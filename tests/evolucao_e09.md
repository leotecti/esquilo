# Evolução E09 — recompensas e coletáveis (0.18.0)

A E09 aumenta a frequência de decisões e recompensas em **1-1 — Primeiros
Passos**, mantendo o tamanho, a duração, a geometria e a bandeira aprovados.

## Conteúdo

- **271 nozes** no total: 245 no caminho principal e 26 na copa.
- **39 alimentos**: maçãs, frutas silvestres e cenouras.
- **14 blocos de recompensa** distribuídos pelos onze trechos ampliados.
- **2 Nozes Douradas opcionais**: uma na trilha e outra na copa.
- Maior intervalo medido entre recompensas: **540 unidades**.

Cada trecho possui um bloco com noz; três trechos possuem um segundo bloco.
Arcos de três nozes recompensam saltos, enquanto alimentos ocupam posições
intermediárias. A alternância evita uma linha contínua de itens.

## Regras

- Nozes e blocos alimentam o contador configurável de 100 nozes por vida.
- Alimentos usam um contador próprio e representam provisões do vilarejo.
- Alimentos não concedem progresso no contador de nozes.
- Cada alimento persistente conta uma vez, mesmo após morrer ou reabrir o jogo.
- Em **Jogar novamente**, alimentos e os novos blocos reaparecem para manter o
  ritmo, mas seus IDs impedem novo crédito permanente, vidas ou provisões.
- Nozes Douradas são opcionais e ficam no registro permanente da fase.
- Corações mantêm a regra da 0.17.1: curam ou concedem uma vida com saúde cheia.

Saves V2 anteriores recebem `food_total = 0` ao abrir. Nozes, vidas,
personagens, conclusões e itens anteriores são preservados.

## Desempenho

Os desenhos animados dos coletáveis só são atualizados perto da câmera. Na
medição local Windows Compatibility 1280×720, Intel Iris Xe, os cinco cenários
ficaram entre **16,61 e 16,73 ms de mediana**, com percentil 95 entre
**17,68 e 18,92 ms**.

## Validação automática

- **409 verificações Godot sem falhas** nos testes funcionais e de regressão.
- **4 cenários Web sem falhas**: o cenário próprio da E09 e três regressões da E08.
- `rewards_e09_test.gd`: quantidades, espaçamento, três tipos de alimento,
  blocos, Nozes Douradas, persistência e validação do save.
- `first_steps_route_test.gd`: chegada por movimento e salto com os novos blocos.
- Regressões do modelo, retorno, copa, vidas, save e progresso permanente.
- Navegador: coleta de alimento e reabertura offline.

## Roteiro no celular

1. Atualize `/tico/` sem apagar os dados do site.
2. Rejogue Primeiros Passos e observe o ritmo entre nozes, alimentos e blocos.
3. Bata nos blocos por baixo e confira o contador de vida.
4. Colete os três alimentos e confira o contador **Comida**.
5. Feche o PWA, abra offline e confirme que os alimentos continuam registrados.
6. Procure as duas Nozes Douradas sem exigir sua coleta para concluir a fase.

Pacotes: `builds/web/Tico-evolucao-E09-web.zip` e
`builds/windows/Tico-evolucao-E09-windows.zip`. Sem commit ou publicação automática.
