# Evolução E20 — expansão de Blocos e Segredos

## Estrutura entregue

- Rota principal ampliada de 3.800 para 39.000 unidades.
- Duração alvo de 5 a 8 minutos em primeira exploração tranquila.
- Trecho histórico preservado como introdução aos blocos.
- Dez conjuntos próprios de salas, pilares, caminhos altos e tetos de blocos.
- Blocos comuns, quebráveis e de recompensa usados ao longo do percurso.
- Nozes, três tipos de alimento, corações, vidas e Nozes Douradas.
- Lesmas, besouros e ouriços intercalados com áreas seguras.
- Uma bandeira após a área secundária e chegada tranquila.

## Galeria das Pedras

A passagem fica aproximadamente no meio da rota. Um arco de alvenaria, rochas e
névoa comunicam a entrada; não há árvore. A galeria subterrânea tem 5.200 unidades,
plataformas próprias, três inimigos, recuperação, provisões, vida em bloco raro e
uma Noz Dourada. A saída retorna perto da bandeira para comunicar avanço.

## Validação automatizada

Execute:

```powershell
& 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_win64_console.exe' --headless --path . --script res://tests/evolucao_e20_test.gd
```

O teste confere dimensões, recompensas, blocos, inimigos, recuperação, posição da
bandeira, entrada e saída da galeria, câmera e compatibilidade do save. O roteiro
`optional_e08_test.gd` também deve continuar aprovado para proteger 1-1.

## Playtest recomendado

1. Percorra 1-2 sem entrar na galeria e confirme que a fase pode ser concluída.
2. Recomece, entre na ruína com **Ação** e explore os dois sentidos.
3. Saia pelo portal final e confirme o retorno antes da bandeira.
4. Volte ao início para verificar todos os degraus nos dois sentidos.
5. Reabra o jogo dentro da galeria e após ativar a bandeira.
6. Teste em celular a leitura dos blocos, da névoa e dos comandos de toque.

## Correção de navegação 0.30.1

A revisão encontrou paredes repetidas de 110, 120 e 160 pixels na rota principal
e acessos altos na galeria. A geometria foi refeita com degraus de até 80 pixels
e apoios intermediários. `blocks_secrets_route_test.gd` percorre os 39.000 pontos
com movimento e salto reais e confere numericamente todos os perfis repetidos.

### Correções de interação 0.30.2

- A caudada agora derrota também o porco-espinho; todos os seis inimigos comuns
  aceitam o golpe quando estão ao alcance e sem uma parede entre eles e Tico.
- A recompensa `galeria_12_life` foi autorizada no Save V2. O teste executa um
  salto real, acerta o bloco por baixo e confirma o acréscimo de uma vida.
- O portal final foi movido para a superfície da última plataforma e ampliado
  com moldura de pedra, névoa, luz e partículas. A saída é testada pelo comando
  de ação e retorna perto da bandeira.
- Na correção 0.30.3, o ponto de retorno e a bandeira foram transferidos para a
  faixa plana entre os conjuntos de pilares. O teste caminha após a transição e
  falha se o personagem nascer preso em terreno.

### Passagem noturna 0.30.4

A área secundária recebeu o fundo `assets/environment/night_forest_passage.png`,
uma pintura panorâmica com bosque profundo, luar e céu estrelado. Um véu azul
mantém contraste com personagens e plataformas; névoa e vaga-lumes procedurais
criam movimento sem adicionar colisões ou custo de física.


### Pedra e rota inferior 0.30.5

- A pedra empurrável usa a ilustração de rocha com volume, fissuras e musgo.
- O apoio invisível do segredo de revisita foi removido da fase 1-2.
- Duas lajes visíveis substituem a plataforma contínua e deixam uma abertura
  acessível para os inimigos, frutas e nozes do caminho inferior.

As alterações desta entrega permanecem sem commit, conforme solicitado.


### Navegação inferior 0.30.6

- Baixo, S e o novo botão de toque atravessam pontes sinalizadas.
- A fase 1-2 reutiliza a largura existente em dois níveis, sem aumentar o mapa.
- Setas douradas identificam superfícies atravessáveis; saltar permite retornar.
- Frutas e nozes ocupam as novas rotas inferiores junto dos inimigos existentes.
