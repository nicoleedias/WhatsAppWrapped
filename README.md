# Rebobina — WhatsApp Wrapped

![Plataforma](https://img.shields.io/badge/Plataforma-iOS%2026%2B-000000)
![Linguagem](https://img.shields.io/badge/Swift-SwiftUI-F05138)
![IA](https://img.shields.io/badge/IA-Gemini%20(Firebase%20AI%20Logic)-4285F4)

Uma retrospectiva das suas conversas do WhatsApp, no estilo do Spotify Wrapped. Você exporta uma conversa,
o app calcula as estatísticas no próprio iPhone e transforma tudo em uma sequência de slides animados, com
frases divertidas escritas por IA para cada um.

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/d8173045-4060-4f01-8ccc-2fd0a4b7689e" width="200" height="440" alt="Tela 1"></td>
    <td><img src="https://github.com/user-attachments/assets/76002efa-9023-45aa-a330-7de9d9797471" width="200" height="440" alt="Tela 2"></td>
    <td><img src="https://github.com/user-attachments/assets/db7e2d73-0f7e-4806-8efa-8db8a2154b4f" width="200" height="440" alt="Tela 3"></td>
    <td><img src="https://github.com/user-attachments/assets/53fc8676-86aa-4313-bef3-b7c4424c641b" width="200" height="440" alt="Tela 4"></td>
  </tr>
</table>

## Funcionalidades

- **Importação da conversa:** aceita o `.zip` exportado pelo iPhone e o `.txt` exportado pelo Android,
  escolhido no app ou compartilhado direto do WhatsApp. Um guia mostra como exportar.
- **Retrospectiva em slides:** mensagens, risadas, emojis, palavras mais usadas, tempo de resposta,
  sequência de dias conversando, horário favorito, áudios, fotos, figurinhas, ligações e o maior "textão".
  Em grupos, aparecem também o pódio de quem mais fala e os "fantasmas".
- **Mini game:** um quiz para adivinhar a palavra mais usada da conversa antes de ver o ranking.
- **Frases geradas por IA:** cada slide ganha uma frase curta e bem-humorada que comenta os números da
  conversa, sem repeti-los.
- **Resumo final e compartilhamento:** um card com os destaques, pronto para compartilhar.
- **Minhas retrospectivas:** as retrospectivas ficam salvas no aparelho para rever ou apagar depois.
- **Slides adaptativos:** só aparecem os slides que fazem sentido para aquela conversa (sem ligações, sem
  slide de ligações).

## Como a IA é usada

As frases dos slides vêm do **Gemini**, chamado pelo **Firebase AI Logic**. A integração foi pensada para
que a IA nunca seja um ponto de falha do app:

- **Saída estruturada:** a resposta é pedida em JSON, com um *schema* gerado a partir dos slides daquela
  retrospectiva (um emoji e uma frase de até 90 caracteres por slide). Assim o app não precisa interpretar
  texto livre.
- **Prompt com regras de tom e de segurança:** português do Brasil, humor leve e carinhoso, sem repetir o
  número que o slide já mostra, sem inventar fatos e sem temas sensíveis (saúde, corpo, religião, política,
  sexualidade, dinheiro).
- **Retentativas e troca de modelo:** se o modelo principal estiver sobrecarregado, o app tenta de novo e
  depois passa para um modelo mais leve. Em caso de *timeout* ou cota esgotada (HTTP 429), troca de modelo
  na hora, sem desperdiçar outra tentativa.
- **Limite de tempo:** cada tentativa tem 15 s e o processo inteiro tem 40 s. Passou disso, o app segue sem
  esperar.
- **Frases de reserva:** sem internet, com erro ou com resposta incompleta, o app completa o que faltar com
  frases prontas. A retrospectiva sempre abre.
- **App Check:** as chamadas ao Gemini só são aceitas quando vêm do app de verdade (App Attest na App Store
  e no TestFlight, token de depuração no Xcode). A chave da API fica no Firebase, não no app.

## Privacidade

- O arquivo da conversa é lido e analisado **inteiramente no aparelho**, e a cópia importada é apagada
  depois da leitura.
- **O texto das mensagens nunca é enviado para a IA.** Ela recebe só um resumo das estatísticas já
  calculadas: contagens, nomes dos participantes, emojis e palavras mais usadas.
- As retrospectivas salvas ficam em um arquivo local, protegido enquanto o aparelho está bloqueado.

## Arquitetura

O projeto separa a lógica de negócio da interface, o que deixa o núcleo testável e independente da IA:

```
WhatsAppWrapped/
├── App/              # Entrada do app, coordinator e dados de preview
├── Core/
│   ├── Parsing/      # Leitor de .zip próprio (sem dependências) e parser do formato do WhatsApp
│   ├── Analyzers/    # Um analyzer por estatística (mensagens, emojis, tempo de resposta, sequência…)
│   ├── Models/       # Chat, Message e as estatísticas de cada slide
│   ├── Phrases/      # Prompt, resumo enviado à IA, frases de reserva e o protocolo do gerador
│   └── Services/     # Importação, montagem das estatísticas e armazenamento das retrospectivas
├── Infrastructure/
│   └── Firebase/     # Implementação do gerador com Gemini e App Check
├── DesignSystem/     # Tokens (tipografia, movimento, fundos) e componentes reutilizáveis
└── Features/         # Onboarding, Import, Wrapped (slides), Summary e Retrospectives, em MVVM
```

Alguns pontos de destaque:

- **Fluxo de dados:** `arquivo → ChatImporter → ChatParser → Analyzers → WrappedStats → slides`.
  O parsing e as análises rodam fora da main thread, porque conversas longas passam de dezenas de milhares
  de mensagens.
- **IA atrás de um protocolo:** o `SlidePhraseGenerator` define o que o app precisa, e o
  `GeminiPhraseGenerator` é só uma implementação. Os previews do SwiftUI usam um gerador falso, sem chamar a
  API.
- **Slides desacoplados do player:** cada slide é uma view que declara o próprio rótulo, frase e se pode ser
  compartilhado. O player só lê esses dados, então adicionar um slide novo não mexe no player.

## Tecnologias

- Swift e SwiftUI, com Swift Concurrency (`async/await`, `TaskGroup`)
- MVVM com Coordinator
- Firebase AI Logic (Gemini), Firebase App Check (App Attest)
- Framework `Compression` para ler o `.zip` sem bibliotecas externas
- Swift Package Manager


> Projeto independente, sem nenhuma relação com o WhatsApp ou a Meta.
