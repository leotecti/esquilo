# Evolução E06 — Mapa do mundo

Versão **0.14.1**. Funcionamento do mapa aprovado pelo usuário. Renovação visual
implementada e testada; aparência e desempenho no celular aguardam nova conferência.

## Entrega

- Entrada pelo mapa, tanto na campanha nova quanto ao reabrir um save existente.
- Quatro páginas ilustradas: Bosque, Rio, Montanha e Vila dos Castores.
  Cada página apresenta quatro nós ligados por caminhos. O vilarejo marca o
  início da jornada no Bosque; nas demais páginas, o caminho vem do mundo anterior.
- Botões nativos para mouse, teclado e toque, com seleção da fase e confirmação
  de entrada. É possível consultar mundos bloqueados, mas suas fases não abrem.
- Estados derivados de `progress_summary()` da E05: `LOCKED`, `AVAILABLE`,
  `CURRENT` e `COMPLETED`. A fase atual tem prioridade visual; sua conclusão
  permanente continua disponível na descrição e no save.
- **Mapa da jornada** na pausa e no resultado atual. **Fase atual** volta à
  tentativa existente, sem curar o personagem ou mudar sua posição.
- Reabrir o jogo continua usando o checkpoint salvo. Selecionar outra fase
  concluída inicia um replay, preservando conquistas, vidas, itens e Pipo.
- Game Over abre o mapa no mundo anterior e seleciona sua primeira fase.
  Todos os desbloqueios continuam disponíveis. O botão de voltar à tentativa
  derrotada fica oculto; entrar em uma fase consome o retorno pendente.
- Nova aventura mantém a confirmação existente e volta ao mapa inicial.

O resultado e o botão de próxima fase existentes foram preservados. O ciclo
completo de resultados, retorno automático ao mapa e animação de desbloqueio
será ampliado na E07. A caudada do Tico continua planejada para a E14.

## Preservação do projeto

O mapa combina quatro ilustrações com caminhos curvos e medalhões desenhados em
código. Apenas o fundo do mundo exibido é carregado; as imagens usam compressão
com qualidade 0,8 na importação. Tico e Pipo reutilizam os atlas existentes.
O cabeçalho compacto traz setas para trocar de mundo; cadeados, bandeiras e
seleção animada indicam o estado das fases. Partículas discretas e som de seleção
respeitam a apresentação e a configuração de efeitos. Gameplay e áudio da fase
ficam pausados, e comandos de movimento são liberados ao entrar no mapa.
O aviso de orientação vertical também impede entrada na fase por teclado.

Artes, prompts e ferramenta: [assets/map/PROMPTS.md](../assets/map/PROMPTS.md).

O formato continua sendo **save V2**, no mesmo slot. Nenhuma nova migração ou
lista duplicada de desbloqueios foi criada. Consultar outra página do mapa não
muda a fase atual salva. Saves futuros/danificados mantêm a proteção da E05.

As cenas históricas e testes de jogabilidade podem usar `start_on_map = false`
na campanha. A cena principal distribuída inicia com essa opção ativada.

## Validação automatizada

Na entrega 0.14.0, 380 verificações Godot passaram: 48 de mapa, 47 de vidas, 79 de progresso,
133 de checkpoints e 73 de persistência. Os 19 cenários de navegador foram
validados; os quatro de mapa e Game Over foram repetidos após os ajustes finais
de orientação, áudio e apresentação, todos aprovados.

Na revisão visual 0.14.1, foram executadas novamente as 48 verificações de mapa
e oito cenários de navegador E06/E05/E02: todos passaram. Incluem navegação pelos
quatro fundos, teclado, toque, replay com Pipo, save, Game Over e uso offline.

- `tests/map_e06_test.gd`: entrada, 16 estados iniciais, bloqueios, conclusão,
  checkpoint, revisão de fases, Pipo, migração, Game Over nos quatro mundos,
  retorno pendente e nova aventura.
- Regressões: vidas, checkpoints, progresso E05 e persistência da campanha.
- Navegador: mapa inicial, entrada pelo teclado, toque, rotação, replay com Pipo,
  reabertura offline e funcionalidades anteriores da campanha.
- `tests/map_e06_performance.gd`: mapa do Bosque, mapa da Montanha e gameplay
  após sair do mapa. Relatório em `builds/performance-e06-windows.json`.

Revisão 0.14.1: Intel Iris Xe, Compatibility, 1280×720, 180–181 amostras por cenário:

| Cenário | Mediana | p95 | Chamadas de desenho p95 |
| --- | ---: | ---: | ---: |
| Mapa do Bosque | 16,64 ms | 18,42 ms | 185 |
| Mapa da Montanha | 16,63 ms | 17,94 ms | 199 |
| Fase após o mapa | 16,69 ms | 18,59 ms | 66 |

A medição no computador não substitui a validação de desempenho no celular.

## Pacotes

- Web/PWA: `builds/web/Tico-evolucao-E06-web.zip`.
- Windows: `builds/windows/Tico-evolucao-E06-windows.zip`.
- Pastas: `builds/web/evolucao_e06/` e `builds/windows/evolucao_e06/`.

## Teste no celular

1. Publique em `/tico/` e atualize a PWA sem limpar os dados do site.
2. Confira se o mapa abre no mundo da sua campanha e se as conquistas estão corretas.
3. Navegue pelas quatro páginas e tente selecionar uma fase bloqueada.
4. Entre na fase atual e confira personagem, vidas e checkpoint.
5. Abra o mapa pela pausa. Use **Fase atual** para voltar à mesma posição.
6. Rejogue uma fase concluída. Confira que Pipo fica disponível se já foi resgatado.
7. Feche e reabra offline: o mapa deve recuperar a fase atual e seus desbloqueios.
8. Em uma campanha de teste, esgote as vidas: o mapa deve abrir no mundo anterior,
   preservando os mundos posteriores. Gire o celular e confira o aviso vertical.

Sem commit, push ou publicação automática.
