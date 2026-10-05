# Evolução E14 — mecânicas de Tico e Pipo (0.23.0)

A E14 reforça a diferença entre os protagonistas. Tico ganha uma caudada terrestre
contra inimigos comuns. Os obstáculos de força, peso e resistência continuam
dependendo de Pipo.

## Caudada de Tico

- Teclado: **E**. Toque: botão **CAUDADA**.
- Somente no chão e sem deslocamento de investida.
- Preparação de 0,10 s, janela ativa de 0,14 s e recuperação de 0,28 s.
- Alcance frontal de 112 unidades, com conferência vertical e bloqueio por paredes.
- Um inimigo recebe no máximo um acerto por golpe.
- Manter o botão pressionado não repete automaticamente.
- Dano, derrota, checkpoint, reinício, conclusão e Game Over limpam o ataque.
- A troca de personagem fica bloqueada até terminar a recuperação.

| Alvo | Resultado |
|---|---|
| Lesmas | Derrotadas, preservando feedback e reaparecimento |
| Inimigos voadores próximos do chão | Derrotados |
| Porcos-espinhos | Não recebem o golpe |
| Guardiões e chefes | Mantêm suas regras atuais |
| Pedras, paredes e mecanismos | Continuam dependendo de Pipo |

## Apresentação

A prancha `assets/slice/tico_tail_strike.png` possui quatro poses próprias. Tico
prepara o corpo, move a cauda em dois momentos legíveis e retorna à postura normal.
O impacto usa mensagem curta, cor quente e efeito sonoro infantil.

Uma dica contextual apresenta a habilidade diante do primeiro inimigo comum. O
registro `tutorial_tail_seen` é incluído em campanhas novas e acrescentado aos
saves V2 existentes sem apagar progresso.

## Pipo preservado

- **E/INVESTIR** continua preparando e executando a investida.
- Empurrão, faro, corpo maior, salto menor e mecanismos de peso permanecem.
- A herança do controlador não permite que Pipo execute a caudada.

## Validação automatizada

- `tail_e14_test.gd`: 15 verificações específicas de entrada, animação lógica,
  direção, parede, pausa, repetição, dano, alvos, troca e investida de Pipo.
- `coop_test.gd`: 54 verificações da cooperação e percurso completo.
- `health_e01_test.gd`: 20 verificações de saúde, derrota e cancelamento.
- `progress_e05_test.gd`: 79 verificações de save e migração.
- `tutorial_e04_test.gd`: tutorial contextual e persistência revalidados.

## Playtest no aparelho

1. Use Tico perto de uma lesma e toque **CAUDADA**.
2. Confira os quatro momentos da animação e o impacto.
3. Segure o botão e confirme que ocorre somente um golpe.
4. Ataque para os dois lados e diante de uma parede.
5. Confirme que porcos-espinhos continuam perigosos.
6. Troque para Pipo e teste pedra, parede pesada, faro e **INVESTIR**.
7. Pause, sofra dano e perca uma vida durante tentativas diferentes.
8. Feche e reabra a PWA, inclusive offline.

Pacotes: `builds/web/Tico-evolucao-E14-web.zip` e
`builds/windows/Tico-evolucao-E14-windows.zip`. Sem commit ou publicação automática.
