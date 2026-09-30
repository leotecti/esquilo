# Evolução E02 — Vidas e Game Over

Implementação: 2026-09-30, versão 0.10.0. Validação do usuário pendente.

## Comportamento

- Tico e Pipo compartilham três vidas iniciais. Os três corações continuam sendo
  a saúde da tentativa atual; receber dano não desconta vida até a saúde chegar a zero.
- Com vidas restantes, a animação de derrota e o retorno ao checkpoint existentes
  são reaproveitados, incluindo recuperação da saúde e invulnerabilidade temporária.
- O medalhão `+1 VIDA` aparece no começo da primeira fase de cada mundo, acima
  da trilha, acessível por salto. Cada medalhão vale uma única coleta por campanha.
  Corações continuam recuperando saúde, sem conceder vidas.
- Ao esgotar as vidas, a tela de Game Over seleciona a primeira fase do mundo
  anterior. No Bosque, permanece no Bosque. As vidas são renovadas para três.
- A tela permite escolher qualquer fase já desbloqueada. Conclusões, recompensas,
  mecanismos, chefes vencidos e Pipo resgatado são preservados. A tentativa começa
  no início da fase escolhida. Mortes seguintes voltam ao checkpoint dessa tentativa.
- Pipo pode ser usado nas primeiras fases após o resgate. Antes do resgate, a troca
  continua bloqueada. O mapa visual será implementado na E06.

## Save e configuração

O slot `tico.campaign.v1` / `user://campaign.json` permanece o mesmo. O bloco
opcional `survival` acrescenta vidas, retorno pendente, destino, tentativa de replay,
desbloqueio global de Pipo e medalhões coletados. Saves anteriores recebem os valores
iniciais e inferem o resgate a partir do progresso. Saves danificados ou de versão
futura continuam protegidos contra substituição automática.

A perda de vida e o Game Over são salvos imediatamente, antes da animação e da
seleção. Reabrir durante o Game Over recupera a tela de retorno. A conclusão
permanente fica separada do estado da tentativa para permitir rejogar fases vencidas.

Em `expedition_campaign.gd`, `initial_lives` configura o valor inicial e
`extra_life_stages` configura as fases com medalhão (índices 0–15; padrão 0, 4, 8, 12).
O limite do contador é 99. Esses valores ainda serão balanceados em playtest.

## Verificação automatizada

- `lives_e02_test.gd`: 47 verificações de coleta por colisão, deduplicação,
  desconto, retorno, reabertura, quatro mundos, desbloqueio de Pipo e save.
- `expedition_save_test.gd`: 73 verificações de regressão da campanha e migração.
- `health_e01_test.gd`: 20 verificações da saúde e recuperação existentes.
- Navegador: derrota real no Rio, Game Over, retorno offline, Pipo no Bosque;
  retorno por toque; corrida dos dois personagens; migração e percurso do Rio;
  Montanha; mecanismos, toque, pausa e rotação da Vila; comporta e save futuro.
- Desempenho da campanha com o novo HUD e medalhão: Windows Compatibility,
  Intel Iris Xe, 1280×720, 301 amostras, mediana 16,77 ms, p95 18,43 ms,
  66 chamadas de desenho no p95. Medição local, sem equivalência garantida ao celular.
  Script: `lives_e02_performance.gd`; relatório em `builds/performance-e02-windows.json`.

## Pacotes e teste manual

- Web: `builds/web/Tico-evolucao-E02-web.zip`.
- Windows: `builds/windows/Tico-evolucao-E02-windows.zip`.
- Publicar o conteúdo do ZIP Web em `/tico/`, conforme [instruções](../web/deployment.md).

1. Confira corações, nozes e vidas no HUD; teste correr, pular, planar e empurrar.
2. Salte para coletar `+1 VIDA`. Reabra o jogo e confirme que a coleta persiste.
3. Ative uma bandeira e perca os três corações: uma vida é descontada e o retorno
   ocorre na bandeira. Troque de personagem e confira o mesmo contador de vidas.
4. Esgote as vidas em um mundo posterior. Confira o mundo anterior selecionado,
   três vidas renovadas e acesso às fases liberadas. Reabra antes de continuar.
5. Continue numa fase antiga e confira Pipo disponível após o resgate.
6. No celular, atualize a PWA, abra uma vez online e repita a retomada offline.

Sem commit, push ou publicação automática.
