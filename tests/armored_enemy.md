# Inimigos com defesa quebrável — 0.36.3

O Mundo 2 introduz besouros blindados nas três fases de percurso. A carapaça
azul-petróleo possui placas, rebites dourados e brilho de impacto, distinguindo
o inimigo dos besouros comuns.

## Regra do encontro

1. Pisão e caudada produzem som metálico, `CLANG!` e uma orientação curta.
2. A investida de Pipo quebra a carapaça, mas não derrota o inimigo nesse golpe.
3. Sem a defesa, caudada, pisão ou uma nova investida podem finalizar o besouro.
4. Derrota e reinício restauram a armadura e o encontro completo.

A solução usa a animação existente do besouro com uma camada vetorial leve para
a armadura. Não foi adicionada uma nova textura animada nem processamento fora
da lógica normal dos inimigos.
