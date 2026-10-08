# Pipo e o transporte de objetos — refinamento 0.39.0

As três fases de percurso do Mundo 2 receberam cestos de provisões destinados
ao vilarejo. O sistema torna a força de Pipo parte da missão principal.

## Funcionamento

- Próximo do cesto, `AÇÃO` recolhe a carga em vez de iniciar a investida.
- Pipo ergue a cesta em uma transição curta, segura-a acima da cabeça e passa a
  andar a 150 px/s com passos, braços elevados e expressão de esforço.
- O salto e a troca de personagem ficam bloqueados durante o transporte.
- `AÇÃO` fora do destino solta o cesto, que pode ser recolhido novamente.
- Aproximar-se da carroça inicia automaticamente a entrega e conclui o mecanismo.
- Sofrer dano faz Pipo soltar a carga no local.

Em 2-1, Pipo alcança a cesta diretamente depois da travessia da mola. O antigo
mecanismo de rocha, corda, alavanca e barreira foi removido. A missão preserva
o transporte das provisões e a entrega à carroça.

A cesta possui trama de madeira, aro, tecido e alimentos legíveis. O destino usa
carroça de madeira conduzida por um burrinho simpático e indicação `ENTREGA • AÇÃO`.
Pipo usa uma sequência própria de quatro poses enquanto leva a cesta acima da cabeça,
com passada pesada e expressão de esforço. A cesta, a carroça e o burrinho usam arte
ilustrada coerente com as frutas, personagens e objetos do bosque. A
posição acompanha Pipo somente enquanto ele o carrega.

As quatro poses usam um recorte alinhado à sola dos pés. A margem transparente
inferior do sprite sheet e o balanço vertical do quadro foram removidos, mantendo
Pipo apoiado no terreno durante toda a caminhada com a cesta.

Na entrega, a cesta é reduzida para caber dentro do compartimento e desenhada
atrás da parede frontal da carroça. O controle é pausado por cerca de três
segundos: o burrinho inicia uma caminhada de quatro poses, as rodas avançam em
quatro posições, a carroça produz poeira e sai pela direita rumo ao vilarejo.
Quando ela deixa a tela, o controle retorna ao personagem ativo e a mensagem
orienta o jogador a seguir para o portal.

A troca visual da carga é exclusiva: ao entrar na área de entrega, os controles
são suspensos e Pipo estende os braços. O cesto deixa suas mãos, percorre um arco
curto, diminui até o tamanho do compartimento e se encaixa atrás da lateral da
carroça. A mensagem informa que a comida seguirá para o vilarejo; então o
burrinho parte. O controle retorna somente depois que ele sai da tela.

Saves anteriores recebem as novas entregas automaticamente quando a fase já
estava concluída ou tinha checkpoint, preservando o progresso existente.

## Estrutura consolidada do Mundo 2

| Fase | Papel principal de Pipo |
|---|---|
| 2-1 | Vencer o vento, usar a mola de peso, derrubar a rocha no rio e transportar provisões |
| 2-2 | Ativar plataformas de peso e atravessar usando balsas móveis |
| 2-3 | Romper inimigos blindados e transportar provisões |
| 2-4 | Romper a defesa do Guardião para que Tico acerte a cabeça |

Cada um dos três acertos do chefe exige a investida de Pipo seguida pelo salto
de Tico. A abertura permanece ativa durante a troca, e Pipo fica protegido do
contato depois de romper a defesa.

## Refinamento 0.40.5

A cesta entregue mant�m 68 px de altura, fica centralizada dentro do compartimento e termina o arco na mesma posi��o usada pela carro�a em movimento. A parede frontal cobre sua base para criar um encaixe com profundidade, sem flutua��o ou redu��o brusca.
