# Coroa-mola do ralo da pia Tramontina

Peça de reposição do anel plástico branco que ficava entre o cesto e a válvula da pia Tramontina. A peça original se perdeu e não é vendida separadamente, nem vem nos kits de válvula americana 3.1/2".

A coroa encaixa no ralo com o aro apoiado no fundo. As pontas dos dentes empurram o cesto para cima e mantêm a separação que deixa a água escoar pelos recortes em V.

Os dentes se unem na base, então a saia é um cone facetado contínuo e os recortes só aparecem na metade de cima. Isso deixa a peça rígida sem perder a elasticidade das pontas.

## Arquivos

| Arquivo | Descrição |
| --- | --- |
| `coroa_mola.scad` | Modelo paramétrico em OpenSCAD |

O STL e as vistas não ficam no repositório. Gere o STL com `openscad -o coroa_mola.stl coroa_mola.scad`.

## Medidas

L = lida no paquímetro. E = estimada por fotogrametria das fotos ou por teste de encaixe.

| Parâmetro | Valor (mm) | Origem | Descrição |
| --- | --- | --- | --- |
| `d_ext` | 80 | L | Diâmetro externo do aro, igual ao do ralo |
| `d_int` | 34 | E | Diâmetro no círculo das pontas dos dentes |
| `subida` | 14 | E | Altura da ponta do dente em relação ao aro |
| `larg_aro` | 3 | E | Largura da faixa lisa do aro |
| `esp` | 2,4 | E | Espessura da chapa |
| `n_dentes` | 20 | E | Quantidade de dentes |
| `larg_pta` | 2,0 | E | Largura do dente na ponta |
| `sobrep` | 1,12 | E | Sobreposição na base que solda um dente no outro |

Resultado: 80,0 x 80,0 x 16,1 mm, sólido único e estanque.

Medidas de referência do conjunto: ralo com 80 mm de diâmetro e 25 mm de profundidade, cesto com 78 mm de borda externa.

## Impressão

| Item | Valor |
| --- | --- |
| Impressora | Anycubic Kobra S1 V2 |
| Orientação | Aro na mesa, dentes para cima (já é a orientação do modelo) |
| Suporte | Não precisa |
| Material | PETG. O PLA quebra no primeiro aperto e o TPU cede demais |
| Altura de camada | 0,2 mm |
| Perímetros | 3 |
| Preenchimento | 40% |

## Como ajustar

Encosta no ralo e raspa na hora de encaixar: baixe `d_ext` para 79,4.

O cesto ainda veda ou fica baixo demais: suba `subida` em passos de 2 mm.

A peça fica alta e o cesto balança: desça `subida` em passos de 2 mm.

Quer mais vão para a água passar: baixe `sobrep` para 1,02, e os recortes descem quase até a base.

Quer mais rigidez: suba `sobrep` para 1,25, e os recortes ficam só nas pontas.
