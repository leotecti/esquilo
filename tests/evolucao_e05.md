# Evolução E05 — Progresso e salvamento

Versão do jogo: **0.13.0**. Formato da campanha: **V2**.

## Entrega

O salvamento existente foi ampliado, preservando as 16 fases, vidas,
checkpoints, Pipo, mecanismos, itens, segredos e tutoriais. O mapa visual
continua previsto para E06.

| Informação | Fonte no save V2 |
| --- | --- |
| Fase atual e fases disponíveis | `stage` e `unlocked` (último índice liberado) |
| Fases concluídas | `levels[id].completed` |
| Coletáveis e blocos usados | `levels[id].items` e `blocks` |
| Segredos encontrados | `levels[id].secret`; coleta registrada em `items` |
| Nozes Douradas | `collectibles.golden_nuts[id]`, lista de IDs por fase |
| Personagens | Tico disponível; `survival.pipo_unlocked` para Pipo |
| Vidas e retorno após Game Over | `survival` |
| Eventos narrativos e vilarejo | `story.events` e `story.village` |
| Tutoriais e dicas vistas | `tutorials` e `context_hints_seen` |
| Preferências de áudio | `settings` |

`progress_summary()` fornece as fases atuais, disponíveis e concluídas, os
personagens e as conquistas como uma cópia independente. Os dados derivados
não são duplicados no arquivo, evitando divergências para o futuro mapa.

`record_golden_nut(id)`, `record_story_event(id)` e `set_village_flag(id, value)`
gravam imediatamente. IDs usam letras minúsculas, números, `_`, `:` ou `-`,
até 80 caracteres. Coletas e eventos repetidos não geram novos registros.
As Nozes Douradas têm estrutura e persistência prontas; sua distribuição e
recompensas serão implementadas nas etapas de conteúdo. Nenhuma noz comum
ou secreta existente foi convertida em Noz Dourada.

Resgate de Pipo, conclusão de fase e guardiões acalmados geram eventos a partir
dos fatos já registrados. Os demais eventos e estados do vilarejo começam vazios.
Os IDs de itens antigos continuam baseados nas posições originais; mudanças
futuras nessas posições precisam de uma migração própria.

## Compatibilidade e armazenamento

- Saves V1 válidos são migrados para V2, sem alterar a origem em memória.
  Saves do Bosque antigo continuam sendo importados, mantendo o arquivo antigo.
- O slot permanece `user://campaign.json` no Windows e `tico.campaign.v1`
  no localStorage. O sufixo da chave é histórico; `save_version` identifica o formato.
- Migração preenche campos ausentes e infere Pipo pelo resgate ou progresso.
  Vidas, retorno pendente, áudio e conquistas anteriores são preservados.
- O navegador grava de forma síncrona; Windows usa arquivo temporário e renomeação.
  Falha de escrita é indicada no menu de pausa e permite nova tentativa de gravação.
- Save danificado ou de versão futura fica bloqueado contra sobrescrita.
  Somente confirmar **Nova aventura** substitui esse progresso.
- Reinício, replay e Game Over mantêm conquistas. Nova aventura limpa o progresso
  e conserva as preferências de áudio, como antes.
- O save é local ao dispositivo, navegador/perfil e origem do site. A PWA usa
  o armazenamento dessa origem; não há sincronização entre aparelhos.

## Validação

311 verificações Godot passaram: 79 da E05, 73 da campanha, 133 de checkpoints
e 26 de tutoriais. A suíte inicial do navegador passou em 16 cenários; os quatro
cenários E05 foram executados novamente no build final, incluindo a proteção
adicional quando a leitura do armazenamento está bloqueada.

- `tests/progress_e05_test.gd`: migração das 16 fases, idempotência, consulta,
  persistência dos novos campos, rejeição de registros inválidos e falha de escrita.
- Regressões: `expedition_save_test.gd`, `checkpoints_e03_test.gd` e
  `tutorial_e04_test.gd`.
- Navegador: migração V1, coleta real, fechamento da página e reabertura offline,
  restauração V2, falha de armazenamento e recuperação. A suíte também cobre
  toque, Game Over, mecanismos, corrida e proteção de save futuro.
- Desempenho: `tests/progress_e05_performance.gd` gera
  `builds/performance-e05-windows.json`, sem alterar o save pessoal.

Intel Iris Xe, Compatibility, 1280×720: 181 amostras, mediana de 16,61 ms,
p95 de 18,65 ms e 66 chamadas de desenho no p95. Captura, validação e consulta
de progresso custaram em média 0,096 ms por ciclo, sem medir acesso ao disco.

## Pacotes e validação no celular

- `builds/web/Tico-evolucao-E05-web.zip`
- `builds/windows/Tico-evolucao-E05-windows.zip`

1. Publique o pacote Web em `/tico/`, sem limpar os dados do site.
2. Abra uma campanha existente e confira fase, vidas, Pipo e checkpoint.
3. Colete uma noz e altere uma preferência de áudio. Feche e reabra a PWA.
4. Confirme o progresso, depois repita a reabertura em modo avião.
5. Reinicie a fase pelo menu e confira que as conquistas continuam salvas.

A instalação e o encerramento da PWA no celular real aguardam o teste do usuário.
Sem commit, push ou publicação automática.
