# Bandeja Gridfinity A4 (6 x 8 unidades, em 4 peças)

Bandeja para pastas com elástico e papéis A4 deitados. A bandeja montada tem 6 x 8 unidades Gridfinity (252 x 336 mm). Cada peça tem 3 x 4 unidades (125,8 x 167,8 mm) e cabe na mesa da Anycubic Kobra S1 V2. As peças se unem por chaves borboleta (rabo de andorinha) coladas, sem parafuso aparente.

## Parâmetro que você deve mudar

Se o encaixe ficar apertado ou frouxo, mude só o `CL` em `bandeja_a4_v2.scad`.

| Parâmetro | Valor atual | O que faz |
|---|---|---|
| `CL` | 0,3 mm | Folga de cada lado do rasgo. Já inclui espaço para a cola. Chave não entra: aumente (0,35 / 0,4). Chave bamba: diminua (0,25 / 0,2). |

Depois de mudar, renderize de novo as 4 saídas (esquerda, direita, chave do piso, chave da parede), porque a chave e o rasgo usam o mesmo `CL`.

## Arquivos

| Arquivo | Descrição |
|---|---|
| `bandeja_a4_v2.scad` | Modelo OpenSCAD, com todos os parâmetros no topo |
| `peca_esq.stl` | Peça esquerda (3 x 4), com parede esquerda |
| `peca_dir.stl` | Peça direita, espelho da esquerda, com parede direita |
| `chave_piso.stl` | Chave borboleta do piso (3,1 mm de altura) |
| `chave_parede.stl` | Chave borboleta da parede (43 mm de altura) |
| `vistas/prancha_esq.png`, `vistas/prancha_dir.png` | Elevação, lateral, planta e vistas 3D |
| `vistas/explodida.png` | Duas peças afastadas com as chaves no ar |
| `vistas/juncao.png` | Desenho da chave e do rasgo, em planta e em corte |

## Quantas peças imprimir

| Item | Quantidade | Onde vai |
|---|---|---|
| `peca_esq.stl` | 2 | Frente esquerda e fundo direito (esta gira 180 graus) |
| `peca_dir.stl` | 2 | Frente direita e fundo esquerdo (esta gira 180 graus) |
| `chave_piso.stl` | 8 | 4 na união esquerda/direita, 4 na união frente/fundo |
| `chave_parede.stl` | 2 | Uma em cada parede lateral, na união frente/fundo |

## Medidas

L = lida, E = estimada.

| Medida | Valor | Origem |
|---|---|---|
| Passo Gridfinity | 42 mm | L (padrão) |
| Peça | 3 x 4 unidades | E |
| Altura total | 49 mm (7 unidades) | E |
| Topo do piso | 9 mm | E |
| Parede | 3 mm | E |
| Folga do encaixe (`CL`) | 0,3 mm por lado | E |
| Chave do piso | pescoço 8, ponta 14, 9 de cada lado | E |
| Chave da parede | pescoço 5, ponta 8, 6 de cada lado | E |
| Rebaixo frontal e traseiro | 60 mm de largura quando unido (30 mm por peça) | E |

## Notas de impressão

Imprima com os pés Gridfinity na mesa, sem suporte. PLA ou PETG, bico 0,4 mm, altura de camada 0,2 mm, 3 perímetros. Imprima a chave do piso como está (deitada) e a chave da parede em pé, como está no STL, sem suporte. As chaves entram por cima nos rasgos e ficam de 0,4 mm (piso) e 0,5 mm (parede) abaixo da superfície.

## Limitações conhecidas

- Os pés têm o perfil Gridfinity padrão, mas não há borda de empilhamento no topo.
- O pilar de união da parede avança cerca de 10 mm para dentro da bandeja.
- Nada disso foi impresso ainda. Teste primeiro uma chave e um canto da peça para validar a folga.
