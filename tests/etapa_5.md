# Etapa 5 — Pipo e Trilha da Amizade

## Entrega

Cena principal: `scenes/levels/coop_trail.tscn`. As cenas anteriores permanecem
disponíveis para F6 e testes de regressão. A etapa 4 foi publicada e aprovada
pelo usuário antes do início desta etapa.

| Controle | Teclado | Celular |
| --- | --- | --- |
| Movimento | A/D ou setas | Setas |
| Salto | Espaço | PULO |
| Planar com Tico | Manter Espaço na queda | Manter PULO na queda |
| Investida de Pipo | E | INVESTIR, no lugar de AÇÃO |
| Troca | Q | Trocar, no topo |
| Faro de Pipo | Automático perto do segredo | Automático perto do segredo |

Trocar exige chão e espaço livre, fora da investida, pausa, derrota e resultado.
Tico e Pipo compartilham vida e nozes; trocar não recupera corações nem proteção.
Pipo tem camisa verde, é maior, corre a 220 px/s e salta menos que Tico.
O personagem inativo fica oculto, sem física ou colisões.

## Percurso

1. Passe pela primeira lesma e chame Pipo perto da pedra.
2. Empurre para a direita até a marca dourada abrir o portão.
3. Troque para Tico, pule a pedra e atravesse a passagem baixa.
4. Ative a bandeira, chame Pipo e invista na parede pesada com E/INVESTIR.
5. Siga as partículas do faro perto dos arbustos para revelar a noz escondida.
6. Passe pela última lesma e entre na árvore. Coletar as nove nozes é opcional.

O retorno após derrota mantém o personagem ativo e o progresso dos objetos,
restaurando vida e inimigos. Recomeçar/Jogar de novo restaura tudo e seleciona Tico.

## Validação automatizada

```powershell
$engine = 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_win64_console.exe'
& $engine --headless --path . --script tests/coop_test.gd --fixed-fps 60
& $engine --headless --path . --script tests/foundation_test.gd --fixed-fps 60
& $engine --headless --path . --script tests/tico_test.gd --fixed-fps 60
& $engine --headless --path . --script tests/minigame_test.gd --fixed-fps 60
npm.cmd run build:web
npm.cmd run test:web
```

**54 verificações novas aprovadas**, incluindo:

- Troca por Q, câmera/HUD, corpo inativo, espaço para Pipo e troca junto à pedra.
- Diferenças de velocidade/salto e ausência de planar em Pipo.
- Vida/proteção compartilhadas e bloqueio de troca em situações incompatíveis.
- Pedra imóvel para Tico, empurrada por Pipo, limite e abertura da passagem.
- Pipo bloqueado no túnel; Tico atravessa; troca dentro do túnel recusada.
- Bloco pesado resiste a Tico e a Pipo parado, mas quebra durante a investida.
- Preparação, avanço, impacto, recuperação e pausa da habilidade.
- Pista do faro, revelação, coleta única e reinício do segredo.
- Checkpoint, derrota, estado dos objetos, resultado e reinício completo.
- Travessia inteira usando comandos de movimento, salto, troca e ação.

Também passaram as 16 verificações de fundação, 45 de Tico e 38 do minigame:
**153 verificações da engine** no total.

**Cinco cenários de navegador aprovados** com o WASM exportado: teclado/tela
cheia, manifesto/cache/reabertura offline, multitoque de Tico, puzzle completo
da dupla até resultado e nova partida, e troca/investida de Pipo com multitoque.
O botão Trocar tem pelo menos 44 pixels CSS no celular emulado de 844 × 390.
O cancelamento de toque libera direção e ação. Capturas em `builds/web/`:
`preview-etapa5-pipo-touch.png`, `preview-etapa5-faro.png` e `preview-etapa5-final.png`.

## Builds e playtest

- Web: `builds/web/etapa_5/` e `builds/web/Tico-etapa-5-web.zip`.
- Windows: `builds/windows/etapa_5/Tico.exe` com `Tico.pck` e ZIP correspondente.
- Publicação: [HostGator](../web/deployment.md).

O executável Windows exportado foi aberto a partir da pasta do build em modo
headless, encerrando com código 0 e sem erros. As capturas Web foram inspecionadas.

O usuário confirmou acesso normal e funcionamento de corrida, salto, troca
de personagem, empurrar e botão de ação. Esses controles estão aprovados no
playtest relatado. O aparelho e o navegador não foram especificados.

Falta confirmar no playtest o faro para encontrar o segredo e a conclusão do
puzzle até a chegada. Esses fluxos já passaram nos testes automatizados.
A emulação não mede desempenho do aparelho.
