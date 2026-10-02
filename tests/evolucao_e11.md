# Evolução E11 — Abertura do jogo (0.20.0)

A E11 usa o diretor narrativo da E10 para apresentar a motivação da aventura
antes do mapa, sem alterar o gameplay das fases existentes.

## Sequência

1. O vilarejo guarda alimentos para o inverno.
2. Tico procura mais comida e percebe que quase não encontra nada.
3. Seu depósito também está quase vazio.
4. As marcas levam Tico além das trilhas conhecidas.
5. Ele encontra a coruja Valda presa sob galhos e decide ajudar.
6. Depois do resgate, Tico se apresenta e explica que procura comida para o vilarejo.
7. Valda se apresenta como observadora da floresta e revela que outros animais também estão sendo afetados.
8. Valda reconhece a coragem de Tico e o convida a ajudar todo o bosque.
9. Tico aceita a missão e recebe a orientação de seguir as nozes e observar as penas.
10. O título aparece e a jornada segue para o mapa.

As falas são curtas. Três ilustrações apresentam o vilarejo, Valda presa e
Valda livre. O fundo alterna planos abertos, aproximações em Tico e Valda e a
revelação da trilha. Transições e ações dos personagens separam os momentos.
Tico usa o retrato já existente no jogo para manter sua identidade visual.

## Fluxo e save

- A abertura aparece em uma aventura nova antes do mapa.
- `Pular cena` conclui a abertura e abre o mapa.
- Ao assistir, `owl_rescued`, `first_clue_received` e `opening_complete` são salvos.
- Ao pular cedo, somente `opening_complete` é registrado.
- Reabrir não repete a cena.
- `Nova aventura` volta a apresentá-la.
- Campanhas criadas antes da E11 recebem `opening_complete` durante a migração e
  continuam diretamente no mapa.

## Validação

- `opening_e11_test.gd`: 17 verificações, zero falhas.

## Ajustes após teste da abertura

- O painel narrativo foi reduzido para preservar a leitura da ilustração, inclusive em celulares.
- Tico agora atravessa as cenas com ciclos de corrida e trajetórias curvas de salto e resgate.
- O cenário mantém movimento lento de câmera e usa entrada suave em cada mudança.
- O texto surge progressivamente; um primeiro toque conclui a frase e o seguinte avança.
- Tico e Valda agora se apresentam após o resgate, antes do convite para a missão.
- Valda explica por que escolheu Tico e relaciona a falta de comida a todo o bosque.
- Enquadramentos com focos e aproximações diferentes acompanham cada trecho da conversa.
- A entrada suave da paisagem e o movimento de câmera usam animações independentes;
  assim, os enquadramentos de Valda não interrompem a exibição do cenário.
- O teste Web registra e verifica Valda presa e resgatada com a paisagem totalmente visível.
- Regressão do Save V2: 79 verificações, zero falhas.
- Web desktop: abertura completa, eventos, mapa e reabertura offline.
- Web mobile 844×390: botões, avanço por toque, pulo e mapa.
- Exportações Web/PWA e Windows concluídas.

As ilustrações foram reduzidas para 1280×720 antes da importação. Na medição
local Windows Compatibility, Intel Iris Xe, as três cenas ficaram entre 16,64 e
16,68 ms de mediana e entre 17,30 e 18,32 ms no percentil 95, com 331 chamadas
de desenho no p95. Relatório: `builds/performance-e11-windows.json`.

## Roteiro no celular

1. Inicie uma **Nova aventura**.
2. Confira a leitura das falas e a aparência das três cenas em landscape.
3. Avance até o título e confirme a chegada ao mapa.
4. Feche e reabra; a abertura não deve repetir.
5. Inicie outra Nova aventura e use `Pular cena`; o mapa deve abrir.
6. Instale ou atualize a PWA, abra offline e confirme que o mapa e o save continuam.

Pacotes: `builds/web/Tico-evolucao-E11-web.zip` e
`builds/windows/Tico-evolucao-E11-windows.zip`. Sem commit ou publicação automática.
