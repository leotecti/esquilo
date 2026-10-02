# Evolução E12 — Valda e progressão da história (0.21.0)

A E12 conecta os quatro mundos por encontros narrativos após os confrontos
decisivos. Valda orienta e contextualiza; Tico e Pipo continuam responsáveis
por investigar e resolver os problemas.

## Encontros

| Etapa | Resultado | Orientação de Valda |
|---|---|---|
| 1-Guardião | Bosque pacificado | Seguir as marcas até o Rio das Pedras |
| 2-Guardião | Correnteza segura | Seguir as penas até a montanha e compreender a agitação do Gavião |
| 3-Guardião | Gavião acalmado | Investigar os carregamentos que descem para a Vila dos Castores |
| 4-Guardião | Alimentos recuperados | Reconhecer a união do bosque e encerrar o arco atual |

Cada encontro alterna relato de Tico, orientação de Valda, pista e resposta do
herói. Depois da conversa, o mapa abre com o próximo destino selecionado.

## Identidade da montanha

- Valda permanece exclusivamente mentora e aliada.
- A antiga chefe coruja foi convertida no **Gavião da Montanha**.
- Avisos, fala final, cores, bico e expressão do chefe foram atualizados.
- O nome regional `Montanha das Corujas` permanece como local da campanha.

## Save e repetição

- Os eventos `valda_after_3`, `valda_after_7`, `valda_after_11` e
  `valda_after_15` são persistidos no Save V2.
- Cada encontro aparece somente na primeira conclusão correspondente.
- Revisitas seguem diretamente ao mapa depois que o encontro já foi visto.
- Pular a conversa também registra sua conclusão e mantém o desbloqueio.

## Validação

- `valda_e12_test.gd`: 24 verificações dos quatro encontros, save, mapa e repetição.
- Regressão de abertura, campanha e Save V2 permanece obrigatória.
- Navegador valida o encontro após o Bosque, persistência e reabertura offline.

## Tela cheia

- Windows inicia diretamente em tela cheia.
- O navegador solicita tela cheia no clique ou toque em `Jogar`.
- A PWA instalada usa o modo `fullscreen` e orientação horizontal.
- Os botões flutuantes `Tela cheia` e `Sair da tela cheia` foram removidos.
- Navegadores que não oferecem a API continuam abrindo o jogo na maior área disponível.

Pacotes: `builds/web/Tico-evolucao-E12-web.zip` e
`builds/windows/Tico-evolucao-E12-windows.zip`. Sem commit ou publicação automática.
