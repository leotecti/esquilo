# Evolução E07 — Resultado e desbloqueio de fases

Versão **0.15.0**. Ciclo **mapa → fase → resultado → mapa** implementado.

## Entrega

- Resultado reaproveita o painel existente e apresenta nozes, vidas,
  Nozes Douradas registradas e descoberta do segredo, sem notas negativas.
- **Voltar ao mapa** substitui a passagem direta à próxima fase.
- O mapa seleciona a próxima trilha e muda de mundo quando necessário.
- Um novo desbloqueio recebe destaque animado e aviso; consultar o mapa
  novamente não repete a celebração. A entrada na fase exige confirmação.
- A última fase celebra as trilhas disponíveis e retorna ao último mundo;
  jogar novamente preserva a conclusão da campanha.
- Conclusão e desbloqueio continuam salvos imediatamente. Fechar a aplicação
  no resultado preserva o progresso e reabre o mapa com o próximo destino.
- Save V2, Pipo, checkpoints, vidas e arte do mapa foram mantidos.
- Falha de armazenamento é informada no resultado; voltar ao mapa tenta
  salvar novamente. O jogo não promete persistência enquanto o armazenamento
  estiver indisponível.

Nozes Douradas usam os registros da E05; a criação das recompensas permanece
nas etapas de conteúdo. Não há migração de save nesta entrega.

## Verificação

**476 verificações Godot e 20 cenários de navegador passaram.** O percurso do
Rio foi repetido após adicionar a conferência do nó liberado e as capturas de
tela do resultado e do mapa, também aprovado.

- `tests/results_e07_test.gd`: conclusão, resultado, salvamento, mapa,
  passagem entre mundos, reabertura e última fase.
- Regressões de mapa, saúde, vidas, checkpoints, tutorial, progresso e save.
- Navegador: resultado final por toque, replay e reabertura offline;
  percurso real do Rio inclui resultado e entrada pelo mapa.

Distribuição das verificações Godot: 50 de resultado E07, 48 de mapa, 20 de
saúde, 47 de vidas, 133 de checkpoints, 26 de tutorial, 79 de progresso e 73
de persistência. Falha de gravação e nova tentativa foram testadas na E07.

Desempenho em Intel Iris Xe, Windows Compatibility, 1280×720, 181 amostras
por cenário (`tests/results_e07_performance.gd`):

| Cenário | Mediana | p95 |
| --- | ---: | ---: |
| Resultado | 16,62 ms | 17,48 ms |
| Mapa após conclusão | 16,64 ms | 18,28 ms |
| Próxima fase | 16,69 ms | 18,49 ms |

Relatório: `builds/performance-e07-windows.json`. A medição no computador
não substitui a conferência de desempenho no celular.

## Pacotes

- Web/PWA: `builds/web/Tico-evolucao-E07-web.zip`.
- Windows: `builds/windows/Tico-evolucao-E07-windows.zip`.
- Pastas: `builds/web/evolucao_e07/` e `builds/windows/evolucao_e07/`.

## Validação no celular

1. Publique o conteúdo do ZIP Web em `/tico/`, sem apagar os dados do site.
2. Conclua uma fase e confira o resultado e o botão **Voltar ao mapa**.
3. Confira o destaque da próxima fase e entre nela pelo mapa.
4. Conclua um guardião e confira a passagem ao mapa do mundo seguinte.
5. Rejogue uma fase concluída: conquistas e Pipo devem continuar disponíveis.
6. Feche o jogo no resultado e reabra offline; a conclusão deve permanecer.
7. Confira os controles e a legibilidade em paisagem no celular.

Sem commit, push ou publicação automática. Após a conferência do usuário,
seguir com a validação intermediária do loop principal antes da E08.
