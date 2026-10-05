# Tico e a Floresta das Nozes

Jogo de plataforma 2D para crianças, sobre exploração, amizade e cooperação
entre Tico, um esquilo ágil, e Pipo, um porquinho forte de camisa verde.

Para configurar outra máquina após clonar o repositório, consulte o
[guia de desenvolvimento e builds](DESENVOLVIMENTO.md).

## Estado atual

**Validação intermediária 2 — aventura completa em miniatura (0.25.0):** o
Mundo 1 agora é a referência integrada da campanha, da abertura ao chefe e à
próxima pista de Valda. Mapa, três fases, copa opcional, coletáveis, Pipo,
progressão e Save V2 foram validados em um fluxo contínuo.
[Relatório da validação](tests/validacao_intermediaria_2.md).

**Evolução E13 — introdução de Pipo (0.22.0):** Pipo agora recebe uma apresentação
narrativa dentro da fase 1-3. Tico descobre que ele também procura comida, realiza
o resgate jogável e o convida para a missão. A cena demonstra força e agilidade
antes do desafio cooperativo, e o desbloqueio continua válido nas fases iniciais
revisitadas. [Entrega e validação da E13](tests/evolucao_e13.md).

**Evolução E12 — Valda e progressão da história (0.21.0):** Valda reencontra
Tico e Pipo depois dos quatro confrontos decisivos, contextualiza o resultado,
revela a pista seguinte e conduz a transição para o mapa. A antiga chefe coruja
da montanha agora é o Gavião da Montanha. Windows, navegador e PWA iniciam em
tela cheia, sem controle flutuante sobre o jogo. [Entrega e validação da E12](tests/evolucao_e12.md).

**Evolução E11 — abertura do jogo (0.20.0):** nova aventura apresenta o vilarejo,
a falta de comida, o resgate de Valda, a conversa que transforma a busca de Tico
em uma missão por todo o bosque e o título antes do mapa. A sequência usa
enquadramentos animados, funciona com toque, pode ser pulada e não se repete depois
de concluída. [Entrega e validação da E11](tests/evolucao_e11.md).

**Evolução E10 — estrutura narrativa (0.19.0):** infraestrutura reutilizável para
cenas, diálogos, retratos, transições, eventos persistentes e sinais de animação.
As cenas suspendem o gameplay, podem ser puladas e não se repetem após concluídas.
[Entrega e validação da E10](tests/evolucao_e10.md).

**Evolução E09 — recompensas e coletáveis (0.18.0):** tamanho e duração aprovados,
com 271 nozes, 39 alimentos, 14 blocos de recompensa, duas Nozes Douradas,
vida a cada 100 novas coletas, copa na metade da fase e uma única
bandeira após a árvore. O caminho permite voltar e acessar a árvore pelos dois lados.
Corações coletados com saúde cheia concedem uma vida extra.
O solo agora preenche plataformas altas com textura contínua e usa bordas
erodidas nas transições, eliminando blocos escuros e cantos retos.
[Entrega, regras e playtest da E09](tests/evolucao_e09.md).
[Padrão estrutural para reestruturar as outras fases](arquivos_projeto/15_estrutura_fase_modelo.md).

**Evolução E08 (0.16.2):** Primeiros Passos ganhou um trecho final e a Copa dos Segredos,
uma área opcional ampliada com 26 nozes, uma vida extra, três lesmas, bandeira local e
portais de retorno. [Entrega e validação](tests/evolucao_e08.md).

A revisão visual integra entradas à madeira e à folhagem, usa galhos finos
com musgo e mostra a indicação de ação apenas quando o personagem se aproxima.

**Correção 0.15.1:** Tico e Pipo caminham pelo mapa com as setas direcionais,
incluindo a passagem entre mundos desbloqueados. Enter confirma a fase.

**Evolução E07 (0.15.0):** resultado com conquistas, retorno ao mapa, seleção da
próxima trilha e destaque animado de novos desbloqueios. A conclusão é salva
antes de sair do resultado. [Entrega e validação](tests/evolucao_e07.md).

**Evolução E06:** entrada pelo mapa ilustrado dos quatro mundos, com caminhos,
fases bloqueadas, disponíveis, atuais e concluídas. O mapa permite revisitar fases
liberadas e recebe o jogador no mundo anterior após Game Over.
Save V2, vidas, checkpoints, Pipo e conquistas foram preservados.
Na versão 0.14.1, o mapa recebeu quatro fundos ilustrados, trilhas curvas,
medalhões de fases e os personagens junto da fase atual. Navegação, toque e
reabertura offline foram testados novamente.
[Registro e testes](tests/evolucao_e06.md).

Etapa 9 implementada: **Rio das Pedras, Montanha das Corujas e Vila dos Castores**,
cada um com três fases e um encontro final. A campanha inclui os quatro mundos.
O Bosque da etapa 8 foi testado e aprovado pelo usuário; os mundos novos aguardam
seu playtest. O progresso anterior é importado automaticamente.
Água, troncos, vento, cavernas, elevadores, peso e comportas ampliam a cooperação.
Consulte [o registro de execução](arquivos_projeto/12_status-do-projeto.md).

## Abrir e executar

1. Use **Godot 4.7.2 stable, edição padrão** (sem .NET).
2. No gerenciador da Godot, importe o arquivo `project.godot` desta pasta.
3. Abra o projeto e pressione **F6** para executar a cena aberta ou **F5**
   para executar o projeto e abrir o mapa da jornada.
4. Use **F8** para interromper a execução e **Ctrl+S** para salvar a cena.

Nesta máquina, a instalação escolhida fica em
`D:\Godot\Godot_v4.7.2-stable`. Para abrir pelo PowerShell:

```powershell
$godotExe = 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_win64.exe'
& $godotExe --editor --path .
```

Execute o comando na raiz do repositório. Em outra máquina, instale a mesma
versão pelo [arquivo oficial](https://godotengine.org/download/archive/4.7.2-stable/).
A versão do projeto também está registrada em `.godot-version`.

## Configuração inicial

- GDScript, cena 2D e renderizador Compatibility.
- Janela de referência 1280 × 720, landscape; resolução provisória.
- Stretch `canvas_items` com aspecto `expand`.
- Meta de desempenho do jogo: 60 FPS, a validar durante implementação.
- Distribuição principal: Web/PWA; Windows e Android nativo conforme roadmap.

| Ação | Tecla provisória |
| --- | --- |
| `move_left` | A / seta esquerda |
| `move_right` | D / seta direita |
| `jump` | Espaço |
| `action` | E |
| `switch_character` | Q |
| `pause` | Esc |

Na fase, A/D e setas movem Tico. Toque em Espaço para um salto curto;
segure para subir mais. Durante a queda, manter Espaço abre a cauda e permite
planar por até 2 segundos. Soltar encerra o planar; aterrissar recarrega a cauda.
Esc pausa e retoma. No menu de pausa, **Reiniciar fase** volta ao início da fase
atual e desativa sua bandeira, com saúde completa e sem gastar vidas. Itens e
caminhos liberados permanecem salvos. **Nova aventura**, no menu de pausa,
pede confirmação para substituir o progresso da campanha.
Perder o foco da janela pausa o jogo. Após resgatar Pipo, **Q/Trocar** alterna os personagens;
**E/AÇÃO** inicia a investida de Pipo. A troca acontece no chão, fora da
investida e onde há espaço para o outro personagem.
No celular, use ◀/▶ e PULO; manter PULO durante a queda permite planar.
Com Pipo, AÇÃO passa a mostrar **INVESTIR**. Seu faro é automático perto de
segredos, sem botão extra. Gamepad futuro.

### Como jogar o Mundo 1

1. **1-1 — Primeiros Passos:** siga as nozes, salte pelas plataformas,
   passe pelas lesmas e alcance a árvore no alto.
2. **1-2 — Blocos e Segredos:** bata por baixo dos blocos, explore a passagem
   escondida e salte sobre o ouriço. Os espinhos machucam mesmo por cima.
3. **1-3 — Um Novo Amigo:** quebre o bloco rachado que prende os cipós de Pipo.
   A troca fica disponível após o resgate. Complete os desafios da dupla abaixo.
4. **Final de 1-3 — Guardião:** salte quando as raízes douradas se erguerem.
   Quando ele ficar cansado, use um salto por cima ou a investida de Pipo.
   Três acertos acalmam o Guardião e liberam a saída do mundo.

Na tela de resultado, **Próxima fase** continua a campanha. O encontro com o
Guardião tem sua própria bandeira. Recomeçar inicia o mundo novamente após confirmação.

### Como jogar os mundos novos

- **Rio das Pedras:** espere as plataformas móveis, empurre troncos com Pipo e
  use sua investida para baixar a ponte. Cair na água retorna à margem com dano.
- **Montanha das Corujas:** segure PULO para planar nas correntes de vento.
  Tico atravessa cavernas baixas; Pipo abre a passagem e encontra o segredo.
- **Vila dos Castores:** Pipo aciona placas de peso e engrenagens. Espere o elevador
  baixar, suba nele e salte para o patamar. Abra a comporta para revelar o túnel.
- **Chefes:** espere o ataque anunciado e a abertura dourada. O Guardião do Rio
  aceita salto ou investida. Coruja e Rei Castor exigem um salto por cima com Tico;
  comece o salto com distância. Pipo liga o elevador da arena do Rei Castor.

Três acertos acalmam cada chefe. A saída leva ao mundo seguinte. A conclusão da
Vila aponta para a Árvore; esse quinto mundo pertence à etapa 10.

### Desafios da dupla na fase 1-3

- Colete até 13 nozes; uma está em um bloco e outra exige o faro de Pipo.
- Pule sobre a lesma e experimente bater por baixo dos blocos.
- Chame Pipo e caminhe contra a pedra para empurrá-la até a marca dourada.
- Troque para Tico, pule a pedra e entre na passagem baixa aberta.
- Chame Pipo e use E/INVESTIR na parede pesada.
- Perto dos arbustos, siga as partículas douradas do faro para revelar o segredo.
- Os amigos compartilham três corações. Trocar não recupera vida. A bandeira
  recupera os corações e marca o retorno.
- Ao perder a vida, o personagem ativo retorna ao ponto seguro; nozes,
  pedra, passagem aberta e parede quebrada permanecem como estavam.
- Ative a bandeira depois do segredo e suba as três plataformas até a árvore.
  Coletar todas as nozes é opcional.
- **Recomeçar** ou **Jogar de novo** substitui o progresso após confirmação.

### Salvamento automático

Ao reabrir, a aventura continua automaticamente no início ou na bandeira ativada,
com três corações. Nozes, blocos usados, pedra, passagem, parede, segredo e personagem
ficam salvos. Uma fase concluída reabre no resultado, exceto quando uma tentativa
de replay está em andamento. Inimigos comuns reaparecem; chefes já vencidos
permanecem calmos. Corações consumidos não reaparecem. Em Primeiros Passos,
**Jogar novamente** pelo mapa repõe nozes, alimentos e blocos de provisão para
permitir novas vidas e provisões; Nozes Douradas e corações continuam únicos.
O indicador no menu de pausa informa se foi possível salvar.

No Web/PWA, o progresso pertence ao navegador e à origem do site (`localStorage`).
Atualizar os arquivos do jogo preserva o save; limpar dados do site pode apagá-lo.
Não há sincronização entre aparelhos. No Windows, o arquivo fica em
`%APPDATA%\Godot\app_userdata\Tico e a Floresta das Nozes\campaign.json`.
O Web usa `tico.campaign.v1`. Na primeira abertura da etapa 9, o progresso do
Bosque (`world1.json` / `tico.world1.v1`) é importado e o original permanece intacto.
Quem terminou o Bosque reabre no resultado e usa **Seguir para o Rio**.
Sem save do Bosque, a campanha começa em 1-1. O slot do protótipo também é preservado.
Pontes, comportas e mecanismos ativados ficam salvos por fase.
Saves danificados ou de versões futuras são preservados até o jogador confirmar
uma nova aventura. Veja [regras e testes da etapa 6](tests/etapa_6.md).

Na etapa 7, **Pausar/Esc** abre o menu com controles de música e efeitos.
As preferências são salvas; saves da etapa 6 são aceitos com áudio ligado por padrão.
O jogo suspende música e animações durante a pausa. Arte, animações e áudio estão
documentados em [testes da etapa 7](tests/etapa_7.md).

As cenas das etapas anteriores continuam disponíveis para abrir com F6.

## Web/PWA — validação intermediária 2

Destino: **https://projetosdoleo.com/tico/**. Pacote local:
`builds/web/Tico-validacao-intermediaria-2-web-corrigido.zip`. Consulte [publicação e teste no celular](web/deployment.md).
Os builds anteriores foram preservados. O usuário confirmou o teste e a aprovação da etapa 8.

Com Node.js instalado e templates Web 4.7.2 disponíveis:

```powershell
npm.cmd ci
npm.cmd run build:web
npm.cmd run serve:web
```

Abra `http://127.0.0.1:8080/tico/`. Gere sempre com `build:web`, pois o comando
também prepara o manifesto, os ícones e a versão do cache offline. Em outra
máquina, configure `GODOT_BIN` com o caminho do executável console da Godot.
Para os testes de navegador, use `npm.cmd run test:web` com Google Chrome instalado.

## Build Windows da validação intermediária 2

Abra `builds/windows/validacao_intermediaria_2/Tico.exe`. Mantenha `Tico.pck` na mesma pasta.
O pacote `builds/windows/Tico-validacao-intermediaria-2-windows-corrigido.zip` contém os dois arquivos.
As ilustrações em `assets/slice/` seguem as pranchas de `img/`, com aprovação
artística ainda pendente. A etapa 7 representa o acabamento proposto para o jogo.

Para gerar novamente, instale os templates de exportação **4.7.2 stable**
pelo gerenciador de templates da Godot. Nesta máquina, os templates Windows
x86_64 já estão em `%APPDATA%\Godot\export_templates\4.7.2.stable`.

```powershell
$engine = 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_win64_console.exe'
New-Item -ItemType Directory -Force builds/windows/validacao_intermediaria_2 | Out-Null
& $engine --headless --path . --export-release 'Windows Desktop' 'builds/windows/validacao_intermediaria_2/Tico.exe'
```

O preset está em `export_presets.cfg`; os binários gerados ficam fora do Git.

## Ajustar o controle

Abra `scenes/characters/tico.tscn` e selecione Tico. O Inspector expõe velocidade,
aceleração, frenagem, controle aéreo, salto, tolerâncias e planar. Os valores
iniciais estão registrados em [testes da etapa 2](tests/etapa_2.md).

A câmera está em `scripts/systems/follow_camera.gd`; o playground está em
`scenes/levels/tico_playground.tscn`. A cena `test_level.tscn` da etapa 1 foi
preservada para regressão e pode ser executada separadamente com F6.

## Estrutura

| Pasta | Conteúdo |
| --- | --- |
| `arquivos_projeto/` | Documentação, decisões e andamento |
| `img/` | Pranchas originais de referência |
| `assets/` | Arte, áudio e fontes utilizados pelo jogo |
| `scenes/` | Cena inicial e futuras cenas reutilizáveis |
| `scripts/` | Scripts de personagens, objetos e sistemas, incluindo a sonda provisória |
| `data/` | Dados configuráveis |
| `web/` | Recursos específicos da distribuição Web/PWA |
| `tests/` | Registros e recursos de validação |
| `builds/` | Exportações locais, ignoradas pelo Git |

As pastas ainda vazias usam `.gitkeep`. Documentação, referências, testes e
builds possuem `.gdignore`. O cache `.godot/` não é versionado.

## Documentação

1. [Visão geral](arquivos_projeto/01_visao-geral.md)
2. [Requisitos](arquivos_projeto/02_requisitos.md)
3. [Gameplay](arquivos_projeto/03_gameplay.md)
4. [Personagens](arquivos_projeto/04_personagens.md)
5. [Fases e mundos](arquivos_projeto/05_fases-e-mundos.md)
6. [Direção visual](arquivos_projeto/06_direcao-visual.md)
7. [Arquitetura técnica](arquivos_projeto/07_arquitetura-tecnica.md)
8. [Roadmap](arquivos_projeto/08_roadmap.md)
9. [História e narrativa](arquivos_projeto/09_historia-e-narrativa.md)
10. [Testes](arquivos_projeto/10_testes.md)
11. [Decisões](arquivos_projeto/11_decisoes.md)
12. [Status do projeto](arquivos_projeto/12_status-do-projeto.md)

## Verificação local

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

Esses comandos verificam importação, execução, input, colisões, salto, planar,
câmera e pausa. Resultados em [testes da etapa 1](tests/etapa_1.md) e
[testes da etapa 2](tests/etapa_2.md). O usuário aprovou o playtest da etapa 2.
Os testes Web/PWA estão em [testes da etapa 3](tests/etapa_3.md).
O gameplay e a nova versão Web estão em [testes da etapa 4](tests/etapa_4.md).
Pipo e a cooperação estão em [testes da etapa 5](tests/etapa_5.md).
O protótipo e a persistência estão em [testes da etapa 6](tests/etapa_6.md).
Arte, áudio, UI e medições estão em [testes da etapa 7](tests/etapa_7.md).
O build Android nativo permanece para uma etapa futura.

A campanha e seu aceite estão em [testes da etapa 8](tests/etapa_8.md).
Os mundos novos estão documentados em [testes da etapa 9](tests/etapa_9.md).
`npm.cmd run test:web` executa os cenários atuais em `expedition.spec.js`.
Para repetir os testes Web da etapa 8, use `$env:TICO_WEB_STAGE='8'` com seu build preservado.
Os testes históricos Web da etapa 7 continuam disponíveis contra seu build preservado:
defina `$env:TICO_WEB_STAGE='7'` antes de executar o Playwright e remova a variável
com `Remove-Item Env:TICO_WEB_STAGE` ao voltar à etapa atual. Feche o servidor local
antes de alternar a versão servida.

## Evolução planejada

**E00 concluída:** [diagnóstico da base](arquivos_projeto/15_diagnostico_e00.md)
e [verificações executadas](tests/evolucao_e00.md).
**E01 implementada:** [saúde, dano e morte](tests/evolucao_e01.md).
**E02 implementada:** [vidas e Game Over](tests/evolucao_e02.md).
**E03 implementada:** [checkpoints e reinício](tests/evolucao_e03.md).
**E06 implementada:** [mapa do mundo](tests/evolucao_e06.md).
**E07 implementada:** [resultado e desbloqueio](tests/evolucao_e07.md).
**E08 implementada:** [áreas opcionais e exploração](tests/evolucao_e08.md).

**E09 implementada:** [recompensas e coletáveis](tests/evolucao_e09.md).
**E10 implementada:** [estrutura narrativa](tests/evolucao_e10.md).
**E14 implementada:** [mecânicas de Tico e Pipo](tests/evolucao_e14.md).
**E15 implementada:** [backtracking controlado](tests/evolucao_e15.md).
**Validação intermediária 2 concluída:** [aventura completa em miniatura](tests/validacao_intermediaria_2.md).
Próximo passo: validar o fluxo completo no aparelho e seguir para a E16.

As próximas melhorias seguem [13_evolucao.md](arquivos_projeto/13_evolucao.md) e
[14_etapas_evolucao.md](arquivos_projeto/14_etapas_evolucao.md), com etapas E00–E30.
Decisões registradas na DEC-115: Coruja mentora, Gavião como chefe da Montanha,
Pipo nas fases iniciais após seu desbloqueio e Game Over no mapa do mundo anterior,
preservando fases desbloqueadas. Essas mudanças ainda não estão no build da etapa 9.
