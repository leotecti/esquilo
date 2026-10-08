# Fase 2-1 — foco em Pipo — 0.37.4

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
