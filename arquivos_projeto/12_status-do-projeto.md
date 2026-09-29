# Status do projeto

**Data:** 2026-09-29  
**Etapa atual:** 3 — Web, touch e PWA: implementação local

**Próximo trabalho:** publicar em HTTPS e validar instalação/offline no celular

**Marco 1 — Tico Playground:** aprovado pelo usuário após playtest

**Marco 2 — Tico PWA:** aguarda validação em celular físico

## Etapa 0 — Entregas

- [x] Documentação em Markdown com referências e numeração alinhadas.
- [x] Marcos de arquitetura alinhados aos oito marcos do roadmap.
- [x] Distinção entre cena vazia, protótipo completo, MVP e vertical slice.
- [x] Referências visuais documentadas e preservadas em `img/`.
- [x] Godot 4.7.2 stable, edição padrão, instalada e executada.
- [x] Download conferido com SHA512 publicado no release oficial.
- [x] Git 2.53.0.windows.2 disponível; repositório local na branch `main`.
- [x] Projeto 2D com Compatibility, referência 1280 × 720 e landscape.
- [x] Input Map inicial com seis ações e teclas cadastradas.
- [x] Estrutura de diretórios, `.gitignore`, `.gitattributes` e `.editorconfig`.
- [x] Cena principal vazia `scenes/main.tscn` carregada e executada.
- [x] Cena e configurações salvas pela Godot e carregadas novamente.
- [x] Primeiro commit local: `chore: prepara projeto Godot e unifica documentacao`.

## Ambiente preparado

Instalação atual escolhida pelo usuário: `D:\Godot\Godot_v4.7.2-stable`.
Versão executada: `4.7.2.stable.official.ed1daf0bf`.

A versão e a execução headless da cena vazia foram verificadas novamente
nesse caminho. A cópia preparada na etapa 0 em
`%LOCALAPPDATA%\Programs\Godot\4.7.2` foi preservada; os comandos do README
passam a usar a instalação em `D:\Godot`.

Editor de código inicial: editor integrado da Godot; VS Code também encontrado.
Navegadores Chrome e Edge disponíveis. Git já possuía identidade configurada,
que foi preservada. Nenhum repositório remoto foi configurado.

Templates Windows x86_64 4.7.2 stable instalados em
`%APPDATA%\Godot\export_templates\4.7.2.stable`, após verificação SHA512 do
pacote oficial. Os templates Web da mesma versão também foram instalados.

O SDK/JDK para Android nativo e ferramentas gráficas adicionais serão
preparados quando essas atividades começarem. A etapa 3 inclui testes de
navegador e toque emulado; o celular físico ainda precisa ser validado.

## Etapa 1 — Entregas

- [x] Resolução, proporção, orientação e input da etapa 0 mantidos.
- [x] Física a 60 ticks/s, gravidade provisória de 1200 px/s².
- [x] Dez camadas de colisão nomeadas conforme a arquitetura.
- [x] Grupos iniciais `world`, `player` e `spawn_points`.
- [x] `test_level.tscn` com chão, paredes, três plataformas e ponto inicial.
- [x] Corpo provisório para validar teclado, salto e colisões.
- [x] Diagnóstico de E/Q e pausa por Esc.
- [x] Dezesseis verificações de integração aprovadas.
- [x] Preset Windows versionado e exportação x86_64 de desenvolvimento gerada.
- [x] Executável testado fora da pasta do projeto, sem erros.

Build: `builds/windows/etapa_1/Tico.exe` acompanhado de `Tico.pck`.
Pacote: `builds/windows/Tico-etapa-1-windows.zip`.
O retângulo de teste não representa o controlador final nem a arte de Tico.

## Validação

### Etapas 0 e 1

Importação no editor, execução headless, execução gráfica com Compatibility,
salvamento e reabertura concluídos sem erros. As teclas do Input Map foram
conferidas pela própria engine, incluindo as setas esquerda e direita.

Detalhes: [registro da etapa 0](../tests/etapa_0.md).

Na etapa 1, os testes de teclado, chão, paredes, plataformas, salto e pausa
passaram. O build Windows executou com Compatibility / OpenGL 3.3 na Intel
Iris Xe. A captura da cena foi inspecionada visualmente.
Detalhes: [registro da etapa 1](../tests/etapa_1.md).

## Próximo trabalho previsto

Publicar o pacote Web em `https://projetosdoleo.com/tico/` e executar o roteiro
de instalação, conforto dos controles e reabertura offline em celular físico.
O endereço foi informado; o serviço e o método de envio ainda não foram informados.

## Etapa 2 — Entregas

- [x] `tico.tscn` e `tico.gd`, com parâmetros configuráveis.
- [x] Movimento com aceleração, desaceleração, controle aéreo e direção visual.
- [x] Salto de altura variável, coyote time e jump buffer.
- [x] Planar na queda, mantendo Espaço, por até 2 segundos; recarga no chão.
- [x] Animações provisórias idle, run, jump, fall, glide e land; 11 quadros SVG.
- [x] Playground de 3800 × 900, subida gradual, travessia longa e chão seguro.
- [x] Câmera suave, antecipação horizontal e limites.
- [x] Pausa, pausa ao perder foco e botão Recomeçar.
- [x] 45 verificações de Tico e 16 de regressão aprovadas.
- [x] Build Windows executado fora do projeto e capturas inspecionadas.
- [x] Playtest humano: usuário testou, considerou bem jogável e aprovou avançar.

Build atual: `builds/windows/etapa_2/Tico.exe` com `Tico.pck`.
Pacote: `builds/windows/Tico-etapa-2-windows.zip`.
Registro: [testes da etapa 2](../tests/etapa_2.md).

A cena principal agora abre o playground de Tico. A área e o build da etapa 1
foram preservados. A arte vetorial é provisória; Pipo, inimigos, coleta,
áudio ainda não fazem parte deste playground. Touch e Web/PWA foram adicionados
na etapa 3, sem alterar os parâmetros de movimento aprovados.

## Etapa 3 — Entregas

- [x] Exportação Web sem threads, shell em português e caminhos relativos a `/tico/`.
- [x] Botões multitoque de direção, pulo/planar e ação reservada.
- [x] Layout landscape, áreas seguras, pausa em retrato e tela cheia.
- [x] Manifesto, ícones, cache versionado e botão de atualização.
- [x] Scripts de build, servidor local e testes de navegador reproduzíveis.
- [ ] Publicação no endereço HTTPS informado.
- [ ] Instalação pelo navegador, abertura pelo ícone e offline no celular físico.
- [ ] Aprovação de conforto, visibilidade e desempenho no celular.

Pacote: `builds/web/Tico-etapa-3-web.zip`.
Detalhes: [testes da etapa 3](../tests/etapa_3.md) e
[publicação](../web/deployment.md).

## Decisões ainda abertas

Resolução artística definitiva, parâmetros de movimento, duração do planar,
corações, layout touch, quantidade de chefes e inclusão de Android nativo
na versão 1.0 continuam sujeitos aos protótipos e testes previstos.
