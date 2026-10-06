# EVOLUÇÃO E22 — Balanceamento

**Status:** concluída  
**Perfil:** aventura acessível, sem níveis de dificuldade nesta etapa

## Perfil central

Os valores ajustáveis ficam em `scripts/systems/game_balance.gd`. O arquivo
concentra saúde, vidas, limite de vidas, nozes por vida, movimento, salto,
invulnerabilidade, planagem, velocidades dos inimigos, saúde e janelas dos
chefes, alcance progressivo, meta de duração, recuperação, alimentos,
checkpoint e evolução do vilarejo.

## Equilíbrio adotado

- 3 corações e 3 vidas iniciais.
- 100 nozes concedem uma vida; máximo de 99 vidas.
- Tico corre a 300 px/s e salta mais alto que Pipo.
- Inimigos comuns são vencidos com um golpe correto; o desafio está na leitura
  do movimento e no contato, não em repetir ataques.
- Chefes exigem três acertos. O alcance e o ritmo aumentam, mas o aviso nunca
  fica abaixo de um segundo e a vulnerabilidade permanece acima de 3,5 s.
- Primeiros Passos mantém 5–8 minutos como duração de exploração aprovada,
  ao menos 7 recuperações e checkpoint entre 55% e 68% da rota.
- A oferta generosa de alimentos e nozes no primeiro mundo ensina a economia e
  permite preparar vidas antes das fases seguintes.

O teste `evolucao_e22_test.gd` impede que esses valores voltem a se espalhar ou
se afastem silenciosamente do perfil aprovado.

As alterações permanecem sem commit, conforme solicitado.
