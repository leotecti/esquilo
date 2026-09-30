# Etapa 7 — Vertical Slice / Bosque das Folhas

Data: 29/09/2026. Implementação disponível; marco 5 aguardando avaliação humana.

## Entrega

- `scenes/levels/vertical_slice.tscn` é a entrada principal. O percurso, a física
  e os IDs de persistência permanecem compatíveis com a etapa 6.
- Fundo ilustrado com deslocamento suave, vegetação, solo com borda clara,
  tronco/passagem, objetos ilustrados e chegada ornamentada.
- Tico: idle, corrida, salto, queda, planar, dano e celebração.
- Pipo: idle, corrida, salto, queda, empurrar, preparar/investir/recuperar,
  farejar, dano e celebrar. Poses de atlas combinadas com ciclos procedurais.
- Corações, retrato do personagem, botões, pausa, controles touch e conclusão
  com paleta de creme, verde e dourado. Capa Web usa a arte do bosque.
- Música original em loop, passos, salto, pouso, coleta, impacto, dano,
  checkpoint, segredo, troca, interface e vitória, com streams pré-carregados.
- Música e efeitos têm opções separadas e persistentes. O campo `settings`
  é opcional no save v1; ausência usa áudio ligado, preservando saves da etapa 6.
- Atlas compartilhados, limite de 16 emissores de efeitos e expiração automática.

Arte, arquivos finais e prompts: [assets/slice](../assets/slice/README.md).
Áudio reproduzível: `node tools/generate_slice_audio.mjs`.

## Verificação

```powershell
$engine = 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_win64_console.exe'
& $engine --headless --path . --script tests/slice_test.gd --fixed-fps 60
npm.cmd run build:web
npm.cmd run test:web
& $engine --path . --script tests/slice_performance.gd
```

O teste da engine usa `user://stage7_test_only.json` e o remove ao terminar.
Percorre a fase por comandos e verifica apresentação, áudio, pausa, preferências,
salto/planar, dano, investida, limite de efeitos e celebração. Os testes anteriores
continuam executáveis nas respectivas cenas.

No Chrome, verificar também save anterior sem `settings`, opções de áudio,
reabertura e amostra de tempos de quadro. A sonda de desempenho existe apenas
em `?test=1`; usa relógio monotônico, sem depender do delta suavizado da engine.
O teste Web detecta travamentos graves; seu limite não certifica 60 FPS.

### Desempenho

**Resultado técnico:** 208 verificações de engine aprovadas (185 anteriores
+ 23 novas) e 12 cenários de Chrome aprovados. Incluem percurso completo,
multitoque, pausa, áudio, compatibilidade de save, atualização e reabertura
offline em um novo processo de navegador. Importação e exportações sem erros
de script; capturas desktop, celular emulado, pausa e chegada revisadas.
Os pacotes Web e Windows foram gerados e conferidos; o executável Windows
iniciou e encerrou com código 0, sem erros ou avisos após liberar o áudio.
O ZIP Web inclui a capa do bosque no cache offline. Nenhum commit foi realizado.

Windows: Compatibility, Intel Iris Xe, 1280×720; amostra de 543 quadros em três
trechos, após aquecimento. Mediana **16,66 ms**, percentil 95 **17,74 ms**;
percentil 95 de draw calls: **164**. É uma amostra local, não garantia para outros aparelhos.

Web desktop: Chrome headless/SwiftShader, 1280×720; mediana **16,70 ms**,
percentil 95 **17,90 ms**, com **82 draw calls** no retrato final da amostra.
As medições usam relógio monotônico e não certificam o desempenho do Android.

Relatórios reproduzíveis: `builds/performance-stage7-windows.json` e
`builds/web/performance-etapa7.json`. O teste Web usa Chrome headless/SwiftShader.
O Android/PWA real ainda precisa ser medido; a emulação de toque não mede o hardware
de um celular. Meta do projeto: 60 FPS; corrigir problemas observados antes do Mundo 1.

## Ajuste após o teste do usuário — esforço e passadas

O usuário pediu que Tico demonstrasse esforço diante da pedra e que Pipo
movimentasse as pernas enquanto empurra. O projeto recebido ainda usa
`vertical_slice.tscn`; o ajuste foi aplicado ao Bosque das Folhas.

- Tico usa quatro poses de esforço ao segurar uma direção contra a pedra,
  apoiado no chão. Soltar, afastar-se ou saltar encerra a tentativa.
- Pipo alterna quatro quadros de passada conforme a distância percorrida;
  no limite da pedra, para os pés e mantém a postura de esforço.
- Dano, derrota e habilidades têm prioridade sobre o esforço. Pausar congela
  o ciclo. Física, força, limites da pedra e dados do save permanecem iguais.
- Verificação específica: `tests/push_animation_test.gd` (15 casos).
  Regressão: `slice_test.gd` e `coop_test.gd` (77 casos).
- Navegador: `tests/browser/push.spec.js` verifica teclado e multitoque,
  alternância de poses, pedra imóvel com Tico e deslocamento com Pipo.
- Resultado: 92 verificações na Godot e três cenários no navegador aprovados,
  incluindo o percurso completo da dupla. Pacotes Web/PWA e Windows atualizados
  com as animações de esforço e passadas.

## Roteiro de aceite no aparelho

- [ ] Atualizar o pacote sem limpar dados; verificar retomada do save anterior.
- [ ] Reconhecer Tico e Pipo pelas referências, inclusive em movimento e no faro.
- [ ] Distinguir plataformas, lesma, blocos, parede pesada e decoração.
- [ ] Percorrer toda a trilha com multitoque, sem controles presos nem botões encobertos.
- [ ] Ouvir música e efeitos em volume confortável; sem distorção ou cortes ao repetir.
- [ ] Desligar música e efeitos separadamente, fechar/reabrir e conferir preferências.
- [ ] Pausar, mudar de aplicativo e girar o celular; confirmar suspensão e retomada.
- [ ] Reabrir offline pelo ícone e concluir o percurso com áudio e arte disponíveis.
- [ ] Jogar por pelo menos dez minutos e observar travamentos, aquecimento e bateria.
- [ ] Registrar aparelho, sistema, navegador e FPS/tempos de quadro quando disponíveis.
- [ ] Executar o [roteiro com jogadores](playtest_etapa_6.md) e aprovar identidade/diversão.

Só então aprovar **marco 5 — Vertical Slice**. O pedido de avançar não substitui
um resultado de playtest ainda não registrado.
