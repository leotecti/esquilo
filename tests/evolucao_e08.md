# Evolução E08 — Áreas opcionais e exploração

Versão atual **0.17.2**. Primeira área secundária implementada na fase **1-1 — Primeiros Passos**.

A fase agora serve de modelo para duração e exploração: 224 nozes, vida a cada
100 novas coletas, acesso à copa no meio, corações e uma única bandeira após a árvore.
Tamanho aprovado; retorno, lesmas e acesso pelos dois lados revisados.
[Entrega 0.17.2 e roteiro](primeiros_passos_modelo.md). Os registros abaixo
descrevem as revisões anteriores da E08.

## Ampliação 0.16.2

Escopo aprovado: ampliar Primeiros Passos e sua copa antes de estender os
demais mundos. A aparência da árvore e a entrada discreta foram preservadas.

- Caminho principal: largura de 3.800 para 5.200 unidades, seis nozes adicionais,
  duas novas lesmas e chegada em x=5.040. Bandeira e itens antigos mantêm suas posições.
- Copa: largura de 1.800 para 4.000 unidades, novos galhos, rota inferior e
  26 nozes no total. A primeira subida e os portais anteriores permanecem.
- Três lesmas patrulham a copa. Uma vida extra está no último conjunto de galhos;
  um terceiro portal permite voltar sem refazer todo o trajeto.
- A fase reúne 42 nozes: 16 no caminho principal e 26 opcionais.
- A vida da copa usa o evento persistente `copa_life`, separado do medalhão
  original. Não reaparece após morte, reabertura ou replay. Nova aventura reinicia
  as recompensas. O limite de 99 vidas continua válido.
- Saves V2 existentes são aproveitados; não há migração nem alteração dos IDs
  dos itens anteriores. Conclusões antigas continuam concluídas.

Esta ampliação antecipa conteúdo de recompensas a pedido do usuário; a E09
continua responsável pelas regras gerais dos coletáveis.

Validação da ampliação: 410 verificações Godot passaram (28 da copa, 47 de vidas,
133 de checkpoints, 79 de progresso, 73 de persistência e 50 de resultados).
Três cenários de navegador passaram: copa ampliada com coleta da vida e
reabertura offline, novo final da trilha e portais por toque com Pipo.

Desempenho 0.16.2: cinco cenários na Iris Xe, 1280×720, com medianas entre
16,58 e 16,67 ms; o maior p95 foi 19,12 ms. O relatório inclui a região nova
da copa e a chegada ampliada. Desempenho e ritmo no celular aguardam playtest.

## Revisão visual 0.16.1

Acesso mais discreto: aberturas de madeira e folhagem substituem os arcos dourados.
As plataformas da copa e da subida têm aparência de galhos com musgo, com as
mesmas superfícies de colisão. Troncos usam silhuetas afuniladas e cores suaves.
O título grande foi retirado da paisagem; os avisos de ação aparecem apenas
perto das entradas. Itens, saltos, checkpoints e formato do save foram mantidos.

Revalidação 0.16.1: 21 verificações Godot e dois cenários de navegador passaram,
incluindo toque e offline. Na Iris Xe a copa apresentou mediana de 16,66 ms e
p95 de 18,24 ms; o relatório de desempenho foi atualizado.

## Percurso

Após os primeiros degraus da trilha, suba os três galhos da árvore. No arco
do alto, pressione **E** ou o botão **AÇÃO** para entrar na **Copa dos Segredos**.
Suba as plataformas para coletar nozes. Há uma bandeira local na primeira
plataforma e três portais de retorno: na entrada, na primeira copa e no fim do percurso ampliado.

A área é opcional: o caminho principal continua aberto e não exige essas nozes.
Tico e Pipo podem usá-la; Pipo depende do resgate, como nas demais fases.

## Estado e segurança do retorno

- A mesma fase conserva seus inimigos, itens, conclusão e bandeira principal.
- A copa usa câmera delimitada e transição breve, sem trocar o save da fase.
- Morrer na copa retorna à entrada ou à bandeira local, descontando uma vida.
- Sair pelo portal devolve o personagem ao alto da árvore. A próxima morte no
  caminho principal usa sua bandeira original.
- Fechar o jogo na copa recupera a entrada ou a bandeira local; itens coletados
  permanecem coletados. Consultar o mapa preserva a tentativa.
- Game Over usa o fluxo existente do mapa. Reiniciar ou rejogar a fase começa
  no caminho principal, preservando as conquistas e os itens já registrados.
- Save V2 recebe o campo opcional `levels["0"].optional_area`, com dois booleanos:
  `active` e `checkpoint`. Saves anteriores sem esse campo continuam válidos.
- As nozes usam IDs estáveis no array de itens existente. A vida adicional
  reutiliza o medalhão existente e possui registro próprio de coleta.

Implementação: `scripts/systems/optional_area.gd`. A área usa personagens,
vegetação, nozes, bandeira e materiais já presentes no projeto.

## Validação

**497 verificações Godot e 23 cenários de navegador passaram**, incluindo o
percurso completo da copa por teclado e os portais por toque com Pipo.
As regressões automatizadas do loop principal também passaram nesta versão.

- `tests/optional_e08_test.gd`: entrada, câmera, retorno, bandeiras independentes,
  morte, Game Over, reinício, itens, reabertura e validação do save.
- Navegador: subida real pelos galhos, quatro coletas, portais, reabertura offline
  e uso dos portais por toque com Pipo.
- Regressões do ciclo principal: saúde, vidas, checkpoints, tutorial, progresso,
  persistência, mapa e resultados.
- Desempenho: `tests/optional_e08_performance.gd`, relatório
  `builds/performance-e08-windows.json`.

Intel Iris Xe, Windows Compatibility, 1280×720, 179–181 amostras por cenário:

| Cenário | Mediana | p95 |
| --- | ---: | ---: |
| Trilha principal | 16,64 ms | 17,60 ms |
| Copa opcional | 16,70 ms | 18,42 ms |
| Retorno da copa | 16,62 ms | 17,63 ms |

## Pacotes

- Web/PWA: `builds/web/Tico-evolucao-E08-web.zip`.
- Windows: `builds/windows/Tico-evolucao-E08-windows.zip`.
- Pastas: `builds/web/evolucao_e08/` e `builds/windows/evolucao_e08/`.

## Conferência no celular

1. Publique o ZIP Web em `/tico/` sem apagar os dados do site.
2. Abra ou rejogue **Primeiros Passos**. Suba os galhos próximos aos primeiros degraus.
3. Use **AÇÃO** no portal e explore a copa. Confira câmera, saltos e controles.
4. Ative a bandeira, colete nozes e confira que morrer não duplica a recompensa.
5. Saia pelos portais e siga o caminho principal normalmente.
6. Feche na copa e reabra offline; confira posição segura e itens preservados.
7. Se Pipo estiver desbloqueado, confira também sua troca e o botão de ação.

Sem commit, push ou publicação automática. Desempenho e conforto dos saltos
no celular aguardam a conferência do usuário.
