# TICO E A FLORESTA DAS NOZES

## ROADMAP DE DESENVOLVIMENTO

**Versão:** 1.0  
**Documento:** 08_roadmap.md

---

# 1. OBJETIVO

Este documento define o roadmap de desenvolvimento de **Tico e a Floresta das Nozes**.

Seu objetivo é transformar os documentos de visão, requisitos, gameplay, personagens, fases, direção visual e arquitetura técnica em uma sequência prática de desenvolvimento.

O roadmap deverá responder:

**O QUE FAZER PRIMEIRO?**

**O QUE PRECISA ESTAR PRONTO ANTES DE AVANÇAR?**

**QUANDO TESTAR?**

**QUANDO PRODUZIR ARTE FINAL?**

**QUANDO COMEÇAR A CRIAR OS MUNDOS?**

A principal regra será:

**VALIDAR ANTES DE EXPANDIR.**

---

# 2. VISÃO GERAL DO ROADMAP

## Vocabulário e acompanhamento

- **Etapa:** conjunto de atividades de desenvolvimento, começando na etapa 0.
- **Marco:** resultado validado; os oito nomes da seção 119 são a referência
  para arquitetura, decisões e testes.
- **Primeira cena executável:** cena vazia da etapa 0 para validar o ambiente.
- **Primeiro protótipo completo:** fase pequena com Tico e Pipo, integrada
  na etapa 6. Nos documentos de visão, gameplay e personagens, a expressão
  "primeiro protótipo" refere-se a esse objetivo integrado.
- **MVP:** conjunto mínimo descrito na seção 123, incluindo Web/PWA e save.
- **Vertical slice:** pequena seção com qualidade representativa do jogo final,
  produzida após validar o protótipo.

O registro de execução fica em `arquivos_projeto/12_status-do-projeto.md`.

O desenvolvimento será dividido nas seguintes etapas:

```text
ETAPA 0
Preparação
   ↓
ETAPA 1
Fundação técnica
   ↓
ETAPA 2
Tico jogável
   ↓
ETAPA 3
Web + Touch + PWA
   ↓
ETAPA 4
Gameplay básico
   ↓
ETAPA 5
Pipo
   ↓
ETAPA 6
Protótipo completo
   ↓
ETAPA 7
Vertical Slice
   ↓
ETAPA 8
Mundo 1
   ↓
ETAPA 9
Mundos 2, 3 e 4
   ↓
ETAPA 10
Mundo 5 + Final
   ↓
ETAPA 11
Polimento
   ↓
ETAPA 12
Publicação
```

---

# 3. FILOSOFIA DO ROADMAP

Não desenvolver:

**15 FASES**

antes de saber se:

**TICO É DIVERTIDO DE CONTROLAR.**

Não produzir dezenas de personagens antes de validar:

**ESCALA E DIREÇÃO VISUAL.**

Não construir todos os mundos antes de validar:

**UMA FASE COMPLETA.**

Não implementar sistemas online antes de existir:

**UM JOGO FUNCIONANDO.**

---

# 4. CICLO DE DESENVOLVIMENTO

Cada etapa deverá seguir aproximadamente:

```text
PLANEJAR
   ↓
IMPLEMENTAR
   ↓
JOGAR
   ↓
TESTAR
   ↓
CORRIGIR
   ↓
VALIDAR
   ↓
AVANÇAR
```

Uma funcionalidade não deverá ser considerada concluída apenas porque o código funciona.

Ela também deverá funcionar adequadamente durante o jogo.

---

# 5. ETAPA 0 — PREPARAÇÃO

## OBJETIVO

Preparar ambiente, documentação e estrutura inicial.

---

# 6. DOCUMENTAÇÃO INICIAL

Antes da programação principal deverão existir:

```text
01_visao-geral.md
02_requisitos.md
03_gameplay.md
04_personagens.md
05_fases-e-mundos.md
06_direcao-visual.md
07_arquitetura-tecnica.md
08_roadmap.md
```

Também fazem parte da documentação inicial:

```text
09_historia-e-narrativa.md
10_testes.md
11_decisoes.md
```

---

# 7. AMBIENTE DE DESENVOLVIMENTO

Instalar e configurar:

- Godot Engine 4;
- Git;
- editor de código: editor integrado da Godot; VS Code opcional;
- navegador Chromium para os testes Web;
- testes Android Web/PWA em aparelho real a partir da etapa 3;
- SDK/JDK e ferramentas de exportação Android nativa quando essa plataforma entrar em implementação;
- ferramentas gráficas adicionais quando a produção de arte exigir.

A etapa 0 prepara o projeto local. Exportações, validação em aparelho Android,
instalação PWA e offline pertencem às etapas seguintes e não são critérios desta etapa.

---

# 8. CRIAR REPOSITÓRIO

Criar:

```text
jogo-esquilo/
```

Inicializar:

```text
Git
```

Branch principal:

```text
main
```

Criar `.gitignore` adequado.

---

# 9. CRIAR PROJETO GODOT

Criar projeto vazio.

Configurar inicialmente:

```text
2D

Landscape

16:9

Input Map

estrutura de diretórios
```

Ainda não será necessário inserir arte definitiva.

---

# 10. RESULTADO DA ETAPA 0

Deveremos possuir:

```text
Projeto abre
   ↓
Godot funciona
   ↓
Git funciona
   ↓
pastas existem
   ↓
documentação existe
```

---

# 11. CRITÉRIO DE CONCLUSÃO — ETAPA 0

A etapa termina quando for possível:

1. abrir o projeto;
2. executar uma cena vazia;
3. salvar;
4. versionar no Git;
5. gerar primeiro commit.

---

# 12. ETAPA 1 — FUNDAÇÃO TÉCNICA

## OBJETIVO

Construir somente a infraestrutura mínima necessária para iniciar o gameplay.

---

# 13. CONFIGURAÇÕES INICIAIS

Configurar:

- resolução;
- proporção;
- orientação;
- física;
- Input Map;
- camadas de colisão;
- grupos iniciais.

---

# 14. INPUT MAP

Criar ações:

```text
move_left
move_right
jump
action
switch_character
pause
```

Neste momento, implementar primeiro teclado.

---

# 15. CENA DE TESTE

Criar:

```text
test_level.tscn
```

Ela deverá possuir apenas:

- chão;
- algumas plataformas;
- paredes;
- ponto inicial.

Utilizar arte provisória.

---

# 16. PRIMEIRO BUILD

Gerar uma versão Windows extremamente simples.

Objetivo:

validar cedo o processo de exportação.

---

# 17. CRITÉRIO DE CONCLUSÃO — ETAPA 1

Concluir quando:

- projeto executa;
- fase de teste abre;
- colisões básicas funcionam;
- input está configurado;
- build Windows é gerado.

---

# 18. ETAPA 2 — TICO JOGÁVEL

**Execução em 2026-09-29:** implementação e verificações técnicas concluídas.
O usuário jogou o build Windows, considerou o controle bem jogável e autorizou
a etapa 3. O playtest da seção 27 e o marco 1 estão aprovados para o protótipo.
Resultados: `tests/etapa_2.md` e `arquivos_projeto/12_status-do-projeto.md`.

## OBJETIVO

Criar o primeiro elemento realmente importante do jogo:

**TICO.**

---

# 19. IMPLEMENTAR TICO

Criar:

```text
tico.tscn
tico.gd
```

Inicialmente utilizar sprite provisório.

---

# 20. MOVIMENTO HORIZONTAL

Implementar:

- esquerda;
- direita;
- aceleração;
- desaceleração;
- direção visual.

Objetivo:

Tico deverá responder rapidamente ao jogador.

---

# 21. SALTO

Implementar:

- salto;
- gravidade;
- queda;
- aterrissagem.

Testar repetidamente.

O salto será uma das mecânicas mais importantes de todo o projeto.

---

# 22. AJUSTES DE QUALIDADE

Avaliar:

- velocidade;
- altura;
- distância;
- aceleração;
- desaceleração;
- controle aéreo.

Poderão ser avaliados:

- coyote time;
- jump buffer;
- altura variável.

---

# 23. CÂMERA

Implementar câmera.

Validar:

- acompanhamento;
- suavização;
- visão à frente;
- limites.

---

# 24. PLANAR

Depois que o salto estiver satisfatório:

implementar planar utilizando a cauda.

Fluxo:

```text
PULO
 ↓
QUEDA
 ↓
SEGURAR PULO
 ↓
PLANAR
```

---

# 25. ANIMAÇÕES PROVISÓRIAS

Criar pelo menos:

```text
idle
run
jump
fall
glide
```

Mesmo que utilizando arte temporária.

---

# 26. MARCO 1

Ao final desta etapa deverá existir:

**TICO PLAYGROUND**

Uma pequena área onde Tico possa:

- andar;
- correr;
- pular;
- cair;
- planar.

---

# 27. TESTE PRINCIPAL

Pergunta:

**CONTROLAR TICO É DIVERTIDO?**

Se a resposta ainda não for satisfatória:

**NÃO AVANÇAR.**

Ajustar movimento antes de adicionar complexidade.

---

# 28. CRITÉRIO DE CONCLUSÃO — ETAPA 2

Tico deverá:

- responder bem;
- pular de forma previsível;
- planar;
- possuir câmera funcional;
- não atravessar cenário;
- possuir animações provisórias suficientes.

---

# 29. ETAPA 3 — WEB, TOUCH E PWA

**Execução em 2026-09-29:** exportação Web/PWA e controles touch implementados.
Destino: `https://projetosdoleo.com/tico/`. O usuário confirmou publicação,
acesso, instalação da PWA, jogabilidade muito boa e teste de reabertura pelo
ícone sem conexão no celular. Etapa 3 e marco 2 concluídos.
Resultados e roteiro: `tests/etapa_3.md` e `web/deployment.md`.

## OBJETIVO

Validar cedo a principal plataforma de distribuição.

---

# 30. EXPORTAÇÃO WEB

Exportar Tico Playground para Web.

Validar:

```text
abrir navegador
↓
carregar jogo
↓
controlar Tico
```

---

# 31. TESTE WEB DESKTOP

Verificar:

- carregamento;
- teclado;
- resolução;
- fullscreen;
- câmera;
- desempenho.

---

# 32. CONTROLES TOUCH

Adicionar:

```text
◀
▶
PULO
AÇÃO
```

Inicialmente o botão de troca poderá existir, mesmo antes de Pipo ser implementado.

---

# 33. TESTE EM CELULAR

Abrir pelo navegador do celular.

Testar:

- landscape;
- tamanho dos botões;
- conforto;
- visibilidade;
- desempenho;
- resposta dos controles.

---

# 34. PLANAR NO TOUCH

Testar:

```text
toque em PULO
        ↓
      salto

manter PULO no ar
        ↓
      planar
```

Validar se a interação é intuitiva.

---

# 35. PWA

Configurar versão instalável.

Adicionar:

- nome;
- ícones;
- orientação;
- modo de exibição;
- recursos necessários.

---

# 36. TESTE DE INSTALAÇÃO

Fluxo esperado:

```text
abrir endereço
↓
instalar PWA
↓
ícone aparece
↓
abrir pelo ícone
↓
Tico Playground inicia
```

---

# 37. TESTE OFFLINE

Depois de instalar/carregar:

1. fechar;
2. remover conexão;
3. abrir novamente;
4. verificar funcionamento.

---

# 38. MARCO 2

**TICO PWA**

Primeira versão instalável do projeto.

Mesmo sendo apenas uma área de testes, já teremos validado:

- Godot;
- Web;
- touchscreen;
- PWA;
- celular.

---

# 39. CRITÉRIO DE CONCLUSÃO — ETAPA 3

Deverá ser possível:

```text
abrir no celular
↓
instalar
↓
jogar
↓
fechar
↓
abrir novamente
```

---

# 40. ETAPA 4 — GAMEPLAY BÁSICO

**Execução:** implementação e testes técnicos concluídos. A Trilha das Nozes
possui vida, lesmas, pisão, nozes, blocos, checkpoint e resultado. Uma fase
completa foi percorrida por testes de engine e navegador. O usuário publicou
a etapa 4 e confirmou que funcionou muito bem. Marco 3 aprovado.
Resultados: `tests/etapa_4.md`.

## OBJETIVO

Transformar Tico Playground em um pequeno jogo.

---

# 41. SISTEMA DE VIDA

Implementar:

- corações;
- dano;
- invulnerabilidade temporária;
- recuperação;
- derrota.

---

# 42. PRIMEIRO INIMIGO

Implementar:

**LESMA**

Ela deverá:

- patrulhar;
- virar;
- causar dano;
- receber pisão;
- possuir derrota amigável.

---

# 43. TESTE DE PISÃO

Fluxo:

```text
Tico cai
   ↓
atinge lesma por cima
   ↓
lesma derrotada
   ↓
Tico recebe pequeno impulso
```

---

# 44. NOZ

Implementar:

```text
nut.tscn
```

Ao coletar:

- desaparecer;
- tocar som;
- gerar feedback visual;
- incrementar contador.

---

# 45. HUD

Adicionar:

```text
♥ ♥ ♥

🌰 × 00
```

---

# 46. BLOCOS

Implementar inicialmente:

- bloco comum;
- bloco quebrável;
- bloco de noz.

---

# 47. CHECKPOINT

Implementar checkpoint.

Testar:

```text
ativar
↓
receber dano
↓
perder vida
↓
respawn
↓
retornar ao checkpoint
```

---

# 48. FINAL DA FASE

Criar:

```text
level_exit.tscn
```

Ao alcançar:

- impedir controles;
- executar pequena comemoração;
- mostrar resultado;
- concluir fase.

---

# 49. PRIMEIRO LOOP DE GAMEPLAY

Ao final:

```text
EXPLORAR
   ↓
PULAR
   ↓
EVITAR/DERROTAR
   ↓
COLETAR
   ↓
CHECKPOINT
   ↓
AVANÇAR
   ↓
FINAL
```

---

# 50. MARCO 3

**TICO MINI GAME**

Agora já existe um jogo simples, e não apenas um teste de movimento.

---

# 51. CRITÉRIO DE CONCLUSÃO — ETAPA 4

Deverá existir uma pequena fase jogável do início ao fim.

---

# 52. ETAPA 5 — PIPO

**Execução:** Pipo, troca, empurrar, investida, faro e puzzle cooperativo
implementados na Trilha da Amizade. Testes em `tests/etapa_5.md`.
O usuário aprovou os controles, o faro e a conclusão do percurso no playtest.
Etapa 5 e marco 4 — Tico + Pipo concluídos.

## OBJETIVO

Implementar a segunda metade da principal mecânica do jogo.

---

# 53. IMPLEMENTAR PIPO

Criar:

```text
pipo.tscn
pipo.gd
```

Utilizar inicialmente arte provisória.

Mesmo na arte provisória:

**PIPO DEVERÁ USAR CAMISA VERDE.**

---

# 54. MOVIMENTO DE PIPO

Implementar:

- esquerda;
- direita;
- salto;
- queda.

Seu movimento deverá parecer diferente de Tico.

Pipo:

**MAIS PESADO**

mas não:

**DESAGRADÁVEL DE CONTROLAR**

---

# 55. EMPURRAR

Criar objeto empurrável.

Pipo deverá conseguir movê-lo.

Tico não deverá possuir força suficiente.

---

# 56. BLOCO PESADO

Criar:

```text
heavy_block.tscn
```

Regra:

```text
TICO
não quebra

PIPO
quebra
```

---

# 57. INVESTIDA

Implementar:

```text
preparar
↓
avançar
↓
impactar
↓
recuperar
```

A investida deverá possuir feedback visual e sonoro.

---

# 58. FARO

Criar primeira versão do faro.

Exemplo:

```text
Pipo fareja
↓
partículas aparecem
↓
direção é sugerida
↓
segredo é encontrado
```

---

# 59. TROCA DE PERSONAGEM

Implementar:

```text
TICO
 ↓
BOTÃO TROCAR
 ↓
PIPO
```

E vice-versa.

---

# 60. CÂMERA E HUD

Ao trocar:

- câmera muda alvo;
- personagem ativo muda;
- HUD informa personagem.

---

# 61. TESTE TOUCH

Validar cuidadosamente troca e ações de Pipo no celular.

Evitar adicionar muitos botões.

---

# 62. PRIMEIRO PUZZLE COOPERATIVO

Criar situação:

```text
PEDRA PESADA
     │
     ▼
PIPO EMPURRA
     │
     ▼
CAMINHO ABERTO
     │
     ▼
PASSAGEM ESTREITA
     │
     ▼
TICO PASSA
```

---

# 63. MARCO 4

**TICO + PIPO**

A identidade central do jogo passa a existir.

---

# 64. TESTE PRINCIPAL

Pergunta:

**A diferença entre Tico e Pipo é evidente sem precisar de longa explicação?**

Tico:

**AGILIDADE**

Pipo:

**FORÇA**

---

# 65. CRITÉRIO DE CONCLUSÃO — ETAPA 5

Jogador deverá compreender:

- quando usar Tico;
- quando usar Pipo;
- como trocar;
- diferença entre os dois.

---

# 66. ETAPA 6 — PROTÓTIPO COMPLETO

**Execução em 29/09/2026:** protótipo integrado em `prototype_trail.tscn`,
com save local, retomada e desafio final. A implementação está disponível para
publicação; o aceite depende do teste no aparelho e da observação de jogadores
descrita em [playtest da etapa 6](../tests/playtest_etapa_6.md).
Resultados técnicos em [testes da etapa 6](../tests/etapa_6.md).

## OBJETIVO

Construir uma pequena fase que represente os principais conceitos do jogo.

---

# 67. CONTEÚDO DO PROTÓTIPO

A fase deverá possuir:

- Tico;
- Pipo;
- nozes;
- lesma;
- blocos;
- bloco pesado;
- plataforma;
- segredo;
- checkpoint;
- troca;
- cooperação;
- final.

---

# 68. ESTRUTURA DO PROTÓTIPO

```text
INÍCIO
 ↓
TICO
 ↓
MOVIMENTO
 ↓
NOZES
 ↓
INIMIGO
 ↓
BLOCOS
 ↓
PIPO
 ↓
OBSTÁCULO PESADO
 ↓
TROCA
 ↓
COOPERAÇÃO
 ↓
CHECKPOINT
 ↓
DESAFIO FINAL
 ↓
FIM
```

---

# 69. SAVE

Adicionar persistência necessária.

Validar:

```text
jogar
↓
salvar
↓
fechar
↓
abrir
↓
continuar
```

Especialmente no PWA.

---

# 70. TESTE COM JOGADORES

Este será o primeiro momento adequado para testes mais estruturados.

Observar:

- controles;
- entendimento;
- dificuldade;
- diversão;
- frustração;
- Tico;
- Pipo;
- cooperação.

---

# 71. NÃO EXPLICAR DEMAIS

Durante testes:

não ensinar imediatamente tudo ao jogador.

Observar se o jogo consegue comunicar suas regras.

---

# 72. CRITÉRIO DE CONCLUSÃO — ETAPA 6

O protótipo deverá responder positivamente:

**Tico é divertido?**

**Pipo acrescenta algo?**

**A troca funciona?**

**A cooperação funciona?**

**A criança entende?**

**O PWA funciona?**

---

# 73. ETAPA 7 — VERTICAL SLICE

**Execução em 29/09/2026:** `vertical_slice.tscn` implementa o Bosque das Folhas
com arte ilustrada, animações, áudio original, UI e opções persistentes.
O usuário solicitou o avanço; o aceite do marco 5 exige validar esta versão no
aparelho e com jogadores. [Resultados e roteiro](../tests/etapa_7.md).

## OBJETIVO

Produzir uma pequena parte do jogo próxima da qualidade final.

---

# 74. DIFERENÇA ENTRE PROTÓTIPO E VERTICAL SLICE

Protótipo:

**ISSO É DIVERTIDO?**

Vertical Slice:

**É ASSIM QUE O JOGO FINAL DEVERÁ PARECER E FUNCIONAR?**

---

# 75. ARTE

Substituir assets principais provisórios.

Produzir:

- Tico;
- Pipo;
- lesma;
- nozes;
- blocos;
- vegetação;
- HUD;
- efeitos.

---

# 76. ANIMAÇÕES

Tico:

```text
idle
run
jump
fall
glide
hurt
celebrate
```

Pipo:

```text
idle
run
jump
fall
push
charge
sniff
hurt
celebrate
```

---

# 77. ÁUDIO

Adicionar:

- música;
- passos quando apropriado;
- salto;
- coleta;
- impacto;
- dano;
- checkpoint;
- segredo;
- interface.

---

# 78. CENÁRIO

Criar trecho representativo do:

**BOSQUE DAS FOLHAS**

Com qualidade visual próxima da pretendida para o jogo.

---

# 79. UI

Produzir versão visual adequada de:

- corações;
- nozes;
- personagem;
- pausa;
- controles touch;
- tela de conclusão.

---

# 80. PERFORMANCE

Testar vertical slice principalmente em:

- Windows;
- Web desktop;
- Android/PWA.

Se o vertical slice não possuir bom desempenho no celular, corrigir antes de produzir os mundos completos.

---

# 81. MARCO 5

**VERTICAL SLICE**

Esse será o primeiro build que deverá transmitir claramente:

**“ESTE É TICO E A FLORESTA DAS NOZES.”**

---

# 82. CRITÉRIO DE CONCLUSÃO — ETAPA 7

Validar:

- gameplay;
- visual;
- áudio;
- UI;
- touchscreen;
- desempenho;
- PWA;
- identidade.

---

# 83. ETAPA 8 — MUNDO 1

## BOSQUE DAS FOLHAS

O Mundo 1 será a primeira produção real.

---

# 84. FASE 1-1 — PRIMEIROS PASSOS

Implementar:

- movimento;
- salto;
- nozes;
- plataformas;
- lesma.

Objetivo:

ensinar sem excesso de texto.

---

# 85. FASE 1-2 — BLOCOS E SEGREDOS

Introduzir:

- blocos;
- bloco de noz;
- exploração;
- segredo;
- novo desafio.

---

# 86. FASE 1-3 — UM NOVO AMIGO

Introduzir:

- encontro com Pipo;
- resgate;
- força;
- obstáculos pesados;
- troca;
- cooperação.

---

# 87. CHEFE DO MUNDO 1

Implementar, se mantido no escopo:

**GUARDIÃO DO BOSQUE**

O chefe deverá utilizar mecânicas já ensinadas.

---

# 88. TESTE COMPLETO DO MUNDO 1

Antes do Mundo 2:

testar todo o Mundo 1.

Avaliar:

- progressão;
- dificuldade;
- história;
- mecânicas;
- checkpoints;
- controles;
- arte;
- desempenho.

---

# 89. MARCO 6

**MUNDO 1 COMPLETO**

Esse será um marco crítico.

Se o Mundo 1 funcionar bem, ele servirá como padrão de produção para os demais.

---

# 90. ETAPA 9 — MUNDOS 2, 3 E 4

A partir daqui a arquitetura principal deverá estar estabilizada.

---

# 91. MUNDO 2 — RIO DAS PEDRAS

Foco:

**MOVIMENTO DO AMBIENTE**

Implementar:

- água;
- troncos;
- plataformas móveis;
- pontes;
- cachoeiras.

Fases:

```text
2-1
2-2
2-3
```

Chefe:

**GUARDIÃO DO RIO**

---

# 92. MUNDO 3 — MONTANHA DAS CORUJAS

Foco:

**PLANAR + VERTICALIDADE**

Implementar:

- altura;
- vento;
- cavernas;
- plataformas suspensas;
- inimigos aéreos.

Fases:

```text
3-1
3-2
3-3
```

Chefe:

**CORUJA DA MONTANHA**

---

# 93. MUNDO 4 — VILA DOS CASTORES

Foco:

**PIPO + MECANISMOS**

Implementar:

- engrenagens;
- elevadores;
- comportas;
- peso;
- objetos pesados;
- mecanismos.

Fases:

```text
4-1
4-2
4-3
```

Chefe:

**REI CASTOR**

---

# 94. REGRA DE PRODUÇÃO DOS MUNDOS

Para cada mundo:

```text
CONCEITO
 ↓
ASSETS PRINCIPAIS
 ↓
MECÂNICA
 ↓
FASE 1
 ↓
TESTE
 ↓
FASE 2
 ↓
TESTE
 ↓
FASE 3
 ↓
CHEFE
 ↓
TESTE DO MUNDO
 ↓
POLIMENTO
```

Evitar construir as três fases completamente antes de testar a primeira.

---

# 95. ETAPA 10 — MUNDO 5

## ÁRVORE DO MESTRE CORVO

Foco:

**DOMÍNIO DAS MECÂNICAS**

O mundo final deverá combinar conhecimentos anteriores.

---

# 96. FASE 5-1 — RAÍZES

Combinar:

- exploração;
- força;
- passagens;
- inimigos.

---

# 97. FASE 5-2 — INTERIOR DA ÁRVORE

Combinar:

- mecanismos;
- verticalidade;
- planar;
- Pipo;
- segredos.

A narrativa deverá começar a revelar com maior clareza a situação da comunidade de Mestre Corvo.

---

# 98. FASE 5-3 — O TOPO

Utilizar:

- altura;
- plataformas;
- obstáculos;
- Tico;
- Pipo;
- troca;
- cooperação.

Preparar encontro final.

---

# 99. CONFRONTO FINAL

Mestre Corvo deverá utilizar desafios que exijam:

**AGILIDADE DE TICO**

+

**FORÇA DE PIPO**

A resolução narrativa não deverá depender simplesmente da destruição do antagonista.

---

# 100. FINAL

Recuperar o tema central:

**COOPERAÇÃO**

**AMIZADE**

**COMPARTILHAMENTO**

Cena final:

Tico e Pipo compartilhando comida.

Pipo:

**CAMISA VERDE.**

Mensagem:

**“Quando trabalhamos juntos, todos podem ter um lugar à mesa.”**

---

# 101. MARCO 7

**JOGO COMPLETO DO INÍCIO AO FIM**

Neste momento todas as fases principais deverão ser jogáveis.

Isso não significa que o jogo está pronto para publicação.

---

# 102. ETAPA 11 — POLIMENTO

## OBJETIVO

Transformar conteúdo completo em produto final.

---

# 103. BUG FIXING

Corrigir:

- colisões;
- travamentos;
- softlocks;
- checkpoints;
- save;
- controles;
- câmera;
- animações;
- áudio;
- interface.

---

# 104. POLIMENTO VISUAL

Revisar:

- partículas;
- iluminação;
- backgrounds;
- animações;
- transições;
- UI;
- feedback.

---

# 105. POLIMENTO DE ÁUDIO

Revisar:

- volumes;
- música;
- efeitos;
- repetições;
- transições.

---

# 106. DIFICULDADE

Revisar jogo completo.

Verificar:

- picos de dificuldade;
- fases muito longas;
- checkpoints;
- chefes;
- quantidade de inimigos;
- punição.

---

# 107. TESTES INFANTIS

Realizar testes com público compatível com o público-alvo.

Observar principalmente:

**ONDE PARAM?**

**ONDE ERRAM?**

**ONDE NÃO ENTENDEM?**

**ONDE SE DIVERTEM?**

**O QUE TENTAM FAZER ESPONTANEAMENTE?**

---

# 108. ACESSIBILIDADE

Revisar:

- tamanho de texto;
- contraste;
- cores;
- controles;
- feedback;
- legibilidade;
- quantidade de informação.

---

# 109. PWA

Realizar testes finais de:

- instalação;
- atualização;
- offline;
- cache;
- save;
- fullscreen;
- landscape;
- touchscreen.

---

# 110. ANDROID

Gerar build Android.

Testar:

- APK;
- instalação;
- desempenho;
- touchscreen;
- áudio;
- save.

---

# 111. WINDOWS

Gerar versão Windows.

Testar em máquina limpa quando possível.

---

# 112. ETAPA 12 — PUBLICAÇÃO

## OBJETIVO

Disponibilizar a primeira versão pública.

---

# 113. PUBLICAÇÃO WEB/PWA

Estrutura:

```text
Internet
   ↓
HTTPS
   ↓
jogar.tico.com.br
   ↓
Tico e a Floresta das Nozes
```

---

# 114. PÁGINA DE ENTRADA

A experiência deverá ser simples.

Exemplo:

```text
TICO E A FLORESTA DAS NOZES

[ JOGAR ]

Uma aventura de amizade,
exploração e cooperação.
```

---

# 115. INSTALAÇÃO

Quando suportado:

permitir instalação como PWA.

A experiência deverá ser opcional.

O jogador poderá continuar jogando diretamente pelo navegador.

---

# 116. MONITORAMENTO INICIAL

Após publicação:

observar principalmente:

- erros;
- desempenho;
- carregamento;
- incompatibilidades;
- save;
- instalação PWA;
- feedback dos jogadores.

---

# 117. ATUALIZAÇÕES

Prioridade inicial:

```text
BUGS CRÍTICOS
      ↓
PROBLEMAS DE GAMEPLAY
      ↓
PROBLEMAS DE ACESSIBILIDADE
      ↓
PROBLEMAS VISUAIS
      ↓
NOVOS RECURSOS
```

Evitar adicionar conteúdo enquanto problemas importantes permanecem.

---

# 118. ROADMAP RESUMIDO

```text
0. PREPARAÇÃO
      ↓
1. FUNDAÇÃO
      ↓
2. TICO
      ↓
3. WEB + TOUCH + PWA
      ↓
4. GAMEPLAY BÁSICO
      ↓
5. PIPO
      ↓
6. PROTÓTIPO COMPLETO
      ↓
7. VERTICAL SLICE
      ↓
8. MUNDO 1
      ↓
9. MUNDOS 2–4
      ↓
10. MUNDO 5
      ↓
11. POLIMENTO
      ↓
12. PUBLICAÇÃO
```

---

# 119. MARCOS PRINCIPAIS

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

# 120. REGRA DE AVANÇO

Uma etapa somente deverá avançar quando sua principal hipótese tiver sido validada.

Exemplo:

## TICO

Hipótese:

**movimentação é divertida.**

## PWA

Hipótese:

**jogo funciona adequadamente no navegador e celular.**

## PIPO

Hipótese:

**segundo personagem acrescenta gameplay.**

## PROTÓTIPO

Hipótese:

**o conceito geral funciona.**

## VERTICAL SLICE

Hipótese:

**arte, áudio e gameplay funcionam juntos.**

## MUNDO 1

Hipótese:

**estrutura de produção das fases funciona.**

---

# 121. CONTROLE DE ESCOPO

Durante desenvolvimento surgirão novas ideias.

Não implementar automaticamente.

Registrar primeiro.

Classificar:

```text
ESSENCIAL
IMPORTANTE
DESEJÁVEL
FUTURO
FORA DO ESCOPO
```

Pergunta principal:

**ISSO É NECESSÁRIO PARA VALIDAR A ETAPA ATUAL?**

Se não:

registrar e continuar.

---

# 122. IDEIAS FUTURAS

Recursos que poderão ser avaliados somente após a base funcionar:

- fases secretas;
- cosméticos;
- mais coletáveis;
- conquistas;
- novos personagens;
- novos mundos;
- desafios extras;
- recursos educacionais;
- contas;
- progresso na nuvem;
- painel para responsáveis/professores.

Esses recursos não deverão atrasar o MVP.

---

# 123. MVP

O MVP deverá possuir:

- Tico;
- Pipo;
- movimentação;
- salto;
- planar;
- força;
- investida;
- troca;
- nozes;
- inimigo;
- blocos;
- checkpoint;
- fase completa;
- HUD;
- áudio básico;
- teclado;
- touchscreen;
- save;
- Web;
- PWA;
- funcionamento offline básico.

O MVP não precisa possuir os cinco mundos.

---

# 124. VERTICAL SLICE

O Vertical Slice deverá responder:

**COMO SERÁ O JOGO FINAL?**

Deverá possuir qualidade representativa de:

- gameplay;
- visual;
- áudio;
- interface;
- controles;
- desempenho.

---

# 125. VERSÃO 1.0

A versão 1.0 deverá representar:

```text
5 MUNDOS

3 FASES PRINCIPAIS POR MUNDO

15 FASES PRINCIPAIS

TICO

PIPO

MESTRE CORVO

INIMIGOS

CHEFES DEFINIDOS NO ESCOPO FINAL

HISTÓRIA COMPLETA

PWA

SAVE

TOUCHSCREEN

WINDOWS

ANDROID, SE APROVADO PARA O LANÇAMENTO
```

A presença de chefes e da versão Android no lançamento deverá ser confirmada durante o desenvolvimento, conforme escopo, desempenho e testes.

---

# 126. PRIORIDADE REAL

A ordem de prioridade deverá permanecer:

```text
1. GAMEPLAY

2. CLAREZA PARA A CRIANÇA

3. ESTABILIDADE

4. DESEMPENHO

5. ARTE

6. CONTEÚDO

7. RECURSOS EXTRAS
```

Arte é importante, mas não deverá esconder problemas de gameplay.

Conteúdo não deverá substituir qualidade.

---

# 127. PRINCÍPIO DO PRIMEIRO PROTÓTIPO

O primeiro protótipo poderá ser:

**FEIO**

**PEQUENO**

**SIMPLES**

Mas deverá ser:

**JOGÁVEL**

**TESTÁVEL**

**DIVERTIDO**

Um protótipo bonito que não responde às perguntas do projeto não cumpriu sua função.

---

# 128. PRIMEIRA META PRÁTICA

Depois da documentação inicial, a primeira meta de programação será extremamente pequena:

```text
CRIAR PROJETO GODOT
       ↓
CRIAR UMA FASE VAZIA
       ↓
CRIAR TICO
       ↓
ADICIONAR CHÃO
       ↓
TICO ANDA
       ↓
TICO PULA
```

Neste ponto:

**PARAR.**

Jogar.

Ajustar.

Jogar novamente.

---

# 129. SEGUNDA META PRÁTICA

Somente depois:

```text
CÂMERA
   ↓
PLANAR
   ↓
PLATAFORMAS
   ↓
EXPORTAR WINDOWS
   ↓
EXPORTAR WEB
   ↓
ABRIR NO CELULAR
```

---

# 130. TERCEIRA META PRÁTICA

Depois:

```text
TOUCH
   ↓
PWA
   ↓
INSTALAR
   ↓
TESTAR OFFLINE
```

Assim validaremos muito cedo uma das principais decisões arquiteturais do projeto.

---

# 131. PRINCÍPIO FINAL

O desenvolvimento de **Tico e a Floresta das Nozes** não deverá começar construindo uma floresta inteira.

Começará com:

**UM ESQUILO.**

**UM CHÃO.**

**UM BOTÃO.**

**UM PULO.**

Quando esse pulo for divertido:

adicionaremos uma noz.

Depois uma lesma.

Depois Pipo.

Depois uma fase.

Depois um mundo.

E somente então:

**A FLORESTA.**

O objetivo do roadmap é impedir que o projeto cresça mais rápido do que nossa capacidade de testar suas ideias.

A cada etapa:

**CONSTRUIR**

**JOGAR**

**TESTAR**

**APRENDER**

**MELHORAR**

e somente depois:

**EXPANDIR.**

---

**FIM DO DOCUMENTO**
