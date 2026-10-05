# Primeiros Passos — fase modelo (0.17.2)

Referência de duração aprovada: **5 a 8 minutos na primeira exploração tranquila,
incluindo a copa e sem contar mortes**. O usuário aprovou o tamanho e o tempo
da fase em 2026-10-02. Esta revisão mantém o comprimento.

## Percurso

- Caminho principal com 42.000 unidades de largura e chegada em x=41.780.
- Sequências de subidas, travessias e descidas, com grupos de nozes indicando a rota.
- Entrada da copa em x=21.000, na metade da fase. A árvore e a abertura discreta
  foram mantidas; a copa fica em outra região para não colidir com o percurso ampliado.
- Uma única bandeira em x=24.100, após a árvore. A copa não tem bandeira própria;
  ao retomar dentro dela, o jogador volta à entrada segura da área.
- Apoios permitem voltar pelos desníveis e acessar a árvore pela direita.
  Galhos da entrada permitem saltar por baixo e sustentam o jogador ao pousar.
- Desníveis da extensão ajustados para o salto menor de Pipo.
- Depois do resgate de Pipo, uma revisita acrescenta uma plataforma opcional em
  x=14.350. Pipo move a pedra até a marca; Tico entra na passagem estreita e
  encontra a Noz Dourada `retorno_01`. O caminho principal passa por baixo.
- 198 nozes principais e 26 na copa: **224 nozes** ao todo.
- Três corações na copa e quatro pontos de recuperação no caminho principal.
  Corações recuperam saúde; com três corações, concedem uma vida extra.
  Não contam como nozes. Com saúde cheia e 99 vidas, permanecem disponíveis.
- Lesmas invertem o movimento ao atingir paredes e consultam o chão na direção
  atual, evitando oscilar. Duas lesmas que nasciam dentro do terreno foram reposicionadas.

## Acabamento do solo — 0.17.2

- A textura de terra continua por toda a altura das plataformas, sem repetir a
  faixa de grama e sem deixar preenchimentos escuros abaixo dos primeiros 160 px.
- As junções ganham bordas irregulares de terra e transições suaves de cor.
- O acabamento é apenas visual: colisões, alturas e percurso permanecem iguais.
- Capturas de revisão: `builds/primeiros-passos-solo-01.png`,
  `builds/primeiros-passos-solo-02.png` e `builds/primeiros-passos-solo-03.png`.
- Na medição Windows 1280×720, a trilha registrou mediana de **21,61 ms** e
  percentil 95 de **26,55 ms**. As cinco amostras ficaram entre 21,61–23,88 ms
  de mediana; o relatório permanece em `builds/performance-e08-windows.json`.

## Uma vida a cada 100 nozes

A regra vale para novas coletas em toda a campanha, incluindo nozes de blocos e
segredos. O contador continua entre fases, mortes e reaberturas; o HUD mostra
o progresso até a próxima vida. `NUTS_PER_LIFE`, na campanha, define o limite de 100.

Cada item entra no contador uma vez por tentativa: morrer, salvar novamente ou
reabrir durante a tentativa não duplica créditos. Ao iniciar pelo mapa uma nova
tentativa de uma fase concluída, recompensas comuns podem ser recolhidas de novo.
Nozes Douradas mantêm o registro permanente; corações seguem a regra de cura ou
vida conforme a saúde.
O limite de 99 vidas permanece; atingir um marco nesse limite não acumula uma
vida para receber depois. Nova aventura reinicia o contador.

## Compatibilidade

O save continua V2. `survival.nut_total` registra as novas coletas desde a
introdução da regra; campanhas anteriores começam esse contador em zero,
preservando suas vidas e itens, sem conceder vidas retroativas.

Saves anteriores com uma bandeira ativada passam a usar a bandeira única.
`route_checkpoint` antigo continua aceito na leitura e deixa de ser gravado.
A antiga bandeira da copa é ignorada, preservando área ativa e recompensas.
O limite de itens por fase na campanha
foi ampliado para 512, pois o modelo tem mais de 64 coletáveis.

Os IDs antigos das nozes foram mantidos apesar das mudanças de coordenadas e alturas.
Conclusões anteriores continuam concluídas. Use **Jogar novamente** para conhecer
o percurso novo em uma campanha que já concluiu Primeiros Passos.

## Verificação

- `first_steps_model_test.gd`: marcos de 99/100 e 199/200 nozes, reabertura,
  duplicação, bandeira única, cura, conversão em vida e limite de 99 vidas.
- `first_steps_return_test.gd`: volta da chegada ao início com Tico e Pipo.
- `first_steps_refinement_test.gd`: árvore pela direita com ambos os personagens,
  lesma entre paredes e migração das bandeiras antigas.
- `first_steps_route_test.gd`: percurso principal completo por movimento e salto.
- Regressões de área opcional, vidas, checkpoints, progresso, save e resultados.
- Navegador: entrada da copa no meio, recompensas, portais, toque e offline.

### Registro anterior — 0.17.0

Os testes Godot do modelo e das regressões somaram **431 verificações aprovadas**.
O controle automático completou a rota principal em **146,7 segundos simulados**,
sem visitar a copa. Esse percurso direto verifica que a chegada é alcançável;
a meta de 5 a 8 minutos inclui exploração e ainda depende do playtest humano.

No navegador, os **24 cenários foram aprovados**: 21 na rodada completa e três
na repetição. A automação passou a aguardar o início físico do salto e a percorrer
o trecho final em segmentos. A comparação de tutoriais preserva dicas já vistas
e permite registrar dicas novas ao reabrir. O teste do painel do ninho apresentou
uma falha de tempo na rodada completa e passou na repetição sem alteração.

Medição local Windows, Compatibility, 1280×720, Intel Iris Xe: mediana entre
**19,18 e 22,14 ms por quadro**, com percentil 95 entre **23,97 e 28,68 ms** nos
cinco cenários (trilha, copa, extensão da copa, retorno e chegada). Essa medição
não confirma 60 FPS nem representa o desempenho no celular. Relatório completo:
`builds/performance-e08-windows.json`.

A validação final da 0.17.1 aprovou 24 verificações do modelo, 4 de refinamento,
4 de retorno, 133 de checkpoints, 73 de save, 47 de vidas e 28 da copa.
A rota principal completa voltou a terminar em **146,8 segundos simulados**.

Na revisão 0.17.1, a medição nas mesmas condições registrou mediana entre
**22,98 e 25,65 ms por quadro** e percentil 95 entre **28,20 e 32,41 ms**.
O celular continua sendo a referência para decidir se será necessária uma etapa
específica de otimização antes de aplicar o modelo às demais fases.

## Teste do ritmo no celular

1. Atualize os arquivos em `/tico/` sem limpar os dados do site.
2. Passe pela árvore, volte e suba pelo lado direito com Tico e com Pipo desbloqueado.
3. Confira os corações com saúde incompleta e com três corações, além da regra de 100 nozes.
4. Ative a única bandeira, saia do jogo e confira o retorno offline.
5. Volte por trechos da fase e observe as lesmas próximas das paredes.

Pacotes: `builds/web/Tico-evolucao-E08-web.zip` e
`builds/windows/Tico-evolucao-E08-windows.zip`. Sem commit ou publicação automática.

Este documento registra a fase modelo até a revisão visual 0.17.2. A distribuição
atual está em [Evolução E09](evolucao_e09.md), com novos alimentos e recompensas.
O padrão atual para reestruturar outras fases está em
[15_estrutura_fase_modelo.md](../arquivos_projeto/15_estrutura_fase_modelo.md).
Atualize-o junto com qualquer mudança aprovada na estrutura de Primeiros Passos.
