# Registro de validação — Etapa 1

Data: 2026-09-29. Godot 4.7.2 stable, Windows x86_64, Compatibility.

## Integração de input e física

Comando executado na raiz:

```powershell
$engine = 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_win64_console.exe'
& $engine --headless --path . --script tests/foundation_test.gd
```

Resultado: **16 verificações aprovadas, 0 falhas, código de saída 0**.
O teste instancia a cena principal real e injeta eventos de teclado na engine.

Atualização da etapa 2: como a cena principal passou a abrir Tico Playground,
o teste de regressão agora instancia diretamente `test_level.tscn`, preservada
com a mesma geometria e o corpo provisório. As 16 verificações passaram novamente.

- Gravidade e apoio no chão no ponto inicial.
- Movimento por D e A.
- Salto por Espaço e aterrissagem.
- Bloqueio nas paredes esquerda e direita usando as setas.
- Apoio sobre cada uma das três plataformas.
- Bloqueio pela parte inferior da plataforma durante salto.
- Recepção dos comandos E e Q.
- Pausa por Esc, imobilidade do corpo e retomada por Esc.

## Exportação e execução

- Templates oficiais 4.7.2 stable conferidos por SHA512.
- Instalados somente os templates Windows x86_64 debug/release e `version.txt`.
- Preset `Windows Desktop`, exportação debug sem erros.
- Artefatos: `builds/windows/etapa_1/Tico.exe` e `Tico.pck`.
- Executável iniciado com diretório de trabalho fora do projeto por 90 frames.
- Código de saída 0, sem erros no log.
- Renderizador: Compatibility, OpenGL 3.3, Intel Iris Xe Graphics.
- Captura da cena inspecionada: instruções, corpo, chão, paredes e plataformas visíveis.

Comando de exportação:

```powershell
& $engine --headless --path . --export-debug 'Windows Desktop' 'builds/windows/etapa_1/Tico.exe'
```

Os arquivos do jogo devem permanecer juntos. O ZIP em
`builds/windows/Tico-etapa-1-windows.zip` reúne EXE e PCK. Logs, captura,
binários e ZIP ficam fora do Git.

## Limites

Esta etapa valida infraestrutura e um corpo provisório. Não valida Tico,
qualidade de salto, câmera, planar, arte final, touch, Web/PWA nem Android.
Não houve playtest com crianças ou medição de desempenho de uma fase completa.
