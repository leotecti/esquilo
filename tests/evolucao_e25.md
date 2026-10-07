# Evolução E25 — Performance

## Gargalos encontrados

- A fase 1-3 mantinha centenas de animações de coletáveis processando fora da
  câmera.
- Inimigos de toda a fase continuavam executando inteligência e física mesmo a
  dezenas de telas do jogador.
- As três áreas secundárias redesenhavam o cenário a 60 Hz mesmo quando o
  personagem estava na trilha principal.
- A arte de todo o solo expandido era um único `CanvasItem`. Isso impedia o
  descarte eficiente das partes distantes e elevava as chamadas de desenho.

## Alterações

- `MobileActivityManager` atualiza a atividade a cada 180 ms, com margens
  maiores que a tela. Animações e inimigos são reativados antes de aparecerem.
- O desenho-base invisível dos coletáveis deixa de executar `_process`; a arte
  comercial visível continua responsável pela animação.
- Goteiras pausam fora da Gruta Fria.
- Animações ambientais das áreas secundárias são limitadas a 30 Hz e só
  redesenham quando a área está ativa ou a entrada está próxima.
- O solo de fases longas foi dividido em trechos visuais de 1.800 px. Colisão e
  geometria permanecem contínuas.

## Medição local

Ambiente: Godot 4.7.2, Compatibility, 1280×720, Intel Iris Xe.

| Cena | draw calls p95 antes | draw calls p95 depois | p95 depois |
|---|---:|---:|---:|
| 1-1 | 151 | 150 | 17,12 ms |
| 1-2 | 151 | 153 | 17,01 ms |
| 1-3 | 341* | 146 | 17,20 ms |
| 1-4 | 110 | 102 | 17,25 ms |

`*` Medição da fase expandida feita imediatamente antes da divisão em trechos.
A queda em 1-3 foi de aproximadamente 57% nas chamadas de desenho.

Na entrada de 1-3, 298 animações foram registradas e somente 8 permaneceram
ativas. Os 15 inimigos foram mantidos em espera enquanto estavam distantes.

## Limites da validação

A medição local confirma redução de trabalho da CPU e da GPU, mas não representa
o desempenho de um navegador móvel. Validar no mesmo conjunto de celulares que
apresentou saltos de quadros, com atenção especial à fase 1-3 e à Gruta Fria.

## Web/PWA

O build Web foi gerado com cache b847ee0c65012d6a. Na suíte Playwright, 27 de 35 cenários passaram, incluindo cache incremental, Gruta Fria, caudada, abertura, offline e controles. Oito cenários antigos de mapa, migração e posições automatizadas não correspondem ao fluxo e à extensão atuais das fases; a E25 não altera esses estados. Os testes Godot da otimização, fase 1-3 e aventura completa somaram 69 verificações sem falhas.
