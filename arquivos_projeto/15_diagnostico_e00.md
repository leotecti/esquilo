# Evolução E00 — Preparação e diagnóstico

**Base:** campanha da etapa 9 e decisões da DEC-115.
**Escopo:** inspecionar a implementação, registrar dependências e verificar a base.
Esta etapa não implementa as novas regras de gameplay.

## 1. Estado encontrado

A campanha contém quatro mundos, com três fases e um encontro final por mundo:
12 fases e quatro arenas, totalizando 16 cenas. O Mundo 5 permanece planejado.
As fases são curtas e predominantemente lineares, com alguns segredos locais.
Não há mapa navegável, replay pela interface, vidas limitadas, Game Over,
Nozes Douradas, portais, vilarejo evolutivo ou sistema geral de narrativa.

Tico, Pipo, cooperação, saúde, dano, checkpoints, chefes, persistência e PWA já
funcionam. Esses sistemas constituem a base da evolução. A Coruja ainda aparece
como chefe no código; sua substituição pelo Gavião está aprovada na documentação.

## 2. Organização e dependências

### Entrada e campanha

- `scenes/main.tscn` inicia `expedition_campaign.gd`.
- `expedition_campaign.gd` estende `world_campaign.gd`, acrescenta os mundos 2–4
  e importa progresso do Bosque quando não existe save da campanha atual.
- `world_campaign.gd` carrega fases, restaura estado, salva progresso e avança
  sequencialmente. Não oferece navegação pelo mapa ou replay de fase concluída.
- `world_1_campaign.tscn` conserva a campanha histórica para testes.

### Fases

As cenas `world_1_*.tscn` usam `world_level.gd`; as cenas `world_2_*`,
`world_3_*` e `world_4_*` usam `expedition_level.gd`. Geometria, itens, placas e
inimigos são montados principalmente em código, sobre a cena `vertical_slice.tscn`.

Cadeia de herança dos scripts de fase:

```text
tico_playground → tico_minigame → coop_level → prototype_level
→ vertical_slice → world_level → expedition_level
```

Cada camada adiciona comportamento e chama métodos das anteriores. HUD, dano,
retorno, áudio e persistência passam por várias camadas. Alterações devem conferir
o efeito nas cenas históricas e na campanha atual. Separar responsabilidades
gradualmente ao introduzir novos sistemas; não reescrever toda a cadeia em E00.

### Componentes reutilizáveis

| Sistema | Arquivos principais | Estado e uso na evolução |
| --- | --- | --- |
| Movimento e saúde | `characters/tico.gd`, `characters/pipo.gd` | Preservar; integrar vidas acima do controlador |
| Troca e habilidades | `systems/coop_level.gd`, `objects/pushable.gd`, `heavy_block.gd`, `secret_nut.gd` | Preservar regras físicas; ampliar condição global de desbloqueio |
| Checkpoint e saída | `objects/level_marker.gd`, `systems/tico_minigame.gd` | Preservar detecção; ampliar destinos e estado de retorno |
| Ambiente | `travel_platform.gd`, `power_device.gd`, `bridge_log.gd`, `expedition_level.gd` | Reutilizar em desafios opcionais |
| Câmera e toque | `follow_camera.gd`, `ui/touch_controls.gd` | Manter acompanhamento, área segura e liberação de entradas |
| Apresentação | `presentation/character_art.gd`, `object_art.gd`, `atlas_library.gd`, `slice_audio.gd` | Preservar atlas, esforço/passadas, efeitos e opções de áudio |
| Save | `save_manager.gd`, `world_save.gd`, `expedition_save.gd` | Manter proteção e armazenamento; migrar estrutura |
| Web/PWA | `web/build.mjs`, `custom/shell.html`, `custom/service-worker.js` | Manter exportação, instalação, atualização e offline |

## 3. Controle, dano e colisões

- Tico: velocidade 300 px/s, salto inicial −560 px/s, planagem até 2 s.
  Há tolerância ao sair da borda, antecipação do comando de salto e salto curto.
- Pipo: velocidade 220 px/s, salto −500 px/s e nenhuma planagem. Empurra,
  investe, revela segredos pelo faro e aciona mecanismos de peso.
- Corpos físicos: Tico 32 × 56 px; Pipo 48 × 72 px. Ambos usam camada 2 e
  máscara 1. O personagem inativo fica sem colisão e processamento físico.
- A troca verifica chão, habilidade e espaço para o corpo maior. Copia saúde
  e proteção temporária; não serve para recuperar corações.
- Saúde máxima padrão: três. Dano retira um coração, aplica recuo e proteção
  por 1,5 s. `defeated` é emitido ao chegar a zero.
- A fase apresenta uma transição de derrota de cerca de 1 s e retorna ao
  checkpoint com saúde cheia. Atualmente há tentativas ilimitadas.
- A apresentação usa pose de dano na derrota; não existe sequência narrativa
  de morte independente. Revisar clareza em E01 antes de criar animação adicional.
- Água e quedas nos mundos novos usam retorno à margem segura enquanto houver
  saúde. E01/E03 precisam preservar a distinção entre dano ambiental e derrota.

As lesmas usam `CharacterBody2D`, contato por área e verificação de sobreposição.
O ouriço, o inimigo aéreo e os chefes usam verificações de distância/posição.
Portanto, ampliar tamanho de personagens ou sprites exige conferir também esses
limites manuais; alterar somente a forma de colisão não cobre todos os contatos.

## 4. Inimigos e chefes

| Componente | Comportamento atual | Trabalho futuro |
| --- | --- | --- |
| Lesma | Patrulha, detecta borda, recebe salto/investida | Manter como inimigo inicial |
| Ouriço | Oscila e causa dano por espinhos | Manter e revisar comunicação visual |
| Inimigo aéreo | Movimento oscilatório, dano por contato, salto derrota | Reutilizar como base para variedade |
| Guardião do Bosque | Ataque anunciado e abertura para acerto | Preservar e ampliar padrões em E18 |
| Guardiões regionais | Variações de água, voo e engrenagens | Preservar mecânicas; substituir identidade da Coruja |

A troca para Gavião alcança nomes e diálogos em `expedition_level.gd`, avisos,
desenho e comportamento visual em `region_guardian.gd`, testes e documentação
de entrega. Renomear somente o título deixaria a antiga personagem no jogo.
A Coruja mentora precisará de encontros e apresentação próprios em E10–E12.

## 5. Progresso e armazenamento

O save atual guarda `save_version`, `stage`, `unlocked`, `finished`, `settings`
e estados em `levels`. Cada cena guarda personagem, checkpoint, conclusão,
resgate, itens, blocos, pedra, passagem, segredo e vitória no chefe. As cenas
novas acrescentam `mechanisms`.

- Atual: `user://campaign.json` no Windows e `tico.campaign.v1` no localStorage.
- Legado: `world1.json` / `tico.world1.v1`; protótipo: `progress.json` /
  `tico.progress.v1`. A migração mantém o original.
- Escrita nativa usa arquivo temporário e renomeação; Web usa escrita síncrona.
- Save danificado ou futuro fica protegido até confirmação de nova aventura.
- Retomada usa início ou bandeira, com saúde cheia; não salva a posição exata.

### Dependências que precisam mudar

1. **Pipo global:** `world_level.gd` bloqueia a troca conforme `rescued` local.
   `world_save.gd` rejeita resgate nas cenas 0/1. Alterar ambos e a restauração;
   acrescentar estado global migrável, inferido do resgate ou progresso posterior.
2. **Replay:** restaurar uma fase concluída abre diretamente o resultado.
   Separar conquistas permanentes do estado da tentativa para permitir jogar
   novamente sem apagar conquistas ou duplicar recompensas.
3. **Identidade dos itens:** IDs atuais são derivados das coordenadas. Ao expandir
   fases e mover itens, adotar IDs estáveis e migração explícita dos antigos.
4. **Mapa e Game Over:** `stage` é índice da cena, e cada mundo usa quatro índices,
   contando a arena. Criar destino de mapa explícito e testar as fronteiras entre
   mundos. Preservar desbloqueios; no primeiro mundo, retorno nele mesmo.
5. **Checkpoints:** hoje há uma bandeira e um booleano por cena. Fases maiores e
   áreas opcionais precisarão identificar qual ponto de retorno está ativo.
6. **Novos dados:** vidas compartilhadas, tutoriais vistos, narrativa, vilarejo,
   Nozes Douradas e áreas opcionais ainda não possuem campos próprios.

## 6. Textos fixos a substituir em E04

O objetivo é remover orientação explicativa permanente e apresentar dicas no
contexto. Manter identificação da fase/personagem, corações, contadores, botões,
opções e mensagens necessárias de erro/salvamento.

| Origem | Conteúdo identificado | Destino |
| --- | --- | --- |
| `world_level.gd`, `_build_solo_or_arena()` e `_sign()` | “Siga as nozes”, “Pule • Segure para planar”, “Pule sobre a lesma”, “Bata por baixo dos blocos”, “Uma trilha escondida…”, “Espinhos! Passe por cima”, instruções do Guardião | Gatilhos de proximidade, símbolos e dicas curtas |
| `world_level.gd`, resgate e tabela `hints` | “Pule sob o bloco rachado para libertar Pipo”, “Encontre Pipo”, “Pipo • Empurre”, “Tico • Passagem”, “Pipo • INVESTIR”, “Snif, snif…”, “Até a árvore” | Resgate e tutorial contextual da dupla |
| `expedition_level.gd`, `_river()` | Esperar troncos, empurrar, seguir sobre troncos, bandeira e investir na engrenagem | Dicas na primeira situação de cada tipo |
| `expedition_level.gd`, `_mountain()` | Passagem estreita, faro, subida ao ninho, segurar PULO no vento e abrir a cauda | Tutorial de caverna e vento |
| `expedition_level.gd`, `_village()` | Peso, comporta, túnel drenado, elevador e sequência de engrenagens | Indicação no mecanismo relevante |
| `expedition_level.gd`, `_boss_arena()` | Água, pouso da antiga Coruja e elevador do Rei Castor | Introdução contextual de cada encontro; atualizar referência ao Gavião |
| `tico_minigame.gd`, `_process()` | “Explore · Colete nozes · Encontre a bandeira” e “Bandeira ativada · Siga até a chegada” | Retirar fallback explicativo permanente do HUD |
| `coop_level.gd`, `_process()` | “Pipo · AÇÃO/E: investir · Faro automático” e instrução de planar/trocar | Dica por primeira utilização, com registro persistente |
| `world_level.gd`, `_process()` | Nome da fase seguido de “Siga as nozes” antes do resgate | Manter título separado; retirar a instrução recorrente |

Os textos de `$Signs` do playground e a linha `HUD/Instructions` são ocultados
pela cadeia da campanha atual. Permanecem nas cenas históricas: não confundir
texto definido em código com texto visível no jogo. As placas da campanha são
Labels adicionadas em `Actors` e continuam visíveis no cenário.

`_say()` já oferece mensagens temporárias, incluindo avisos de ataques, dano,
checkpoint e faro. Reaproveitar a apresentação, acrescentando gatilhos e registro
de tutoriais vistos. Não remover os avisos de perigo junto com as placas fixas.

## 7. Classificação para execução

### Manter

- Controladores, sensibilidade, salto, planagem, câmera e multitoque.
- Saúde compartilhada, proteção contra dano repetido e regras físicas da troca.
- Resgate jogável de Pipo, esforço de Tico e passadas de Pipo ao empurrar.
- Mundos existentes, mecanismos e padrões aproveitáveis dos chefes.
- Áudio, arte existente, pausa, confirmação de reinício e proteção do save.
- Exportação, cache por versão, offline e testes históricos.

### Alterar

- Integrar derrota a vidas/Game Over sem duplicar a lógica de saúde (E01–E03).
- Dicas e HUD explicativo (E04); schema e migração do save (E05).
- Campanha linear para mapa e replay (E06–E07); separar tentativa de conquistas.
- Globalizar liberação de Pipo na base de progresso, integrando seleção e replay
  quando o mapa entrar; ampliar apresentação e desafios em E13–E15.
- Trocar identidade do chefe aéreo na integração narrativa e revisar em E18.
- Expandir fases por conteúdo e áreas opcionais; validar duração em uma fase
  completa antes de fixar metas para todos os mundos.

### Remover ou substituir, nas etapas correspondentes

- Placas explicativas e fallbacks permanentes listados na seção 6.
- Identidade da Coruja como adversária, preservando sua função de mentora.
- Bloqueio local de Pipo em fases iniciais após o resgate global.
- Avanço direto como único caminho entre fases, substituído pelo fluxo do mapa.

Não apagar cenas históricas, conquistas ou código funcional em E00.

### Criar

- Vidas, Game Over e destino persistente no mapa do mundo anterior.
- Mapa navegável, seleção de fases e estado de nova tentativa/replay.
- Tutorial contextual persistente; áreas opcionais, portais e Nozes Douradas.
- Sistema narrativo, abertura, Coruja mentora e evolução visual do vilarejo.
- Novos comportamentos de inimigos, padrões dos chefes e ajuda adaptativa nas
  etapas previstas, depois de validar os respectivos protótipos.

## 8. Dependências e próximos passos

1. **E01:** revisar a saúde existente, transição de derrota e fontes de dano;
   manter os parâmetros aprovados salvo evidência de problema.
2. **E02–E03:** integrar vidas e retorno. E02 prepara o destino e uma tela
   transitória; E06 conecta ao mapa. Não marcar mapa como pronto antecipadamente.
3. **E04–E05:** trocar dicas e ampliar persistência. O registro de dicas vistas
   deve usar campos versionados desde sua introdução.
4. **E06–E07:** mapa e replay dependem de save migrável, desbloqueio global e
   separação entre conquistas permanentes e estado da tentativa.
5. **E08 em diante:** validar uma área opcional, recompensas e uma fase completa
   antes da expansão em escala. A duração continua hipótese até esse teste.

PWA, desempenho e save acompanham todas as etapas, com verificações proporcionais
ao impacto. Os testes finais E25–E27 ampliam a cobertura, não adiam essas validações.

## 9. Evidências e limites

Execução e resultados da E00: [tests/evolucao_e00.md](../tests/evolucao_e00.md).
Os testes desta etapa estabelecem a base técnica; não implementam nem aprovam
a diversão das novas mecânicas. Playtest da etapa 9 e medições em celular físico
continuam pendentes. Nenhum commit ou push faz parte desta entrega.
