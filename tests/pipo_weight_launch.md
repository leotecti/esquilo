# Plataformas de peso e impulso — 0.36.4

O Mundo 2 passa a usar o peso de Pipo durante a navegação, além de pedras e
portas. Cada uma das três fases de percurso possui uma plataforma larga que:

- afunda gradualmente quando Pipo permanece sobre ela;
- mostra o progresso de ativação;
- trava o mecanismo depois de 0,38 segundo;
- torna-se necessária para concluir a respectiva fase.

## Impulso em dupla

A fase 2-1 introduz um marco de folhas com seta ascendente. Perto dele, o botão
`AÇÃO` deixa de iniciar a investida e prepara o lançamento:

1. Pipo assume a pose de preparação;
2. o jogo confirma `Impulso em dupla!`;
3. depois de 0,24 segundo, o controle passa automaticamente para Tico;
4. Tico recebe impulso vertical e pode planar até uma plataforma de recompensas.

O sistema mantém apenas um personagem físico ativo, preservando câmera,
desempenho, vida compartilhada e regras de troca. Saves anteriores recebem os
novos mecanismos automaticamente; fases já concluídas permanecem concluídas.
