# Tico e a Floresta das Nozes

Jogo de plataforma 2D para crianças, sobre exploração, amizade e cooperação
entre Tico, um esquilo ágil, e Pipo, um porquinho forte de camisa verde.

## Estado atual

Etapa 2 implementada: Tico corre, pula, plana e possui animações provisórias
em um playground com câmera e chão seguro. Os testes técnicos passaram;
o marco 1 ainda precisa de playtest para avaliar o conforto e a diversão.
Consulte [o registro de execução](arquivos_projeto/12_status-do-projeto.md).

## Abrir e executar

1. Use **Godot 4.7.2 stable, edição padrão** (sem .NET).
2. No gerenciador da Godot, importe o arquivo `project.godot` desta pasta.
3. Abra o projeto e pressione **F6** para executar a cena aberta ou **F5**
   para executar o projeto e abrir o Tico Playground.
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

No playground, A/D e setas movem Tico. Toque em Espaço para um salto curto;
segure para subir mais. Durante a queda, manter Espaço abre a cauda e permite
planar por até 2 segundos. Soltar encerra o planar; aterrissar recarrega a cauda.
Esc pausa e retoma. O botão **Recomeçar** volta ao início, inclusive durante a pausa.
Perder o foco da janela pausa o jogo. E e Q permanecem reservados, sem efeito aqui.
Os botões touch serão conectados às mesmas ações na etapa 3. Gamepad futuro.

## Build Windows da etapa 2

Abra `builds/windows/etapa_2/Tico.exe`. Mantenha `Tico.pck` na mesma pasta.
O pacote `builds/windows/Tico-etapa-2-windows.zip` contém os dois arquivos.
É um build de desenvolvimento com gráficos provisórios em SVG. As pranchas
em `img/` continuam sendo a referência para a arte final.

Para gerar novamente, instale os templates de exportação **4.7.2 stable**
pelo gerenciador de templates da Godot. Nesta máquina, os templates Windows
x86_64 já estão em `%APPDATA%\Godot\export_templates\4.7.2.stable`.

```powershell
$engine = 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_win64_console.exe'
New-Item -ItemType Directory -Force builds/windows/etapa_2 | Out-Null
& $engine --headless --path . --export-debug 'Windows Desktop' 'builds/windows/etapa_2/Tico.exe'
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
```

Esses comandos verificam importação, execução, input, colisões, salto, planar,
câmera e pausa. Resultados em [testes da etapa 1](tests/etapa_1.md) e
[testes da etapa 2](tests/etapa_2.md). Antes da etapa 3, experimente o playground
para avaliar se o controle é confortável e divertido, conforme o roadmap.
Não há exportação Web/PWA nem build Android nesta etapa.
