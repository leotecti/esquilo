# Evolução E03 — Checkpoints e reinício

Implementação: 2026-09-30, versão 0.11.0. Playtest do usuário pendente.

## Entrega

As bandeiras, animações, controles, saúde e save existentes foram reaproveitados.
A campanha continua com uma bandeira por fase, incluindo as arenas. A posição de
retorno vem da cena; o save registra se a bandeira está ativa, sem armazenar
coordenadas arbitrárias.

O menu de pausa agora oferece **Reiniciar fase**, com confirmação e cancelamento.
Essa opção reinicia a tentativa atual. **Nova aventura** continua sendo a opção
que substitui o progresso da campanha, também com confirmação.

## Regras de retorno

| Estado | Morte com vidas restantes | Reiniciar fase pelo menu | Fechar e reabrir |
| --- | --- | --- | --- |
| Posição | Bandeira ativa; início quando não há bandeira | Início da fase atual; bandeira desativada | Ponto de retorno salvo |
| Personagem | Mantém Tico ou Pipo ativo | Mantém o personagem ativo | Restaura o personagem salvo |
| Saúde | Completa, com proteção temporária | Completa, com proteção temporária | Completa, com proteção temporária |
| Vidas | Desconta uma | Mantém a quantidade | Mantém a quantidade salva |
| Inimigos comuns | Reaparecem | Reaparecem | Reaparecem |
| Chefe ainda não vencido | Reinicia o encontro com saúde completa | Reinicia o encontro | Reinicia o encontro |
| Chefe já vencido | Continua calmo | Continua calmo | Continua calmo |
| Nozes, corações consumidos e blocos usados | Mantém | Mantém | Mantém |
| Medalhões de vida extra | Não concede novamente | Não concede novamente | Não concede novamente |
| Segredos e caminhos abertos | Mantém | Mantém | Mantém |
| Mecanismos, pedra e paredes | Mantém o progresso | Mantém o progresso salvo | Restaura o progresso salvo |
| Fases concluídas/desbloqueadas e Pipo liberado | Mantém | Mantém | Mantém |

Itens ainda não coletados continuam disponíveis. Plataformas móveis continuam
seu ciclo durante a tentativa; ao recarregar a cena, retomam a partir de sua
posição inicial, com os mecanismos liberados preservados.

Uma tentativa de replay não apaga a conclusão permanente. Reabrir durante esse
replay mantém a fase jogável. A opção **Nova aventura** continua sendo necessária
para começar uma campanha com todas as recompensas e desafios reiniciados.

Ao perder a última vida, prevalece a regra da E02: Game Over, vidas renovadas e
seleção da primeira fase do mundo anterior, preservando os desbloqueios. O mapa
visual continua previsto para a E06.

## Ajustes na retomada

- Derrota libera os comandos de movimento, salto, ação e troca, incluindo toques
  mantidos. O jogador volta sem movimento ou investida presos.
- Retorno e leitura do save usam a mesma restauração de saúde e proteção do personagem.
- O tempo de espera da troca de personagem é limpo ao retornar.
- A margem segura das fases de Rio/Montanha/Vila acompanha a bandeira após derrota,
  evitando que uma queda posterior use uma margem da tentativa anterior.
- O tempo de animação dos chefes ainda não vencidos também é reiniciado.
- Um comando de continuar durante a rotação não retoma o jogo atrás do aviso de
  tela vertical no celular.

## Persistência e compatibilidade

O esquema e o slot da campanha continuam os mesmos: `campaign.json` no Windows
e `tico.campaign.v1` no navegador. A E03 reaproveita `checkpoint` e o estado de
replay da E02. Saves anteriores continuam sendo aceitos; saves inválidos ou de
versão futura permanecem protegidos contra substituição automática.

Ativar a bandeira, morrer e confirmar o reinício atualizam o save. Cancelar o
reinício mantém a tentativa. O reinício manual fica bloqueado durante a animação
de derrota e o Game Over, evitando dois retornos simultâneos.

## Testes

| Script | Verificações aprovadas |
| --- | ---: |
| `checkpoints_e03_test.gd` | 133 |
| `lives_e02_test.gd` | 47 |
| `expedition_save_test.gd` | 73 |
| `health_e01_test.gd` | 20 |
| **Total Godot** | **273** |

Os testes E03 cobrem colisão com as bandeiras das 16 fases, saúde, proteção,
personagem ativo, inimigos, chefes, pausa durante a derrota, cancelamento e
confirmação do reinício, medalhão, segredo da caverna, coração consumido, replay
e reabertura. Usam arquivos de save exclusivos para testes.

O navegador cobre retorno real de Pipo à bandeira, reabertura offline, reinício
por toque e preservação da comporta. As regressões verificam Game Over, acesso
aos mundos liberados, corrida, Rio, Montanha, Vila, áudio, rotação e save futuro.
**Dez cenários validados.** Após corrigir a proteção de pausa na rotação e aguardar
o pouso antes da troca no teste de Game Over, os quatro cenários relacionados
foram repetidos e passaram.
Logs locais: `builds/e03-browser.log` e `builds/e03-browser-final.log`.

O desempenho é medido por `checkpoints_e03_performance.gd`, com gameplay,
gameplay após reinício e confirmação pausada. O relatório local fica em
`builds/performance-e03-windows.json`. A medição Windows não substitui o teste
de desempenho no celular.

Medição local, Intel Iris Xe, Windows Compatibility, 1280×720, 181 amostras por cenário:

| Cenário | Mediana | p95 | Chamadas de desenho p95 |
| --- | ---: | ---: | ---: |
| Gameplay | 16,73 ms | 18,09 ms | 66 |
| Após reinício | 16,63 ms | 17,93 ms | 66 |
| Confirmação pausada | 16,62 ms | 17,49 ms | 90 |

## Pacotes

- Web/PWA: `builds/web/Tico-evolucao-E03-web.zip`.
- Windows: `builds/windows/Tico-evolucao-E03-windows.zip`.
- Pastas de exportação: `builds/web/evolucao_e03/` e `builds/windows/evolucao_e03/`.
- [Publicação na HostGator](../web/deployment.md).
- [Configuração de outra máquina e geração dos builds](../DESENVOLVIMENTO.md).

## Roteiro para o usuário

1. Antes de chegar à bandeira, perca os corações: confira o desconto de uma vida
   e o retorno ao início com saúde completa.
2. Ative a bandeira com Tico ou Pipo. Perca os corações novamente e confira o
   retorno do mesmo personagem à bandeira, com proteção temporária.
3. Colete uma noz ou coração, abra uma passagem e repita a derrota. Confira que
   o progresso permanece e os inimigos comuns reaparecem.
4. Pause, toque em **Reiniciar fase** e cancele. A bandeira e a tentativa devem
   permanecer. Confirme em seguida: volte ao início, com a bandeira desativada,
   saúde completa e a mesma quantidade de vidas e recompensas.
5. Feche e reabra: o retorno deve continuar no início após esse reinício. Ative
   outra vez a bandeira e confira que ela volta a ser o ponto salvo.
6. Teste uma derrota no Rio e uma queda seguinte: a margem segura deve pertencer
   à nova tentativa. Confira também investida, empurrão e corrida dos personagens.
7. Esgote as vidas e confira o retorno ao mundo anterior conforme a E02.
8. No celular, atualize a PWA online, depois repita a retomada offline e a rotação.

Sem commit, push ou publicação automática.
