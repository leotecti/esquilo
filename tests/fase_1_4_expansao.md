# Expansão da fase 1-4 — Periquito do Bosque

## Estrutura concluída

- Trilha principal ampliada para 38.000 unidades, próxima das fases 1-1, 1-2 e 1-3.
- Onze trechos com clareiras, degraus reversíveis, blocos, alimentos, nozes e corações.
- Lesmas, besouros, aranhas, ouriços e corvos em superfícies alcançáveis.
- Uma única bandeira, posicionada depois do retorno da área secundária.
- Arena limpa no fim da jornada, preservando o Periquito de três acertos e o portal final.

## Refúgio da Cachoeira

A passagem fica no centro da fase. A lâmina d'água, a abertura rochosa, a névoa e a
mensagem contextual indicam que `AÇÃO` atravessa a cachoeira. O refúgio possui
paisagem própria, percurso de rocha úmida com musgo, alimentos, nozes, corações, uma noz
dourada e seis encontros. A saída devolve Tico/Pipo adiante, perto da bandeira.

O terreno usa faces em verde-petróleo, lajes minerais irregulares, musgo nas
frestas, reflexos turquesa discretos e rachaduras. A arte é desenhada uma única
vez e mantém as colisões retangulares já validadas, evitando custo contínuo de
animação durante a exploração.

Esse desenho usa princípios comuns em fases profissionais: o portal é um marco visual,
a área opcional recompensa a curiosidade, o retorno confirma progresso e a aproximação
do chefe reduz distrações para tornar o confronto legível.

## Validação automatizada

`tests/fase_1_4_expansao_test.gd` verifica extensão, ordem cachoeira–retorno–bandeira,
quantidade de encontros, distribuição de alimentos, apoio de todos os coletáveis,
entrada e saída da área, câmera e validade do save.
