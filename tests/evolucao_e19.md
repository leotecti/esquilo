# Evolução E19 — vilarejo evolutivo

## Entrega

O mapa da jornada agora possui o botão **Visitar vilarejo**. A visita usa o
cenário apresentado na abertura e mostra as consequências permanentes da
aventura: provisões, cestos, moradores, preparação e celebração.

## Estados

| Estado | Condição salva | Resposta visual |
| --- | --- | --- |
| Escassez | menos de 20 alimentos e menos de 3 fases concluídas | luz fria, cesta vazia e pouco movimento |
| Recuperação | 20 alimentos ou 3 fases concluídas | primeiras cestas cheias e moradores trabalhando |
| Preparação | 75 alimentos ou 8 fases concluídas | mais provisões, moradores e bandeirolas |
| Comunidade abastecida | aventura concluída | cestas completas, comunidade reunida e celebração |

Alimentos coletados novamente durante uma revisita continuam ajudando o
vilarejo, conforme a regra estabelecida na E09. A conclusão final depende da
vitória da aventura, evitando que a coleta repetida antecipe o encerramento.

O estado é derivado de `survival.food_total`, das conclusões em `levels` e de
`finished`. As flags `story.village.state_0` até `state_3` registram o resultado
no Save V2. A tela não mantém um contador paralelo.

## Movimento e apresentação

- moradores surgem gradualmente e possuem movimento de respiração;
- os cestos recebem frutas conforme o estado;
- a iluminação fica mais quente durante a recuperação;
- bandeirolas aparecem no estado avançado;
- partículas de celebração aparecem somente após a vitória;
- a tela funciona com mouse, toque, teclado e áreas seguras do celular.

## Verificação

- `evolucao_e19_test.gd`: **11 verificações aprovadas** para os quatro estados,
  acesso pelo mapa, informações apresentadas, retorno e persistência;
- a regressão deve preservar Save V2, E18 e a aventura completa em miniatura.

## Roteiro de playtest

1. Abra o mapa e toque em **Visitar vilarejo** antes de coletar alimentos.
2. Confira a cesta vazia, a luz fria e o estado **Escassez**.
3. Colete pelo menos 20 alimentos e visite novamente.
4. Confira novas provisões, moradores e o estado **Recuperação**.
5. Continue a aventura até 75 alimentos ou oito fases concluídas.
6. Confira as bandeirolas e o estado **Preparação para o inverno**.
7. Termine a aventura e confira a celebração da comunidade abastecida.
8. Feche e reabra a PWA para confirmar a preservação do estado.
