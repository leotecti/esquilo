# Etapa 9 — Rio, Montanha e Vila

Data: 2026-09-30. Implementação solicitada após aprovação da etapa 8.
Alterações sem commit ou push. Playtest desta versão no aparelho ainda pendente.

## Conteúdo

| Mundo | Fases | Mecânicas | Encontro final |
| --- | --- | --- | --- |
| Rio das Pedras | Atravessando o Rio, Correnteza, A Grande Ponte | Água, troncos móveis, tronco empurrável e ponte por investida; cachoeira no cenário | Guardião do Rio: água anunciada, salto ou investida na abertura |
| Montanha das Corujas | Vento nas Alturas, Cavernas da Montanha, O Ninho das Corujas | Subida, vento durante o salto/planagem, cavernas baixas, faro, plataformas suspensas e inimigos aéreos | Coruja: mergulho anunciado, pouso e salto de Tico |
| Vila dos Castores | A Vila Mecânica, A Grande Barragem, As Engrenagens | Peso de Pipo, engrenagens por investida, elevadores, tronco e comporta que drena a passagem | Rei Castor: Pipo liga elevador; Tico evita ataque e salta sobre o chefe |

Cada encontro tem cena própria ao final da terceira fase, como no Bosque.
Os três chefes avisam por 1,2 s, atacam por 0,7 s e abrem uma janela de 4 s.
Três acertos encerram o encontro de forma amigável. Não há limite de tempo.
Pipo já está disponível ao entrar no Rio. Coletar todas as nozes é opcional.

As primeiras fases de cada mundo foram construídas e testadas por comandos
antes das seguintes. A validação do conjunto ajustou largura dos elevadores
para facilitar embarque e chegada ao patamar. Nas arenas, há espaço para esperar
fora do alcance dos ataques. Contra o Rei Castor, comece o salto com distância.

Água e quedas retiram um coração e retornam à última margem segura. Ao perder
todos os corações, o retorno usa a bandeira. Plataformas e chefes respeitam pausa.
Fundos SVG distinguem os três ambientes; personagens, música e efeitos existentes
são reaproveitados. Objetos e chefes novos usam desenho vetorial por código.

## Campanha e persistência

- `main.tscn` inicia `expedition_campaign.gd`: 16 cenas, quatro por mundo.
- `expedition_level.gd` reaproveita os controladores, HUD, áudio e save do Bosque.
- Slot atual: `user://campaign.json` / `tico.campaign.v1`, versão 1.
- Na ausência desse slot, importa `world1.json` / `tico.world1.v1`, mantendo o
  original intacto. Bosque concluído libera **Seguir para o Rio**; Bosque em
  andamento mantém fase, resgate, itens e preferências. Sem save, começa em 1-1.
- Mecanismos ativados, nozes, segredo, checkpoint, personagem e conclusão são
  persistentes. A retomada reconstrói pontes, comportas e elevadores antes do jogo.
- Saves inválidos ou futuros ficam protegidos. Nova aventura pede confirmação
  e reinicia a campanha, preservando preferências de áudio.
- O final da Vila conclui o conteúdo da etapa 9. A Árvore do Mestre Corvo e o
  desfecho completo pertencem à etapa 10.

## Testes na Godot

| Suíte | Verificações aprovadas |
| --- | ---: |
| `expedition_test.gd` — Rio inicial, transporte, água e pausa | 7 |
| `mountain_first_test.gd` — subida, vento e conclusão | 3 |
| `village_first_test.gd` — peso, elevador e conclusão | 5 |
| `expedition_routes_test.gd` — seis fases restantes por comandos | 22 |
| `expedition_boss_test.gd` — três encontros completos por comandos | 19 |
| `expedition_save_test.gd` — migração, mecanismos, segredo, transições e reabertura | 73 |
| Regressão: `world_test`, `world_rules_test`, `push_animation_test`, `tico_test`, `coop_test`, `prototype_test`, `slice_test` | 220 |
| **Total** | **349** |

Percursos e combates usam comandos de movimento e habilidades. Testes isolados
de transporte e persistência usam posicionamento/fixtures para conferir cada
regra; não representam playtest humano. A campanha histórica do Bosque usa
`world_1_campaign.tscn` para conservar sua suíte de quatro cenas.

Comandos, na raiz do projeto:

```powershell
$engine = 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_win64_console.exe'
& $engine --headless --path . --script tests/expedition_routes_test.gd --fixed-fps 60
& $engine --headless --path . --script tests/expedition_boss_test.gd --fixed-fps 60
& $engine --headless --path . --script tests/expedition_save_test.gd --fixed-fps 60
npm.cmd run build:web
npm.cmd run test:web
```

## Navegador e Windows

`tests/browser/expedition.spec.js` cobre cinco cenários: migração do Bosque e
Rio com retomada offline; percurso da Montanha; peso, troca, multitoque,
pausa e rotação na Vila; investida na comporta e reabertura; proteção de save
futuro e confirmação de reinício. Fixtures iniciam cada cenário com progresso
válido. A telemetria `?test=1` continua somente leitura.

Os cinco cenários passaram: três na execução inicial e dois após corrigir a
sincronização do teste com a tela de resultado e o início do gesto multitoque.

O executável Windows foi aberto com Compatibility/Intel Iris Xe, sem erros.
Medição gráfica local: 181 quadros por cena, quatro cenas, com partículas.
Medianas entre 16,64 e 16,73 ms; p95 entre 17,84 e 18,12 ms. São amostras
locais, sem garantia de desempenho em outros aparelhos.
Relatório: `builds/performance-stage9-windows.json`.

## Entrega e roteiro no aparelho

- Web: `builds/web/Tico-etapa-9-web.zip`.
- Windows: `builds/windows/Tico-etapa-9-windows.zip`.
- Publicação manual: extrair o conteúdo Web diretamente em `/tico/`, incluindo
  `.htaccess`. [Instruções de publicação](../web/deployment.md).

1. Atualize os arquivos sem limpar os dados do navegador. Use **Atualizar**
   quando oferecido; confira **Seguir para o Rio** após o Bosque concluído.
2. Rio: atravesse os troncos, empurre um com Pipo, baixe a ponte e ajude o Guardião.
3. Montanha: plane no vento, atravesse a caverna com Tico, encontre o segredo
   com Pipo e espere a Coruja pousar antes de saltar por cima.
4. Vila: teste peso, elevadores, comporta e engrenagens; ajude o Rei Castor.
5. Feche após ativar uma bandeira/mecanismo. Reabra e confira progresso e nozes.
6. Repita offline pela PWA instalada. Teste toque simultâneo, pausa, áudio e rotação.
7. Avalie leitura dos caminhos, dificuldade, visual e fluidez por dez minutos.
   Registre aparelho e qualquer ponto em que a dupla fique presa.

Aceite do usuário e medição no celular físico permanecem pendentes.
