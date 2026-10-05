# TICO E A FLORESTA DAS NOZES

## PLANO DE TESTES E VALIDAÇÃO

**Versão:** 1.0  
**Documento:** 10_testes.md

**Execução da etapa 9:** 349 verificações na Godot e cinco cenários Web aprovados;
Windows exportado e executado, com medição gráfica local. Percursos, chefes,
migração e retomada dos mecanismos foram conferidos. Playtest no aparelho
permanece pendente. [Relatório e roteiro](../tests/etapa_9.md).

## Diretriz de evolução aprovada

Em cada E00–E30, executar verificações de regressão adequadas e conferir PWA, desempenho e save conforme o impacto. Cobrir Pipo bloqueado antes do resgate, liberado nas fases iniciais após ele e preservado ao migrar/reabrir. Conferir Game Over no Mundo 1 e nos demais: mapa do mundo anterior, vidas restauradas e desbloqueios intactos. Medir duração e exploração após uma fase completa da evolução. Auditorias finais complementam essas verificações.

Estas decisões descrevem a evolução a implementar; os builds da etapa 9 registram o comportamento anterior. Referências: [evolução](13_evolucao.md), [etapas E00–E30](14_etapas_evolucao.md) e DEC-115 em [decisões](11_decisoes.md).

---

# 1. OBJETIVO

Este documento define a estratégia de testes e validação de **Tico e a Floresta das Nozes**.

O objetivo não é apenas verificar se o jogo:

**FUNCIONA**

mas também se ele é:

**DIVERTIDO**

**FÁCIL DE ENTENDER**

**CONFORTÁVEL DE CONTROLAR**

**ESTÁVEL**

**ADEQUADO PARA CRIANÇAS**

**JOGÁVEL EM WEB/PWA**

**JOGÁVEL EM TOUCHSCREEN**

**COERENTE COM A HISTÓRIA**

---

# 2. PRINCÍPIO DE QUALIDADE

Uma funcionalidade não está pronta apenas porque:

**NÃO APRESENTA ERRO.**

Ela estará pronta quando:

```text
FUNCIONA
   +
É COMPREENSÍVEL
   +
É AGRADÁVEL
   +
É ESTÁVEL
   +
FUNCIONA NAS PLATAFORMAS-ALVO
```

---

# 3. FILOSOFIA DE TESTES

O projeto seguirá:

```text
IMPLEMENTAR
    ↓
TESTAR
    ↓
OBSERVAR
    ↓
CORRIGIR
    ↓
TESTAR NOVAMENTE
    ↓
VALIDAR
```

Testes deverão ocorrer durante todo o desenvolvimento.

Não deixar testes apenas para o final.

---

# 4. CATEGORIAS DE TESTE

O projeto utilizará:

1. testes funcionais;
2. testes de gameplay;
3. testes de personagens;
4. testes de fases;
5. testes de narrativa;
6. testes de interface;
7. testes de touchscreen;
8. testes Web/PWA;
9. testes de save;
10. testes de áudio;
11. testes de desempenho;
12. testes de compatibilidade;
13. testes de regressão;
14. testes com crianças;
15. testes de publicação.

---

# 5. NÍVEIS DE TESTE

Os testes serão realizados progressivamente.

```text
MECÂNICA
   ↓
PERSONAGEM
   ↓
OBJETO
   ↓
TRECHO DE FASE
   ↓
FASE
   ↓
MUNDO
   ↓
JOGO COMPLETO
   ↓
PLATAFORMA
```

---

# 6. TESTES DURANTE O DESENVOLVIMENTO

Cada nova funcionalidade deverá possuir pelo menos:

```text
TESTE ISOLADO
+
TESTE DENTRO DA FASE
+
TESTE DE INTEGRAÇÃO
```

Exemplo:

**PLANAR**

Primeiro:

testar Tico sozinho.

Depois:

testar em plataformas.

Depois:

testar em uma fase real.

---

# 7. AMBIENTE DE TESTE

Manter uma cena:

`test_level.tscn`

Essa cena servirá para testar:

- personagens;
- inimigos;
- blocos;
- plataformas;
- objetos;
- física;
- coletáveis;
- checkpoints.

Ela não será uma fase oficial.

---

# 8. ÁREA DE TESTE

A cena poderá possuir áreas identificadas:

```text
MOVIMENTO

SALTO

PLANAR

INIMIGOS

BLOCOS

PIPO

OBJETOS

CHECKPOINT

PLATAFORMAS
```

Isso facilitará testes rápidos.

---

# 9. TESTE DE MOVIMENTO — TICO

Validar:

- andar para esquerda;
- andar para direita;
- parar;
- mudar rapidamente de direção;
- aceleração;
- desaceleração;
- colisão com paredes;
- colisão com chão;
- bordas;
- pequenas plataformas.

---

# 10. CRITÉRIO DE TICO

O movimento deverá transmitir:

**AGILIDADE**

Tico não deverá parecer:

- excessivamente pesado;
- escorregadio;
- lento;
- difícil de controlar.

---

# 11. TESTE DE SALTO

Testar:

- salto parado;
- salto correndo;
- salto próximo à parede;
- salto próximo à borda;
- queda;
- aterrissagem;
- vários saltos consecutivos;
- salto sobre inimigos;
- salto entre plataformas.

---

# 12. PERGUNTAS SOBRE O SALTO

Durante testes:

**A altura é adequada?**

**A distância é previsível?**

**O jogador entende onde Tico cairá?**

**Existe controle suficiente no ar?**

**O salto parece divertido?**

---

# 13. COYOTE TIME

Se utilizado:

testar salto poucos instantes depois de sair da plataforma.

Objetivo:

reduzir frustração causada por pequenos erros de timing.

---

# 14. JUMP BUFFER

Se utilizado:

testar pressionar pulo ligeiramente antes de tocar o chão.

O salto deverá ocorrer quando apropriado.

---

# 15. TESTE DE PLANAR

Validar:

```text
PULAR
  ↓
SEGURAR PULO
  ↓
PLANAR
```

Testar:

- altura;
- duração;
- velocidade de queda;
- distância;
- cancelamento;
- aterrissagem;
- obstáculos.

---

# 16. CRITÉRIO DO PLANAR

A criança deverá perceber:

**TICO CAI MAIS DEVAGAR.**

Não deverá ser necessário compreender uma explicação técnica.

---

# 17. TESTE DE MOVIMENTO — PIPO

Validar:

- esquerda;
- direita;
- salto;
- queda;
- parada;
- colisão;
- mudança de direção.

---

# 18. CRITÉRIO DE PIPO

Pipo deverá parecer:

**MAIS PESADO QUE TICO**

mas nunca:

**RUIM DE CONTROLAR.**

A diferença deverá ser intencional e compreensível.

---

# 19. TESTE DE EMPURRAR

Testar:

- objeto correto;
- direção;
- velocidade;
- colisão;
- parede;
- borda;
- objeto preso;
- dois objetos próximos.

Validar que Tico não execute a mesma ação quando não deveria.

---

# 20. TESTE DE INVESTIDA

Testar:

- início;
- duração;
- velocidade;
- impacto;
- cancelamento;
- parede;
- inimigo;
- bloco pesado;
- borda.

A investida deverá possuir feedback claro.

---

# 21. TESTE DO FARO

Validar:

- ativação;
- alcance;
- indicação visual;
- direção;
- descoberta;
- segredo;
- repetição.

Pergunta principal:

**A criança entende que Pipo encontrou alguma coisa?**

---

# 22. TESTE DE TROCA

Validar:

```text
TICO → PIPO

PIPO → TICO
```

Testar:

- parado;
- durante exploração;
- próximo a obstáculo;
- checkpoint;
- após dano;
- próximo a inimigo.

---

# 23. PERSONAGEM INATIVO

Verificar:

- posição;
- colisão;
- animação;
- segurança;
- possibilidade de ficar preso;
- possibilidade de bloquear passagem.

---

# 24. TESTE DE COMPLEMENTARIDADE

Criar situações onde:

```text
TICO CONSEGUE
PIPO NÃO CONSEGUE
```

e:

```text
PIPO CONSEGUE
TICO NÃO CONSEGUE
```

Depois:

```text
OS DOIS SÃO NECESSÁRIOS
```

---

# 25. PERGUNTA CENTRAL DA DUPLA

Durante testes:

> O jogador consegue entender por conta própria que Tico representa agilidade e Pipo representa força?

Se for necessária uma longa explicação:

o design deverá ser revisto.

---

# 26. TESTES DE INIMIGOS

Para cada inimigo verificar:

- movimento;
- colisão;
- dano;
- animação;
- derrota;
- limites;
- comportamento próximo a plataformas;
- interação com Tico;
- interação com Pipo.

---

# 27. LESMA

Validar:

- patrulha;
- mudança de direção;
- velocidade;
- contato;
- pisão;
- derrota.

A lesma deverá ser adequada como primeiro inimigo.

---

# 28. OURIÇO

Validar visualmente que:

**NÃO É SEGURO PISAR NORMALMENTE.**

A aparência deverá comunicar os espinhos antes do jogador precisar aprender pelo erro.

---

# 29. CORVO

Validar:

- voo;
- trajetória;
- previsibilidade;
- altura;
- colisão.

Não deverá atacar de maneira impossível de antecipar.

---

# 30. COBRA

A surpresa deverá ser:

**DIVERTIDA**

e não:

**INJUSTA.**

Deverá existir algum indício antes do ataque quando necessário.

---

# 31. CASTOR

Validar:

- ataque à distância;
- trajetória;
- intervalo;
- aviso;
- possibilidade de desviar.

---

# 32. DERROTA DOS INIMIGOS

Não utilizar:

- sangue;
- ferimentos realistas;
- morte explícita.

Preferir:

- tontura;
- fumaça;
- fuga;
- animação engraçada;
- desaparecimento estilizado.

---

# 33. TESTE DE DANO

Validar:

```text
CONTATO
   ↓
DANO
   ↓
FEEDBACK
   ↓
INVULNERABILIDADE TEMPORÁRIA
   ↓
RETORNO
```

O jogador deverá entender imediatamente que sofreu dano.

---

# 34. INVULNERABILIDADE TEMPORÁRIA

Testar se impede:

- perda imediata de vários corações;
- dano contínuo injusto;
- aprisionamento junto ao inimigo.

---

# 35. TESTE DE VIDA

Validar:

- vida máxima;
- dano;
- cura;
- zero corações;
- respawn;
- atualização do HUD.

---

# 36. TESTE DE BLOCOS

Testar:

- bloco comum;
- bloco quebrável;
- bloco de noz;
- bloco pesado;
- bloco invisível.

Verificar:

- colisão;
- feedback;
- animação;
- som;
- recompensa.

---

# 37. BLOCO PESADO

Regra:

```text
TICO
não quebra

PIPO
quebra
```

A diferença deverá ser visualmente compreensível.

---

# 38. BLOCO INVISÍVEL

Verificar se a descoberta através de Pipo é:

- compreensível;
- recompensadora;
- consistente.

Não utilizar de maneira que pareça injusta.

---

# 39. TESTE DE COLETÁVEIS

Para cada coletável:

- colisão;
- animação;
- som;
- contador;
- persistência;
- duplicação;
- respawn quando apropriado.

---

# 40. NOZ COMUM

A noz deverá ser:

- fácil de reconhecer;
- visualmente atraente;
- rápida de coletar;
- útil como orientação.

---

# 41. NOZES COMO GUIA

Testar sequências como:

```text
🌰  🌰  🌰  🌰
           ↗
       plataforma
```

Verificar se o jogador naturalmente segue o caminho.

---

# 42. TESTE DE POWER-UPS

Para cada power-up verificar:

- identificação;
- coleta;
- duração;
- efeito;
- feedback;
- término.

A criança deverá entender que algo mudou.

---

# 43. TESTE DE CHECKPOINT

Testar:

- ativação;
- feedback;
- registro;
- morte;
- retorno;
- múltiplos checkpoints;
- reinício da fase.

---

# 44. CRITÉRIO DO CHECKPOINT

Depois de ativado, deverá ser evidente que:

**ALGO FOI SALVO/REGISTRADO.**

Utilizar:

- animação;
- som;
- luz;
- efeito.

---

# 45. TESTE DE RESPAWN

O jogador não deverá:

- reaparecer dentro de parede;
- cair imediatamente;
- reaparecer sobre inimigo;
- perder controle;
- voltar ao checkpoint errado.

---

# 46. TESTES DE FASE

Cada fase deverá ser testada isoladamente.

Verificar:

- início;
- progressão;
- dificuldade;
- checkpoints;
- segredos;
- inimigos;
- narrativa;
- final.

---

# 47. PRIMEIRO MINUTO

O primeiro minuto de cada fase deverá ser testado separadamente.

Perguntas:

**O jogador sabe para onde ir?**

**Existe perigo imediato injusto?**

**A nova mecânica é apresentada adequadamente?**

---

# 48. CAMINHO PRINCIPAL

Deverá ser possível encontrar o caminho principal sem depender de tentativa aleatória.

Utilizar:

- composição;
- iluminação;
- objetos;
- nozes;
- movimento;
- enquadramento.

---

# 49. CAMINHOS OPCIONAIS

Segredos deverão:

- recompensar curiosidade;
- não impedir conclusão;
- não causar confusão excessiva.

---

# 50. TESTE DE SEGREDOS

Observar:

- quantos jogadores percebem;
- quantos tentam alcançar;
- se entendem a recompensa;
- se conseguem retornar ao caminho principal.

---

# 51. TESTE DE DIFICULDADE

Classificar trechos:

```text
MUITO FÁCIL
FÁCIL
ADEQUADO
DIFÍCIL
MUITO DIFÍCIL
```

Para o público-alvo, priorizar:

**FÁCIL → ADEQUADO**

com desafios progressivos.

---

# 52. TESTE DE FRUSTRAÇÃO

Observar sinais como:

- repetição excessiva;
- abandono;
- apertar botões aleatoriamente;
- não entender o objetivo;
- reclamar de controles;
- pedir ajuda constantemente.

Esses sinais deverão ser registrados.

---

# 53. TESTES DOS MUNDOS

Depois das três fases de um mundo:

testar o mundo completo em sequência.

Verificar:

- evolução;
- repetição;
- variedade;
- dificuldade;
- narrativa;
- identidade visual.

---

# 54. TESTE DE PROGRESSÃO

Cada mundo deverá parecer:

**UM PASSO ADIANTE**

e não:

**UM JOGO DIFERENTE.**

---

# 55. TESTE DE CHEFES

Para cada chefe:

- apresentação;
- padrões;
- telegraph;
- dano;
- fases;
- dificuldade;
- feedback;
- conclusão.

---

# 56. CRITÉRIO DOS CHEFES

A criança deverá aprender:

```text
OBSERVAR
↓
ENTENDER
↓
AGIR
```

e não:

```text
PERDER
↓
DECORAR
↓
TENTAR ALEATORIAMENTE
```

---

# 57. TESTES DE NARRATIVA

Consultar:

`09_historia-e-narrativa.md`

Cada cena deverá responder:

- o que revela?
- o jogador entende?
- é necessária?
- está longa?
- cria curiosidade?

---

# 58. TESTE DA ABERTURA

Depois da abertura, perguntar sem explicar:

**Quem é Tico?**

**O que aconteceu?**

**O que Tico quer fazer?**

A resposta esperada deverá ser próxima de:

```text
Tico é um esquilo.

Suas nozes desapareceram.

Ele quer descobrir o que aconteceu.
```

---

# 59. TESTE DAS CENAS DE FIM DE FASE

Depois da cena:

perguntar:

**O que Tico descobriu?**

Se a criança não souber:

a cena precisa ser revista.

---

# 60. TESTE DE PIPO

Depois do encontro:

a criança deverá compreender:

- quem é Pipo;
- que sua família também perdeu comida;
- que ele agora acompanha Tico.

---

# 61. TESTE DE MESTRE CORVO

Antes da revelação final:

o jogador poderá considerá-lo simplesmente o vilão.

Depois da revelação:

deverá compreender:

```text
CORVO TINHA UM PROBLEMA REAL

MAS

ESCOLHEU UMA SOLUÇÃO ERRADA
```

---

# 62. TESTE DA MENSAGEM FINAL

Ao terminar:

a criança deverá compreender de maneira simples a ideia de:

**TRABALHAR JUNTOS**

e:

**COMPARTILHAR.**

Evitar exigir que repita uma “moral da história”.

---

# 63. TESTE DE CUTSCENES

Validar:

- início;
- fim;
- câmera;
- personagens;
- animação;
- diálogo;
- transição;
- possibilidade de pular quando prevista.

---

# 64. REPETIÇÃO DE FASE

Se uma cutscene já foi assistida:

verificar se repetir a fase não obriga o jogador a assistir novamente a uma cena longa sem possibilidade de pular.

---

# 65. TESTES DE INTERFACE

Validar:

- menus;
- HUD;
- pausa;
- configurações;
- conclusão da fase.

---

# 66. HUD

Verificar:

- corações;
- nozes;
- personagem ativo.

Pergunta:

**A criança entende sem explicação excessiva?**

---

# 67. TAMANHO DE TEXTO

Testar em:

- monitor;
- notebook;
- tablet;
- celular.

Texto legível no computador pode ficar pequeno no celular.

---

# 68. CONTRASTE

Verificar texto e ícones sobre:

- céu;
- floresta;
- água;
- cavernas;
- madeira;
- áreas claras;
- áreas escuras.

---

# 69. NÃO DEPENDER APENAS DE COR

Informações importantes deverão combinar:

- cor;
- forma;
- símbolo;
- animação;
- posição.

---

# 70. TESTES TOUCHSCREEN

Touchscreen é requisito do projeto.

Testar desde as primeiras versões.

---

# 71. BOTÕES TOUCH

Validar:

- tamanho;
- distância;
- posição;
- transparência;
- feedback;
- múltiplos toques.

---

# 72. TESTE DE DOIS COMANDOS

Exemplo:

```text
DIREITA
+
PULO
```

Deverão funcionar simultaneamente.

Também:

```text
DIREITA
+
PULO MANTIDO
+
PLANAR
```

---

# 73. TESTE COM POLEGARES

Testar segurando o celular de maneira natural:

```text
MÃO ESQUERDA
movimento

MÃO DIREITA
ações
```

Evitar exigir posições desconfortáveis.

---

# 74. TESTE DE PIPO NO TOUCH

Validar:

- movimento;
- salto;
- ação;
- investida;
- troca.

Evitar criar um botão para cada habilidade.

---

# 75. TESTE DE ORIENTAÇÃO

O jogo deverá funcionar prioritariamente em:

**LANDSCAPE.**

Verificar comportamento ao:

- abrir;
- girar aparelho;
- bloquear;
- retornar ao jogo.

---

# 76. TESTE DE SAFE AREA

Elementos importantes não deverão ficar escondidos por:

- bordas;
- recortes;
- barras;
- áreas do sistema.

---

# 77. TESTES WEB

A versão Web deverá ser testada durante todo o projeto.

Não apenas antes do lançamento.

---

# 78. CARREGAMENTO WEB

Medir:

- tempo inicial;
- feedback;
- tela de carregamento;
- travamentos.

Nunca deixar tela vazia sem indicar o que está acontecendo.

---

# 79. TESTE DE FULLSCREEN

Verificar:

- entrada;
- saída;
- resolução;
- HUD;
- controles;
- câmera.

---

# 80. TESTE DE FOCO

Testar:

```text
jogo
↓
trocar de aba
↓
retornar
```

Verificar:

- pausa;
- áudio;
- input;
- estado do jogo.

---

# 81. TESTE DE BLOQUEIO DO CELULAR

Durante o jogo:

1. bloquear tela;
2. aguardar;
3. desbloquear;
4. retornar.

Verificar estado do jogo.

---

# 82. TESTES PWA

Validar:

- acesso por HTTPS;
- instalação;
- ícone;
- nome;
- abertura;
- modo standalone/fullscreen;
- orientação;
- cache;
- offline;
- atualização.

---

# 83. TESTE DE INSTALAÇÃO PWA

Fluxo:

```text
ABRIR SITE
   ↓
INSTALAR
   ↓
FECHAR NAVEGADOR
   ↓
ABRIR PELO ÍCONE
   ↓
JOGAR
```

---

# 84. TESTE OFFLINE

Fluxo:

```text
INSTALAR
↓
JOGAR
↓
FECHAR
↓
DESATIVAR INTERNET
↓
ABRIR
↓
JOGAR
```

Registrar quais recursos funcionam sem conexão.

---

# 85. TESTE DE ATUALIZAÇÃO PWA

Fluxo:

```text
VERSÃO A
↓
JOGAR
↓
SALVAR
↓
PUBLICAR VERSÃO B
↓
ATUALIZAR
↓
ABRIR
↓
SAVE CONTINUA
```

---

# 86. TESTES DE SAVE

Testar:

- novo jogo;
- salvar;
- carregar;
- sobrescrever;
- fechar;
- reabrir;
- atualização.

---

# 87. TESTE DE SAVE PWA

Validar especificamente:

```text
JOGAR
↓
SALVAR
↓
FECHAR PWA
↓
ABRIR PWA
↓
CONTINUAR
```

---

# 88. SAVE CORROMPIDO

O jogo deverá tratar save inválido de maneira segura.

Não deverá:

- travar;
- impedir abertura;
- entrar em loop.

Quando possível:

usar valores padrão ou estratégia de recuperação.

---

# 89. VERSÃO DO SAVE

Testar mudanças entre:

```text
save_version = 1
```

e futuras versões.

Alterações deverão preservar dados sempre que possível.

---

# 90. TESTES DE ÁUDIO

Validar:

- música;
- efeitos;
- UI;
- volumes;
- pausa;
- mudança de fase;
- navegador.

---

# 91. PRIMEIRA INTERAÇÃO WEB

Testar áudio após:

```text
CLIQUE/TOQUE
↓
JOGAR
```

para respeitar comportamento dos navegadores.

---

# 92. TESTE DE VOLUME

Nenhum efeito deverá ser:

- excessivamente alto;
- assustador;
- agressivo.

Especialmente:

- dano;
- impacto;
- chefe;
- derrota.

---

# 93. TESTES DE DESEMPENHO

Meta inicial:

**60 FPS**

quando viável nos dispositivos-alvo definidos para o projeto.

Também observar estabilidade.

---

# 94. O QUE MEDIR

Observar:

- FPS;
- memória;
- carregamento;
- tamanho do build;
- travamentos;
- quedas de desempenho;
- uso excessivo de partículas;
- quantidade de objetos.

---

# 95. TESTE DE PIOR CENÁRIO

Criar trecho contendo:

- vários inimigos;
- partículas;
- coletáveis;
- plataformas;
- cenário;
- áudio.

Testar desempenho.

---

# 96. WEB/MOBILE COMO REFERÊNCIA

Uma funcionalidade que funciona perfeitamente no computador, mas inviabiliza o PWA no celular, deverá ser reconsiderada.

---

# 97. TESTE DE BUILD WINDOWS

Validar em versão exportada.

Não testar somente pelo editor Godot.

---

# 98. TESTE DE BUILD WEB

Validar exportação real através de servidor HTTP/HTTPS adequado.

Não considerar apenas execução dentro do editor.

---

# 99. TESTE ANDROID NATIVO

Quando APK entrar no ciclo:

validar:

- instalação;
- inicialização;
- touch;
- áudio;
- save;
- desempenho;
- retorno após minimizar.

---

# 100. MATRIZ DE PLATAFORMAS

Cada release importante deverá registrar pelo menos:

| Plataforma | Input | Execução |
|---|---|---|
| Windows | Teclado | Build nativo |
| Web desktop | Teclado | Navegador |
| PWA Android | Touch | PWA |
| Android nativo | Touch | APK, quando aplicável |

---

# 101. TESTES COM CRIANÇAS

Esses testes serão essenciais.

O objetivo principal não é perguntar:

> Você gostou?

O objetivo é:

**OBSERVAR.**

---

# 102. PRINCÍPIO DE OBSERVAÇÃO

Durante o teste:

**NÃO EXPLICAR IMEDIATAMENTE.**

Se a criança parar:

observar.

Se tentar algo:

observar.

Se errar:

observar.

Isso revela problemas que uma explicação esconderia.

---

# 103. O QUE OBSERVAR

Registrar:

- onde olha;
- para onde vai;
- onde para;
- onde erra;
- onde pede ajuda;
- o que tenta;
- o que ignora;
- o que repete;
- onde sorri;
- onde demonstra frustração.

---

# 104. NÃO INDUZIR

Evitar:

> Aperte o botão verde.

Preferir observar se ela descobre.

Se precisar ajudar, registrar:

**PRECISOU DE AJUDA.**

---

# 105. PERGUNTAS APÓS O TESTE

Depois da sessão poderão ser feitas perguntas simples.

Exemplos:

**Quem é Tico?**

**Quem é Pipo?**

**O que aconteceu com as nozes?**

**Qual personagem é melhor para subir?**

**Qual personagem é melhor para coisas pesadas?**

**Qual parte você mais gostou?**

**Teve alguma parte difícil?**

---

# 106. EVITAR INTERROGATÓRIO

O teste deverá continuar sendo uma experiência leve.

Utilizar poucas perguntas.

Priorizar observação espontânea.

---

# 107. TESTE DE CONTROLES COM CRIANÇAS

Observar se:

- encontram os botões;
- conseguem correr e pular;
- conseguem usar dois comandos;
- entendem planar;
- entendem troca;
- entendem ação.

---

# 108. TESTE DA DUPLA

Sem explicar diretamente:

criar obstáculo que Tico não consegue resolver.

Observar:

**A criança pensa em trocar para Pipo?**

Depois:

criar obstáculo de agilidade.

Observar:

**Ela retorna para Tico?**

---

# 109. TESTE DA NARRATIVA COM CRIANÇAS

Não perguntar:

> Você entendeu que Mestre Corvo representa um antagonista moralmente complexo?

Perguntar:

> Por que o Corvo pegou a comida?

Depois:

> Você acha que Tico descobriu alguma coisa importante?

Usar linguagem compatível com a criança.

---

# 110. REGISTRO DA SESSÃO

Modelo:

```text
TESTE:
PLAYTEST-001

BUILD:
0.4.0

PLATAFORMA:
PWA Android

FASE:
Protótipo

DURAÇÃO:
________

OBSERVAÇÕES:
________

PRECISOU DE AJUDA:
________

PROBLEMAS:
________

PONTOS POSITIVOS:
________

MUDANÇAS PROPOSTAS:
________
```

---

# 111. PRIVACIDADE NOS TESTES

Ao realizar testes com crianças:

evitar coletar dados pessoais desnecessários.

Se houver gravação de:

- imagem;
- voz;
- tela associada à criança;

deverão ser adotadas autorizações e cuidados apropriados.

Para testes comuns, registros anônimos de observação podem ser suficientes.

---

# 112. CLASSIFICAÇÃO DE BUGS

Utilizar:

```text
CRÍTICO
ALTO
MÉDIO
BAIXO
```

---

# 113. BUG CRÍTICO

Exemplos:

- jogo não abre;
- save impede inicialização;
- fase impossível de concluir;
- personagem fica permanentemente preso;
- PWA não inicia;
- perda generalizada de progresso.

Bloqueia release.

---

# 114. BUG ALTO

Exemplos:

- checkpoint incorreto;
- controle falha;
- inimigo impede progressão;
- cutscene trava;
- problema importante no touchscreen.

Normalmente deverá ser corrigido antes do release.

---

# 115. BUG MÉDIO

Exemplos:

- animação incorreta;
- pequeno problema de UI;
- som ausente;
- objeto visual desalinhado.

Avaliar conforme impacto.

---

# 116. BUG BAIXO

Exemplos:

- detalhe visual;
- pequeno desalinhamento;
- comportamento sem impacto significativo.

Pode ser programado para correção posterior.

---

# 117. REGISTRO DE BUG

Modelo:

```text
ID:
BUG-0001

TÍTULO:
Tico atravessa plataforma

BUILD:
0.3.0

PLATAFORMA:
PWA Android

FASE:
1-1

SEVERIDADE:
Alta

PASSOS:
1.
2.
3.

RESULTADO ATUAL:
________

RESULTADO ESPERADO:
________

REPRODUZ:
Sempre / Às vezes / Uma vez

EVIDÊNCIA:
Screenshot / vídeo / log

STATUS:
Aberto
```

---

# 118. STATUS DE BUG

Utilizar:

```text
ABERTO
↓
EM CORREÇÃO
↓
PRONTO PARA RETESTE
↓
VALIDADO
↓
FECHADO
```

Se ainda ocorrer:

```text
REABERTO
```

---

# 119. TESTES DE REGRESSÃO

Ao corrigir uma funcionalidade:

verificar se outra não foi quebrada.

Exemplo:

alteração no salto poderá afetar:

- planar;
- pisão;
- plataformas;
- inimigos;
- checkpoints.

---

# 120. REGRESSÃO MÍNIMA

Antes de cada build importante testar:

```text
INICIAR JOGO

MOVIMENTAR

PULAR

PLANAR

COLETAR

RECEBER DANO

DERROTAR INIMIGO

CHECKPOINT

TROCAR PERSONAGEM

AÇÃO DE PIPO

PAUSAR

CONCLUIR FASE

SALVAR

FECHAR

CONTINUAR
```

---

# 121. SMOKE TEST

Toda nova build deverá passar por um teste rápido.

Pergunta:

**AS FUNÇÕES PRINCIPAIS AINDA FUNCIONAM?**

Se não:

não distribuir a build para playtest.

---

# 122. DEFINITION OF DONE — MECÂNICA

Uma mecânica será considerada pronta para a etapa atual quando:

```text
[ ] implementada
[ ] testada isoladamente
[ ] testada na fase
[ ] possui feedback
[ ] funciona com teclado
[ ] funciona com touch, quando aplicável
[ ] funciona na Web
[ ] não cria bug bloqueador
[ ] é compreensível
[ ] documentação foi atualizada
```

---

# 123. DEFINITION OF DONE — FASE

Uma fase estará pronta quando:

```text
[ ] início funciona
[ ] final funciona
[ ] caminho principal é claro
[ ] mecânicas funcionam
[ ] inimigos funcionam
[ ] checkpoints funcionam
[ ] segredos funcionam
[ ] narrativa funciona
[ ] cutscene funciona
[ ] áudio funciona
[ ] HUD funciona
[ ] touch funciona
[ ] PWA funciona
[ ] desempenho é aceitável
[ ] não existem bugs críticos
[ ] playtest foi realizado
```

---

# 124. DEFINITION OF DONE — MUNDO

Um mundo estará pronto quando:

```text
[ ] três fases concluídas
[ ] progressão validada
[ ] mecânicas validadas
[ ] narrativa validada
[ ] identidade visual consistente
[ ] chefe validado, se aplicável
[ ] desempenho validado
[ ] save validado
[ ] playtest completo realizado
[ ] bugs críticos corrigidos
```

---

# 125. TESTES POR MARCO

## MARCO 1 — TICO PLAYGROUND

Testar:

- movimento;
- salto;
- planar;
- câmera.

Pergunta:

**Tico é divertido?**

---

# 126. MARCO 2 — TICO PWA

Testar:

- Web;
- touch;
- instalação;
- landscape;
- offline.

Pergunta:

**É confortável jogar no celular?**

---

# 127. MARCO 3 — TICO MINI GAME

Testar:

- nozes;
- inimigo;
- dano;
- blocos;
- checkpoint;
- final.

Pergunta:

**O loop básico funciona?**

---

# 128. MARCO 4 — TICO + PIPO

Testar:

- Pipo;
- força;
- investida;
- faro;
- troca;
- cooperação.

Pergunta:

**Pipo realmente acrescenta gameplay?**

---

# 129. MARCO 5 — VERTICAL SLICE

Testar:

- arte;
- animação;
- áudio;
- UI;
- desempenho;
- PWA;
- narrativa.

Pergunta:

**Essa experiência representa o jogo que queremos produzir?**

---

# 130. MARCO 6 — MUNDO 1

Testar:

- três fases;
- curva de aprendizagem;
- Pipo;
- história;
- chefe, se aplicável.

Pergunta:

**Temos um modelo sustentável para produzir os demais mundos?**

---

# 131. MARCO 7 — JOGO COMPLETO

Testar do início ao fim.

Avaliar:

- progressão;
- dificuldade;
- história;
- bugs;
- save;
- desempenho.

---

# 132. MARCO 8 — VERSÃO 1.0

Executar:

- regressão completa;
- testes de plataforma;
- testes PWA;
- testes de atualização;
- testes de instalação;
- testes de save;
- testes finais com jogadores.

---

# 133. CHECKLIST DE RELEASE PWA

Antes de publicar:

```text
[ ] HTTPS funcionando
[ ] jogo carrega
[ ] ícone correto
[ ] nome correto
[ ] landscape
[ ] touch
[ ] áudio
[ ] save
[ ] continuar
[ ] instalação
[ ] abertura pelo ícone
[ ] offline
[ ] atualização
[ ] fullscreen/standalone
[ ] desempenho
[ ] sem bug crítico
```

---

# 134. CHECKLIST DE RELEASE WINDOWS

```text
[ ] executável inicia
[ ] arquivos necessários presentes
[ ] teclado
[ ] áudio
[ ] save
[ ] fullscreen
[ ] resolução
[ ] pausa
[ ] conclusão
[ ] sem bug crítico
```

---

# 135. CHECKLIST ANDROID NATIVO

Quando aplicável:

```text
[ ] APK instala
[ ] aplicativo inicia
[ ] landscape
[ ] touch
[ ] multitouch
[ ] áudio
[ ] save
[ ] minimizar/retornar
[ ] desempenho
[ ] sem bug crítico
```

---

# 136. TESTES ANTES DE ADICIONAR CONTEÚDO

Antes de criar muitas fases:

validar:

**MOVIMENTO.**

Antes de criar muitos inimigos:

validar:

**UM INIMIGO.**

Antes de criar muitos personagens:

validar:

**TICO + PIPO.**

Antes de criar cinco mundos:

validar:

**MUNDO 1.**

---

# 137. NÃO MASCARAR PROBLEMAS

Não corrigir dificuldade simplesmente adicionando:

- mais vida;
- mais checkpoints;
- mais recompensas.

Primeiro descobrir:

**POR QUE O JOGADOR ESTÁ ERRANDO?**

Pode ser:

- controle;
- câmera;
- leitura visual;
- design da fase;
- feedback;
- regra não compreendida.

---

# 138. ERRO DO JOGADOR

Diferenciar:

```text
ERRO POR DESAFIO
```

de:

```text
ERRO POR CONFUSÃO
```

Erro por desafio pode fazer parte do jogo.

Erro por confusão geralmente indica problema de design ou comunicação.

---

# 139. PERGUNTA MAIS IMPORTANTE

Ao observar alguém falhar:

não perguntar apenas:

**“POR QUE ELE ERROU?”**

Perguntar:

**“O JOGO DEU INFORMAÇÃO SUFICIENTE PARA ELE ACERTAR?”**

---

# 140. MÉTRICAS SIMPLES

Durante playtests poderão ser registrados:

- tempo para concluir fase;
- número de derrotas;
- checkpoints alcançados;
- pedidos de ajuda;
- segredos encontrados;
- tentativas em obstáculos;
- momentos de abandono.

Não é necessário criar telemetria online para isso.

Pode ser registrado manualmente inicialmente.

---

# 141. PLANILHA DE PLAYTEST

Posteriormente poderá ser criada uma planilha:

```text
Data
Build
Jogador/Teste
Faixa etária
Plataforma
Fase
Tempo
Derrotas
Pedidos de ajuda
Problemas
Observações
```

Evitar registrar dados pessoais desnecessários.

---

# 142. TESTE DE DIVERSÃO

Diversão não é medida apenas perguntando:

**“Você gostou?”**

Observar:

- vontade de continuar;
- repetição voluntária;
- exploração;
- curiosidade;
- reação às descobertas;
- interesse por Tico e Pipo.

---

# 143. TESTE DE CURIOSIDADE

Observar se o jogador:

- segue nozes;
- procura segredos;
- investiga caminhos;
- tenta alcançar objetos;
- quer saber o que existe depois.

Isso é especialmente importante para Tico.

---

# 144. TESTE DE RECOMPENSA

Depois de:

- segredo;
- obstáculo;
- inimigo;
- puzzle;

verificar se a recompensa parece proporcional.

---

# 145. TESTE DE FEEDBACK

Toda ação importante deverá responder visualmente ou por áudio.

Exemplos:

```text
COLETOU
→ som + animação

LEVOU DANO
→ animação + som + invulnerabilidade

CHECKPOINT
→ luz + som

SEGREDO
→ efeito + recompensa

BLOCO QUEBROU
→ animação + som
```

---

# 146. TESTE SEM SOM

Jogar trecho sem áudio.

Pergunta:

**Ainda consigo entender o que acontece?**

---

# 147. TESTE VISUAL

Jogar observando principalmente elementos visuais.

Pergunta:

**O cenário comunica corretamente caminhos, perigos e objetos?**

---

# 148. TESTE DE SILHUETA

Personagens importantes deverão ser reconhecíveis pela forma.

Especialmente:

**TICO**

e:

**PIPO.**

---

# 149. REGRA VISUAL DE PIPO

Durante qualquer teste visual:

confirmar:

**PIPO ESTÁ USANDO CAMISA VERDE.**

Essa regra se aplica a:

- gameplay;
- cutscenes;
- menus;
- ilustrações;
- telas;
- materiais promocionais.

---

# 150. TESTE DE ACESSIBILIDADE VISUAL

Verificar:

- contraste;
- tamanho;
- ícones;
- dependência de cores;
- legibilidade;
- fundos.

---

# 151. TESTE DE PAUSA

Validar:

- abrir;
- fechar;
- retornar;
- áudio;
- gameplay;
- touch;
- teclado.

---

# 152. TESTE DE REINÍCIO

Testar:

- reiniciar fase;
- reiniciar após derrota;
- reiniciar após checkpoint;
- reiniciar após cutscene.

---

# 153. TESTE DE TRANSIÇÃO

Validar:

```text
MENU
↓
FASE
↓
CUTSCENE
↓
FASE
↓
RESULTADO
↓
PRÓXIMA FASE
```

Não deverá haver perda indevida de estado.

---

# 154. TESTE DE HISTÓRIA COMPLETA

Antes da versão final:

jogar as 15 fases em sequência.

Avaliar se a história pode ser compreendida sem consultar documentação externa.

---

# 155. TESTE DO ARCO DE AMIZADE

Observar se existe evolução perceptível:

```text
TICO
↓
ENCONTRA PIPO
↓
COOPERAM
↓
CONFIAM
↓
TORNAM-SE UMA DUPLA
```

---

# 156. TESTE DO ARCO DE MESTRE CORVO

Verificar se a sequência funciona:

```text
MISTÉRIO
↓
SUSPEITA
↓
RESPONSÁVEL
↓
ANTAGONISTA
↓
MOTIVAÇÃO
↓
COMPREENSÃO
↓
COOPERAÇÃO
```

A revelação não deverá parecer surgir sem preparação.

---

# 157. TESTE DO FINAL

Perguntas:

**A resolução faz sentido?**

**A solução foi preparada durante o jogo?**

**Tico e Pipo participam da solução?**

**Mestre Corvo mantém sua personalidade?**

**A mensagem é compreensível sem ser excessivamente explicada?**

---

# 158. TESTE DE CONSISTÊNCIA

Antes de releases importantes, conferir os documentos:

```text
02_requisitos.md
03_gameplay.md
04_personagens.md
05_fases-e-mundos.md
06_direcao-visual.md
07_arquitetura-tecnica.md
08_roadmap.md
09_historia-e-narrativa.md
```

Verificar se implementação e documentação continuam coerentes.

---

# 159. DECISÕES ORIGINADAS EM TESTES

Quando um teste provocar mudança importante:

registrar posteriormente em:

`11_decisoes.md`

Exemplo:

```text
DECISÃO:
Planar utiliza o mesmo botão do salto.

MOTIVO:
Testes mostraram que botão adicional
dificultava os controles touch.
```

---

# 160. CICLO DE CORREÇÃO

```text
PROBLEMA OBSERVADO
        ↓
REGISTRAR
        ↓
CLASSIFICAR
        ↓
IDENTIFICAR CAUSA
        ↓
PROPOR CORREÇÃO
        ↓
IMPLEMENTAR
        ↓
RETESTAR
        ↓
VALIDAR
```

---

# 161. NÃO CORRIGIR SEM ENTENDER

Se cinco crianças falharem no mesmo salto:

não reduzir imediatamente a distância.

Primeiro verificar:

- viram a plataforma?
- entenderam o salto?
- o controle respondeu?
- a câmera mostrou o destino?
- tentaram planar?
- existe informação visual suficiente?

Corrigir:

**A CAUSA**

e não apenas:

**O SINTOMA.**

---

# 162. PRIORIDADE DE CORREÇÃO

Prioridade:

```text
1. TRAVAMENTOS

2. IMPOSSIBILIDADE DE PROGREDIR

3. CONTROLES

4. SAVE

5. CONFUSÃO DE GAMEPLAY

6. DESEMPENHO

7. NARRATIVA

8. INTERFACE

9. ÁUDIO/VISUAL

10. DETALHES
```

A prioridade poderá mudar conforme impacto.

---

# 163. CRITÉRIO PARA AVANÇAR NO ROADMAP

Consultar:

`08_roadmap.md`

Uma etapa não deverá avançar apenas porque suas tarefas foram marcadas como concluídas.

Deverá avançar quando:

**A HIPÓTESE PRINCIPAL FOI VALIDADA.**

---

# 164. EXEMPLO

Etapa:

**TICO PLAYGROUND**

Não basta:

```text
[x] movimento
[x] salto
[x] câmera
[x] planar
```

Também precisamos responder:

**TICO É DIVERTIDO DE CONTROLAR?**

Se não:

a etapa continua.

---

# 165. OUTRO EXEMPLO

Etapa:

**TICO + PIPO**

Não basta Pipo existir.

Precisamos responder:

**PIPO CRIA UMA EXPERIÊNCIA DIFERENTE DE TICO?**

e:

**A COOPERAÇÃO É DIVERTIDA?**

---

# 166. PRINCÍPIO DE TESTE DO PROJETO

O objetivo dos testes não é provar que:

**O JOGO ESTÁ BOM.**

O objetivo é descobrir:

**ONDE ELE AINDA NÃO ESTÁ BOM.**

Quanto mais cedo um problema for encontrado:

mais barato e simples será corrigi-lo.

---

# 167. REGRA FINAL

Para **Tico e a Floresta das Nozes**, qualidade deverá significar:

```text
A CRIANÇA PEGA O CONTROLE
        ↓
ENTENDE O QUE FAZER
        ↓
TENTA
        ↓
APRENDE
        ↓
CONSEGUE
        ↓
SE DIVERTE
        ↓
FICA CURIOSA
        ↓
QUER CONTINUAR
```

Se o jogador precisa constantemente de alguém ao lado explicando:

**O JOGO PRECISA COMUNICAR MELHOR.**

Se perde porque o controle não respondeu:

**O CONTROLE PRECISA MELHORAR.**

Se não sabe para onde ir:

**A FASE PRECISA COMUNICAR MELHOR.**

Se não entende a história:

**A NARRATIVA PRECISA COMUNICAR MELHOR.**

Se não quer continuar:

precisamos descobrir:

**POR QUÊ?**

Testar não será uma etapa final do projeto.

Será parte do processo de criação.

**CRIAR → JOGAR → OBSERVAR → APRENDER → MELHORAR.**

---

---

# VALIDAÇÃO NARRATIVA — E10

Toda sequência narrativa deve verificar: suspensão e retorno do gameplay,
teclado e toque, avanço e pulo, retratos e texto em landscape, transições,
sinais de animação, ausência de repetição involuntária, persistência do evento,
reabertura offline e compatibilidade com saves anteriores. A primeira cena real
da E11 acrescentará a validação visual em celular.

Teste automatizado atual: `tests/narrative_e10_test.gd`, com 14 verificações.

**FIM DO DOCUMENTO**
## TESTES DA EVOLUÇÃO E15

Validar que o segredo não existe antes do resgate, aparece apenas na revisita de
uma fase concluída, exige o empurrão de Pipo e permite somente Tico na passagem.
Coletar a Noz Dourada, morrer, trocar de fase e reabrir devem preservar o estado.
Também concluir a fase sem explorar o desvio deve continuar possível. O teste
automatizado de referência é `tests/backtracking_e15_test.gd`.
