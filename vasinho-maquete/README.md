# vasinho-maquete

Vasinho de plantas para a maquete do El Caminito. Cada versão é um arquivo novo, as anteriores ficam mantidas.

## Arquivos

| Arquivo | Descrição |
|---|---|
| vasinho.scad | v1. Vaso em uma cor, com terra e montinho (20 mm de altura) |
| vasinho_v2.scad | v2. Vaso e planta em dois corpos, para duas cores |
| vasinho_v3.scad | v3. Planta enche a abertura, uma única troca de cor |

## Medidas

L = lida, E = estimada. Nenhuma medida foi lida de peça real.

| Versão | Vaso (altura x boca x base) | Conjunto com planta | Origem |
|---|---|---|---|
| v1 | 20 x 18 x 12 mm | 20 mm | E |
| v2 | 20 x 18 x 12 mm | 28,5 mm | E |
| v3 | 20 x 18 x 12 mm | 30,1 mm | E |

## Como gerar os STLs

Nas v2 e v3 a variável `parte` escolhe o corpo: `vaso`, `planta` ou `conjunto`.

```
openscad -D 'parte="vaso"'   -o vasinho_v3_vaso.stl   vasinho_v3.scad
openscad -D 'parte="planta"' -o vasinho_v3_planta.stl vasinho_v3.scad
```

## Notas de impressão

| Item | Valor |
|---|---|
| Orientação | Base do vaso na mesa (z = 0) |
| Suporte | Não precisa |
| Duas cores | Importar vaso e planta na mesma posição e atribuir uma cor a cada corpo |
| Troca de cor (v3) | Uma só, em z = altura do vaso |
| Ponto frágil v2 e v3 | Hastes das flores (0,9 a 1 mm) |

## Como ajustar

Todos os parâmetros ficam no topo do `.scad`, com unidade e origem (E). Para outra escala, altere `altura`, `diam_boca`, `diam_base`, `raio_copa` e o tamanho das folhas e flores. Abaixo de 0,5 mm os detalhes não imprimem com bico de 0,4 mm.
