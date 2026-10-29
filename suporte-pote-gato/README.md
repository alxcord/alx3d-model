# suporte-pote-gato

Suporte inclinado (15°) para o pote de aço inox do gato, de Ø157 mm na borda. A parte mais larga do pote fica em cima. A versão atual, a v9, são duas peças impressas separadas: o suporte, com duas pernas de patinha vazada, quatro reforços curvos e um vão em funil, e o anel de apoio, que encaixa no funil.

As versões v1 a v6 foram feitas em Python e não estão neste repositório.

## Como o encaixe funciona

O vão do suporte é um cone de 50°. O anel tem a mesma borda cônica e assenta no funil como uma cunha, centrado e firme, com 0,25 mm de folga radial para a tolerância da impressão. O pote apoia no topo do anel, 2 mm abaixo da face, com 3 mm de folga por lado até a parede do vão. A borda do pote apoia 4,5 mm no anel, e o corpo passa pelo furo do anel com folga.

Os dois cones têm mais de 45°, então nenhuma peça precisa de suporte. O suporte imprime com a face do pote na mesa. O anel imprime com a face que recebe o pote na mesa, que sai lisa, e o cone estreita para cima. Isso foi conferido fatiando o STL do suporte a cada 0,2 mm. Só a segunda camada passa uns 0,4 mm sobre a primeira, por causa do arredondamento da boca junto à mesa, o que a impressora absorve. No conjunto montado o anel não penetra no suporte e a menor distância entre as peças é 0,19 mm.

## Arquivos

| Arquivo | O que é |
|---|---|
| `suporte_pote_gato_v9.scad` | Modelo paramétrico das duas peças. A variável `PECA` escolhe: `"suporte"`, `"anel"` ou `"conjunto"` (os dois montados, só para ver) |
| `suporte_pote_gato_v9_suporte.stl` | Peça 1, o suporte, na orientação de impressão |
| `suporte_pote_gato_v9_anel.stl` | Peça 2, o anel de apoio, na orientação de impressão |
| `vistas_v9/corte_encaixe.png` | Corte do encaixe pelo centro, com a borda do pote |
| `vistas_v9/conjunto.png` | Suporte e anel montados |
| `vistas_v9/suporte/prancha.png` | Vistas do suporte |
| `vistas_v9/anel/prancha.png` | Vistas do anel |
| `suporte_pote_gato_v7.scad`, `suporte_pote_gato_v8.scad` | Versões anteriores em peça única. A v7 precisava de suporte e a v8 tem o assento direto na rampa |

## Medidas

L = lida, E = estimada, D = derivada dos parâmetros.

| Medida | Valor | Origem |
|---|---|---|
| Diâmetro da borda do pote | 157 mm | L |
| Diâmetro do corpo do pote | 130 mm | E |
| Vão no topo do anel (folga de 3 mm por lado) | Ø163 mm | D |
| Boca do suporte, na face | Ø166,4 mm | D |
| Funil do suporte | 50°, 7 mm de profundidade | escolha |
| Furo do suporte, no fundo do funil | Ø154,6 mm | D |
| Anel, diâmetro externo | Ø162,5 mm em cima e Ø155,8 mm embaixo | D |
| Anel, furo | Ø148 mm | D |
| Anel, espessura | 4 mm | escolha |
| Topo do anel abaixo da face | 2 mm | escolha |
| Folga do anel no cone | 0,25 mm radial | escolha |
| Inclinação da peça | 15° | escolha |
| Espessura da placa | 8 mm | escolha |
| Altura do lado baixo | 40 mm | E |
| Suporte | cerca de 186 x 180 x 82 mm, 218 cm³ | D |
| Anel | 162,5 x 162,5 x 4 mm, 10,7 cm³ | D |

O corpo do pote e a altura do lado baixo ainda não foram medidos. O furo do anel de Ø148 deixa 9 mm de folga por lado para um corpo de Ø130. A altura do lado baixo precisa passar da profundidade do corpo do pote.

## Notas de impressão

Suporte e anel: nenhum suporte. Material: PETG ou PLA. Altura de camada: 0,2 mm. Perímetros: 3 paredes, com ordem Interna/Externa/Interna e "Precise wall" ligado. Compense o "elephant foot" em 0,2 a 0,3 mm.

Para reduzir os fios que cruzam o furo do suporte, ligue "Avoid crossing walls" no fatiador, deixe o filamento seco e use costura alinhada atrás.

Se o anel ficar justo demais depois de impresso, aumente `FOLGA_ANEL` para 0,3 e reimprima o anel. Se ficar frouxo, reduza para 0,15. O pote assenta o anel no cone pelo próprio peso. Uma gota de cola no cone prende o anel de vez, se você quiser.

## Como ajustar

Todos os parâmetros estão no topo do `.scad`. Para um pote com outra borda, mude `BORDA_D`. `FOLGA_POTE` é a folga do pote no vão e `APOIO` é quanto da borda do pote apoia no anel. `ANGULO` define a inclinação do cone das duas peças, e 45° ou mais imprime sem suporte. `ANEL_TOPO` e `ANEL_ESP` definem a profundidade e a espessura do anel, e `PLACA` precisa ser maior que a soma dos dois mais 1,5 mm. Use `RES = 96` para testar rápido e `RES = 240` para o STL final.
