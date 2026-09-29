# Tico e a Floresta das Nozes

Jogo de plataforma 2D para crianças, sobre exploração, amizade e cooperação
entre Tico, um esquilo ágil, e Pipo, um porquinho forte de camisa verde.

## Estado atual

Etapa 0: preparação do ambiente e projeto inicial. A cena principal está
vazia; personagens e gameplay serão implementados nas próximas etapas.
Consulte [o registro de execução](arquivos_projeto/12_status-do-projeto.md).

## Abrir e executar

1. Use **Godot 4.7.2 stable, edição padrão** (sem .NET).
2. No gerenciador da Godot, importe o arquivo `project.godot` desta pasta.
3. Abra o projeto e pressione **F6** para executar a cena aberta ou **F5**
   para executar o projeto. A cena inicial exibe somente a cor de fundo.
4. Use **F8** para interromper a execução e **Ctrl+S** para salvar a cena.

Nesta máquina, a Godot foi instalada em
`%LOCALAPPDATA%\Programs\Godot\4.7.2`. Para abrir pelo PowerShell:

```powershell
$godotExe = Join-Path $env:LOCALAPPDATA 'Programs\Godot\4.7.2\Godot_v4.7.2-stable_win64.exe'
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

As ações estão cadastradas no Input Map, mas ainda não executam gameplay.
Os botões touch serão conectados às mesmas ações na etapa 3. Gamepad futuro.

## Estrutura

| Pasta | Conteúdo |
| --- | --- |
| `arquivos_projeto/` | Documentação, decisões e andamento |
| `img/` | Pranchas originais de referência |
| `assets/` | Arte, áudio e fontes utilizados pelo jogo |
| `scenes/` | Cena inicial e futuras cenas reutilizáveis |
| `scripts/` | Futuros scripts de personagens, objetos e sistemas |
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
$godotConsole = Join-Path $env:LOCALAPPDATA 'Programs\Godot\4.7.2\Godot_v4.7.2-stable_win64_console.exe'
& $godotConsole --headless --path . --editor --import --quit
& $godotConsole --headless --path . --quit-after 10
```

Esses comandos verificam importação e execução básica. A validação gráfica,
os testes de gameplay e as exportações pertencem a verificações específicas.
Não há exportação Web/PWA nem build Android nesta etapa.
