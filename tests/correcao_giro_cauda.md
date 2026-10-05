# Correção da caudada — giro de Tico (0.25.1)

A caudada deixou de ser uma varredura feita apenas pela cauda. Tico agora gira o
corpo inteiro e usa a cauda como extensão circular do movimento.

## Sequência visual

1. Tico abaixa o corpo e recolhe a cauda.
2. Começa a girar em vista lateral.
3. Mostra as costas durante a rotação.
4. A cauda atravessa a frente do corpo e alcança o adversário.
5. O corpo completa a volta.
6. Tico recupera o equilíbrio na postura frontal.

A nova prancha `assets/slice/tico_tail_spin.png` mantém seis poses igualmente
espaçadas e fundo transparente. A prancha anterior permanece no projeto como
referência e não é mais usada pelo jogo.

A prancha usa células iguais com margens transparentes laterais. Nenhuma cauda,
linha de movimento ou parte do corpo atravessa o limite do quadro. A pequena
margem vertical mantém Tico com o mesmo tamanho durante a preparação, o giro e
a recuperação.

## Sincronização e regras preservadas

- O acerto começa na metade da fase ativa, junto à varredura frontal da cauda.
- Alcance curto, direção do personagem e bloqueio por paredes foram mantidos.
- Cada inimigo recebe somente um acerto por giro.
- Porcos-espinhos, chefes, pedras e mecanismos preservam suas regras.
- Pausa, dano, derrota, troca de personagem e conclusão continuam cancelando ou
  bloqueando a ação nos momentos definidos anteriormente.

## Verificação

- `tail_e14_test.gd`: **19 verificações aprovadas**, incluindo as seis poses,
  preparação, quadros centrais do giro, impacto, direção, parede e recuperação.
- `coop_test.gd`: **54 verificações aprovadas**.
- `health_e01_test.gd`: **20 verificações aprovadas**.
- `mini_adventure_validation_test.gd`: **35 verificações aprovadas**.
- Navegador: o cenário **E14: caudada responde no navegador e respeita a
  recuperação** foi aprovado no build Web.

## Pacotes

- Web/PWA: `builds/web/Tico-0.25.1-giro-cauda-laterais-corrigidas-web.zip`.
- Windows: `builds/windows/Tico-0.25.1-giro-cauda-laterais-corrigidas-windows.zip`.

Os dois arquivos foram extraídos em pastas novas e tiveram seus arquivos
obrigatórios conferidos após a compactação.

Arte gerada com a ferramenta integrada de imagens a partir da prancha anterior,
mantendo o desenho de Tico como referência visual.
