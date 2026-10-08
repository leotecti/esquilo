# Fase 2-1 — foco em Pipo — refinamento 0.38.2

A fase `2-1 • Atravessando o Rio` usa Pipo como personagem principal durante
todo o percurso.

- O vento contrário cobre a fase inteira e possui rajadas visíveis distribuídas
  pelo cenário.
- Tico usa 10% de sua velocidade normal nessa fase: 30 px/s.
- Pipo usa 95% de sua velocidade normal nessa fase: 209 px/s.
- A resistência de Pipo ao vento foi reforçada para que ele avance e complete o
  salto da mola mesmo sob a rajada contínua.
- Todos os inimigos da fase recebem a regra `pipo_one_hit`: um salto de Pipo ou
  uma investida os derrota.
- A mola recebeu impulso de 340 px/s na horizontal e 1020 px/s na vertical para
  preservar a travessia até a plataforma alta sob o novo vento contínuo. A área
  de pouso possui margem suficiente para evitar quedas causadas por variações de quadro.

As regras de velocidade e combate são aplicadas somente quando `biome == 2` e
`section == 0`, sem modificar as outras fases.

## Refinamento visual e de percurso

- As rajadas usam linhas curvas em velocidades diferentes e dezoito folhas
  grandes, coloridas e giratórias, tornando a direção do vento explícita.
- Ao tentar andar, Tico usa quatro novas ilustrações a 2,4 quadros por segundo.
  Ele inclina o corpo, protege o rosto com uma pata e move os pés lentamente.
- A força alterna entre uma corrente mais suave e uma rajada: Tico avança alguns
  passos a 10% da velocidade e logo é levado para trás.
- A primeira plataforma móvel começa em `X 820`, inteiramente sobre o rio. A
  margem inicial termina em `X 760`, por isso a plataforma não forma mais um teto
  sobre o caminho de Pipo e continua acessível para atravessar a água.
- A prancha de esforço foi refeita com uma linha de chão comum. O terceiro quadro
  estende a perna direita e baixa a cauda; o quarto comprime as duas pernas e
  levanta a cauda para preparar o retorno ao primeiro quadro.
- O bloco de vida das fases com Pipo fica em `Y 625`. Sua base termina em `Y 654`,
  deixando 106 px até o solo para o corpo de 72 px de Pipo atravessar.
- O primeiro trecho de água começa em `X 760`, depois da margem, sem desenhar
  ondas sobre o solo em T01.
- O besouro derrotado desativa sua camada e sua forma de colisão. Ele deixa de
  funcionar como plataforma ou parede invisível após desaparecer.
- Ao chegar a 150 px do destino, a cesta é desenhada apoiada na carroça e Pipo
  deixa a pose com carga. A entrega continua aguardando a ação do jogador.
- O empurrão mantém uma tolerância visual curta entre contatos com a rocha.
  Assim, o ciclo não pisca para corrida ou repouso quando a rocha avança, e
  correções de colisão não pulam duas poses de uma vez.
