# suporte-notebook-ergo

Suporte de notebook com 5 ângulos, inspirado no Ergo LSP14 da Kalunga (295 x 220 mm, 5 ângulos). A bandeja gira numa dobradiça na frente e um apoio com barra redonda encaixa em 5 entalhes nos trilhos da base. Quatro peças, todas cabem na mesa da Kobra S1 V2 (250 x 250 mm).

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| suporte_notebook.scad | Modelo paramétrico. A variável PART escolhe a peça |
| base.stl | Base com trilhos, orelhas da dobradiça e 5 entalhes |
| bandeja.stl | Bandeja com janelas de ventilação, cilindros da dobradiça e orelhas do apoio |
| apoio.stl | Apoio em U com barra redonda no pé |
| trava.stl | Trava frontal que segura o notebook, encaixa na bandeja |
| vistas/ | Pranchas de cada peça e da montagem |

## Medidas

L = lida, E = estimada ou de projeto. Nenhuma foi lida no produto; a página da Kalunga só informa 295 x 220 mm, 304 g e 5 ângulos.

| Medida | Valor | Origem |
|---|---|---|
| Base | 236 x 234 x 27 mm | E |
| Bandeja | 242 x 213 x 16 mm (impressa) | E |
| Ângulos | 14, 21, 28, 35 e 42 graus | E |
| Pino das articulações | filamento 1,75 mm, furo de 2,0 mm | E |
| Folga entre peças móveis | 0,4 mm | E |

## Impressão

| Peça | Orientação | Suporte | Observação |
|---|---|---|---|
| Base | Como está, trilhos para cima | Não | Furos dos pinos na horizontal |
| Bandeja | Já está de cabeça para baixo, face de cima na mesa | Não | Use brim |
| Apoio | Em pé, apoiado nas bordas | Não | Use brim |
| Trava | Deitada | Não | Encaixa nos furos retangulares da bandeja, com cola |

Material PETG ou PLA, camada de 0,2 mm, 4 perímetros, 25% de preenchimento. A bandeja tem 5 mm de espessura com janelas grandes, então prefira PETG e 5 perímetros se o notebook for pesado.

## Montagem

Dois pedaços de filamento de 1,75 mm de cerca de 30 mm fazem a dobradiça da bandeja nas orelhas da base, um de cada lado. Mais dois pedaços ligam o apoio às orelhas da bandeja. Dobre as pontas dos pinos com um ferro de solda ou cola. A barra do apoio entra num dos 5 entalhes dos trilhos. Cole a trava nos furos retangulares da bandeja.

## Como ajustar

Os ângulos ficam em ANGS e o comprimento do apoio em L. Os entalhes da base são calculados a partir desses valores, então basta mudar e renderizar de novo. Os entalhes mais próximos ficam a 10,6 mm de distância, com parede de cerca de 3 mm entre eles.
