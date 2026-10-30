//
//  ZipReader.swift
//  WhatsAppWrapped
//
//  Extrai arquivos de um .zip sem biblioteca externa (para tirar o _chat.txt do .zip do iPhone).
//

import Compression
import Foundation

/// Lê arquivos de dentro de um .zip. O iPhone exporta a conversa como "WhatsApp Chat - Nome.zip" com o `_chat.txt` dentro.
/// Suporta os formatos que o WhatsApp usa: sem compressão e deflate.
nonisolated enum ZipReader {
    enum ZipError: Error, Equatable {
        case invalidArchive
        case unsupportedCompression
        case corruptedEntry
    }

    struct Entry {
        let name: String
        let compressionMethod: UInt16
        let compressedSize: Int
        let uncompressedSize: Int
        let localHeaderOffset: Int
    }

    /// Arquivos dentro do zip, lidos do diretório central (que fica no fim do arquivo).
    static func entries(in data: Data) throws -> [Entry] {
        let bytes = [UInt8](data)
        guard let end = endOfCentralDirectory(in: bytes) else { throw ZipError.invalidArchive }

        let count = Int(bytes.uint16(at: end + 10))
        var offset = Int(bytes.uint32(at: end + 16))
        var entries: [Entry] = []
        for _ in 0..<count {
            guard offset + 46 <= bytes.count, bytes.uint32(at: offset) == 0x0201_4B50 else { throw ZipError.invalidArchive }
            let nameLength = Int(bytes.uint16(at: offset + 28))
            let extraLength = Int(bytes.uint16(at: offset + 30))
            let commentLength = Int(bytes.uint16(at: offset + 32))
            guard offset + 46 + nameLength <= bytes.count else { throw ZipError.invalidArchive }

            entries.append(Entry(
                name: String(decoding: bytes[(offset + 46)..<(offset + 46 + nameLength)], as: UTF8.self),
                compressionMethod: bytes.uint16(at: offset + 10),
                compressedSize: Int(bytes.uint32(at: offset + 20)),
                uncompressedSize: Int(bytes.uint32(at: offset + 24)),
                localHeaderOffset: Int(bytes.uint32(at: offset + 42))
            ))
            offset += 46 + nameLength + extraLength + commentLength
        }
        return entries
    }

    static func contents(of entry: Entry, in data: Data) throws -> Data {
        let bytes = [UInt8](data)
        let header = entry.localHeaderOffset
        guard header + 30 <= bytes.count, bytes.uint32(at: header) == 0x0403_4B50 else { throw ZipError.corruptedEntry }

        let start = header + 30 + Int(bytes.uint16(at: header + 26)) + Int(bytes.uint16(at: header + 28))
        guard start + entry.compressedSize <= bytes.count else { throw ZipError.corruptedEntry }
        let compressed = Data(bytes[start..<(start + entry.compressedSize)])

        switch entry.compressionMethod {
        case 0:
            return compressed
        case 8:
            return try inflate(compressed, expectedSize: entry.uncompressedSize)
        default:
            throw ZipError.unsupportedCompression
        }
    }

    /// Deflate "cru", que é o que `COMPRESSION_ZLIB` da Apple espera.
    private static func inflate(_ data: Data, expectedSize: Int) throws -> Data {
        guard expectedSize > 0 else { return Data() }
        var output = Data(count: expectedSize)
        let written = output.withUnsafeMutableBytes { outputBuffer in
            data.withUnsafeBytes { inputBuffer in
                compression_decode_buffer(
                    outputBuffer.bindMemory(to: UInt8.self).baseAddress!, expectedSize,
                    inputBuffer.bindMemory(to: UInt8.self).baseAddress!, data.count,
                    nil, COMPRESSION_ZLIB
                )
            }
        }
        guard written == expectedSize else { throw ZipError.corruptedEntry }
        return output
    }

    /// O registro final fica nos últimos 22 bytes, mais um comentário opcional de até 64 KB.
    private static func endOfCentralDirectory(in bytes: [UInt8]) -> Int? {
        guard bytes.count >= 22 else { return nil }
        let lowest = max(0, bytes.count - 22 - 0xFFFF)
        return stride(from: bytes.count - 22, through: lowest, by: -1).first { bytes.uint32(at: $0) == 0x0605_4B50 }
    }
}

nonisolated private extension [UInt8] {
    func uint16(at offset: Int) -> UInt16 {
        UInt16(self[offset]) | UInt16(self[offset + 1]) << 8
    }

    func uint32(at offset: Int) -> UInt32 {
        UInt32(uint16(at: offset)) | UInt32(uint16(at: offset + 2)) << 16
    }
}
