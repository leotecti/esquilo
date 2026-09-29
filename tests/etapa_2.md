# Registro de validação — Etapa 2: Tico jogável

Data: 2026-09-29. Godot 4.7.2 stable, Windows x86_64, Compatibility.

## Resultado técnico

**45 verificações de Tico aprovadas e 16 de regressão da etapa 1 aprovadas.**
As duas execuções encerraram com código 0. A importação dos 11 quadros SVG,
cenas e scripts ocorreu sem erros. A cena principal abre o Tico Playground.

```powershell
$engine = 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_win64_console.exe'
& $engine --headless --path . --editor --import --quit
& $engine --headless --path . --script tests/tico_test.gd --fixed-fps 60
& $engine --headless --path . --script tests/foundation_test.gd --fixed-fps 60
```

O teste de Tico usa a cena real, viewport de referência 1280 × 720, física
da engine e eventos de teclado. A regressão executa diretamente a área
preservada da etapa 1, pois a cena principal agora contém Tico.

### Comportamentos cobertos

- Spawn, chão seguro, aceleração, velocidade máxima, frenagem e direção visual.
- Idle, corrida, subida, queda, planar e aterrissagem.
- Salto curto e alto; botão mantido não repete saltos ao aterrissar.
- Ausência de salto duplo; controle não permite salto fora da tolerância.
- Coyote time e expiração; jump buffer e expiração antes da aterrissagem.
- Planar reduz a queda, consome tempo e para ao soltar Espaço ou esgotar a cauda.
- Reativar no ar não recarrega o planar; aterrissar recarrega.
- Percurso desde o chão até as quatro plataformas superiores pelos controles.
- Travessia longa com planar até a plataforma de pouso.
- Topos, parte inferior das plataformas e paredes bloqueiam o personagem.
- Câmera com antecipação, suavização e quatro limites da área.
- Pausa congela física e animação; Esc retoma; perda de foco pausa.
- Recomeçar restaura o ponto inicial e funciona durante a pausa.
- Reposicionar no ar não preserva contato antigo com o chão.

## Parâmetros iniciais para playtest

Os valores são provisórios e estão expostos no Inspector do personagem.

| Parâmetro | Valor inicial |
| --- | --- |
| Corrida | 300 px/s |
| Aceleração no chão | 2200 px/s² |
| Desaceleração no chão | 2600 px/s² |
| Aceleração/desaceleração no ar | 1400 px/s² |
| Velocidade inicial do salto | -560 px/s |
| Gravidade base | 1200 px/s² |
| Multiplicador de gravidade na queda | 1,35 |
| Velocidade máxima de queda | 900 px/s |
| Corte de velocidade ao soltar o salto | 0,48 |
| Coyote time | 0,10 s |
| Jump buffer | 0,12 s |
| Planar disponível por aterrissagem | 2,0 s |
| Velocidade máxima de queda planando | 100 px/s |
| Multiplicador de gravidade planando | 0,18 |
| Antecipação horizontal da câmera | até 110 px |
| Área de teste | 3800 × 900 px |

No teste, soltar Espaço após 2 frames gerou altura aproximada de **41,64 px**;
manter por 28 frames gerou **126,06 px**. Esses resultados descrevem a
configuração atual; não demonstram por si só que o controle é confortável.

## Exportação e inspeção visual

- Build debug Windows x86_64 em `builds/windows/etapa_2/`.
- `Tico.exe` e `Tico.pck` devem permanecer juntos.
- Executável iniciado fora da pasta do projeto por 120 frames, código 0.
- Log sem erros; Compatibility / OpenGL 3.3, Intel Iris Xe Graphics.
- Capturas de idle e glide inspecionadas em 1280 × 720: Tico visível, cauda
  aberta durante planar, chão/plataformas legíveis e HUD separado do cenário.
- ZIP: `builds/windows/Tico-etapa-2-windows.zip`.
- Capturas e logs ficam junto ao build, fora do Git.

## Ajustes feitos durante validação

- O teste headless fixa o viewport: `--script` não garantia a janela 16:9.
- A detecção de esgotamento do planar observa a transição antes de tocar o chão,
  pois a aterrissagem recarrega corretamente a habilidade.
- A travessia é observada até o pouso, incluindo toda a duração do voo.
- A plataforma de chegada foi ampliada, mantendo o vão, para dar margem ao pouso.
- Reposicionar Tico invalida o contato anterior com o chão, evitando coyote time
  incorreto após um teletransporte de teste.

## Playtest aprovado — Marco 1

A implementação e os testes técnicos estão concluídos. A seção 27 do roadmap
exige avaliar se controlar Tico é divertido antes de avançar para a etapa 3.
Em 2026-09-29, o usuário confirmou que testou a etapa 2, considerou o jogo
“bem jogável” e pediu o início da etapa 3. Marco 1 aprovado para o protótipo.

Roteiro curto para jogar:

1. Corra para os dois lados, solte a direção e inverta o movimento.
2. Compare um toque curto em Espaço com um salto segurando o botão.
3. Suba as plataformas e segure Espaço para planar até a área de pouso.
4. Solte o botão no ar, volte a segurá-lo e observe o limite da cauda.
5. Caia no chão seguro, pause, retome e use Recomeçar.

Registrar se há demora, deslize, salto difícil de prever, confusão entre
pular/planar ou câmera desconfortável. Ajustar os parâmetros a partir desse
retorno. Arte definitiva, áudio, touch, Web/PWA e testes com crianças continuam
fora da validação técnica desta etapa.
