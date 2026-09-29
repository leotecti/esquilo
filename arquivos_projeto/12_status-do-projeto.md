# Status do projeto

**Data:** 2026-09-29  
**Etapa atual:** 5 — Pipo: implementação e testes técnicos concluídos

**Próximo trabalho:** confirmar faro e conclusão do puzzle no playtest da etapa 5

**Marco 1 — Tico Playground:** aprovado pelo usuário após playtest

**Marco 2 — Tico PWA:** concluído; instalação, jogabilidade e offline aprovados

**Marco 3 — Tico Mini Game:** publicado e aprovado pelo usuário

**Marco 4 — Tico + Pipo:** controles aprovados pelo usuário; faro e percurso completo aguardam confirmação

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
navegador e toque emulado; o usuário também aprovou instalação, jogabilidade
e offline da etapa 3 no aparelho. A etapa 4 também foi publicada e aprovada.
Na etapa 5, o usuário confirmou acesso, corrida, salto, troca, empurrar e ação.

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

Publicar o pacote da etapa 5 e jogar a Trilha da Amizade no celular.
Avaliar se fica claro quando usar cada personagem e se Trocar/INVESTIR são
confortáveis. Depois, etapa 6 — Protótipo completo, conforme o roadmap.
O usuário confirmou upload na HostGator, acesso, instalação da PWA e
jogabilidade muito boa em `https://projetosdoleo.com/tico/`. Também confirmou
o teste offline no aparelho, encerrando a etapa 3 e o marco 2.

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

Build preservado da etapa 2: `builds/windows/etapa_2/Tico.exe` com `Tico.pck`.
Pacote: `builds/windows/Tico-etapa-2-windows.zip`.
Registro: [testes da etapa 2](../tests/etapa_2.md).

Na etapa 2, a cena principal passou a abrir o playground de Tico. A área e o build da etapa 1
foram preservados. A arte vetorial é provisória; Pipo, inimigos, coleta,
áudio ainda não fazem parte deste playground. Touch e Web/PWA foram adicionados
na etapa 3, sem alterar os parâmetros de movimento aprovados.

## Etapa 3 — Entregas

- [x] Exportação Web sem threads, shell em português e caminhos relativos a `/tico/`.
- [x] Botões multitoque de direção, pulo/planar e ação reservada.
- [x] Layout landscape, áreas seguras, pausa em retrato e tela cheia.
- [x] Manifesto, ícones, cache versionado e botão de atualização.
- [x] Scripts de build, servidor local e testes de navegador reproduzíveis.
- [x] Publicação no endereço HTTPS informado, confirmada pelo usuário.
- [x] Acesso e instalação da PWA confirmados pelo usuário.
- [x] Jogabilidade aprovada pelo usuário: “muito boa”.
- [x] Fechar e reabrir pelo ícone sem conexão no celular físico: teste confirmado pelo usuário.

O retorno aprova a experiência de jogo; não foi fornecida medição de FPS.

Pacote: `builds/web/Tico-etapa-3-web.zip`.
Detalhes: [testes da etapa 3](../tests/etapa_3.md) e
[publicação](../web/deployment.md).

## Etapa 4 — Entregas

- [x] Três corações, dano, reação, proteção temporária, recuperação e derrota.
- [x] Lesma com patrulha, viradas, dano lateral, pisão e saída amigável.
- [x] Nozes com som, feedback visual, contagem e prevenção de coleta duplicada.
- [x] HUD de corações e nozes, adaptado a teclado e toque.
- [x] Blocos comum, quebrável e de noz, acionados por cabeçada.
- [x] Checkpoint, retorno com vida restaurada e regras de reinício definidas.
- [x] Chegada com controles bloqueados, comemoração, resultado e nova partida.
- [x] Fase percorrida do início ao fim nos testes de engine e navegador.
- [x] 99 verificações de engine e quatro cenários de navegador aprovados.
- [x] Pacotes Web e Windows da etapa 4 preparados.
- [x] Usuário publicou a etapa 4 e confirmou que funcionou muito bem.

Cena: `scenes/levels/tico_minigame.tscn`. O playground continua disponível
separadamente. Os builds antigos foram preservados. A fase tem 14 nozes
opcionais, três lesmas, um item de recuperação, uma bandeira e uma chegada.
Detalhes: [testes da etapa 4](../tests/etapa_4.md).

## Etapa 5 — Entregas

- [x] `pipo.tscn` e `pipo.gd`, arte provisória com camisa verde e referência preservada.
- [x] Movimento mais pesado: velocidade e salto menores; Pipo não plana.
- [x] Pedra empurrável somente por Pipo, com limite de deslocamento.
- [x] Bloco pesado quebrável somente pela investida de Pipo.
- [x] Preparação, avanço, impacto e recuperação, com postura, som e fragmentos.
- [x] Faro automático, pista direcional em partículas e noz escondida.
- [x] Q/Trocar, câmera e HUD do personagem ativo, vida e contador compartilhados.
- [x] Verificação de espaço na troca; personagem inativo sem colisão ou controle.
- [x] Puzzle: empurrar a pedra, abrir o portão e atravessar com Tico.
- [x] Checkpoint, derrota, reinício e resultado adaptados à dupla.
- [x] 54 testes novos de integração e 99 verificações anteriores aprovados.
- [x] Cinco cenários de navegador, incluindo troca e investida por multitoque.
- [x] Usuário confirmou acesso e funcionamento de corrida, salto, troca, empurrar e ação.
- [ ] Confirmar faro e conclusão do puzzle no playtest; aparelho não informado.

Cena: `scenes/levels/coop_trail.tscn`. Pacotes:
`builds/web/Tico-etapa-5-web.zip` e `builds/windows/Tico-etapa-5-windows.zip`.
Detalhes e roteiro: [testes da etapa 5](../tests/etapa_5.md).

## Decisões ainda abertas

Resolução artística definitiva, parâmetros de movimento, duração do planar,
corações, layout touch, quantidade de chefes e inclusão de Android nativo
na versão 1.0 continuam sujeitos aos protótipos e testes previstos.
