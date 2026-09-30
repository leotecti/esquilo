# TICO E A FLORESTA DAS NOZES

## DOCUMENTO DE ARQUITETURA TÉCNICA

**Versão:** 1.1  
**Documento:** 07_arquitetura-tecnica.md  
**Arquitetura principal:** Godot + GDScript + Web/PWA

**Implementação da etapa 9:** `expedition_campaign.gd` coordena 16 cenas dos
quatro mundos. `expedition_level.gd` estende o Bosque com ambiente e mecanismos.
`expedition_save.gd` importa o save da etapa 8 para `campaign.json` /
`tico.campaign.v1`, preservando o original. [Detalhes e testes](../tests/etapa_9.md).

---

# 1. OBJETIVO

Este documento define a arquitetura técnica de **Tico e a Floresta das Nozes**.

A arquitetura deverá permitir que o jogo seja desenvolvido uma única vez e distribuído como:

- aplicação Web;
- Progressive Web App — PWA;
- aplicativo Android, como plataforma adicional, sujeito à confirmação para o lançamento;
- aplicativo Windows.

A plataforma prioritária de distribuição será:

**WEB / PWA**

A plataforma prioritária de desenvolvimento será:

**WINDOWS**

O projeto deverá priorizar:

**SIMPLICIDADE**

**MODULARIDADE**

**REUTILIZAÇÃO**

**PORTABILIDADE**

**DESEMPENHO**

**FACILIDADE DE MANUTENÇÃO**

**FACILIDADE DE EXPANSÃO**

---

# 2. DECISÕES TÉCNICAS PRINCIPAIS

Stack inicial:

```text
ENGINE
Godot Engine 4

LINGUAGEM
GDScript

TIPO
Plataforma 2D Side-Scrolling

DISTRIBUIÇÃO PRINCIPAL
Web / PWA

DESENVOLVIMENTO
Windows

PLATAFORMAS ADICIONAIS
Android
Windows

ORIENTAÇÃO
Landscape

PROPORÇÃO
16:9

FPS ALVO
60 FPS

INPUTS
Teclado
Touchscreen
Gamepad (futuro, sujeito a validação)
```

---

# 3. ENGINE

Engine escolhida:

**Godot Engine 4**

Utilizar uma versão estável da linha Godot 4.

Não utilizar em produção versões:

- dev;
- alpha;
- beta;
- release candidate;

sem uma necessidade específica.

A versão exata utilizada pelo projeto deverá ser registrada no repositório.

Base inicial registrada na etapa 0: **Godot 4.7.2 stable, edição padrão, GDScript**.
O arquivo `.godot-version` registra a versão adotada. Utilizar o renderizador
**Compatibility**, compatível com a distribuição Web planejada.

Referências oficiais: [download Windows](https://godotengine.org/download/windows/)
e [exportação Web](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html).

---

# 4. LINGUAGEM

Linguagem principal:

**GDScript**

Motivos:

- integração direta com Godot;
- sintaxe simples;
- facilidade de manutenção;
- adequada para gameplay;
- rápida prototipação;
- integração com cenas e nós;
- adequada à estratégia de exportação Web.

A primeira versão não dependerá de C#.

---

# 5. FILOSOFIA MULTIPLATAFORMA

O jogo deverá possuir uma única base principal de código.

```text
                  PROJETO GODOT
                       │
                 GAMEPLAY ÚNICO
                       │
          ┌────────────┼────────────┐
          │            │            │
         WEB         ANDROID      WINDOWS
          │            │            │
         PWA         APK/AAB        EXE
```

Evitar manter versões independentes do jogo para cada plataforma.

Diferenças deverão ficar principalmente em:

- input;
- interface;
- exportação;
- configurações específicas;
- otimizações.

---

# 6. PLATAFORMA PRINCIPAL — WEB/PWA

A distribuição principal será através da Web.

Exemplo:

```text
https://jogar.tico.com.br
```

O jogador poderá:

1. acessar pelo navegador;
2. jogar diretamente;
3. instalar o PWA quando suportado;
4. acessar posteriormente pela tela inicial do dispositivo.

---

# 7. PROGRESSIVE WEB APP

O jogo deverá ser preparado para funcionar como:

**PWA — Progressive Web App**

Características desejadas:

- instalável;
- ícone próprio;
- abertura em modo standalone/fullscreen;
- orientação landscape;
- cache dos arquivos necessários;
- funcionamento offline quando possível;
- atualização controlada;
- armazenamento local do progresso.

---

# 8. PWA NÃO SERÁ OUTRO JOGO

Importante:

A lógica principal continuará sendo desenvolvida em:

**GODOT**

Não serão mantidos dois jogos:

```text
Godot
+
versão JavaScript separada
```

A estrutura será:

```text
Godot
   ↓
Exportação Web
   ↓
HTML + JavaScript + WebAssembly + dados
   ↓
PWA
```

HTML, JavaScript e arquivos auxiliares deverão servir principalmente como camada de execução/distribuição Web.

---

# 9. ARQUITETURA WEB

Estrutura conceitual:

```text
NAVEGADOR
    │
    ▼
index.html
    │
    ▼
Runtime Web
    │
    ├── JavaScript
    ├── WebAssembly
    ├── dados do jogo
    └── assets
          │
          ▼
      GODOT GAME
```

---

# 10. ARQUITETURA PWA

Conceitualmente:

```text
                    INTERNET
                        │
                        ▼
                 SERVIDOR HTTPS
                        │
                        ▼
                  APLICAÇÃO WEB
                        │
              ┌─────────┴─────────┐
              │                   │
           Manifest          Cache/Offline
              │                   │
              └─────────┬─────────┘
                        │
                        ▼
                       PWA
                        │
             ┌──────────┴──────────┐
             │                     │
         NAVEGADOR             INSTALADO
```

---

# 11. HOSPEDAGEM

A primeira versão não necessitará obrigatoriamente de VPS.

Poderá ser utilizada:

**HOSPEDAGEM COMPARTILHADA**

desde que ofereça os recursos necessários à exportação Web utilizada.

Requisitos básicos:

- HTTPS;
- suporte aos tipos de arquivos utilizados;
- configuração adequada de MIME types;
- armazenamento suficiente;
- largura de banda adequada.

---

# 12. HTTPS

A versão PWA deverá ser publicada através de:

**HTTPS**

Exemplo:

```text
https://jogar.tico.com.br
```

Evitar:

```text
http://jogar.tico.com.br
```

HTTPS deverá ser tratado como requisito da implantação Web/PWA.

---

# 13. VPS

Uma VPS poderá ser utilizada futuramente, mas não será requisito inicial.

Poderá tornar-se interessante se o projeto passar a possuir:

- API;
- autenticação;
- contas;
- sincronização;
- ranking;
- painel administrativo;
- serviços online;
- banco de dados;
- telemetria própria.

Para o primeiro protótipo:

**BACKEND NÃO É NECESSÁRIO.**

---

# 14. FUNCIONAMENTO OFFLINE

O PWA deverá buscar permitir que o jogo continue funcionando após os arquivos necessários terem sido armazenados localmente.

Fluxo desejado:

```text
PRIMEIRO ACESSO
      │
      ▼
DOWNLOAD DO JOGO
      │
      ▼
CACHE LOCAL
      │
      ▼
INSTALAÇÃO PWA
      │
      ▼
PRÓXIMAS EXECUÇÕES
      │
      ├── ONLINE
      │
      └── OFFLINE
```

O funcionamento offline deverá ser validado durante os testes.

---

# 15. ATUALIZAÇÃO DO PWA

Quando uma nova versão for publicada:

```text
Servidor
   │
   ▼
Nova versão
   │
   ▼
PWA detecta atualização
   │
   ▼
novos arquivos são obtidos
   │
   ▼
nova versão passa a ser utilizada
```

A atualização não deverá apagar o progresso salvo do jogador.

---

# 16. VERSIONAMENTO DO JOGO

Cada build deverá possuir uma versão.

Exemplo:

```text
0.1.0
0.2.0
0.3.0
0.4.0
1.0.0
```

O save também deverá possuir versão própria.

Exemplo:

```text
save_version = 1
```

---

# 17. PLATAFORMA ANDROID

Além do PWA, o projeto poderá gerar versão nativa Android.

Formatos:

```text
APK
AAB
```

APK:

adequado para testes e instalação direta.

AAB:

adequado para distribuição em lojas que utilizem esse formato.

---

# 18. PLATAFORMA WINDOWS

O projeto também poderá gerar versão desktop.

Exemplo:

```text
TicoFloresta.exe
```

O usuário não precisará instalar Godot.

---

# 19. PRIORIDADES DE DISTRIBUIÇÃO

## PRIORIDADE 1

Web/PWA.

## PRIORIDADE 2

Android.

## PRIORIDADE 3

Windows distribuível.

A versão Windows continuará sendo importante durante desenvolvimento e testes.

---

# 20. ORIENTAÇÃO

Orientação principal:

**LANDSCAPE**

O jogo não será projetado inicialmente para gameplay vertical.

---

# 21. PROPORÇÃO

Proporção principal:

**16:9**

Exemplos:

```text
1920 × 1080
1280 × 720
```

O layout deverá adaptar-se a diferentes dimensões de tela sem comprometer o gameplay.

---

# 22. RESOLUÇÃO INTERNA

A resolução lógica definitiva deverá ser validada juntamente com a direção artística.

Para abrir e executar o projeto na etapa 0, a configuração provisória é
**1280 × 720**, orientação landscape e stretch `canvas_items` com aspecto `expand`.
A proporção de referência continua 16:9; a área visível pode crescer em outras telas.
Essa configuração não define a resolução final da arte nem substitui testes de UI.

A arquitetura deverá separar:

**RESOLUÇÃO INTERNA DO JOGO**

de:

**RESOLUÇÃO FÍSICA DA TELA**

Isso permitirá executar o jogo em dispositivos diferentes.

---

# 23. SAFE AREA

A interface deverá considerar áreas seguras.

Elementos importantes não deverão ficar excessivamente próximos das bordas.

Especialmente:

- corações;
- contador de nozes;
- botões touch;
- pausa;
- indicador de personagem.

---

# 24. TOUCHSCREEN

Touchscreen passa a ser requisito arquitetural desde o início.

O jogo deverá ser utilizável em:

- smartphone;
- tablet;
- dispositivos touchscreen compatíveis.

---

# 25. INPUT ABSTRATO

A lógica nunca deverá depender diretamente de:

```text
tecla Espaço
```

ou:

```text
botão da tela
```

Ela deverá depender de ações.

Exemplo:

```text
move_left
move_right
jump
action
switch_character
pause
```

---

# 26. INPUT MAP

Godot Input Map deverá representar essas ações.

Exemplo:

```text
ACTION             TECLADO       TOUCH       GAMEPAD

move_left          A / ←          ◀           Stick/D-pad
move_right         D / →          ▶           Stick/D-pad
jump               Espaço         Jump        Botão
action             E              Action      Botão
switch_character   Q              Switch      Shoulder
pause              Esc            Pause       Start
```

Os mapeamentos são provisórios.

---

# 27. CAMADA DE INPUT

Arquitetura:

```text
            INPUT
              │
    ┌─────────┼─────────┐
    │         │         │
 TECLADO    TOUCH    GAMEPAD
    │         │         │
    └─────────┼─────────┘
              │
              ▼
          INPUT MAP
              │
              ▼
          GAMEPLAY
```

O personagem não deverá precisar saber qual dispositivo gerou o comando.

---

# 28. CONTROLES TOUCH

Layout inicial conceitual:

```text
┌─────────────────────────────────────────────┐
│ ♥ ♥ ♥                              🌰 × 25 │
│                                             │
│                                             │
│                                             │
│                                             │
│                                             │
│   ◀   ▶                         AÇÃO   PULO │
│                                TROCAR       │
└─────────────────────────────────────────────┘
```

A posição e quantidade definitiva de botões será validada em testes.

---

# 29. PRINCÍPIO DOS CONTROLES TOUCH

Evitar excesso de botões.

Objetivo:

**POUCOS CONTROLES + MUITAS POSSIBILIDADES**

Sempre que possível, uma mesma ação contextual poderá ser utilizada em situações diferentes.

---

# 30. PLANAR NO TOUCH

O planar de Tico deverá evitar exigir um botão adicional.

Solução preferencial a ser testada:

```text
PULAR
  │
  ▼
Tico está no ar?
  │
  ├── não → salto
  │
  └── sim + botão mantido → planar
```

Assim:

**PULO + SEGURAR = PLANAR**

Isso reduz o número de controles.

---

# 31. PIPO NO TOUCH

Da mesma forma, a ação de Pipo deverá ser contextual quando possível.

Exemplo:

```text
ACTION
   │
   ├── obstáculo pesado → empurrar
   ├── situação de investida → carregar/investir
   └── elemento especial → interagir
```

A solução definitiva será validada através de protótipos.

---

# 32. BOTÕES TOUCH

Botões deverão:

- possuir área confortável;
- ser visualmente claros;
- possuir transparência adequada;
- não esconder gameplay importante;
- fornecer feedback ao toque.

---

# 33. TECLADO

Durante o desenvolvimento, teclado será o método principal.

Ações iniciais:

```text
A / ←       esquerda
D / →       direita
Espaço      pulo
E           ação
Q           trocar personagem
Esc         pausa
```

---

# 34. GAMEPAD

O projeto deverá permitir posteriormente mapear as mesmas ações para gamepad.

Não deverá ser necessária alteração da lógica de gameplay.

---

# 35. DETECÇÃO DO DISPOSITIVO

A interface poderá adaptar os controles conforme o ambiente.

Exemplo:

Desktop:

```text
HUD
+
sem controles touch
```

Mobile:

```text
HUD
+
controles touch
```

---

# 36. ENGINE 2D

O jogo utilizará os recursos 2D da Godot.

Principais sistemas:

- CharacterBody2D;
- CollisionShape2D;
- Area2D;
- TileMap/TileSet;
- AnimatedSprite2D;
- AnimationPlayer;
- Camera2D;
- partículas 2D;
- áudio.

---

# 37. PERSONAGENS

Cenas:

```text
tico.tscn
pipo.tscn
```

Scripts:

```text
tico.gd
pipo.gd
```

Raiz recomendada:

`CharacterBody2D`

---

# 38. TICO

Implementação da etapa 2: `scenes/characters/tico.tscn` e
`scripts/characters/tico.gd`. Nesta etapa existem o corpo físico, a colisão
e o `AnimatedSprite2D`, com estados idle, run, jump, fall, glide e land.
Dano, hurtbox e interações ainda pertencem às etapas posteriores.
O Inspector expõe os parâmetros de movimento, salto e planar.

O playground atual fica em `scenes/levels/tico_playground.tscn`. A câmera
reutilizável está em `scripts/systems/follow_camera.gd`; pausa e reinício do
playground ficam em `scripts/systems/tico_playground.gd`. A cena de teste
da fundação técnica foi preservada separadamente.

Estrutura conceitual:

```text
Tico
├── AnimatedSprite2D
├── CollisionShape2D
├── Hurtbox
├── InteractionArea
└── Effects
```

Responsabilidades:

- movimento;
- salto;
- queda;
- planar;
- dano;
- invulnerabilidade;
- estados.

---

# 39. PIPO

Estrutura:

```text
Pipo
├── AnimatedSprite2D
├── CollisionShape2D
├── Hurtbox
├── InteractionArea
├── ChargeArea
└── SniffArea
```

Responsabilidades:

- movimento;
- salto;
- empurrar;
- investida;
- faro;
- dano;
- estados.

---

# 40. CHARACTER MANAGER

Criar:

`character_manager.gd`

Responsabilidades:

- personagem ativo;
- troca Tico/Pipo;
- ativação de input;
- atualização da câmera;
- comunicação com HUD.

---

# 41. PERSONAGEM INATIVO

Inicialmente:

- permanece parado;
- executa idle;
- não recebe comandos.

Posteriormente poderá:

- acompanhar;
- reagir;
- reposicionar-se;
- executar comportamentos simples.

Não criar IA complexa antes de existir necessidade.

---

# 42. COMPONENTIZAÇÃO

Funcionalidades reutilizáveis poderão ser componentes.

Exemplos:

```text
HealthComponent
HitboxComponent
HurtboxComponent
InteractionComponent
CollectableComponent
```

---

# 43. VIDA

`health_component.gd`

Responsabilidades:

- vida máxima;
- vida atual;
- dano;
- cura;
- derrota;
- signals.

O mesmo componente poderá ser utilizado por diferentes personagens.

---

# 44. HITBOX E HURTBOX

Separação:

```text
HITBOX
causa dano

HURTBOX
recebe dano
```

Isso facilitará reutilização em personagens, inimigos e chefes.

---

# 45. ESTADOS

Tico:

```text
IDLE
RUN
JUMP
FALL
GLIDE
HURT
DISABLED
```

Pipo:

```text
IDLE
RUN
JUMP
FALL
PUSH
CHARGE
SNIFF
HURT
DISABLED
```

Máquina de estados dedicada somente será criada se a complexidade justificar.

---

# 46. FÍSICA

Utilizar nós adequados conforme comportamento.

Exemplos:

```text
CharacterBody2D
StaticBody2D
AnimatableBody2D
RigidBody2D
Area2D
```

Priorizar comportamento previsível.

Especialmente porque o jogo é infantil.

---

# 47. COLISÕES

Planejamento conceitual:

```text
1  World
2  Player
3  Enemy
4  PlayerHitbox
5  EnemyHitbox
6  Collectable
7  Interactable
8  Hazard
9  Trigger
10 Special
```

A configuração definitiva deverá ser registrada durante implementação.

Na etapa 1, essas dez camadas foram nomeadas em `project.godot`. A geometria
usa a camada World (1), sem máscara de detecção; o corpo de teste usa Player
(2) e detecta World (máscara 1). Grupos iniciais: `world`, `player` e
`spawn_points`. Física: 60 ticks/s e gravidade provisória de 1200 px/s².
Os parâmetros de Tico serão definidos na etapa 2.

---

# 48. ESTRUTURA DAS FASES

Cada fase será uma cena independente.

Exemplo:

```text
scenes/
└── levels/
    ├── world_01/
    │   ├── level_01_01.tscn
    │   ├── level_01_02.tscn
    │   └── level_01_03.tscn
    │
    ├── world_02/
    ├── world_03/
    ├── world_04/
    └── world_05/
```

---

# 49. ESTRUTURA INTERNA DA FASE

```text
Level
├── Background
├── Parallax
├── TileMap
├── Objects
├── Enemies
├── Items
├── Checkpoints
├── Triggers
├── PlayerSpawn
└── LevelExit
```

---

# 50. TILEMAP E CENAS

Utilizar tiles para elementos repetitivos.

Exemplos:

- terreno;
- parede;
- plataforma;
- vegetação estrutural.

Utilizar cenas para objetos com comportamento.

Exemplos:

- noz;
- inimigo;
- bloco;
- checkpoint;
- mecanismo;
- saída.

---

# 51. CÂMERA

Criar sistema reutilizável.

Responsabilidades:

- seguir jogador;
- suavizar movimento;
- respeitar limites;
- trocar entre Tico/Pipo;
- favorecer direção do movimento.

A câmera deverá ser testada também em telas pequenas.

---

# 52. INIMIGOS

Criar base comum quando a repetição justificar.

Exemplo:

`enemy_base.gd`

Responsabilidades compartilhadas:

- vida;
- dano;
- direção;
- derrota.

IA deverá permanecer simples e previsível.

---

# 53. PRIMEIRO INIMIGO

Primeiro inimigo:

**LESMA**

Comportamento:

```text
ANDAR
  ↓
DETECTAR OBSTÁCULO
  ↓
VIRAR
  ↓
CONTINUAR
```

Esse inimigo será utilizado para validar:

- colisão;
- dano;
- pisão;
- animação;
- derrota.

---

# 54. OBJETOS

Cenas independentes:

```text
breakable_block.tscn
heavy_block.tscn
pushable_object.tscn
pressure_switch.tscn
moving_platform.tscn
checkpoint.tscn
level_exit.tscn
```

---

# 55. COLETÁVEIS

Base:

`collectable.gd`

Especializações:

```text
nut.tscn
golden_nut.tscn
special_nut.tscn
```

Fluxo:

```text
Player
  ↓
Collectable
  ↓
GameState
  ↓
HUD
```

---

# 56. SIGNALS

Preferir signals para comunicação desacoplada.

Exemplos:

```text
nut_collected
health_changed
player_damaged
checkpoint_reached
character_changed
level_completed
```

---

# 57. GAME STATE

`game_state.gd`

Poderá armazenar:

- mundo;
- fase;
- personagem ativo;
- nozes;
- checkpoint;
- estado temporário da sessão.

Evitar transformá-lo em depósito indiscriminado de variáveis.

---

# 58. AUTOLOADS

Autoloads iniciais possíveis:

```text
GameManager
SaveManager
AudioManager
SceneManager
```

Criar somente os realmente necessários.

---

# 59. GAME MANAGER

Responsabilidades:

- fluxo da partida;
- estado global necessário;
- reinício;
- conclusão;
- respawn.

Não controlar diretamente movimentação dos personagens.

---

# 60. SCENE MANAGER

Responsabilidades:

- menu;
- carregar fase;
- trocar fase;
- reiniciar fase;
- transições.

---

# 61. CHECKPOINT

Fluxo:

```text
Player
   ↓
Checkpoint
   ↓
GameManager
   ↓
registra retorno
```

Em caso de derrota:

```text
Derrota
   ↓
Transição
   ↓
Respawn
   ↓
Último checkpoint
```

---

# 62. SAVE

Sistema:

`save_manager.gd`

Dados previstos para a progressão entre mundos e fases:

```text
save_version
current_world
unlocked_levels
completed_levels
special_collectables
settings
```

Na etapa 6, há uma única fase: o formato implementado v1 registra `level`,
personagem, IDs de itens/blocos, pedra, portão, parede, segredo, checkpoint e
conclusão. O esquema acima será introduzido conforme esses sistemas existirem,
com migração explícita. Detalhes: [save do protótipo](../tests/etapa_6.md).

---

# 63. SAVE NO PWA

Na versão Web/PWA, o save será armazenado localmente através dos mecanismos disponibilizados pelo ambiente Web da engine/navegador.

Implementação da etapa 6: `localStorage` via `JavaScriptBridge`, com escrita
síncrona e tratamento de erros. No Windows, JSON em `user://progress.json`,
gravado primeiro em arquivo temporário. O worker de atualização não remove
o save; a retomada é automática no ponto seguro. Ver DEC-111.

Objetivo:

```text
PWA
 │
 ├── progresso
 ├── configurações
 └── conquistas locais
       │
       ▼
 armazenamento local
```

Não será necessário banco de dados na primeira versão.

---

# 64. LIMITAÇÃO DO SAVE LOCAL

O progresso local pertence ao navegador/dispositivo.

Inicialmente não haverá garantia de sincronização automática entre:

```text
celular
tablet
computador
```

Exemplo:

progresso feito no celular não necessariamente aparecerá no computador.

---

# 65. SINCRONIZAÇÃO FUTURA

Caso futuramente seja necessário:

```text
Usuário
   ↓
Conta
   ↓
API
   ↓
Banco de dados
   ↓
Save na nuvem
```

Essa funcionalidade deverá ser implementada como expansão.

Não faz parte do MVP.

---

# 66. PROTEÇÃO DO SAVE

Atualizações do PWA não deverão apagar propositalmente:

- progresso;
- configurações;
- dados locais.

Mudanças de formato deverão considerar:

`save_version`

e migração quando necessária.

---

# 67. ÁUDIO

Criar:

`audio_manager.gd`

Buses:

```text
Master
Music
SFX
UI
```

Configurações:

- volume geral;
- música;
- efeitos.

---

# 68. RESTRIÇÕES DE ÁUDIO NA WEB

A versão Web deverá considerar regras dos navegadores relacionadas à reprodução automática.

O áudio poderá precisar começar somente depois da primeira interação do usuário.

Exemplo:

```text
TELA INICIAL

      JOGAR

primeiro toque/clique
        ↓
áudio liberado
        ↓
jogo começa
```

A tela inicial deverá ser compatível com esse comportamento.

---

# 69. HUD

Cena:

`hud.tscn`

Informações principais:

- corações;
- nozes;
- personagem ativo;
- mensagens.

No mobile:

HUD deverá coexistir com controles touch sem poluir a tela.

---

# 70. RESPONSIVIDADE DA INTERFACE

A UI deverá utilizar:

- anchors;
- containers;
- margens;
- tamanhos adequados.

Evitar posicionamento rígido baseado apenas em coordenadas absolutas.

---

# 71. MENUS

Cenas:

```text
main_menu.tscn
pause_menu.tscn
settings_menu.tscn
level_complete.tscn
```

---

# 72. MENU PRINCIPAL

Estrutura inicial:

```text
TICO E A FLORESTA DAS NOZES

        JOGAR

      CONTINUAR

       OPÇÕES
```

Quando instalado como PWA, a experiência deverá se aproximar de um aplicativo normal.

---

# 73. PAUSA

Botão de pausa deverá existir também na interface touch.

A pausa deverá interromper gameplay, mantendo o menu funcional.

---

# 74. EVENTOS DO NAVEGADOR

A versão Web deverá considerar situações como:

- mudança de aba;
- navegador minimizado;
- perda de foco;
- celular bloqueado.

Quando apropriado, o jogo deverá pausar ou evitar continuar uma ação crítica sem o jogador.

---

# 75. ANIMAÇÕES

Inicialmente:

`AnimatedSprite2D`

Quando necessário:

`AnimationPlayer`

Posteriormente:

`AnimationTree`

somente se a complexidade justificar.

---

# 76. EFEITOS

Poderão ser utilizados:

- GPUParticles2D;
- sprites;
- animações;
- shaders simples.

Considerar desempenho Web/mobile.

Evitar efeitos pesados sem necessidade.

---

# 77. PERFORMANCE WEB

A versão Web deverá ser testada continuamente.

Cuidados:

- tamanho dos assets;
- quantidade de texturas;
- memória;
- partículas;
- quantidade de objetos;
- scripts executados por frame;
- áudio;
- tempo de carregamento.

---

# 78. TAMANHO DO DOWNLOAD

Como o jogo será acessado pela Web, o tamanho inicial é importante.

Evitar assets desnecessariamente grandes.

Priorizar:

- compressão;
- reutilização;
- spritesheets;
- áudio adequado;
- texturas no tamanho necessário.

---

# 79. TELA DE CARREGAMENTO

O PWA deverá possuir feedback durante carregamento.

Exemplo:

```text
TICO E A FLORESTA DAS NOZES

        🌰

    Carregando...
```

O jogador nunca deverá ficar diante de uma tela aparentemente travada.

---

# 80. CACHE

O cache deverá reduzir downloads repetidos.

Objetivo:

```text
1º acesso
████████████████ download

2º acesso
██ carregamento local
```

A estratégia definitiva dependerá da exportação Web/PWA utilizada.

---

# 81. INTERNET DURANTE GAMEPLAY

O gameplay principal não deverá exigir conexão contínua.

Objetivo:

```text
INTERNET
necessária principalmente para:

primeiro acesso
+
atualizações
```

Depois que os recursos necessários estiverem disponíveis localmente, o jogo deverá buscar funcionar sem depender continuamente do servidor.

---

# 82. SEM BACKEND NO MVP

O MVP não terá:

- login;
- cadastro;
- API;
- banco de dados;
- ranking online;
- chat;
- multiplayer;
- sincronização em nuvem.

Isso reduz muito a complexidade.

---

# 83. SEGURANÇA WEB

Como o jogo inicial será essencialmente cliente, nenhuma informação sensível deverá ser armazenada nele.

Não incluir:

- senhas;
- chaves privadas;
- credenciais de servidor;
- tokens administrativos.

Tudo enviado ao navegador deverá ser considerado acessível ao usuário.

---

# 84. ESTRUTURA DE DIRETÓRIOS

```text
jogo-esquilo/
│
├── project.godot
├── README.md
│
├── arquivos_projeto/
├── img/                     # pranchas de referência, fora do runtime
│
├── assets/
│   ├── characters/
│   ├── enemies/
│   ├── environments/
│   ├── items/
│   ├── objects/
│   ├── ui/
│   ├── effects/
│   ├── audio/
│   │   ├── music/
│   │   └── sfx/
│   └── fonts/
│
├── scenes/
│   ├── characters/
│   ├── enemies/
│   ├── levels/
│   ├── objects/
│   ├── items/
│   ├── ui/
│   └── effects/
│
├── scripts/
│   ├── characters/
│   ├── enemies/
│   ├── objects/
│   ├── systems/
│   ├── ui/
│   └── utils/
│
├── data/
│
├── web/
│   ├── icons/
│   └── custom/
│
├── tests/
│
└── builds/
```

---

# 85. PASTA WEB

`web/`

armazenará apenas recursos específicos da distribuição Web/PWA que realmente sejam necessários.

Exemplo:

```text
web/
├── icons/
│   ├── icon-192.png
│   └── icon-512.png
│
└── custom/
```

Evitar duplicar assets do jogo.

---

# 86. DOCUMENTAÇÃO

```text
arquivos_projeto/
├── 01_visao-geral.md
├── 02_requisitos.md
├── 03_gameplay.md
├── 04_personagens.md
├── 05_fases-e-mundos.md
├── 06_direcao-visual.md
├── 07_arquitetura-tecnica.md
├── 08_roadmap.md
├── 09_historia-e-narrativa.md
├── 10_testes.md
├── 11_decisoes.md
└── 12_status-do-projeto.md
```

---

# 87. DADOS CONFIGURÁVEIS

Valores importantes deverão ser configuráveis.

Exemplo:

```gdscript
@export var move_speed: float
@export var jump_velocity: float
@export var acceleration: float
```

Isso permitirá ajuste rápido através do Inspector.

---

# 88. NOMENCLATURA

Arquivos:

`snake_case`

Exemplo:

```text
tico.gd
pipo.gd
moving_platform.gd
level_01_01.tscn
```

Classes:

`PascalCase`

Variáveis:

`snake_case`

Constantes:

`UPPER_SNAKE_CASE`

---

# 89. GIT

Utilizar Git desde o início.

Branch principal:

`main`

Branches opcionais:

```text
feature/tico-movement
feature/touch-controls
feature/pipo
feature/pwa-export
feature/checkpoint
```

---

# 90. BUILDS

Separar builds por plataforma.

Exemplo:

```text
builds/
├── web/
│   └── prototype_0.1/
│
├── android/
│   └── prototype_0.1.apk
│
└── windows/
    └── prototype_0.1/
```

Builds normalmente não deverão ser versionados no Git.

---

# 91. AMBIENTES

Poderemos considerar:

```text
DESENVOLVIMENTO

TESTE

PRODUÇÃO
```

Inicialmente desenvolvimento e produção simples serão suficientes.

Posteriormente poderá existir:

```text
dev.jogar.tico.com.br

jogar.tico.com.br
```

---

# 92. TESTE WEB LOCAL

Durante desenvolvimento, a versão Web deverá ser testada através de servidor HTTP adequado.

Não assumir que abrir diretamente:

```text
file://index.html
```

representa corretamente o ambiente final.

---

# 93. TESTES MULTIPLATAFORMA

O protótipo deverá ser testado em:

### WINDOWS

- teclado;
- diferentes resoluções.

### WEB DESKTOP

- navegador;
- fullscreen;
- áudio;
- save.

### ANDROID WEB/PWA

- touchscreen;
- landscape;
- instalação;
- save;
- desempenho;
- offline.

### ANDROID NATIVO

Posteriormente:

- APK;
- touchscreen;
- desempenho.

---

# 94. NAVEGADORES

Os testes Web deverão incluir pelo menos navegadores modernos relevantes.

Prioridade inicial:

- Chrome/Chromium desktop;
- Chrome Android.

Posteriormente:

- Edge;
- Firefox;
- Safari, caso a plataforma passe a fazer parte do escopo.

---

# 95. MARCO 1 — TICO PLAYGROUND

Corresponde ao marco 1 do roadmap, após a preparação da etapa 0 e a fundação da etapa 1.

Validar Tico controlável, movimento, salto, planar, colisões e câmera no Windows.
A cena vazia da etapa 0 é apenas a verificação do ambiente.

---

# 96. MARCO 2 — TICO PWA

Subpassos técnicos do mesmo marco:

1. Exportar a cena jogável para Web.
2. Validar carregamento, execução e desempenho no navegador desktop.
3. Adicionar controles touch e testar em celular Android, em landscape.
4. Validar instalação PWA, reabertura e funcionamento offline básico.

Web, touch e instalação são subpassos; não recebem numeração de marcos própria.

---

# 97. MARCO 3 — TICO MINI GAME

Adicionar nozes, lesma, dano, blocos, HUD, checkpoint e final de fase.
Validar um ciclo completo de jogo, incluindo retorno após falha.

---

# 98. MARCO 4 — TICO + PIPO

Adicionar Pipo, força, investida, faro, troca e um desafio cooperativo.
Validar câmera, personagem inativo e controles tanto no teclado quanto no touch.

A etapa 6 do roadmap integra o protótipo completo: uma fase com a dupla,
coletáveis, inimigo, obstáculos, checkpoint, final e save local.
Esse protótipo consolida os marcos anteriores antes do vertical slice.

---

# 99. MARCO 5 — VERTICAL SLICE

Produzir uma pequena seção representativa da qualidade final de gameplay,
arte, animações, áudio, interface e desempenho. Validar em Windows e Web/PWA.

O MVP já reúne uma fase funcional e os sistemas mínimos. O vertical slice
valida o padrão de qualidade para produzir o restante do jogo.

---

# 100. MARCO 6 — MUNDO 1 COMPLETO

Concluir as três fases do Bosque das Folhas, sua progressão e narrativa.
Incluir o chefe se confirmado no escopo. Validar save e playtest completo.

---

# 101. MARCO 7 — JOGO COMPLETO

Integrar os cinco mundos e as 15 fases principais, com a história completa
até a resolução com Mestre Corvo. A quantidade de chefes permanece sujeita
à validação do escopo. Este marco antecede o polimento e a publicação.

---

# 102. MARCO 8 — VERSÃO 1.0

Concluir polimento, testes e publicação de Web/PWA e Windows.
Android nativo será incluído somente se confirmado para o lançamento.
A comparação com APK é uma validação adicional quando houver build nativo;
não é requisito do MVP Web/PWA.

Os nomes e números dos marcos seguem `08_roadmap.md`, `10_testes.md` e
`11_decisoes.md`. Etapas são conjuntos de trabalho; marcos são resultados
validados. A etapa 0 não é o marco 1.

---
# 103. VERTICAL SLICE

Após validar a arquitetura:

criar pequena seção próxima da qualidade final.

Deverá possuir:

- Tico final/provisório avançado;
- Pipo;
- cenário;
- animações;
- áudio;
- efeitos;
- interface;
- touchscreen;
- PWA.

Esse será um importante teste da experiência real.

---

# 104. NÃO SUPERARQUITETAR

Não criar antecipadamente:

- backend;
- contas;
- multiplayer;
- banco de dados;
- microserviços;
- sincronização;
- analytics complexo;
- IA avançada;
- editor próprio;
- sistemas genéricos sem uso.

Primeiro:

**JOGO FUNCIONANDO.**

---

# 105. OTIMIZAÇÃO

Fluxo:

```text
IMPLEMENTAR
     ↓
TESTAR WINDOWS
     ↓
TESTAR WEB
     ↓
TESTAR CELULAR
     ↓
MEDIR
     ↓
OTIMIZAR
```

O celular/PWA será parte dos testes de desempenho desde cedo.

---

# 106. REGRA PARA DEPENDÊNCIAS

Antes de adicionar plugin ou biblioteca:

1. é necessário?
2. Godot já resolve?
3. funciona em Web?
4. funciona em Android?
5. funciona em Windows?
6. possui licença adequada?
7. está sendo mantido?

Compatibilidade Web passa a ser requisito importante.

---

# 107. REGRA PARA NOVAS FUNCIONALIDADES

Antes de implementar uma nova funcionalidade:

1. funciona no desktop?
2. funciona no navegador?
3. funciona com touchscreen?
4. funciona em landscape?
5. prejudica desempenho mobile?
6. aumenta muito o download?
7. funciona offline?
8. interfere no save?
9. exige backend?
10. é realmente necessária?

---

# 108. PRINCÍPIO DE PORTABILIDADE

Código de gameplay não deverá possuir lógica como:

```text
SE ANDROID
   pular
SENÃO
   outro pulo
```

O comportamento deverá ser:

```text
INPUT
   ↓
ACTION: JUMP
   ↓
TICO PULA
```

A origem do comando não importa para Tico.

---

# 109. ARQUITETURA RESUMIDA

```text
                         INTERNET
                            │
                      HTTPS SERVER
                            │
                            ▼
                         WEB/PWA
                            │
                            ▼
                      GODOT RUNTIME
                            │
              ┌─────────────┼─────────────┐
              │             │             │
            INPUT          GAME          SAVE
              │             │             │
      ┌───────┼───────┐     │        Local Storage
      │       │       │      │
  Keyboard  Touch  Gamepad   │
              │              │
              └──────┬───────┘
                     │
                     ▼
                 GAMEPLAY
                     │
         ┌───────────┼───────────┐
         │           │           │
       TICO         PIPO       WORLD
         │           │           │
         └───────────┼───────────┘
                     │
                COMPONENTS
                     │
                  SIGNALS
                     │
         ┌───────────┼───────────┐
         │           │           │
        HUD        AUDIO       MANAGERS
```

---

# 110. ARQUITETURA DE DISTRIBUIÇÃO

```text
                       SOURCE
                         │
                    GODOT PROJECT
                         │
            ┌────────────┼────────────┐
            │            │            │
        WEB EXPORT    ANDROID      WINDOWS
            │          EXPORT       EXPORT
            │            │            │
           PWA        APK/AAB        EXE
            │
     ┌──────┴──────┐
     │             │
 Navegador     Instalado
```

---

# 111. PRIMEIRO OBJETIVO REAL

O primeiro objetivo técnico continua sendo simples:

**COLOCAR TICO EM UMA FASE E FAZER O MOVIMENTO SER DIVERTIDO.**

Depois:

```text
Tico anda
   ↓
Tico pula
   ↓
Tico coleta
   ↓
Tico enfrenta inimigo
   ↓
Pipo aparece
   ↓
Tico + Pipo cooperam
```

Em paralelo:

```text
Windows
   ↓
Web
   ↓
Touch
   ↓
PWA
   ↓
Offline
```

Assim, plataforma e gameplay evoluem juntos.

---

# 112. DEFINIÇÃO DO MVP TÉCNICO

O MVP técnico estará concluído quando existir:

- Tico controlável;
- Pipo controlável;
- troca entre personagens;
- uma fase;
- uma lesma;
- nozes;
- blocos;
- obstáculo de Pipo;
- checkpoint;
- HUD;
- áudio básico;
- save;
- teclado;
- touchscreen;
- build Windows;
- build Web;
- PWA instalável;
- funcionamento básico offline.

Não será necessário para o MVP:

- conta;
- login;
- servidor;
- banco de dados;
- sincronização em nuvem.

---

# 113. RESULTADO ESPERADO

Ao final da primeira etapa técnica deverá ser possível enviar para alguém:

```text
https://jogar.tico.com.br
```

A pessoa deverá poder:

```text
ABRIR
  ↓
JOGAR
  ↓
INSTALAR
  ↓
FECHAR
  ↓
ABRIR NOVAMENTE
  ↓
CONTINUAR
```

Sem instalar Godot.

Sem configurar servidor local.

Sem criar conta.

---

# 114. PRINCÍPIO FINAL

A arquitetura de **Tico e a Floresta das Nozes** deverá permitir que a mesma aventura acompanhe o jogador em diferentes plataformas.

No computador:

**ABRE O SITE E JOGA.**

No celular:

**ABRE O SITE E JOGA.**

Se desejar:

**INSTALA COMO PWA.**

Se futuramente preferir:

**INSTALA O APK.**

No Windows:

**EXECUTA A VERSÃO DESKTOP.**

Tudo utilizando essencialmente:

**UMA BASE DE JOGO**

**UMA BASE DE GAMEPLAY**

**UMA ARQUITETURA**

O objetivo técnico permanece subordinado ao objetivo principal:

**FAZER UM JOGO INFANTIL DIVERTIDO, SIMPLES DE ACESSAR E FÁCIL DE JOGAR.**

---

**FIM DO DOCUMENTO**
