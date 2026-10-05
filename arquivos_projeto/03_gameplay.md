# TICO E A FLORESTA DAS NOZES

## DOCUMENTO DE GAMEPLAY

**Versão:** 1.0  
**Documento:** 03_gameplay.md

## Diretriz de evolução aprovada

A dupla compartilha saúde e, na evolução, vidas. Morte com vidas restantes usa o checkpoint. Game Over restaura as vidas e retorna ao mapa do mundo anterior, preservando desbloqueios e conquistas permanentes; no Mundo 1, permanece nele. Pipo fica disponível nas fases iniciais revisitadas somente após seu resgate global. A duração será validada após uma fase completa da evolução.

Estas decisões descrevem a evolução a implementar; os builds da etapa 9 registram o comportamento anterior. Referências: [evolução](13_evolucao.md), [etapas E00–E30](14_etapas_evolucao.md) e DEC-115 em [decisões](11_decisoes.md).

---

# 1. OBJETIVO DO DOCUMENTO

Este documento define como o jogador interage com **Tico e a Floresta das Nozes**.

Enquanto o documento de requisitos estabelece o que o jogo deve possuir, este documento descreve como essas mecânicas devem funcionar durante a partida.

O gameplay deverá priorizar:

- controles simples;
- resposta rápida;
- movimentos previsíveis;
- aprendizado através da experimentação;
- exploração;
- desafios progressivos;
- baixa punição;
- cooperação entre Tico e Pipo;
- diversão.

O jogo deverá ser fácil para uma criança começar a jogar, mesmo que ela tenha pouca experiência com jogos de plataforma.

---

# 2. FILOSOFIA CENTRAL DO GAMEPLAY

A principal regra do gameplay será:

**REGRAS SIMPLES + COMBINAÇÕES INTERESSANTES**

A dificuldade não deverá surgir da necessidade de executar comandos complexos.

O jogador deverá compreender facilmente o que cada personagem consegue fazer.

A complexidade deverá surgir da combinação entre:

- movimento;
- salto;
- inimigos;
- plataformas;
- obstáculos;
- exploração;
- habilidades dos personagens;
- elementos do cenário.

O jogador deverá frequentemente pensar:

**"Qual habilidade posso usar aqui?"**

e não:

**"Qual é o comando para fazer isso?"**

---

# 3. CICLO PRINCIPAL DE GAMEPLAY

O ciclo básico será:

**EXPLORAR → SUPERAR → COLETAR → DESCOBRIR → AVANÇAR**

Durante uma fase, o jogador deverá:

1. observar o ambiente;
2. movimentar-se pelo cenário;
3. superar plataformas;
4. evitar ou enfrentar inimigos;
5. coletar nozes;
6. quebrar blocos;
7. encontrar itens;
8. descobrir segredos;
9. utilizar Tico ou Pipo conforme o desafio;
10. alcançar checkpoints;
11. chegar ao final da fase.

Esse ciclo deverá ser repetido com pequenas variações.

---

# 4. ESTRUTURA DOS CONTROLES

O jogo deverá utilizar poucos comandos.

Conceitualmente, serão necessários:

- esquerda;
- direita;
- pular;
- ação/habilidade;
- trocar personagem;
- pausa.

Dependendo da plataforma, diferentes botões físicos poderão ser utilizados.

O importante é manter a quantidade de ações reduzida.

---

# 5. MOVIMENTO BÁSICO

Tico e Pipo poderão movimentar-se horizontalmente.

O movimento deverá possuir:

- resposta rápida;
- aceleração suave;
- desaceleração previsível;
- animações claras;
- controle preciso.

O jogador deverá conseguir parar próximo da borda de uma plataforma sem dificuldade excessiva.

Os personagens não deverão parecer estar deslizando sobre o chão.

---

# 6. DIFERENÇA DE MOVIMENTO ENTRE OS PERSONAGENS

Tico e Pipo não deverão parecer apenas versões visuais diferentes do mesmo personagem.

Suas características deverão ser perceptíveis através do controle.

## TICO

Sensação:

**leve, rápido e ágil.**

Características:

- aceleração rápida;
- salto eficiente;
- boa movimentação aérea;
- facilidade para alcançar plataformas;
- capacidade de planar;
- facilidade para acessar espaços pequenos.

## PIPO

Sensação:

**forte, pesado e resistente.**

Características:

- movimentação ligeiramente mais pesada;
- salto menor;
- maior sensação de impacto;
- capacidade de empurrar objetos;
- capacidade de quebrar obstáculos;
- investida;
- ativação de mecanismos pesados.

A diferença deverá ser perceptível sem tornar Pipo desagradável de controlar.

---

# 7. GAMEPLAY DE TICO

Tico será o personagem principal.

Seu gameplay será baseado principalmente em:

**AGILIDADE + EXPLORAÇÃO**

Suas principais ações serão:

- correr;
- pular;
- controlar o movimento durante o salto;
- pular sobre inimigos;
- quebrar determinados blocos;
- coletar itens;
- planar;
- acessar espaços pequenos.

---

# 8. PULO DE TICO

O pulo será uma das mecânicas mais importantes do jogo.

Por isso, deverá ser desenvolvido e testado desde o primeiro protótipo.

O pulo deverá possuir:

- resposta imediata;
- trajetória previsível;
- altura adequada;
- boa sensação de controle;
- aterrissagem clara.

O jogador deverá sentir que possui controle sobre o personagem.

---

# 9. ALTURA VARIÁVEL DO PULO

Sempre que tecnicamente adequado, o tempo que o jogador mantém o botão pressionado poderá influenciar a altura do salto.

Exemplo:

**toque rápido → salto menor**

**botão pressionado → salto maior**

Essa diferença não deverá ser extrema.

A criança deverá conseguir utilizar o pulo normalmente mesmo sem dominar essa técnica.

---

# 10. CONTROLE AÉREO

Enquanto estiver no ar, Tico poderá realizar pequenas correções horizontais.

Isso permitirá:

- corrigir saltos;
- alcançar plataformas;
- evitar obstáculos;
- melhorar a sensação de controle.

O controle aéreo não deverá permitir mudanças exageradas de direção.

---

# 11. TOLERÂNCIA NOS SALTOS

O jogo deverá possuir pequenas tolerâncias para evitar frustração.

Poderá existir uma pequena janela de tempo permitindo que o jogador ainda pule logo após sair da borda de uma plataforma.

Essa técnica é conhecida como:

**Coyote Time**

Também poderá existir um pequeno armazenamento do comando de pulo.

Se o jogador pressionar o botão pouco antes de tocar o chão, o personagem poderá executar o salto assim que aterrissar.

Essa técnica é conhecida como:

**Jump Buffer**

Esses sistemas deverão ser discretos.

O jogador não precisa saber que existem.

Seu objetivo será simplesmente tornar os controles mais agradáveis.

---

# 12. PLANAR COM TICO

A cauda de Tico funcionará como um pequeno planador.

Quando Tico estiver no ar, o jogador poderá ativar a habilidade.

Ao planar:

- a velocidade de queda será reduzida;
- Tico continuará podendo se mover horizontalmente;
- saltos maiores poderão ser realizados.

Representação conceitual:

**PULAR → CAIR → PLANAR → ATERRISSAR**

---

# 13. FUNÇÃO DO PLANAR

O planar deverá ser utilizado principalmente para:

- atravessar espaços grandes;
- alcançar plataformas distantes;
- corrigir saltos;
- explorar áreas;
- encontrar caminhos alternativos.

O planar não deverá eliminar completamente o desafio de plataforma.

---

# 14. ENSINANDO O PLANAR

A primeira área que exigir planar deverá ser segura.

Exemplo:

Tico encontra um pequeno espaço entre duas plataformas.

Caso caia, ele retorna facilmente e pode tentar novamente.

Depois:

- espaço um pouco maior;
- combinação com plataforma;
- combinação com inimigos;
- combinação com exploração.

Progressão:

**APRENDER → PRATICAR → COMBINAR**

---

# 15. PULAR SOBRE INIMIGOS

Tico poderá derrotar determinados inimigos pulando sobre eles.

Ao acertar um inimigo por cima:

1. o inimigo recebe o impacto;
2. uma animação é executada;
3. um efeito sonoro é reproduzido;
4. Tico realiza um pequeno impulso para cima.

Esse pequeno impulso deverá deixar a ação divertida.

---

# 16. INIMIGOS QUE NÃO PODEM SER PISADOS

Alguns inimigos não poderão ser derrotados dessa maneira.

O exemplo principal será o ouriço.

Se possuir espinhos visíveis, o jogador deverá compreender:

**"Não devo pular sobre isso."**

A aparência deverá ensinar a regra antes que seja necessário utilizar texto.

---

# 17. QUEBRA DE BLOCOS COM TICO

Tico poderá quebrar determinados blocos.

Blocos frágeis deverão possuir aparência diferente dos blocos resistentes.

A quebra deverá produzir:

- animação;
- partículas;
- som;
- possível recompensa.

Quebrar blocos deverá transmitir sensação de impacto e recompensa.

---

# 18. GAMEPLAY DE PIPO

Pipo será baseado principalmente em:

**FORÇA + INTERAÇÃO COM O AMBIENTE**

Suas principais habilidades serão:

- movimentação;
- pulo;
- empurrar;
- quebrar;
- investir;
- ativar mecanismos;
- farejar;
- descobrir segredos.

---

# 19. EMPURRAR OBJETOS

Pipo poderá empurrar determinados objetos.

Exemplos:

- pedras;
- troncos;
- caixas;
- plataformas;
- mecanismos.

Esses objetos poderão ser utilizados para:

- criar plataformas;
- bloquear água;
- ativar mecanismos;
- abrir caminhos;
- alcançar lugares.

---

# 20. INVESTIDA DE PIPO

Pipo poderá realizar uma investida.

Representação:

**PIPO → → → OBSTÁCULO**

Durante a investida:

- sua velocidade aumenta;
- sua animação muda;
- obstáculos específicos podem ser destruídos;
- determinados inimigos podem ser derrubados.

---

# 21. PREPARAÇÃO DA INVESTIDA

A investida deverá possuir uma pequena indicação antes ou durante sua execução.

Isso poderá incluir:

- mudança de postura;
- pequena animação;
- movimento das patas;
- efeito sonoro.

O objetivo é fazer a habilidade parecer poderosa e divertida.

---

# 22. IMPACTO DA INVESTIDA

Quando Pipo atingir um objeto destrutível:

- o objeto deverá reagir;
- partículas poderão aparecer;
- deverá existir efeito sonoro;
- poderá ocorrer pequeno movimento da câmera.

O efeito de câmera deverá ser discreto para não causar desconforto.

---

# 23. FARO DE PIPO

Pipo poderá detectar elementos escondidos.

Quando estiver próximo de algo secreto, poderá apresentar comportamento específico.

Exemplos:

- levantar o focinho;
- cheirar o ambiente;
- aparecer pequenas linhas ou partículas;
- produzir som característico.

Isso deverá comunicar:

**"Existe alguma coisa aqui."**

---

# 24. DESCOBRINDO SEGREDOS

O faro poderá revelar:

- nozes escondidas;
- blocos invisíveis;
- passagens;
- itens;
- caminhos alternativos;
- recompensas.

A criança deverá associar gradualmente:

**Pipo farejando = procurar alguma coisa próxima.**

---

# 25. TROCA ENTRE TICO E PIPO

Em fases específicas, o jogador poderá alternar entre os personagens.

A troca deverá utilizar apenas um comando.

Exemplo:

**TICO → botão de troca → PIPO**

**PIPO → botão de troca → TICO**

---

# 26. FEEDBACK DA TROCA

A troca deverá possuir feedback claro.

Poderão ser utilizados:

- pequena animação;
- efeito visual;
- som;
- alteração do indicador do personagem.

A troca deverá ser rápida.

O jogador não deverá precisar abrir menus.

---

# 27. OBSTÁCULOS DE PERSONAGEM

Alguns desafios deverão comunicar claramente qual personagem é mais adequado.

Exemplos:

### Rocha pesada

**Pipo**

### Passagem estreita

**Tico**

### Grande distância

**Tico + planar**

### Parede quebrável pesada

**Pipo + investida**

### Objeto escondido

**Pipo + faro**

O cenário deverá comunicar essas regras visualmente.

---

# 28. COOPERAÇÃO

Alguns desafios poderão utilizar os dois personagens em sequência.

Exemplo:

1. Pipo empurra uma pedra;
2. a pedra cria uma plataforma;
3. Tico sobe na plataforma;
4. Tico alcança uma área elevada;
5. Tico ativa um mecanismo;
6. o caminho de Pipo é liberado.

A cooperação deverá reforçar a amizade entre os personagens através do gameplay.

---

# 29. INIMIGOS

Os inimigos deverão possuir padrões simples.

Cada inimigo deverá inicialmente ensinar uma única ideia.

Exemplo:

**Lesma → pular**

**Ouriço → observar**

**Corvo → observar o alto**

**Cobra → cuidado com esconderijos**

**Castor → desviar de projéteis**

Depois que essas regras forem aprendidas, os inimigos poderão aparecer combinados.

---

# 30. TELEGRAMAÇÃO DE ATAQUES

Ataques perigosos deverão possuir algum aviso antes de acontecer.

Exemplos:

- inimigo muda de posição;
- animação de preparação;
- objeto começa a se mover;
- efeito sonoro;
- brilho;
- pequena pausa.

A criança deverá possuir tempo suficiente para reagir.

---

# 31. DANO

Ao tocar em um inimigo perigoso ou obstáculo:

1. o personagem perde um coração;
2. reage ao impacto;
3. recebe pequena proteção temporária;
4. continua jogando.

O jogo deverá evitar interromper excessivamente a partida.

---

# 32. INVULNERABILIDADE TEMPORÁRIA

Depois de receber dano, o personagem ficará temporariamente protegido.

Durante esse período poderá:

- piscar;
- ficar parcialmente transparente;
- possuir pequeno efeito visual.

Isso evita que o jogador perca vários corações rapidamente ao encostar no mesmo inimigo.

---

# 33. PERDA DE TODOS OS CORAÇÕES

Quando todos os corações forem perdidos:

- o personagem executará uma animação amigável;
- não haverá representação de morte realista;
- a tela realizará pequena transição;
- o jogador retornará ao checkpoint.

A transição deverá ser rápida.

---

# 34. CHECKPOINTS

Checkpoints deverão aparecer em fases maiores.

Eles deverão possuir aparência facilmente reconhecível.

Exemplo conceitual:

uma pequena bandeira, flor especial, árvore brilhante ou outro elemento relacionado à floresta.

Ao ativar:

- animação;
- som;
- confirmação visual.

---

# 35. COLETA DE NOZES

As nozes serão o principal elemento coletável.

Ao coletar uma noz:

- ela desaparece do cenário;
- ocorre pequena animação;
- efeito sonoro é reproduzido;
- contador aumenta.

A ação deverá ser rápida e satisfatória.

---

# 36. LINHAS DE NOZES

Nozes poderão ser utilizadas também para orientar o jogador.

Exemplo:

**🌰 🌰 🌰 🌰 →**

Uma sequência de nozes poderá indicar:

- direção;
- trajetória de salto;
- caminho seguro;
- local interessante.

Dessa maneira, recompensas também ajudam a ensinar a fase.

---

# 37. NOZES EM LOCAIS DE RISCO

Algumas nozes poderão indicar oportunidades opcionais.

Exemplo:

caminho normal embaixo;

nozes acima de plataformas.

A criança poderá decidir explorar ou continuar pelo caminho principal.

---

# 38. SEGREDOS

Segredos deverão recompensar curiosidade.

Pistas poderão incluir:

- pequena abertura;
- parede diferente;
- nozes apontando caminho;
- comportamento de Pipo;
- som;
- elemento visual incomum.

Os segredos deverão parecer descobertas e não requisitos obrigatórios.

---

# 39. PLATAFORMAS MÓVEIS

Plataformas móveis deverão possuir movimento previsível.

Inicialmente:

**esquerda ↔ direita**

Depois:

**cima ↕ baixo**

Somente posteriormente poderão existir trajetórias mais elaboradas.

---

# 40. ÁGUA

A água será importante principalmente no Rio das Pedras.

Dependendo da implementação escolhida, poderá:

- impedir passagem;
- fazer o personagem retornar à plataforma;
- possuir correnteza;
- movimentar objetos.

A água não deverá possuir representação assustadora de afogamento.

---

# 41. QUEDAS

Buracos e grandes quedas poderão funcionar como obstáculos.

Ao cair:

- pequena animação;
- transição rápida;
- retorno ao checkpoint ou ponto seguro.

Evitar longas sequências de queda.

---

# 42. OBJETIVO DA FASE

O jogador deverá compreender claramente que precisa avançar.

O objetivo padrão será:

**chegar ao final da fase.**

Objetivos adicionais poderão incluir:

- encontrar nozes;
- libertar personagem;
- ativar mecanismo;
- atravessar região;
- encontrar Pipo;
- recuperar item.

---

# 43. FINAL DA FASE

O final deverá ser facilmente identificável.

Ao alcançar o objetivo:

- controle poderá ser temporariamente interrompido;
- animação de comemoração será executada;
- música ou efeito especial será reproduzido;
- resultados poderão aparecer.

A conclusão deverá transmitir sensação de conquista.

---

# 44. TELA DE RESULTADOS

A tela de resultados deverá ser simples.

Poderá mostrar:

**FASE CONCLUÍDA**

Nozes:

**🌰 42 / 50**

Nozes especiais:

**⭐ 2 / 3**

Segredos:

**? 1 / 2**

Não será necessário apresentar muitas estatísticas.

---

# 45. RECOMPENSA POR EXPLORAÇÃO

O jogador não deverá precisar coletar tudo para continuar.

Jogadores curiosos poderão receber recompensas adicionais.

Isso permite dois estilos:

**jogador que quer avançar**

e

**jogador que gosta de explorar.**

Ambos deverão conseguir aproveitar o jogo.

---

# 46. DIFICULDADE

A dificuldade deverá aumentar gradualmente.

Nunca deverá ocorrer grande aumento repentino sem preparação.

Progressão recomendada:

**1. mecânica isolada**

**2. mecânica repetida**

**3. pequena variação**

**4. combinação com outra mecânica**

**5. desafio utilizando as duas**

---

# 47. DIFICULDADE NÃO DEVE SIGNIFICAR CONTROLES DIFÍCEIS

A dificuldade deverá surgir de situações.

Exemplo ruim:

exigir sequência complicada de cinco botões.

Exemplo adequado:

utilizar corretamente salto + planar para alcançar uma plataforma.

---

# 48. SISTEMA DE AJUDA NATURAL

O jogo poderá ajudar jogadores que apresentarem dificuldade.

Exemplo:

Se o jogador falhar várias vezes no mesmo salto:

- mostrar discretamente a habilidade necessária;
- posicionar nozes indicando a trajetória;
- permitir que Pipo faça uma pequena indicação;
- apresentar dica curta.

A ajuda não deverá ridicularizar ou punir o jogador.

---

# 49. ENSINO SEM TEXTO

Sempre que possível:

**MOSTRAR EM VEZ DE EXPLICAR.**

Exemplo:

Para ensinar que Pipo quebra uma parede:

1. colocar Pipo próximo;
2. mostrar parede rachada;
3. posicionar espaço para investida;
4. permitir que o jogador experimente.

Isso é preferível a apresentar:

"Pressione X para quebrar paredes."

Textos poderão complementar a experiência, mas não deverão ser a única forma de ensino.

---

# 50. RITMO DAS FASES

As fases deverão alternar momentos.

Exemplo:

**Exploração**

↓  

**Pequeno desafio**

↓  

**Recompensa**

↓  

**Plataformas**

↓  

**Inimigos**

↓  

**Área tranquila**

↓  

**Segredo**

↓  

**Novo desafio**

Essa alternância evita que toda a fase tenha a mesma intensidade.

---

# 51. ÁREAS DE DESCANSO

Após desafios mais difíceis, poderá existir uma pequena área segura.

Ela poderá conter:

- nozes;
- checkpoint;
- personagem;
- elemento visual interessante;
- pequena interação.

Isso ajuda a controlar o ritmo.

---

# 52. CHEFES

Chefes deverão funcionar como testes das mecânicas aprendidas.

Eles não deverão depender principalmente de reflexos extremamente rápidos.

O jogador deverá:

1. observar;
2. compreender o padrão;
3. identificar oportunidade;
4. agir.

---

# 53. ESTRUTURA DE BATALHA DE CHEFE

Modelo recomendado:

**CHEFE ATACA**

↓

**JOGADOR OBSERVA**

↓

**CHEFE FICA VULNERÁVEL**

↓

**JOGADOR ATACA**

↓

**CHEFE MUDA O PADRÃO**

↓

**REPETIR**

Cada mudança deverá ser gradual.

---

# 54. MESTRE CORVO

A batalha final deverá utilizar mecânicas aprendidas durante a aventura.

Tico poderá precisar:

- pular;
- desviar;
- planar;
- alcançar plataformas.

Pipo poderá precisar:

- destruir obstáculos;
- empurrar objetos;
- utilizar investida;
- ativar mecanismos.

O desafio deverá representar a união das habilidades dos dois personagens.

---

# 55. GAMEPLAY DO PRIMEIRO PROTÓTIPO

Este é o protótipo completo integrado na etapa 6 de `08_roadmap.md`.
A cena vazia da etapa 0 e o Tico Playground do marco 1 são passos anteriores.

O primeiro protótipo deverá ser pequeno.

A fase poderá possuir aproximadamente esta sequência:

**INÍCIO**

↓

Movimentação

↓

Primeiras nozes

↓

Pequeno salto

↓

Plataformas

↓

Lesma

↓

Bloco quebrável

↓

Mais nozes

↓

Encontro com Pipo

↓

Troca de personagem

↓

Bloco pesado

↓

Pipo utiliza força

↓

Pequeno desafio utilizando Tico

↓

Pequeno desafio utilizando Pipo

↓

Final da fase

---

# 56. OBJETIVO DO PRIMEIRO PROTÓTIPO

O primeiro protótipo deverá validar principalmente:

### TICO

- movimento;
- aceleração;
- desaceleração;
- pulo;
- controle aéreo;
- colisões.

### PIPO

- movimento;
- sensação de peso;
- força;
- quebra de obstáculo;
- troca de personagem.

### MUNDO

- plataformas;
- blocos;
- nozes;
- inimigo;
- checkpoint;
- final da fase.

---

# 57. O QUE NÃO É PRIORIDADE NO PRIMEIRO PROTÓTIPO

Não será prioridade inicialmente:

- gráficos finais;
- animações finais;
- história completa;
- todos os inimigos;
- todos os mundos;
- chefes;
- cosméticos;
- menus complexos;
- grande quantidade de fases.

Primeiro deverá ser validada a pergunta:

**É divertido controlar Tico e Pipo?**

Se a resposta for positiva, o restante do jogo poderá ser construído sobre essa base.

---

# 58. ORDEM RECOMENDADA DE IMPLEMENTAÇÃO DO GAMEPLAY

## ETAPA 1

Tico:

- andar;
- correr;
- pular;
- colisões.

## ETAPA 2

Câmera e plataformas.

## ETAPA 3

Nozes e coleta.

## ETAPA 4

Primeiro inimigo.

## ETAPA 5

Dano e corações.

## ETAPA 6

Blocos.

## ETAPA 7

Planar.

## ETAPA 8

Pipo.

## ETAPA 9

Força e obstáculos pesados.

## ETAPA 10

Investida.

## ETAPA 11

Troca Tico/Pipo.

## ETAPA 12

Faro e segredos.

## ETAPA 13

Checkpoint.

## ETAPA 14

Final da fase.

---

# 59. MÉTRICA PRINCIPAL DE QUALIDADE

Antes de adicionar grande quantidade de conteúdo, deverão ser avaliadas quatro perguntas:

**Tico é divertido de controlar?**

**Pipo é divertido de controlar?**

**É fácil compreender a diferença entre eles?**

**Trocar entre os dois cria situações interessantes?**

Essas questões são mais importantes inicialmente do que a quantidade de fases, inimigos ou itens existentes.

---

# 60. REGRA PARA NOVAS MECÂNICAS

Antes de adicionar uma nova mecânica, verificar:

1. É fácil de compreender?
2. É divertida?
3. Pode ser ensinada visualmente?
4. Precisa realmente de um novo botão?
5. Pode utilizar um comando já existente?
6. Combina com Tico ou Pipo?
7. Cria novas possibilidades de fases?
8. Pode ser combinada com mecânicas existentes?
9. Funciona para o público infantil?
10. Torna o jogo melhor ou apenas mais complexo?

Caso a mecânica apenas aumente a complexidade sem acrescentar novas possibilidades interessantes, ela deverá ser reconsiderada.

---

# 61. PRINCÍPIO FINAL DE GAMEPLAY

O jogador deverá aprender as regras naturalmente enquanto joga.

O jogo deverá começar simples:

**ANDAR**

↓

**PULAR**

↓

**COLETAR**

↓

**SUPERAR INIMIGOS**

↓

**QUEBRAR**

↓

**PLANAR**

↓

**CONHECER PIPO**

↓

**USAR FORÇA**

↓

**TROCAR PERSONAGENS**

↓

**COOPERAR**

↓

**COMBINAR HABILIDADES**

A experiência deverá crescer progressivamente sem perder a simplicidade inicial.

A principal característica do gameplay de **Tico e a Floresta das Nozes** deverá ser:

**FÁCIL DE ENTENDER, DIVERTIDO DE CONTROLAR E INTERESSANTE DE DOMINAR.**

---

## MECÂNICAS IMPLEMENTADAS NA E14

Na versão 0.23.0, o botão de ação de Tico executa uma caudada curta quando ele
está no chão. O golpe possui preparação, janela ativa e recuperação; não desloca
o personagem, não atravessa paredes e não substitui a necessidade de Pipo em
pedras, mecanismos e obstáculos resistentes. Lesmas e inimigos voadores podem
ser derrotados. Espinhos e guardiões preservam as regras anteriores.

Pipo continua usando o mesmo botão para a investida. A troca é bloqueada enquanto
qualquer uma das ações está em andamento.

**FIM DO DOCUMENTO**
## BACKTRACKING IMPLEMENTADO NA E15

Após o resgate global de Pipo, revisitas às fases 1-1 e 1-2 oferecem um desvio
cooperativo opcional. Pipo empurra uma pedra até a marca para abrir a grade; a
passagem de 64 unidades exige o corpo menor de Tico e termina em uma Noz Dourada.
O caminho principal passa sob o desvio, portanto a exploração nunca é necessária
para concluir a fase. Antes do resgate ou durante a primeira passagem, o conjunto
não é criado.
