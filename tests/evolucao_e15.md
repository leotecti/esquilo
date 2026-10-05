# Evolução E15 — backtracking controlado (0.24.0)

A E15 recompensa a revisita às fases iniciais depois do resgate de Pipo. O
conteúdo novo é opcional e não altera a primeira passagem nem bloqueia a chegada.

## Segredos de revisita

- **1-1 — Primeiros Passos:** plataforma opcional no trecho intermediário.
- **1-2 — Blocos e Segredos:** segundo trecho curto para reforçar a descoberta.
- Os trechos existem somente quando Pipo foi desbloqueado globalmente e a fase
  concluída é iniciada novamente pelo mapa.
- Pipo empurra uma pedra até a marca dourada e abre uma grade.
- A passagem possui 64 unidades de altura: Tico atravessa; Pipo permanece fora.
- Tico encontra uma Noz Dourada com ID permanente próprio em cada fase.
- O caminho principal passa abaixo da plataforma e continua utilizável mesmo se
  o jogador ignorar o puzzle.

## Persistência

Os eventos `backtrack_cache_0_open` e `backtrack_cache_1_open` registram as
grades abertas em `story.events`. As recompensas `retorno_01` e `retorno_02`
usam o registro existente de Nozes Douradas por fase. Assim, mecanismo,
recompensa e desbloqueio global de Pipo sobrevivem a morte, Game Over, troca de
fase e reabertura. O formato do save permanece V2 e aceita campanhas anteriores.

## Validação automatizada

- `backtracking_e15_test.gd`: 13 verificações de bloqueio antes do resgate,
  disponibilidade na revisita, empurrão, passagem por tamanho, recompensa,
  persistência, segunda fase e conclusão opcional.
- `pipo_e13_test.gd`: 15 verificações da apresentação e do desbloqueio global.
- `tail_e14_test.gd`: 15 verificações das habilidades distintas da dupla.
- `progress_e05_test.gd`: 79 verificações do Save V2 e migrações.

## Playtest no aparelho

1. Use um save que já resgatou Pipo e concluiu as fases 1-1 e 1-2.
2. No mapa, entre novamente em **Primeiros Passos**.
3. No trecho intermediário, suba à plataforma marcada e troque para Pipo.
4. Empurre a pedra até a marca e confirme a abertura da grade.
5. Troque para Tico, atravesse a passagem e pegue a Noz Dourada.
6. Saia e reabra a fase; confira a grade aberta e o tesouro registrado no mapa.
7. Repita em **Blocos e Segredos** e teste também concluir sem explorar o trecho.
8. Feche e reabra a PWA, inclusive offline.

Pacotes: `builds/web/Tico-evolucao-E15-web.zip` e
`builds/windows/Tico-evolucao-E15-windows.zip`. Sem commit ou publicação automática.
