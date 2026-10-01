# Evolução E04 — Interface e tutorial contextual

Implementação: 2026-09-30, versão 0.12.0. Playtest do usuário pendente.

## Entrega

- HUD compacto com corações, nozes, vidas, retrato, troca de personagem e pausa.
- Nome da fase, indicador de save, **Reiniciar fase** e **Nova aventura** no menu de pausa.
- Remoção dos textos permanentes de estado e das placas de instrução no cenário.
  O conteúdo das placas foi aproveitado em dicas temporárias de proximidade.
- Uma dica por vez, curta, sem pausar o jogo e sem capturar mouse ou toque.
  Os comandos de salto indicam Espaço ou PULO conforme o dispositivo.
- Feedbacks de coleta, dano, mecanismos e avisos de chefes continuam aparecendo
  temporariamente; as regras e os controles das etapas anteriores foram mantidos.

## Quando cada dica aparece

| Registro | Contexto | Quando encerra |
| --- | --- | --- |
| `tutorial_enemy_seen` | Inimigo comum próximo; texto específico para espinhos | Inimigo derrotado, ultrapassado, afastamento ou tempo |
| `tutorial_heart_seen` | Coração próximo e personagem com saúde incompleta | Coleta, afastamento ou tempo |
| `tutorial_life_seen` | Medalhão de vida extra próximo | Coleta, afastamento ou tempo |
| `tutorial_glide_seen` | Tico caindo com espaço abaixo para planar | Planagem, aterrissagem, troca ou tempo |
| `tutorial_secret_seen` | Segredo próximo ainda oculto, com Pipo já liberado | Revelação, aproximação com Pipo, afastamento ou tempo |

As dicas principais duram até cinco segundos de jogo. Dicas de percurso duram
até quatro segundos; mensagens de feedback, até 3,5 segundos. A pausa oculta
a dica e suspende seu tempo. Derrota e conclusão encerram a dica. Há um intervalo
entre dicas para evitar uma sequência contínua de mensagens.

O tutorial de movimento aparece no início de uma nova aventura. As dicas das
placas têm identificação por fase e posição, para não repetirem em replays.
As cenas históricas abertas separadamente mantêm sua interface anterior; a
interface E04 é aplicada à campanha de `scenes/main.tscn`.

## Save

O slot permanece `campaign.json` / `tico.campaign.v1`. Dois campos opcionais
foram acrescentados sem substituir o progresso:

- `tutorials`: os cinco indicadores booleanos acima.
- `context_hints_seen`: identificadores das dicas de movimento e percurso já vistas.

Saves anteriores recebem valores iniciais. Mostrar uma dica salva seu registro;
reiniciar a fase, perder vidas, entrar em Game Over e reabrir offline preservam
esse registro. **Nova aventura** reinicia os tutoriais junto com a campanha.
Flags inválidas e listas duplicadas são rejeitadas. Saves danificados ou de
versão futura continuam protegidos contra substituição automática.

## Validação

| Script | Verificações aprovadas |
| --- | ---: |
| `tutorial_e04_test.gd` | 26 |
| `checkpoints_e03_test.gd` | 133 |
| `expedition_save_test.gd` | 73 |
| **Total Godot** | **232** |

Os testes verificam os cinco contextos, prioridade de dicas, interação, expiração,
pausa, HUD sem sobreposição, migração, reinício, Game Over, nova aventura e
validação do save. Os testes de campanha e retorno mantêm a cobertura das 16 fases.

Doze cenários Web cobrem dicas em desktop e toque, persistência offline, HUD,
checkpoints, reinício, Game Over, corrida, mundos, mecanismos, rotação e save futuro.
Após ajustar o posicionamento dos controles no HUD, os cinco cenários relacionados
à interface foram repetidos. Capturas em `builds/web/e04-*.png`; logs em
`builds/e04-browser.log` e `builds/e04-browser-final.log`.

Desempenho: `tests/tutorial_e04_performance.gd`, com HUD e dica, HUD sem dica e
menu de pausa. Relatório em `builds/performance-e04-windows.json`. A medição local
não substitui o teste no celular.

Medição em Intel Iris Xe, Windows Compatibility, 1280×720, 181 amostras por cenário:

| Cenário | Mediana | p95 | Chamadas de desenho p95 |
| --- | ---: | ---: | ---: |
| HUD e dica | 16,64 ms | 17,78 ms | 58 |
| HUD sem dica | 16,68 ms | 17,87 ms | 57 |
| Menu de pausa | 16,67 ms | 17,30 ms | 71 |

## Pacotes

### Correções visuais — 0.12.1

- Painel de dicas com altura calculada explicitamente e limite de duas linhas,
  corrigindo o retângulo que cobria a fase do ninho.
- Planagem contínua nas correntes ascendentes, sem alternância entre salto e
  planagem a cada quadro. Pose maior e oscilação suave, reaproveitando o atlas.
- Vida extra com retrato do Tico e selo `+1`, mantendo coleta e recompensa.
- 17 verificações de regressão visual/comportamental e 20 de saúde passaram.
  Quatro cenários de navegador passaram: desktop/offline, ninho, toque e Montanha.
- Nova medição em Intel Iris Xe, 1280×720: p95 de 18,12 ms com dica,
  18,41 ms sem dica e 17,20 ms na pausa; 181 amostras por cenário.
- Conferir os três ajustes no celular após publicar o pacote atualizado.

- Web/PWA: `builds/web/Tico-evolucao-E04-web.zip`.
- Windows: `builds/windows/Tico-evolucao-E04-windows.zip`.
- Pastas: `builds/web/evolucao_e04/` e `builds/windows/evolucao_e04/`.
- [Publicação](../web/deployment.md) e [ambiente de desenvolvimento](../DESENVOLVIMENTO.md).

## Roteiro para o usuário

1. Atualize a PWA sem limpar os dados do site. Confira os contadores e os botões
   de pausa e troca, sem sobreposição no celular.
2. No início do Bosque, aproxime-se do medalhão e do primeiro inimigo. Confira
   que a dica é curta e que o movimento e o salto continuam funcionando.
3. Com saúde incompleta, aproxime-se de um coração. Colete e confira o encerramento
   da dica. Teste também planar com Tico e procurar um segredo com Pipo.
4. Pause durante uma dica. Confira o nome da fase e o indicador de save no menu.
   Retome e teste **Reiniciar fase**, mantendo os comportamentos da E03.
5. Reabra o jogo, inclusive offline: as dicas vistas não devem se repetir.
6. Teste corrida, empurrão, investida, checkpoints e Game Over. Os controles e
   regras existentes devem permanecer como antes.

Para rever todos os tutoriais, use uma campanha de teste em outro perfil de
navegador ou confirme **Nova aventura**, que substitui o progresso dessa campanha.

Sem commit, push ou publicação automática.
