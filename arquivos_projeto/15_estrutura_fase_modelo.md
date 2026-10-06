# Estrutura padrão das fases

Este documento define a estrutura aprovada em **1-1 — Primeiros Passos** para
orientar a reestruturação das demais fases. Ele descreve o padrão de percurso,
ritmo, recompensas, checkpoints e segurança de navegação; cada mundo pode manter
sua identidade visual, seus inimigos e seus mecanismos próprios.

## Fonte de referência

- Geometria e distribuição: `scripts/systems/first_steps_layout.gd`.
- Área secundária: `scripts/systems/optional_area.gd`.
- Regras de recompensas e playtest: `tests/evolucao_e09.md`.
- Este arquivo é a referência de design para as próximas fases.

Se uma alteração aprovada mudar tamanho, ritmo, checkpoints, recompensas ou
regras de segurança do modelo, atualize este documento na mesma alteração e
revise os arquivos de status e evolução que apontam para ele. Mantenha números
e coordenadas coerentes com o código e com os testes.

## Escala e marcos

| Elemento | Padrão aprovado |
| --- | ---: |
| Largura do caminho principal | 42.000 unidades |
| Chegada | x = 41.780 |
| Entrada da área secundária | x = 21.000, aproximadamente metade da fase |
| Bandeira única | x = 24.100, depois da árvore e da área secundária |
| Área secundária | 4.000 unidades de largura, em uma região lateral |
| Duração da primeira exploração | 5 a 8 minutos, com exploração tranquila e sem contar mortes |

A bandeira é única e fica depois da principal escolha de exploração. A área
secundária não cria um checkpoint próprio. Ao retornar a ela, o jogo usa uma
posição segura de entrada.

## Ritmo do caminho principal

Primeiros Passos usa onze trechos de aproximadamente **3.200 unidades** cada,
começando em x = 5.200. Cada trecho contém oito passos de 400 unidades. Três
perfis de altura alternam subidas, plataformas de travessia e descidas. Use-os
como referência de ritmo, sem copiar a silhueta literalmente em todos os mundos.

Uma fase baseada neste modelo deve alternar:

1. corrida curta para o jogador ler o próximo obstáculo;
2. subida ou salto com nozes agrupadas indicando a rota;
3. encontro com inimigo em plataforma aberta;
4. pausa breve ou descida recuperável;
5. bloco de recompensa e alimento antes do próximo trecho.

Evite longos corredores sem inimigos, itens, mecanismos ou mudanças no terreno.
No modelo atual, alimentos aparecem três vezes por trecho, há ao menos um bloco
de provisão por trecho e o maior intervalo entre recompensas foi medido em 540
unidades. Não transforme cada trecho numa linha contínua de coletáveis: deixe
espaço para correr e varie altura e posição dos grupos.

## Curva de dificuldade da fase modelo

Primeiros Passos usa uma curva única antes da futura criação de modos separados:

| Momento | Intervalo | Função |
| --- | ---: | --- |
| Aprender | x = 0 a 5.200 | apresentar salto, planagem e lesma com espaço |
| Praticar | x = 5.200 a 14.800 | repetir encontros previsíveis na velocidade base |
| Combinar | x = 14.800 a 27.600 | juntar terreno, recompensas e lesmas moderadamente mais rápidas |
| Desafiar | x = 27.600 a 40.500 | pedir reação maior com elementos já ensinados |
| Chegada | x = 40.500 a 42.000 | reduzir a pressão antes da saída |

Há duas lesmas em cada um dos quatro momentos jogáveis. Suas velocidades são 45,
45, 50 e 55. Elas continuam isoladas em plataformas abertas; o aumento vem do
contexto do percurso, sem ampliar saúde ou criar grupos que bloqueiem a passagem.

## Recompensas e saúde

Primeiros Passos oferece **271 nozes contabilizadas**, sendo 245 no caminho
principal e 26 na copa; a contagem inclui nozes de blocos. Há também 39 alimentos
de três tipos, 14 blocos de provisão e duas Nozes Douradas opcionais. Alimentos
abastecem o contador do vilarejo, separado da regra de uma vida a cada 100 nozes.

Corações recuperam saúde. Quando a saúde está cheia, um coração pode conceder uma
vida, respeitando o limite da campanha. Na revisita de uma fase concluída pelo
mapa, as recompensas recolhíveis reaparecem: nozes e blocos podem render vidas
novamente; alimentos voltam a abastecer o vilarejo; corações seguem sua regra de
cura ou vida. Cada coleta é salva uma vez por tentativa. Nozes Douradas mantêm
registro permanente e não concedem um segundo tesouro.

## Área secundária

A copa fica aproximadamente na metade do percurso principal e deve parecer uma
descoberta opcional. Ela oferece percurso próprio, inimigos, nozes, alimentos,
corações e uma recompensa especial, mas o jogador pode terminar a fase sem
explorá-la. Preserve uma rota clara de entrada e retorno para a trilha principal.

A entrada precisa ser reconhecida antes do contato: use uma árvore completa,
com raízes sobrepostas ao terreno, sem revelar a paisagem por baixo, tronco,
galhos e copa, e destaque o vão com
névoa suave em movimento e luz integrada à natureza.
Ao se aproximar, mostre o nome do destino e o comando de entrada. O brilho deve
chamar atenção sem competir com o personagem ou parecer um portal tecnológico.

## Ensino contextual de mecanismos

Mecanismos novos combinam três sinais: aparência que sugere sua função, indicação
visual do objetivo e uma mensagem curta quando o jogador se aproxima. Na pedra
da fase modelo, Tico recebe a orientação para trocar para Pipo; Pipo recebe a
instrução de segurar a direção; uma seta sobre a pedra e uma marca dourada no
chão indicam o movimento e o destino. A orientação não pausa o jogo e aparece
uma vez por tentativa.

Colisões devem seguir a silhueta visível. Copas, túneis e galhos não podem criar
apoios invisíveis, bloquear espaço aparentemente livre ou permitir que o jogador
fique em pé fora da arte.
## Segurança de navegação

- Degraus devem permitir avanço e retorno, inclusive com o salto menor de Pipo.
- Não deixe fendas entre plataformas onde o personagem possa cair e ficar preso.
- Apoios junto a árvores, paredes e passagens precisam ter saída caminhável ou
  um salto claramente alcançável nos dois sentidos.
- Inimigos patrulham plataformas abertas; evite colocá-los em espaços estreitos
  entre paredes ou degraus.
- A câmera deve manter o personagem visível durante saltos e entradas opcionais.
- Teste a fase indo até o fim e voltando ao início, além de passar pela rota
  principal com cada personagem desbloqueado.

## Guia para aplicar às próximas fases

Use estes passos ao reestruturar uma fase:

1. Defina a duração e os marcos principais antes de posicionar itens.
2. Divida o percurso em trechos curtos com mudanças legíveis de altura e ritmo.
3. Alterne corrida, plataformas, encontros, recompensas e pequenos respiros.
4. Coloque a área opcional perto do meio e o checkpoint principal depois dela.
5. Distribua nozes, alimentos e blocos para evitar trechos longos vazios.
6. Confira que cada degrau pode ser percorrido de ida e volta com Tico e Pipo.
7. Atualize este documento sempre que a estrutura padrão aprovada mudar.

Não replique automaticamente o total de itens de Primeiros Passos em outras
fases. Use-o como exemplo de frequência e variedade; ajuste quantidades à
duração, ao tema e à dificuldade de cada percurso.
