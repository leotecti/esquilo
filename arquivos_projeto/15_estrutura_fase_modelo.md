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

### Aplicação em 1-2 — Blocos e Segredos

A fase 1-2 aplica a frequência, a duração, a segurança e a progressão do modelo,
mas usa composição própria. O percurso tem 39.000 unidades e organiza o avanço
em salas de ruína, pilares, blocos suspensos, caminhos altos e segredos. Blocos
são o mecanismo dominante; a geometria de escadas da fase 1-1 não foi copiada.

A área secundária pode usar outra linguagem visual quando o tema pedir. Em 1-2,
a Galeria das Pedras é acessada por um arco de alvenaria com névoa, aproximadamente
no meio do percurso. Ela inclui recompensas, recuperação, inimigos e tesouro
permanente. A saída fica antes da única bandeira da fase e comunica progresso.

Não replique automaticamente o total de itens de Primeiros Passos em outras
fases. Use-o como exemplo de frequência e variedade; ajuste quantidades à
duração, ao tema e à dificuldade de cada percurso.

### Aplicação em 1-3 — Um Novo Amigo

A fase 1-3 preserva o resgate e a apresentação de Pipo como abertura. Depois do
resgate, o percurso cresce para **38.000 unidades** e passa a alternar desafios
de força e agilidade, pedras móveis, blocos resistentes, inimigos, provisões e
recuperação. A fase oferece 244 nozes e 24 alimentos, distribuídos em dez trechos.

A área secundária aparece aproximadamente em **x = 19.500** como um túnel
mineral. A Gruta Fria usa um cenário próprio, quatro morcegos, estalactites e
seis goteiras perigosas. Cada goteira anuncia a queda com brilho e uma gota
parada, cai, produz um impacto breve e reinicia; o dano ocorre somente durante
a parte ativa e legível do ciclo.

A saída da gruta coloca o personagem em uma plataforma segura em x = 24.080.
A única bandeira fica logo depois, em x = 24.300. O percurso termina em
x = 37.780, após um trecho final mais calmo. Essa estrutura mantém a narrativa
de formação da dupla e transforma as habilidades apresentadas em prática.

## Recompensa, combate e saída opcional — revisão 0.29.5

Vidas especiais são reveladas em um bloco raro atingido por baixo. A linguagem
visual usa noz, folha e dourado para diferenciá-lo dos blocos comuns; a animação
`+1` confirma a recompensa sem deixar um coletável solto no caminho.

O pisão em inimigos considera posição, direção vertical e trajetória do quadro
anterior para tolerar pequenas diferenças de processamento. A saída de uma área
secundária deve comunicar progresso: em Primeiros Passos, ela retorna à plataforma
imediatamente anterior à bandeira, mantendo o checkpoint como conquista do jogador.


## Navegação em dois níveis

As fases podem reutilizar áreas inferiores já visíveis, sem ampliar sua extensão horizontal. Pontes marcadas com uma seta dourada aceitam **Baixo**, **S** ou o botão **▼** para descer. A rota inferior deve conter recompensas ou riscos, manter piso seguro e oferecer retorno por salto ou degrau. Superfícies comuns continuam sólidas para evitar descidas acidentais.

## Escala e leitura dos personagens

Pipo aparece aproximadamente 29% mais alto que Tico durante o jogo e também é
maior no mapa. Sua ilustração acompanha o corpo físico já existente, inclusive
em corrida, preparação, investida e empurrão. Essa diferença deve comunicar
força e volume e preparar a leitura de passagens estreitas exclusivas de Tico,
sem aumentar novamente a colisão ou comprometer fases já validadas.

Seu peso também tem efeito mecânico: Pipo recebe 45% do recuo de golpes, 30% da
força do vento e 25% da correnteza. Faixas de água rasa usam setas para indicar
direção. Elas devem oferecer rotas ou recompensas em que a estabilidade de Pipo
seja vantajosa, mantendo o dano dos inimigos e a necessidade de atenção.

Besouros blindados reforçam Pipo no combate. A carapaça deve rejeitar caudada e
pisão com resposta metálica; a investida de Pipo quebra a defesa e deixa o
inimigo exposto para qualquer personagem finalizar. A armadura usa placas
azul-petróleo e rebites dourados para comunicar sua regra antes do primeiro golpe.

Plataformas largas de peso afundam gradualmente e travam após Pipo permanecer
sobre elas. O Mundo 2 usa uma em cada fase de percurso. Em 2-1, rajadas visíveis
impedem Tico de alcançar uma mola artesanal. O peso de Pipo permite atravessar o
vento, comprimir a mola e alcançar uma plataforma alta sobre o rio. Tico recebe
apenas um salto curto. Essa travessia não deve possuir plataforma móvel ou rota
alternativa, e cair na água causa dano e retorna à margem segura.

O transporte de provisões usa cestos colocados em superfícies seguras. Pipo anda
mais devagar e não salta nem troca de personagem enquanto carrega. AÇÃO solta o
cesto durante o percurso. Ao se aproximar da carroça do burrinho, o controle é
suspenso e a entrega começa automaticamente. Pipo ergue a cesta acima da cabeça,
mantém os braços elevados e caminha com expressão de esforço. As rotas devem
permitir o transporte a pé e deixar o destino visível antes do início.

Em 2-1, Pipo alcança a cesta diretamente depois da travessia da mola. A missão
mantém o transporte das provisões e a entrega à carroça, sem o antigo mecanismo
de rocha, corda, alavanca e barreira.

### Estrutura do Mundo 2

| Fase | Uso obrigatório de Pipo |
|---|---|
| 2-1 | Resistência ao vento, mola de peso e transporte de provisões |
| 2-2 | Plataformas de peso e travessia em balsas móveis |
| 2-3 | Quebra de armaduras e transporte de provisões |
| 2-4 | Investida para romper a defesa do Guardião do Rio antes do salto de Tico |

A fase 2-1 usa **38.000 unidades**. O trecho inicial aprovado permanece intacto;
depois da entrega, dez trechos alternam margens, correntezas, plataformas móveis,
blocos, alimentos e inimigos. Uma caverna em **x = 18.418** leva à área
secundária e retorna em **x = 24.600**. A bandeira única fica em **x = 25.800**
e o portal final em **x = 37.740**. O vento contrário cobre toda a trilha e os
inimigos seguem a regra especial de derrota com um salto ou uma investida de Pipo.

Na fase 2-4, os três acertos repetem a cooperação completa. Pipo rompe a
proteção, o jogo mantém uma janela segura para a troca e somente o salto de Tico
reduz a vida do chefe. Isso impede que um único personagem resolva o encontro.

### Aplicação em 1-4 — Periquito do Bosque

A fase 1-4 passa a ter **38.000 unidades** e onze trechos antes do portal final.
A trilha alterna clareiras, plataformas reversíveis, blocos, provisões e cinco
tipos de inimigo. A entrada da área secundária fica aproximadamente em
**x = 18.400**, atrás de uma cachoeira com abertura rochosa, névoa e indicação
contextual. A saída retorna em **x = 24.600** e a bandeira única fica adiante,
em **x = 25.100**.

O Refúgio da Cachoeira possui cenário, terreno e recompensas próprios. O piso
usa rocha úmida verde-petróleo, lajes irregulares, musgo e reflexos discretos,
sem redesenho contínuo da camada estática. Todos os
coletáveis e inimigos se apoiam em superfícies navegáveis. A aproximação final
fica mais calma e a arena do Periquito permanece limpa para que o jogador leia
voo, pouso, cansaço e vulnerabilidade sem interferência de inimigos comuns.
