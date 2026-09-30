# Etapa 6 — Protótipo completo

Data: 29/09/2026. Implementação pronta para playtest; aceite humano pendente.

## Fase

`scenes/levels/prototype_trail.tscn` é a cena principal. Reutiliza os controladores
aprovados de Tico e Pipo, preservando as cenas das etapas anteriores.

| Trecho | Conteúdo |
| --- | --- |
| Início, x=160–780 | Movimento, nozes, primeira lesma, blocos comum/quebrável/de noz |
| x=850–1750 | Pipo empurra a pedra até a marca, abre portão; Tico atravessa o túnel |
| x=2240 | Investida de Pipo quebra a parede pesada |
| x=2880–3020 | Segredo pelo faro, recuperação e bandeira |
| x=3160–3710 | Lesma, três plataformas em degraus e chegada elevada |

São 13 nozes opcionais: oito na trilha, uma escondida, uma no bloco e três
nas plataformas. A fase termina sem exigir todas. Arte e áudio continuam provisórios.
Pistas curtas substituem as placas mais explicativas da etapa 5.

## Regras do save

- Slot único automático, `save_version: 1`, fase `prototype_1`.
- Guarda personagem, itens coletados, blocos usados, posição da pedra, portão,
  parede, segredo, bandeira e conclusão. O contador é reconstruído pelos objetos.
- Coletas, blocos, troca, parede, bandeira e chegada gravam imediatamente.
  Movimento da pedra é registrado a cada 0,5 s; pausa/perda de foco também grava.
  Estados idênticos não provocam outra escrita.
- Reabrir retorna ao início ou à bandeira com três corações. A posição exata no
  salto não é salva. Inimigos reaparecem. Conclusão reabre a comemoração/resultado.
- Web/PWA: JSON em `localStorage`, chave `tico.progress.v1`, escrita síncrona com
  tratamento de indisponibilidade/cota. Não depende de aguardar sincronização ao fechar.
- Windows: `user://progress.json`; grava arquivo temporário, faz flush e renomeia.
- Atualizações do service worker limpam somente caches de arquivos; não removem
  o save. A chave e o identificador da fase devem permanecer estáveis em atualizações.
- Formato inválido ou futuro é preservado e bloqueia sobrescrita automática.
  O indicador informa o problema. Nova aventura confirmada permite substituí-lo.
- Limpar os dados do site remove o save. Não há conta, nuvem ou sincronização.
  Configurações ainda não existem na interface; não há campos fictícios de ajustes.
  Ao acrescentar mundos/configurações, será necessária evolução do esquema e migração.

## Verificação reproduzível

```powershell
$engine = 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_win64_console.exe'
& $engine --headless --path . --script tests/prototype_test.gd --fixed-fps 60
npm.cmd run build:web
npm.cmd run test:web
```

O teste de engine usa `user://stage6_test_only.json`, removido ao terminar;
não altera o save de uma partida normal. Verifica percurso inteiro por comandos,
reabertura da cena, objetos persistentes, reinício/cancelamento, recompensa única,
conclusão e entradas inválidas. Os testes anteriores continuam executáveis.

No Chrome, a suíte verifica teclado, touch emulado, instalação/cache, percurso
completo, encerramento e novo processo de navegador com o mesmo perfil,
retomada offline, atualização do worker, save danificado/futuro e falha de escrita.
Os perfis de navegador são isolados. `?test=1` expõe apenas um retrato de leitura;
o percurso usa comandos de entrada, sem teletransporte.

## Resultado técnico — 29/09/2026

- **185 verificações de engine aprovadas:** 16 de fundação, 45 de Tico,
  38 do minigame, 54 da cooperação e 32 do protótipo/save.
- **Dez cenários de Chrome aprovados**, incluindo touch emulado, percurso,
  fechamento do processo/reabertura offline, atualização e falhas de armazenamento.
- Importação e exportação sem erros de script; build Windows executado em modo
  headless até encerrar com código 0, sem erros em stdout/stderr.
- Capturas desktop/touch inspecionadas; pistas legíveis e última noz posicionada
  antes da área de chegada. ZIP Web conferido, inclusive `.htaccess` e cache offline.
- Pacotes: `builds/web/Tico-etapa-6-web.zip` (~10 MB) e
  `builds/windows/Tico-etapa-6-windows.zip` (~33 MB).
- Nenhum commit ou push realizado.

## Aceite pendente

Publicar `builds/web/Tico-etapa-6-web.zip` em `/tico/` e executar
[o roteiro no aparelho e com jogadores](playtest_etapa_6.md).
Automação não confirma diversão, compreensão infantil nem desempenho de aparelhos reais.
