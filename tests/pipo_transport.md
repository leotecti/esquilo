# Pipo e o transporte de objetos — 0.36.5

As três fases de percurso do Mundo 2 receberam cestos de provisões destinados
ao vilarejo. O sistema torna a força de Pipo parte da missão principal.

## Funcionamento

- Próximo do cesto, `AÇÃO` recolhe a carga em vez de iniciar a investida.
- Pipo segura visualmente o cesto e passa a andar a 150 px/s.
- O salto e a troca de personagem ficam bloqueados durante o transporte.
- `AÇÃO` fora do destino solta o cesto, que pode ser recolhido novamente.
- `AÇÃO` dentro da marca dourada entrega as provisões e conclui o mecanismo.
- Sofrer dano faz Pipo soltar a carga no local.

O cesto usa desenho vetorial simples com frutas e uma marca de entrega estática.
Não há textura adicional, partículas contínuas ou física aplicada ao objeto. A
posição acompanha Pipo somente enquanto ele o carrega.

Saves anteriores recebem as novas entregas automaticamente quando a fase já
estava concluída ou tinha checkpoint, preservando o progresso existente.

## Estrutura consolidada do Mundo 2

| Fase | Papel principal de Pipo |
|---|---|
| 2-1 | Resistir à correnteza e empurrar o tronco que abre a passagem final |
| 2-2 | Ativar plataformas de peso e atravessar usando balsas móveis |
| 2-3 | Romper inimigos blindados e transportar provisões |
| 2-4 | Romper a defesa do Guardião para que Tico acerte a cabeça |

Cada um dos três acertos do chefe exige a investida de Pipo seguida pelo salto
de Tico. A abertura permanece ativa durante a troca, e Pipo fica protegido do
contato depois de romper a defesa.
