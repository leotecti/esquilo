# Tico e a Floresta das Nozes

Jogo de plataforma 2D para crianÃ§as, sobre exploraÃ§Ã£o, amizade e cooperaÃ§Ã£o
entre Tico, um esquilo Ã¡gil, e Pipo, um porquinho forte de camisa verde.

Para configurar outra mÃ¡quina apÃ³s clonar o repositÃ³rio, consulte o
[guia de desenvolvimento e builds](DESENVOLVIMENTO.md).

## Estado atual

**Correção visual da Galeria (0.36.9):** a área secundária de 1-2 voltou a
desenhar o solo e os degraus da Galeria das Pedras. Os trechos opcionais usam
coordenadas locais para evitar descarte do desenho distante pelo renderizador.

**Correção visual da Copa (0.36.7):** o piso da área secundária de 1-1 voltou a
ser desenhado por um trecho estático próprio. A colisão existente foi preservada
e a correção mantém a divisão visual usada para desempenho em celulares.

**Estrutura de Pipo no Mundo 2 (0.36.6):** a fase 2-1 combina resistência à
correnteza com um tronco que Pipo precisa empurrar; 2-2 usa plataformas de peso
e balsas; 2-3 reúne besouros blindados e transporte de provisões. No Guardião do
Rio, Pipo rompe a defesa e Tico completa cada abertura com um salto.

**Transporte de objetos (0.36.5):** Pipo pode levar cestos de provisões nas três
fases de percurso do Mundo 2. Carregar reduz sua velocidade, impede salto e troca,
permite soltar e recolher e exige entrega em uma marca visível.
[Implementação e testes](tests/pipo_transport.md).

**Mola de peso e vento (0.37.0):** na fase 2-1, Pipo resiste às rajadas e usa
uma mola artesanal para alcançar a plataforma alta sobre o rio. Tico é leve
demais para obter o mesmo impulso, e a travessia não possui rota alternativa.
[Implementação e testes](tests/pipo_weight_launch.md).

**Plataformas de peso (0.36.4):** as três fases de percurso do Mundo 2
receberam plataformas ativadas pelo peso de Pipo. A interação inicial de 2-1
foi posteriormente substituída pela mola descrita acima.

**Inimigos blindados (0.36.3):** besouros protegidos no Mundo 2 bloqueiam pisão
e caudada até Pipo quebrar a carapaça com sua investida. Depois da abertura,
qualquer personagem pode finalizar o encontro. [Implementação e testes](tests/armored_enemy.md).

**Resistência de Pipo (0.36.2):** seu peso agora reduz recuo de golpes, vento e
correntezas. O Mundo 2 possui faixas caminháveis de água corrente para aplicar
essa vantagem durante a expansão das fases. [Implementação e testes](tests/pipo_resistance.md).

**Porte visual de Pipo (0.36.1):** Pipo agora aparece cerca de 29% mais alto
que Tico durante a partida e também é maior no mapa. Corrida, preparação,
investida e empurrão preservam a nova proporção, enquanto a colisão aprovada
permanece igual. [Implementação e testes](tests/pipo_visual_size.md).

**Fase 1-4 ampliada (0.36.0):** Periquito do Bosque agora possui uma jornada de
38.000 unidades, encontros variados, alimentos, blocos e o Refúgio da Cachoeira.
A passagem secundária retorna perto da bandeira e a arena do chefe encerra a
fase. [Estrutura e validação](tests/fase_1_4_expansao.md).

**ValidaÃ§Ã£o intermediÃ¡ria 2 â€” aventura completa em miniatura (0.25.0):** o
Mundo 1 agora Ã© a referÃªncia integrada da campanha, da abertura ao chefe e Ã 
prÃ³xima pista de Valda. Mapa, trÃªs fases, copa opcional, coletÃ¡veis, Pipo,
progressÃ£o e Save V2 foram validados em um fluxo contÃ­nuo.
[RelatÃ³rio da validaÃ§Ã£o](tests/validacao_intermediaria_2.md).

**CorreÃ§Ã£o 0.25.1:** a caudada de Tico agora Ã© um giro corporal completo em seis
poses. O personagem prepara, vira de costas, varre o espaÃ§o com a cauda, atinge
o adversÃ¡rio e recupera o equilÃ­brio. O dano foi sincronizado ao quadro de impacto,
e o recorte dos quadros preserva o tamanho de Tico durante todo o golpe.
[Detalhes e testes](tests/correcao_giro_cauda.md).

**EvoluÃ§Ã£o E13 â€” introduÃ§Ã£o de Pipo (0.22.0):** Pipo agora recebe uma apresentaÃ§Ã£o
narrativa dentro da fase 1-3. Tico descobre que ele tambÃ©m procura comida, realiza
o resgate jogÃ¡vel e o convida para a missÃ£o. A cena demonstra forÃ§a e agilidade
antes do desafio cooperativo, e o desbloqueio continua vÃ¡lido nas fases iniciais
revisitadas. [Entrega e validaÃ§Ã£o da E13](tests/evolucao_e13.md).

**EvoluÃ§Ã£o E12 â€” Valda e progressÃ£o da histÃ³ria (0.21.0):** Valda reencontra
Tico e Pipo depois dos quatro confrontos decisivos, contextualiza o resultado,
revela a pista seguinte e conduz a transiÃ§Ã£o para o mapa. A antiga chefe coruja
da montanha agora Ã© o GaviÃ£o da Montanha. Windows, navegador e PWA iniciam em
tela cheia, sem controle flutuante sobre o jogo. [Entrega e validaÃ§Ã£o da E12](tests/evolucao_e12.md).

**EvoluÃ§Ã£o E11 â€” abertura do jogo (0.20.0):** nova aventura apresenta o vilarejo,
a falta de comida, o resgate de Valda, a conversa que transforma a busca de Tico
em uma missÃ£o por todo o bosque e o tÃ­tulo antes do mapa. A sequÃªncia usa
enquadramentos animados, funciona com toque, pode ser pulada e nÃ£o se repete depois
de concluÃ­da. [Entrega e validaÃ§Ã£o da E11](tests/evolucao_e11.md).

**EvoluÃ§Ã£o E10 â€” estrutura narrativa (0.19.0):** infraestrutura reutilizÃ¡vel para
cenas, diÃ¡logos, retratos, transiÃ§Ãµes, eventos persistentes e sinais de animaÃ§Ã£o.
As cenas suspendem o gameplay, podem ser puladas e nÃ£o se repetem apÃ³s concluÃ­das.
[Entrega e validaÃ§Ã£o da E10](tests/evolucao_e10.md).

**EvoluÃ§Ã£o E09 â€” recompensas e coletÃ¡veis (0.18.0):** tamanho e duraÃ§Ã£o aprovados,
com 271 nozes, 39 alimentos, 14 blocos de recompensa, duas Nozes Douradas,
vida a cada 100 novas coletas, copa na metade da fase e uma Ãºnica
bandeira apÃ³s a Ã¡rvore. O caminho permite voltar e acessar a Ã¡rvore pelos dois lados.
CoraÃ§Ãµes coletados com saÃºde cheia concedem uma vida extra.
O solo agora preenche plataformas altas com textura contÃ­nua e usa bordas
erodidas nas transiÃ§Ãµes, eliminando blocos escuros e cantos retos.
[Entrega, regras e playtest da E09](tests/evolucao_e09.md).
[PadrÃ£o estrutural para reestruturar as outras fases](arquivos_projeto/15_estrutura_fase_modelo.md).

**EvoluÃ§Ã£o E08 (0.16.2):** Primeiros Passos ganhou um trecho final e a Copa dos Segredos,
uma Ã¡rea opcional ampliada com 26 nozes, uma vida extra, trÃªs lesmas, bandeira local e
portais de retorno. [Entrega e validaÃ§Ã£o](tests/evolucao_e08.md).

A revisÃ£o visual integra entradas Ã  madeira e Ã  folhagem, usa galhos finos
com musgo e mostra a indicaÃ§Ã£o de aÃ§Ã£o apenas quando o personagem se aproxima.

**CorreÃ§Ã£o 0.15.1:** Tico e Pipo caminham pelo mapa com as setas direcionais,
incluindo a passagem entre mundos desbloqueados. Enter confirma a fase.

**EvoluÃ§Ã£o E07 (0.15.0):** resultado com conquistas, retorno ao mapa, seleÃ§Ã£o da
prÃ³xima trilha e destaque animado de novos desbloqueios. A conclusÃ£o Ã© salva
antes de sair do resultado. [Entrega e validaÃ§Ã£o](tests/evolucao_e07.md).

**EvoluÃ§Ã£o E06:** entrada pelo mapa ilustrado dos quatro mundos, com caminhos,
fases bloqueadas, disponÃ­veis, atuais e concluÃ­das. O mapa permite revisitar fases
liberadas e recebe o jogador no mundo anterior apÃ³s Game Over.
Save V2, vidas, checkpoints, Pipo e conquistas foram preservados.
Na versÃ£o 0.14.1, o mapa recebeu quatro fundos ilustrados, trilhas curvas,
medalhÃµes de fases e os personagens junto da fase atual. NavegaÃ§Ã£o, toque e
reabertura offline foram testados novamente.
[Registro e testes](tests/evolucao_e06.md).

Etapa 9 implementada: **Rio das Pedras, Montanha das Corujas e Vila dos Castores**,
cada um com trÃªs fases e um encontro final. A campanha inclui os quatro mundos.
O Bosque da etapa 8 foi testado e aprovado pelo usuÃ¡rio; os mundos novos aguardam
seu playtest. O progresso anterior Ã© importado automaticamente.
Ãgua, troncos, vento, cavernas, elevadores, peso e comportas ampliam a cooperaÃ§Ã£o.
Consulte [o registro de execuÃ§Ã£o](arquivos_projeto/12_status-do-projeto.md).

## Abrir e executar

1. Use **Godot 4.7.2 stable, ediÃ§Ã£o padrÃ£o** (sem .NET).
2. No gerenciador da Godot, importe o arquivo `project.godot` desta pasta.
3. Abra o projeto e pressione **F6** para executar a cena aberta ou **F5**
   para executar o projeto e abrir o mapa da jornada.
4. Use **F8** para interromper a execuÃ§Ã£o e **Ctrl+S** para salvar a cena.

Nesta mÃ¡quina, a instalaÃ§Ã£o escolhida fica em
`D:\Godot\Godot_v4.7.2-stable`. Para abrir pelo PowerShell:

```powershell
$godotExe = 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_win64.exe'
& $godotExe --editor --path .
```

Execute o comando na raiz do repositÃ³rio. Em outra mÃ¡quina, instale a mesma
versÃ£o pelo [arquivo oficial](https://godotengine.org/download/archive/4.7.2-stable/).
A versÃ£o do projeto tambÃ©m estÃ¡ registrada em `.godot-version`.

## ConfiguraÃ§Ã£o inicial

- GDScript, cena 2D e renderizador Compatibility.
- Janela de referÃªncia 1280 Ã— 720, landscape; resoluÃ§Ã£o provisÃ³ria.
- Stretch `canvas_items` com aspecto `expand`.
- Meta de desempenho do jogo: 60 FPS, a validar durante implementaÃ§Ã£o.
- DistribuiÃ§Ã£o principal: Web/PWA; Windows e Android nativo conforme roadmap.

| AÃ§Ã£o | Tecla provisÃ³ria |
| --- | --- |
| `move_left` | A / seta esquerda |
| `move_right` | D / seta direita |
| `jump` | EspaÃ§o |
| `action` | E |
| `switch_character` | Q |
| `pause` | Esc |

Na fase, A/D e setas movem Tico. Toque em EspaÃ§o para um salto curto;
segure para subir mais. Durante a queda, manter EspaÃ§o abre a cauda e permite
planar por atÃ© 2 segundos. Soltar encerra o planar; aterrissar recarrega a cauda.
Esc pausa e retoma. No menu de pausa, **Reiniciar fase** volta ao inÃ­cio da fase
atual e desativa sua bandeira, com saÃºde completa e sem gastar vidas. Itens e
caminhos liberados permanecem salvos. **Nova aventura**, no menu de pausa,
pede confirmaÃ§Ã£o para substituir o progresso da campanha.
Perder o foco da janela pausa o jogo. ApÃ³s resgatar Pipo, **Q/Trocar** alterna os personagens;
**E/AÃ‡ÃƒO** inicia a investida de Pipo. A troca acontece no chÃ£o, fora da
investida e onde hÃ¡ espaÃ§o para o outro personagem.
No celular, use â—€/â–¶ e PULO; manter PULO durante a queda permite planar.
Com Pipo, AÃ‡ÃƒO passa a mostrar **INVESTIR**. Seu faro Ã© automÃ¡tico perto de
segredos, sem botÃ£o extra. Gamepad futuro.

### Como jogar o Mundo 1

1. **1-1 â€” Primeiros Passos:** siga as nozes, salte pelas plataformas,
   passe pelas lesmas e alcance a Ã¡rvore no alto.
2. **1-2 â€” Blocos e Segredos:** bata por baixo dos blocos, explore a passagem
   escondida e salte sobre o ouriÃ§o. Os espinhos machucam mesmo por cima.
3. **1-3 â€” Um Novo Amigo:** quebre o bloco rachado que prende os cipÃ³s de Pipo.
   A troca fica disponÃ­vel apÃ³s o resgate. Complete os desafios da dupla abaixo.
4. **1-4 â€” Periquito do Bosque:** salte quando as raÃ­zes douradas se erguerem.
   Ele patrulha o ar, mira o personagem ativo e mergulha para tentar atingi-lo.
   Quando pousar cansado, pule sobre sua cabeÃ§a. A investida de Pipo nÃ£o causa dano.
   TrÃªs pulos na cabeÃ§a acalmam o Periquito e liberam a saÃ­da do mundo.

Na tela de resultado, **PrÃ³xima fase** continua a campanha. O encontro com o
O Periquito tem sua prÃ³pria bandeira. RecomeÃ§ar inicia o mundo novamente apÃ³s confirmaÃ§Ã£o.

### Como jogar os mundos novos

- **Rio das Pedras:** espere as plataformas mÃ³veis, empurre troncos com Pipo e
  use sua investida para baixar a ponte. Cair na Ã¡gua retorna Ã  margem com dano.
- **Montanha das Corujas:** segure PULO para planar nas correntes de vento.
  Tico atravessa cavernas baixas; Pipo abre a passagem e encontra o segredo.
- **Vila dos Castores:** Pipo aciona placas de peso e engrenagens. Espere o elevador
  baixar, suba nele e salte para o patamar. Abra a comporta para revelar o tÃºnel.
- **Chefes:** espere o ataque anunciado e a abertura dourada. O GuardiÃ£o do Rio
  aceita salto ou investida. Coruja e Rei Castor exigem um salto por cima com Tico;
  comece o salto com distÃ¢ncia. Pipo liga o elevador da arena do Rei Castor.

TrÃªs acertos acalmam cada chefe. A saÃ­da leva ao mundo seguinte. A conclusÃ£o da
Vila aponta para a Ãrvore; esse quinto mundo pertence Ã  etapa 10.

### Desafios da dupla na fase 1-3

- Colete atÃ© 13 nozes; uma estÃ¡ em um bloco e outra exige o faro de Pipo.
- Pule sobre a lesma e experimente bater por baixo dos blocos.
- Chame Pipo e caminhe contra a pedra para empurrÃ¡-la atÃ© a marca dourada.
- Troque para Tico, pule a pedra e entre na passagem baixa aberta.
- Chame Pipo e use E/INVESTIR na parede pesada.
- Perto dos arbustos, siga as partÃ­culas douradas do faro para revelar o segredo.
- Os amigos compartilham trÃªs coraÃ§Ãµes. Trocar nÃ£o recupera vida. A bandeira
  recupera os coraÃ§Ãµes e marca o retorno.
- Ao perder a vida, o personagem ativo retorna ao ponto seguro; nozes,
  pedra, passagem aberta e parede quebrada permanecem como estavam.
- Ative a bandeira depois do segredo e suba as trÃªs plataformas atÃ© a Ã¡rvore.
  Coletar todas as nozes Ã© opcional.
- **RecomeÃ§ar** ou **Jogar de novo** substitui o progresso apÃ³s confirmaÃ§Ã£o.

### Salvamento automÃ¡tico

Ao reabrir, a aventura continua automaticamente no inÃ­cio ou na bandeira ativada,
com trÃªs coraÃ§Ãµes. Nozes, blocos usados, pedra, passagem, parede, segredo e personagem
ficam salvos. Uma fase concluÃ­da reabre no resultado, exceto quando uma tentativa
de replay estÃ¡ em andamento. Inimigos comuns reaparecem; chefes jÃ¡ vencidos
permanecem calmos. CoraÃ§Ãµes consumidos nÃ£o reaparecem. Em Primeiros Passos,
**Jogar novamente** pelo mapa repÃµe nozes, alimentos e blocos de provisÃ£o para
permitir novas vidas e provisÃµes; Nozes Douradas e coraÃ§Ãµes continuam Ãºnicos.
O indicador no menu de pausa informa se foi possÃ­vel salvar.

No Web/PWA, o progresso pertence ao navegador e Ã  origem do site (`localStorage`).
Atualizar os arquivos do jogo preserva o save; limpar dados do site pode apagÃ¡-lo.
NÃ£o hÃ¡ sincronizaÃ§Ã£o entre aparelhos. No Windows, o arquivo fica em
`%APPDATA%\Godot\app_userdata\Tico e a Floresta das Nozes\campaign.json`.
O Web usa `tico.campaign.v1`. Na primeira abertura da etapa 9, o progresso do
Bosque (`world1.json` / `tico.world1.v1`) Ã© importado e o original permanece intacto.
Quem terminou o Bosque reabre no resultado e usa **Seguir para o Rio**.
Sem save do Bosque, a campanha comeÃ§a em 1-1. O slot do protÃ³tipo tambÃ©m Ã© preservado.
Pontes, comportas e mecanismos ativados ficam salvos por fase.
Saves danificados ou de versÃµes futuras sÃ£o preservados atÃ© o jogador confirmar
uma nova aventura. Veja [regras e testes da etapa 6](tests/etapa_6.md).

Na etapa 7, **Pausar/Esc** abre o menu com controles de mÃºsica e efeitos.
As preferÃªncias sÃ£o salvas; saves da etapa 6 sÃ£o aceitos com Ã¡udio ligado por padrÃ£o.
O jogo suspende mÃºsica e animaÃ§Ãµes durante a pausa. Arte, animaÃ§Ãµes e Ã¡udio estÃ£o
documentados em [testes da etapa 7](tests/etapa_7.md).

As cenas das etapas anteriores continuam disponÃ­veis para abrir com F6.

## Web/PWA â€” validaÃ§Ã£o intermediÃ¡ria 2

Destino: **https://projetosdoleo.com/tico/**. Pacote local:
`builds/web/Tico-0.36.0-fase-1-4-rochas-web.zip`. Consulte [publicaÃ§Ã£o e teste no celular](web/deployment.md).
Os builds anteriores foram preservados. O usuÃ¡rio confirmou o teste e a aprovaÃ§Ã£o da etapa 8.

Com Node.js instalado e templates Web 4.7.2 disponÃ­veis:

```powershell
npm.cmd ci
npm.cmd run build:web
npm.cmd run serve:web
```

Abra `http://127.0.0.1:8080/tico/`. Gere sempre com `build:web`, pois o comando
tambÃ©m prepara o manifesto, os Ã­cones e a versÃ£o do cache offline. Em outra
mÃ¡quina, configure `GODOT_BIN` com o caminho do executÃ¡vel console da Godot.
Para os testes de navegador, use `npm.cmd run test:web` com Google Chrome instalado.

## Build Windows da validaÃ§Ã£o intermediÃ¡ria 2

Abra `builds/windows/validacao_intermediaria_2/Tico.exe`. Mantenha `Tico.pck` na mesma pasta.
O pacote `builds/windows/Tico-0.35.0-e25-performance-windows.zip` contÃ©m os dois arquivos.
As ilustraÃ§Ãµes em `assets/slice/` seguem as pranchas de `img/`, com aprovaÃ§Ã£o
artÃ­stica ainda pendente. A etapa 7 representa o acabamento proposto para o jogo.

Para gerar novamente, instale os templates de exportaÃ§Ã£o **4.7.2 stable**
pelo gerenciador de templates da Godot. Nesta mÃ¡quina, os templates Windows
x86_64 jÃ¡ estÃ£o em `%APPDATA%\Godot\export_templates\4.7.2.stable`.

```powershell
$engine = 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_win64_console.exe'
New-Item -ItemType Directory -Force builds/windows/validacao_intermediaria_2 | Out-Null
& $engine --headless --path . --export-release 'Windows Desktop' 'builds/windows/validacao_intermediaria_2/Tico.exe'
```

O preset estÃ¡ em `export_presets.cfg`; os binÃ¡rios gerados ficam fora do Git.

## Ajustar o controle

Abra `scenes/characters/tico.tscn` e selecione Tico. O Inspector expÃµe velocidade,
aceleraÃ§Ã£o, frenagem, controle aÃ©reo, salto, tolerÃ¢ncias e planar. Os valores
iniciais estÃ£o registrados em [testes da etapa 2](tests/etapa_2.md).

A cÃ¢mera estÃ¡ em `scripts/systems/follow_camera.gd`; o playground estÃ¡ em
`scenes/levels/tico_playground.tscn`. A cena `test_level.tscn` da etapa 1 foi
preservada para regressÃ£o e pode ser executada separadamente com F6.

## Estrutura

| Pasta | ConteÃºdo |
| --- | --- |
| `arquivos_projeto/` | DocumentaÃ§Ã£o, decisÃµes e andamento |
| `img/` | Pranchas originais de referÃªncia |
| `assets/` | Arte, Ã¡udio e fontes utilizados pelo jogo |
| `scenes/` | Cena inicial e futuras cenas reutilizÃ¡veis |
| `scripts/` | Scripts de personagens, objetos e sistemas, incluindo a sonda provisÃ³ria |
| `data/` | Dados configurÃ¡veis |
| `web/` | Recursos especÃ­ficos da distribuiÃ§Ã£o Web/PWA |
| `tests/` | Registros e recursos de validaÃ§Ã£o |
| `builds/` | ExportaÃ§Ãµes locais, ignoradas pelo Git |

As pastas ainda vazias usam `.gitkeep`. DocumentaÃ§Ã£o, referÃªncias, testes e
builds possuem `.gdignore`. O cache `.godot/` nÃ£o Ã© versionado.

## DocumentaÃ§Ã£o

1. [VisÃ£o geral](arquivos_projeto/01_visao-geral.md)
2. [Requisitos](arquivos_projeto/02_requisitos.md)
3. [Gameplay](arquivos_projeto/03_gameplay.md)
4. [Personagens](arquivos_projeto/04_personagens.md)
5. [Fases e mundos](arquivos_projeto/05_fases-e-mundos.md)
6. [DireÃ§Ã£o visual](arquivos_projeto/06_direcao-visual.md)
7. [Arquitetura tÃ©cnica](arquivos_projeto/07_arquitetura-tecnica.md)
8. [Roadmap](arquivos_projeto/08_roadmap.md)
9. [HistÃ³ria e narrativa](arquivos_projeto/09_historia-e-narrativa.md)
10. [Testes](arquivos_projeto/10_testes.md)
11. [DecisÃµes](arquivos_projeto/11_decisoes.md)
12. [Status do projeto](arquivos_projeto/12_status-do-projeto.md)

## VerificaÃ§Ã£o local

```powershell
$godotConsole = 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_win64_console.exe'
& $godotConsole --headless --path . --editor --import --quit
& $godotConsole --headless --path . --quit-after 10
& $godotConsole --headless --path . --script tests/foundation_test.gd
& $godotConsole --headless --path . --script tests/tico_test.gd --fixed-fps 60
& $godotConsole --headless --path . --script tests/minigame_test.gd --fixed-fps 60
& $godotConsole --headless --path . --script tests/coop_test.gd --fixed-fps 60
& $godotConsole --headless --path . --script tests/prototype_test.gd --fixed-fps 60
& $godotConsole --headless --path . --script tests/slice_test.gd --fixed-fps 60
& $godotConsole --headless --path . --script tests/world_test.gd --fixed-fps 60
& $godotConsole --headless --path . --script tests/world_rules_test.gd --fixed-fps 60
```

Esses comandos verificam importaÃ§Ã£o, execuÃ§Ã£o, input, colisÃµes, salto, planar,
cÃ¢mera e pausa. Resultados em [testes da etapa 1](tests/etapa_1.md) e
[testes da etapa 2](tests/etapa_2.md). O usuÃ¡rio aprovou o playtest da etapa 2.
Os testes Web/PWA estÃ£o em [testes da etapa 3](tests/etapa_3.md).
O gameplay e a nova versÃ£o Web estÃ£o em [testes da etapa 4](tests/etapa_4.md).
Pipo e a cooperaÃ§Ã£o estÃ£o em [testes da etapa 5](tests/etapa_5.md).
O protÃ³tipo e a persistÃªncia estÃ£o em [testes da etapa 6](tests/etapa_6.md).
Arte, Ã¡udio, UI e mediÃ§Ãµes estÃ£o em [testes da etapa 7](tests/etapa_7.md).
O build Android nativo permanece para uma etapa futura.

A campanha e seu aceite estÃ£o em [testes da etapa 8](tests/etapa_8.md).
Os mundos novos estÃ£o documentados em [testes da etapa 9](tests/etapa_9.md).
`npm.cmd run test:web` executa os cenÃ¡rios atuais em `expedition.spec.js`.
Para repetir os testes Web da etapa 8, use `$env:TICO_WEB_STAGE='8'` com seu build preservado.
Os testes histÃ³ricos Web da etapa 7 continuam disponÃ­veis contra seu build preservado:
defina `$env:TICO_WEB_STAGE='7'` antes de executar o Playwright e remova a variÃ¡vel
com `Remove-Item Env:TICO_WEB_STAGE` ao voltar Ã  etapa atual. Feche o servidor local
antes de alternar a versÃ£o servida.

## EvoluÃ§Ã£o planejada

**E00 concluÃ­da:** [diagnÃ³stico da base](arquivos_projeto/15_diagnostico_e00.md)
e [verificaÃ§Ãµes executadas](tests/evolucao_e00.md).
**E01 implementada:** [saÃºde, dano e morte](tests/evolucao_e01.md).
**E02 implementada:** [vidas e Game Over](tests/evolucao_e02.md).
**E03 implementada:** [checkpoints e reinÃ­cio](tests/evolucao_e03.md).
**E06 implementada:** [mapa do mundo](tests/evolucao_e06.md).
**E07 implementada:** [resultado e desbloqueio](tests/evolucao_e07.md).
**E08 implementada:** [Ã¡reas opcionais e exploraÃ§Ã£o](tests/evolucao_e08.md).

**E09 implementada:** [recompensas e coletÃ¡veis](tests/evolucao_e09.md).
**E10 implementada:** [estrutura narrativa](tests/evolucao_e10.md).
**E14 implementada:** [mecÃ¢nicas de Tico e Pipo](tests/evolucao_e14.md).
**E15 implementada:** [backtracking controlado](tests/evolucao_e15.md).
**ValidaÃ§Ã£o intermediÃ¡ria 2 concluÃ­da:** [aventura completa em miniatura](tests/validacao_intermediaria_2.md).
**EvoluÃ§Ã£o E16:** a fase Primeiros Passos possui uma curva Ãºnica de aprender,
praticar, combinar e desafiar. Os modos FÃ¡cil, MÃ©dio e DifÃ­cil foram adiados atÃ©
o aceite final da fase. Consulte a [implementaÃ§Ã£o e validaÃ§Ã£o](tests/evolucao_e16.md).

**EvoluÃ§Ã£o E17 (0.27.1):** seis famÃ­lias de inimigos agora possuem arte prÃ³pria e
comportamentos distintos. O porco-espinho recebeu nova aparÃªncia, o besouro
acelera, a aranha ameaÃ§a na vertical e o corvo executa perseguiÃ§Ãµes curtas.
Todos receberam ciclos de quatro quadros: patas alternam no solo, a lesma rasteja
por compressÃ£o e os inimigos aÃ©reos articulam as asas sem mudar de tamanho.
As artes terrestres ficam alinhadas Ã  superfÃ­cie, e a aranha desce atÃ© a faixa de
risco antes de retornar ao alto e liberar a passagem.
[Detalhes e playtest](tests/evolucao_e17.md).

**EvoluÃ§Ã£o E18 (0.29.2):** os quatro chefes avanÃ§am por padrÃ£o simples, variaÃ§Ã£o
e combinaÃ§Ã£o. Cada acerto amplia a Ã¡rea do ataque e acelera o aviso, enquanto a
abertura continua longa o bastante para observar, posicionar e atacar. As arenas
retomam as mecÃ¢nicas ensinadas em cada mundo. O Periquito patrulha o ar, persegue
Tico ou Pipo e mergulha sobre o alvo. Ao pousar, ele permanece no ponto do mergulho
e recupera o fÃ´lego com uma respiraÃ§Ã£o visÃ­vel. ApÃ³s trÃªs pulos na cabeÃ§a, ele cai,
desaparece e o personagem corre automaticamente atÃ© o portal.
[Detalhes e playtest](tests/evolucao_e18.md).

**EvoluÃ§Ã£o E19 (0.29.1):** o mapa agora permite visitar o vilarejo. Alimentos e
fases concluÃ­das transformam cestos, moradores, iluminaÃ§Ã£o e decoraÃ§Ã£o em quatro
estados persistentes. A vitÃ³ria final reÃºne a comunidade em uma celebraÃ§Ã£o.
[Detalhes e playtest](tests/evolucao_e19.md).

As prÃ³ximas melhorias seguem [13_evolucao.md](arquivos_projeto/13_evolucao.md) e
[14_etapas_evolucao.md](arquivos_projeto/14_etapas_evolucao.md), com etapas E00â€“E30.
DecisÃµes registradas na DEC-115: Coruja mentora, GaviÃ£o como chefe da Montanha,
Pipo nas fases iniciais apÃ³s seu desbloqueio e Game Over no mapa do mundo anterior,
preservando fases desbloqueadas. Essas mudanÃ§as ainda nÃ£o estÃ£o no build da etapa 9.
