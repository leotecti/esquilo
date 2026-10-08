# Pipo e o transporte de objetos — refinamento 0.37.3

As três fases de percurso do Mundo 2 receberam cestos de provisões destinados
ao vilarejo. O sistema torna a força de Pipo parte da missão principal.

## Funcionamento

- Próximo do cesto, `AÇÃO` recolhe a carga em vez de iniciar a investida.
- Pipo ergue a cesta em uma transição curta, segura-a acima da cabeça e passa a
  andar a 150 px/s com passos, braços elevados e expressão de esforço.
- O salto e a troca de personagem ficam bloqueados durante o transporte.
- `AÇÃO` fora do destino solta o cesto, que pode ser recolhido novamente.
- `AÇÃO` dentro da marca dourada entrega as provisões e conclui o mecanismo.
- Sofrer dano faz Pipo soltar a carga no local.

A cesta possui trama de madeira, aro, tecido e alimentos legíveis. O destino usa
carroça de madeira conduzida por um burrinho simpático e indicação `ENTREGA • AÇÃO`.
Pipo usa uma sequência própria de quatro poses enquanto leva a cesta acima da cabeça,
com passada pesada e expressão de esforço. A cesta, a carroça e o burrinho usam arte
ilustrada coerente com as frutas, personagens e objetos do bosque. A
posição acompanha Pipo somente enquanto ele o carrega.

Saves anteriores recebem as novas entregas automaticamente quando a fase já
estava concluída ou tinha checkpoint, preservando o progresso existente.

## Estrutura consolidada do Mundo 2

| Fase | Papel principal de Pipo |
|---|---|
| 2-1 | Vencer o vento, usar a mola de peso, resistir à correnteza e empurrar o tronco final |
| 2-2 | Ativar plataformas de peso e atravessar usando balsas móveis |
| 2-3 | Romper inimigos blindados e transportar provisões |
| 2-4 | Romper a defesa do Guardião para que Tico acerte a cabeça |

Cada um dos três acertos do chefe exige a investida de Pipo seguida pelo salto
de Tico. A abertura permanece ativa durante a troca, e Pipo fica protegido do
contato depois de romper a defesa.
