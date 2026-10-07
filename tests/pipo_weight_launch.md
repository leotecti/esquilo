# Mola de peso e vento — fase 2-1

Na primeira travessia do Mundo 2, o antigo arremesso de Tico foi substituído
por uma mola artesanal na margem do rio.

- O vento contrário empurra Tico para a esquerda e suas rajadas ficam visíveis.
- Pipo resiste ao vento e consegue chegar à mola.
- Tico comprime pouco a mola e recebe apenas um salto curto.
- O peso de Pipo produz um lançamento alto e diagonal até a plataforma suspensa.
- A plataforma móvel sobre esse trecho foi removida. Cair no rio causa dano e
  devolve o personagem à última margem segura.

A mola usa desenho vetorial simples, sem partículas ou texturas adicionais. A
animação de compressão só atualiza o próprio desenho e reaproveita a camada de
cenário para representar o vento.

Execute a validação com:

```powershell
& 'D:\Godot\Godot_v4.7.2-stable\Godot_v4.7.2-stable_console.exe' --headless --path . --script tests/pipo_weight_launch_test.gd --fixed-fps 60
```
