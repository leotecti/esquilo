# Status do projeto

**Data:** 2026-10-06
**VersÃ£o atual:** 0.34.3, com as correÃ§Ãµes localizadas de 1-2 e 1-3, o localizador de
mapa, a fase 1-3 ampliada e a Gruta Fria opcional.

**CorreÃ§Ãµes 1-2 em 0.33.2:** o besouro inicial apoia visualmente as patas no
solo; os blocos suspensos ficam ao alcance de um salto normal; e os oito
inimigos da rota ampliada patrulham sobre superfÃ­cies visÃ­veis.

**CorreÃ§Ãµes 1-2 em 0.33.3:** o encontro de T03 foi levado para a plataforma
percorrida e os blocos de T03 e T04 agora seguem a altura do prÃ³prio degrau,
mantendo a face inferior ao alcance do salto normal.

**CorreÃ§Ãµes 1-2 em 0.33.4:** os porcos-espinhos acompanham as plataformas da
rota, inclusive em T04 e T06. O bloco secreto de T05 foi colocado ao alcance
do salto normal.

**CorreÃ§Ãµes 1-2 em 0.33.5:** a fruta de T07 e as cinco frutas da Galeria das
Pedras acompanham as superfÃ­cies visÃ­veis e podem ser coletadas pelo jogador.

**CorreÃ§Ãµes 1-2 em 0.33.6:** as trÃªs lesmas da Galeria das Pedras patrulham as
plataformas acessÃ­veis. As frutas de T04 e T05 permanecem alinhadas Ã s mesmas
superfÃ­cies.

**CorreÃ§Ãµes 1-2 em 0.33.7:** os blocos de T08 possuem margem adicional para a
cabeÃ§ada. Os besouros receberam alinhamento mais preciso das patas com o solo;
os itens e inimigos anteriormente corrigidos em T05 e T09 tÃªm testes prÃ³prios.

**CorreÃ§Ãµes 1-2 em 0.33.8:** a recompensa dourada de T10 e a fruta da chegada
em T12 ficam acessÃ­veis. Os blocos de T12 receberam margem adicional e os
inimigos de T11/T12 tÃªm posiÃ§Ãµes protegidas por testes.

**CorreÃ§Ãµes 1-2 em 0.33.9:** recompensas procedurais duplicadas sob as
plataformas dos portais foram removidas. As recompensas posicionadas sobre as
superfÃ­cies da Galeria e da chegada foram preservadas.

**CorreÃ§Ã£o 1-2 em 0.33.10:** o lado direito do portal da Galeria possui degraus
atravessÃ¡veis em `y=700` e `y=630`. Uma queda em T06 permite retornar Ã 
plataforma da saÃ­da em `y=570`.

**CorreÃ§Ãµes 1-3 em 0.34.3:** os oito inimigos acompanham as plataformas da rota;
o bloco fora do padrÃ£o fica no solo e quebra com a caudada; recompensas
soterradas no tÃºnel foram substituÃ­das; e o portal recebeu acabamento mineral,
luz, partÃ­culas e nÃ©voa.

**Localizador 0.33.1:** F3 no computador ou trÃªs toques no tÃ­tulo da fase exibem
fase, Ã¡rea, trecho e coordenadas X/Y. O botÃ£o de cÃ³pia produz uma referÃªncia como
`Fase 1-3 | Gruta Fria | T03 | X 67420 | Y 635`. O painel inicia oculto e nÃ£o
altera o save.

**ExpansÃ£o de 1-3:** Um Novo Amigo preserva o resgate de Pipo e passa a ter
38.000 unidades. A Gruta Fria possui entrada por tÃºnel, morcegos, estalactites,
goteiras com aviso e dano, recompensas prÃ³prias e saÃ­da prÃ³xima da bandeira.
Foram aprovadas 12 verificaÃ§Ãµes especÃ­ficas, 15 da narrativa, 73 de save e 17
da expansÃ£o anterior.

**Identidade visual 0.32.1:** o PWA, o Ã­cone da janela e o executÃ¡vel Windows
agora usam o Tico ilustrado atual. A abertura Web, a instalaÃ§Ã£o, a atualizaÃ§Ã£o e
a pÃ¡gina offline compartilham a paleta verde-floresta, creme, Ã¢mbar e laranja.

**CorreÃ§Ã£o visual atual:** a caudada foi refeita como giro corporal completo em
seis poses, com o impacto sincronizado Ã  passagem frontal da cauda.

**Etapa atual:** E22 â€” balanceamento concluÃ­do com um Ãºnico perfil acessÃ­vel.

**PrÃ³ximo trabalho previsto:** validar o ritmo completo no aparelho e avanÃ§ar
para a E23 â€” testes com crianÃ§as.

## EvoluÃ§Ã£o E22 â€” Entrega atual

- SaÃºde, vidas, economia, movimento, inimigos, chefes e metas da fase modelo
  foram reunidos em `scripts/systems/game_balance.gd`.
- Permanecem trÃªs coraÃ§Ãµes, trÃªs vidas iniciais e uma vida a cada 100 nozes.
- Chefes exigem trÃªs acertos e mantÃªm aviso mÃ­nimo de um segundo e oportunidade
  de ataque superior a 3,5 segundos.
- Primeiros Passos mantÃ©m a meta aprovada de 5 a 8 minutos, checkpoint depois
  da metade e oferta frequente de recuperaÃ§Ã£o, alimentos e nozes.
- Os nÃ­veis fÃ¡cil, mÃ©dio e difÃ­cil continuam adiados atÃ© a fase modelo estar
  totalmente validada.
- 12 verificaÃ§Ãµes especÃ­ficas e 141 verificaÃ§Ãµes de regressÃ£o foram aprovadas.

[ImplementaÃ§Ã£o e roteiro de playtest](../tests/evolucao_e22.md).

## EvoluÃ§Ã£o E19 â€” Entrega atual

- O mapa possui acesso permanente por **Visitar vilarejo**.
- Escassez, recuperaÃ§Ã£o, preparaÃ§Ã£o e celebraÃ§Ã£o respondem ao Save V2.
- Cestos, provisÃµes, moradores, luz, bandeirolas e partÃ­culas mudam gradualmente.
- Alimentos de revisitas ajudam a recuperaÃ§Ã£o; a celebraÃ§Ã£o exige a vitÃ³ria final.
- A tela respeita toque, teclado, tela cheia e Ã¡reas seguras dos celulares.
- 11 verificaÃ§Ãµes especÃ­ficas foram aprovadas.

[ImplementaÃ§Ã£o e roteiro de playtest](../tests/evolucao_e19.md).

## EvoluÃ§Ã£o E18 â€” Entrega atual

- Periquito do Bosque, GuardiÃ£o do Rio, GaviÃ£o da Montanha e Rei Castor possuem
  trÃªs momentos distintos.
- Cada acerto amplia a Ã¡rea perigosa e acelera o prÃ³ximo aviso.
- A oportunidade de ataque permanece entre 3,6 e 4 segundos.
- O Periquito do Bosque possui quatro poses ilustradas: voo, aviso, golpe de asas
  e pouso cansado. Sua rajada desperta as raÃ­zes usadas no primeiro confronto.
- Ele patrulha no ar, persegue o personagem ativo e mergulha sobre Tico ou Pipo.
- Somente pulos na cabeÃ§a durante o pouso cansado causam dano; sÃ£o necessÃ¡rios trÃªs.
- O pouso preserva o ponto final do mergulho. A pose e a respiraÃ§Ã£o mostram esforÃ§o
  fÃ­sico sem transmitir tristeza, dando ao jogador uma oportunidade previsÃ­vel.
- A cabeÃ§a fica abaixada e marcada durante a recuperaÃ§Ã£o; saltos normais sobre a
  ilustraÃ§Ã£o acionam a vulnerabilidade sem exigir alinhamento exato dos centros.
- O terceiro pulo inicia queda, desaparecimento e corrida automÃ¡tica do personagem
  ativo atÃ© o portal que encerra a fase.
- As arenas retomam raÃ­zes, correnteza, vento, planeio, mecanismos e elevadores.
- Valda continua exclusivamente como mentora.
- 41 verificaÃ§Ãµes especÃ­ficas, 19 confrontos completos por comandos, 10 regras e
  35 verificaÃ§Ãµes da aventura completa foram aprovadas.

[ImplementaÃ§Ã£o e roteiro de playtest](../tests/evolucao_e18.md).

## EvoluÃ§Ã£o E17 â€” Entrega atual

- Seis inimigos receberam ilustraÃ§Ãµes comerciais com fundo transparente.
- O porco-espinho ganhou espinhos volumosos e silhueta defensiva legÃ­vel.
- Besouro acelera, aranha move-se verticalmente e corvo persegue a curta distÃ¢ncia.
- Lesma e morcego preservam seus papÃ©is, agora no mesmo padrÃ£o artÃ­stico.
- Os seis inimigos possuem ciclos de quatro quadros para rastejo, passos ou voo.
- Inimigos terrestres mantÃªm os pÃ©s no solo; morcego e corvo articulam as asas.
- A aranha desce da teia atÃ© a faixa do personagem e retorna ao alto, abrindo
  uma janela segura de travessia.
- Primeiros Passos continua ensinando somente a lesma.
- 41 verificaÃ§Ãµes especÃ­ficas, 20 da E16, 10 de regras e 35 da aventura completa
  foram aprovadas.

[ImplementaÃ§Ã£o e roteiro de playtest](../tests/evolucao_e17.md).

## EvoluÃ§Ã£o E16 â€” Entrega atual

- Primeiros Passos foi dividida em Aprender, Praticar, Combinar e Desafiar.
- Cada faixa mantÃ©m duas lesmas isoladas; a velocidade progride de 45 para 50 e 55.
- A chegada permanece sem inimigos para encerrar a fase com clareza.
- Geometria, recompensas, copa, bandeira, Save V2 e duraÃ§Ã£o foram preservados.
- 20 verificaÃ§Ãµes especÃ­ficas, 24 da fase modelo, 4 de navegaÃ§Ã£o e 35 da aventura
  completa foram aprovadas.
- FÃ¡cil, MÃ©dio e DifÃ­cil serÃ£o definidos depois do aceite final desta fase.

[ImplementaÃ§Ã£o e roteiro de playtest](../tests/evolucao_e16.md).

## ValidaÃ§Ã£o intermediÃ¡ria 2 â€” Entrega atual

- O Mundo 1 representa a campanha completa em escala reduzida.
- Abertura, Valda, mapa, trÃªs fases e confronto final formam um fluxo contÃ­nuo.
- A Copa dos Segredos valida exploraÃ§Ã£o opcional e conquistas permanentes.
- Pipo Ã© apresentado, resgatado, usado em cooperaÃ§Ã£o e preservado globalmente.
- O chefe impede a saÃ­da atÃ© ser resolvido e libera a prÃ³xima pista narrativa.
- O Rio Ã© desbloqueado no mapa ao concluir o arco.
- Save V2 preserva cenas, fases, Pipo e Noz Dourada ao reabrir.
- 35 verificaÃ§Ãµes integradas foram aprovadas.

[RelatÃ³rio e roteiro](../tests/validacao_intermediaria_2.md).

## EvoluÃ§Ã£o E15 â€” Entrega atual

- Fases 1-1 e 1-2 ganham trechos cooperativos somente nas revisitas apÃ³s o resgate.
- Pipo empurra a pedra atÃ© a marca e abre uma passagem estreita para Tico.
- Cada trecho entrega uma Noz Dourada permanente e nÃ£o bloqueia a saÃ­da da fase.
- Abertura do mecanismo, recompensa e desbloqueio de Pipo persistem no Save V2.
- Primeira passagem, morte, Game Over, mapa e recompensas existentes foram preservados.
- 13 verificaÃ§Ãµes especÃ­ficas cobrem disponibilidade, puzzle, coleta e persistÃªncia.

[ImplementaÃ§Ã£o e validaÃ§Ã£o da E15](../tests/evolucao_e15.md).

## EvoluÃ§Ã£o E14 â€” Entrega atual

- Tico usa **E/CAUDADA** no chÃ£o contra inimigos comuns.
- Seis poses mostram preparaÃ§Ã£o, giro corporal, impacto e recuperaÃ§Ã£o.
- Alcance frontal curto, bloqueio por paredes e um acerto por alvo em cada golpe.
- Dano, derrota, retorno e conclusÃ£o cancelam a aÃ§Ã£o com seguranÃ§a.
- Lesmas e inimigos voadores recebem o golpe; espinhos e chefes nÃ£o recebem.
- Pedras, paredes pesadas e mecanismos continuam exclusivos de Pipo.
- Pipo mantÃ©m **INVESTIR**, empurrÃ£o, faro e mecanismos de peso.
- Nova dica contextual Ã© migrada para saves existentes.
- 15 verificaÃ§Ãµes especÃ­ficas cobrem os alvos, cancelamentos e controles.

[ImplementaÃ§Ã£o e validaÃ§Ã£o da E14](../tests/evolucao_e14.md).

## EvoluÃ§Ã£o E13 â€” Entrega atual

- Pipo Ã© apresentado na fase 1-3 antes do resgate jogÃ¡vel.
- A falta de comida da famÃ­lia dele conecta sua histÃ³ria Ã  missÃ£o de Tico e Valda.
- O diÃ¡logo apÃ³s o resgate explica por que Pipo entra na equipe.
- Uma demonstraÃ§Ã£o visual apresenta forÃ§a de Pipo e agilidade de Tico.
- O percurso cooperativo existente permanece como demonstraÃ§Ã£o jogÃ¡vel.
- Pipo continua bloqueado antes do resgate e globalmente liberado depois dele.
- Saves antigos preservam o resgate sem apresentar uma cena retroativa.
- 15 verificaÃ§Ãµes especÃ­ficas cobrem narrativa, gameplay, save e revisitas.

[ImplementaÃ§Ã£o e validaÃ§Ã£o da E13](../tests/evolucao_e13.md).

## EvoluÃ§Ã£o E12 â€” Entrega atual

- Valda reaparece depois dos quatro confrontos decisivos da campanha.
- Cada encontro contextualiza a vitÃ³ria, entrega uma pista e abre o mapa.
- Os encontros sÃ£o persistentes, podem ser pulados e nÃ£o se repetem em revisitas.
- A antiga chefe coruja da montanha foi substituÃ­da pelo GaviÃ£o da Montanha.
- Falas, cores, bico e expressÃ£o do GaviÃ£o foram atualizados.
- 24 verificaÃ§Ãµes especÃ­ficas cobrem narrativa, save, mapa e reabertura.

[ImplementaÃ§Ã£o e validaÃ§Ã£o da E12](../tests/evolucao_e12.md).

## EvoluÃ§Ã£o E11 â€” Entrega atual

- Abertura ilustrada do vilarejo atÃ© o mapa da jornada.
- Escassez de comida, exploraÃ§Ã£o de Tico e Ã¡rea desconhecida apresentadas.
- Valda Ã© resgatada, apresenta-se como mentora e convida Tico para ajudar o bosque.
- Tico explica sua busca por comida antes de aceitar a missÃ£o e receber a primeira pista.
- TÃ­tulo apresentado antes do mapa, com falas curtas e comunicaÃ§Ã£o visual.
- ContinuaÃ§Ã£o e pulo funcionam com mouse, teclado e toque em landscape.
- Eventos `owl_rescued`, `first_clue_received` e `opening_complete` persistem.
- Campanhas anteriores abrem no mapa sem interrupÃ§Ã£o; nova aventura repÃµe a cena.
- 17 verificaÃ§Ãµes Godot, 79 regressÃµes de save e dois cenÃ¡rios Web aprovados.
- IlustraÃ§Ãµes em 1280Ã—720; cenas medidas com p95 de 17,30â€“18,32 ms no PC local.

[ImplementaÃ§Ã£o, validaÃ§Ã£o e roteiro da E11](../tests/evolucao_e11.md).

## EvoluÃ§Ã£o E10 â€” Entrega atual

- Diretor narrativo reutilizÃ¡vel baseado em passos de dados.
- Suporte a cena, diÃ¡logo, retrato, transiÃ§Ã£o, evento e sinal de animaÃ§Ã£o.
- Gameplay, HUD, comandos mantidos e controles de toque suspensos durante cenas.
- BotÃµes grandes para continuar e pular, com restauraÃ§Ã£o segura da partida.
- Eventos e sequÃªncias concluÃ­das persistem no `story.events` do Save V2.
- Cenas concluÃ­das nÃ£o reaparecem automaticamente; reproduÃ§Ã£o explÃ­cita Ã© possÃ­vel.
- 14 verificaÃ§Ãµes especÃ­ficas e 79 regressÃµes de save/progresso aprovadas.
- ExportaÃ§Ãµes Web/PWA e Windows concluÃ­das; cenÃ¡rio Web de save offline aprovado.

[ImplementaÃ§Ã£o, validaÃ§Ã£o e roteiro da E10](../tests/evolucao_e10.md).
Nenhum conteÃºdo da abertura foi antecipado; ele pertence Ã  E11.

## Fase modelo â€” Entrega atual

- Percurso principal de 42.000 unidades, com entrada da copa na metade.
- 245 nozes principais e 26 opcionais; contador de vida extra a cada 100 novas coletas.
- Uma Ãºnica bandeira apÃ³s a Ã¡rvore; quatro coraÃ§Ãµes na trilha e trÃªs na copa.
- Tamanho e duraÃ§Ã£o aprovados pelo usuÃ¡rio. Retorno e acesso Ã  Ã¡rvore pelos dois lados revisados.
- SaÃºde cheia: coletar um coraÃ§Ã£o concede uma vida, atÃ© o limite de 99.
- Solo redesenhado: textura contÃ­nua nas plataformas altas, laterais erodidas
  e transiÃ§Ãµes sem Ã¡reas escuras retangulares.
- Saves V2 preservados, incluindo IDs antigos dos itens da copa deslocada.
- Recompensas nÃ£o se repetem ao morrer ou salvar novamente. Em uma nova tentativa
  de fase concluÃ­da pelo mapa, nozes, alimentos e blocos de provisÃ£o podem ser recolhidos de novo.

[Entrega e playtest](../tests/primeiros_passos_modelo.md). Sem commit ou publicaÃ§Ã£o automÃ¡tica.
[PadrÃ£o a aplicar nas demais fases](15_estrutura_fase_modelo.md).

## EvoluÃ§Ã£o E09 â€” Entrega atual

- 271 nozes, 39 alimentos e 14 blocos de recompensa em Primeiros Passos.
- MaÃ§Ã£s, frutas silvestres e cenouras abastecem o contador do vilarejo.
- Duas Nozes Douradas opcionais, uma na trilha e outra na copa.
- Intervalo mÃ¡ximo de 540 unidades entre recompensas na fase ainda nÃ£o coletada.
- AnimaÃ§Ãµes dos coletÃ¡veis atualizadas apenas perto da cÃ¢mera.
- Saves V2 anteriores recebem contador de alimentos sem perder progresso.
- Ao rejogar Primeiros Passos pelo mapa, nozes, alimentos e blocos de provisÃ£o reaparecem e podem ser coletados para ganhar vidas e provisÃµes novamente.
- CoraÃ§Ãµes voltam na nova tentativa e curam ou concedem vida conforme a saÃºde; Nozes Douradas nÃ£o duplicam o tesouro registrado.
- Entrada da Ã¡rvore protegida por uma plataforma contÃ­nua; Tico e Pipo conseguem seguir nos dois sentidos.
- Cenoura redesenhada com corpo, contorno, folhas e detalhes de luz.

[Testes e roteiro da E09](../tests/evolucao_e09.md).

## EvoluÃ§Ã£o E08 â€” RevisÃ£o anterior

- Ãrea opcional em Primeiros Passos, acessÃ­vel subindo os galhos da Ã¡rvore.
- Copa ampliada para 4.000 unidades, com 26 nozes, uma vida extra, trÃªs lesmas,
  bandeira local e trÃªs portais de retorno.
- Caminho principal ampliado para 5.200 unidades, com 16 nozes e nova chegada.
- Bandeira principal preservada; morte, Game Over e reinÃ­cio integrados.
- Save V2 compatÃ­vel com campanhas anteriores e reabertura offline na copa.
- Arte e mecÃ¢nicas existentes reaproveitadas; Pipo depende do resgate.

[Testes e roteiro](../tests/evolucao_e08.md). Sem commit ou publicaÃ§Ã£o automÃ¡tica.

## EvoluÃ§Ã£o E07 â€” Entrega anterior

- Resultado com nozes, Nozes Douradas registradas, vidas e segredo.
- Retorno ao mapa com seleÃ§Ã£o da prÃ³xima fase, inclusive entre mundos.
- Destaque animado de novos desbloqueios; entrada depende da seleÃ§Ã£o do jogador.
- ConclusÃ£o salva imediatamente e recuperada na reabertura offline.
- Ãšltima fase permite voltar ao mapa e rejogar sem perder conquistas.
- Mantidos os saves V2, os personagens e a arte da E06.

[Testes, pacotes e roteiro de validaÃ§Ã£o](../tests/evolucao_e07.md).
Sem commit, push ou publicaÃ§Ã£o automÃ¡tica.

## EvoluÃ§Ã£o E06 â€” Entrega anterior

- Entrada pelo mapa ilustrado dos quatro mundos e suas 16 fases.
- NÃ³s e caminhos com estados de bloqueio, disponibilidade, fase atual e conclusÃ£o.
- SeleÃ§Ã£o por teclado, mouse e toque; acesso tambÃ©m pela pausa e pelo resultado.
- Replay de fases concluÃ­das preserva conquistas, vidas e Pipo desbloqueado.
- Game Over abre o mapa do mundo anterior com os demais desbloqueios mantidos.
- Save V2 e resultados existentes preservados; ampliaÃ§Ã£o do resultado permanece na E07.

VersÃ£o 0.14.1: quatro fundos ilustrados, trilhas curvas, medalhÃµes com cadeados
e bandeiras, Tico e Pipo junto da fase atual e navegaÃ§Ã£o compacta por setas.
48 verificaÃ§Ãµes Godot e oito cenÃ¡rios de navegador passaram nesta revisÃ£o.
[Testes, pacotes e roteiro de validaÃ§Ã£o](../tests/evolucao_e06.md).
Sem commit ou publicaÃ§Ã£o automÃ¡tica; aparÃªncia e desempenho no celular aguardam conferÃªncia.

## EvoluÃ§Ã£o E05 â€” Entrega anterior

- MigraÃ§Ã£o automÃ¡tica V1 â†’ V2 no mesmo slot, preservando campanhas anteriores.
- Consulta de progresso com fase atual, disponÃ­veis, concluÃ­das, conquistas e personagens.
- Registros de Nozes Douradas por fase, eventos narrativos e estado do vilarejo.
- Resgate de Pipo, conclusÃµes e guardiÃµes inferidos a partir dos registros existentes.
- Saves danificados/futuros protegidos; falhas de armazenamento informadas.
- Mapa visual e distribuiÃ§Ã£o de Nozes Douradas continuam nas prÃ³ximas etapas.

VersÃ£o 0.13.0. [Testes, pacotes e roteiro de validaÃ§Ã£o](../tests/evolucao_e05.md).
Sem commit ou publicaÃ§Ã£o automÃ¡tica; aguarda teste do usuÃ¡rio no celular.

## EvoluÃ§Ã£o E04 â€” Entrega anterior

- HUD mantÃ©m saÃºde, nozes, vidas, personagem e controles. Fase, save e nova aventura ficam na pausa.
- Placas existentes convertidas em dicas temporÃ¡rias de proximidade, sem texto permanente no cenÃ¡rio.
- Cinco tutoriais principais: inimigo, coraÃ§Ã£o, vida extra, planar e segredo.
- Dicas expiram, desaparecem apÃ³s interaÃ§Ã£o e nÃ£o pausam nem capturam os controles.
- Dicas visualizadas persistem em save, replay e Game Over; nova aventura reinicia o tutorial.

VersÃ£o 0.12.0. [Testes, pacotes e roteiro de validaÃ§Ã£o](../tests/evolucao_e04.md).
Sem commit ou publicaÃ§Ã£o automÃ¡tica; aguarda teste do usuÃ¡rio no celular.

## EvoluÃ§Ã£o E03 â€” Entrega anterior

- Bandeiras existentes preservadas, com retorno validado nas 16 fases.
- Personagem ativo retorna com saÃºde completa, proteÃ§Ã£o temporÃ¡ria e comandos liberados.
- Margem segura do Rio passa a acompanhar o checkpoint apÃ³s uma derrota.
- **Reiniciar fase** no menu de pausa, com confirmaÃ§Ã£o e cancelamento. Desativa a
  bandeira e mantÃ©m vidas, conquistas, Pipo, itens consumidos e caminhos abertos.
- Regras de inimigos, chefes, itens e Ã¡reas opcionais documentadas; saves anteriores mantidos.

VersÃ£o 0.11.0. [Testes, pacotes e roteiro de validaÃ§Ã£o](../tests/evolucao_e03.md).
Sem commit ou publicaÃ§Ã£o automÃ¡tica; aguarda teste do usuÃ¡rio no celular.

## EvoluÃ§Ã£o E02 â€” Entrega anterior

- TrÃªs vidas compartilhadas e medalhÃµes de vida extra, com coleta persistente.
- Derrota com vidas restantes usa o checkpoint existente. Game Over renova as vidas
  e oferece retorno Ã  primeira fase do mundo anterior, preservando todas as fases liberadas.
- Tela transitÃ³ria de seleÃ§Ã£o atÃ© o mapa da E06; Pipo resgatado acompanha os replays.
- Save compatÃ­vel com campanhas anteriores; retorno pendente tambÃ©m funciona offline.
- Corrida, empurrÃ£o, saÃºde, controles e conteÃºdo existentes mantidos.

VersÃ£o 0.10.0. [Testes, pacotes e roteiro de validaÃ§Ã£o](../tests/evolucao_e02.md).
Sem commit ou publicaÃ§Ã£o automÃ¡tica; aguarda teste do usuÃ¡rio no celular.

**Marco 1 â€” Tico Playground:** aprovado pelo usuÃ¡rio apÃ³s playtest

**Marco 2 â€” Tico PWA:** concluÃ­do; instalaÃ§Ã£o, jogabilidade e offline aprovados

**Marco 3 â€” Tico Mini Game:** publicado e aprovado pelo usuÃ¡rio

**Marco 4 â€” Tico + Pipo:** concluÃ­do; controles, faro e percurso completo aprovados

## Etapa 0 â€” Entregas

- [x] DocumentaÃ§Ã£o em Markdown com referÃªncias e numeraÃ§Ã£o alinhadas.
- [x] Marcos de arquitetura alinhados aos oito marcos do roadmap.
- [x] DistinÃ§Ã£o entre cena vazia, protÃ³tipo completo, MVP e vertical slice.
- [x] ReferÃªncias visuais documentadas e preservadas em `img/`.
- [x] Godot 4.7.2 stable, ediÃ§Ã£o padrÃ£o, instalada e executada.
- [x] Download conferido com SHA512 publicado no release oficial.
- [x] Git 2.53.0.windows.2 disponÃ­vel; repositÃ³rio local na branch `main`.
- [x] Projeto 2D com Compatibility, referÃªncia 1280 Ã— 720 e landscape.
- [x] Input Map inicial com seis aÃ§Ãµes e teclas cadastradas.
- [x] Estrutura de diretÃ³rios, `.gitignore`, `.gitattributes` e `.editorconfig`.
- [x] Cena principal vazia `scenes/main.tscn` carregada e executada.
- [x] Cena e configuraÃ§Ãµes salvas pela Godot e carregadas novamente.
- [x] Primeiro commit local: `chore: prepara projeto Godot e unifica documentacao`.

## Ambiente preparado

InstalaÃ§Ã£o atual escolhida pelo usuÃ¡rio: `D:\Godot\Godot_v4.7.2-stable`.
VersÃ£o executada: `4.7.2.stable.official.ed1daf0bf`.

A versÃ£o e a execuÃ§Ã£o headless da cena vazia foram verificadas novamente
nesse caminho. A cÃ³pia preparada na etapa 0 em
`%LOCALAPPDATA%\Programs\Godot\4.7.2` foi preservada; os comandos do README
passam a usar a instalaÃ§Ã£o em `D:\Godot`.

Editor de cÃ³digo inicial: editor integrado da Godot; VS Code tambÃ©m encontrado.
Navegadores Chrome e Edge disponÃ­veis. Git jÃ¡ possuÃ­a identidade configurada,
que foi preservada. Nenhum repositÃ³rio remoto foi configurado.

Templates Windows x86_64 4.7.2 stable instalados em
`%APPDATA%\Godot\export_templates\4.7.2.stable`, apÃ³s verificaÃ§Ã£o SHA512 do
pacote oficial. Os templates Web da mesma versÃ£o tambÃ©m foram instalados.

O SDK/JDK para Android nativo e ferramentas grÃ¡ficas adicionais serÃ£o
preparados quando essas atividades comeÃ§arem. A etapa 3 inclui testes de
navegador e toque emulado; o usuÃ¡rio tambÃ©m aprovou instalaÃ§Ã£o, jogabilidade
e offline da etapa 3 no aparelho. A etapa 4 tambÃ©m foi publicada e aprovada.
Na etapa 5, o usuÃ¡rio confirmou acesso, corrida, salto, troca, empurrar e aÃ§Ã£o.

## Etapa 1 â€” Entregas

- [x] ResoluÃ§Ã£o, proporÃ§Ã£o, orientaÃ§Ã£o e input da etapa 0 mantidos.
- [x] FÃ­sica a 60 ticks/s, gravidade provisÃ³ria de 1200 px/sÂ².
- [x] Dez camadas de colisÃ£o nomeadas conforme a arquitetura.
- [x] Grupos iniciais `world`, `player` e `spawn_points`.
- [x] `test_level.tscn` com chÃ£o, paredes, trÃªs plataformas e ponto inicial.
- [x] Corpo provisÃ³rio para validar teclado, salto e colisÃµes.
- [x] DiagnÃ³stico de E/Q e pausa por Esc.
- [x] Dezesseis verificaÃ§Ãµes de integraÃ§Ã£o aprovadas.
- [x] Preset Windows versionado e exportaÃ§Ã£o x86_64 de desenvolvimento gerada.
- [x] ExecutÃ¡vel testado fora da pasta do projeto, sem erros.

Build: `builds/windows/etapa_1/Tico.exe` acompanhado de `Tico.pck`.
Pacote: `builds/windows/Tico-etapa-1-windows.zip`.
O retÃ¢ngulo de teste nÃ£o representa o controlador final nem a arte de Tico.

## ValidaÃ§Ã£o

### Etapas 0 e 1

ImportaÃ§Ã£o no editor, execuÃ§Ã£o headless, execuÃ§Ã£o grÃ¡fica com Compatibility,
salvamento e reabertura concluÃ­dos sem erros. As teclas do Input Map foram
conferidas pela prÃ³pria engine, incluindo as setas esquerda e direita.

Detalhes: [registro da etapa 0](../tests/etapa_0.md).

Na etapa 1, os testes de teclado, chÃ£o, paredes, plataformas, salto e pausa
passaram. O build Windows executou com Compatibility / OpenGL 3.3 na Intel
Iris Xe. A captura da cena foi inspecionada visualmente.
Detalhes: [registro da etapa 1](../tests/etapa_1.md).

## PrÃ³ximo trabalho previsto

Publicar e validar os mundos novos da etapa 9. O usuÃ¡rio aprovou o Mundo 1
e solicitou a expansÃ£o. As pendÃªncias histÃ³ricas abaixo registram o aceite
especÃ­fico de cada etapa, sem substituir o teste desta versÃ£o no aparelho.
O usuÃ¡rio confirmou os controles da etapa 5, a descoberta do segredo pelo faro
e o percurso atÃ© a chegada, encerrando a etapa 5 e o marco 4.
O usuÃ¡rio confirmou upload na HostGator, acesso, instalaÃ§Ã£o da PWA e
jogabilidade muito boa em `https://projetosdoleo.com/tico/`. TambÃ©m confirmou
o teste offline no aparelho, encerrando a etapa 3 e o marco 2.

## Etapa 2 â€” Entregas

- [x] `tico.tscn` e `tico.gd`, com parÃ¢metros configurÃ¡veis.
- [x] Movimento com aceleraÃ§Ã£o, desaceleraÃ§Ã£o, controle aÃ©reo e direÃ§Ã£o visual.
- [x] Salto de altura variÃ¡vel, coyote time e jump buffer.
- [x] Planar na queda, mantendo EspaÃ§o, por atÃ© 2 segundos; recarga no chÃ£o.
- [x] AnimaÃ§Ãµes provisÃ³rias idle, run, jump, fall, glide e land; 11 quadros SVG.
- [x] Playground de 3800 Ã— 900, subida gradual, travessia longa e chÃ£o seguro.
- [x] CÃ¢mera suave, antecipaÃ§Ã£o horizontal e limites.
- [x] Pausa, pausa ao perder foco e botÃ£o RecomeÃ§ar.
- [x] 45 verificaÃ§Ãµes de Tico e 16 de regressÃ£o aprovadas.
- [x] Build Windows executado fora do projeto e capturas inspecionadas.
- [x] Playtest humano: usuÃ¡rio testou, considerou bem jogÃ¡vel e aprovou avanÃ§ar.

Build preservado da etapa 2: `builds/windows/etapa_2/Tico.exe` com `Tico.pck`.
Pacote: `builds/windows/Tico-etapa-2-windows.zip`.
Registro: [testes da etapa 2](../tests/etapa_2.md).

Na etapa 2, a cena principal passou a abrir o playground de Tico. A Ã¡rea e o build da etapa 1
foram preservados. A arte vetorial Ã© provisÃ³ria; Pipo, inimigos, coleta,
Ã¡udio ainda nÃ£o fazem parte deste playground. Touch e Web/PWA foram adicionados
na etapa 3, sem alterar os parÃ¢metros de movimento aprovados.

## Etapa 3 â€” Entregas

- [x] ExportaÃ§Ã£o Web sem threads, shell em portuguÃªs e caminhos relativos a `/tico/`.
- [x] BotÃµes multitoque de direÃ§Ã£o, pulo/planar e aÃ§Ã£o reservada.
- [x] Layout landscape, Ã¡reas seguras, pausa em retrato e tela cheia.
- [x] Manifesto, Ã­cones, cache versionado e botÃ£o de atualizaÃ§Ã£o.
- [x] Scripts de build, servidor local e testes de navegador reproduzÃ­veis.
- [x] PublicaÃ§Ã£o no endereÃ§o HTTPS informado, confirmada pelo usuÃ¡rio.
- [x] Acesso e instalaÃ§Ã£o da PWA confirmados pelo usuÃ¡rio.
- [x] Jogabilidade aprovada pelo usuÃ¡rio: â€œmuito boaâ€.
- [x] Fechar e reabrir pelo Ã­cone sem conexÃ£o no celular fÃ­sico: teste confirmado pelo usuÃ¡rio.

O retorno aprova a experiÃªncia de jogo; nÃ£o foi fornecida mediÃ§Ã£o de FPS.

Pacote: `builds/web/Tico-etapa-3-web.zip`.
Detalhes: [testes da etapa 3](../tests/etapa_3.md) e
[publicaÃ§Ã£o](../web/deployment.md).

## Etapa 4 â€” Entregas

- [x] TrÃªs coraÃ§Ãµes, dano, reaÃ§Ã£o, proteÃ§Ã£o temporÃ¡ria, recuperaÃ§Ã£o e derrota.
- [x] Lesma com patrulha, viradas, dano lateral, pisÃ£o e saÃ­da amigÃ¡vel.
- [x] Nozes com som, feedback visual, contagem e prevenÃ§Ã£o de coleta duplicada.
- [x] HUD de coraÃ§Ãµes e nozes, adaptado a teclado e toque.
- [x] Blocos comum, quebrÃ¡vel e de noz, acionados por cabeÃ§ada.
- [x] Checkpoint, retorno com vida restaurada e regras de reinÃ­cio definidas.
- [x] Chegada com controles bloqueados, comemoraÃ§Ã£o, resultado e nova partida.
- [x] Fase percorrida do inÃ­cio ao fim nos testes de engine e navegador.
- [x] 99 verificaÃ§Ãµes de engine e quatro cenÃ¡rios de navegador aprovados.
- [x] Pacotes Web e Windows da etapa 4 preparados.
- [x] UsuÃ¡rio publicou a etapa 4 e confirmou que funcionou muito bem.

Cena: `scenes/levels/tico_minigame.tscn`. O playground continua disponÃ­vel
separadamente. Os builds antigos foram preservados. A fase tem 14 nozes
opcionais, trÃªs lesmas, um item de recuperaÃ§Ã£o, uma bandeira e uma chegada.
Detalhes: [testes da etapa 4](../tests/etapa_4.md).

## Etapa 5 â€” Entregas

- [x] `pipo.tscn` e `pipo.gd`, arte provisÃ³ria com camisa verde e referÃªncia preservada.
- [x] Movimento mais pesado: velocidade e salto menores; Pipo nÃ£o plana.
- [x] Pedra empurrÃ¡vel somente por Pipo, com limite de deslocamento.
- [x] Bloco pesado quebrÃ¡vel somente pela investida de Pipo.
- [x] PreparaÃ§Ã£o, avanÃ§o, impacto e recuperaÃ§Ã£o, com postura, som e fragmentos.
- [x] Faro automÃ¡tico, pista direcional em partÃ­culas e noz escondida.
- [x] Q/Trocar, cÃ¢mera e HUD do personagem ativo, vida e contador compartilhados.
- [x] VerificaÃ§Ã£o de espaÃ§o na troca; personagem inativo sem colisÃ£o ou controle.
- [x] Puzzle: empurrar a pedra, abrir o portÃ£o e atravessar com Tico.
- [x] Checkpoint, derrota, reinÃ­cio e resultado adaptados Ã  dupla.
- [x] 54 testes novos de integraÃ§Ã£o e 99 verificaÃ§Ãµes anteriores aprovados.
- [x] Cinco cenÃ¡rios de navegador, incluindo troca e investida por multitoque.
- [x] UsuÃ¡rio confirmou acesso e funcionamento de corrida, salto, troca, empurrar e aÃ§Ã£o.
- [x] UsuÃ¡rio confirmou descoberta pelo faro e conclusÃ£o do puzzle atÃ© a chegada.

Cena: `scenes/levels/coop_trail.tscn`. Pacotes:
`builds/web/Tico-etapa-5-web.zip` e `builds/windows/Tico-etapa-5-windows.zip`.
Detalhes e roteiro: [testes da etapa 5](../tests/etapa_5.md).

## Etapa 6 â€” Entregas

- [x] Fase integrada: Tico, Pipo, 13 nozes, lesmas, trÃªs tipos de bloco e bloco pesado.
- [x] Pedra, passagem baixa, troca, investida, faro e segredo preservados.
- [x] Bandeira apÃ³s a cooperaÃ§Ã£o e trÃªs plataformas no desafio final atÃ© a Ã¡rvore.
- [x] Pistas curtas no cenÃ¡rio; cenas anteriores preservadas.
- [x] Save automÃ¡tico versionado, retomada segura e conclusÃ£o persistente.
- [x] ReinÃ­cio com confirmaÃ§Ã£o; save danificado/futuro protegido de sobrescrita automÃ¡tica.
- [x] 185 verificaÃ§Ãµes de engine (153 anteriores + 32 novas) aprovadas.
- [x] Dez cenÃ¡rios de Chrome aprovados, incluindo novo processo offline e atualizaÃ§Ã£o do worker.
- [x] Pacotes Web/Windows gerados; conteÃºdo dos ZIPs e execuÃ§Ã£o Windows conferidos.
- [ ] PublicaÃ§Ã£o e validaÃ§Ã£o desta versÃ£o no aparelho real do usuÃ¡rio.
- [ ] Playtest estruturado: compreensÃ£o, diversÃ£o, dificuldade e cooperaÃ§Ã£o.
- [ ] AprovaÃ§Ã£o do protÃ³tipo completo; a etapa 6 nÃ£o acrescenta um marco numerado.

Cena: `scenes/levels/prototype_trail.tscn`. Pacotes da etapa 6 em `builds/`.
Registro tÃ©cnico: [etapa 6](../tests/etapa_6.md).
Roteiro de observaÃ§Ã£o: [playtest](../tests/playtest_etapa_6.md).
AlteraÃ§Ãµes deixadas sem commit, conforme preferÃªncia do usuÃ¡rio.

## Etapa 7 â€” Entregas

- [x] Cena `vertical_slice.tscn`: Bosque das Folhas com fundo ilustrado e profundidade.
- [x] Arte de Tico, Pipo, lesma, nozes, blocos, pedra, vegetaÃ§Ã£o e bandeira.
- [x] Poses de movimento, habilidades, dano e celebraÃ§Ã£o; ciclos com variaÃ§Ãµes e movimento procedural.
- [x] MÃºsica original em loop e efeitos prÃ©-gerados de gameplay e interface.
- [x] HUD ilustrado, retrato do personagem, pausa, opÃ§Ãµes de Ã¡udio e controles touch.
- [x] PreferÃªncias persistentes e compatibilidade com saves da etapa 6.
- [x] Efeitos limitados em quantidade e recortes de atlas compartilhados.
- [x] 208 verificaÃ§Ãµes de engine e 12 cenÃ¡rios de navegador aprovados.
- [x] MediÃ§Ãµes locais prÃ³ximas de 60 FPS: p95 de 17,74 ms no Windows e 17,90 ms no Web desktop.
- [ ] Validar Ã¡udio, desempenho e legibilidade no Android/PWA real.
- [ ] Aprovar identidade visual, diversÃ£o e entendimento com jogadores.
- [ ] Aprovar marco 5 â€” Vertical Slice, antes da produÃ§Ã£o do Mundo 1.

Pacotes: `builds/web/Tico-etapa-7-web.zip` e
`builds/windows/Tico-etapa-7-windows.zip`. Detalhes: [etapa 7](../tests/etapa_7.md).
Arte e prompts: [assets do slice](../assets/slice/README.md).
As alteraÃ§Ãµes desta etapa permanecem sem commit.

**Ajuste apÃ³s o playtest do usuÃ¡rio:** Tico passa a demonstrar esforÃ§o ao tentar
empurrar a pedra. Pipo recebe um ciclo de passadas ao empurrÃ¡-la; os pÃ©s param
quando a pedra atinge o limite. As regras de forÃ§a e movimento nÃ£o mudam.

## Etapa 8 â€” Entregas

- [x] Fase 1-1 â€” Primeiros Passos: nozes, plataformas, lesmas, bandeira e chegada.
- [x] Fase 1-2 â€” Blocos e Segredos: trÃªs tipos de bloco, segredo opcional e ouriÃ§o.
- [x] Fase 1-3 â€” Um Novo Amigo: resgate jogÃ¡vel, breve diÃ¡logo e desbloqueio de Pipo.
- [x] CooperaÃ§Ã£o: pedra, passagem baixa, investida, faro e desafio final.
- [x] Periquito do Bosque definido como chefe da fase 1-4.
- [x] Patrulha aÃ©rea, perseguiÃ§Ã£o, mergulho anunciado e encerramento amigÃ¡vel.
- [x] Periquito derrotado por trÃªs pulos na cabeÃ§a; investida de Pipo nÃ£o causa dano.
- [x] TransiÃ§Ã£o entre fases e conclusÃ£o persistente do mundo.
- [x] Save prÃ³prio versionado; slot do protÃ³tipo preservado e preferÃªncias aproveitadas.
- [x] ReinÃ­cio com confirmaÃ§Ã£o; dados danificados ou futuros protegidos.
- [x] 175 verificaÃ§Ãµes na Godot e quatro cenÃ¡rios Web aprovados, incluindo campanha completa e reabertura offline.
- [x] Multitoque: percurso de 1-1, resgate, troca, esforÃ§o de Tico e passadas de Pipo.
- [x] ExecuÃ§Ã£o grÃ¡fica Windows e conteÃºdo dos ZIPs Web/Windows conferidos.
- [x] UsuÃ¡rio confirmou: â€œetapa 8 testada e aprovada. Ficou muito bom.â€
- [x] Marco 6 â€” Mundo 1 Completo aprovado pelo usuÃ¡rio.

Aceite registrado em 2026-09-30. O retorno confirma a aprovaÃ§Ã£o geral da etapa;
nÃ£o detalha aparelho, mediÃ§Ã£o de FPS ou execuÃ§Ã£o individual de cada item do roteiro.

ImplementaÃ§Ã£o e validaÃ§Ã£o: [etapa 8](../tests/etapa_8.md).
Pacotes: `builds/web/Tico-etapa-8-web.zip` e `builds/windows/Tico-etapa-8-windows.zip`.
AvanÃ§o autorizado pelo usuÃ¡rio; as pendÃªncias de playtest anteriores permanecem registradas.
Nenhum commit ou push feito nesta entrega.

## Etapa 9 â€” Entregas

- [x] Rio das Pedras: trÃªs fases, Ã¡gua, troncos, ponte, plataformas mÃ³veis e GuardiÃ£o.
- [x] Montanha das Corujas: trÃªs fases, vento, cavernas, altura, inimigos aÃ©reos e Coruja.
- [x] Vila dos Castores: trÃªs fases, peso, investida, elevadores, comporta e Rei Castor.
- [x] Primeira fase de cada mundo validada antes da produÃ§Ã£o das seguintes.
- [x] Campanha contÃ­nua de quatro mundos; save do Bosque importado e preservado.
- [x] Mecanismos, checkpoints, nozes, segredo e conclusÃµes persistentes.
- [x] 349 verificaÃ§Ãµes na Godot aprovadas, incluindo regressÃ£o do Bosque e dos controles.
- [x] ExportaÃ§Ãµes Web/PWA e Windows e mediÃ§Ã£o grÃ¡fica local.
- [x] Cinco cenÃ¡rios Web aprovados: migraÃ§Ã£o, Rio offline, Montanha, toque na Vila, comporta e proteÃ§Ã£o do save.
- [ ] PublicaÃ§Ã£o e playtest desta versÃ£o no aparelho do usuÃ¡rio.
- [ ] Aceite de dificuldade, visual e fluidez dos mundos novos.

Detalhes, testes Web e roteiro: [etapa 9](../tests/etapa_9.md).
Pacotes: `builds/web/Tico-etapa-9-web.zip` e `builds/windows/Tico-etapa-9-windows.zip`.
Nenhum commit ou push realizado. O Mundo 5 permanece para a etapa 10.

## EvoluÃ§Ã£o E20 â€” Blocos e Segredos

**CorreÃ§Ã£o 0.30.1:** removidos desnÃ­veis de 110, 120 e 160 pixels na rota
principal. Os degraus repetidos agora sobem no mÃ¡ximo 80 pixels. A Galeria das
Pedras tambÃ©m recebeu apoios intermediÃ¡rios para todas as plataformas elevadas.
Uma travessia automatizada completa com Tico protege a rota contra bloqueios.

**CorreÃ§Ã£o 0.30.2:** a caudada derrota o porco-espinho como os demais inimigos
comuns; o bloco raro da galeria concede sua vida apÃ³s uma cabeÃ§ada real; e o fim
da Ã¡rea secundÃ¡ria possui um portal grande, iluminado e acionÃ¡vel sobre o piso.

**CorreÃ§Ã£o 0.30.3:** o retorno da Galeria das Pedras e a bandeira foram movidos
de dentro de um pilar para uma faixa plana. O teste agora exige movimento real
imediatamente depois da transiÃ§Ã£o.

**RevisÃ£o visual 0.30.4:** a Ã¡rea secundÃ¡ria passa a representar uma travessia
noturna pelo bosque, com pintura prÃ³pria, luar, Ã¡rvores em profundidade, nÃ©voa e
vaga-lumes animados. Plataformas e elementos interativos preservam sua leitura.

- [x] Fase 1-2 ampliada para 39.000 unidades, com duraÃ§Ã£o alvo de 5 a 8 minutos.
- [x] IntroduÃ§Ã£o existente preservada e desenvolvida em uma jornada prÃ³pria.
- [x] Blocos, ruÃ­nas, pilares, rotas altas, inimigos, alimentos e segredos distribuÃ­dos.
- [x] Galeria das Pedras criada como Ã¡rea secundÃ¡ria, sem reutilizar a Ã¡rvore de 1-1.
- [x] CoraÃ§Ãµes, vida em bloco raro, Nozes Douradas e saÃ­da perto da bandeira.
- [x] Bandeira Ãºnica posicionada depois da Ã¡rea secundÃ¡ria.
- [x] Save V2 ampliado para preservar a Ã¡rea opcional da fase 1-2.
- [x] Teste E20 e regressÃ£o da Ã¡rea opcional de 1-1 aprovados.
- [ ] Playtest de duraÃ§Ã£o, retorno completo e legibilidade no celular do usuÃ¡rio.

Detalhes e roteiro: [evoluÃ§Ã£o E20](../tests/evolucao_e20.md). Nenhum commit feito.

## DecisÃµes ainda abertas

ResoluÃ§Ã£o artÃ­stica definitiva, parÃ¢metros de movimento, duraÃ§Ã£o do planar,
coraÃ§Ãµes, layout touch, quantidade de chefes e inclusÃ£o de Android nativo
na versÃ£o 1.0 continuam sujeitos aos protÃ³tipos e testes previstos.

## EvoluÃ§Ã£o â€” decisÃµes documentadas

RevisÃ£o aprovada pelo usuÃ¡rio: E00â€“E30, preservaÃ§Ã£o dos sistemas existentes, Coruja mentora, GaviÃ£o como chefe aÃ©reo, Pipo global apÃ³s o resgate, Game Over no mapa do mundo anterior com desbloqueios preservados, duraÃ§Ã£o a validar e verificaÃ§Ãµes contÃ­nuas de PWA/desempenho/save.

DocumentaÃ§Ã£o alinhada; alteraÃ§Ãµes no cÃ³digo ainda pendentes. O build da etapa 9 ainda tem a antiga chefe Coruja e nÃ£o possui mapa, vidas limitadas ou replay global com Pipo. NÃ£o considerar essas funcionalidades implementadas por esta revisÃ£o. Ver DEC-115.

## EvoluÃ§Ã£o E00 â€” ConcluÃ­da

- [x] InventÃ¡rio dos sistemas, componentes reutilizÃ¡veis e dependÃªncias.
- [x] InspeÃ§Ã£o de controles, colisÃµes, inimigos, HUD, fases, progresso e PWA.
- [x] ClassificaÃ§Ã£o manter/alterar/remover/criar e identificaÃ§Ã£o dos textos fixos.
- [x] Pontos de migraÃ§Ã£o para Pipo global, replay, vidas e mapa registrados.
- [x] 182 verificaÃ§Ãµes Godot e cinco cenÃ¡rios Web aprovados nesta execuÃ§Ã£o.
- [x] MediÃ§Ã£o local: medianas de 16,59â€“16,74 ms; p95 de 17,50â€“18,19 ms.

Entregas: [diagnÃ³stico E00](15_diagnostico_e00.md) e
[registro de validaÃ§Ã£o](../tests/evolucao_e00.md).
Gameplay preservado; nenhum commit ou push realizado.

## EvoluÃ§Ã£o E01 â€” Entregas

- [x] SaÃºde, dano, recuperaÃ§Ã£o, HUD, invulnerabilidade e derrota existentes revisados.
- [x] TrÃªs coraÃ§Ãµes, controles, habilidades, proteÃ§Ã£o e retorno Ã  bandeira preservados.
- [x] CoraÃ§Ã£o pode recuperar saÃºde sem exigir sair e reentrar na Ã¡rea apÃ³s dano.
- [x] RecuperaÃ§Ã£o rejeita valores invÃ¡lidos e personagem inativo/derrotado.
- [x] 195 verificaÃ§Ãµes Godot aprovadas, incluindo 20 verificaÃ§Ãµes especÃ­ficas.
- [x] Cinco cenÃ¡rios Web aprovados; Windows executado e pacotes conferidos.
- [x] Amostra grÃ¡fica local e compatibilidade do save verificadas.
- [ ] Playtest desta versÃ£o no aparelho do usuÃ¡rio.

Registro, validaÃ§Ã£o Web e pacotes: [evoluÃ§Ã£o E01](../tests/evolucao_e01.md).
Vidas limitadas, Game Over e mapa nÃ£o foram antecipados. Sem commit ou push.

**CorreÃ§Ã£o apÃ³s teste do usuÃ¡rio (0.9.2):** corrida de Tico e Pipo recebe quatro
poses com movimento visÃ­vel das pernas e ciclo proporcional ao deslocamento.
AnimaÃ§Ãµes de empurrar e regras fÃ­sicas mantidas. Pacotes E01 atualizados;
detalhes em [evoluÃ§Ã£o E01](../tests/evolucao_e01.md).


**Refino da Gruta Fria em 0.34.3:** a área secundária de 1-3 ganhou pintura de fundo própria em tons frios, sombras distantes e esporádicas de morcegos e goteiras com formação, aviso, rastro de queda e respingo mais legíveis. A mecânica e o tempo de dano foram preservados.

**Correções T08–T10 em 0.34.3:** o piso de T08 foi nivelado; seu bloco está apoiado e aceita a caudada; os inimigos de T08 e T09 ocupam plataformas acessíveis; e a parede alta de T10 foi substituída por um obstáculo baixo, saltável e quebrável pela caudada.

**Solo da Gruta Fria em 0.34.3:** as plataformas da área secundária de 1-3 usam rocha azul-ardósia escura, bordas minerais, veios e umidade sutil. O renderizador exclui a terra marrom e a grama do bosque nas coordenadas da caverna, preservando as colisões e a leitura dos saltos.
