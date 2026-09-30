# Evolução E01 — Saúde, dano e morte

## Escopo

Revisão do sistema existente, preservando três corações, dano de um coração,
invulnerabilidade de 1,5 s, recuo, feedback, saúde compartilhada e retorno ao
checkpoint com saúde cheia. Movimento, salto, planagem e habilidades mantidos.
Vidas limitadas e Game Over pertencem à E02.

## Correções

- **Coração em contato contínuo:** antes, a coleta dependia exclusivamente de
  entrar na área. Se o jogador chegasse com saúde cheia e recebesse dano sem
  sair, o coração permanecia sem uso. O item de cura agora reavalia os corpos
  que continuam em contato, usando as mesmas verificações de colisão e coleta.
  Permanece disponível com saúde cheia e é consumido apenas uma vez.
- **Recuperação inválida:** `recover()` rejeita valores zero/negativos e
  personagens com controles desativados, além de continuar rejeitando saúde
  cheia e derrota. Evita que uma chamada de recuperação diminua a saúde ou
  modifique um personagem inativo. Recuperação positiva respeita o máximo.

Arquivos de gameplay alterados: `scripts/characters/tico.gd` e
`scripts/objects/nut.gd`. Não houve reescrita do controlador nem do retorno.
O HUD e a apresentação de dano/derrota existentes foram mantidos.

## Verificações na Godot

| Suíte | Verificações aprovadas |
| --- | ---: |
| `health_e01_test.gd` | 20 |
| `minigame_test.gd` | 38 |
| `coop_test.gd` | 54 |
| `world_rules_test.gd` | 10 |
| `expedition_save_test.gd` | 73 |
| **Total** | **195** |

A suíte nova cobre coração recusado com saúde cheia, cura sem reentrada, HUD,
coleta única, recuperação inválida, proteção contra dano repetido, emissão única
de derrota, bloqueio de cura e troca durante derrota, pausa, retorno protegido,
preservação do coração consumido, interrupção da investida por dano e saúde
compartilhada após troca. Usa posicionamento e chamadas diretas para isolar
essas condições; os percursos e contatos reais também são cobertos pela regressão.

Os testes existentes cobrem lesma, espinhos, ataque do Guardião, recuperação,
checkpoint, retomada, cooperação, persistência e migração de save.
Todos terminaram com zero falhas. O primeiro ensaio da suíte nova omitiu ativar
a bandeira; o cenário de teste foi corrigido antes da execução aprovada.

## Execução

```powershell
$engine = 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_win64_console.exe'
& $engine --headless --path . --script tests/health_e01_test.gd --fixed-fps 60
& $engine --headless --path . --script tests/minigame_test.gd --fixed-fps 60
& $engine --headless --path . --script tests/coop_test.gd --fixed-fps 60
& $engine --headless --path . --script tests/world_rules_test.gd --fixed-fps 60
& $engine --headless --path . --script tests/expedition_save_test.gd --fixed-fps 60
npm.cmd run build:web
npm.cmd run test:web
```

Build atual: `builds/web/evolucao_e01/`; servidor local usa essa pasta por padrão.
`TICO_WEB_STAGE=7`, `8` ou `9` permite servir os builds históricos existentes.
A telemetria continua identificando o conteúdo da campanha como etapa 9.
Versão do pacote de ferramentas: 0.9.1; formato e slots de save preservados.

## Pacotes

- `builds/web/Tico-evolucao-E01-web.zip` — conteúdo para extrair em `/tico/`.
- `builds/windows/Tico-evolucao-E01-windows.zip` — executável e PCK juntos.

Não limpar dados do navegador ao atualizar. O progresso existente continua válido.

## Web, Windows e desempenho

- Cinco cenários Web aprovados: quatro na execução completa e o de save futuro
  na repetição após corrigir uma espera ausente no teste de confirmação.
  Cobrem migração, percurso, toque, pausa, rotação, mecanismos e reabertura offline.
- Exportações Web/PWA e Windows geradas; ZIPs conferidos, incluindo `.htaccess`
  no Web e `Tico.exe`/`Tico.pck` no Windows. Executável aberto com Compatibility
  na Intel Iris Xe, sem erros no log.
- Amostra gráfica local em quatro cenas, 180–181 quadros por cena: medianas de
  16,665–16,687 ms; p95 de 17,699–18,093 ms. Coleta durante outras verificações,
  sem isolamento de carga; não representa medição em celular nem combate completo.
- Evidências: `builds/e01-*.log`, `builds/e01-browser-save-retest.log` e
  `builds/performance-e01-windows.json`. Logs e pacotes ficam fora do Git.

Os testes específicos da correção foram executados na Godot; a suíte Web
verifica a regressão do conjunto e a persistência, sem comandos de depuração
para alterar saúde no navegador.

## Conferência no aparelho

1. Receba dano: apenas um coração deve ser perdido durante a proteção.
2. Colete um coração com saúde incompleta; com saúde cheia, ele deve ficar disponível.
3. Troque entre Tico e Pipo: corações não devem ser recuperados pela troca.
4. Perca todos os corações; confirme a transição curta e o retorno à bandeira.
5. Pause durante a transição e retome; não deve haver retorno enquanto pausado.
6. Feche e reabra a PWA, inclusive offline, conferindo nozes, mecanismos e checkpoint.

O playtest desta versão no aparelho permanece pendente. Alterações sem commit ou push.

## Correção posterior — corrida de Tico e Pipo (0.9.2)

Relato do usuário: pernas permaneciam abertas ao correr. Os dois quadros antigos
tinham posições muito semelhantes. Foi adicionado `run.png`, com quatro poses
por personagem e alternância visível entre extensão e recolhimento das pernas.
O ciclo acompanha velocidade; repouso, salto e pausa encerram/congelam as passadas.
Controles, colisões, saúde e animações de esforço/empurrar foram preservados.

Validação específica: `run_animation_test.gd` (14 verificações) e
`push_animation_test.gd` (15 verificações). A suíte de corrida utiliza o chão
livre da arena do Rio para não confundir contato com inimigo e interrupção da
animação. No navegador, o cenário de corrida verifica os quatro quadros para
ambos os personagens e repouso; o cenário de toque na Vila verifica regressão.
As capturas de tela ficam fora da amostragem dos quadros para não atrasá-la.

Os pacotes E01 foram atualizados com a correção. Atlas antigos preservados.
