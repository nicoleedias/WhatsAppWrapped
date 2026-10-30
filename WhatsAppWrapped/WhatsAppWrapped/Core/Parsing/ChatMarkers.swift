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

    static let media: [String: MediaType] = [
        "audio omitted": .audio, "áudio ocultado": .audio, "áudio omitido": .audio,
        "image omitted": .image, "imagem ocultada": .image, "imagem omitida": .image,
        "video omitted": .video, "vídeo omitido": .video, "vídeo ocultado": .video,
        "sticker omitted": .sticker, "figurinha omitida": .sticker, "figurinha ocultada": .sticker,
        "gif omitted": .gif, "gif omitido": .gif, "gif ocultado": .gif,
        "contact card omitted": .contact, "cartão de contato omitido": .contact,
        "<media omitted>": .unknown, "<mídia oculta>": .unknown, "<arquivo de mídia oculto>": .unknown,
    ]

    /// Documentos vêm como "relatorio.pdf • 3 páginas ‎documento omitido".
    static let documentSuffixes = ["document omitted", "documento omitido", "documento ocultado"]
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
