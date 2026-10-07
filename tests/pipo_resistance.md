# Resistência de Pipo — 0.36.2

Pipo passa a expressar seu peso durante a movimentação:

- recebe 45% do recuo horizontal e vertical de golpes;
- recebe 30% da aceleração causada pelo vento;
- recebe 25% da aceleração de correntezas;
- continua sofrendo dano normalmente, preservando o risco dos encontros.

O Mundo 2 ganhou faixas caminháveis de correnteza. Água translúcida e setas
claras indicam a direção sem partículas ou nós adicionais. A força ambiental é
compartilhada pelo controlador dos personagens e pode ser reutilizada durante a
expansão das fases do rio.

O teste específico valida as três resistências, as zonas do rio e a preservação
do dano. Os percursos existentes do rio, vento, empurrão e cooperação também são
executados como regressão.
