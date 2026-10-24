# trave-futebol-botao

Trave de futebol de botão para impressão 3D, no tamanho do kit Pais e Filhos (Casas Bahia): 120 x 50 x 50 mm, frente aberta, rede em losango nas laterais, no fundo e no topo.

## Arquivos

| Arquivo | Descrição |
|---|---|
| `trave_botao_v2.scad` | Modelo atual, orientado para imprimir sem suporte |
| `trave_botao_v2.stl` | STL pronto para o fatiador |
| `trave_botao.scad` | Primeira versão, mantida. Sai em pé com 120 mm de altura, não use |
| `vistas/` | Elevação, lateral, planta, três vistas 3D e a prancha com todas |

## Medidas

| Parâmetro | Valor | Origem |
|---|---|---|
| `largura` | 120 mm | L (ficha do produto) |
| `profundidade` | 50 mm | L (ficha do produto) |
| `altura` | 50 mm | L (ficha do produto) |
| `barra` | 3 mm | E |
| `rede_barra` | 1,6 mm | E (4 passadas de bico 0,4) |
| `rede_passo` | 10 mm | E |

L = lida da ficha do produto. E = estimada. A ficha não informa a seção das barras nem a malha da rede.

## Impressão

A trave imprime de cabeça para baixo, com o teto na mesa. Os quatro postes sobem na vertical, a rede das laterais e do fundo fica a 45° e as barras do chão ficam no alto, apoiadas pelas pontas da rede a cada 10 mm. O vão máximo em ponte é de cerca de 8 mm. Não precisa de suporte.

Inclinar a peça na mesa não elimina as pontes. As barras de 120 mm continuam cada uma em uma altura diferente, sem nada embaixo.

| Item | Sugestão |
|---|---|
| Material | PLA |
| Altura de camada | 0,2 mm |
| Perímetros | 2 |
| Preenchimento | 100% (as peças são finas) |
| Suporte | Não |
| Brim | Opcional, ajuda na aderência do teto |

## Como ajustar

Todos os parâmetros ficam no topo de `trave_botao_v2.scad`. Para ver a trave na posição de uso, troque `imprimir_deitada` para `false`. Para gerar o STL: `openscad -o trave_botao_v2.stl trave_botao_v2.scad`.
