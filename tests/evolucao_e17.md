# Evolução E17 — famílias de inimigos

## Entrega

A E17 completa seis famílias com aparência e comportamento próprios:

| Inimigo | Onde é apresentado | Comportamento |
| --- | --- | --- |
| Lesma | 1-1 — Primeiros Passos | patrulha lenta e previsível |
| Besouro | 1-2 — Blocos e Segredos | patrulha e acelera quando o jogador se aproxima |
| Porco-espinho | 1-2 — Blocos e Segredos | ameaça defensiva que deve ser evitada por cima |
| Aranha | 1-3 — Um Novo Amigo | movimento vertical preso a um fio |
| Morcego | Montanha | patrulha aérea ondulante |
| Corvo patrulheiro | Montanha, depois do morcego | aproximação curta quando detecta o jogador |

## Direção visual

As seis imagens-base ficam em `assets/enemies/`, com tela de 512 × 384 e
transparência. Cada criatura possui uma prancha de quatro quadros em
`assets/enemies/animation/`, com 2048 × 384. `enemy_art.gd` seleciona os quadros,
a direção, o fio da aranha e os sinais breves de alerta.

Lesma, besouro, aranha e porco-espinho mantêm uma linha de contato fixa com o
solo. A lesma comprime e estende o corpo; os demais alternam as patas. Morcego e
corvo articulam as asas sem comprimir ou reduzir o corpo inteiro.

O desenho geométrico provisório permanece apenas como fallback interno e fica
invisível quando a ilustração é carregada. Colisões e alcance não dependem das
dimensões da imagem.

## Regras

- lesma, besouro, aranha, morcego e corvo aceitam pisão e caudada;
- porco-espinho rejeita a caudada e causa dano pelo contato lateral;
- todos os inimigos comuns reaparecem depois da perda de uma vida;
- uma família é apresentada antes de aparecer em combinação;
- Primeiros Passos não recebe inimigos novos e preserva a curva da E16;
- inimigos não recebem saúde adicional para aumentar artificialmente a duração.

## Verificação

- `evolucao_e17_test.gd`: **39 verificações aprovadas**;
- `evolucao_e16_test.gd`: **20 verificações aprovadas**;
- `world_rules_test.gd`: **10 verificações aprovadas**;
- `tail_e14_test.gd`: **19 verificações aprovadas**;
- `mini_adventure_validation_test.gd`: **35 verificações aprovadas**.

## Roteiro de playtest

1. Em 1-1, confirme que a lesma continua sendo o único inimigo e é fácil de ler.
2. Em 1-2, aproxime-se do besouro e observe a aceleração. Passe por cima do
   porco-espinho e confira se os espinhos parecem perigosos antes do contato.
3. Em 1-3, observe um ciclo completo da aranha e atravesse quando ela subir.
4. Na Montanha, compare o voo previsível do morcego com a perseguição do corvo.
5. Teste pisão e caudada nos inimigos vulneráveis; a caudada não deve derrotar o
   porco-espinho.
6. No celular, confira se pés e patas permanecem apoiados, sem flutuação ou
   mudança de tamanho, e se as asas completam todo o ciclo.
7. Confira tamanho, transparência, fluidez e identificação das silhuetas sobre
   fundos claros e escuros.

## Arte

As ilustrações e os ciclos foram gerados com a ferramenta integrada de imagens
usando cada inimigo aprovado como referência. Os pedidos preservaram desenho,
paleta e proporções, exigiram quatro poses separadas, fundo transparente, linha
de apoio constante e ausência de cenário, texto, cortes ou elementos soltos.
