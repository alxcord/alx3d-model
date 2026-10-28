# suporte-pote-gato

Suporte inclinado (15°) para o pote de aço inox do gato, de Ø157 mm na borda. A parte mais larga do pote fica em cima. A peça tem duas pernas com patinha vazada, quatro reforços curvos (dois atrás e dois na frente) e um assento em rampa cônica em volta do furo.

A versão atual é a v8, em OpenSCAD. As versões v1 a v6 foram feitas em Python e não estão neste repositório.

## A rampa

A boca da rampa tem Ø162 mm e o furo, no fundo, Ø152 mm. A rampa tem 50° de inclinação e 6 mm de profundidade. A borda do pote (Ø157) apoia no meio dela, a 3 mm da face, com 2,5 mm de folga por lado na boca. O pote se centraliza sozinho e não cai pelo furo. Qualquer borda entre Ø152 e Ø162 assenta na rampa. A boca e o fundo da rampa têm as quinas arredondadas.

Como a rampa é a única superfície de apoio e tem mais de 45°, cada camada se apoia na anterior e a peça imprime sem suporte. O assento sai liso, porque não toca em nenhum suporte. Isso foi conferido fatiando o STL a cada 0,2 mm. Só a segunda camada passa uns 0,4 mm sobre a primeira, por causa do arredondamento da boca junto à mesa, o que a impressora absorve.

## Arquivos

| Arquivo | O que é |
|---|---|
| `suporte_pote_gato_v8.scad` | Modelo paramétrico em OpenSCAD (versão atual) |
| `suporte_pote_gato_v8.stl` | Malha pronta para o fatiador, já na orientação de impressão |
| `vistas_v8/` | Elevação, lateral, planta, três vistas 3D, a prancha com todas e `corte_rampa.png` com o perfil da rampa |
| `suporte_pote_gato_v7.scad` | Versão anterior, com sulco em V e prateleira plana. Precisa de suporte sob a prateleira e por isso foi substituída |
| `vistas/` | Vistas da v7 |

## Medidas

L = lida, E = estimada, D = derivada dos parâmetros.

| Medida | Valor | Origem |
|---|---|---|
| Diâmetro da borda do pote | 157 mm | L |
| Diâmetro do corpo do pote | 130 mm | E |
| Boca da rampa, na face | Ø162 mm | D |
| Furo, no fundo da rampa | Ø152 mm | D |
| Inclinação da rampa | 50° | escolha |
| Profundidade da rampa | 6 mm | escolha |
| Borda do pote apoia a | 3 mm da face | D |
| Inclinação da peça | 15° | escolha |
| Espessura da placa | 7 mm | escolha |
| Altura do lado baixo | 40 mm | E |
| Dimensões da peça | cerca de 182 x 176 x 81 mm | D |

O corpo do pote e a altura do lado baixo ainda não foram medidos. O furo de Ø152 deixa 11 mm de folga por lado para um corpo de Ø130. A altura do lado baixo precisa passar da profundidade do corpo do pote.

## Notas de impressão

Orientação: a face do pote fica na mesa, como já está no STL. Suporte: nenhum. Material: PETG ou PLA. Altura de camada: 0,2 mm. Perímetros: 3 paredes, com ordem Interna/Externa/Interna e "Precise wall" ligado.

Para reduzir os fios que cruzam o furo, ligue "Avoid crossing walls" no fatiador, deixe o filamento seco e use costura alinhada atrás. Compense o "elephant foot" em 0,2 a 0,3 mm.

## Como ajustar

Todos os parâmetros estão no topo do `.scad`. Para um pote com outra borda, mude `BORDA_D`. `ANGULO_RAMPA` define a inclinação, e 45° ou mais imprime sem suporte (44° fica no limite). `PROF_RAMPA` define a profundidade: quanto maior, maior a boca e menor o furo, e o valor precisa ser menor que `PLACA`. `RAIO_BORDA` controla o arredondamento. Use `RES = 96` para testar rápido e `RES = 240` para o STL final.
