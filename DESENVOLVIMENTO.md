# Guia de desenvolvimento após clonar o projeto

Este guia cobre o ambiente Windows com PowerShell, usado neste projeto.
Execute os comandos na raiz do repositório, onde está `project.godot`.
Os caminhos de saída abaixo correspondem à **Evolução E09, versão 0.18.0**.

## 1. Preparar o ambiente

Instale ou disponibilize estas ferramentas:

| Ferramenta | Uso e versão |
| --- | --- |
| Git | Clonar o repositório e revisar alterações |
| Godot padrão, sem .NET | **4.7.2 stable**, conforme `.godot-version` |
| Templates de exportação da Godot | **4.7.2 stable**, para exportar Web e Windows |
| Node.js com npm | Ambiente usado: **Node 24.16.0 / npm 11.13.0**; necessário para os scripts Web e testes de navegador |
| Google Chrome | Necessário para os testes configurados em `playwright.config.js` |

O jogo usa GDScript e o renderizador Compatibility. Não é necessário instalar
.NET, Python ou um compilador C++ para o fluxo descrito aqui.

Na Godot, abra **Editor → Manage Export Templates / Gerenciar templates de
exportação** e instale os templates da mesma versão do editor. Se já tiver o
arquivo `.tpz`, use a opção de instalar a partir de arquivo. O local padrão no
Windows é `%APPDATA%\Godot\export_templates\4.7.2.stable`.

Depois de instalar Git e Node.js, abra um novo PowerShell e confira:

```powershell
git --version
node --version
npm.cmd --version
```

Os exemplos usam `npm.cmd` para evitar o bloqueio de `npm.ps1` pela política
de execução do PowerShell.

## 2. Clonar e configurar o projeto

Substitua a URL abaixo pela URL real do seu repositório:

```powershell
git clone <URL_DO_REPOSITORIO> jogo-esquilo
Set-Location jogo-esquilo
git status
```

O clone recebe apenas o conteúdo enviado ao repositório remoto. Alterações que
ficaram somente em outra máquina precisam ser transferidas ou enviadas ao remoto
para estarem disponíveis aqui.

Configure o caminho do executável **console** da Godot. Adapte o exemplo à pasta
em que você extraiu o editor:

```powershell
$env:GODOT_BIN = 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_win64_console.exe'
Test-Path -LiteralPath $env:GODOT_BIN
& $env:GODOT_BIN --version
```

`Test-Path` deve retornar `True`. Essa variável vale para o terminal atual e os
programas iniciados por ele. Configure-a novamente ao abrir outro terminal.
`web/build.mjs` usa `GODOT_BIN`; assim, não é preciso alterar o script para adaptar
o caminho à sua máquina.

Instale as dependências registradas no lockfile e importe os recursos:

```powershell
npm.cmd ci
& $env:GODOT_BIN --headless --path . --editor --import --quit
```

Use `npm.cmd ci` para reproduzir as dependências de `package-lock.json`.
O cache `.godot/`, as dependências `node_modules/` e os builds são gerados
localmente e não vêm no clone. Aguarde a importação terminar antes de testar ou
exportar; confira se o console informa algum `SCRIPT ERROR` ou `Parse Error`.

## 3. Abrir e executar

```powershell
& $env:GODOT_BIN --editor --path .
```

Também é possível importar `project.godot` pelo gerenciador de projetos da Godot.

- **F5:** executa a campanha, a partir de `scenes/main.tscn`.
- **F6:** executa somente a cena aberta, útil para testar uma fase ou protótipo.
- **F8:** encerra a execução.
- **Ctrl+S:** salva a cena ou o recurso aberto.

Para jogar sem abrir o editor:

```powershell
& $env:GODOT_BIN --path .
```

Controles: A/D ou setas para andar, Espaço para pular/planar, Q para trocar de
personagem após liberar Pipo, E para sua investida e Esc para pausar.

## 4. Realizar alterações

Antes de começar, leia o [status do projeto](arquivos_projeto/12_status-do-projeto.md)
e o [plano de evolução](arquivos_projeto/14_etapas_evolucao.md). Aproveite as
implementações existentes e confira as decisões de gameplay antes de mudar regras.

| Onde alterar | Conteúdo |
| --- | --- |
| `scenes/characters/` e `scripts/characters/` | Personagens, movimento e habilidades |
| `scenes/levels/` | Cenas de fases e protótipos preservados |
| `scripts/systems/` | Construção das fases, campanha, HUD, save e controles |
| `scripts/objects/` e `scripts/enemies/` | Objetos, recompensas, obstáculos e inimigos |
| `scripts/presentation/` e `assets/` | Animações, apresentação, imagens e áudio |
| `web/` | Página do jogo, PWA, servidor e preparação do build Web |
| `tests/` | Testes automatizados e roteiros de validação |
| `arquivos_projeto/` | Regras, decisões, planejamento e andamento |

Parte das fases e interfaces é criada por código. Se um objeto não aparecer na
árvore da cena no editor, confira o script que o cria. A campanha atual usa
`expedition_campaign.gd`; vidas e Game Over estão nesse script, e o save da
campanha é validado por `expedition_save.gd`.

Fluxo sugerido para cada alteração:

1. Confira `git status` e, se desejar, crie uma branch com
   `git switch -c melhoria/nome-da-alteracao`.
2. Altere a cena, script ou recurso responsável. Preserve os comportamentos já
   aprovados e a leitura dos saves existentes.
3. Teste com F6 quando adequado e com F5 para verificar a integração à campanha.
4. Execute os testes relacionados, incluindo save e Web quando afetados.
5. Atualize a documentação da etapa e gere novamente os builds que serão testados.
6. Revise `git diff`, `git diff --check` e `git status` antes de decidir o que enviar.

Mantenha arquivos de texto em UTF-8. Versione os recursos-fonte e arquivos de
referência da Godot, como `.uid` e `.import`, quando gerados ou alterados pelo
editor. O cache `.godot/` fica fora do Git. Não edite apenas os arquivos dentro
de `builds/`: a próxima exportação irá substituí-los.

Commit e push são decisões manuais após a revisão. Os comandos deste guia não
criam commits nem enviam alterações ao remoto.

## 5. Executar os testes

Após importar o projeto, execute os testes relevantes. Este conjunto cobre
saúde, vidas, persistência da campanha e as animações dos personagens:

```powershell
& $env:GODOT_BIN --headless --path . --script tests/health_e01_test.gd
& $env:GODOT_BIN --headless --path . --script tests/lives_e02_test.gd
& $env:GODOT_BIN --headless --path . --script tests/checkpoints_e03_test.gd
& $env:GODOT_BIN --headless --path . --script tests/tutorial_e04_test.gd
& $env:GODOT_BIN --headless --path . --script tests/progress_e05_test.gd
& $env:GODOT_BIN --headless --path . --script tests/map_e06_test.gd
& $env:GODOT_BIN --headless --path . --script tests/expedition_save_test.gd
& $env:GODOT_BIN --headless --path . --script tests/run_animation_test.gd
& $env:GODOT_BIN --headless --path . --script tests/push_animation_test.gd
```

Execute um por vez: alguns testes históricos compartilham arquivos temporários.
Confira o resumo de falhas e `$LASTEXITCODE` após cada comando. Os testes acima
devem terminar sem falhas; um erro de script também precisa ser resolvido.

Para verificar o navegador, gere primeiro o build Web da seção seguinte e rode:

```powershell
npm.cmd run test:web
```

O Playwright inicia o servidor local se necessário e usa o **Chrome instalado**.
O teste padrão é `tests/browser/expedition.spec.js`. A variável `TICO_WEB_STAGE`
seleciona versões históricas; para testar a versão atual, remova-a se estiver definida:

```powershell
Remove-Item Env:TICO_WEB_STAGE -ErrorAction SilentlyContinue
```

Feche servidores de versões anteriores com Ctrl+C antes dos testes. A configuração
usa `127.0.0.1:8080` e pode reutilizar um servidor já aberto nessa porta.

Para medir o desempenho local com renderização, execute separadamente dos testes
e builds:

```powershell
New-Item -ItemType Directory -Force builds | Out-Null
& $env:GODOT_BIN --path . --script tests/map_e06_performance.gd
```

O relatório fica em `builds/performance-e06-windows.json`. Essa medição na máquina
de desenvolvimento não substitui o teste no celular.

## 6. Gerar e testar o build Web/PWA

Com `GODOT_BIN` configurado, dependências instaladas e templates disponíveis:

```powershell
npm.cmd run build:web
npm.cmd run serve:web
```

Saída atual: `builds/web/evolucao_e09/`.
Abra **http://127.0.0.1:8080/tico/** e clique em jogar. Ctrl+C encerra o servidor.

Sempre gere a Web com `build:web`: além da exportação da Godot, o script prepara
ícones, manifesto, service worker, versão do cache offline e `.htaccess`.
Não basta exportar somente pelo menu da Godot para reproduzir esse pacote.

O servidor serve o último build; alterações nos scripts do jogo exigem uma nova
execução de `build:web`. Não abra `index.html` diretamente pelo explorador de arquivos.
Para instalação e validação da PWA no celular, use a hospedagem HTTPS descrita em
[web/deployment.md](web/deployment.md).

## 7. Gerar o build Windows

```powershell
& $env:GODOT_BIN --headless --path . --editor --import --quit
New-Item -ItemType Directory -Force builds/windows/evolucao_e09 | Out-Null
& $env:GODOT_BIN --headless --path . --export-release 'Windows Desktop' 'builds/windows/evolucao_e09/Tico.exe'
```

Confira o console e `$LASTEXITCODE`. A pasta deve conter `Tico.exe` e `Tico.pck`.
Mantenha os dois juntos ao executar ou distribuir. Para abrir:

```powershell
& '.\builds\windows\evolucao_e09\Tico.exe'
```

Os presets ficam em `export_presets.cfg`. Atualmente existem presets para
**Windows Desktop** e **Web**; o Android nativo ainda não tem um fluxo de build
implementado neste projeto.

## 8. Criar os ZIPs para distribuição

Os comandos de build geram pastas, não ZIPs. Depois de testar as exportações,
use o bloco abaixo para criar pacotes com data e hora, sem substituir os anteriores:

```powershell
Add-Type -AssemblyName System.IO.Compression.FileSystem
$projectRoot = (Get-Location).Path
$buildStamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$webSource = Join-Path $projectRoot 'builds/web/evolucao_e09'
$windowsSource = Join-Path $projectRoot 'builds/windows/evolucao_e09'
$webZip = Join-Path $projectRoot "builds/web/Tico-E09-web-$buildStamp.zip"
$windowsZip = Join-Path $projectRoot "builds/windows/Tico-E09-windows-$buildStamp.zip"
[IO.Compression.ZipFile]::CreateFromDirectory($webSource, $webZip)
[IO.Compression.ZipFile]::CreateFromDirectory($windowsSource, $windowsZip)
Get-Item -LiteralPath $webZip, $windowsZip
```

O ZIP Web deve conter `index.html`, `.htaccess` e os demais recursos diretamente
na raiz, sem uma pasta `evolucao_e09` envolvendo os arquivos. Publique seu conteúdo
em `/tico/`, seguindo [o guia da HostGator](web/deployment.md).

Os ZIPs e as pastas de build são ignorados pelo Git. Um push do código não publica
o jogo na hospedagem nem transfere esses pacotes.

## 9. Saves e atualização de versão

O save não acompanha o clone:

- Windows: `%APPDATA%\Godot\app_userdata\Tico e a Floresta das Nozes\campaign.json`.
- Web: chave `tico.campaign.v1` no `localStorage` da origem usada pelo navegador.
  O site publicado e `localhost`/`127.0.0.1` têm armazenamentos separados.

O editor e o executável Windows usam o mesmo diretório de dados do jogo por padrão.
Faça uma cópia do save antes de testes manuais que reiniciem a aventura. Atualizar
os arquivos Web preserva o progresso; limpar os dados do site pode apagá-lo.

Ao criar uma nova versão, mantenha coerentes:

- `package.json` e `package-lock.json`;
- pastas de saída em `web/build.mjs`, `web/serve.mjs` e `export_presets.cfg`;
- nomes dos pacotes, README, este guia e documentação da etapa.

Para atualizar a versão npm sem criar commit ou tag, por exemplo:

```powershell
npm.cmd version 0.18.1 --no-git-tag-version
```

Execute esse comando apenas quando estiver preparando uma nova versão. O cache
da PWA é calculado pelo conteúdo do build; ele é renovado por `build:web`.

## 10. Resolver problemas comuns

| Problema | O que conferir |
| --- | --- |
| Godot não encontrada | `Test-Path $env:GODOT_BIN`; configure o executável console no terminal atual |
| Templates ausentes ou incompatíveis | Instale os templates 4.7.2 stable no gerenciador da Godot |
| Imagens ou recursos ausentes após clonar | Aguarde a importação; execute `--editor --import --quit` |
| `npm.ps1` bloqueado | Use `npm.cmd`, como nos exemplos |
| Teste Web não encontra navegador | Instale Google Chrome; o projeto está configurado com `channel: 'chrome'` |
| Página local retorna 404 | Gere o build Web e confira `http://127.0.0.1:8080/tico/` |
| Porta 8080 ocupada ou versão errada nos testes | Encerre o servidor antigo; confira `TICO_WEB_STAGE` |
| Alteração não aparece na Web | Refaça `build:web`, confira a pasta servida e feche/reabra as abas/PWA após a atualização |
| `git status` sem alterações listadas | Confira a pasta atual e se os arquivos foram salvos; `builds/` e caches são ignorados |

Antes de distribuir, faça também o [roteiro manual da E09](tests/evolucao_e09.md),
incluindo controles por toque, retorno após Game Over, save e retomada offline.
