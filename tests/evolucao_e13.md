# Evolução E13 — introdução de Pipo (0.22.0)

A E13 mantém o resgate jogável de Pipo na fase 1-3 e completa sua apresentação.
O jogador conhece o personagem, entende por que ele está em perigo e descobre
por que a dupla decide seguir a aventura junta.

## Sequência

1. Tico encontra Pipo preso nos cipós.
2. Pipo conta que procurava comida para sua família.
3. A fala aponta o bloco rachado, mas o jogador executa o resgate.
4. Tico explica a missão recebida de Valda.
5. Pipo decide ajudar o bosque.
6. A cena demonstra a força de Pipo e a agilidade de Tico.
7. O percurso existente pede que o jogador mova a pedra e alcance a passagem.

Antes do resgate, somente Tico pode ser usado. Depois dele, Pipo é liberado na
campanha inteira e pode ser selecionado ao revisitar as fases iniciais.

## Apresentação e acessibilidade

- Tico e Pipo aparecem juntos sobre a paisagem do bosque.
- Retratos identificam quem está falando.
- As falas são curtas e podem ser avançadas ou puladas com mouse, teclado ou toque.
- A cena suspende o gameplay e devolve os controles ao terminar.
- `pipo_first_meeting` e `pipo_joins_team` persistem no Save V2.

## Compatibilidade

- O formato do save permanece V2.
- Campanhas antigas com Pipo desbloqueado continuam funcionando sem cena retroativa.
- Interromper e reabrir depois do primeiro encontro retoma a apresentação que falta.
- PWA, cache offline e tela cheia preservam o comportamento das entregas anteriores.

## Validação

- `pipo_e13_test.gd`: 15 verificações de narrativa, resgate, habilidades, save,
  revisita de fase e migração.
- Regressões de abertura, Valda, campanha, mapa e save continuam obrigatórias.
- O playtest no aparelho deve confirmar clareza das falas, tamanho dos personagens,
  ritmo da cena e compreensão da troca no desafio logo após o resgate.

Pacotes: `builds/web/Tico-evolucao-E13-web.zip` e
`builds/windows/Tico-evolucao-E13-windows.zip`. Sem commit ou publicação automática.
