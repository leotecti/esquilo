# Validação intermediária 2 — aventura completa em miniatura (0.25.0)

O Mundo 1 foi adotado como a amostra integrada do jogo completo. Esta validação
confirma que os sistemas construídos nas evoluções anteriores formam uma aventura
coerente antes da produção e do refinamento dos demais mundos.

## Fluxo validado

1. A abertura apresenta Tico, a escassez de comida e Valda.
2. A narrativa conduz ao mapa do Bosque das Folhas.
3. **1-1 — Primeiros Passos** ensina a movimentação, oferece nozes, alimentos e
   a Copa dos Segredos como exploração opcional.
4. **1-2 — Blocos e Segredos** pratica blocos, inimigos e descoberta.
5. **1-3 — Um Novo Amigo** apresenta e resgata Pipo, liberando a cooperação.
6. **Periquito do Bosque** exige resolver o confronto antes da saída.
7. Valda apresenta a próxima pista e o mapa libera o Rio das Pedras.
8. Fechar e reabrir preserva cenas concluídas, fases, Pipo e conquistas.

## Cobertura dos requisitos

| Requisito | Implementação usada |
|---|---|
| Mapa | Quatro páginas, com o Mundo 1 usado neste fluxo |
| Duas ou três fases | Três fases do Bosque e um encontro final separado |
| Narrativa | Abertura, apresentação de Pipo e encerramento com Valda |
| Coruja | Valda atua como mentora na abertura e após o chefe |
| Área opcional | Copa dos Segredos na fase 1-1 |
| Coletáveis | Nozes, alimentos, corações, vida e Noz Dourada |
| Pipo | Apresentação, resgate, troca e habilidades de força |
| Chefe | Guardião com saída bloqueada até a resolução |
| Progressão | Desbloqueio sequencial e acesso ao Mundo 2 |
| Save | Save V2, migração, reabertura e PWA offline |

## Testes

- `mini_adventure_validation_test.gd`: **35 verificações** em uma única campanha,
  da abertura à reabertura após o chefe.
- As suítes específicas de abertura, mapa, área opcional, Pipo, chefe, vidas,
  save e backtracking permanecem como regressões detalhadas.
- O teste Web confirma carregamento, PWA, controles e persistência no navegador.
- Medição Windows Compatibility em 1280×720: mediana de 16,62–16,73 ms e
  percentil 95 de 17,83–18,86 ms nas quatro cenas do Mundo 1. Relatório em
  `builds/performance-stage8-windows.json`.

## Roteiro no aparelho

1. Inicie uma nova aventura e acompanhe ou pule a abertura.
2. Complete as fases 1-1, 1-2 e 1-3 pelo mapa.
3. Entre e saia da Copa dos Segredos; colete uma Noz Dourada.
4. Resgate Pipo, troque de personagem e use sua força.
5. Acalme o Periquito do Bosque e acompanhe a conversa com Valda.
6. Confirme que o Rio das Pedras foi liberado.
7. Feche e reabra a PWA; confira mapa, Pipo, fases e coletáveis.
8. Repita a reabertura sem conexão.

Pacotes: `builds/web/Tico-validacao-intermediaria-2-web-corrigido.zip` e
`builds/windows/Tico-validacao-intermediaria-2-windows-corrigido.zip`. Sem commit ou
publicação automática.
