# TICO E A FLORESTA DAS NOZES

# ETAPAS DE EVOLUÇÃO DO JOGO

**Arquivo:** etapas_evolucao.md  
**Versão:** 1.0  
**Status:** Planejamento de desenvolvimento  
**Documento relacionado:** evolucao.md

---

# 1. OBJETIVO

Este documento organiza em uma sequência lógica as etapas necessárias para implementar as evoluções previstas para **Tico e a Floresta das Nozes**.

O objetivo é evitar que as novas funcionalidades sejam desenvolvidas de forma isolada ou em uma ordem que gere retrabalho.

A evolução deverá acontecer de maneira incremental:

BASE
  ↓
PROGRESSÃO
  ↓
NARRATIVA
  ↓
EXPLORAÇÃO
  ↓
NOVOS PERSONAGENS
  ↓
NOVOS DESAFIOS
  ↓
CONTEÚDO
  ↓
POLIMENTO
  ↓
TESTES
  ↓
VERSÃO FINAL

Cada etapa deverá produzir uma versão jogável.

---

# 2. PRINCÍPIO DE DESENVOLVIMENTO

Não implementar todas as mudanças simultaneamente.

O projeto deverá evoluir através de pequenas versões funcionais.

Cada etapa deverá seguir:

IMPLEMENTAR
   ↓
TESTAR
   ↓
CORRIGIR
   ↓
VALIDAR
   ↓
AVANÇAR

Uma nova etapa somente deverá ser considerada concluída quando seus elementos principais estiverem funcionando de forma estável.

---

# 3. VISÃO GERAL DAS ETAPAS

A evolução será dividida em:

ETAPA 0 — Preparação e diagnóstico

ETAPA 1 — Saúde, dano e morte

ETAPA 2 — Vidas e Game Over

ETAPA 3 — Checkpoints e reinício

ETAPA 4 — Limpeza da interface e tutorial contextual

ETAPA 5 — Sistema de progresso e salvamento

ETAPA 6 — Mapa do mundo

ETAPA 7 — Resultados e desbloqueio de fases

ETAPA 8 — Áreas opcionais e exploração

ETAPA 9 — Recompensas e coletáveis

ETAPA 10 — Estrutura narrativa

ETAPA 11 — Coruja e progressão da história

ETAPA 12 — Introdução de Pipo

ETAPA 13 — Mecânicas de Tico e Pipo

ETAPA 14 — Progressão de dificuldade

ETAPA 15 — Novos inimigos

ETAPA 16 — Chefes

ETAPA 17 — Evolução do vilarejo

ETAPA 18 — Expansão das fases e mundos

ETAPA 19 — Áudio, animações e feedback

ETAPA 20 — Balanceamento

ETAPA 21 — Testes com público

ETAPA 22 — Performance, PWA e dispositivos

ETAPA 23 — Polimento e versão final

---

# 4. ETAPA 0 — PREPARAÇÃO E DIAGNÓSTICO

Antes de modificar o jogo, analisar a versão atual.

Objetivos:

- identificar sistemas existentes;
- identificar código reutilizável;
- identificar dependências;
- verificar organização das fases;
- verificar controle do personagem;
- verificar inimigos;
- verificar colisões;
- verificar HUD;
- verificar sistema atual de progresso;
- verificar armazenamento;
- verificar estrutura PWA.

Criar uma lista separando:

MANTER

ALTERAR

REMOVER

CRIAR

Nesta etapa também deverão ser identificados os textos fixos atualmente existentes no gameplay que serão removidos posteriormente.

## Resultado esperado

Conhecimento claro do estado atual do projeto antes das alterações.

---

# 5. ETAPA 1 — SAÚDE, DANO E MORTE

O primeiro novo sistema deverá ser a saúde.

Antes de criar vidas, Game Over ou checkpoints, é necessário existir uma regra consistente de morte.

Implementar:

- saúde máxima;
- saúde atual;
- recebimento de dano;
- recuperação;
- coração;
- HUD de saúde;
- animação de dano;
- invulnerabilidade temporária;
- morte ao chegar a zero.

Fluxo:

PERSONAGEM
   ↓
RECEBE DANO
   ↓
SAÚDE DIMINUI
   ↓
SAÚDE > 0?
   │
   ├── SIM → CONTINUA
   │
   └── NÃO → MORTE

## Testar

- dano de inimigos;
- dano de obstáculos;
- recuperação;
- dano repetido;
- invulnerabilidade;
- morte.

## Resultado esperado

O personagem pode receber dano, recuperar saúde e morrer corretamente.

---

# 6. ETAPA 2 — VIDAS E GAME OVER

Com a morte funcionando, implementar o sistema de vidas.

Adicionar:

- vidas iniciais;
- contador de vidas;
- perda de vida;
- vida extra;
- HUD;
- Game Over.

Fluxo:

SAÚDE = 0
   ↓
PERDE UMA VIDA
   ↓
VIDAS RESTANTES?
   │
   ├── SIM → REINICIAR
   │
   └── NÃO → GAME OVER

Neste momento, o Game Over poderá utilizar uma regra provisória.

A consequência definitiva será definida depois dos testes de balanceamento.

## Resultado esperado

O jogador possui saúde, pode morrer, perder vidas e chegar ao Game Over.

---

# 7. ETAPA 3 — CHECKPOINTS E REINÍCIO

Agora definir de onde o jogador retorna depois da morte.

Criar:

- checkpoint;
- checkpoint ativo;
- posição de retorno;
- restauração do personagem;
- reinício da fase.

Fluxo:

MORTE
   ↓
POSSUI VIDA
   ↓
CHECKPOINT?
   │
   ├── SIM → RETORNA AO CHECKPOINT
   │
   └── NÃO → INÍCIO DA FASE

Deverão existir regras claras sobre:

- saúde após retorno;
- inimigos reaparecendo;
- itens reaparecendo;
- coletáveis permanentes;
- estado de áreas opcionais.

## Resultado esperado

A morte passa a integrar corretamente o fluxo da fase.

---

# 8. ETAPA 4 — LIMPEZA DA INTERFACE E TUTORIAL CONTEXTUAL

Remover textos fixos que ocupam permanentemente a tela.

A interface deverá apresentar apenas informações realmente necessárias.

Criar o sistema de dicas contextuais.

Exemplos:

PRIMEIRO INIMIGO
   ↓
"Dê um salto sobre ele!"

PRIMEIRO CORAÇÃO
   ↓
"Pegue o coração para recuperar sua saúde."

PRIMEIRA VIDA
   ↓
"Uma vida extra!"

PRIMEIRA POSSIBILIDADE DE PLANAR
   ↓
DICA SOBRE A HABILIDADE

As dicas deverão:

- aparecer no momento adequado;
- ser curtas;
- utilizar linguagem infantil;
- desaparecer automaticamente ou após interação;
- não bloquear excessivamente o jogo;
- aparecer apenas quando necessárias.

Registrar:

tutorial_enemy_seen

tutorial_heart_seen

tutorial_life_seen

tutorial_glide_seen

tutorial_secret_seen

## Resultado esperado

A primeira fase passa a ensinar o jogo sem depender de textos permanentes.

---

# 9. ETAPA 5 — SISTEMA DE PROGRESSO E SALVAMENTO

Antes de criar o mapa, criar a estrutura de dados que representará o progresso.

O jogo deverá conhecer:

- fase atual;
- fases desbloqueadas;
- fases concluídas;
- coletáveis;
- segredos;
- Nozes Douradas;
- tutoriais visualizados;
- personagens desbloqueados;
- progresso narrativo;
- configurações.

Como o projeto será PWA, o armazenamento local deverá funcionar corretamente no navegador e no aplicativo instalado.

Deverá existir versionamento do formato de save para permitir futuras alterações.

Exemplo conceitual:

saveVersion
player
progress
levels
collectibles
characters
story
tutorials
settings

## Resultado esperado

O progresso pode ser salvo, fechado e recuperado corretamente.

---

# 10. ETAPA 6 — MAPA DO MUNDO

Somente depois do progresso estar funcionando deverá ser criado o mapa.

Implementar:

- mapa ilustrado;
- nós das fases;
- caminhos;
- fase atual;
- fases bloqueadas;
- fases disponíveis;
- fases concluídas.

Estados:

LOCKED

AVAILABLE

CURRENT

COMPLETED

Inicialmente:

VILAREJO
   ↓
FASE 1
   ↓
🔒
   ↓
🔒
   ↓
🔒

## Resultado esperado

O jogador inicia pelo mapa e consegue visualizar sua jornada.

---

# 11. ETAPA 7 — RESULTADO E DESBLOQUEIO DE FASES

Criar a conclusão completa de uma fase.

Fluxo:

FINAL DA FASE
   ↓
RESULTADOS
   ↓
ATUALIZA SAVE
   ↓
DESBLOQUEIA PRÓXIMA FASE
   ↓
MAPA
   ↓
ANIMAÇÃO DE DESBLOQUEIO

Tela de resultado poderá mostrar:

- alimentos;
- Nozes Douradas;
- áreas secretas;
- vidas;
- tempo;
- conclusão.

Não utilizar notas negativas.

## Resultado esperado

O ciclo:

MAPA → FASE → RESULTADO → MAPA

está completamente funcional.

---

# 12. MARCO 1 — LOOP PRINCIPAL FUNCIONAL

Neste ponto interromper temporariamente a adição de novas funcionalidades.

O jogo deverá possuir:

- saúde;
- vidas;
- morte;
- Game Over;
- checkpoints;
- tutorial;
- save;
- mapa;
- fase;
- conclusão;
- desbloqueio.

Executar testes completos.

Este é o primeiro grande marco técnico.

---

# 13. ETAPA 8 — ÁREAS OPCIONAIS E EXPLORAÇÃO

Depois do loop principal estabilizado, expandir as fases.

Criar o conceito de área secundária.

Primeiro protótipo:

ÁRVORE
   ↓
SUBIDA PELOS GALHOS
   ↓
ÁREA OPCIONAL
   ↓
DESAFIO
   ↓
RECOMPENSA
   ↓
PORTAL
   ↓
RETORNO

A primeira área opcional deverá servir como modelo técnico para as demais.

Testar:

- entrada;
- transição;
- retorno;
- morte;
- checkpoint;
- itens;
- save.

## Resultado esperado

Uma fase possui caminho principal e exploração opcional.

---

# 14. ETAPA 9 — RECOMPENSAS E COLETÁVEIS

Depois das áreas opcionais, tornar a exploração relevante.

Implementar:

- alimentos;
- coração;
- vida extra;
- Noz Dourada;
- segredos.

Definir regras para recompensas.

Possibilidade:

100 alimentos
   ↓
+1 VIDA

Essa regra deverá permanecer configurável para facilitar balanceamento.

As Nozes Douradas deverão ser opcionais.

## Resultado esperado

Explorar oferece vantagens reais ao jogador.

---

# 15. ETAPA 10 — ESTRUTURA NARRATIVA

Com o loop de gameplay funcionando, implementar a estrutura necessária para contar a história.

Criar suporte para:

- cenas;
- diálogos;
- transições;
- personagens;
- eventos narrativos;
- avanço de história;
- animações narrativas.

O sistema deverá permitir:

CENA
   ↓
DIÁLOGO
   ↓
ANIMAÇÃO
   ↓
GAMEPLAY

sem exigir implementação específica para cada situação.

## Resultado esperado

O jogo possui infraestrutura reutilizável para narrativa.

---

# 16. ETAPA 11 — ABERTURA DO JOGO

Implementar a sequência inicial.

Ordem:

VILAREJO
   ↓
TICO PROCURA COMIDA
   ↓
NÃO ENCONTRA
   ↓
PROCURA MAIS LONGE
   ↓
ENTRA EM ÁREA DESCONHECIDA
   ↓
ENCONTRA CORUJA
   ↓
SALVA CORUJA
   ↓
RECEBE PISTA
   ↓
DECIDE AJUDAR
   ↓
TÍTULO
   ↓
MAPA

A cena deverá priorizar comunicação visual.

Evitar diálogos excessivamente longos.

## Resultado esperado

A aventura possui uma motivação clara desde o início.

---

# 17. ETAPA 12 — CORUJA E PROGRESSÃO DA HISTÓRIA

Transformar a Coruja em personagem recorrente.

Criar encontros após momentos importantes.

Estrutura:

CHEFE / FINAL
   ↓
CORUJA
   ↓
DIÁLOGO
   ↓
PISTA
   ↓
PRÓXIMO DESTINO
   ↓
MAPA

A Coruja deverá:

- orientar;
- revelar pistas;
- incentivar;
- contextualizar.

Ela não deverá resolver os problemas pelo jogador.

## Resultado esperado

As fases passam a fazer parte de uma história contínua.

---

# 18. ETAPA 13 — INTRODUÇÃO DE PIPO

Não disponibilizar Pipo imediatamente.

Criar sua entrada através da narrativa.

Sequência sugerida:

TICO ENCONTRA PIPO
   ↓
PIPO TAMBÉM SOFRE COM A FALTA DE COMIDA
   ↓
ACONTECE UM PROBLEMA
   ↓
TICO AJUDA PIPO
   ↓
PIPO CONHECE A MISSÃO
   ↓
DECIDE AJUDAR
   ↓
DEMONSTRAÇÃO DAS HABILIDADES

Criar animação mostrando:

TICO = AGILIDADE

PIPO = FORÇA

Exemplo:

PEDRA
   ↓
TICO TENTA
   ↓
NÃO CONSEGUE
   ↓
PIPO MOVE

Depois:

PLATAFORMA
   ↓
PIPO NÃO ALCANÇA
   ↓
TICO ALCANÇA

## Resultado esperado

A criança entende quem é Pipo e por que ele entrou na aventura.

---

# 19. ETAPA 14 — MECÂNICAS DE TICO E PIPO

Implementar efetivamente as diferenças.

## Tico

- menor;
- rápido;
- ágil;
- salto;
- planar;
- espaços menores.

## Pipo

- maior;
- forte;
- pesado;
- empurra objetos;
- quebra obstáculos;
- ativa mecanismos de peso.

Implementar troca de personagem.

Depois criar um pequeno trecho de teste:

PIPO MOVE OBJETO
   ↓
TICO ACESSA ÁREA
   ↓
TICO ATIVA MECANISMO
   ↓
CAMINHO PARA PIPO

## Resultado esperado

Os personagens possuem gameplay realmente diferente.

---

# 20. ETAPA 15 — BACKTRACKING CONTROLADO

Depois de Pipo estar funcional, adicionar pequenos segredos em fases anteriores.

Exemplo:

FASE ANTIGA
   ↓
PEDRA
   ↓
PIPO
   ↓
PASSAGEM
   ↓
SEGREDO

Não tornar o retorno obrigatório.

O objetivo é recompensar jogadores que desejem explorar novamente.

## Resultado esperado

Novas habilidades aumentam a utilidade das fases anteriores.

---

# 21. MARCO 2 — AVENTURA COMPLETA EM MINIATURA

Neste momento criar uma pequena sequência contendo:

- mapa;
- duas ou três fases;
- narrativa;
- Coruja;
- área opcional;
- coletáveis;
- Pipo;
- chefe;
- progressão;
- save.

Esta pequena campanha deverá representar em escala reduzida o jogo completo.

Testá-la antes de produzir todas as fases.

Isso é importante para evitar produzir muito conteúdo antes de validar os sistemas.

---

# 22. ETAPA 16 — PROGRESSÃO DE DIFICULDADE

Agora definir formalmente uma curva de dificuldade.

Exemplo:

NÍVEL 1
Aprender

NÍVEL 2
Praticar

NÍVEL 3
Combinar

NÍVEL 4
Desafiar

Para cada mundo definir:

- velocidade dos inimigos;
- quantidade;
- combinação;
- obstáculos;
- plataformas;
- distância entre checkpoints;
- complexidade das áreas opcionais.

Evitar dificuldade baseada apenas em aumento de saúde.

## Resultado esperado

Existe uma curva previsível de desafio.

---

# 23. ETAPA 17 — NOVOS INIMIGOS

Criar famílias de inimigos gradualmente.

Exemplo:

Lesma
   ↓
Besouro
   ↓
Aranha
   ↓
Morcego
   ↓
Porco-espinho
   ↓
Corvo patrulheiro

Cada inimigo deverá introduzir um comportamento.

Depois combinar inimigos.

Exemplo:

BESOURO + MORCEGO

posteriormente:

CORVO + OBSTÁCULO + PLATAFORMA

## Resultado esperado

O desafio aumenta através da variedade.

---

# 24. ETAPA 18 — CHEFES

Criar chefes utilizando as mecânicas aprendidas no mundo.

Estrutura:

OBSERVAR
   ↓
ENTENDER
   ↓
DESVIAR
   ↓
ENCONTRAR FRAQUEZA
   ↓
ATACAR

Utilizar preferencialmente três momentos:

FASE 1 — padrão simples

FASE 2 — variação

FASE 3 — combinação

O chefe final poderá utilizar conhecimentos adquiridos durante toda a aventura.

## Resultado esperado

Chefes funcionam como conclusão do aprendizado do mundo.

---

# 25. ETAPA 19 — VILAREJO EVOLUTIVO

Criar estados diferentes do vilarejo.

## Estado inicial

- escassez;
- cestos vazios;
- preocupação.

## Estado intermediário

- alguns alimentos;
- melhorias;
- personagens mais animados.

## Estado avançado

- alimentos;
- movimento;
- decoração;
- recuperação.

## Estado final

- comunidade abastecida;
- celebração;
- consequência visual da vitória.

O estado deverá ser determinado pelo progresso salvo.

## Resultado esperado

O mundo responde visualmente às ações do jogador.

---

# 26. ETAPA 20 — EXPANSÃO DAS FASES E MUNDOS

Somente depois dos sistemas principais validados começar a grande produção de conteúdo.

Para cada fase definir:

- objetivo;
- tema;
- duração;
- inimigos;
- mecânica principal;
- desafios;
- áreas opcionais;
- coletáveis;
- segredos;
- checkpoints;
- elementos narrativos;
- conexão com próxima fase.

Cada fase deverá ser tratada como uma pequena jornada.

Evitar copiar fases alterando apenas cenário.

## Resultado esperado

A duração do jogo cresce através de conteúdo significativo.

---

# 27. ETAPA 21 — ÁUDIO, ANIMAÇÕES E FEEDBACK

Com os sistemas estáveis, iniciar forte etapa de polimento.

Adicionar ou revisar:

- passos;
- saltos;
- dano;
- coleta;
- vida extra;
- segredo;
- morte;
- Game Over;
- conclusão;
- desbloqueio;
- chefes;
- músicas;
- ambientes;
- partículas;
- transições.

Cada ação importante deverá possuir resposta perceptível.

## Resultado esperado

O jogo começa a apresentar sensação de produto final.

---

# 28. ETAPA 22 — BALANCEAMENTO

Agora ajustar números.

Testar:

- quantidade de saúde;
- vidas iniciais;
- frequência de corações;
- frequência de vidas;
- quantidade de alimentos;
- velocidade;
- dano;
- saúde dos inimigos;
- checkpoints;
- duração;
- dificuldade dos chefes.

Evitar inserir números diretamente em muitos pontos do código.

Valores importantes deverão ser configuráveis.

Isso permitirá experimentar rapidamente.

---

# 29. DECISÃO SOBRE GAME OVER

Nesta etapa deverá ser tomada a decisão definitiva sobre a consequência do Game Over.

Testar:

## Modelo A

Reiniciar toda a campanha.

## Modelo B

Reiniciar o mundo.

## Modelo C

Retornar ao mapa.

## Modelo D

Retornar ao último ponto importante.

Observar principalmente:

- frustração;
- motivação;
- importância percebida das vidas;
- disposição para continuar jogando.

O público infantil deverá ter peso decisivo nessa escolha.

---

# 30. ETAPA 23 — TESTES COM CRIANÇAS

Os desenvolvedores não deverão ser os únicos responsáveis pela validação.

Observar crianças jogando.

Evitar explicar imediatamente.

Observar:

- entendem os controles?
- entendem os corações?
- entendem as vidas?
- sabem por que morreram?
- entendem o mapa?
- sabem qual fase escolher?
- entendem Pipo?
- descobrem áreas opcionais?
- compreendem os balões?
- sabem quando trocar de personagem?
- chefes são compreensíveis?
- Game Over causa frustração excessiva?
- querem continuar jogando?

Registrar problemas.

Corrigir.

Testar novamente.

---

# 31. TESTAR DIVERSOS PERFIS

Não testar apenas com crianças muito acostumadas a videogames.

Idealmente observar:

CRIANÇA COM POUCA EXPERIÊNCIA

CRIANÇA COM EXPERIÊNCIA MÉDIA

CRIANÇA QUE JOGA FREQUENTEMENTE

Isso permitirá identificar diferenças importantes.

Um desafio considerado fácil por uma criança experiente pode ser uma barreira significativa para outra.

---

# 32. ETAPA 24 — AJUDA ADAPTATIVA

Depois de observar dificuldades reais, implementar ajuda adaptativa.

Exemplo:

3 quedas semelhantes
   ↓
DICA

Tentativas repetidas contra inimigo
   ↓
DICA

Dificuldade para usar habilidade
   ↓
INDICAÇÃO VISUAL

Não implementar ajuda excessiva antes dos testes.

As dificuldades reais deverão orientar esse sistema.

---

# 33. ETAPA 25 — PERFORMANCE

Com o conteúdo completo, verificar desempenho.

Especial atenção porque o jogo será PWA.

Testar:

- memória;
- FPS;
- carregamento;
- imagens;
- áudio;
- animações;
- tamanho dos assets;
- transições;
- cache;
- dispositivos modestos.

O jogo deverá permanecer fluido em celulares compatíveis com o público esperado.

---

# 34. ETAPA 26 — PWA

Validar especificamente:

- manifest;
- ícones;
- instalação;
- service worker;
- cache;
- atualização;
- orientação de tela;
- fullscreen;
- armazenamento local;
- funcionamento offline quando aplicável;
- retomada do jogo.

Testar:

NAVEGADOR DESKTOP

NAVEGADOR MOBILE

PWA INSTALADO

Diferentes resoluções deverão ser consideradas.

---

# 35. ETAPA 27 — TESTES DE SAVE

Executar testes específicos de persistência.

Cenários:

- fechar durante uma fase;
- fechar no mapa;
- fechar após desbloquear fase;
- atualizar PWA;
- reiniciar dispositivo;
- Game Over;
- obter Pipo;
- encontrar Noz Dourada;
- concluir área secreta.

O jogador não deverá perder progresso inesperadamente.

---

# 36. ETAPA 28 — POLIMENTO FINAL

Revisar todo o jogo.

Verificar:

- interface;
- fontes;
- tamanhos;
- animações;
- transições;
- áudio;
- textos;
- ortografia;
- colisões;
- dificuldade;
- fases;
- narrativa;
- mapa;
- Pipo;
- Coruja;
- vilarejo;
- chefes;
- Game Over;
- save;
- PWA.

Nesta etapa não deverão ser adicionados grandes sistemas novos.

O foco será qualidade.

---

# 37. ETAPA 29 — TESTE COMPLETO DA CAMPANHA

Jogar do início ao final sem utilizar atalhos de desenvolvimento.

Executar:

NOVO JOGO
   ↓
ABERTURA
   ↓
MAPA
   ↓
FASES
   ↓
PIPO
   ↓
MUNDOS
   ↓
CHEFES
   ↓
CHEFÃO FINAL
   ↓
FINAL
   ↓
VILAREJO RECUPERADO

Registrar:

- tempo total;
- mortes;
- Game Overs;
- itens;
- dificuldade;
- bugs;
- pontos cansativos;
- pontos confusos.

---

# 38. ETAPA 30 — VERSÃO CANDIDATA

Gerar uma versão candidata à publicação.

Nesta fase:

NÃO adicionar novas funcionalidades.

Somente corrigir:

- bugs;
- problemas graves de interface;
- performance;
- balanceamento crítico;
- problemas de save;
- problemas de instalação.

Se uma nova ideia surgir, registrar para uma versão futura.

---

# 39. ORDEM RESUMIDA DE DESENVOLVIMENTO

A sequência recomendada será:

1. Diagnóstico
2. Saúde
3. Dano
4. Morte
5. Vidas
6. Game Over
7. Checkpoints
8. Remoção dos textos fixos
9. Tutorial contextual
10. Save
11. Progresso
12. Mapa
13. Resultado de fase
14. Desbloqueio
15. Áreas opcionais
16. Portais
17. Recompensas
18. Nozes Douradas
19. Sistema narrativo
20. Abertura
21. Coruja
22. Progressão narrativa
23. Pipo
24. Troca de personagem
25. Habilidades diferentes
26. Backtracking
27. Curva de dificuldade
28. Novos inimigos
29. Chefes
30. Vilarejo evolutivo
31. Expansão dos mundos
32. Áudio
33. Animações
34. Feedback
35. Balanceamento
36. Testes infantis
37. Ajuda adaptativa
38. Performance
39. PWA
40. Testes de save
41. Polimento
42. Campanha completa
43. Versão candidata

---

# 40. DEPENDÊNCIAS PRINCIPAIS

Algumas funcionalidades não deverão ser desenvolvidas fora de ordem.

## Saúde antes de vidas

SAÚDE
   ↓
MORTE
   ↓
VIDAS
   ↓
GAME OVER

## Save antes do mapa completo

SAVE
   ↓
PROGRESSO
   ↓
MAPA
   ↓
DESBLOQUEIO

## Narrativa antes das animações finais

SISTEMA NARRATIVO
   ↓
CENAS
   ↓
CORUJA
   ↓
PIPO
   ↓
HISTÓRIA COMPLETA

## Pipo antes dos desafios cooperativos

PIPO
   ↓
HABILIDADES
   ↓
TROCA
   ↓
COOPERAÇÃO
   ↓
BACKTRACKING

## Sistemas antes de grande produção de fases

SISTEMAS
   ↓
PROTÓTIPO
   ↓
TESTES
   ↓
VALIDAÇÃO
   ↓
PRODUÇÃO DE CONTEÚDO

---

# 41. O QUE NÃO FAZER

Evitar:

- produzir todas as fases antes de validar as mecânicas;
- criar todos os inimigos simultaneamente;
- produzir todas as animações antes da história estar definida;
- aumentar dificuldade apenas aumentando saúde;
- criar fases enormes sem conteúdo;
- adicionar muitos textos;
- tornar coletáveis obrigatórios sem necessidade;
- criar punições frustrantes sem testes;
- otimizar apenas no final;
- alterar muitos sistemas ao mesmo tempo.

---

# 42. ESTRATÉGIA DE PROTÓTIPOS

Sempre que possível, testar uma nova ideia em apenas uma fase.

Exemplo:

NOVA ÁREA OPCIONAL
   ↓
IMPLEMENTAR NA FASE 1
   ↓
TESTAR
   ↓
CORRIGIR
   ↓
VALIDAR
   ↓
REUTILIZAR NAS DEMAIS

O mesmo princípio deverá ser aplicado a:

- checkpoints;
- portais;
- novos inimigos;
- chefes;
- Pipo;
- segredos;
- tutorial.

---

# 43. MARCOS DO PROJETO

## MARCO A — SOBREVIVÊNCIA

Saúde + vidas + morte + Game Over + checkpoints.

## MARCO B — PROGRESSÃO

Save + mapa + conclusão + desbloqueio.

## MARCO C — EXPLORAÇÃO

Áreas opcionais + recompensas + segredos.

## MARCO D — AVENTURA

Narrativa + Coruja + abertura.

## MARCO E — DUPLA

Pipo + habilidades + cooperação.

## MARCO F — DESAFIO

Dificuldade + inimigos + chefes.

## MARCO G — MUNDO VIVO

Vilarejo + progressão visual.

## MARCO H — CONTEÚDO

Fases e mundos completos.

## MARCO I — QUALIDADE

Áudio + animações + feedback + balanceamento.

## MARCO J — PUBLICAÇÃO

Testes + performance + PWA + versão candidata.

---

# 44. REGRA PARA CADA ETAPA

Nenhuma etapa deverá ser considerada concluída apenas porque:

> “O código funciona.”

Para ser concluída deverá atender:

FUNCIONA
+
É COMPREENSÍVEL
+
É DIVERTIDA
+
NÃO QUEBRA SISTEMAS EXISTENTES
+
FUNCIONA NO PWA
+
PODE SER MANTIDA

---

# 45. DOCUMENTAÇÃO DURANTE A EVOLUÇÃO

As decisões tomadas durante o desenvolvimento deverão atualizar os documentos correspondentes.

Exemplos:

Mudança de gameplay
→ 03_gameplay.md

Mudança de personagem
→ 04_personagens.md

Mudança de mundo
→ 05_fases-e-mundos.md

Mudança técnica
→ 07_arquitetura-tecnica.md

Mudança de roadmap
→ 08_roadmap.md

Mudança narrativa
→ 09_historia-e-narrativa.md

Mudança de testes
→ 10_testes.md

Decisão definitiva
→ 11_decisoes.md

O arquivo evolucao.md permanece como referência geral da evolução planejada.

---

# 46. CRITÉRIO PARA NOVAS IDEIAS

Durante o desenvolvimento surgirão novas ideias.

Antes de implementá-las perguntar:

1. melhora a diversão?
2. melhora a narrativa?
3. melhora a exploração?
4. melhora o desafio?
5. é adequada para crianças?
6. combina com o escopo?
7. depende de algum sistema ainda inexistente?
8. aumenta significativamente a complexidade?
9. precisa entrar nesta versão?

Se não for necessária agora:

BACKLOG
   ↓
VERSÃO FUTURA

Não interromper constantemente o desenvolvimento principal.

---

# 47. SEQUÊNCIA MACRO RECOMENDADA

A evolução completa pode ser visualizada assim:

JOGO ATUAL
    ↓
FUNDAÇÃO
    ↓
SAÚDE / VIDAS
    ↓
CHECKPOINTS
    ↓
TUTORIAL
    ↓
SAVE
    ↓
MAPA
    ↓
PROGRESSÃO
    ↓
EXPLORAÇÃO
    ↓
RECOMPENSAS
    ↓
NARRATIVA
    ↓
CORUJA
    ↓
PIPO
    ↓
COOPERAÇÃO
    ↓
DIFICULDADE
    ↓
INIMIGOS
    ↓
CHEFES
    ↓
VILAREJO
    ↓
NOVAS FASES
    ↓
POLIMENTO
    ↓
TESTES
    ↓
BALANCEAMENTO
    ↓
PWA
    ↓
VERSÃO FINAL

---

# 48. DIRETRIZ FINAL

O principal objetivo desta sequência é impedir que a expansão do jogo gere um projeto grande, difícil de manter e cheio de sistemas incompletos.

A evolução deverá acontecer sempre em ciclos pequenos:

PLANEJAR
   ↓
IMPLEMENTAR
   ↓
JOGAR
   ↓
OBSERVAR
   ↓
CORRIGIR
   ↓
VALIDAR
   ↓
DOCUMENTAR
   ↓
CONTINUAR

A prioridade não será desenvolver rapidamente todas as funcionalidades.

A prioridade será construir uma base sólida sobre a qual novas fases, personagens, inimigos e histórias possam ser adicionados com segurança.

O jogo deverá permanecer jogável durante todo o desenvolvimento.

A cada grande marco deverá existir uma versão que possa ser iniciada, jogada e avaliada.

---

# 49. RESULTADO ESPERADO

Ao final destas etapas, **Tico e a Floresta das Nozes** deverá possuir:

- história completa;
- abertura narrativa;
- mapa do mundo;
- progressão;
- save;
- sistema de saúde;
- vidas;
- Game Over;
- checkpoints;
- tutorial contextual;
- exploração;
- áreas opcionais;
- recompensas;
- coletáveis;
- segredos;
- Tico;
- Pipo;
- Coruja;
- habilidades distintas;
- cooperação;
- inimigos variados;
- dificuldade progressiva;
- chefes;
- vilarejo evolutivo;
- fases mais longas;
- mundos distintos;
- áudio;
- animações;
- feedback;
- suporte PWA;
- experiência adequada para crianças.

O resultado não deverá ser apenas um jogo maior.

Deverá ser um jogo:

**mais divertido, mais claro, mais variado, mais desafiador, mais envolvente e mais profissional.**

---

**FIM DO DOCUMENTO**