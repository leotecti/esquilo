# Etapa 8 — Mundo 1: Bosque das Folhas

Data: 2026-09-30. Implementação autorizada pelo usuário; sem commit ou push.

## Conteúdo entregue

| Trecho | Conteúdo | Nozes |
| --- | --- | --- |
| 1-1 — Primeiros Passos | Movimento, salto, planar, plataformas, lesmas, bandeira e chegada | 10 |
| 1-2 — Blocos e Segredos | Blocos comum/quebrável/de noz, caminho opcional, segredo, ouriço e plataformas | 14 |
| 1-3 — Um Novo Amigo | Resgate de Pipo, diálogo, troca, pedra, túnel, investida, faro e subida final | 13 |
| Final de 1-3 — Guardião do Bosque | Bandeira, raízes anunciadas, abertura para salto/investida, três acertos e conclusão amigável | 4 |

O encontro final usa uma cena própria, como continuação da fase 1-3.
O Guardião foi mantido no escopo previsto pelo roadmap. Seu ataque avisa por
1,2 s, dura 0,45 s e abre uma janela de 3,2 s. Não há contagem regressiva para
terminar o mundo. O jogador pode esperar longe das raízes e tentar de novo.

Tico joga sozinho até quebrar, por baixo, o bloco que segura os cipós de Pipo.
O resgate remove a armadilha, libera a passagem e apresenta Trocar. O diálogo
explica que a comida da família de Pipo também foi roubada.

As escadas introdutórias têm degraus contíguos: errar um salto não deixa Tico
preso diante de um degrau alto que exige voltar. Nozes e sinais curtos orientam
o percurso. O ouriço tem espinhos visíveis e deve ser evitado com um salto.

## Arquitetura e save

- `scenes/main.tscn` inicia `world_campaign.gd`, que carrega cada fase.
- As quatro cenas `world_1_*.tscn` usam `world_level.gd`, reaproveitando os
  controladores, a apresentação e as mecânicas já testadas do vertical slice.
- `world_save.gd` valida progresso, fases desbloqueadas e estados de cada cena.
- Slot nativo: `user://world1.json`; Web: `tico.world1.v1`. Versão: 1.
- O slot anterior (`progress.json` / `tico.progress.v1`) permanece intacto.
  Apenas preferências de áudio são copiadas ao iniciar a campanha pela primeira vez.
- A retomada ocorre no início da fase ou na bandeira, com três corações.
  Nozes, blocos, resgate, puzzles, personagem e conclusão permanecem salvos.
- O encontro do Guardião reinicia com três pontos após derrota ou reabertura
  antes da vitória. Depois de acalmado, esse resultado fica salvo.
- Recomeçar pede confirmação e reinicia o mundo, preservando opções de áudio.
- Save danificado/futuro não é sobrescrito automaticamente. Falha de armazenamento
  aparece no HUD; o jogo continua disponível sem persistência.

## Validação automatizada

- `world_test.gd`: 41 verificações, incluindo travessias por comandos, resgate,
  transições, investidas reais no Guardião, fechamento/reabertura e reinício.
- `world_rules_test.gd`: 10 verificações de dano, raízes, salto sobre o Guardião,
  proteção contra acerto duplicado, retorno à bandeira e comportamento do ouriço.
- Regressão: `prototype_test.gd` (32), `slice_test.gd` (23),
  `push_animation_test.gd` (15) e `coop_test.gd` (54).
- Total na Godot: **175 verificações aprovadas**.
- Navegador: `tests/browser/world.spec.js` cobre campanha inteira por teclado,
  conclusão offline, multitoque, rotação, áudio, confirmação de reinício,
  proteção de save futuro, resgate e animações de empurrar no toque.
- **Quatro cenários Web aprovados** na versão final: os três cenários de toque/save
  e a repetição da campanha inteira após ajustar o posicionamento do teste no resgate.
  O encontro verifica também que Pipo consegue recuar após acertar sem dano de contato.
- Windows: exportação e execução gráfica aprovadas, sem erros no log gráfico.
  A saída forçada em modo headless indicou duas referências WAV no encerramento;
  isso não ocorreu na execução gráfica nem nos testes que liberam a cena antes de sair.
- ZIPs conferidos: Web inclui `.htaccess`, HTML, JS, WASM, PCK, manifesto,
  service worker, capa e ícones; Windows inclui executável e PCK.

Comandos:

```powershell
$engine = 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_win64_console.exe'
& $engine --headless --path . --script tests/world_test.gd --fixed-fps 60
& $engine --headless --path . --script tests/world_rules_test.gd --fixed-fps 60
npm.cmd run build:web
npm.cmd run test:web
```

Os testes de navegador históricos estão preservados para o build da etapa 7;
o Playwright seleciona a suíte atual por padrão. O diagnóstico `?test=1` é
somente leitura e não permite comandar personagens ou alterar o mundo.

## Desempenho local

Amostra Windows/Compatibility, Intel Iris Xe, 1280 × 720: 181 quadros por cena
após aquecimento, com partículas. Medianas entre **16,60 e 16,72 ms**;
percentil 95 entre **17,89 e 18,22 ms**. São amostras locais, não garantia de
60 FPS em outros aparelhos. Não houve medição em Android físico nesta entrega.

Relatório: `builds/performance-stage8-windows.json`.
Reprodução: executar `tests/world_performance.gd` com renderização habilitada.

## Pacotes

- Web/PWA: `builds/web/Tico-etapa-8-web.zip`.
- Windows: `builds/windows/Tico-etapa-8-windows.zip`.
- Destino de publicação manual: `https://projetosdoleo.com/tico/` (HostGator).
- Os pacotes anteriores foram preservados.

## Aceite no aparelho do usuário

**Aprovado em 2026-09-30.** Retorno do usuário: “etapa 8 testada e aprovada.
Ficou muito bom.” O marco 6 — Mundo 1 Completo está aprovado.
Os itens específicos abaixo permanecem como roteiro: a confirmação geral não
informa quais verificações foram feitas individualmente nem medições de desempenho.

- [ ] Publicar o pacote e conferir que começa em 1-1, mantendo as opções de áudio.
- [ ] Jogar as três fases por toque; avaliar sinais, saltos, dificuldade e diversão.
- [ ] Resgatar Pipo e testar troca, esforço de Tico e passadas de Pipo na pedra.
- [ ] Descobrir o segredo de 1-2 e o segredo encontrado pelo faro em 1-3.
- [ ] Ajudar o Guardião com salto e investida; conferir leitura do aviso das raízes.
- [ ] Fechar e reabrir em fases diferentes, após bandeiras e depois da conclusão.
- [ ] Reabrir pelo ícone sem conexão e continuar a campanha.
- [ ] Jogar ao menos dez minutos; registrar aparelho, fluidez, áudio e aquecimento.
- [x] Aprovar **marco 6 — Mundo 1 Completo** antes de produzir os próximos mundos.

A aprovação geral acima foi fornecida pelo usuário após testar a etapa.
Modelo do aparelho, FPS e resultados individuais do roteiro não foram informados.
