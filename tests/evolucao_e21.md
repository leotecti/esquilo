# EVOLUÇÃO E21 — Áudio, animações e feedback

**Versão:** 0.31.0  
**Status:** concluída

## Entrega

- Passos, salto, pouso, coleta, dano, checkpoint, segredo e conclusão preservam
  os efeitos já aprovados.
- Vida extra, derrota, Game Over, desbloqueio, aviso do chefe e vitória sobre o
  chefe receberam efeitos sonoros próprios.
- Eventos centrais acionam clarão de cor, mensagem curta e, em impactos, tremor
  moderado de câmera.
- Vida extra e chefes combinam som, partículas e resposta visual.
- A passagem noturna reduz suavemente o tom e o volume da música; a saída
  restaura a ambientação do bosque.
- O mapa reforça uma nova fase com animação, aviso e som de desbloqueio.

## Validação automática

`evolucao_e21_test.gd` verifica os seis novos efeitos, clarão, mensagem, vida
extra, Game Over, retorno previsto, ambientação noturna e registro dos eventos.
Também foram repetidos os testes da E18, E20 e da apresentação audiovisual.

As alterações permanecem sem commit, conforme solicitado.
