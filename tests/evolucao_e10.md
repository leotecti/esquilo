# Evolução E10 — Estrutura narrativa (0.19.0)

A E10 acrescenta infraestrutura reutilizável para narrativa e preserva o
gameplay, os mapas, as recompensas e o Save V2 existentes. O conteúdo da
abertura e os encontros com a Coruja permanecem para E11 e E12.

## Estrutura implementada

As sequências são listas de passos passadas a `play_narrative(id, steps)`. O
diretor aceita:

- `scene`: título e cor de ambiente da cena;
- `dialogue`: personagem, retrato e fala curta;
- `transition`: transição visual com duração configurável;
- `animation`: sinal com personagem e animação para a cena conectar ao ator;
- `event`: registro permanente de uma descoberta ou mudança da história.

Ao iniciar, o sistema libera comandos mantidos, suspende o gameplay e oculta o
HUD. Ao concluir ou pular, restaura o estado anterior. O ID da sequência fica em
`story.events`, por isso ela não repete automaticamente. Uma chamada com
`replay = true` permite rever a cena quando uma interface futura oferecer isso.

Exemplo de conteúdo para as próximas etapas:

```gdscript
campaign.play_narrative("opening_clue", [
    {"type":"scene", "title":"Bosque das Folhas"},
    {"type":"dialogue", "speaker":"Tico", "portrait":"tico",
        "text":"Minhas nozes sumiram!"},
    {"type":"animation", "actor":"tico", "animation":"look_around"},
    {"type":"event", "id":"first_tracks_found"},
    {"type":"transition"}
])
```

## Save, PWA e desempenho

O formato do save não mudou: a E10 usa `story.events`, criado na E05. Saves V2
anteriores continuam válidos e recebem os novos eventos somente ao assistir ou
pular uma sequência. A interface é construída com controles da Godot, funciona
sem rede e não adiciona imagens ou bibliotecas ao download. Ela só processa
enquanto uma cena está ativa.

## Validação automática

`narrative_e10_test.gd` passou com 14 verificações:

- execução de sequência baseada em dados;
- cena, retrato e diálogo;
- suspensão e restauração do gameplay;
- sinal de animação e transição;
- registro de evento e conclusão;
- proteção contra repetição e reprodução explícita;
- encerramento ao pular;
- persistência após fechar e reabrir;
- validade do Save V2.

A regressão de progresso e migração passou com 79 verificações. A exportação
Web E10 também repetiu com sucesso o cenário de coleta, save e reabertura
offline da E09. As exportações release Web/PWA e Windows foram concluídas.

## Roteiro para o celular

A E10 não inicia cenas de história na campanha atual, pois a primeira sequência
real será a abertura da E11. Nesta entrega, confirme que o jogo existente abre,
o mapa responde, Primeiros Passos funciona, o save continua após reabrir e a PWA
abre offline. A validação visual dos diálogos acontecerá junto com a primeira
cena completa.

Pacotes: `builds/web/Tico-evolucao-E10-web.zip` e
`builds/windows/Tico-evolucao-E10-windows.zip`. Sem commit ou publicação automática.
