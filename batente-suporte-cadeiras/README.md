# batente-suporte-cadeiras

Batente impresso em 3D para a ponta do suporte de parede das cadeiras dobráveis de madeira. A parede alta na ponta impede as cadeiras de deslizarem e caírem. Duas garras entram no suporte, uma de cada lado da divisão do meio, e um parafuso M4 fixa a peça pelo furo de 5 mm do suporte.

## Arquivos

| Arquivo | Descrição |
|---|---|
| `batente_suporte_v9.scad` | Versão atual: furo do parafuso a 13 mm do fim das garras |
| `batente_suporte_v8.scad` | Garras de 46 mm, base 2 mm mais baixa, parede mais baixa, nova curva e ponta suave (furo ainda a 23 mm da parede, errado) |
| `batente_suporte_v7.scad` | Bordas da parede arredondadas |
| `batente_suporte_v6.scad` | Ponta das garras arredondada |
| `batente_suporte_v5.scad` | Sulco fechado pela parede |

## Medidas

L = lida com paquímetro, E = estimada.

| Medida | Valor (mm) | Origem |
|---|---|---|
| Largura do suporte e da peça | 22 | L |
| Divisão do meio | 3 | L |
| Altura do canal | 18 | L |
| Furo de 5 mm, centro a partir da ponta do suporte | 23 | L |
| Furo de 5 mm, centro a partir da parede da peça | 33 | E (23 + 10 de extremidade) |
| Furo de 8 mm, centro a partir da ponta do suporte | 33 | L |
| Folga de encaixe | 0,3 | E |
| Folga extra do sulco, de cada lado | 0,5 | E |
| Parede da ponta (espessura x altura acima do canal) | 6 x 13 | E |
| Comprimento das garras | 46 | E |
| Descida extra da base | 2 | L (folga medida no teste impresso) |
| Espessura da rampa no fim | 1 | E |
| Raio do arredondamento das bordas da parede | 3 | E |

A peça mede 52 x 22 x 33 mm. O suporte não tem paredes externas, então as duas garras ocupam os 22 mm inteiros. O sulco central tem 4,6 mm, passa de ponta a ponta e atravessa também a parede da ponta, até a altura do canal. Cada garra fica com 8,7 mm. A rampa cai rápido junto da parede e acaba plana, com 1 mm de material sobre as garras e a ponta arredondada, sem quina. O arredondamento das bordas vale só para o contorno externo da face da parede. As quinas do sulco ficam vivas.

A altura do furo não muda com a descida da base: o furo fica 11 mm acima da base nova, o mesmo ponto absoluto de antes, porque a base desceu 2 mm sem mover o resto.

## Parafuso e porca

Parafuso M4 x 16 (cabeça panela ou cilíndrica) e porca M4 comum. O rebaixo da cabeça é um cilindro de 8,6 mm x 5 mm, no lado -Y. O encaixe da porca é um sextavado de 7,3 mm entre faces x 5 mm, no lado +Y. O parafuso entra por fora, atravessa as garras e a divisão e rosca na porca.

## Impressão

Imprima com a face de trás da parede (X = -6) apoiada na mesa, ou de lado sobre a face de 22 x 52 mm. Use PETG ou ABS, 4 perímetros e 40% de preenchimento. Se o encaixe ficar justo no suporte, aumente `FOLGA` no topo do `.scad`.

## Como ajustar

Todos os parâmetros ficam no topo do `.scad`. O furo acompanha `EXT_EXTREMIDADE`: se alongar ou encurtar a peça do lado da parede, mude esse valor. A curva da rampa muda com `P_CURVA` (maior cai mais rápido junto da parede) e `H_FIM`. Para exportar o STL: `openscad -o batente_suporte_v9.stl batente_suporte_v9.scad`.
