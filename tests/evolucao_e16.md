# Evolução E16 — progressão de dificuldade

## Escopo

A E16 aplica uma curva única à fase modelo **1-1 — Primeiros Passos**. A criação
dos modos Fácil, Médio e Difícil foi adiada até o aceite final desta fase.

## Curva implementada

| Faixa | Intervalo | Encontros | Velocidade das lesmas |
| --- | ---: | ---: | ---: |
| Aprender | 0–5.200 | 2 | 45 |
| Praticar | 5.200–14.800 | 2 | 45 |
| Combinar | 14.800–27.600 | 2 | 50 |
| Desafiar | 27.600–40.500 | 2 | 55 |
| Chegada | 40.500–42.000 | 0 | — |

As faixas são dados em `first_steps_layout.gd`. Cada lesma recebe a identificação
da faixa e a velocidade correspondente. Isso permite testar a distribuição e
reutilizar o padrão quando as outras fases forem reestruturadas.

## Decisões preservadas

- largura de 42.000 unidades e duração esperada de 5 a 8 minutos;
- 271 nozes totais, alimentos, blocos e vidas;
- Copa dos Segredos no meio da fase;
- uma única bandeira depois da copa;
- geometria reversível para Tico e Pipo;
- inimigos em plataformas abertas;
- chegada sem inimigos para encerrar com clareza;
- Save V2, física, dano, saúde e recompensas sem alterações.

## Validação automatizada

`evolucao_e16_test.gd` verifica:

- cobertura contínua de toda a fase;
- duas lesmas em cada faixa jogável;
- velocidades 45, 45, 50 e 55;
- ausência de inimigos na chegada;
- bandeira na faixa de combinação;
- saída depois do último desafio.

Resultados:

- `evolucao_e16_test.gd`: **20 verificações aprovadas**;
- `first_steps_model_test.gd`: **24 verificações aprovadas**;
- `first_steps_refinement_test.gd`: **4 verificações aprovadas**;
- `mini_adventure_validation_test.gd`: **35 verificações aprovadas**.

## Roteiro de playtest

1. Percorra a fase sem entrar na copa e observe se os primeiros encontros ainda
   permitem compreender a lesma antes de exigir reação maior.
2. Confirme que as lesmas posteriores parecem um pouco mais ativas, sem impedir
   a passagem ou exigir tentativa cega.
3. Entre e saia da copa, continue pela bandeira e perceba se a retomada da curva
   é natural.
4. Faça o caminho de volta com Tico e Pipo para confirmar que nenhum encontro
   bloqueia o retorno.
5. Verifique se o trecho final permite recolher as últimas recompensas e alcançar
   a saída sem outro inimigo.
6. No celular, observe fluidez, aquecimento e resposta dos controles durante uma
   passagem completa de 5 a 8 minutos.
