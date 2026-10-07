# Publicar Tico Web/PWA

Destino informado: **https://projetosdoleo.com/tico/**.
Hospedagem informada: **HostGator**. As instruÃ§Ãµes abaixo usam o cPanel.
O usuÃ¡rio aprovou publicaÃ§Ã£o, instalaÃ§Ã£o, jogabilidade e offline da **etapa 3**.
O usuÃ¡rio tambÃ©m confirmou publicaÃ§Ã£o e bom funcionamento da **etapa 4**.
Na **etapa 5 â€” Trilha da Amizade**, o usuÃ¡rio confirmou acesso e aprovou
controles, faro e percurso completo.

## Pacote

VersÃ£o atual: **ValidaÃ§Ã£o intermediÃ¡ria 2 â€” aventura completa em miniatura
(0.34.1)**. Inclui as correÃ§Ãµes localizadas das fases 1-2 e 1-3, o localizador temporÃ¡rio, a expansÃ£o de 1-3 e a Gruta Fria, preservando a identidade visual e o Save V2.

Ao tocar em `Jogar`, o navegador solicita tela cheia e tenta fixar a orientaÃ§Ã£o
horizontal. A PWA instalada abre diretamente no modo `fullscreen`; nÃ£o hÃ¡ botÃ£o
flutuante sobre o jogo para alternar esse estado.
[RelatÃ³rio e roteiro da validaÃ§Ã£o](../tests/validacao_intermediaria_2.md).

`builds/web/Tico-0.34.1-gruta-fria-web.zip` contÃ©m os arquivos que devem ficar diretamente
na pasta pÃºblica correspondente a `/tico/`, incluindo `index.html`, `index.js`,
`index.wasm`, `index.pck`, manifesto, service worker e Ã­cones.
NÃ£o coloque outra pasta `validacao_intermediaria_2` entre `/tico/` e os arquivos.
O botÃ£o **Atualizar** ativa o novo service worker e recarrega a PWA quando uma
versÃ£o estiver aguardando. O registro tambÃ©m consulta atualizaÃ§Ãµes ao abrir a
pÃ¡gina, sem depender do cache HTTP do navegador.
O usuÃ¡rio confirmou o teste e a aprovaÃ§Ã£o da etapa 8 em 2026-09-30.
As instruÃ§Ãµes abaixo ficam disponÃ­veis para publicaÃ§Ã£o e futuras atualizaÃ§Ãµes.

A etapa 9 importa o progresso do Bosque e mantÃ©m o save antigo intacto.
Quem concluiu a etapa 8 pode usar **Seguir para o Rio** na tela de resultado.
Sem progresso anterior, a campanha comeÃ§a em **1-1 â€” Primeiros Passos**.
Teste Rio, Montanha e Vila, seus chefes e a retomada dos mecanismos ativados.
NÃ£o limpe os dados do navegador ao atualizar. Roteiro: [etapa 9](../tests/etapa_9.md).

1. Guarde uma cÃ³pia do conteÃºdo existente em `/tico/` antes da substituiÃ§Ã£o.
2. No cPanel da HostGator, abra **Gerenciador de arquivos** e localize a raiz
   de `projetosdoleo.com`. Se for o domÃ­nio principal, normalmente Ã© `public_html`;
   se for adicional, confira a raiz configurada para ele em **DomÃ­nios**.
3. Dentro dessa raiz, crie ou abra `tico`. Use **Carregar/Upload** para enviar
   o ZIP e depois **Extrair** nessa mesma pasta. O resultado deve ser
   `public_html/tico/index.html` quando a raiz for `public_html`.
   Inclua o `.htaccess` do pacote; habilite a exibiÃ§Ã£o de arquivos ocultos
   nas configuraÃ§Ãµes do gerenciador para conferir sua presenÃ§a.
4. Abra `https://projetosdoleo.com/tico/` e pressione **Jogar**.
5. Verifique no celular os passos da prÃ³xima seÃ§Ã£o.

Ajuda oficial da HostGator: [enviar arquivos pelo cPanel](https://suporte.hostgator.com.br/hc/pt-br/articles/30813145737235-Como-enviar-um-arquivo-para-o-cPanel)
e [extrair arquivos no gerenciador](https://suporte.hostgator.com.br/hc/pt-br/articles/30808065412371-Quais-as-funcionalidades-do-Gerenciador-de-arquivos-do-cPanel).

SÃ£o arquivos estÃ¡ticos: o servidor de produÃ§Ã£o nÃ£o precisa executar Node.js.
O endereÃ§o `/tico` deve redirecionar para `/tico/`, com a barra final.
Sirva `.wasm` como `application/wasm`, `.js` como JavaScript e `.json` como JSON.
NÃ£o use fallback de pÃ¡ginas do site para arquivos ausentes do jogo.

O `.htaccess` incluÃ­do aplica MIME e revalidaÃ§Ã£o em Apache quando permitidos.
Em Nginx ou outro servidor, configure esses itens no painel ou na configuraÃ§Ã£o
do site. Use `Cache-Control: no-cache` para HTML, JS, JSON, PCK e WASM;
habilite gzip/Brotli para reduzir a transferÃªncia, especialmente do WASM.
O cache offline Ã© administrado pelo service worker dentro de `/tico/`.

## Roteiro no celular â€” repetir apÃ³s atualizar

1. Abra o endereÃ§o HTTPS com internet, em landscape. Aguarde a indicaÃ§Ã£o
   **Pronto para jogar offline neste dispositivo** e pressione **Jogar**.
2. Mantenha uma direÃ§Ã£o e PULO simultaneamente. Solte e pressione novamente;
   confirme salto, planar, movimento e ausÃªncia de botÃµes presos.
3. Experimente Pausar, Continuar, RecomeÃ§ar, trocar de aplicativo e girar a tela.
4. Avalie tamanho dos botÃµes, visibilidade, conforto e fluidez. Registre modelo
   do aparelho, sistema e navegador. O alvo do projeto continua sendo 60 FPS.
5. Instale pelo botÃ£o **Instalar**, quando oferecido, ou pelo menu do navegador.
   No Safari do iPhone, use Compartilhar â†’ Adicionar Ã  Tela de InÃ­cio.
6. Feche o jogo e abra pelo Ã­cone. Confirme nome, Ã­cone e Ã¡rea de jogo.
7. Feche novamente, desligue Wi-Fi e dados mÃ³veis e reabra pelo Ã­cone.
   Pressione Jogar e confirme movimento, salto e planar sem conexÃ£o.

Na etapa 6, teste Trocar, o movimento mais pesado de Pipo, empurrar a pedra,
passar pelo tÃºnel com Tico, investir na parede com Pipo e seguir as partÃ­culas
do faro. Perca a vida apÃ³s ativar a bandeira e confira personagem, coraÃ§Ãµes e
progresso do puzzle no retorno. Suba as plataformas, chegue Ã  Ã¡rvore e use Jogar de novo.
O botÃ£o INVESTIR Ã© o mesmo AÃ‡ÃƒO; o faro Ã© automÃ¡tico.

A etapa 7 apresenta o **Bosque das Folhas** com arte ilustrada e Ã¡udio.
Teste a mÃºsica, os efeitos, as opÃ§Ãµes no menu Pausar e a persistÃªncia dessas
preferÃªncias. Confirme que o Ã¡udio pausa ao mudar de aplicativo e que volta
corretamente. Confira o visual, a fluidez e o aquecimento durante uma sessÃ£o
de pelo menos dez minutos. [Roteiro da etapa 7](../tests/etapa_7.md).
Saves da etapa 6 sÃ£o compatÃ­veis: nÃ£o limpe os dados do site ao atualizar.

Para validar o save: colete nozes, abra os obstÃ¡culos e ative a bandeira.
Confira **Progresso salvo**, feche o PWA, desligue a internet e reabra pelo Ã­cone.
O personagem deve voltar Ã  bandeira com trÃªs coraÃ§Ãµes, mantendo nozes, segredo
e passagens abertas. Conclua e reabra: o resultado deve permanecer.
RecomeÃ§ar exige confirmaÃ§Ã£o; cancelar mantÃ©m o progresso. Repita depois de atualizar
os arquivos, sem limpar os dados do site. O save pertence ao navegador/dispositivo.
Roteiro completo: [playtest da etapa 6](../tests/playtest_etapa_6.md).

## AtualizaÃ§Ãµes

Gere cada versÃ£o com `npm.cmd run build:web`; o script calcula a versÃ£o do cache
pelos arquivos exportados. Publique o pacote completo. Quando aparecer
**Atualizar**, o jogador pode carregar a nova versÃ£o; a aventura retoma do ponto
seguro com o progresso salvo a partir da etapa 6. A etapa 5 nÃ£o possuÃ­a save.
O worker remove somente caches antigos do Tico na mesma subpasta.

## Desenvolvimento local

```powershell
npm.cmd ci
npm.cmd run build:web
npm.cmd run serve:web
```

Abra `http://127.0.0.1:8080/tico/` no computador. Para testar instalaÃ§Ã£o e
offline no celular, use o endereÃ§o HTTPS publicado. O servidor local serve
somente para desenvolvimento e escuta em `127.0.0.1` por padrÃ£o.

ReferÃªncia tÃ©cnica: [exportaÃ§Ã£o Web da Godot](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html).

## AtualizaÃ§Ãµes incrementais â€” 0.29.4

O build registra tamanho e assinatura de cada arquivo no service worker. Ao preparar
uma nova versÃ£o, a PWA copia do cache anterior os arquivos que permanecem iguais
e baixa apenas os alterados. Uma barra mostra o progresso em bytes, informa quantos
arquivos foram reaproveitados e libera **Atualizar** quando a versÃ£o estÃ¡ completa.
A primeira migraÃ§Ã£o a partir da 0.29.3 ainda precisa formar o cache com assinaturas;
as atualizaÃ§Ãµes posteriores passam a aproveitar o mecanismo incremental.


### Refino visual 0.34.1

A Gruta Fria agora usa cenário próprio, sombras ambientais de morcegos e pingos com animação refinada. O novo pacote altera recursos do jogo e deve substituir integralmente a versão anterior na hospedagem.
