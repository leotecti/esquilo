# Correções localizadas — fase 1-2

Referências recebidas:

- `Fase 1-2 | Trilha principal | T01 | X 999 | Y 760`: o besouro recebeu um
  ajuste visual de 6 px para apoiar as patas no terreno, sem alterar a colisão.
- `Fase 1-2 | Trilha principal | T02 | X 5340 | Y 640`: os blocos suspensos
  agora ficam 80 px acima da plataforma de referência e são alcançáveis por um
  salto normal.
- `Fase 1-2 | Trilha principal | T02 | X 5647 | Y 640`: o primeiro inimigo da
  expansão foi movido para a plataforma em y=640.

A revisão foi aplicada aos oito encontros ampliados e a todos os conjuntos de
blocos da fase para impedir a repetição dos mesmos problemas.

- `T03 | X 9044 | Y 600`: o inimigo agora patrulha a plataforma acessível.
- `T03 | X 8841 | Y 600`: os blocos seguem a altura do degrau percorrido.
- `T04 | X 12224 | Y 680`: os blocos ficam ao alcance do salto normal.
- `T04 | X 12224 | Y 680`: o porco-espinho foi levado à plataforma acessível.
- `T05 | X 15094 | Y 680`: o bloco secreto foi baixado para a faixa alcançável.
- `T06 | X 16592 | Y 600`: o porco-espinho foi levado à próxima plataforma
  acessível da rota.
- `T07 | X 19506 | Y 520`: a fruta acompanha a escadaria visível da passagem.
- `Galeria das Pedras | T02 | X 47147 | Y 680`: a fruta fica sobre a plataforma.
- `Galeria das Pedras | T03 | X 47945 | Y 650`: a fruta fica sobre a plataforma.

As cinco frutas da Galeria das Pedras foram revisadas com a altura de suas
respectivas superfícies.

- `Galeria das Pedras | T03 | X 48121 | Y 710`: lesma levada à plataforma.
- `Galeria das Pedras | T04 | X 48739 | Y 680`: fruta confirmada na superfície.
- `Galeria das Pedras | T04 | X 49584 | Y 610`: lesma levada à plataforma.
- `Galeria das Pedras | T05 | X 49719 | Y 680`: fruta confirmada na superfície.

As três lesmas da galeria foram alinhadas às plataformas acessíveis.

- `Galeria das Pedras | T05 | X 50379 | Y 640`: fruta e lesma permanecem na
  plataforma acessível após a correção anterior.
- `Trilha principal | T08 | X 24568 | Y 760`: alinhamento das patas do besouro
  refinado para eliminar a impressão de flutuação.
- `Trilha principal | T08 | X 25600 | Y 680`: blocos baixados mais 20 px.
- `Trilha principal | T09 | X 26264 | Y 600`: porco-espinho confirmado na
  plataforma elevada acessível.
- `Trilha principal | T09 | X 28501 | Y 680`: besouro alinhado ao terreno.
- `Trilha principal | T10 | X 31823 | Y 720`: recompensa dourada baixada para
  uma posição alcançável.
- `Trilha principal | T11 | X 32756 | Y 600`: besouro confirmado na superfície.
- `Trilha principal | T11 | X 34217 | Y 700`: porco-espinho confirmado na
  plataforma acessível.
- `Trilha principal | T12 | X 35640 | Y 600`: blocos baixados mais 20 px e
  besouro confirmado sobre a superfície.
- `Trilha principal | T12 | X 37496 | Y 690`: fruta alinhada à plataforma de
  chegada.
- `Trilha principal | T07 | X 19696 | Y 520`: confirmação adicional de que a
  fruta usa `y=472`; a antiga posição soterrada em `y=552` não é mais criada.
- `Trilha principal | T12 | X 37513 | Y 690`: confirmação adicional de que a
  fruta usa `y=642`; a antiga posição soterrada em `y=712` não é mais criada.

Uma segunda revisão identificou nozes procedurais duplicadas sob as plataformas
especiais próximas ao portal da Galeria e ao portal final. Essas duplicatas
foram removidas; as recompensas manuais acessíveis continuam nos dois locais.

- `Galeria das Pedras | T06 | X 51016 | Y 760`: dois degraus atravessáveis
  permitem subir do piso para `y=700`, `y=630` e retornar ao portal em `y=570`.
