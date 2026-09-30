# Evolução E00 — Verificação da base

## Resultado

Preparação e diagnóstico concluídos. Código de gameplay preservado.
Inventário, classificação manter/alterar/remover/criar, dependências e textos
fixos registrados em [15_diagnostico_e00.md](../arquivos_projeto/15_diagnostico_e00.md).

## Verificações executadas nesta etapa

| Suíte existente | Verificações | Resultado |
| --- | ---: | --- |
| `tico_test.gd` | 45 | Aprovadas |
| `coop_test.gd` | 54 | Aprovadas |
| `world_rules_test.gd` | 10 | Aprovadas |
| `expedition_save_test.gd` | 73 | Aprovadas |
| **Total Godot** | **182** | **Zero falhas** |

Cobertura: movimento, salto, planagem, câmera, pausa, diferenças da dupla,
troca, força, dano, chefes, checkpoint, migração e reabertura da campanha.
Os saves de teste usam slots próprios. A E00 não executou novamente todas as
349 verificações históricas da etapa 9; selecionou as suítes acima para a base.

Web reconstruída com `npm.cmd run build:web`. Os cinco cenários atuais de
`expedition.spec.js` passaram em uma execução completa:

1. Migração do Bosque, percurso do Rio, checkpoint e reabertura offline.
2. Montanha: subida, vento, planagem e saída.
3. Vila por toque: peso, troca, multitoque, pausa, rotação e persistência.
4. Comporta por investida e reabertura com mecanismo ativado.
5. Save futuro preservado até confirmar nova aventura.

A reconstrução verificou também importação/exportação Godot, manifesto,
service worker e geração do cache. A inspeção do worker confirmou cache limitado
à subpasta, remoção de versões antigas do Tico e ativação da atualização por
ação do jogador. Atualização entre duas versões distintas e instalação em
aparelho físico não foram repetidas nesta etapa.

## Desempenho local

`expedition_performance.gd`, Windows/Compatibility, Intel Iris Xe, 1280 × 720.
180–181 quadros por cena após aquecimento, com partículas:

| Cena | Mediana (ms) | p95 (ms) |
| --- | ---: | ---: |
| Rio 2-1 | 16,630 | 18,189 |
| Montanha 3-1 | 16,671 | 17,498 |
| Vila 4-1 | 16,591 | 17,886 |
| Arena do Rei Castor | 16,738 | 17,665 |

Amostras de cenas, não uma medição do percurso inteiro ou combate completo.
A coleta local ocorreu durante a preparação das verificações Web, sem isolamento
de carga. Não representa garantia de desempenho no celular. Não foram medidos
pico de memória, aquecimento ou sessão prolongada em aparelho físico.

## Evidências locais

- `builds/e00-tico_test.log`
- `builds/e00-coop_test.log`
- `builds/e00-world_rules_test.log`
- `builds/e00-expedition_save_test.log`
- `builds/e00-web-build.log`
- `builds/e00-browser.log`
- `builds/e00-performance.log` e `e00-performance-errors.log` (sem erros)
- `builds/performance-e00-windows.json`

Os logs e builds são locais e ficam fora do Git. Os avisos de Node sobre
`NO_COLOR`/`FORCE_COLOR` são de formatação do terminal; os cinco testes passaram.

## Reprodução

```powershell
$engine = 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_win64_console.exe'
& $engine --headless --path . --script tests/tico_test.gd --fixed-fps 60
& $engine --headless --path . --script tests/coop_test.gd --fixed-fps 60
& $engine --headless --path . --script tests/world_rules_test.gd --fixed-fps 60
& $engine --headless --path . --script tests/expedition_save_test.gd --fixed-fps 60
npm.cmd run build:web
npm.cmd run test:web
& $engine --path . --script tests/expedition_performance.gd
```

O script de desempenho reutilizado grava `performance-stage9-windows.json`;
a execução da E00 foi copiada para `performance-e00-windows.json`.

## Aceite da E00

- [x] Sistemas, código reutilizável e dependências identificados.
- [x] Fases, controles, inimigos, colisões e HUD inspecionados.
- [x] Progresso, armazenamento e estrutura PWA verificados.
- [x] Listas manter, alterar, remover e criar registradas.
- [x] Textos fixos visíveis e textos históricos ocultos diferenciados.
- [x] Base verificada com testes de engine, save, Web/PWA e amostra de desempenho.

Próxima etapa: **E01 — Saúde, dano e morte**, revisando o sistema existente.
Vidas, mapa, replay global de Pipo e substituição do chefe ainda serão implementados.
Nenhum commit ou push realizado nesta etapa.
