# Etapa 3 — Web, touch e PWA

Data: 2026-09-29. Destino: `https://projetosdoleo.com/tico/`.

## Implementação

- Godot 4.7.2, Compatibility, exportação Web sem threads.
- Shell em português, início por Jogar, tela cheia e indicação de cache pronto.
- Direções e PULO multitoque; manter PULO permite planar. AÇÃO usa o input
  reservado e ainda não realiza uma interação no cenário.
- Controles maiores no celular, áreas seguras e aviso para girar em retrato.
- Manifesto com nome, ícones, landscape e standalone; caminhos relativos.
- Service worker com todos os recursos necessários, cache por conteúdo,
  atualização por botão e limpeza limitada aos caches do Tico nessa subpasta.

## Verificações automatizadas

Execute `npm.cmd run build:web`, seguido de `npm.cmd run test:web`.
O teste usa o Google Chrome instalado e Playwright, inicia um servidor local
quando necessário e executa o WASM real exportado em `/tico/`.
O parâmetro `?test=1` habilita somente uma leitura do estado do jogo para os
testes; não permite modificar posição, física ou comandos.

Três cenários de navegador cobrem:

1. Inicialização sem erros, teclado, salto, planar, pausa e tela cheia.
2. Manifesto, recursos em cache e reabertura em nova página com rede desligada,
   incluindo o carregamento do jogo e movimento de Tico.
3. Celular emulado em 844 × 390: direção e pulo simultâneos, planar, cancelamento
   de toque, ação reservada, rotação e pausa. Os alvos de jogo têm cerca de
   69 pixels CSS nessa resolução.

Resultado: três cenários aprovados. O diagnóstico de instalação do Chrome
apontou apenas o modo anônimo do contexto de teste, sem outros impedimentos;
a instalação real foi posteriormente confirmada pelo usuário. A pausa com direção mantida também foi
verificada, incluindo a ausência de movimento preso ao continuar.

As 45 verificações de Tico e as 16 de fundação também passaram após a inclusão
dos controles. Capturas: `builds/web/preview-desktop.png` e `preview-touch.png`.

## Retorno do usuário

O usuário confirmou upload na HostGator, acesso e instalação da PWA e avaliou
a jogabilidade como “muito boa”. Não foi fornecida medição de FPS.

## Conclusão — Marco 2 aprovado

O usuário confirmou a realização do teste offline solicitado: fechar a PWA,
desligar Wi-Fi e dados móveis, reabrir pelo ícone e jogar. Com essa confirmação,
a etapa 3 e o marco 2 — Tico PWA estão concluídos.

A emulação confirma o funcionamento do input e do layout testado. A taxa de
quadros do navegador automatizado não valida desempenho de um celular.
Roteiro de publicação e teste: [deployment.md](../web/deployment.md).
