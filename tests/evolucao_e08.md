# Evolução E08 — Áreas opcionais e exploração

Versão **0.16.0**. Primeira área secundária implementada na fase **1-1 — Primeiros Passos**.

## Percurso

Após os primeiros degraus da trilha, suba os três galhos da árvore. No arco
do alto, pressione **E** ou o botão **AÇÃO** para entrar na **Copa dos Segredos**.
Suba as plataformas para coletar quatro nozes. Há uma bandeira local na primeira
plataforma e dois portais de retorno: na entrada e no fim do desafio.

A área é opcional: o caminho principal continua aberto e não exige essas nozes.
Tico e Pipo podem usá-la; Pipo depende do resgate, como nas demais fases.

## Estado e segurança do retorno

- A mesma fase conserva seus inimigos, itens, conclusão e bandeira principal.
- A copa usa câmera delimitada e transição breve, sem trocar o save da fase.
- Morrer na copa retorna à entrada ou à bandeira local, descontando uma vida.
- Sair pelo portal devolve o personagem ao alto da árvore. A próxima morte no
  caminho principal usa sua bandeira original.
- Fechar o jogo na copa recupera a entrada ou a bandeira local; itens coletados
  permanecem coletados. Consultar o mapa preserva a tentativa.
- Game Over usa o fluxo existente do mapa. Reiniciar ou rejogar a fase começa
  no caminho principal, preservando as conquistas e os itens já registrados.
- Save V2 recebe o campo opcional `levels["0"].optional_area`, com dois booleanos:
  `active` e `checkpoint`. Saves anteriores sem esse campo continuam válidos.
- As quatro nozes usam IDs estáveis no array de itens existente. Não há nova
  moeda ou regra de vida extra; a ampliação das recompensas permanece na E09.

Implementação: `scripts/systems/optional_area.gd`. A área usa personagens,
vegetação, nozes, bandeira e materiais já presentes no projeto.

## Validação

**497 verificações Godot e 23 cenários de navegador passaram**, incluindo o
percurso completo da copa por teclado e os portais por toque com Pipo.
As regressões automatizadas do loop principal também passaram nesta versão.

- `tests/optional_e08_test.gd`: entrada, câmera, retorno, bandeiras independentes,
  morte, Game Over, reinício, itens, reabertura e validação do save.
- Navegador: subida real pelos galhos, quatro coletas, portais, reabertura offline
  e uso dos portais por toque com Pipo.
- Regressões do ciclo principal: saúde, vidas, checkpoints, tutorial, progresso,
  persistência, mapa e resultados.
- Desempenho: `tests/optional_e08_performance.gd`, relatório
  `builds/performance-e08-windows.json`.

Intel Iris Xe, Windows Compatibility, 1280×720, 179–181 amostras por cenário:

| Cenário | Mediana | p95 |
| --- | ---: | ---: |
| Trilha principal | 16,64 ms | 17,60 ms |
| Copa opcional | 16,70 ms | 18,42 ms |
| Retorno da copa | 16,62 ms | 17,63 ms |

## Pacotes

- Web/PWA: `builds/web/Tico-evolucao-E08-web.zip`.
- Windows: `builds/windows/Tico-evolucao-E08-windows.zip`.
- Pastas: `builds/web/evolucao_e08/` e `builds/windows/evolucao_e08/`.

## Conferência no celular

1. Publique o ZIP Web em `/tico/` sem apagar os dados do site.
2. Abra ou rejogue **Primeiros Passos**. Suba os galhos próximos aos primeiros degraus.
3. Use **AÇÃO** no portal e explore a copa. Confira câmera, saltos e controles.
4. Ative a bandeira, colete nozes e confira que morrer não duplica a recompensa.
5. Saia pelos portais e siga o caminho principal normalmente.
6. Feche na copa e reabra offline; confira posição segura e itens preservados.
7. Se Pipo estiver desbloqueado, confira também sua troca e o botão de ação.

Sem commit, push ou publicação automática. Desempenho e conforto dos saltos
no celular aguardam a conferência do usuário.
