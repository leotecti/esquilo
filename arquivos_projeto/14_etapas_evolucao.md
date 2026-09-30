# TICO E A FLORESTA DAS NOZES

# ETAPAS DE EVOLUÇÃO DO JOGO

**Arquivo:** 14_etapas_evolucao.md
**Versão:** 1.1
**Status:** Planejamento de desenvolvimento  
**Documento relacionado:** [13_evolucao.md](13_evolucao.md)

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

Cada etapa deverá produzir uma versão jogável. Preservar e melhorar o que já funciona: saúde, dano, retorno, checkpoints, save, Pipo, troca, habilidades, mundos, áudio e PWA. “Criar” e “implementar” nas seções abaixo significam completar lacunas ou ampliar os sistemas existentes quando já houver uma base.

A cada etapa, verificar PWA (desktop, toque, offline e atualização conforme o impacto), desempenho e migração/persistência do save. E25, E26 e E27 são auditorias completas adicionais.

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

A evolução usa identificadores **E00–E30**, distintos das etapas do roadmap original. Todos os itens detalhados foram mantidos. Os dois pontos de validação intermediária são checkpoints de projeto; os marcos A–J agrupam entregas e não renumeram as etapas.

- **E00 — PREPARAÇÃO E DIAGNÓSTICO**
- **E01 — SAÚDE, DANO E MORTE**
- **E02 — VIDAS E GAME OVER**
- **E03 — CHECKPOINTS E REINÍCIO**
- **E04 — LIMPEZA DA INTERFACE E TUTORIAL CONTEXTUAL**
- **E05 — SISTEMA DE PROGRESSO E SALVAMENTO**
- **E06 — MAPA DO MUNDO**
- **E07 — RESULTADO E DESBLOQUEIO DE FASES**
- **E08 — ÁREAS OPCIONAIS E EXPLORAÇÃO**
- **E09 — RECOMPENSAS E COLETÁVEIS**
- **E10 — ESTRUTURA NARRATIVA**
- **E11 — ABERTURA DO JOGO**
- **E12 — CORUJA E PROGRESSÃO DA HISTÓRIA**
- **E13 — INTRODUÇÃO DE PIPO**
- **E14 — MECÂNICAS DE TICO E PIPO**
- **E15 — BACKTRACKING CONTROLADO**
- **E16 — PROGRESSÃO DE DIFICULDADE**
- **E17 — NOVOS INIMIGOS**
- **E18 — CHEFES**
- **E19 — VILAREJO EVOLUTIVO**
- **E20 — EXPANSÃO DAS FASES E MUNDOS**
- **E21 — ÁUDIO, ANIMAÇÕES E FEEDBACK**
- **E22 — BALANCEAMENTO**
- **E23 — TESTES COM CRIANÇAS**
- **E24 — AJUDA ADAPTATIVA**
- **E25 — PERFORMANCE**
- **E26 — PWA**
- **E27 — TESTES DE SAVE**
- **E28 — POLIMENTO FINAL**
- **E29 — TESTE COMPLETO DA CAMPANHA**
- **E30 — VERSÃO CANDIDATA**

---

# 4. EVOLUÇÃO E00 — PREPARAÇÃO E DIAGNÓSTICO

**Status:** concluída. [Diagnóstico](15_diagnostico_e00.md) e
[verificação da base](../tests/evolucao_e00.md): 182 verificações na Godot,
cinco cenários Web e amostra de desempenho local. Gameplay preservado.

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

# 5. EVOLUÇÃO E01 — SAÚDE, DANO E MORTE

**Status:** implementada e verificada sobre o sistema existente. Correções na
coleta contínua de coração e na validação da recuperação; três corações, dano,
proteção e retorno preservados. [Registro E01](../tests/evolucao_e01.md).

Revisar e manter o sistema de saúde existente, completando apenas as lacunas necessárias à evolução.

Antes de integrar vidas e Game Over, verificar a regra existente de morte e sua ligação com os checkpoints.

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

# 6. EVOLUÇÃO E02 — VIDAS E GAME OVER

**Implementada em 2026-09-30 (0.10.0); playtest do usuário pendente.**
Três vidas compartilhadas, medalhão de vida extra e retorno persistente ao mundo
anterior. A tela transitória permite escolher entre as fases já liberadas, com
a primeira fase do mundo de retorno selecionada. Pipo resgatado permanece disponível.
O mapa visual continua reservado à E06. [Execução e testes](../tests/evolucao_e02.md).

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

Ao esgotar as vidas compartilhadas pela dupla, apresentar Game Over e retornar ao mapa do mundo anterior ao da fase em que ocorreu a derrota. No Mundo 1, permanecer no mapa do Mundo 1. Restaurar as vidas ao valor inicial configurado.

Preservar fases desbloqueadas e concluídas, personagens liberados e conquistas permanentes. O retorno muda a localização no mapa; não bloqueia novamente os mundos já acessíveis nem apaga a campanha. A seleção inicial aponta para a primeira fase do mundo de retorno. Morte com vidas restantes continua usando o checkpoint da fase.

Salvar o estado resultante antes de permitir nova seleção; fechar e reabrir deve manter esse resultado. Quantidade inicial de vidas e frequência das recompensas serão balanceadas em testes.

Em E02, preparar e testar o estado de retorno; E06 integra esse estado ao mapa visual. Até lá, usar uma tela transitória de retorno que identifique o mundo de destino.

## Resultado esperado

O jogador possui saúde, pode morrer, perder vidas e chegar ao Game Over.

---

# 7. EVOLUÇÃO E03 — CHECKPOINTS E REINÍCIO

Manter o retorno ao checkpoint para morte com vidas restantes. Integrar a regra aprovada de Game Over ao mundo anterior, descrita em E02.

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

# 8. EVOLUÇÃO E04 — LIMPEZA DA INTERFACE E TUTORIAL CONTEXTUAL

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
- desaparecer após interação;
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

# 9. EVOLUÇÃO E05 — SISTEMA DE PROGRESSO E SALVAMENTO

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

# 10. EVOLUÇÃO E06 — MAPA DO MUNDO

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

# 11. EVOLUÇÃO E07 — RESULTADO E DESBLOQUEIO DE FASES

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

# 12. VALIDAÇÃO INTERMEDIÁRIA 1 — LOOP PRINCIPAL FUNCIONAL

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

# 13. EVOLUÇÃO E08 — ÁREAS OPCIONAIS E EXPLORAÇÃO

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

# 14. EVOLUÇÃO E09 — RECOMPENSAS E COLETÁVEIS

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

# 15. EVOLUÇÃO E10 — ESTRUTURA NARRATIVA

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

# 16. EVOLUÇÃO E11 — ABERTURA DO JOGO

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

# 17. EVOLUÇÃO E12 — CORUJA E PROGRESSÃO DA HISTÓRIA

Transformar a Coruja em mentora recorrente e aliada. Substituir a chefe coruja pelo Gavião da Montanha; a Coruja não participa de combates como adversária.

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

# 18. EVOLUÇÃO E13 — INTRODUÇÃO DE PIPO

Preservar o resgate jogável de Pipo em 1-3 e melhorar sua apresentação narrativa. Antes do resgate, somente Tico fica disponível. Depois, registrar Pipo como desbloqueado globalmente e permitir sua seleção também nas fases iniciais revisitadas.

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

# 19. EVOLUÇÃO E14 — MECÂNICAS DE TICO E PIPO

Manter as diferenças já implementadas e melhorar os trechos que precisarem de ajuste.

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

Manter a troca de personagem e condicioná-la ao desbloqueio global de Pipo, incluindo fases revisitadas.

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

# 20. EVOLUÇÃO E15 — BACKTRACKING CONTROLADO

Após o desbloqueio global de Pipo, permitir revisitar fases iniciais com a dupla e adicionar pequenos segredos. Antes do resgate, Pipo permanece indisponível. Preservar o desbloqueio em morte, Game Over, troca de fase e reabertura.

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

# 21. VALIDAÇÃO INTERMEDIÁRIA 2 — AVENTURA COMPLETA EM MINIATURA

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

# 22. EVOLUÇÃO E16 — PROGRESSÃO DE DIFICULDADE

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

# 23. EVOLUÇÃO E17 — NOVOS INIMIGOS

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

# 24. EVOLUÇÃO E18 — CHEFES

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

# 25. EVOLUÇÃO E19 — VILAREJO EVOLUTIVO

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

# 26. EVOLUÇÃO E20 — EXPANSÃO DAS FASES E MUNDOS

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

# 27. EVOLUÇÃO E21 — ÁUDIO, ANIMAÇÕES E FEEDBACK

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

# 28. EVOLUÇÃO E22 — BALANCEAMENTO

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
- duração, a validar após uma fase completa da evolução estar implementada;
- dificuldade dos chefes.

Evitar inserir números diretamente em muitos pontos do código.

Valores importantes deverão ser configuráveis.

Isso permitirá experimentar rapidamente.

---

# 29. DECISÃO SOBRE GAME OVER

A consequência foi aprovada pelo usuário: Game Over retorna ao mapa do mundo anterior, mantendo fases desbloqueadas, Pipo e conquistas permanentes. No primeiro mundo, o retorno permanece nele. Ver regra completa em E02.

Validar clareza do retorno, restauração de vidas, persistência, frustração e disposição para continuar. Balancear vidas e recompensas; não reabrir os modelos de apagamento de campanha ou bloqueio de fases como decisões pendentes.

---

# 30. EVOLUÇÃO E23 — TESTES COM CRIANÇAS

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

# 32. EVOLUÇÃO E24 — AJUDA ADAPTATIVA

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

# 33. EVOLUÇÃO E25 — PERFORMANCE

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

# 34. EVOLUÇÃO E26 — PWA

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

# 35. EVOLUÇÃO E27 — TESTES DE SAVE

Executar testes específicos de persistência.

Cenários:

- fechar durante uma fase;
- fechar no mapa;
- fechar após desbloquear fase;
- atualizar PWA;
- reiniciar dispositivo;
- Game Over;
- obter Pipo e usá-lo em fases iniciais após o desbloqueio;
- impedir Pipo nas fases iniciais antes do resgate;
- retornar ao mapa do mundo anterior no Game Over sem perder desbloqueios;
- encontrar Noz Dourada;
- concluir área secreta.

O jogador não deverá perder progresso inesperadamente.

---

# 36. EVOLUÇÃO E28 — POLIMENTO FINAL

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

# 37. EVOLUÇÃO E29 — TESTE COMPLETO DA CAMPANHA

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

# 38. EVOLUÇÃO E30 — VERSÃO CANDIDATA

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

## Saúde validada antes de vidas

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

O arquivo 13_evolucao.md permanece como referência geral da evolução planejada.

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
