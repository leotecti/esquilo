# Arte do Bosque das Folhas — etapa 7

Ilustrações produzidas com a ferramenta **imagegen integrada**, usando as
referências locais `img/esquilo.png` e `img/porquinho.png`. Não foi usada a CLI/API.
O acabamento proposto ainda depende da aprovação do usuário no jogo.

| Arquivo final | Uso | Origem |
| --- | --- | --- |
| `tico.png` | Oito poses: idle, duas corridas, salto, queda, planar, dano, celebração | Referência de Tico + geração + edição de fundo |
| `pipo.png` | Doze poses: idle, duas corridas, salto, queda, empurrar, investir, farejar, dano, celebrar, preparar, recuperar | Referência de Pipo + geração + edição de fundo |
| `push.png` | Quatro poses de esforço de Tico e quatro passadas de Pipo empurrando | Geração com referência nos dois atlas de personagens |
| `props.png` | Noz, lesma, blocos, parede, pedra, arbusto, grama, samambaia, flores, bandeira | Geração com alpha |
| `forest.png` | Fundo ilustrado e capa Web | Geração |
| `ground.svg` | Solo com borda de grama | Vetor criado no projeto |
| `heart.svg` | Corações do HUD | Vetor criado no projeto |
| `touch.svg`, `touch_pressed.svg` | Controles normal/pressionado | Vetores criados no projeto |
| `regions.json` | Limites de cada pose/objeto nos atlas | `tools/atlas_regions.gd` |

Os primeiros atlas de personagens apresentaram fundo quadriculado opaco.
Uma edição pela própria ferramenta substituiu esse fundo por magenta uniforme.
`chroma_key.gdshader` faz o recorte durante a renderização, mantendo os PNGs
originais intactos. O atlas de objetos já possui transparência real.
Os arquivos usados pelo jogo estão nesta pasta; não dependem de caminhos externos.

Os atlas são recortados por `AtlasTexture`, com recursos compartilhados em cache.
O cálculo dos limites ignora alpha vazio e magenta; não modifica os arquivos.
Alterar uma prancha exige conferir a grade e recalcular `regions.json`:

```powershell
& $engine --headless --path . --script tools/atlas_regions.gd
```

Animações combinam as poses ilustradas com ciclos de respiração, corrida, faro
e celebração. Não há interpolação que altere o corpo físico do personagem.
Pouso usa a pose de repouso; preparação e recuperação de Pipo têm poses próprias.
O ciclo de Pipo empurrando avança a cada 12 pixels percorridos. Ao chegar ao
limite da pedra, os pés param. Tico usa um ciclo de esforço ao segurar a direção
contra a pedra, sem ganhar a capacidade de movê-la. As mãos são alinhadas à
lateral da colisão nos dois sentidos. O atlas adicional usa o mesmo recorte magenta.

Áudio: `assets/audio/slice/`, composição e síntese originais, reproduzíveis com
`node tools/generate_slice_audio.mjs`. Música: 16 compassos, 100 BPM, 38,4 segundos,
loop mono PCM de 22.050 Hz. Doze efeitos curtos completam a trilha.
Não foram baixadas músicas nem efeitos de terceiros.

Os prompts finais estão em [prompts.md](prompts.md).
