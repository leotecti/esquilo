# Evolução E18 — chefes

## Entrega

Os quatro chefes existentes agora concluem o aprendizado de seus mundos em três
momentos. Eles continuam protegidos durante o ataque e só recebem acerto na
abertura anunciada.

Cada mundo possui quatro fases. As três primeiras apresentam e combinam suas
mecânicas; a quarta é dedicada ao chefe.

| Chefe | Aprendizado retomado | Ação do jogador |
| --- | --- | --- |
| Periquito do Bosque | voo, perseguição, mergulho, raízes e salto | desviar do mergulho e pular na cabeça quando ele pousar cansado |
| Guardião do Rio | correnteza, troncos e Pipo | alcançar o apoio e atacar com salto ou investida |
| Gavião da Montanha | vento, altura e planeio | evitar o mergulho e saltar quando ele pousar |
| Rei Castor | mecanismos, elevador e engrenagens | ativar a arena com Pipo e subir com Tico |

## Três momentos

1. **Padrão simples:** área curta e aviso longo para observar.
2. **Variação:** o mesmo ataque alcança uma área maior e começa mais cedo.
3. **Combinação:** alcance máximo e ritmo mais intenso, usando a mecânica central
   da arena.

O aviso diminui de 1,25 para 1 segundo. A oportunidade de ataque permanece entre
3,6 e 4 segundos, para que a dificuldade venha da leitura e do posicionamento.
Cada acerto apresenta uma frase curta sobre a mudança do padrão. As marcas no
chão mostram a área real do próximo ataque.

## Regras preservadas

- três acertos acalmam o chefe;
- o Periquito aceita somente pulos na cabeça; a investida de Pipo não causa dano;
- o Periquito patrulha no ar, acompanha Tico ou Pipo e mira o personagem ativo antes do mergulho;
- ao pousar, permanece no ponto em que terminou o mergulho durante toda a abertura;
- peito inflado, bico aberto, asas baixas e respiração suave comunicam cansaço sem tristeza;
- a cabeça abaixada possui uma faixa vulnerável ampla e um marcador dourado alinhado à pose;
- depois do terceiro pulo, o Periquito cai de lado, desaparece e libera a saída;
- o personagem ativo corre automaticamente até o portal e conclui a fase;
- três pulos físicos na cabeça são necessários para derrotá-lo;
- ataques fora da abertura não causam dano ao chefe;
- a pausa congela o confronto;
- a derrota reinicia um chefe ainda não vencido;
- chefes já vencidos continuam calmos ao reabrir;
- o primeiro chefe é o Periquito do Bosque, e o chefe da Montanha é o Gavião;
- Valda permanece mentora;
- a conclusão e o próximo mundo continuam registrados no Save V2.

## Verificação

- `evolucao_e18_test.gd`: **41 verificações aprovadas** para arte, perseguição,
  alvo, três pulos físicos, progressão, proteção, alcance, ritmo e encerramento;
- `expedition_boss_test.gd`: **19 verificações aprovadas** em confrontos completos
  por comandos;
- `world_rules_test.gd`: **10 verificações aprovadas**;
- `mini_adventure_validation_test.gd`: **35 verificações aprovadas**.

## Roteiro de playtest

1. Observe se o primeiro aviso permite entender o ataque sem sofrer dano.
2. Após cada acerto, confira a frase de mudança e o aumento visível da área.
3. Verifique se as marcas no chão correspondem à região perigosa.
4. Confirme que o Periquito segue Tico e Pipo e anuncia claramente o mergulho.
5. Desvie, espere o pouso cansado e pule sobre a cabeça; repita três vezes.
6. Confirme que a investida de Pipo não reduz a vida do Periquito.
7. No terceiro momento, use a mecânica ensinada no mundo em vez de atacar sem
   observar.
8. Perca uma vida, retorne à bandeira e confira o reinício do confronto.
9. Termine o encontro, volte ao mapa e reabra para conferir o chefe calmo.
