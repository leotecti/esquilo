# Etapa 4 — Gameplay básico

## Entrega

Cena principal: `scenes/levels/tico_minigame.tscn`, **Trilha das Nozes**.
O playground das etapas anteriores permanece em `tico_playground.tscn`.
O minigame reutiliza o controlador e a interface de teclado/toque aprovados,
com uma cena própria para permitir evolução do percurso.

- Três corações, reação ao dano e proteção de 1,5 s com transparência intermitente.
- Recuperação de um coração por item; bandeira recupera todos.
- Derrota amigável de aproximadamente 1 s, retorno ao checkpoint ou início,
  restauração de vida e proteção temporária. A pausa suspende a transição.
- Três lesmas com patrulha, virada nos limites, paredes e bordas, contato lateral
  que causa dano e pisão durante a queda. O pisão dá impulso de -360 px/s.
- Treze nozes no percurso e uma no bloco, com contador, texto animado e som.
- Bloco comum sólido, bloco rachado quebrável e bloco dourado de noz.
  Os dois últimos são acionados por cabeçada; a recompensa não se repete.
- Checkpoint em x=2020 e chegada em x=3560, com comemoração e resultado.
- O objetivo é chegar à árvore; coletar todas as 14 nozes é opcional.

Arte provisória em vetores/formas 2D. Efeitos sonoros originais sintetizados
em PCM pelo jogo, sem recursos externos. AÇÃO e troca continuam reservadas.

## Regras de reinício

Ao perder os corações, preservam-se nozes coletadas, blocos utilizados e item
de recuperação consumido. As lesmas retornam às posições iniciais. Isso evita
duplicação de recompensas. O checkpoint existe somente na partida atual.
Recomeçar e Jogar de novo restauram tudo, inclusive contador e bandeira.
Não há save persistente nesta etapa.

## Validação automatizada

```powershell
$engine = 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_win64_console.exe'
& $engine --headless --path . --script tests/foundation_test.gd --fixed-fps 60
& $engine --headless --path . --script tests/tico_test.gd --fixed-fps 60
& $engine --headless --path . --script tests/minigame_test.gd --fixed-fps 60
npm.cmd run build:web
npm.cmd run test:web
```

Resultados: 16 verificações de fundação, 45 de movimento e 38 de gameplay
aprovadas. Os novos testes cobrem coleta sem duplicação, recuperação, dano,
proteção, patrulha, contato lateral, pisão, cabeçada nos três blocos, checkpoint,
derrota durante pausa, retorno, contagem e reset completo. Uma travessia real
usa somente comandos de movimento e salto, sem reposicionar Tico.

Quatro cenários Chrome/Playwright aprovados: teclado/tela cheia, cache/offline,
multitoque/rotação e travessia até resultado com nova partida. Os testes de
navegador executam o WASM exportado; incluem verificação de erros do console
e dimensionamento do HUD. Capturas em `builds/web/preview-touch.png`,
`preview-desktop.png` e `preview-etapa4-final.png`.

## Builds

- Web: `builds/web/etapa_4/` e `builds/web/Tico-etapa-4-web.zip`.
- Windows: `builds/windows/etapa_4/Tico.exe` com `Tico.pck` e
  `builds/windows/Tico-etapa-4-windows.zip`.
- Atualização na HostGator: [instruções](../web/deployment.md).

O executável Windows exportado foi iniciado a partir da pasta do build em modo
headless e encerrou com código 0, sem erros. As exportações não apresentaram
erros de script. O ZIP Web foi conferido quanto aos arquivos essenciais.

## Playtest da nova fase

1. Compare corrida, salto e planar com a etapa 3.
2. Encoste lateralmente na lesma e observe um coração e a proteção; depois pise nela.
3. Colete nozes nos caminhos baixo e alto e bata por baixo dos três blocos.
4. Use o item de recuperação e ative a bandeira.
5. Perca os três corações, confira retorno e contagem preservada.
6. Alcance a árvore, veja o resultado e reinicie a partida.
7. Após publicar, atualize a PWA e repita o percurso e o offline no celular.

Os testes automatizados não medem conforto ou FPS do celular.
O usuário confirmou o upload da etapa 4 e relatou que
funcionou muito bem, autorizando o início da etapa 5. Marco 3 aprovado.
