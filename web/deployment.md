# Publicar Tico Web/PWA

Destino informado: **https://projetosdoleo.com/tico/**.
O pacote foi preparado localmente; ainda não foi enviado à hospedagem.

## Pacote

`builds/web/Tico-etapa-3-web.zip` contém os arquivos que devem ficar diretamente
na pasta pública correspondente a `/tico/`, incluindo `index.html`, `index.js`,
`index.wasm`, `index.pck`, manifesto, service worker e ícones.
Não coloque outra pasta `etapa_3` entre `/tico/` e os arquivos.

1. Guarde uma cópia do conteúdo existente em `/tico/` antes da substituição.
2. Envie e extraia o ZIP pelo gerenciador de arquivos da hospedagem ou pelo
   método de publicação que ela oferece. O serviço ainda não foi informado.
3. Abra `https://projetosdoleo.com/tico/` e pressione **Jogar**.
4. Verifique no celular os passos da próxima seção.

São arquivos estáticos: o servidor de produção não precisa executar Node.js.
O endereço `/tico` deve redirecionar para `/tico/`, com a barra final.
Sirva `.wasm` como `application/wasm`, `.js` como JavaScript e `.json` como JSON.
Não use fallback de páginas do site para arquivos ausentes do jogo.

O `.htaccess` incluído aplica MIME e revalidação em Apache quando permitidos.
Em Nginx ou outro servidor, configure esses itens no painel ou na configuração
do site. Use `Cache-Control: no-cache` para HTML, JS, JSON, PCK e WASM;
habilite gzip/Brotli para reduzir a transferência, especialmente do WASM.
O cache offline é administrado pelo service worker dentro de `/tico/`.

## Roteiro no celular — necessário para concluir a etapa 3

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

AÇÃO está reservada para interações futuras. Pipo e troca de personagem ainda
não fazem parte deste playground. Os gráficos permanecem provisórios.

## Atualizações

Gere cada versão com `npm.cmd run build:web`; o script calcula a versão do cache
pelos arquivos exportados. Publique o pacote completo. Quando aparecer
**Atualizar**, o jogador pode carregar a nova versão; a partida volta ao início.
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
