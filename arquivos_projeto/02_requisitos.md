# TICO E A FLORESTA DAS NOZES

## DOCUMENTO DE REQUISITOS

**Versão:** 1.0  
**Documento:** 02_requisitos.md

---

# 1. OBJETIVO DO DOCUMENTO

Este documento define os requisitos funcionais, de jogabilidade, interface, experiência do usuário e qualidade do jogo **Tico e a Floresta das Nozes**.

O documento deve orientar o desenvolvimento do jogo e servir como referência para implementação, criação das fases e testes.

O jogo será um jogo de plataforma 2D voltado principalmente para crianças.

Por esse motivo, todo o desenvolvimento deverá priorizar:

- facilidade de aprendizado;
- controles simples;
- leitura visual clara;
- baixa frustração;
- feedback visual e sonoro;
- progressão gradual;
- diversão;
- exploração;
- amizade e cooperação.

A complexidade do jogo deverá surgir da combinação das mecânicas e não da utilização de controles complicados.

---

# 2. PÚBLICO-ALVO

O público principal do jogo será composto por crianças.

O jogo também poderá ser jogado por adolescentes, adultos e familiares, mas suas decisões de design deverão considerar prioritariamente jogadores com pouca experiência com jogos digitais.

O jogador não deverá precisar possuir experiência anterior com jogos de plataforma para compreender as mecânicas básicas.

---

# 3. PRINCÍPIOS GERAIS

## RG-001 — Facilidade de aprendizado

O jogador deverá conseguir compreender as principais mecânicas observando o cenário, as animações e os elementos visuais.

## RG-002 — Poucos comandos

O jogo deverá utilizar uma quantidade reduzida de comandos.

Sempre que possível, uma mesma ação deverá possuir comportamento contextual.

## RG-003 — Aprendizado progressivo

Nenhuma mecânica importante deverá ser exigida do jogador antes de ter sido apresentada em uma situação segura ou de baixa dificuldade.

A progressão deverá seguir preferencialmente:

**Apresentar → Experimentar → Repetir → Combinar → Desafiar**

## RG-004 — Baixa punição

Erros não deverão provocar punições excessivas.

O jogo deverá incentivar novas tentativas.

## RG-005 — Clareza visual

Objetos importantes deverão possuir aparência claramente diferente dos elementos puramente decorativos.

## RG-006 — Feedback

As ações importantes deverão produzir feedback visual e/ou sonoro.

Exemplos:

- coletar uma noz;
- sofrer dano;
- quebrar um bloco;
- derrotar um inimigo;
- descobrir um segredo;
- alcançar um checkpoint;
- encontrar um item especial;
- concluir uma fase.

## RG-007 — Ambiente amigável

O jogo não deverá apresentar:

- sangue;
- violência explícita;
- mortes realistas;
- imagens perturbadoras;
- terror;
- elementos excessivamente assustadores.

---

# 4. PERSONAGEM TICO

## RF-TICO-001 — Movimento horizontal

O jogador deverá conseguir movimentar Tico para a esquerda e para a direita.

## RF-TICO-002 — Corrida

Tico deverá possuir velocidade adequada para permitir exploração e desafios de plataforma.

A aceleração e desaceleração deverão ser suaves e previsíveis.

## RF-TICO-003 — Pulo

Tico deverá conseguir pular.

O pulo deverá possuir resposta rápida e previsível.

O controle deverá transmitir sensação de agilidade.

## RF-TICO-004 — Controle durante o salto

O jogador deverá possuir algum controle horizontal sobre Tico enquanto estiver no ar.

Esse controle deverá facilitar pequenas correções de trajetória.

## RF-TICO-005 — Pulo sobre inimigos

Tico deverá conseguir derrotar determinados inimigos pulando sobre eles.

O contato deverá produzir feedback visual e sonoro.

## RF-TICO-006 — Quebra de blocos

Tico deverá conseguir quebrar determinados tipos de blocos.

Blocos pesados não poderão ser quebrados por Tico.

## RF-TICO-007 — Coleta

Tico deverá conseguir coletar automaticamente itens quando entrar em contato com eles.

## RF-TICO-008 — Planar

Tico deverá utilizar sua cauda para planar.

Quando a habilidade for ativada durante uma queda, sua velocidade de descida deverá diminuir.

## RF-TICO-009 — Limitações do planar

O planar não deverá substituir completamente o salto.

Sua principal função será permitir:

- atravessar espaços maiores;
- corrigir determinados saltos;
- alcançar plataformas específicas;
- explorar áreas alternativas.

## RF-TICO-010 — Espaços pequenos

Tico deverá conseguir acessar determinados espaços onde Pipo não consegue entrar.

---

# 5. PERSONAGEM PIPO

## RF-PIPO-001 — Identidade visual

Pipo deverá sempre utilizar sua característica camisa verde.

A camisa deverá permanecer verde independentemente do mundo, fase ou situação.

## RF-PIPO-002 — Movimento

Pipo deverá conseguir se movimentar horizontalmente.

## RF-PIPO-003 — Pulo

Pipo deverá conseguir pular.

Seu movimento poderá transmitir sensação de maior peso em comparação com Tico.

## RF-PIPO-004 — Força

Pipo deverá conseguir interagir com objetos pesados que Tico não consegue manipular.

## RF-PIPO-005 — Empurrar objetos

Pipo deverá conseguir empurrar determinados objetos.

## RF-PIPO-006 — Quebrar obstáculos

Pipo deverá conseguir destruir determinados obstáculos pesados.

## RF-PIPO-007 — Investida

Pipo deverá possuir uma habilidade de investida.

Durante a investida, Pipo deverá correr rapidamente em uma direção.

A investida poderá:

- quebrar blocos;
- destruir obstáculos;
- atingir determinados inimigos;
- ativar elementos específicos.

## RF-PIPO-008 — Faro

Pipo deverá conseguir detectar determinados objetos ou áreas escondidas.

O faro poderá revelar:

- nozes escondidas;
- itens;
- blocos invisíveis;
- passagens secretas;
- atalhos;
- recompensas.

## RF-PIPO-009 — Indicação do faro

Quando existir algo escondido próximo de Pipo, deverá existir indicação visual e/ou sonora.

A indicação deverá ser fácil de compreender.

## RF-PIPO-010 — Mecanismos de peso

Pipo deverá conseguir ativar determinados mecanismos utilizando seu peso.

---

# 6. RELAÇÃO ENTRE TICO E PIPO

## RF-DUPLA-001 — Habilidades complementares

As habilidades dos personagens deverão seguir a lógica:

**TICO = AGILIDADE**

**PIPO = FORÇA**

## RF-DUPLA-002 — Problemas específicos

O jogo deverá possuir obstáculos que somente Tico consegue superar.

Também deverá possuir obstáculos que somente Pipo consegue superar.

## RF-DUPLA-003 — Cooperação

Determinadas situações deverão exigir a utilização das habilidades dos dois personagens.

## RF-DUPLA-004 — Alternância

Em fases específicas, o jogador poderá alternar entre Tico e Pipo.

## RF-DUPLA-005 — Identificação

O jogador deverá conseguir identificar facilmente qual personagem está controlando.

## RF-DUPLA-006 — Troca simples

Quando disponível, a troca de personagem deverá utilizar um comando simples.

## RF-DUPLA-007 — Necessidade clara

Quando um obstáculo exigir determinado personagem, sua solução deverá poder ser compreendida visualmente.

Exemplos:

**Bloco pesado → Pipo**

**Passagem estreita → Tico**

**Grande espaço → Tico planando**

**Objeto escondido → Faro de Pipo**

---

# 7. SISTEMA DE MOVIMENTAÇÃO

## RF-MOV-001

Os controles deverão responder imediatamente aos comandos do jogador.

## RF-MOV-002

Movimentação, salto e aterrissagem deverão possuir animações próprias.

## RF-MOV-003

O personagem não deverá deslizar excessivamente após o jogador interromper o movimento.

## RF-MOV-004

As plataformas deverão possuir áreas de colisão previsíveis.

## RF-MOV-005

Pequenos erros de posicionamento não deverão tornar os saltos excessivamente difíceis.

## RF-MOV-006

A câmera deverá acompanhar o personagem de forma suave.

## RF-MOV-007

A câmera não deverá produzir movimentos bruscos que dificultem a compreensão do cenário.

---

# 8. SISTEMA DE DANO

## RF-DANO-001

O personagem deverá possuir corações representando sua resistência.

## RF-DANO-002

Ao sofrer dano, o personagem deverá perder um coração.

## RF-DANO-003

Após sofrer dano, o personagem deverá possuir um curto período de invulnerabilidade.

## RF-DANO-004

O período de invulnerabilidade deverá possuir indicação visual.

Exemplo:

personagem piscando temporariamente.

## RF-DANO-005

O jogador deverá compreender claramente o motivo pelo qual sofreu dano.

---

# 9. CHECKPOINTS

## RF-CHK-001

Fases maiores deverão possuir checkpoints.

## RF-CHK-002

Ao alcançar um checkpoint, o jogador deverá receber indicação visual e sonora.

## RF-CHK-003

Quando perder todos os corações, o jogador deverá retornar ao último checkpoint válido.

## RF-CHK-004

Caso nenhum checkpoint tenha sido alcançado, o jogador poderá retornar ao início da fase.

## RF-CHK-005

Os checkpoints deverão reduzir a necessidade de repetir grandes partes da fase.

---

# 10. INIMIGOS

## RF-INIM-001

Os inimigos deverão possuir comportamento fácil de observar.

## RF-INIM-002

Cada inimigo deverá possuir padrão de movimento previsível.

## RF-INIM-003

O jogador deverá conseguir compreender como evitar ou derrotar cada inimigo.

## RF-INIM-004

Novos inimigos deverão ser introduzidos gradualmente.

## RF-INIM-005

A primeira aparição de um novo inimigo deverá ocorrer preferencialmente em uma situação de baixa dificuldade.

## RF-INIM-006

Inimigos derrotados não deverão apresentar animações violentas.

Eles poderão:

- ficar tontos;
- desaparecer;
- fugir;
- virar uma pequena nuvem;
- apresentar animação engraçada.

---

# 11. TIPOS INICIAIS DE INIMIGOS

## Lesma

Deverá caminhar lentamente.

Servirá principalmente para ensinar o jogador a pular sobre inimigos.

## Ouriço

Deverá possuir espinhos claramente visíveis.

Sua aparência deverá indicar que pular diretamente sobre ele pode não funcionar.

## Corvo

Deverá possuir movimentação aérea.

Deverá ensinar o jogador a observar ameaças acima do personagem.

## Cobra

Poderá permanecer escondida até o jogador se aproximar.

A surpresa não deverá ser excessivamente assustadora.

## Castor

Poderá lançar pequenos objetos à distância.

Seus ataques deverão possuir indicação visual suficiente para permitir que o jogador reaja.

---

# 12. BLOCOS

O jogo deverá possuir diferentes categorias de blocos.

## RF-BLOCO-001 — Bloco de madeira

Poderá ser quebrado conforme suas propriedades.

## RF-BLOCO-002 — Bloco de noz

Ao ser quebrado deverá liberar uma noz.

## RF-BLOCO-003 — Bloco surpresa

Poderá liberar recompensas.

## RF-BLOCO-004 — Bloco pesado

Não poderá ser destruído normalmente por Tico.

Pipo poderá destruí-lo utilizando força ou investida.

## RF-BLOCO-005 — Bloco invisível

Poderá permanecer escondido até ser descoberto.

O faro de Pipo poderá ajudar a localizar esse bloco.

## RF-BLOCO-006 — Identificação

Cada categoria deverá possuir identidade visual suficiente para que o jogador aprenda suas propriedades.

---

# 13. ITENS COLETÁVEIS

## RF-ITEM-001 — Noz comum

Será o principal item coletável.

## RF-ITEM-002 — Noz dourada

Será mais rara que a noz comum.

Deverá possuir aparência claramente diferenciada.

## RF-ITEM-003 — Noz especial

Poderá aparecer em áreas secretas ou desafios opcionais.

## RF-ITEM-004

A coleta de uma noz deverá produzir animação e som.

## RF-ITEM-005

O HUD deverá indicar a quantidade de nozes coletadas quando essa informação for relevante.

---

# 14. POWER-UPS

Poderão existir power-ups temporários.

## Frutinha vermelha

Poderá recuperar um coração ou fornecer proteção.

## Folha mágica

Poderá melhorar temporariamente a capacidade de planar.

## Noz dourada

Poderá fornecer uma habilidade especial temporária.

## Mel

Poderá aumentar temporariamente a força.

## Semente brilhante

Poderá fornecer invulnerabilidade temporária.

## RF-POWER-001

Todo power-up deverá possuir aparência facilmente reconhecível.

## RF-POWER-002

Ao obter um power-up, deverá existir indicação visual e sonora.

## RF-POWER-003

Efeitos temporários deverão possuir alguma indicação de que estão ativos.

---

# 15. SEGREDOS E EXPLORAÇÃO

## RF-EXP-001

As fases poderão possuir áreas secretas.

## RF-EXP-002

Áreas secretas deverão recompensar a exploração.

## RF-EXP-003

As recompensas poderão incluir:

- nozes;
- nozes especiais;
- itens;
- medalhas;
- estrelas;
- acessórios;
- caminhos alternativos;
- fases secretas.

## RF-EXP-004

Segredos não deverão ser obrigatórios para concluir uma fase normal.

## RF-EXP-005

Pipo poderá ajudar a descobrir determinados segredos através do faro.

---

# 16. FASES

## RF-FASE-001

Cada fase deverá possuir início e final claramente identificáveis.

## RF-FASE-002

Cada fase deverá possuir um objetivo principal simples.

## RF-FASE-003

A progressão principal deverá ser predominantemente da esquerda para a direita.

## RF-FASE-004

As fases poderão possuir pequenas áreas de exploração vertical.

## RF-FASE-005

Uma fase poderá possuir caminhos alternativos.

## RF-FASE-006

Os caminhos alternativos poderão conter recompensas.

## RF-FASE-007

Cada mundo deverá introduzir novas mecânicas progressivamente.

## RF-FASE-008

Mecânicas antigas deverão continuar aparecendo para reforçar o aprendizado.

## RF-FASE-009

Mecânicas poderão ser combinadas conforme o jogador progride.

---

# 17. MUNDOS

A estrutura inicial prevista será composta por cinco mundos.

## Mundo 1 — Bosque das Folhas

Foco:

- movimentação;
- pulo;
- inimigos básicos;
- coleta;
- blocos.

## Mundo 2 — Rio das Pedras

Foco:

- água;
- plataformas móveis;
- saltos maiores;
- obstáculos ambientais;
- movimentação de objetos.

## Mundo 3 — Montanha das Corujas

Foco:

- planar;
- exploração vertical;
- plataformas suspensas.

## Mundo 4 — Vila dos Castores

Foco:

- força de Pipo;
- mecanismos;
- obstáculos pesados;
- cooperação.

## Mundo 5 — Árvore do Mestre Corvo

Foco:

- combinação das mecânicas anteriores;
- desafios mais complexos;
- exploração;
- conclusão da história.

---

# 18. CHEFES

## RF-CHEFE-001

Cada mundo poderá possuir uma batalha contra chefe.

## RF-CHEFE-002

Chefes deverão possuir padrões compreensíveis.

## RF-CHEFE-003

O jogador deverá conseguir aprender os padrões através da observação.

## RF-CHEFE-004

As batalhas deverão utilizar mecânicas apresentadas anteriormente.

## RF-CHEFE-005

Chefes não deverão possuir aparência excessivamente assustadora.

## RF-CHEFE-006

Derrotar um chefe deverá produzir uma sequência de comemoração ou progressão.

## RF-CHEFE-007

A batalha final contra Mestre Corvo deverá combinar habilidades de Tico e Pipo.

---

# 19. INTERFACE

## RF-UI-001

A interface deverá ser simples.

## RF-UI-002

A quantidade de informações simultaneamente exibidas deverá ser reduzida.

## RF-UI-003

Elementos importantes deverão possuir tamanho adequado para fácil identificação.

## RF-UI-004

Ícones deverão ser utilizados sempre que puderem substituir textos longos.

## RF-UI-005

Os corações deverão estar claramente visíveis.

## RF-UI-006

A quantidade de nozes poderá ser apresentada através de ícone e número.

## RF-UI-007

O personagem ativo deverá poder ser identificado visualmente quando existir possibilidade de troca.

---

# 20. TEXTOS E INSTRUÇÕES

## RF-TXT-001

Textos destinados às crianças deverão ser curtos.

## RF-TXT-002

Instruções deverão utilizar linguagem simples.

## RF-TXT-003

Sempre que possível, instruções deverão ser acompanhadas por:

- animações;
- imagens;
- ícones;
- demonstrações.

## RF-TXT-004

O jogo deverá evitar grandes blocos de texto durante a jogabilidade.

## RF-TXT-005

Diálogos deverão ser curtos e apropriados ao público infantil.

---

# 21. TUTORIAL

## RF-TUT-001

O tutorial deverá ocorrer naturalmente durante as primeiras fases.

## RF-TUT-002

O jogo deverá evitar depender de um longo tutorial separado.

## RF-TUT-003

Cada nova habilidade deverá ser apresentada individualmente antes de ser combinada com outras.

## RF-TUT-004

O jogador deverá possuir espaço seguro para testar novas habilidades.

## RF-TUT-005

Instruções poderão desaparecer após o jogador executar corretamente a ação solicitada.

---

# 22. FEEDBACK PARA ERROS

## RF-ERRO-001

Quando o jogador cometer um erro, o jogo deverá evitar mensagens negativas.

## RF-ERRO-002

O jogo deverá incentivar uma nova tentativa.

## RF-ERRO-003

O reinício após uma falha deverá ser rápido.

## RF-ERRO-004

O jogador não deverá precisar navegar repetidamente por menus após falhar.

---

# 23. ÁUDIO

## RF-AUD-001

O jogo deverá possuir música compatível com sua atmosfera alegre e amigável.

## RF-AUD-002

Cada mundo poderá possuir identidade musical própria.

## RF-AUD-003

Ações importantes deverão possuir efeitos sonoros.

Exemplos:

- pular;
- coletar;
- quebrar;
- receber dano;
- encontrar segredo;
- checkpoint;
- concluir fase.

## RF-AUD-004

Sons de erro ou dano não deverão ser excessivamente agressivos.

## RF-AUD-005

O jogador deverá conseguir ajustar o volume da música e dos efeitos sonoros.

---

# 24. ACESSIBILIDADE E FACILIDADE DE USO

## RNF-ACE-001

Informações importantes não deverão depender exclusivamente de cores.

## RNF-ACE-002

Sempre que possível, cores deverão ser acompanhadas por:

- formas;
- símbolos;
- animações;
- posições;
- outros elementos visuais.

## RNF-ACE-003

Textos deverão possuir contraste adequado com o fundo.

## RNF-ACE-004

Fontes deverão possuir boa legibilidade.

## RNF-ACE-005

Textos importantes não deverão utilizar tamanhos excessivamente pequenos.

## RNF-ACE-006

O jogo deverá evitar sequências que exijam pressionamento extremamente rápido de botões.

## RNF-ACE-007

O jogo deverá evitar depender de combinações complexas de comandos.

---

# 25. PAUSA

## RF-PAUSA-001

O jogador deverá conseguir pausar o jogo.

## RF-PAUSA-002

O menu de pausa deverá possuir poucas opções e organização simples.

Inicialmente poderá conter:

- Continuar;
- Reiniciar do checkpoint;
- Configurações;
- Sair da fase.

---

# 26. SALVAMENTO

## RF-SAVE-001

O jogo deverá salvar o progresso do jogador.

## RF-SAVE-002

O jogador não deverá precisar salvar manualmente durante a progressão normal.

## RF-SAVE-003

O salvamento deverá ocorrer automaticamente em momentos apropriados.

Exemplos:

- conclusão de fase;
- desbloqueio de mundo;
- obtenção de recompensa importante.

## RF-SAVE-004

O jogo deverá evitar perda significativa de progresso.

---

# 27. REQUISITOS ESPECÍFICOS PARA CRIANÇAS

## RNF-CRI-001

As principais ações deverão poder ser compreendidas sem leitura extensa.

## RNF-CRI-002

O jogo deverá utilizar poucos comandos simultaneamente.

## RNF-CRI-003

Os primeiros desafios deverão possuir baixa dificuldade.

## RNF-CRI-004

A dificuldade deverá aumentar gradualmente.

## RNF-CRI-005

O jogo deverá recompensar curiosidade e exploração.

## RNF-CRI-006

Falhas não deverão gerar grandes perdas de progresso.

## RNF-CRI-007

A criança deverá receber feedback positivo ao superar desafios.

## RNF-CRI-008

Objetivos principais deverão ser claros.

## RNF-CRI-009

Elementos perigosos deverão possuir identificação visual adequada.

## RNF-CRI-010

A interface deverá evitar excesso de informações.

## RNF-CRI-011

A progressão deverá priorizar sensação de descoberta.

## RNF-CRI-012

O jogo deverá permitir que a criança aprenda através da experimentação.

---

# 28. REQUISITOS DE DESEMPENHO

## RNF-DES-001

Os comandos deverão possuir resposta rápida.

## RNF-DES-002

O jogo deverá buscar manter taxa de quadros estável durante a jogabilidade.

## RNF-DES-003

Transições entre áreas não deverão provocar esperas excessivas.

## RNF-DES-004

O tempo para retornar ao checkpoint após uma falha deverá ser reduzido.

---

# 29. PRIMEIRO PROTÓTIPO JOGÁVEL

O primeiro protótipo não deverá tentar implementar todo o jogo.

Seu objetivo será validar as mecânicas fundamentais.

O protótipo deverá possuir:

- Tico;
- Pipo;
- uma pequena fase;
- cenário simples;
- movimentação horizontal;
- pulo;
- colisões;
- plataformas;
- pelo menos um inimigo;
- blocos;
- nozes coletáveis;
- sistema básico de dano;
- pelo menos um obstáculo pesado;
- obstáculo que somente Pipo consiga superar;
- troca entre Tico e Pipo;
- final da fase.

---

# 30. CRITÉRIOS DE VALIDAÇÃO DO PROTÓTIPO

O protótipo deverá permitir responder às seguintes perguntas:

### CV-001

Tico é divertido de controlar?

### CV-002

O movimento responde adequadamente?

### CV-003

O pulo é agradável?

### CV-004

É fácil compreender onde Tico consegue chegar?

### CV-005

Pular sobre um inimigo é fácil de compreender?

### CV-006

Coletar nozes transmite sensação de recompensa?

### CV-007

Quebrar blocos é satisfatório?

### CV-008

A criança consegue compreender que determinados obstáculos exigem Pipo?

### CV-009

A diferença entre Tico e Pipo é perceptível?

### CV-010

A troca entre personagens é simples?

### CV-011

Pipo acrescenta algo relevante à jogabilidade?

### CV-012

O jogador consegue compreender o objetivo da fase sem explicações longas?

---

# 31. FORA DO ESCOPO DO PRIMEIRO PROTÓTIPO

Inicialmente não será necessário implementar:

- os cinco mundos completos;
- as quinze fases;
- todos os inimigos;
- todos os power-ups;
- todos os chefes;
- batalha final;
- sistema completo de cosméticos;
- fases secretas;
- história completa;
- animações cinematográficas;
- sistema avançado de conquistas.

Esses recursos deverão ser adicionados somente após a validação das mecânicas principais.

---

# 32. REGRA PARA NOVAS FUNCIONALIDADES

Toda nova funcionalidade proposta para o jogo deverá responder às seguintes perguntas:

1. É fácil para uma criança compreender?
2. Acrescenta diversão?
3. Combina com Tico, Pipo ou com o universo do jogo?
4. Pode ser ensinada visualmente?
5. Exige novos comandos?
6. Torna o jogo desnecessariamente complexo?
7. Pode ser apresentada gradualmente?
8. Possui feedback claro?
9. Acrescenta algo que ainda não existe?
10. Ajuda a criar situações interessantes utilizando as mecânicas existentes?

Uma funcionalidade não deverá ser adicionada apenas porque é tecnicamente possível.

---

# 33. PRINCÍPIO CENTRAL DE DESENVOLVIMENTO

O objetivo não é criar um jogo difícil de controlar.

O objetivo é criar situações interessantes utilizando regras fáceis de compreender.

O jogador deverá pensar:

**"Eu sei o que preciso fazer. Agora preciso descobrir como fazer."**

e não:

**"Eu não sei qual botão preciso apertar."**

---

# 34. PRINCÍPIO DA DUPLA

A relação entre Tico e Pipo deverá permanecer como um dos elementos centrais do projeto.

Tico deverá representar principalmente:

**AGILIDADE**

Pipo deverá representar principalmente:

**FORÇA**

As diferenças entre os personagens deverão gerar oportunidades de cooperação.

O jogo deverá mostrar através da própria jogabilidade que personagens diferentes podem possuir habilidades diferentes e que essas diferenças podem ajudá-los a superar desafios quando trabalham juntos.

---

# 35. RESULTADO ESPERADO

"Tico e a Floresta das Nozes" deverá ser um jogo de plataforma 2D:

- simples de aprender;
- agradável de controlar;
- visualmente amigável;
- apropriado para crianças;
- divertido;
- pouco punitivo;
- baseado em exploração;
- baseado em descoberta;
- baseado em amizade;
- baseado em cooperação.

A criança deverá sentir curiosidade para descobrir o que existe depois da próxima plataforma, atrás de um obstáculo ou dentro de uma passagem escondida.

Acima de tudo, o jogo deverá fazer com que controlar Tico e Pipo seja divertido mesmo antes de existirem todos os mundos, inimigos e elementos da história.

---

**FIM DO DOCUMENTO**
