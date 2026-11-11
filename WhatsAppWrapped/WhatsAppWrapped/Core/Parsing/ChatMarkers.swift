//
//  ChatMarkers.swift
//  WhatsAppWrapped
//
//  Textos fixos que o WhatsApp escreve (mídia oculta, ligação perdida, avisos…) em português e inglês.
//

import Foundation

/// Textos fixos que o WhatsApp escreve no lugar de mídias, chamadas e avisos.
/// O idioma segue o do aparelho de quem exportou, por isso há português e inglês.
/// Todos em minúsculas e sem caracteres invisíveis.
nonisolated enum ChatMarkers {
    static let invisibleCharacters: Set<Character> = ["\u{200E}", "\u{200F}", "\u{202A}", "\u{202C}", "\u{FEFF}"]
    static let leftToRightMark: Character = "\u{200E}"

    static let editedMarkers = ["<this message was edited>", "<esta mensagem foi editada>"]

    /// Mensagens apagadas por quem exportou a conversa.
    static let deletedByExporter: Set<String> = ["you deleted this message", "você apagou esta mensagem"]

    static let deleted: Set<String> = [
        "this message was deleted", "you deleted this message",
        "esta mensagem foi apagada", "você apagou esta mensagem", "mensagem apagada",
    ]

    /// Mídia sem o arquivo: "imagem oculta", "imagem ocultada", "áudio omitido", "<Mídia oculta>"…
    /// O texto muda com a versão do WhatsApp, então vale qualquer combinação de tipo + palavra de oculto.
    static func mediaType(forPlaceholder text: String) -> MediaType? {
        let trimmed = text.trimmingCharacters(in: CharacterSet(charactersIn: "<>").union(.whitespaces))
        guard let last = trimmed.split(separator: " ").last, mediaHiddenWords.contains(String(last)) else { return nil }
        let noun = trimmed.dropLast(last.count).trimmingCharacters(in: .whitespaces)
        return mediaNouns[noun]
    }

    /// Mídia exportada junto com a conversa: "<anexado: 00000012-PHOTO-2026-03-14-21-03-12.jpg>".
    static func mediaType(forAttachment text: String) -> MediaType? {
        guard text.hasPrefix("<"), text.hasSuffix(">"),
              let colon = text.firstIndex(of: ":"),
              attachmentPrefixes.contains(String(text[text.index(after: text.startIndex)..<colon])) else { return nil }
        let file = text[text.index(after: colon)...].dropLast().trimmingCharacters(in: .whitespaces).lowercased()
        if file.contains("-photo-") { return .image }
        if file.contains("-audio-") || file.hasSuffix(".opus") { return .audio }
        if file.contains("-video-") { return .video }
        if file.contains("-sticker-") || file.hasSuffix(".webp") { return .sticker }
        if file.contains("-gif-") { return .gif }
        if file.hasSuffix(".vcf") { return .contact }
        return .document
    }

    /// Última palavra dos textos de mídia oculta. Também ficam fora das palavras mais usadas.
    static let mediaHiddenWords: Set<String> = [
        "omitted", "omitida", "omitido", "oculta", "ocultada", "oculto", "ocultado",
    ]

    private static let mediaNouns: [String: MediaType] = [
        "audio": .audio, "áudio": .audio,
        "image": .image, "imagem": .image, "photo": .image, "foto": .image,
        "video": .video, "vídeo": .video,
        "sticker": .sticker, "figurinha": .sticker,
        "gif": .gif,
        "contact card": .contact, "cartão de contato": .contact, "contato": .contact,
        "media": .unknown, "mídia": .unknown, "arquivo de mídia": .unknown,
    ]

    private static let attachmentPrefixes: Set<String> = ["attached", "anexado", "anexo"]

    /// Documentos vêm como "relatorio.pdf • 3 páginas ‎documento omitido".
    static let documentSuffixes = [
        "document omitted", "documento omitido", "documento ocultado", "documento oculto",
    ]
    static let locationPrefixes = ["location: ", "localização: ", "localização em tempo real"]

    static let callPrefixes = [
        "voice call", "video call", "missed voice call", "missed video call", "call failed",
        "chamada de voz", "chamada de vídeo", "chamada de voz perdida", "chamada de vídeo perdida",
        "ligação de voz", "ligação de vídeo", "a chamada falhou",
    ]

    static let videoCallFragments = ["video", "vídeo"]
    static let missedCallFragments = [
        "missed", "no answer", "call failed",
        "perdida", "não atendida", "sem resposta", "falhou",
    ]
    /// "12 min", "45 sec", "1 hr 5 min", "30 s".
    static let callDurationPattern = #"(\d+)\s*(sec|secs|seg|s|min|mins|hr|hrs|h|hora|horas)\b"#

    /// Avisos que o iPhone grava com o nome de alguém (ou do grupo) como autor.
    static let systemFragments = [
        "end-to-end encrypted", "criptografia de ponta a ponta",
        "disappearing messages", "mensagens temporárias",
        "security code", "código de segurança",
        "changed their phone number", "mudou o número",
        "changed the group", "changed this group", "mudou o nome do grupo", "mudou a imagem",
        "mudou a descrição", "mudou o ícone", "alterou",
        "created group", "criou o grupo", "criou este grupo",
        "joined using", "entrou usando",
        " added ", " adicionou ", " removed ", " removeu ",
        " left", " saiu",
        "pinned a message", "fixou uma mensagem",
        "is a contact", "é um contato",
    ]

    /// Entradas e saídas de participantes. O grupo 1 é quem fez a ação, o grupo 2 quem sofreu.
    static let joinPatterns = [
        #"^(.+?) (?:added|adicionou) (.+)$"#,
        #"^()(.+?) (?:joined using|entrou usando).*$"#,
        #"^()(.+?) (?:was added|foi adicionad[oa]).*$"#,
    ]
    static let leavePatterns = [
        #"^(.+?) (?:removed|removeu) (.+)$"#,
        #"^()(.+?) (?:left|saiu)\.?$"#,
    ]

    static let stopwords: Set<String> = [
        // português
        "que", "não", "nao", "uma", "uns", "umas", "para", "pra", "pro", "pros", "pras", "com", "por",
        "mas", "mais", "isso", "isto", "esse", "essa", "esses", "essas", "este", "esta", "estes", "estas",
        "ele", "ela", "eles", "elas", "você", "voce", "vocês", "voces", "vcs", "nós", "nos", "meu", "minha",
        "meus", "minhas", "seu", "sua", "seus", "suas", "dele", "dela", "deles", "delas", "nosso", "nossa",
        "tá", "tah", "tô", "toh", "aqui", "ali", "lá", "então", "entao", "ent", "aí", "só", "tbm", "tb",
        "também", "tambem", "foi", "ser", "ter", "tem", "têm", "tinha", "vai", "vou", "vão", "vamos",
        "já", "quando", "como", "onde", "quem", "qual", "quais", "porque", "pq", "porquê", "muito", "muita",
        "muitos", "muitas", "bem", "sim", "gente", "tudo", "nada", "agora", "hoje", "dia", "dias", "ainda",
        "depois", "antes", "sem", "até", "ate", "mesmo", "mesma", "assim", "pode", "posso", "estou", "está",
        "estava", "estão", "era", "são", "sou", "fica", "ficar", "fazer", "faz", "fez", "vez",
        "acho", "sei", "sabe", "vem", "ver", "olha", "das", "dos", "nas", "num", "numa", "pela",
        "pelo", "pelas", "pelos", "sobre", "entre", "cada", "outro", "outra", "outros", "outras", "todo",
        "toda", "todos", "todas", "algum", "alguma", "nenhum", "nenhuma", "lhe", "mim", "comigo",
        "contigo", "tipo", "coisa", "coisas", "ok", "okay", "blz", "beleza", "obrigado", "obrigada",
        "vdd", "verdade", "né", "nee", "hein", "aham", "uhum", "hum", "hmm", "ahh", "ahn", "eita", "oi",
        "ola", "olá", "tchau", "msg", "mensagem", "foto", "video", "vídeo", "audio", "áudio",
        "lah", "tava", "tavam", "teve", "tive", "voc", "nem", "quer", "quero",
        // inglês
        "the", "and", "you", "for", "that", "this", "with", "are", "was", "but", "not", "have", "just",
    ]
}
