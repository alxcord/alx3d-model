# Ralo plástico da cuba Deca L12030.17

Peça plástica que acompanha a cuba redonda de apoio Deca 30 cm branca (código L12030, cor 17). A Deca não vende a peça avulsa que encontrei, então este modelo permite imprimir uma nova em 3D.

A peça tem quatro partes em uma só:

1. Disco de 57 mm com 20 fendas radiais.
2. Corpo superior com 4 anéis e 8 colunas, entre o disco e a tampa.
3. Tampa de 32 mm com grelha de arcos concentricos.
4. Cesto inferior com 4 anéis e 8 colunas, que entra no ralo.

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| `ralo_deca.scad` | Modelo paramétrico em OpenSCAD. É a fonte de verdade. |
| `ralo_deca.stl` | Malha para o fatiador, gerada a partir do `.scad`. |

O STL é gerado pelo GitHub Actions (`.github/workflows/render-stl.yml`) a cada alteração no `.scad`. O OpenSCAD exporta STL em formato texto (ASCII). Arquivos STL binários são menores, mas o texto funciona igual em qualquer fatiador.

## Como gerar o STL manualmente

1. Abra `ralo_deca.scad` no OpenSCAD.
2. Pressione F6 para renderizar. Leva de 1 a 2 minutos.
3. Use Arquivo > Exportar > Exportar como STL.

## Medidas

`L` indica medida lida no paquímetro (visor apagado, leitura na escala, erro de cerca de 1 mm). `E` indica medida estimada pelas fotos. Confira as estimadas com a peça real antes de imprimir.

| Medida | Valor | Origem |
|---|---|---|
| Diâmetro do disco | 57 mm | L |
| Diâmetro externo do corpo | 27 mm | L |
| Espessura da parede | 2 mm | L |
| Diâmetro da tampa | 32 mm | L |
| Distância do disco à tampa | 13 mm | L |
| Comprimento do cesto inferior | 16 mm | L |
| Espessura do disco | 1,6 mm | E |
| Fendas do disco | 20, largura 1,6 mm | contadas, largura E |
| Anéis, colunas e grelha | ver o `.scad` | E |

Altura total do modelo: 33,8 mm.

## Impressão

Imprima com a tampa na mesa e o cesto para cima, que é a orientação do STL. O disco fica no ar, então use suporte embaixo dele, em volta do corpo. A peça original é translúcida, e PETG natural se aproxima dela. Use camada de 0,12 a 0,16 mm e 4 perímetros, porque as paredes têm 2 mm e as fendas têm 1,6 mm.

## Ajustes

Todas as medidas ficam no início do `.scad`. Se a peça impressa não encaixar, altere `NECK_D`, `CAGE_L` ou `CAP_D` e renderize de novo. Crie um arquivo novo para cada versão ajustada.
