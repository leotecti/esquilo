# Publicar Tico Web/PWA

Destino informado: **https://projetosdoleo.com/tico/**.
Hospedagem informada: **HostGator**. As instruções abaixo usam o cPanel.
O usuário aprovou publicação, instalação, jogabilidade e offline da **etapa 3**.
O usuário também confirmou publicação e bom funcionamento da **etapa 4**.
Na **etapa 5 — Trilha da Amizade**, o usuário confirmou acesso e aprovou
controles, faro e percurso completo.

## Pacote

Versão atual: **Evolução E12 — Valda e progressão da história (0.21.0)**. Inclui
a abertura, os encontros recorrentes de Valda após os confrontos decisivos e
preserva o Save V2.
[Alterações e roteiro da E12](../tests/evolucao_e12.md).

`builds/web/Tico-evolucao-E12-web.zip` contém os arquivos que devem ficar diretamente
na pasta pública correspondente a `/tico/`, incluindo `index.html`, `index.js`,
`index.wasm`, `index.pck`, manifesto, service worker e ícones.
Não coloque outra pasta `evolucao_e12` entre `/tico/` e os arquivos.
O usuário confirmou o teste e a aprovação da etapa 8 em 2026-09-30.
As instruções abaixo ficam disponíveis para publicação e futuras atualizações.

A etapa 9 importa o progresso do Bosque e mantém o save antigo intacto.
Quem concluiu a etapa 8 pode usar **Seguir para o Rio** na tela de resultado.
Sem progresso anterior, a campanha começa em **1-1 — Primeiros Passos**.
Teste Rio, Montanha e Vila, seus chefes e a retomada dos mecanismos ativados.
Não limpe os dados do navegador ao atualizar. Roteiro: [etapa 9](../tests/etapa_9.md).

1. Guarde uma cópia do conteúdo existente em `/tico/` antes da substituição.
2. No cPanel da HostGator, abra **Gerenciador de arquivos** e localize a raiz
   de `projetosdoleo.com`. Se for o domínio principal, normalmente é `public_html`;
   se for adicional, confira a raiz configurada para ele em **Domínios**.
3. Dentro dessa raiz, crie ou abra `tico`. Use **Carregar/Upload** para enviar
   o ZIP e depois **Extrair** nessa mesma pasta. O resultado deve ser
   `public_html/tico/index.html` quando a raiz for `public_html`.
   Inclua o `.htaccess` do pacote; habilite a exibição de arquivos ocultos
   nas configurações do gerenciador para conferir sua presença.
4. Abra `https://projetosdoleo.com/tico/` e pressione **Jogar**.
5. Verifique no celular os passos da próxima seção.

Ajuda oficial da HostGator: [enviar arquivos pelo cPanel](https://suporte.hostgator.com.br/hc/pt-br/articles/30813145737235-Como-enviar-um-arquivo-para-o-cPanel)
e [extrair arquivos no gerenciador](https://suporte.hostgator.com.br/hc/pt-br/articles/30808065412371-Quais-as-funcionalidades-do-Gerenciador-de-arquivos-do-cPanel).

São arquivos estáticos: o servidor de produção não precisa executar Node.js.
O endereço `/tico` deve redirecionar para `/tico/`, com a barra final.
Sirva `.wasm` como `application/wasm`, `.js` como JavaScript e `.json` como JSON.
Não use fallback de páginas do site para arquivos ausentes do jogo.

O `.htaccess` incluído aplica MIME e revalidação em Apache quando permitidos.
Em Nginx ou outro servidor, configure esses itens no painel ou na configuração
do site. Use `Cache-Control: no-cache` para HTML, JS, JSON, PCK e WASM;
habilite gzip/Brotli para reduzir a transferência, especialmente do WASM.
O cache offline é administrado pelo service worker dentro de `/tico/`.

## Roteiro no celular — repetir após atualizar

1. Abra o endereço HTTPS com internet, em landscape. Aguarde a indicação
   **Pronto para jogar offline neste dispositivo** e pressione **Jogar**.
2. Mantenha uma direção e PULO simultaneamente. Solte e pressione novamente;
   confirme salto, planar, movimento e ausência de botões presos.
3. Experimente Pausar, Continuar, Recomeçar, trocar de aplicativo e girar a tela.
4. Avalie tamanho dos botões, visibilidade, conforto e fluidez. Registre modelo
   do aparelho, sistema e navegador. O alvo do projeto continua sendo 60 FPS.
5. Instale pelo botão **Instalar**, quando oferecido, ou pelo menu do navegador.
   No Safari do iPhone, use Compartilhar → Adicionar à Tela de Início.
6. Feche o jogo e abra pelo ícone. Confirme nome, ícone e área de jogo.
7. Feche novamente, desligue Wi-Fi e dados móveis e reabra pelo ícone.
   Pressione Jogar e confirme movimento, salto e planar sem conexão.

Na etapa 6, teste Trocar, o movimento mais pesado de Pipo, empurrar a pedra,
passar pelo túnel com Tico, investir na parede com Pipo e seguir as partículas
do faro. Perca a vida após ativar a bandeira e confira personagem, corações e
progresso do puzzle no retorno. Suba as plataformas, chegue à árvore e use Jogar de novo.
O botão INVESTIR é o mesmo AÇÃO; o faro é automático.

A etapa 7 apresenta o **Bosque das Folhas** com arte ilustrada e áudio.
Teste a música, os efeitos, as opções no menu Pausar e a persistência dessas
preferências. Confirme que o áudio pausa ao mudar de aplicativo e que volta
corretamente. Confira o visual, a fluidez e o aquecimento durante uma sessão
de pelo menos dez minutos. [Roteiro da etapa 7](../tests/etapa_7.md).
Saves da etapa 6 são compatíveis: não limpe os dados do site ao atualizar.

Para validar o save: colete nozes, abra os obstáculos e ative a bandeira.
Confira **Progresso salvo**, feche o PWA, desligue a internet e reabra pelo ícone.
O personagem deve voltar à bandeira com três corações, mantendo nozes, segredo
e passagens abertas. Conclua e reabra: o resultado deve permanecer.
Recomeçar exige confirmação; cancelar mantém o progresso. Repita depois de atualizar
os arquivos, sem limpar os dados do site. O save pertence ao navegador/dispositivo.
Roteiro completo: [playtest da etapa 6](../tests/playtest_etapa_6.md).

## Atualizações

Gere cada versão com `npm.cmd run build:web`; o script calcula a versão do cache
pelos arquivos exportados. Publique o pacote completo. Quando aparecer
**Atualizar**, o jogador pode carregar a nova versão; a aventura retoma do ponto
seguro com o progresso salvo a partir da etapa 6. A etapa 5 não possuía save.
O worker remove somente caches antigos do Tico na mesma subpasta.

## Desenvolvimento local

```powershell
npm.cmd ci
npm.cmd run build:web
npm.cmd run serve:web
```

Abra `http://127.0.0.1:8080/tico/` no computador. Para testar instalação e
offline no celular, use o endereço HTTPS publicado. O servidor local serve
somente para desenvolvimento e escuta em `127.0.0.1` por padrão.

Referência técnica: [exportação Web da Godot](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html).
