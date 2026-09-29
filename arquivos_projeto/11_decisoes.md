# TICO E A FLORESTA DAS NOZES

## REGISTRO DE DECISÕES DO PROJETO

**Versão:** 1.0  
**Documento:** 11_decisoes.md

---

# 1. OBJETIVO

Este documento registra as principais decisões de design, narrativa, gameplay, arquitetura, tecnologia e produção de **Tico e a Floresta das Nozes**.

Seu objetivo é responder:

**O QUE FOI DECIDIDO?**

**POR QUE FOI DECIDIDO?**

**QUAIS ALTERNATIVAS FORAM CONSIDERADAS?**

**ESSA DECISÃO AINDA É VÁLIDA?**

O documento deverá crescer durante todo o desenvolvimento.

---

# 2. POR QUE REGISTRAR DECISÕES?

Durante o desenvolvimento surgirão dúvidas como:

> Por que estamos usando Godot?

> Por que PWA?

> Por que Tico plana segurando o botão de pulo?

> Por que Pipo sempre usa camisa verde?

> Por que não existe backend?

> Por que existem apenas dois personagens jogáveis?

Essas decisões não deverão depender apenas da memória da equipe.

Deverão estar registradas.

---

# 3. PRINCÍPIO

Uma decisão importante deverá possuir:

```text
DECISÃO
   ↓
CONTEXTO
   ↓
MOTIVO
   ↓
IMPACTO
   ↓
STATUS
```

---

# 4. IDENTIFICAÇÃO

Cada decisão receberá um identificador.

Formato:

```text
DEC-001
DEC-002
DEC-003
...
```

---

# 5. STATUS

Utilizar:

```text
PROPOSTA
DECIDIDA
EM VALIDAÇÃO
ALTERADA
SUBSTITUÍDA
CANCELADA
```

---

# 6. REGRA PARA ALTERAÇÃO

Uma decisão registrada poderá mudar.

O documento não deverá impedir mudanças.

Ele deverá explicar:

**POR QUE MUDAMOS.**

Não apagar silenciosamente uma decisão antiga.

Quando necessário:

```text
DEC-015

STATUS:
SUBSTITUÍDA

SUBSTITUÍDA POR:
DEC-042
```

Isso preserva o histórico.

---

# 7. MODELO DE NOVA DECISÃO

```text
## DEC-XXX — TÍTULO

DATA:
____

CATEGORIA:
____

STATUS:
DECIDIDA

CONTEXTO:
____

DECISÃO:
____

MOTIVO:
____

ALTERNATIVAS:
____

IMPACTOS:
____

VALIDAÇÃO:
____

OBSERVAÇÕES:
____
```

---

# 8. DEC-001 — ENGINE GODOT

**Categoria:** Arquitetura  
**Status:** DECIDIDA

## Contexto

O projeto necessita de uma engine adequada para:

- jogos 2D;
- plataforma;
- animações;
- física;
- áudio;
- interface;
- exportação multiplataforma;
- Web.

## Decisão

Utilizar:

**GODOT ENGINE 4**

## Motivo

Godot atende adequadamente ao escopo do projeto e permite manter gameplay, cenas, interface e lógica dentro de uma única engine.

## Impacto

Toda arquitetura principal será construída considerando Godot.

---

# 9. DEC-002 — GDSCRIPT

**Categoria:** Arquitetura  
**Status:** DECIDIDA

## Decisão

Utilizar:

**GDScript**

como linguagem principal.

## Motivo

Priorizar:

- simplicidade;
- integração com Godot;
- produtividade;
- prototipação rápida;
- manutenção.

## Alternativa considerada

C#.

## Resultado

C# não será necessário na primeira versão.

---

# 10. DEC-003 — JOGO 2D

**Categoria:** Design / Tecnologia  
**Status:** DECIDIDA

## Decisão

O jogo será:

**2D SIDE-SCROLLING PLATFORMER**

## Motivo

Esse formato combina com:

- Tico;
- exploração;
- plataformas;
- salto;
- planar;
- cooperação;
- público infantil;
- direção artística proposta.

---

# 11. DEC-004 — PWA COMO DISTRIBUIÇÃO PRINCIPAL

**Categoria:** Plataforma  
**Status:** DECIDIDA

## Decisão

A principal estratégia inicial de distribuição será:

**WEB / PWA**

## Objetivo

Permitir:

```text
ABRIR LINK
   ↓
JOGAR
   ↓
INSTALAR, SE DESEJADO
```

## Motivo

Reduzir barreira de entrada.

O jogador não deverá obrigatoriamente:

- baixar instalador;
- configurar ambiente;
- instalar Godot;
- criar conta.

---

# 12. DEC-005 — WINDOWS COMO AMBIENTE PRINCIPAL DE DESENVOLVIMENTO

**Categoria:** Plataforma  
**Status:** DECIDIDA

## Decisão

O desenvolvimento principal será realizado em:

**WINDOWS**

## Impacto

Builds Windows deverão ser gerados desde os primeiros protótipos.

---

# 13. DEC-006 — ANDROID COMO PLATAFORMA ADICIONAL

**Categoria:** Plataforma  
**Status:** DECIDIDA

## Decisão

O jogo deverá ser projetado para permitir também:

```text
APK / AAB
```

## Observação

A primeira experiência mobile poderá ocorrer através do PWA.

A versão Android nativa poderá ser produzida conforme evolução do projeto.

---

# 14. DEC-007 — UMA BASE PRINCIPAL DE CÓDIGO

**Categoria:** Arquitetura  
**Status:** DECIDIDA

## Decisão

Não manter jogos separados para:

- Web;
- Android;
- Windows.

Utilizar:

```text
             GODOT
               │
       GAMEPLAY PRINCIPAL
               │
      ┌────────┼────────┐
      │        │        │
     WEB    ANDROID   WINDOWS
```

## Motivo

Reduzir:

- duplicação;
- manutenção;
- bugs;
- divergência entre versões.

---

# 15. DEC-008 — LANDSCAPE

**Categoria:** Interface  
**Status:** DECIDIDA

## Decisão

Orientação principal:

**LANDSCAPE**

## Motivo

O gameplay horizontal de plataforma se beneficia de maior campo visual lateral.

---

# 16. DEC-009 — PROPORÇÃO 16:9

**Categoria:** Visual  
**Status:** DECIDIDA

## Decisão

O projeto terá:

**16:9**

como proporção visual de referência.

## Observação

A interface deverá adaptar-se a diferentes telas.

---

# 17. DEC-010 — TOUCHSCREEN DESDE O INÍCIO

**Categoria:** Input  
**Status:** DECIDIDA

## Decisão

Touchscreen não será adicionado apenas no final.

Deverá ser testado desde os primeiros protótipos Web/PWA.

## Motivo

Evitar construir mecânicas confortáveis apenas no teclado que depois sejam difíceis de adaptar ao celular.

---

# 18. DEC-011 — INPUT ABSTRATO

**Categoria:** Arquitetura  
**Status:** DECIDIDA

## Decisão

Gameplay responderá a ações:

```text
move_left
move_right
jump
action
switch_character
pause
```

e não diretamente a dispositivos específicos.

## Arquitetura

```text
TECLADO ─┐
TOUCH ───┼→ INPUT MAP → GAMEPLAY
GAMEPAD ─┘
```

---

# 19. DEC-012 — CONTROLES SIMPLES

**Categoria:** Gameplay  
**Status:** DECIDIDA

## Decisão

Evitar grande quantidade de botões.

Princípio:

**POUCOS CONTROLES + MUITAS POSSIBILIDADES**

## Motivo

Público infantil e uso em touchscreen.

---

# 20. DEC-013 — PLANAR UTILIZANDO PULO

**Categoria:** Gameplay  
**Status:** EM VALIDAÇÃO

## Proposta

Tico deverá planar através do mesmo botão utilizado para pular.

```text
PULAR
  ↓
TICO NO AR
  ↓
MANTER PULO
  ↓
PLANAR
```

## Motivo

Evitar botão adicional no touchscreen.

## Validação necessária

Playtests deverão confirmar se a interação é intuitiva.

Caso não seja:

a decisão poderá ser revista.

---

# 21. DEC-014 — TICO REPRESENTA AGILIDADE

**Categoria:** Gameplay / Personagem  
**Status:** DECIDIDA

## Decisão

A principal identidade de gameplay de Tico será:

**AGILIDADE**

Características:

- salto;
- mobilidade;
- planar;
- plataformas altas;
- espaços estreitos;
- exploração.

---

# 22. DEC-015 — PIPO REPRESENTA FORÇA

**Categoria:** Gameplay / Personagem  
**Status:** DECIDIDA

## Decisão

A principal identidade de gameplay de Pipo será:

**FORÇA**

Características:

- empurrar;
- quebrar;
- investir;
- ativar mecanismos de peso;
- mover objetos pesados.

---

# 23. DEC-016 — COMPLEMENTARIDADE

**Categoria:** Gameplay  
**Status:** DECIDIDA

## Decisão

A relação central será:

```text
TICO = AGILIDADE

PIPO = FORÇA

TICO + PIPO = COOPERAÇÃO
```

Nenhum deverá simplesmente substituir o outro.

---

# 24. DEC-017 — PIPO NÃO ESTARÁ EM TODAS AS FASES

**Categoria:** Gameplay / Narrativa  
**Status:** DECIDIDA

## Decisão

Pipo será importante, mas não precisará acompanhar Tico em absolutamente todas as situações.

## Motivo

Permitir:

- fases focadas em Tico;
- variedade;
- desenvolvimento narrativo;
- momentos especiais da dupla.

---

# 25. DEC-018 — TROCA DE PERSONAGENS

**Categoria:** Gameplay  
**Status:** DECIDIDA

## Decisão

Algumas fases permitirão alternar:

```text
TICO ↔ PIPO
```

## Objetivo

Criar desafios baseados na complementaridade dos dois.

---

# 26. DEC-019 — PIPO SEMPRE USA CAMISA VERDE

**Categoria:** Direção Visual  
**Status:** DECIDIDA / REGRA PERMANENTE

## Decisão

Pipo deverá:

**SEMPRE USAR CAMISA VERDE.**

Aplica-se a:

- gameplay;
- sprites;
- cutscenes;
- ilustrações;
- menus;
- material promocional;
- capas;
- animações.

## Motivo

A camisa verde é parte da identidade visual do personagem.

## Regra

Iluminação, sombra e textura poderão alterar sua aparência momentaneamente.

A identidade da camisa deverá continuar:

**VERDE.**

---

# 27. DEC-020 — TICO COM CAUDA COMO ELEMENTO PRINCIPAL

**Categoria:** Direção Visual / Gameplay  
**Status:** DECIDIDA

## Decisão

A grande cauda de Tico será:

- elemento de silhueta;
- elemento de personalidade;
- elemento de animação;
- elemento de gameplay.

Ela estará diretamente relacionada ao:

**PLANAR.**

---

# 28. DEC-021 — DESIGN INFANTIL E AMIGÁVEL

**Categoria:** Direção Visual  
**Status:** DECIDIDA

## Decisão

O visual deverá priorizar:

- formas arredondadas;
- cores agradáveis;
- leitura clara;
- personagens expressivos;
- silhuetas reconhecíveis.

Evitar:

- realismo excessivo;
- violência gráfica;
- horror;
- ambientes excessivamente sombrios.

---

# 29. DEC-022 — VIOLÊNCIA NÃO EXPLÍCITA

**Categoria:** Gameplay / Público  
**Status:** DECIDIDA

## Decisão

Inimigos derrotados poderão:

- ficar tontos;
- fugir;
- desaparecer;
- gerar fumaça;
- realizar animação engraçada.

Não utilizar:

- sangue;
- ferimentos realistas;
- morte explícita.

---

# 30. DEC-023 — CORAÇÕES

**Categoria:** Gameplay  
**Status:** DECIDIDA

## Decisão

Utilizar sistema simples de:

**CORAÇÕES**

para representar resistência/vida.

## Objetivo

Comunicação visual imediata.

---

# 31. DEC-024 — INVULNERABILIDADE APÓS DANO

**Categoria:** Gameplay  
**Status:** DECIDIDA

## Decisão

Depois de receber dano:

o personagem possuirá pequeno período de invulnerabilidade.

## Motivo

Evitar múltiplos danos instantâneos e situações frustrantes.

---

# 32. DEC-025 — CHECKPOINTS

**Categoria:** Gameplay  
**Status:** DECIDIDA

## Decisão

Fases maiores utilizarão checkpoints.

## Motivo

Reduzir punição e repetição desnecessária.

---

# 33. DEC-026 — BAIXA PUNIÇÃO

**Categoria:** Gameplay / Público  
**Status:** DECIDIDA

## Decisão

O jogo não será construído sobre punição severa.

Priorizar:

```text
ERRO
↓
APRENDIZADO
↓
NOVA TENTATIVA
```

e não:

```text
ERRO
↓
GRANDE PERDA
↓
REPETIÇÃO EXTENSA
```

---

# 34. DEC-027 — CINCO MUNDOS

**Categoria:** Conteúdo  
**Status:** DECIDIDA

## Estrutura

```text
1. Bosque das Folhas

2. Rio das Pedras

3. Montanha das Corujas

4. Vila dos Castores

5. Árvore do Mestre Corvo
```

---

# 35. DEC-028 — TRÊS FASES PRINCIPAIS POR MUNDO

**Categoria:** Conteúdo  
**Status:** DECIDIDA

## Decisão

Estrutura inicial:

```text
5 mundos
×
3 fases
=
15 fases principais
```

## Observação

Fases secretas ou extras poderão existir futuramente.

---

# 36. DEC-029 — UM CONCEITO PRINCIPAL POR MUNDO

**Categoria:** Level Design  
**Status:** DECIDIDA

## Estrutura

```text
MUNDO 1
APRENDER

MUNDO 2
INTERAGIR

MUNDO 3
EXPLORAR

MUNDO 4
COOPERAR

MUNDO 5
DOMINAR
```

Cada mundo introduzirá ou aprofundará uma ideia central.

---

# 37. DEC-030 — MECÂNICA ANTES DO DESAFIO

**Categoria:** Level Design  
**Status:** DECIDIDA

## Decisão

Fluxo:

```text
APRESENTAR
↓
EXPERIMENTAR
↓
REPETIR
↓
VARIAR
↓
COMBINAR
↓
DESAFIAR
```

Não exigir domínio de uma mecânica antes de permitir que o jogador a compreenda.

---

# 38. DEC-031 — NOZES COMO RECOMPENSA E ORIENTAÇÃO

**Categoria:** Gameplay / Level Design  
**Status:** DECIDIDA

## Decisão

Nozes não serão apenas pontuação.

Também poderão:

- orientar caminhos;
- sugerir saltos;
- indicar segredos;
- recompensar exploração.

---

# 39. DEC-032 — SEGREDOS OPCIONAIS

**Categoria:** Gameplay  
**Status:** DECIDIDA

## Decisão

Exploração adicional deverá recompensar o jogador, mas não será obrigatória para concluir a história principal.

---

# 40. DEC-033 — MESTRE CORVO NÃO SERÁ SIMPLESMENTE MAU

**Categoria:** Narrativa  
**Status:** DECIDIDA

## Decisão

Mestre Corvo será o antagonista, mas terá motivação compreensível.

Sua comunidade enfrenta escassez de alimento.

## Erro

Ele escolheu roubar recursos de outras comunidades.

## Princípio

```text
PROBLEMA REAL
+
SOLUÇÃO ERRADA
```

---

# 41. DEC-034 — RESOLUÇÃO POR COOPERAÇÃO

**Categoria:** Narrativa  
**Status:** DECIDIDA

## Decisão

A história não terminará simplesmente com:

**MESTRE CORVO DERROTADO.**

O desfecho será construído em torno de:

- compreensão;
- cooperação;
- compartilhamento;
- solução coletiva.

---

# 42. DEC-035 — FRASE TEMÁTICA

**Categoria:** Narrativa  
**Status:** DECIDIDA

## Frase

> **Quando trabalhamos juntos, todos podem ter um lugar à mesa.**

## Uso

Representará a mensagem final da aventura.

A narrativa deverá preparar essa ideia durante todo o jogo.

---

# 43. DEC-036 — HISTÓRIA PROGRESSIVA

**Categoria:** Narrativa  
**Status:** DECIDIDA

## Decisão

Não revelar toda a história no início.

Utilizar:

```text
PISTA
↓
DESCOBERTA
↓
NOVA PERGUNTA
↓
NOVA PISTA
```

---

# 44. DEC-037 — HISTÓRIA AO FINAL DAS FASES

**Categoria:** Narrativa  
**Status:** DECIDIDA

## Decisão

O final de cada fase deverá avançar a narrativa.

A criança deverá sentir:

**“DESCOBRI ALGUMA COISA.”**

---

# 45. DEC-038 — ABERTURA NARRATIVA

**Categoria:** Narrativa  
**Status:** DECIDIDA

## Decisão

O jogo começará apresentando:

- floresta;
- preparação para o inverno;
- Tico;
- personalidade de Tico;
- nozes;
- desaparecimento das nozes;
- início da investigação.

Depois:

**FASE 1-1.**

---

# 46. DEC-039 — PIPO ENTRA NA HISTÓRIA DURANTE O JOGO

**Categoria:** Narrativa  
**Status:** DECIDIDA

## Decisão

Pipo não começará simplesmente ao lado de Tico.

Tico irá encontrá-lo:

**PRESO EM UMA ARMADILHA.**

O jogador participará de seu resgate.

---

# 47. DEC-040 — AMIZADE PROGRESSIVA

**Categoria:** Narrativa  
**Status:** DECIDIDA

## Estrutura

```text
MUNDO 1
se conhecem

MUNDO 2
aprendem a cooperar

MUNDO 3
desenvolvem confiança

MUNDO 4
funcionam como dupla

MUNDO 5
resolvem problemas juntos
```

---

# 48. DEC-041 — CUTSCENES CURTAS

**Categoria:** Narrativa / UX  
**Status:** DECIDIDA

## Decisão

Cenas comuns deverão ser curtas.

Priorizar:

- animação;
- expressão;
- ação;
- poucas falas.

## Exceções

Poderão ser maiores:

- abertura;
- encontro com Pipo;
- revelação de Mestre Corvo;
- final.

---

# 49. DEC-042 — CUTSCENES DENTRO DA ENGINE

**Categoria:** Arquitetura / Narrativa  
**Status:** DECIDIDA

## Decisão

Priorizar cutscenes construídas dentro da Godot.

## Motivo

Facilitar:

- alterações;
- tradução;
- reutilização;
- adaptação de resolução;
- PWA;
- tamanho do jogo.

Evitar depender inicialmente de vídeos pré-renderizados.

---

# 50. DEC-043 — CUTSCENES PODERÃO SER PULADAS

**Categoria:** UX  
**Status:** DECIDIDA

## Decisão

Cenas deverão permitir pular quando apropriado.

Especialmente quando já foram assistidas.

## Motivo

Evitar obrigar o jogador a rever uma cena ao repetir uma fase.

---

# 51. DEC-044 — NARRATIVA AMBIENTAL

**Categoria:** Narrativa  
**Status:** DECIDIDA

## Decisão

Parte da história será comunicada através de:

- penas;
- caixas;
- alimentos;
- pegadas;
- mecanismos;
- cenário;
- personagens ao fundo;
- rotas.

## Princípio

**MOSTRAR ANTES DE EXPLICAR.**

---

# 52. DEC-045 — CADA MUNDO POSSUI UMA PERGUNTA NARRATIVA

**Categoria:** Narrativa  
**Status:** DECIDIDA

## Estrutura

```text
MUNDO 1
O que aconteceu?

MUNDO 2
Quem transporta a comida?

MUNDO 3
Para onde ela está indo?

MUNDO 4
Como a operação funciona?

MUNDO 5
Por que Mestre Corvo fez isso?
```

---

# 53. DEC-046 — SEM BACKEND NO MVP

**Categoria:** Arquitetura  
**Status:** DECIDIDA

## Decisão

O MVP não terá:

- API;
- servidor de aplicação;
- banco de dados;
- contas;
- login;
- ranking online;
- multiplayer;
- sincronização em nuvem.

## Motivo

Esses sistemas não são necessários para validar o jogo.

---

# 54. DEC-047 — SAVE LOCAL

**Categoria:** Arquitetura  
**Status:** DECIDIDA

## Decisão

O progresso inicial será armazenado localmente.

## PWA

O save deverá persistir no ambiente local disponibilizado para a aplicação Web.

## Limitação aceita

Inicialmente não haverá sincronização automática entre dispositivos.

---

# 55. DEC-048 — SAVE VERSIONADO

**Categoria:** Arquitetura  
**Status:** DECIDIDA

## Decisão

O save deverá possuir:

```text
save_version
```

## Motivo

Permitir futuras alterações de estrutura e migração.

---

# 56. DEC-049 — OFFLINE COMO OBJETIVO DO PWA

**Categoria:** Plataforma  
**Status:** DECIDIDA

## Decisão

Depois dos recursos necessários terem sido obtidos, o PWA deverá buscar permitir gameplay sem conexão contínua.

## Validação

Funcionamento offline deverá fazer parte dos testes.

---

# 57. DEC-050 — HTTPS PARA PRODUÇÃO WEB

**Categoria:** Infraestrutura  
**Status:** DECIDIDA

## Decisão

A publicação Web/PWA deverá utilizar:

**HTTPS.**

---

# 58. DEC-051 — HOSPEDAGEM ESTÁTICA/COMPARTILHADA É SUFICIENTE INICIALMENTE

**Categoria:** Infraestrutura  
**Status:** DECIDIDA

## Decisão

Não contratar ou estruturar VPS apenas para executar o MVP.

A versão inicial poderá utilizar hospedagem adequada para os arquivos Web exportados.

## Futuro

VPS/backend poderá ser considerado caso surjam:

- contas;
- API;
- sincronização;
- ranking;
- serviços online.

---

# 59. DEC-052 — 60 FPS COMO ALVO

**Categoria:** Performance  
**Status:** DECIDIDA

## Decisão

Utilizar:

**60 FPS**

como alvo inicial de experiência quando viável nos dispositivos definidos como alvo.

## Observação

Estabilidade e jogabilidade têm prioridade sobre efeitos visuais excessivos.

---

# 60. DEC-053 — PERFORMANCE MOBILE/WEB DESDE CEDO

**Categoria:** Performance  
**Status:** DECIDIDA

## Decisão

Não otimizar apenas no final.

Cada marco importante deverá ser testado em Web/mobile.

---

# 61. DEC-054 — ARTE PROVISÓRIA NO PROTÓTIPO

**Categoria:** Produção  
**Status:** DECIDIDA

## Decisão

O primeiro protótipo poderá utilizar:

- formas simples;
- placeholders;
- sprites temporários.

## Motivo

Validar gameplay antes de investir fortemente em arte.

---

# 62. DEC-055 — VERTICAL SLICE ANTES DA PRODUÇÃO COMPLETA

**Categoria:** Produção  
**Status:** DECIDIDA

## Decisão

Depois do protótipo funcional:

produzir um:

**VERTICAL SLICE**

antes dos cinco mundos completos.

## Objetivo

Validar:

- arte;
- animação;
- áudio;
- interface;
- gameplay;
- desempenho;
- PWA.

---

# 63. DEC-056 — MUNDO 1 COMO REFERÊNCIA DE PRODUÇÃO

**Categoria:** Produção  
**Status:** DECIDIDA

## Decisão

Completar e validar:

**BOSQUE DAS FOLHAS**

antes da produção em escala dos mundos seguintes.

## Motivo

O Mundo 1 estabelecerá:

- pipeline;
- qualidade;
- ritmo;
- estrutura;
- processo.

---

# 64. DEC-057 — TESTAR ANTES DE EXPANDIR

**Categoria:** Produção  
**Status:** DECIDIDA

## Decisão

Princípio:

```text
CONSTRUIR
↓
JOGAR
↓
TESTAR
↓
APRENDER
↓
CORRIGIR
↓
EXPANDIR
```

---

# 65. DEC-058 — TICO PRECISA SER DIVERTIDO ANTES DO RESTO

**Categoria:** Produção / Gameplay  
**Status:** DECIDIDA

## Decisão

Não avançar significativamente para sistemas complexos enquanto:

**MOVIMENTO + SALTO + PLANAR**

de Tico não forem satisfatórios.

---

# 66. DEC-059 — PLAYTEST COM CRIANÇAS

**Categoria:** Testes  
**Status:** DECIDIDA

## Decisão

O projeto deverá incluir testes com crianças compatíveis com o público-alvo.

## Objetivo

Observar:

- compreensão;
- controles;
- dificuldade;
- diversão;
- curiosidade;
- frustração.

---

# 67. DEC-060 — OBSERVAR ANTES DE EXPLICAR

**Categoria:** Testes  
**Status:** DECIDIDA

## Decisão

Durante playtests:

evitar explicar imediatamente o que o jogador deve fazer.

## Motivo

Uma explicação externa pode esconder problemas de:

- UI;
- level design;
- gameplay;
- comunicação visual.

---

# 68. DEC-061 — ERRO POR DESAFIO ≠ ERRO POR CONFUSÃO

**Categoria:** Testes / Design  
**Status:** DECIDIDA

## Decisão

Diferenciar:

```text
ERRO POR DESAFIO
```

de:

```text
ERRO POR CONFUSÃO
```

## Princípio

O primeiro pode fazer parte do jogo.

O segundo normalmente indica algo que precisa ser melhor comunicado.

---

# 69. DEC-062 — NÃO DEPENDER SOMENTE DE COR

**Categoria:** Acessibilidade / Visual  
**Status:** DECIDIDA

## Decisão

Informações importantes deverão utilizar combinação de:

- cor;
- forma;
- símbolo;
- animação;
- posição.

---

# 70. DEC-063 — TEXTO CURTO E LEGÍVEL

**Categoria:** Interface / Narrativa  
**Status:** DECIDIDA

## Decisão

Textos deverão ser:

- curtos;
- simples;
- grandes;
- contrastados;
- apropriados para crianças.

---

# 71. DEC-064 — NARRAÇÃO POR VOZ NÃO É REQUISITO DO MVP

**Categoria:** Áudio / Acessibilidade  
**Status:** DECIDIDA

## Decisão

O primeiro protótipo não dependerá de narração por voz.

## Futuro

Poderá ser avaliada por:

- acessibilidade;
- público em alfabetização;
- experiência narrativa.

---

# 72. DEC-065 — GAMEPLAY PRINCIPAL OFFLINE

**Categoria:** Arquitetura  
**Status:** DECIDIDA

## Decisão

A lógica principal do jogo não deverá depender continuamente de internet.

## Motivo

Permitir:

- PWA offline;
- maior disponibilidade;
- simplicidade arquitetural.

---

# 73. DEC-066 — SEM MULTIPLAYER NO ESCOPO INICIAL

**Categoria:** Escopo  
**Status:** DECIDIDA

## Decisão

Tico e Pipo representam cooperação dentro do gameplay, mas não significam multiplayer.

Inicialmente:

**UM JOGADOR CONTROLA A DUPLA.**

---

# 74. DEC-067 — IA DO COMPANHEIRO DEVE SER SIMPLES

**Categoria:** Arquitetura / Gameplay  
**Status:** DECIDIDA

## Decisão

Não criar IA complexa para o personagem inativo sem necessidade comprovada.

Inicialmente poderá:

- aguardar;
- executar idle;
- reposicionar quando necessário.

---

# 75. DEC-068 — COMPONENTIZAÇÃO GRADUAL

**Categoria:** Arquitetura  
**Status:** DECIDIDA

## Decisão

Não criar arquitetura genérica excessiva antecipadamente.

Fluxo:

```text
FAZER FUNCIONAR
↓
IDENTIFICAR REPETIÇÃO
↓
EXTRAIR COMPONENTE
```

---

# 76. DEC-069 — SIGNALS PARA DESACOPLAMENTO

**Categoria:** Arquitetura  
**Status:** DECIDIDA

## Decisão

Preferir signals para eventos como:

```text
nut_collected
health_changed
checkpoint_reached
character_changed
level_completed
```

quando isso reduzir dependências entre sistemas.

---

# 77. DEC-070 — AUTOLOADS LIMITADOS

**Categoria:** Arquitetura  
**Status:** DECIDIDA

## Decisão

Utilizar Autoload apenas para sistemas realmente globais.

Possíveis:

```text
GameManager
SaveManager
AudioManager
SceneManager
```

Evitar transformar tudo em singleton.

---

# 78. DEC-071 — GIT DESDE O INÍCIO

**Categoria:** Desenvolvimento  
**Status:** DECIDIDA

## Decisão

Utilizar Git desde a criação do projeto.

## Motivo

Permitir:

- histórico;
- reversão;
- branches;
- rastreabilidade.

---

# 79. DEC-072 — DOCUMENTAÇÃO FAZ PARTE DO PROJETO

**Categoria:** Processo  
**Status:** DECIDIDA

## Decisão

Os documentos deverão acompanhar a evolução do jogo.

Estrutura atual:

```text
01_visao-geral.md
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
```

---

# 80. DEC-073 — DOCUMENTAÇÃO NÃO É IMUTÁVEL

**Categoria:** Processo  
**Status:** DECIDIDA

## Decisão

Os documentos poderão evoluir.

Quando uma alteração modificar uma decisão importante:

atualizar:

`11_decisoes.md`

---

# 81. DEC-074 — GAMEPLAY E NARRATIVA DEVEM TRABALHAR JUNTOS

**Categoria:** Design  
**Status:** DECIDIDA

## Decisão

O gameplay ensina:

```text
TICO SOZINHO
não resolve tudo

PIPO SOZINHO
não resolve tudo

TICO + PIPO
cooperam
```

A narrativa utiliza o mesmo princípio:

```text
COMUNIDADES ISOLADAS
enfrentam dificuldades

COMUNIDADES COOPERANDO
encontram uma solução
```

---

# 82. DEC-075 — CADA FASE DEVE TER FUNÇÃO

**Categoria:** Level Design  
**Status:** DECIDIDA

## Decisão

Nenhuma fase deverá existir apenas para aumentar a quantidade de conteúdo.

Cada fase deverá possuir uma ou mais funções:

- ensinar;
- praticar;
- combinar;
- desafiar;
- revelar história;
- apresentar personagem;
- introduzir inimigo;
- explorar ambiente.

---

# 83. DEC-076 — CADA FASE DEVE ENTREGAR RECOMPENSA NARRATIVA

**Categoria:** Narrativa / Level Design  
**Status:** DECIDIDA

## Decisão

Além de completar gameplay, a fase deverá idealmente entregar:

- pista;
- descoberta;
- encontro;
- revelação;
- avanço narrativo.

---

# 84. DEC-077 — CHEFES NÃO DEVEM SER EXCESSIVAMENTE PUNITIVOS

**Categoria:** Gameplay  
**Status:** DECIDIDA

## Decisão

Chefes deverão testar habilidades aprendidas.

Não deverão depender principalmente de:

- reflexos extremos;
- memorização excessiva;
- grande quantidade de tentativas.

---

# 85. DEC-078 — CHEFES PERMANECEM SUJEITOS À VALIDAÇÃO DE ESCOPO

**Categoria:** Escopo  
**Status:** EM VALIDAÇÃO

## Contexto

Foram propostos:

- Guardião do Bosque;
- Guardião do Rio;
- Coruja da Montanha;
- Rei Castor;
- Mestre Corvo.

## Decisão

A estrutura suporta chefes.

Entretanto, quantidade e complexidade deverão ser validadas durante o desenvolvimento.

## Motivo

Evitar que chefes aumentem excessivamente o escopo antes de o gameplay principal estar consolidado.

---

# 86. DEC-079 — PRIMEIRO INIMIGO SERÁ A LESMA

**Categoria:** Gameplay  
**Status:** DECIDIDA

## Motivo

Possui comportamento simples e previsível.

Permite validar:

- patrulha;
- colisão;
- dano;
- pisão;
- derrota.

---

# 87. DEC-080 — PRIMEIRO PROTÓTIPO DEVE SER PEQUENO

**Categoria:** Produção  
**Status:** DECIDIDA

## Conteúdo

```text
Tico
Pipo
pequena fase
movimento
salto
colisão
uma lesma
blocos
nozes
obstáculo de Pipo
troca
final
```

## Objetivo

Validar o conceito antes de produzir grande quantidade de conteúdo.

---

# 88. DEC-081 — ARTE NÃO BLOQUEARÁ PROTOTIPAÇÃO

**Categoria:** Produção  
**Status:** DECIDIDA

## Decisão

Não esperar arte final para iniciar gameplay.

## Princípio

O protótipo poderá ser:

**FEIO**

desde que seja:

**ÚTIL PARA TESTAR.**

---

# 89. DEC-082 — MOBILE É PLATAFORMA DE TESTE DESDE CEDO

**Categoria:** Plataforma  
**Status:** DECIDIDA

## Decisão

Depois de Tico estar minimamente controlável:

exportar para Web e testar no celular.

Não esperar o jogo estar completo.

---

# 90. DEC-083 — PWA DEVE SER VALIDADO NO PROTÓTIPO

**Categoria:** Plataforma  
**Status:** DECIDIDA

## Decisão

Antes de grande produção de conteúdo:

validar:

```text
WEB
↓
TOUCH
↓
PWA
↓
INSTALAÇÃO
↓
OFFLINE
```

---

# 91. DEC-084 — BUILD NATIVO CONTINUA IMPORTANTE

**Categoria:** Plataforma  
**Status:** DECIDIDA

## Decisão

Mesmo com PWA como prioridade:

continuar permitindo builds:

**WINDOWS**

e:

**ANDROID**

quando aplicável.

---

# 92. DEC-085 — NÃO CRIAR CONTA PARA JOGAR

**Categoria:** UX / Arquitetura  
**Status:** DECIDIDA PARA MVP

## Decisão

O jogador deverá poder iniciar o jogo sem:

- cadastro;
- e-mail;
- senha;
- login.

## Motivo

Reduzir barreira para o público infantil e simplificar a primeira versão.

---

# 93. DEC-086 — DADOS PESSOAIS NÃO SÃO NECESSÁRIOS NO MVP

**Categoria:** Privacidade  
**Status:** DECIDIDA

## Decisão

O jogo não deverá coletar dados pessoais desnecessários.

Especialmente considerando o público infantil.

---

# 94. DEC-087 — PROGRESSO LOCAL ANTES DE CLOUD SAVE

**Categoria:** Arquitetura  
**Status:** DECIDIDA

## Decisão

Primeiro:

```text
SAVE LOCAL
```

Somente futuramente, se necessário:

```text
CONTA
+
BACKEND
+
CLOUD SAVE
```

---

# 95. DEC-088 — MECÂNICAS DEVEM SER COMPREENDIDAS VISUALMENTE

**Categoria:** Gameplay / Visual  
**Status:** DECIDIDA

## Decisão

Sempre que possível:

o jogador deverá entender uma regra observando o jogo.

Exemplos:

- espinhos → perigo;
- objeto pesado → Pipo;
- passagem estreita → Tico;
- nozes → caminho/recompensa.

---

# 96. DEC-089 — NÃO DEPENDER DE TUTORIAIS TEXTUAIS LONGOS

**Categoria:** UX  
**Status:** DECIDIDA

## Decisão

Priorizar:

```text
MOSTRAR
↓
PERMITIR TESTAR
↓
REPETIR
↓
COMBINAR
```

Texto será utilizado quando realmente necessário.

---

# 97. DEC-090 — O JOGO DEVE INCENTIVAR CURIOSIDADE

**Categoria:** Gameplay  
**Status:** DECIDIDA

## Decisão

O design deverá recompensar:

- olhar ao redor;
- explorar;
- tentar alcançar lugares;
- seguir pistas;
- procurar segredos.

Isso combina diretamente com a personalidade de Tico.

---

# 98. DEC-091 — FASE CONCLUÍDA NÃO SIGNIFICA APENAS CHEGAR AO FIM

**Categoria:** Design  
**Status:** DECIDIDA

## Decisão

Uma fase deverá idealmente resultar em:

```text
PROGRESSO DE GAMEPLAY
+
PROGRESSO NARRATIVO
```

---

# 99. DEC-092 — FINAL DEVE ESPELHAR O GAMEPLAY

**Categoria:** Narrativa  
**Status:** DECIDIDA

## Decisão

A solução narrativa será baseada na mesma ideia praticada durante o jogo:

**HABILIDADES DIFERENTES FUNCIONAM MELHOR QUANDO COOPERAM.**

---

# 100. DEC-093 — INFRAESTRUTURA DO ANTAGONISTA MUDA DE FUNÇÃO NO FINAL

**Categoria:** Narrativa / Visual  
**Status:** DECIDIDA

## Decisão

Os mecanismos usados para transportar comida roubada poderão aparecer no encerramento sendo utilizados para:

**COMPARTILHAR COMIDA.**

## Objetivo

Criar inversão visual:

```text
ANTES
transporte secreto

DEPOIS
cooperação aberta
```

---

# 101. DEC-094 — HUMOR DE PIPO NÃO DEVE HUMILHÁ-LO

**Categoria:** Personagem  
**Status:** DECIDIDA

## Decisão

Pipo poderá ser:

- atrapalhado;
- engraçado;
- espontâneo;
- apaixonado por comida.

Mas o humor não deverá ridicularizar sua aparência ou diminuir sua importância.

---

# 102. DEC-095 — MESTRE CORVO NÃO SERÁ VISUALMENTE ASSUSTADOR

**Categoria:** Direção Visual  
**Status:** DECIDIDA

## Decisão

Ele deverá parecer:

- importante;
- inteligente;
- sério;
- organizado;
- distinto.

Não deverá parecer personagem de terror.

---

# 103. DEC-096 — DESENVOLVIMENTO GUIADO POR MARCOS

**Categoria:** Processo  
**Status:** DECIDIDA

## Marcos

```text
MARCO 1
Tico Playground

MARCO 2
Tico PWA

MARCO 3
Tico Mini Game

MARCO 4
Tico + Pipo

MARCO 5
Vertical Slice

MARCO 6
Mundo 1 Completo

MARCO 7
Jogo Completo

MARCO 8
Versão 1.0
```

---

# 104. DEC-097 — NÃO AVANÇAR APENAS POR TAREFAS CONCLUÍDAS

**Categoria:** Processo  
**Status:** DECIDIDA

## Decisão

Cada marco deverá validar uma hipótese.

Exemplo:

Tico Playground:

não basta implementar salto.

Precisamos responder:

**TICO É DIVERTIDO DE CONTROLAR?**

---

# 105. DEC-098 — DOCUMENTAR RESULTADOS DOS TESTES

**Categoria:** Testes  
**Status:** DECIDIDA

## Decisão

Problemas encontrados deverão gerar registros.

Mudanças importantes originadas por testes deverão também atualizar:

`11_decisoes.md`

---

# 106. DEC-099 — NÃO CORRIGIR SINTOMA SEM INVESTIGAR CAUSA

**Categoria:** Testes / Design  
**Status:** DECIDIDA

## Exemplo

Se crianças falharem repetidamente em um salto:

não reduzir automaticamente a distância.

Investigar:

- câmera;
- controle;
- leitura visual;
- mecânica;
- entendimento;
- timing.

---

# 107. DEC-100 — DIVERSÃO TEM PRIORIDADE SOBRE QUANTIDADE

**Categoria:** Projeto  
**Status:** DECIDIDA

## Decisão

É preferível:

**UMA FASE MUITO BOA**

a:

**TRÊS FASES SEM POLIMENTO.**

É preferível:

**POUCOS INIMIGOS BEM UTILIZADOS**

a:

**MUITOS INIMIGOS SEM FUNÇÃO.**

---

# 108. DECISÕES AINDA EM VALIDAÇÃO

Atualmente merecem atenção especial:

```text
DEC-013
Planar usando botão de pulo

DEC-078
Quantidade e complexidade dos chefes
```

Além delas, decisões futuras poderão entrar inicialmente como:

**PROPOSTA**

ou:

**EM VALIDAÇÃO.**

---

# 109. QUESTÕES AINDA NÃO DEFINIDAS

Ainda deverão ser decididos durante desenvolvimento:

- resolução interna definitiva;
- velocidade definitiva de Tico;
- altura definitiva do salto;
- duração definitiva do planar;
- quantidade de corações;
- funcionamento definitivo de vidas;
- layout final dos controles touch;
- quantidade de segredos por fase;
- valores de coletáveis;
- sistema final de power-ups;
- quantidade final de chefes;
- duração final das fases;
- estilo final de diálogos;
- presença de narração por voz;
- suporte definitivo a gamepad;
- publicação Android nativa na versão 1.0;
- suporte futuro a iOS;
- cloud save;
- conquistas;
- fases secretas.

Esses itens não deverão ser definidos arbitrariamente apenas para preencher documentação.

Deverão ser decididos quando houver:

**CONTEXTO + PROTÓTIPO + TESTE.**

---

# 110. COMO TOMAR NOVAS DECISÕES

Quando surgir uma dúvida importante:

```text
PROBLEMA
   ↓
OPÇÕES
   ↓
PRÓS E CONTRAS
   ↓
PROTÓTIPO, SE NECESSÁRIO
   ↓
TESTE
   ↓
DECISÃO
   ↓
REGISTRO
```

---

# 111. DECISÕES REVERSÍVEIS

Algumas decisões são fáceis de mudar.

Exemplos:

- valor de velocidade;
- quantidade de nozes;
- volume;
- posição de botão.

Essas decisões não precisam receber o mesmo peso arquitetural.

---

# 112. DECISÕES DE ALTO IMPACTO

Registrar cuidadosamente decisões relacionadas a:

- engine;
- plataforma;
- arquitetura;
- save;
- input;
- estrutura dos personagens;
- narrativa principal;
- número de mundos;
- direção visual;
- público;
- modelo de distribuição.

Essas decisões afetam grande parte do projeto.

---

# 113. EVITAR DECISÕES PREMATURAS

Se uma decisão não precisa ser tomada agora:

**NÃO DECIDIR APENAS PARA FECHAR O ASSUNTO.**

Exemplo:

não precisamos definir agora:

**quantos segundos exatamente dura o planar.**

Precisamos primeiro:

**JOGAR.**

---

# 114. DOCUMENTOS RELACIONADOS

As decisões deverão permanecer coerentes com:

```text
01_visao-geral.md

02_requisitos.md

03_gameplay.md

04_personagens.md

05_fases-e-mundos.md

06_direcao-visual.md

07_arquitetura-tecnica.md

08_roadmap.md

09_historia-e-narrativa.md

10_testes.md
```

---

# 115. CONFLITO ENTRE DOCUMENTOS

Se uma decisão deste documento alterar outro arquivo:

o documento afetado deverá ser atualizado.

Exemplo:

```text
DECISÃO
Pipo passa a possuir nova habilidade
        ↓
02_requisitos.md
03_gameplay.md
04_personagens.md
05_fases-e-mundos.md
10_testes.md
```

Não permitir que diferentes documentos descrevam versões incompatíveis do projeto.

---

# 116. HIERARQUIA CONCEITUAL

O projeto poderá ser compreendido assim:

```text
01 VISÃO
“Que jogo estamos criando?”

        ↓

02 REQUISITOS
“O que ele precisa ter?”

        ↓

03 GAMEPLAY
“Como se joga?”

        ↓

04 PERSONAGENS
“Quem participa?”

        ↓

05 FASES E MUNDOS
“Onde jogamos?”

        ↓

06 DIREÇÃO VISUAL
“Como tudo deve parecer?”

        ↓

07 ARQUITETURA
“Como será construído?”

        ↓

08 ROADMAP
“Em que ordem construiremos?”

        ↓

09 HISTÓRIA
“O que acontece e quando descobrimos?”

        ↓

10 TESTES
“Como saberemos se funciona?”

        ↓

11 DECISÕES
“Por que escolhemos esse caminho?”
```

---

# 117. PRINCÍPIO FINAL

Este arquivo não deverá ser tratado como uma lista de regras que impede mudanças.

Ele será:

**A MEMÓRIA DO PROJETO.**

Durante o desenvolvimento de **Tico e a Floresta das Nozes**, algumas ideias funcionarão.

Outras não.

Algumas decisões permanecerão.

Outras serão substituídas.

Isso é esperado.

O importante é conseguir responder:

**O QUE DECIDIMOS?**

**POR QUE DECIDIMOS?**

**O QUE APRENDEMOS?**

**POR QUE MUDAMOS?**

A sequência deverá ser:

```text
IDEIA
 ↓
PROTÓTIPO
 ↓
TESTE
 ↓
APRENDIZADO
 ↓
DECISÃO
 ↓
REGISTRO
```

E, quando necessário:

```text
NOVA EVIDÊNCIA
 ↓
REAVALIAÇÃO
 ↓
NOVA DECISÃO
 ↓
ATUALIZAÇÃO
```

O projeto deverá permanecer organizado sem perder a capacidade de evoluir.

---

# ATUALIZAÇÃO — PREPARAÇÃO DO PROJETO (2026-09-29)

## DEC-101 — DOCUMENTAÇÃO E NOMES CANÔNICOS

**Categoria:** Processo  
**Status:** DECIDIDA

Manter os documentos em `arquivos_projeto/`, em Markdown, numerados de
`01_visao-geral.md` a `11_decisoes.md`, com narrativa em 09 e testes em 10.
O acompanhamento de execução fica em `12_status-do-projeto.md`.
Manter as duas pranchas originais em `img/`; assets de runtime ficam em `assets/`.

**Motivo:** corrigir referências desatualizadas sem mover desnecessariamente
os materiais existentes. As pastas de documentação e referências usam
`.gdignore` para não serem importadas como assets do jogo.

## DEC-102 — ETAPAS E MARCOS COMPARTILHAM UM VOCABULÁRIO

**Categoria:** Processo / Escopo  
**Status:** DECIDIDA

Os oito marcos de `08_roadmap.md` são a referência única para arquitetura,
testes e acompanhamento: Tico Playground, Tico PWA, Tico Mini Game,
Tico + Pipo, Vertical Slice, Mundo 1 Completo, Jogo Completo e Versão 1.0.
Etapas representam trabalho; marcos representam resultados validados.

A etapa 0 entrega projeto, cena vazia e repositório. O primeiro protótipo
completo é a integração da etapa 6; o MVP inclui os requisitos Web/PWA,
touch e save. Web, touch e instalação são subpassos do marco 2.
Android nativo continua adicional, sujeito à confirmação para o lançamento.

**Motivo:** eliminar duas numerações incompatíveis de marcos e diferenciar
a primeira execução técnica do protótipo com a dupla.

## DEC-103 — BASE TÉCNICA DA ETAPA 0

**Categoria:** Arquitetura  
**Status:** DECIDIDA

Adotar Godot **4.7.2 stable**, edição padrão com GDScript, registrada em
`.godot-version`. Renderizador **Compatibility** para a distribuição Web.
Cena inicial: `scenes/main.tscn`, com raiz `Node2D`.

Configuração provisória: 1280 × 720, landscape, stretch `canvas_items`,
aspecto `expand`. Input Map: `move_left`, `move_right`, `jump`, `action`,
`switch_character` e `pause`. A resolução artística e os controles finais
continuam sujeitos a teste; touch será implementado na etapa correspondente.

**Motivo:** obter uma base executável mínima com as decisões existentes.
O editor integrado atende ao início do desenvolvimento. Ferramentas de arte
adicionais e SDK/JDK Android serão preparados quando necessários; não são
pré-requisitos para validar a cena vazia.

**Fontes:** [Godot para Windows](https://godotengine.org/download/windows/)
e [exportação Web](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html).

## DEC-104 — PRANCHAS COMO REFERÊNCIA VISUAL ATUAL

**Categoria:** Direção visual  
**Status:** DECIDIDA

Usar `img/esquilo.png` e `img/porquinho.png` como referências atuais de
aparência, proporções, cores e expressões, com acabamento cartoon ilustrado.
Pipo aparece com pele verde-clara, focinho rosado, camisa verde-escura com
acabamentos claros e boné claro. Preservar esses elementos nas primeiras
derivações e registrar eventuais mudanças. A camisa verde continua obrigatória.

As pranchas não são sequências de animação prontas para uso. Produzir quadros
com transparência, escala e alinhamento consistentes, testando a legibilidade
e o contraste de Pipo com o cenário verde.

**Motivo:** registrar a evidência visual disponível sem confundir arte de
referência com assets finalizados nem tornar todos os detalhes imutáveis.

---

**FIM DO DOCUMENTO**
