# TICO E A FLORESTA DAS NOZES

# EVOLUÇÃO DO PROJETO

**Arquivo:** 13_evolucao.md
**Versão:** 1.1
**Status:** Planejamento de evolução — decisões aprovadas pelo usuário

## Base e identificação

Preservar os sistemas implementados até a etapa 9 do roadmap original e melhorá-los quando necessário. Saúde, dano, checkpoints, save, resgate de Pipo, troca, habilidades, mundos, áudio e PWA são a base existente. As mudanças abaixo ainda exigem implementação.

A sequência executável é **Evolução E00–E30**, em [14_etapas_evolucao.md](14_etapas_evolucao.md). Os nove grupos da seção 56 são frentes temáticas, não outra numeração de etapas. O histórico de [08_roadmap.md](08_roadmap.md) permanece preservado.

---

# 1. OBJETIVO DO DOCUMENTO

Este documento registra as principais alterações necessárias para a evolução de **Tico e a Floresta das Nozes**.

O projeto já possui uma base de gameplay funcional e divertida. Entretanto, a experiência atual ainda é relativamente curta e precisa evoluir para oferecer:

- maior duração;
- narrativa mais presente;
- sensação de aventura;
- progressão visível;
- exploração;
- desafios opcionais;
- dificuldade progressiva;
- recompensas relevantes;
- sistema de vidas;
- Game Over;
- maior participação de Pipo;
- melhor orientação para crianças;
- maior variedade de inimigos;
- maior sensação de descoberta;
- maior integração entre história e gameplay.

A evolução deverá preservar o princípio central do projeto:

> O jogo deve ser fácil de compreender, divertido para crianças e progressivamente desafiador.

---

# 2. NOVO LOOP PRINCIPAL DO JOGO

A estrutura geral deverá evoluir para:

ABERTURA NARRATIVA
        ↓
MAPA DO MUNDO
        ↓
FASE
        ↓
EXPLORAÇÃO
        ↓
ÁREAS OPCIONAIS
        ↓
DESAFIOS
        ↓
MOMENTO FINAL / CHEFE
        ↓
CORUJA
        ↓
RESULTADO DA FASE
        ↓
MAPA ATUALIZADO
        ↓
PRÓXIMA FASE

O jogador não deverá simplesmente avançar automaticamente de uma fase para outra.

O mapa será o elemento responsável por mostrar:

- onde Tico está;
- onde já esteve;
- fases concluídas;
- próxima fase;
- locais bloqueados;
- mundos;
- progresso da aventura.

---

# 3. ABERTURA NARRATIVA

O jogo deverá possuir uma animação introdutória antes do primeiro gameplay.

A abertura deverá apresentar o problema central da aventura.

## Sequência inicial

Tico vive normalmente em sua comunidade.

Quando sai para procurar alimento, percebe que existe muito menos comida do que deveria.

Ele procura nos locais habituais.

Não encontra.

Tenta novamente em outros lugares.

Também não encontra.

Tico percebe que alguma coisa está errada.

A falta de alimentos também começa a afetar outros moradores.

Tico decide procurar cada vez mais longe.

Ele deixa a região que conhece e entra em áreas desconhecidas da floresta.

Durante essa exploração encontra uma sábia Coruja em uma situação de perigo.

Tico ajuda a Coruja.

Depois de ser salva, ela explica que o desaparecimento dos alimentos não parece natural.

Existem sinais de que alguém está retirando alimentos de diferentes regiões da floresta.

A Coruja sabe que existe algo acontecendo, mas não deverá necessariamente revelar imediatamente toda a identidade e motivação do responsável.

Ela aponta a primeira direção que Tico deverá investigar.

Tico percebe que seu vilarejo continuará passando fome se ninguém fizer alguma coisa.

Apesar do perigo, decide continuar.

Assim começa a aventura.

---

# 4. NÃO REVELAR TODO O MISTÉRIO NO INÍCIO

A narrativa deverá evitar explicar imediatamente:

- quem é exatamente o chefão;
- onde está;
- como funciona sua operação;
- por que está roubando alimentos;
- qual é sua verdadeira motivação.

A Coruja poderá saber que existe alguém por trás do desaparecimento dos alimentos.

Entretanto, a descoberta completa deverá acontecer gradualmente.

Estrutura narrativa:

PROBLEMA
   ↓
PISTA
   ↓
INVESTIGAÇÃO
   ↓
NOVA PISTA
   ↓
DESCOBERTA
   ↓
NOVAS PERGUNTAS
   ↓
IDENTIDADE DO RESPONSÁVEL
   ↓
MOTIVAÇÃO
   ↓
CONFRONTO
   ↓
RESOLUÇÃO

Assim, a criança possui também uma motivação narrativa para continuar jogando:

> “Quero descobrir o que está acontecendo.”

---

# 5. MAPA DO MUNDO

**E06 implementada:** mapa ilustrado em quatro páginas para as 16 fases atuais,
com entrada da campanha, seleção de fases liberadas, replay e retorno após Game Over.
A ampliação dos resultados e animações de desbloqueio permanece na E07.
[Execução e validação](../tests/evolucao_e06.md).

Depois da animação inicial, o jogador deverá chegar ao mapa.

O mapa deverá ser ilustrado e fazer parte da experiência do jogo.

Não deverá funcionar apenas como menu de seleção de fases.

Inicialmente:

- Fase 1 desbloqueada;
- demais fases bloqueadas.

Exemplo conceitual:

VILAREJO
   │
   ● FASE 1
   │
   🔒
   │
   🔒
   │
   🌊 RIO
   │
   🔒
   │
   ⛰ MONTANHA
   │
   🔒
   │
   🌳 DESTINO FINAL

Depois de concluir a Fase 1:

FASE 1
CONCLUÍDA
   ↓
CORUJA
   ↓
NOVA ORIENTAÇÃO
   ↓
MAPA
   ↓
ANIMAÇÃO DE DESBLOQUEIO
   ↓
FASE 2 DISPONÍVEL

As demais continuam bloqueadas.

Este padrão deverá acompanhar toda a campanha.

---

# 6. PROGRESSO VISÍVEL NO MAPA

O mapa deverá comunicar visualmente o progresso.

Uma fase poderá estar em estados como:

BLOQUEADA

DISPONÍVEL

EM PROGRESSO

CONCLUÍDA

O mapa também poderá futuramente apresentar informações como:

- alimentos encontrados;
- Nozes Douradas;
- áreas secretas;
- chefe derrotado;
- percentual de exploração.

O objetivo é fazer a criança perceber claramente:

> “Estou avançando na aventura.”

---

# 7. TUTORIAL CONTEXTUAL

**Base implementada na E04 (0.12.0):** HUD compacto, placas substituídas por
dicas temporárias e cinco registros de tutorial persistentes. As fases atuais
foram aproveitadas; a expansão de seu conteúdo continua nas etapas seguintes.
[Regras e validação](../tests/evolucao_e04.md).

A primeira fase será responsável por ensinar os principais conceitos do jogo.

Entretanto, deverão ser removidos os textos fixos permanentemente exibidos durante o gameplay.

O jogo passará a utilizar **indicações contextuais**.

Uma indicação deverá aparecer quando o jogador encontrar determinada situação pela primeira vez.

Exemplo:

Ao aproximar-se do primeiro inimigo:

> Cuidado!  
> Pule sobre ele para derrotá-lo.

Ao encontrar um coração:

> Pegue o coração!  
> Ele recupera sua saúde.

Ao encontrar uma área que pode ser explorada:

> Parece que existe algo lá em cima...

Ao encontrar um elemento relacionado a uma habilidade:

> Tente usar sua cauda.

Depois que o jogador aprender determinada ação, a mensagem não deverá continuar aparecendo desnecessariamente.

---

# 8. REMOÇÃO DOS TEXTOS FIXOS

Os textos explicativos atualmente mantidos na tela durante o gameplay deverão ser removidos.

A interface deverá permanecer limpa.

A orientação acontecerá por:

- balões contextuais;
- símbolos;
- pequenas animações;
- efeitos visuais;
- elementos do cenário;
- comportamento dos personagens.

Princípio:

MOSTRAR
   ↓
INDICAR
   ↓
PERMITIR EXPERIMENTAR
   ↓
DEIXAR O JOGADOR JOGAR

O objetivo é evitar poluição visual e excesso de leitura.

---

# 9. ÁREAS SECUNDÁRIAS OPCIONAIS

Cada fase deverá possuir uma ou mais possibilidades de exploração fora do caminho principal.

Essas áreas não serão obrigatórias para completar a fase.

Exemplo para a primeira fase:

CAMINHO PRINCIPAL
       │
       ├── ÁRVORE
       │
       │    ↓
       │  GALHOS
       │    ↓
       │  SUBIDA
       │    ↓
       │  ÁREA ESPECIAL
       │    ↓
       │  DESAFIOS
       │    ↓
       │  INIMIGOS
       │    ↓
       │  RECOMPENSAS
       │    ↓
       │  PORTAL
       │    ↓
       └── RETORNO AO CAMINHO PRINCIPAL

O jogador poderá ignorar a árvore e continuar.

Entretanto, o jogador curioso será recompensado.

---

# 10. DIFERENTES TIPOS DE ÁREAS OPCIONAIS

Nem todas as áreas opcionais deverão funcionar da mesma maneira.

Poderão existir:

## Área de plataforma

Focada em saltos e precisão.

## Área de exploração

O jogador deverá descobrir como chegar ao objetivo.

## Área de combate

Possui maior concentração de inimigos.

## Área de coleta

O objetivo será encontrar alimentos ou outros objetos.

## Área de tempo

O jogador deverá completar determinado percurso.

## Área de quebra-cabeça

Exigirá interação com elementos do cenário.

## Área de cooperação

Depois da introdução de Pipo, determinadas áreas poderão exigir a utilização das habilidades dos dois personagens.

A variedade impedirá que exploração opcional se torne repetitiva.

---

# 11. RETORNO DAS ÁREAS OPCIONAIS

Ao completar uma área secundária deverá existir uma forma clara de retornar ao percurso principal.

Uma possibilidade será utilizar um portal.

Funcionamento:

ENTRA NA ÁREA OPCIONAL
        ↓
COMPLETA O DESAFIO
        ↓
RECEBE RECOMPENSA
        ↓
ENCONTRA PORTAL
        ↓
RETORNA AO PONTO DA FASE
        ↓
CONTINUA O CAMINHO PRINCIPAL

O retorno deverá evitar que o jogador tenha de percorrer novamente todo o caminho da área secundária.

---

# 12. RECOMPENSAS MAIS IMPORTANTES

A exploração deverá valer a pena.

As recompensas poderão incluir:

- alimentos;
- nozes;
- corações;
- vidas;
- Nozes Douradas;
- itens especiais;
- itens narrativos;
- desbloqueios.

Exemplo:

FASE 1

Alimentos: 37 / 50

Nozes Douradas: 2 / 3

Área secreta: encontrada

Fase: concluída

As recompensas deverão incentivar exploração sem obrigar o jogador a encontrar tudo para continuar a história.

---

# 13. NOZES DOURADAS

Adicionar a possibilidade de um coletável especial.

Exemplo:

3 Nozes Douradas por fase.

Elas deverão ficar em:

- áreas escondidas;
- caminhos alternativos;
- desafios opcionais;
- locais que exijam domínio das habilidades.

As Nozes Douradas poderão futuramente desbloquear:

- artes;
- conteúdos extras;
- áreas especiais;
- itens cosméticos;
- desafios.

Não deverão ser obrigatórias para completar a campanha principal.

---

# 14. PROGRESSÃO DE DIFICULDADE

A dificuldade deverá aumentar durante a aventura.

Entretanto:

**O JOGO CONTINUA SENDO DESTINADO A CRIANÇAS.**

O objetivo não é criar dificuldade extrema.

A progressão deverá acontecer de maneira gradual.

## Início

- inimigos lentos;
- poucos inimigos;
- inimigos isolados;
- plataformas maiores;
- desafios simples;
- checkpoints próximos.

## Meio

Combinações começam a aparecer:

INIMIGO
+
BURACO

ou:

INIMIGO
+
PLATAFORMA MÓVEL

ou:

DOIS TIPOS DE INIMIGOS

## Final

Combinação de habilidades:

MOVIMENTO
+
SALTO
+
PLANAR
+
INIMIGOS
+
OBSTÁCULOS
+
AMBIENTE

A dificuldade deverá surgir principalmente da combinação de elementos aprendidos anteriormente.

---

# 15. EVOLUÇÃO DOS INIMIGOS

Não aumentar a dificuldade apenas adicionando saúde aos mesmos inimigos.

Deverão existir novos comportamentos.

Exemplos:

## Lesma

- lenta;
- previsível;
- adequada ao início.

## Besouro

- mais rápido;
- exige reação maior.

## Aranha

- movimentação vertical;
- ameaça vinda de outra direção.

## Morcego

- inimigo aéreo.

## Porco-espinho

- possui mecanismo defensivo;
- exige observar antes de atacar.

## Corvo patrulheiro

- identifica Tico;
- persegue por determinada distância.

Posteriormente, diferentes inimigos poderão aparecer juntos.

Isso aumenta o desafio sem depender apenas de aumentar a vida dos adversários.

---

# 16. INIMIGOS MAIS FORTES

Além da variedade, algumas versões mais avançadas poderão possuir:

- maior velocidade;
- maior saúde;
- novos padrões;
- maior alcance;
- menor intervalo entre ações.

Entretanto, deverá existir cuidado com inimigos que apenas demoram muito para serem derrotados.

Princípio:

> Mais difícil não deve significar apenas mais demorado.

---

# 17. QUANTIDADE PROGRESSIVA DE INIMIGOS

A quantidade de ameaças também poderá aumentar.

Início:

1 inimigo em situação controlada.

Depois:

2 inimigos.

Mais adiante:

INIMIGO TERRESTRE
+
INIMIGO AÉREO

Posteriormente:

INIMIGOS
+
OBSTÁCULOS
+
PLATAFORMAS

O jogador deverá receber tempo suficiente para aprender cada elemento antes das combinações.

---

# 18. CHEFES COMO PROVA DO APRENDIZADO

Os chefes não deverão funcionar simplesmente como inimigos com muita saúde.

Cada chefe deverá utilizar conceitos apresentados anteriormente.

Estrutura:

OBSERVAR
   ↓
DESVIAR
   ↓
DESCOBRIR PADRÃO
   ↓
IDENTIFICAR VULNERABILIDADE
   ↓
UTILIZAR HABILIDADE
   ↓
ATACAR

Uma estrutura de três etapas poderá ser utilizada:

ETAPA 1
Aprender padrão

ETAPA 2
Variação

ETAPA 3
Combinação

O chefe deverá ser desafiador, mas compreensível para crianças.

---

# 19. CORUJA COMO MENTORA

A Coruja será a mentora recorrente, aliada de Tico. Não será chefe. O chefe aéreo da Montanha passa a ser o **Gavião da Montanha**, preservando o tema de vento e verticalidade.

Funções:

- orientar Tico;
- fornecer pistas;
- explicar regiões;
- encorajar;
- contextualizar novas mecânicas;
- conduzir a narrativa;
- indicar o próximo destino.

Entretanto:

> A Coruja orienta. Tico resolve.

Ela não deverá retirar o protagonismo de Tico.

---

# 20. CONVERSA APÓS AS FASES IMPORTANTES

Ao concluir uma fase importante ou derrotar um chefe, Tico deverá encontrar novamente a Coruja.

A conversa poderá:

- reconhecer a conquista;
- revelar nova pista;
- avançar a história;
- encorajar Tico;
- apontar o próximo caminho.

Depois:

DIÁLOGO
   ↓
MAPA
   ↓
PROGRESSO ATUALIZADO
   ↓
NOVA FASE DESBLOQUEADA

Essa estrutura ajudará a criar continuidade narrativa entre as fases.

---

# 21. PIPO ENTRA NA AVENTURA

Pipo deverá receber uma apresentação narrativa própria.

Ele não deverá simplesmente aparecer disponível como personagem.

Pipo também poderá ser vítima da falta de alimentos.

Tico poderá encontrá-lo durante a aventura.

A situação deverá mostrar que Pipo também está sofrendo as consequências do problema.

Tico ajuda Pipo.

Depois de entender a missão de Tico, Pipo decide acompanhá-lo.

Isso cria uma motivação para a formação da dupla.

---

# 22. ANIMAÇÃO DE APRESENTAÇÃO DE PIPO

Quando Pipo entrar na história, deverá existir uma pequena animação.

A animação deverá explicar visualmente:

- quem é Pipo;
- por que está ali;
- por que decide acompanhar Tico;
- que ele possui habilidades diferentes.

O jogo poderá demonstrar isso imediatamente.

Exemplo:

Tico tenta mover uma pedra.

Não consegue.

Pipo aproxima-se.

Empurra a pedra facilmente.

Depois Pipo tenta alcançar uma plataforma alta.

Não consegue.

Tico salta e alcança.

Assim, sem depender de grande quantidade de texto:

TICO = AGILIDADE

PIPO = FORÇA

---

# 23. DIFERENÇA DE TAMANHO ENTRE TICO E PIPO

A diferença entre os personagens deverá ser perceptível também visualmente.

Tico:

- menor;
- mais leve;
- mais ágil;
- salta melhor;
- consegue planar;
- alcança espaços menores.

Pipo:

- maior;
- mais pesado;
- mais forte;
- movimenta objetos;
- quebra obstáculos;
- ativa mecanismos relacionados a peso.

A diferença de tamanho deverá fazer parte do level design.

---

# 24. COOPERAÇÃO ENTRE TICO E PIPO

Depois da introdução de Pipo, alguns desafios poderão exigir alternância entre personagens.

Exemplo:

PEDRA BLOQUEIA PASSAGEM
        ↓
PIPO MOVE PEDRA
        ↓
PASSAGEM ABERTA
        ↓
PLATAFORMA ALTA
        ↓
TICO SOBE
        ↓
TICO ATIVA MECANISMO
        ↓
CAMINHO LIBERADO

Isso reforça o tema central:

> Habilidades diferentes funcionam melhor quando cooperam.

---

# 25. BACKTRACKING CONTROLADO

Depois do resgate, Pipo fica desbloqueado globalmente na campanha e pode ser usado ao revisitar as fases iniciais. Antes desse evento, essas fases permitem apenas Tico. O estado local de uma fase antiga não pode remover o desbloqueio global.

Preservar o resgate jogável existente em 1-3 e melhorar sua apresentação. Ao revisitar a cena após o desbloqueio, não repetir o resgate nem conceder novamente suas recompensas.

Algumas fases anteriores poderão possuir áreas que não eram acessíveis inicialmente.

Exemplo:

Na Fase 1 existe uma grande pedra.

Tico não consegue movê-la.

Mais tarde Pipo entra na equipe.

Ao retornar:

PIPO
   ↓
MOVE A PEDRA
   ↓
PASSAGEM
   ↓
ÁREA SECRETA
   ↓
RECOMPENSA

O jogo não deverá se transformar obrigatoriamente em um Metroidvania.

O objetivo é apenas recompensar a curiosidade e dar nova utilidade às fases anteriores.

---

# 26. CHECKPOINTS

Como as fases ficarão maiores, checkpoints tornam-se mais importantes.

Utilizar principalmente:

- após trechos difíceis;
- antes de chefes;
- depois de desafios importantes;
- antes de áreas de maior risco.

O checkpoint deverá transmitir:

> “Você conseguiu chegar até aqui.”

Entretanto, checkpoint não substitui o sistema de vidas.

---

# 27. SISTEMA DE SAÚDE

Saúde e vidas serão conceitos diferentes.

## Saúde

Representa quanto dano Tico ainda pode receber antes de morrer.

Exemplo:

❤️ ❤️ ❤️

Recebe dano:

❤️ ❤️

Encontra coração:

❤️ ❤️ ❤️

Ao perder toda a saúde:

TICO MORRE.

A partir desse momento será verificado o número de vidas disponíveis.

---

# 28. SISTEMA DE VIDAS

O jogo deverá possuir vidas.

Exemplo:

TICO × 3

Ao perder toda a saúde:

SAÚDE = 0
   ↓
PERDE UMA VIDA
   ↓
AINDA POSSUI VIDAS?
   │
   ├── SIM → retorna ao início/checkpoint conforme regra
   │
   └── NÃO → GAME OVER

O sistema deverá aumentar a importância das recompensas.

O jogador poderá encontrar vidas durante a exploração.

---

# 29. RECOMPENSAS RELACIONADAS À SOBREVIVÊNCIA

Algumas recompensas deverão possuir função direta.

## Coração

Recupera saúde.

## Vida extra

Aumenta o número de vidas disponíveis.

## Alimentos

Poderão contribuir para algum sistema de recompensa.

Uma possibilidade futura:

determinada quantidade de alimentos coletados concede uma vida extra.

Exemplo:

100 ALIMENTOS
   ↓
+1 VIDA

Esse valor deverá ser definido através de testes.

---

# 30. MORTE DO PERSONAGEM

Quando a saúde chegar a zero:

1. executar animação curta;
2. reduzir uma vida;
3. verificar vidas restantes.

Se ainda existirem vidas, o jogador poderá retornar:

- ao checkpoint;
- ou ao início da fase;

conforme a regra definida para aquela situação.

A punição deverá existir, mas não ser excessivamente frustrante para crianças.

---

# 31. GAME OVER

Ao esgotar as vidas compartilhadas pela dupla, apresentar Game Over e retornar ao mapa do mundo anterior ao da fase em que ocorreu a derrota. No Mundo 1, permanecer no mapa do Mundo 1. Restaurar as vidas ao valor inicial configurado.

Preservar fases desbloqueadas e concluídas, personagens liberados e conquistas permanentes. O retorno muda a localização no mapa; não bloqueia novamente os mundos já acessíveis nem apaga a campanha. A seleção inicial aponta para a primeira fase do mundo de retorno. Morte com vidas restantes continua usando o checkpoint da fase.

Salvar o estado resultante antes de permitir nova seleção; fechar e reabrir deve manter esse resultado. Quantidade inicial de vidas e frequência das recompensas serão balanceadas em testes.

---

# 32. IMPORTÂNCIA DAS VIDAS PARA A EXPLORAÇÃO

O sistema de vidas cria uma motivação adicional para visitar áreas opcionais.

O jogador poderá pensar:

> “Talvez exista uma vida extra naquela árvore.”

Assim:

EXPLORAÇÃO
   ↓
DESAFIO
   ↓
RECOMPENSA
   ↓
MAIOR CHANCE DE SOBREVIVER

Isso dá valor prático aos caminhos secundários.

---

# 33. SISTEMA DE AJUDA ADAPTATIVA

O jogo poderá identificar dificuldades recorrentes.

Exemplo:

Tico caiu várias vezes no mesmo local.

Depois de algumas tentativas:

> Dica: mantenha o botão de pulo pressionado para planar.

Outro exemplo:

O jogador tenta atacar um inimigo incorretamente repetidas vezes.

O jogo poderá apresentar uma pequena indicação.

O objetivo não é jogar pela criança.

É ajudá-la a aprender.

---

# 34. FEEDBACK VISUAL E SONORO

Toda ação importante deverá possuir resposta clara.

## Coletar alimento

- som;
- animação;
- contador.

## Coletar vida

- efeito especial;
- som distinto;
- atualização do contador.

## Recuperar saúde

- animação;
- som;
- atualização dos corações.

## Receber dano

- animação;
- som;
- invulnerabilidade temporária.

## Descobrir segredo

- efeito;
- som especial;
- indicação discreta.

## Completar fase

- animação;
- música;
- tela de resultado.

## Desbloquear fase

- animação no mapa.

Esses detalhes são importantes para aumentar a sensação de qualidade.

---

# 35. TELA DE CONCLUSÃO DA FASE

Ao completar uma fase deverá existir uma tela curta de resultados.

Exemplo:

FASE CONCLUÍDA!

Alimentos: 43 / 50

Nozes Douradas: 2 / 3

Área secreta: encontrada

Vidas restantes: 4

Tempo: 08:42

Não utilizar classificações negativas como:

- ruim;
- nota baixa;
- fracasso.

O objetivo é mostrar:

- o que foi conquistado;
- o que ainda pode ser encontrado.

---

# 36. AUMENTO DA DURAÇÃO

As fases não deverão ser artificialmente alongadas.

A duração aumentará através de conteúdo significativo.

Cada fase poderá possuir:

CAMINHO PRINCIPAL
+
ÁREAS OPCIONAIS
+
SEGREDOS
+
COLETÁVEIS
+
INIMIGOS
+
DESAFIOS
+
NARRATIVA

O objetivo não é fazer o jogador simplesmente caminhar por mais tempo.

O objetivo é oferecer mais coisas interessantes para fazer.

---

# 37. FASES COMO JORNADAS

Deixar de pensar apenas:

> “15 fases.”

Pensar:

> “15 pequenas jornadas.”

Cada jornada deverá possuir:

- começo;
- desafio;
- exploração;
- descoberta;
- evolução;
- conclusão.

A faixa de 15–25 minutos é uma hipótese de planejamento, não um requisito de duração. Validar quando uma fase completa da evolução, com caminho principal e área opcional, estiver implementada. Medir o tempo com e sem exploração antes de estabelecer metas para as demais fases.

---

# 38. VILAREJO EVOLUTIVO

Adicionar uma representação visual do vilarejo de Tico.

No início:

- pouca comida;
- cestos vazios;
- animais preocupados;
- ambiente menos movimentado.

À medida que Tico recupera alimentos:

- alimentos aparecem;
- cestos começam a encher;
- animais ficam mais animados;
- novos elementos aparecem;
- o vilarejo se prepara para o inverno.

No final:

- comunidade recuperada;
- alimentos compartilhados;
- ambiente alegre;
- personagens reunidos.

O jogador deverá perceber:

> “Minhas ações estão mudando o mundo.”

---

# 39. PROGRESSO NARRATIVO E PROGRESSO VISUAL

Três progressões deverão acontecer simultaneamente.

## Progressão do jogador

- habilidades;
- domínio;
- exploração;
- desafios.

## Progressão narrativa

- pistas;
- descobertas;
- personagens;
- identidade do responsável;
- motivação;
- resolução.

## Progressão do mundo

- mapa desbloqueado;
- vilarejo recuperado;
- novos locais;
- personagens ajudados.

Essas progressões deverão se reforçar mutuamente.

---

# 40. VARIEDADE DE GAMEPLAY

Para manter o jogo divertido durante mais tempo, evitar que todas as fases sejam:

CORRER
+
PULAR
+
DERROTAR INIMIGOS

Adicionar variações como:

- perseguição;
- plataformas móveis;
- vento;
- água;
- objetos empurráveis;
- mecanismos;
- exploração vertical;
- caminhos alternativos;
- quebra-cabeças;
- desafios de Tico;
- desafios de Pipo;
- desafios combinados;
- áreas secretas.

---

# 41. DESIGN PARA CRIANÇAS

Mesmo com o aumento da dificuldade, manter:

- controles simples;
- objetivos claros;
- elementos grandes;
- leitura visual;
- mensagens curtas;
- feedback imediato;
- checkpoints adequados;
- dificuldade gradual.

A criança deverá sentir:

> “Isso é difícil, mas acho que consigo.”

E não:

> “Não sei o que tenho que fazer.”

---

# 42. GAME OVER E PÚBLICO INFANTIL

A regra aprovada é retornar ao mapa do mundo anterior, preservando desbloqueios e conquistas, conforme a seção 31. Testar compreensão, frustração e vontade de continuar com crianças. Ajustar quantidades de vidas e recompensas sem substituir silenciosamente a regra de retorno aprovada.

---

# 43. SALVAMENTO DO PROGRESSO

**E05 implementada:** formato V2 com migração dos saves existentes, consulta
de progresso e registros por fase de Nozes Douradas, eventos e vilarejo.
Conteúdo futuro começa sem conquistas artificiais. [Formato e validação](../tests/evolucao_e05.md).

Com mapa, fases desbloqueadas, coletáveis e evolução narrativa, o save deverá armazenar pelo menos:

- fase atual;
- fases desbloqueadas;
- fases concluídas;
- coletáveis;
- Nozes Douradas;
- áreas secretas;
- personagens desbloqueados;
- progresso narrativo;
- estado do vilarejo;
- configurações;
- tutoriais já apresentados.

Salvar também vidas compartilhadas, desbloqueio global de Pipo e mundo de retorno após Game Over. Migrar os saves existentes sem perder progresso; inferir Pipo desbloqueado a partir do resgate já registrado ou do acesso aos mundos posteriores.

---

# 44. TUTORIAIS JÁ VISUALIZADOS

As mensagens contextuais não deverão aparecer toda vez que o jogo for aberto.

Registrar informações como:

tutorial_enemy_seen

tutorial_heart_seen

tutorial_life_seen

tutorial_secret_seen

tutorial_glide_seen

tutorial_pipo_seen

Isso permitirá manter a experiência limpa depois que o conceito já tiver sido aprendido.

---

# 45. PROFISSIONALIZAÇÃO DA EXPERIÊNCIA

Além de adicionar conteúdo, o jogo deverá receber polimento.

Áreas importantes:

- transições;
- animações;
- sons;
- música;
- partículas;
- interface;
- telas de resultado;
- mapa;
- menus;
- feedback de dano;
- feedback de recompensa;
- transição entre personagens;
- carregamento;
- salvamento;
- Game Over.

Um jogo profissional não depende apenas da quantidade de fases.

Depende da qualidade das pequenas interações.

---

# 46. NOVA ESTRUTURA DA EXPERIÊNCIA

A experiência completa passa a seguir:

ABERTURA
   ↓
TICO PROCURA COMIDA
   ↓
PERCEBE A ESCASSEZ
   ↓
VAI CADA VEZ MAIS LONGE
   ↓
ENCONTRA E SALVA A CORUJA
   ↓
RECEBE A PRIMEIRA PISTA
   ↓
DECIDE AJUDAR O VILAREJO
   ↓
MAPA
   ↓
FASE 1
   ├── tutorial contextual
   ├── caminho principal
   ├── inimigos
   ├── coletáveis
   ├── saúde
   ├── vidas
   ├── área opcional
   └── segredos
   ↓
CONCLUSÃO
   ↓
CORUJA
   ↓
MAPA
   ↓
NOVA FASE
   ↓
NOVAS PISTAS
   ↓
NOVOS DESAFIOS
   ↓
PIPO É ENCONTRADO
   ↓
ANIMAÇÃO DE APRESENTAÇÃO
   ↓
TICO + PIPO
   ↓
NOVAS POSSIBILIDADES
   ↓
MUNDOS MAIS DIFÍCEIS
   ↓
DESCOBERTA DO RESPONSÁVEL
   ↓
CHEFÃO FINAL
   ↓
RESOLUÇÃO
   ↓
ALIMENTOS DEVOLVIDOS
   ↓
VILAREJO RECUPERADO

---

# 47. PRINCÍPIO DE PROGRESSÃO

O jogo deverá seguir:

APRESENTAR
   ↓
ENSINAR
   ↓
PERMITIR EXPERIMENTAR
   ↓
PRATICAR
   ↓
COMBINAR
   ↓
DESAFIAR
   ↓
RECOMPENSAR

Nunca:

DESAFIAR
   ↓
EXPLICAR DEPOIS

---

# 48. PRINCÍPIO DE EXPLORAÇÃO

O jogador não deverá ser obrigado a explorar tudo.

Mas deverá perceber que:

> Explorar normalmente vale a pena.

A exploração poderá entregar:

- saúde;
- vidas;
- alimentos;
- Nozes Douradas;
- segredos;
- conteúdo narrativo.

---

# 49. PRINCÍPIO DE DIFICULDADE

A dificuldade deverá aumentar através de:

DIFICULDADE =
NOVOS INIMIGOS
+
NOVOS PADRÕES
+
MAIOR VELOCIDADE
+
COMBINAÇÃO DE AMEAÇAS
+
OBSTÁCULOS
+
DOMÍNIO DAS HABILIDADES

Evitar depender apenas de:

DIFICULDADE =
MAIS VIDA NO INIMIGO

---

# 50. PRINCÍPIO NARRATIVO

Tico não deverá continuar apenas porque:

> “Preciso completar a próxima fase.”

Ele deverá possuir uma razão narrativa:

> “Meu vilarejo precisa de ajuda.”

Depois:

> “Preciso descobrir quem está levando a comida.”

Depois:

> “Preciso descobrir para onde estão levando.”

Depois:

> “Preciso entender quem está por trás disso.”

Depois:

> “Preciso impedir que isso continue.”

A curiosidade narrativa deverá acompanhar a progressão mecânica.

---

# 51. PRINCÍPIO DE COOPERAÇÃO

Quando Pipo entrar:

TICO
=
AGILIDADE

PIPO
=
FORÇA

TICO + PIPO
=
COOPERAÇÃO

As diferenças deverão existir:

- visualmente;
- no tamanho;
- nas animações;
- na movimentação;
- nas habilidades;
- no level design.

Nenhum deverá ser apenas uma versão visual diferente do outro.

---

# 52. PRINCÍPIO DO VILAREJO

O vilarejo deverá funcionar como representação das consequências da aventura.

INÍCIO
Pouca comida

MEIO
Recuperação gradual

FINAL
Comunidade abastecida

Isso deverá reforçar a ideia:

> As ações do jogador possuem consequências positivas visíveis.

---

# 53. PRINCÍPIO DE VIDA, SAÚDE E GAME OVER

Os três conceitos deverão ser distintos.

## Saúde

Quanto dano o personagem pode receber.

## Vida

Quantidade de novas tentativas disponíveis.

## Game Over

Situação em que todas as vidas foram perdidas.

Fluxo:

SAÚDE
   ↓
CHEGOU A ZERO
   ↓
PERDE UMA VIDA
   ↓
VIDAS > 0?
   │
   ├── SIM → CONTINUA
   │
   └── NÃO → GAME OVER

Isso deverá ser claramente compreensível para crianças.

---

# 54. IMPACTO NOS DOCUMENTOS EXISTENTES

As alterações deste documento exigirão atualização dos documentos anteriores.

Principalmente:

02_requisitos.md

03_gameplay.md

04_personagens.md

05_fases-e-mundos.md

06_direcao-visual.md

07_arquitetura-tecnica.md

08_roadmap.md

09_historia-e-narrativa.md

10_testes.md

11_decisoes.md

As alterações deverão ser incorporadas gradualmente conforme o desenvolvimento.

---

# 55. NOVOS SISTEMAS NECESSÁRIOS

A evolução descrita neste documento introduz ou amplia os seguintes sistemas:

1. abertura narrativa;
2. mapa do mundo;
3. desbloqueio de fases;
4. progresso por fase;
5. tutorial contextual;
6. áreas opcionais;
7. portais;
8. coletáveis especiais;
9. saúde;
10. vidas;
11. Game Over;
12. checkpoints;
13. progressão de dificuldade;
14. novos inimigos;
15. chefes;
16. Coruja mentora;
17. introdução narrativa de Pipo;
18. troca entre personagens;
19. vilarejo evolutivo;
20. tela de resultado;
21. ajuda adaptativa;
22. save expandido;
23. progressão narrativa;
24. backtracking opcional.

Sistemas existentes devem ser mantidos e ampliados, evitando recriá-los. PWA, desempenho e save devem ser verificados em cada etapa; as validações finais ampliam essa cobertura.

Esses sistemas não deverão ser implementados todos simultaneamente.

Deverão entrar no roadmap em etapas.

---

# 56. PRIORIDADE DE IMPLEMENTAÇÃO

A evolução deverá ser feita de maneira incremental.

## FRENTE 1 — Base

- saúde;
- vidas;
- morte;
- Game Over;
- checkpoints.

## FRENTE 2 — Orientação

- remover textos fixos;
- tutorial contextual;
- feedback visual e sonoro.

## FRENTE 3 — Progressão

- mapa;
- desbloqueio;
- resultado de fase;
- save de progresso.

## FRENTE 4 — Exploração

- áreas opcionais;
- portais;
- recompensas;
- Nozes Douradas;
- segredos.

## FRENTE 5 — Narrativa

- abertura;
- Coruja;
- diálogos;
- transições;
- progressão narrativa.

## FRENTE 6 — Pipo

- animação de apresentação;
- gameplay;
- força;
- diferença de tamanho;
- troca;
- desafios cooperativos.

## FRENTE 7 — Expansão

- novos inimigos;
- dificuldade progressiva;
- novos mundos;
- chefes;
- backtracking.

## FRENTE 8 — Mundo vivo

- evolução do vilarejo;
- efeitos das conquistas;
- conteúdo narrativo adicional.

## FRENTE 9 — Polimento

- animações;
- áudio;
- partículas;
- transições;
- interface;
- balanceamento;
- performance.

---

# 57. RESULTADO ESPERADO

Depois dessas alterações, **Tico e a Floresta das Nozes** deverá deixar de ser percebido apenas como uma sequência curta de fases de plataforma.

A experiência deverá transmitir:

AVENTURA
+
HISTÓRIA
+
EXPLORAÇÃO
+
DESCOBERTA
+
PROGRESSÃO
+
DESAFIO
+
RECOMPENSA
+
COOPERAÇÃO

A criança deverá querer continuar não apenas porque existe outra fase.

Ela deverá querer:

- descobrir o que aconteceu;
- ajudar o vilarejo;
- conhecer novos lugares;
- encontrar Pipo;
- descobrir segredos;
- coletar recompensas;
- ficar mais forte;
- superar novos inimigos;
- descobrir quem está por trás do problema;
- recuperar os alimentos.

---

# 58. DIRETRIZ FINAL

Toda nova mecânica deverá responder pelo menos uma destas perguntas:

**Isso torna o jogo mais divertido?**

**Isso melhora a aventura?**

**Isso recompensa a exploração?**

**Isso ajuda a contar a história?**

**Isso cria um desafio interessante?**

**Isso ajuda a criança a compreender o jogo?**

Se uma funcionalidade apenas aumentar o tamanho ou a complexidade do projeto sem melhorar a experiência da criança, ela deverá ser reconsiderada.

A evolução do projeto deverá buscar:

> **MAIS CONTEÚDO SIGNIFICATIVO, NÃO APENAS MAIS CONTEÚDO.**

O objetivo final é transformar **Tico e a Floresta das Nozes** em uma aventura infantil que seja simples de aprender, agradável de explorar, progressivamente desafiadora e capaz de manter a curiosidade da criança até o final.

---

**FIM DO DOCUMENTO**
