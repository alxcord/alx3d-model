# batente-suporte-cadeiras

Batente impresso em 3D para a ponta do suporte de parede das cadeiras dobráveis de madeira. A parede alta na ponta impede as cadeiras de deslizarem e caírem. Duas garras entram no suporte, uma de cada lado da divisão do meio, e um parafuso M4 fixa a peça pelo furo de 5 mm do suporte.

## Arquivos

| Arquivo | Descrição |
|---|---|
| `batente_suporte_v6.scad` | Versão atual: sulco de ponta a ponta, 1 mm mais largo, ponta arredondada |
| `batente_suporte_v5.scad` | Versão anterior, sulco fechado pela parede |

## Medidas

L = lida com paquímetro, E = estimada.

| Medida | Valor (mm) | Origem |
|---|---|---|
| Largura do suporte e da peça | 22 | L |
| Divisão do meio | 3 | L |
| Altura do canal | 18 | L |
| Furo de 5 mm, centro a partir da ponta | 23 | L |
| Furo de 8 mm, centro a partir da ponta | 33 | L |
| Folga de encaixe | 0,3 | E |
| Folga extra do sulco, de cada lado | 0,5 | E |
| Parede da ponta (espessura x altura acima do canal) | 6 x 18 | E |
| Comprimento das garras | 36 | E |
| Raio da ponta arredondada | 3 | E |

A peça mede 42 x 22 x 36 mm. O suporte não tem paredes externas, então as duas garras ocupam os 22 mm inteiros. O sulco central tem 4,6 mm, passa de ponta a ponta e atravessa também a parede da ponta, até 18 mm de altura. Cada garra fica com 8,7 mm.

## Parafuso e porca

Parafuso M4 x 16 (cabeça panela ou cilíndrica) e porca M4 comum. O rebaixo da cabeça é um cilindro de 8,6 mm x 5 mm, no lado -Y. O encaixe da porca é um sextavado de 7,3 mm entre faces x 5 mm, no lado +Y. O parafuso entra por fora, atravessa as garras e a divisão e rosca na porca.

## Impressão

Imprima com a face de trás da parede (X = -6) apoiada na mesa, ou de lado sobre a face de 22 x 42 mm. Use PETG ou ABS, 4 perímetros e 40% de preenchimento. Se o encaixe ficar justo no suporte, aumente `FOLGA` no topo do `.scad`.

## Como ajustar

Todos os parâmetros ficam no topo do `.scad`, com comentário de unidade. Para exportar o STL: `openscad -o batente_suporte_v6.stl batente_suporte_v6.scad`.
