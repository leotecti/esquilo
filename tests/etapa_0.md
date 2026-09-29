# Registro de validação — Etapa 0

Data: 2026-09-29. Ambiente: Windows, Godot 4.7.2 stable (edição padrão).

| Verificação | Resultado |
| --- | --- |
| Integridade da distribuição Godot | SHA512 do ZIP confere com `SHA512-SUMS.txt` do release oficial |
| Inicialização da engine | `4.7.2.stable.official.ed1daf0bf` |
| Importação do projeto no editor, modo headless | Código de saída 0, sem erros |
| Execução da cena principal, modo headless | Código de saída 0, sem erros |
| Execução gráfica por 60 frames | Código de saída 0, Compatibility / OpenGL 3.3, Intel Iris Xe |
| Salvamento da cena | `ResourceSaver.save` retornou `OK` |
| Salvamento das configurações | `ProjectSettings.save` retornou `OK` |
| Reabertura e leitura do Input Map | Seis ações carregadas com A/esquerda, D/direita, Espaço, E, Q e Esc |
| Git | Repositório local inicializado em `main`; primeiro commit da etapa |

## Procedimento reproduzível

Na raiz do projeto, em PowerShell:

```powershell
$engine = Join-Path $env:LOCALAPPDATA 'Programs\Godot\4.7.2\Godot_v4.7.2-stable_win64_console.exe'
& $engine --headless --path . --editor --import --quit
& $engine --headless --path . --quit-after 10
& $engine --path . --rendering-method gl_compatibility --quit-after 60
```

O salvamento foi validado por um script temporário fora do repositório,
usando `ResourceSaver.save` para `scenes/main.tscn` e `ProjectSettings.save`
para `project.godot`, seguido de nova execução da engine.

## Limites desta validação

A cena é intencionalmente vazia. Os comandos verificam ambiente, carregamento,
renderização e persistência dos arquivos do projeto; não validam gameplay,
save de progresso, exportação Windows, Web/PWA, touch ou Android.

Não houve playtest nem avaliação visual manual. A execução gráfica foi
verificada pelo processo e pelo log do renderizador. Esses resultados não
substituem os testes previstos para os próximos marcos.
