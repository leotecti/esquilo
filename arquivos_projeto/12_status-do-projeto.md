# Status do projeto

**Data:** 2026-10-02
**Etapa atual:** Evolução E12 — Valda e progressão da história, versão 0.21.0.

**Próximo trabalho previsto:** validar os encontros de Valda no aparelho do
usuário e seguir para a introdução narrativa de Pipo na E13.

## Evolução E12 — Entrega atual

- Valda reaparece depois dos quatro confrontos decisivos da campanha.
- Cada encontro contextualiza a vitória, entrega uma pista e abre o mapa.
- Os encontros são persistentes, podem ser pulados e não se repetem em revisitas.
- A antiga chefe coruja da montanha foi substituída pelo Gavião da Montanha.
- Falas, cores, bico e expressão do Gavião foram atualizados.
- 24 verificações específicas cobrem narrativa, save, mapa e reabertura.

[Implementação e validação da E12](../tests/evolucao_e12.md).

## Evolução E11 — Entrega atual

- Abertura ilustrada do vilarejo até o mapa da jornada.
- Escassez de comida, exploração de Tico e área desconhecida apresentadas.
- Valda é resgatada, apresenta-se como mentora e convida Tico para ajudar o bosque.
- Tico explica sua busca por comida antes de aceitar a missão e receber a primeira pista.
- Título apresentado antes do mapa, com falas curtas e comunicação visual.
- Continuação e pulo funcionam com mouse, teclado e toque em landscape.
- Eventos `owl_rescued`, `first_clue_received` e `opening_complete` persistem.
- Campanhas anteriores abrem no mapa sem interrupção; nova aventura repõe a cena.
- 17 verificações Godot, 79 regressões de save e dois cenários Web aprovados.
- Ilustrações em 1280×720; cenas medidas com p95 de 17,30–18,32 ms no PC local.

[Implementação, validação e roteiro da E11](../tests/evolucao_e11.md).

## Evolução E10 — Entrega atual

- Diretor narrativo reutilizável baseado em passos de dados.
- Suporte a cena, diálogo, retrato, transição, evento e sinal de animação.
- Gameplay, HUD, comandos mantidos e controles de toque suspensos durante cenas.
- Botões grandes para continuar e pular, com restauração segura da partida.
- Eventos e sequências concluídas persistem no `story.events` do Save V2.
- Cenas concluídas não reaparecem automaticamente; reprodução explícita é possível.
- 14 verificações específicas e 79 regressões de save/progresso aprovadas.
- Exportações Web/PWA e Windows concluídas; cenário Web de save offline aprovado.

[Implementação, validação e roteiro da E10](../tests/evolucao_e10.md).
Nenhum conteúdo da abertura foi antecipado; ele pertence à E11.

## Fase modelo — Entrega atual

- Percurso principal de 42.000 unidades, com entrada da copa na metade.
- 245 nozes principais e 26 opcionais; contador de vida extra a cada 100 novas coletas.
- Uma única bandeira após a árvore; quatro corações na trilha e três na copa.
- Tamanho e duração aprovados pelo usuário. Retorno e acesso à árvore pelos dois lados revisados.
- Saúde cheia: coletar um coração concede uma vida, até o limite de 99.
- Solo redesenhado: textura contínua nas plataformas altas, laterais erodidas
  e transições sem áreas escuras retangulares.
- Saves V2 preservados, incluindo IDs antigos dos itens da copa deslocada.
- Recompensas não se repetem ao morrer ou salvar novamente. Em uma nova tentativa
  de fase concluída pelo mapa, nozes, alimentos e blocos de provisão podem ser recolhidos de novo.

[Entrega e playtest](../tests/primeiros_passos_modelo.md). Sem commit ou publicação automática.
[Padrão a aplicar nas demais fases](15_estrutura_fase_modelo.md).

## Evolução E09 — Entrega atual

- 271 nozes, 39 alimentos e 14 blocos de recompensa em Primeiros Passos.
- Maçãs, frutas silvestres e cenouras abastecem o contador do vilarejo.
- Duas Nozes Douradas opcionais, uma na trilha e outra na copa.
- Intervalo máximo de 540 unidades entre recompensas na fase ainda não coletada.
- Animações dos coletáveis atualizadas apenas perto da câmera.
- Saves V2 anteriores recebem contador de alimentos sem perder progresso.
- Ao rejogar Primeiros Passos pelo mapa, nozes, alimentos e blocos de provisão reaparecem e podem ser coletados para ganhar vidas e provisões novamente.
- Corações voltam na nova tentativa e curam ou concedem vida conforme a saúde; Nozes Douradas não duplicam o tesouro registrado.
- Entrada da árvore protegida por uma plataforma contínua; Tico e Pipo conseguem seguir nos dois sentidos.
- Cenoura redesenhada com corpo, contorno, folhas e detalhes de luz.

[Testes e roteiro da E09](../tests/evolucao_e09.md).

## Evolução E08 — Revisão anterior

- Área opcional em Primeiros Passos, acessível subindo os galhos da árvore.
- Copa ampliada para 4.000 unidades, com 26 nozes, uma vida extra, três lesmas,
  bandeira local e três portais de retorno.
- Caminho principal ampliado para 5.200 unidades, com 16 nozes e nova chegada.
- Bandeira principal preservada; morte, Game Over e reinício integrados.
- Save V2 compatível com campanhas anteriores e reabertura offline na copa.
- Arte e mecânicas existentes reaproveitadas; Pipo depende do resgate.

[Testes e roteiro](../tests/evolucao_e08.md). Sem commit ou publicação automática.

## Evolução E07 — Entrega anterior

- Resultado com nozes, Nozes Douradas registradas, vidas e segredo.
- Retorno ao mapa com seleção da próxima fase, inclusive entre mundos.
- Destaque animado de novos desbloqueios; entrada depende da seleção do jogador.
- Conclusão salva imediatamente e recuperada na reabertura offline.
- Última fase permite voltar ao mapa e rejogar sem perder conquistas.
- Mantidos os saves V2, os personagens e a arte da E06.

[Testes, pacotes e roteiro de validação](../tests/evolucao_e07.md).
Sem commit, push ou publicação automática.

## Evolução E06 — Entrega anterior

- Entrada pelo mapa ilustrado dos quatro mundos e suas 16 fases.
- Nós e caminhos com estados de bloqueio, disponibilidade, fase atual e conclusão.
- Seleção por teclado, mouse e toque; acesso também pela pausa e pelo resultado.
- Replay de fases concluídas preserva conquistas, vidas e Pipo desbloqueado.
- Game Over abre o mapa do mundo anterior com os demais desbloqueios mantidos.
- Save V2 e resultados existentes preservados; ampliação do resultado permanece na E07.

Versão 0.14.1: quatro fundos ilustrados, trilhas curvas, medalhões com cadeados
e bandeiras, Tico e Pipo junto da fase atual e navegação compacta por setas.
48 verificações Godot e oito cenários de navegador passaram nesta revisão.
[Testes, pacotes e roteiro de validação](../tests/evolucao_e06.md).
Sem commit ou publicação automática; aparência e desempenho no celular aguardam conferência.

## Evolução E05 — Entrega anterior

- Migração automática V1 → V2 no mesmo slot, preservando campanhas anteriores.
- Consulta de progresso com fase atual, disponíveis, concluídas, conquistas e personagens.
- Registros de Nozes Douradas por fase, eventos narrativos e estado do vilarejo.
- Resgate de Pipo, conclusões e guardiões inferidos a partir dos registros existentes.
- Saves danificados/futuros protegidos; falhas de armazenamento informadas.
- Mapa visual e distribuição de Nozes Douradas continuam nas próximas etapas.

Versão 0.13.0. [Testes, pacotes e roteiro de validação](../tests/evolucao_e05.md).
Sem commit ou publicação automática; aguarda teste do usuário no celular.

## Evolução E04 — Entrega anterior

- HUD mantém saúde, nozes, vidas, personagem e controles. Fase, save e nova aventura ficam na pausa.
- Placas existentes convertidas em dicas temporárias de proximidade, sem texto permanente no cenário.
- Cinco tutoriais principais: inimigo, coração, vida extra, planar e segredo.
- Dicas expiram, desaparecem após interação e não pausam nem capturam os controles.
- Dicas visualizadas persistem em save, replay e Game Over; nova aventura reinicia o tutorial.

Versão 0.12.0. [Testes, pacotes e roteiro de validação](../tests/evolucao_e04.md).
Sem commit ou publicação automática; aguarda teste do usuário no celular.

## Evolução E03 — Entrega anterior

- Bandeiras existentes preservadas, com retorno validado nas 16 fases.
- Personagem ativo retorna com saúde completa, proteção temporária e comandos liberados.
- Margem segura do Rio passa a acompanhar o checkpoint após uma derrota.
- **Reiniciar fase** no menu de pausa, com confirmação e cancelamento. Desativa a
  bandeira e mantém vidas, conquistas, Pipo, itens consumidos e caminhos abertos.
- Regras de inimigos, chefes, itens e áreas opcionais documentadas; saves anteriores mantidos.

Versão 0.11.0. [Testes, pacotes e roteiro de validação](../tests/evolucao_e03.md).
Sem commit ou publicação automática; aguarda teste do usuário no celular.

## Evolução E02 — Entrega anterior

- Três vidas compartilhadas e medalhões de vida extra, com coleta persistente.
- Derrota com vidas restantes usa o checkpoint existente. Game Over renova as vidas
  e oferece retorno à primeira fase do mundo anterior, preservando todas as fases liberadas.
- Tela transitória de seleção até o mapa da E06; Pipo resgatado acompanha os replays.
- Save compatível com campanhas anteriores; retorno pendente também funciona offline.
- Corrida, empurrão, saúde, controles e conteúdo existentes mantidos.

Versão 0.10.0. [Testes, pacotes e roteiro de validação](../tests/evolucao_e02.md).
Sem commit ou publicação automática; aguarda teste do usuário no celular.

**Marco 1 — Tico Playground:** aprovado pelo usuário após playtest

**Marco 2 — Tico PWA:** concluído; instalação, jogabilidade e offline aprovados

**Marco 3 — Tico Mini Game:** publicado e aprovado pelo usuário

**Marco 4 — Tico + Pipo:** concluído; controles, faro e percurso completo aprovados

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

Publicar e validar os mundos novos da etapa 9. O usuário aprovou o Mundo 1
e solicitou a expansão. As pendências históricas abaixo registram o aceite
específico de cada etapa, sem substituir o teste desta versão no aparelho.
O usuário confirmou os controles da etapa 5, a descoberta do segredo pelo faro
e o percurso até a chegada, encerrando a etapa 5 e o marco 4.
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
- [x] Usuário confirmou descoberta pelo faro e conclusão do puzzle até a chegada.

Cena: `scenes/levels/coop_trail.tscn`. Pacotes:
`builds/web/Tico-etapa-5-web.zip` e `builds/windows/Tico-etapa-5-windows.zip`.
Detalhes e roteiro: [testes da etapa 5](../tests/etapa_5.md).

## Etapa 6 — Entregas

- [x] Fase integrada: Tico, Pipo, 13 nozes, lesmas, três tipos de bloco e bloco pesado.
- [x] Pedra, passagem baixa, troca, investida, faro e segredo preservados.
- [x] Bandeira após a cooperação e três plataformas no desafio final até a árvore.
- [x] Pistas curtas no cenário; cenas anteriores preservadas.
- [x] Save automático versionado, retomada segura e conclusão persistente.
- [x] Reinício com confirmação; save danificado/futuro protegido de sobrescrita automática.
- [x] 185 verificações de engine (153 anteriores + 32 novas) aprovadas.
- [x] Dez cenários de Chrome aprovados, incluindo novo processo offline e atualização do worker.
- [x] Pacotes Web/Windows gerados; conteúdo dos ZIPs e execução Windows conferidos.
- [ ] Publicação e validação desta versão no aparelho real do usuário.
- [ ] Playtest estruturado: compreensão, diversão, dificuldade e cooperação.
- [ ] Aprovação do protótipo completo; a etapa 6 não acrescenta um marco numerado.

Cena: `scenes/levels/prototype_trail.tscn`. Pacotes da etapa 6 em `builds/`.
Registro técnico: [etapa 6](../tests/etapa_6.md).
Roteiro de observação: [playtest](../tests/playtest_etapa_6.md).
Alterações deixadas sem commit, conforme preferência do usuário.

## Etapa 7 — Entregas

- [x] Cena `vertical_slice.tscn`: Bosque das Folhas com fundo ilustrado e profundidade.
- [x] Arte de Tico, Pipo, lesma, nozes, blocos, pedra, vegetação e bandeira.
- [x] Poses de movimento, habilidades, dano e celebração; ciclos com variações e movimento procedural.
- [x] Música original em loop e efeitos pré-gerados de gameplay e interface.
- [x] HUD ilustrado, retrato do personagem, pausa, opções de áudio e controles touch.
- [x] Preferências persistentes e compatibilidade com saves da etapa 6.
- [x] Efeitos limitados em quantidade e recortes de atlas compartilhados.
- [x] 208 verificações de engine e 12 cenários de navegador aprovados.
- [x] Medições locais próximas de 60 FPS: p95 de 17,74 ms no Windows e 17,90 ms no Web desktop.
- [ ] Validar áudio, desempenho e legibilidade no Android/PWA real.
- [ ] Aprovar identidade visual, diversão e entendimento com jogadores.
- [ ] Aprovar marco 5 — Vertical Slice, antes da produção do Mundo 1.

Pacotes: `builds/web/Tico-etapa-7-web.zip` e
`builds/windows/Tico-etapa-7-windows.zip`. Detalhes: [etapa 7](../tests/etapa_7.md).
Arte e prompts: [assets do slice](../assets/slice/README.md).
As alterações desta etapa permanecem sem commit.

**Ajuste após o playtest do usuário:** Tico passa a demonstrar esforço ao tentar
empurrar a pedra. Pipo recebe um ciclo de passadas ao empurrá-la; os pés param
quando a pedra atinge o limite. As regras de força e movimento não mudam.

## Etapa 8 — Entregas

- [x] Fase 1-1 — Primeiros Passos: nozes, plataformas, lesmas, bandeira e chegada.
- [x] Fase 1-2 — Blocos e Segredos: três tipos de bloco, segredo opcional e ouriço.
- [x] Fase 1-3 — Um Novo Amigo: resgate jogável, breve diálogo e desbloqueio de Pipo.
- [x] Cooperação: pedra, passagem baixa, investida, faro e desafio final.
- [x] Guardião do Bosque mantido no escopo, em encontro ao final da fase 1-3.
- [x] Ataque anunciado, abertura para salto/investida, três acertos e encerramento amigável.
- [x] Transição entre fases e conclusão persistente do mundo.
- [x] Save próprio versionado; slot do protótipo preservado e preferências aproveitadas.
- [x] Reinício com confirmação; dados danificados ou futuros protegidos.
- [x] 175 verificações na Godot e quatro cenários Web aprovados, incluindo campanha completa e reabertura offline.
- [x] Multitoque: percurso de 1-1, resgate, troca, esforço de Tico e passadas de Pipo.
- [x] Execução gráfica Windows e conteúdo dos ZIPs Web/Windows conferidos.
- [x] Usuário confirmou: “etapa 8 testada e aprovada. Ficou muito bom.”
- [x] Marco 6 — Mundo 1 Completo aprovado pelo usuário.

Aceite registrado em 2026-09-30. O retorno confirma a aprovação geral da etapa;
não detalha aparelho, medição de FPS ou execução individual de cada item do roteiro.

Implementação e validação: [etapa 8](../tests/etapa_8.md).
Pacotes: `builds/web/Tico-etapa-8-web.zip` e `builds/windows/Tico-etapa-8-windows.zip`.
Avanço autorizado pelo usuário; as pendências de playtest anteriores permanecem registradas.
Nenhum commit ou push feito nesta entrega.

## Etapa 9 — Entregas

- [x] Rio das Pedras: três fases, água, troncos, ponte, plataformas móveis e Guardião.
- [x] Montanha das Corujas: três fases, vento, cavernas, altura, inimigos aéreos e Coruja.
- [x] Vila dos Castores: três fases, peso, investida, elevadores, comporta e Rei Castor.
- [x] Primeira fase de cada mundo validada antes da produção das seguintes.
- [x] Campanha contínua de quatro mundos; save do Bosque importado e preservado.
- [x] Mecanismos, checkpoints, nozes, segredo e conclusões persistentes.
- [x] 349 verificações na Godot aprovadas, incluindo regressão do Bosque e dos controles.
- [x] Exportações Web/PWA e Windows e medição gráfica local.
- [x] Cinco cenários Web aprovados: migração, Rio offline, Montanha, toque na Vila, comporta e proteção do save.
- [ ] Publicação e playtest desta versão no aparelho do usuário.
- [ ] Aceite de dificuldade, visual e fluidez dos mundos novos.

Detalhes, testes Web e roteiro: [etapa 9](../tests/etapa_9.md).
Pacotes: `builds/web/Tico-etapa-9-web.zip` e `builds/windows/Tico-etapa-9-windows.zip`.
Nenhum commit ou push realizado. O Mundo 5 permanece para a etapa 10.

## Decisões ainda abertas

Resolução artística definitiva, parâmetros de movimento, duração do planar,
corações, layout touch, quantidade de chefes e inclusão de Android nativo
na versão 1.0 continuam sujeitos aos protótipos e testes previstos.

## Evolução — decisões documentadas

Revisão aprovada pelo usuário: E00–E30, preservação dos sistemas existentes, Coruja mentora, Gavião como chefe aéreo, Pipo global após o resgate, Game Over no mapa do mundo anterior com desbloqueios preservados, duração a validar e verificações contínuas de PWA/desempenho/save.

Documentação alinhada; alterações no código ainda pendentes. O build da etapa 9 ainda tem a antiga chefe Coruja e não possui mapa, vidas limitadas ou replay global com Pipo. Não considerar essas funcionalidades implementadas por esta revisão. Ver DEC-115.

## Evolução E00 — Concluída

- [x] Inventário dos sistemas, componentes reutilizáveis e dependências.
- [x] Inspeção de controles, colisões, inimigos, HUD, fases, progresso e PWA.
- [x] Classificação manter/alterar/remover/criar e identificação dos textos fixos.
- [x] Pontos de migração para Pipo global, replay, vidas e mapa registrados.
- [x] 182 verificações Godot e cinco cenários Web aprovados nesta execução.
- [x] Medição local: medianas de 16,59–16,74 ms; p95 de 17,50–18,19 ms.

Entregas: [diagnóstico E00](15_diagnostico_e00.md) e
[registro de validação](../tests/evolucao_e00.md).
Gameplay preservado; nenhum commit ou push realizado.

## Evolução E01 — Entregas

- [x] Saúde, dano, recuperação, HUD, invulnerabilidade e derrota existentes revisados.
- [x] Três corações, controles, habilidades, proteção e retorno à bandeira preservados.
- [x] Coração pode recuperar saúde sem exigir sair e reentrar na área após dano.
- [x] Recuperação rejeita valores inválidos e personagem inativo/derrotado.
- [x] 195 verificações Godot aprovadas, incluindo 20 verificações específicas.
- [x] Cinco cenários Web aprovados; Windows executado e pacotes conferidos.
- [x] Amostra gráfica local e compatibilidade do save verificadas.
- [ ] Playtest desta versão no aparelho do usuário.

Registro, validação Web e pacotes: [evolução E01](../tests/evolucao_e01.md).
Vidas limitadas, Game Over e mapa não foram antecipados. Sem commit ou push.

**Correção após teste do usuário (0.9.2):** corrida de Tico e Pipo recebe quatro
poses com movimento visível das pernas e ciclo proporcional ao deslocamento.
Animações de empurrar e regras físicas mantidas. Pacotes E01 atualizados;
detalhes em [evolução E01](../tests/evolucao_e01.md).
