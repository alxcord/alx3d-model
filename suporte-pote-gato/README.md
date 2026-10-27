# suporte-pote-gato

Suporte inclinado (15°) para o pote de aço inox do gato, de Ø157 mm na borda. A parte mais larga do pote fica em cima. A peça tem duas pernas com patinha vazada, quatro reforços curvos (dois atrás e dois na frente) e um sulco em V arredondado em volta do furo, com uma prateleira onde a borda do pote apoia.

Esta é a v7, a primeira em OpenSCAD. As versões v1 a v6 foram feitas em Python e não estão neste repositório.

## O sulco em V

A boca do sulco tem parede externa inclinada. A parede de dentro é menor e termina numa prateleira plana de 3 mm, onde o pote apoia, 3 mm abaixo da face. A borda do pote passa por cima do V, com 2 mm de folga até a parede externa. O fundo do V e as quinas de plástico (boca, lábio e borda do furo) são arredondados. As duas paredes do V têm cerca de 56°, acima do limite de 45°, então a peça imprime sem suporte. Só a prateleira vira uma ponte de 3 mm e o topo arredondado do V um arco de cerca de 2 mm.

## Arquivos

| Arquivo | O que é |
|---|---|
| `suporte_pote_gato_v7.scad` | Modelo paramétrico em OpenSCAD |
| `suporte_pote_gato_v7.stl` | Malha pronta para o fatiador, já na orientação de impressão |
| `vistas/` | Elevação, lateral, planta, três vistas 3D, a prancha com todas e `corte_sulco.png` com o perfil do sulco |

## Medidas

L = lida, E = estimada, D = derivada dos parâmetros.

| Medida | Valor | Origem |
|---|---|---|
| Diâmetro da borda do pote | 157 mm | L |
| Diâmetro do corpo do pote | 130 mm | E |
| Boca do sulco, na face | Ø165 mm | D |
| Fundo teórico do V | Ø157 mm, 6 mm de profundidade | D |
| Lábio do V | Ø153 mm, 3 mm de profundidade | D |
| Furo passante | Ø147 mm | D |
| Inclinação | 15° | escolha |
| Espessura da placa | 7 mm | escolha |
| Altura do lado baixo | 40 mm | E |
| Dimensões da peça | cerca de 185 x 179 x 82 mm | D |

O corpo do pote e a altura do lado baixo ainda não foram medidos. O furo de Ø147 deixa mais de 6 mm de folga por lado para um corpo de Ø130. A altura do lado baixo precisa passar da profundidade do corpo do pote.

## Notas de impressão

Orientação: a face do pote fica na mesa, como já está no STL. Suporte: nenhum. Material: PETG ou PLA. Altura de camada: 0,2 mm. Perímetros: 3 paredes, com ordem Interna/Externa/Interna e "Precise wall" ligado.

Para reduzir os fios que cruzam o furo, ligue "Avoid crossing walls" no fatiador, deixe o filamento seco e use costura alinhada atrás. Compense o "elephant foot" em 0,2 a 0,3 mm. A primeira camada estreita um pouco as medidas, então a folga de 4 mm na borda do pote já considera isso.

## Como ajustar

Todos os parâmetros estão no topo do `.scad`. Para um pote com outra borda, mude `BORDA_D`. Para mais ou menos folga na borda, mude `FOLGA_V`. A profundidade da prateleira é `PRAT_PROF` e a largura dela é `PRAT_LARG`, que define o tamanho do furo. `V_INCL` controla a inclinação das paredes do V, e valores a partir de 1 dispensam suporte. `RAIO_FUNDO` e `RAIO_BORDA` controlam o arredondamento. Use `RES = 96` para testar rápido e `RES = 240` para o STL final.
