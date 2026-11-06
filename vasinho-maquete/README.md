# vasinho-maquete

Vasinho de plantas para a maquete do El Caminito. Cada versão é um arquivo novo, as anteriores ficam mantidas.

## Arquivos

| Arquivo | Descrição |
|---|---|
| vasinho.scad | v1. Vaso em uma cor, com terra e montinho (20 mm de altura) |
| vasinho_v2.scad | v2. Vaso e planta em dois corpos, para duas cores |
| vasinho_v3.scad | v3. Planta enche a abertura, uma única troca de cor |
| vasinho_v4.scad | v4. Mesma ideia da v3 em escala de poste de 31 x 31 x 70 mm (~1:65) |

## Medidas

L = lida, E = estimada. Nenhuma medida foi lida de peça real.

| Versão | Vaso (altura x boca x base) | Conjunto com planta | Origem |
|---|---|---|---|
| v1 | 20 x 18 x 12 mm | 20 mm | E |
| v2 | 20 x 18 x 12 mm | 28,5 mm | E |
| v3 | 20 x 18 x 12 mm | 30,1 mm | E |
| v4 | 6 x 6,4 x 4,2 mm | 9,1 mm | E, escala ~1:65 assumida |

## Como gerar os STLs

Nas v2 a v4 a variável `parte` escolhe o corpo: `vaso`, `planta` ou `conjunto`.

```
openscad -D 'parte="vaso"'   -o vasinho_v4_vaso.stl   vasinho_v4.scad
openscad -D 'parte="planta"' -o vasinho_v4_planta.stl vasinho_v4.scad
```

## Notas de impressão

| Item | Valor |
|---|---|
| Orientação | Base do vaso na mesa (z = 0) |
| Suporte | Não precisa |
| Duas cores | Importar vaso e planta na mesma posição e atribuir uma cor a cada corpo |
| Troca de cor (v3 e v4) | Uma só, em z = altura do vaso |
| Bico | 0,4 mm |
| Camada v4 | 0,08 a 0,12 mm, impressão lenta |
| Ponto frágil v2 e v3 | Hastes das flores (0,9 a 1 mm) |

## Como ajustar

Todos os parâmetros ficam no topo do `.scad`, com unidade e origem (E). Para outra escala, altere `altura`, `diam_boca`, `diam_base`, `raio_copa` e o tamanho das folhas e flores. Abaixo de 0,5 mm os detalhes não imprimem.
