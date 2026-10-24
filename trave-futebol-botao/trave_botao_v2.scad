// Trave de futebol de botão (estilo e tamanho do kit Pais e Filhos / Casas Bahia)
// Impressora: Anycubic Kobra S1 V2
// Origem das medidas: L = lida da ficha do produto, E = estimada

// ---------- Parâmetros (mm) ----------
largura      = 120;   // L: comprimento da boca da trave (12 cm)
profundidade = 50;    // L: largura/profundidade do gol (5 cm)
altura       = 50;    // L: altura do gol (5 cm)
barra        = 3;     // E: seção quadrada das barras da estrutura
rede_barra   = 1.6;   // E: espessura da rede (4 passadas de bico 0,4)
rede_passo   = 10;    // E: distância entre cruzamentos da rede (losango)
ov           = 0.1;   // sobreposição entre partes, para virar um único sólido
imprimir_deitada = true; // true: teto na mesa, de cabeça para baixo (sem suporte)

// ---------- Rede em losango (2D) ----------
// Faixas a 45° nos dois sentidos, cortadas pelo retângulo w x h
module rede2d(w, h, passo, e) {
    n   = ceil((w + h) / passo);
    big = w + h;
    intersection() {
        square([w, h]);
        union() {
            for (i = [-n : n]) {
                // família de faixas a +45°
                translate([i * passo, 0]) rotate(45)
                    translate([-e / 2, -big]) square([e, 2 * big]);
                // família de faixas a -45°
                translate([i * passo, 0]) rotate(-45)
                    translate([-e / 2, -big]) square([e, 2 * big]);
            }
        }
    }
}

// ---------- Estrutura: barras que formam a caixa aberta na frente ----------
module estrutura() {
    b = barra;
    // postes verticais: 2 da frente e 2 de trás
    for (x = [0, largura - b], y = [0, profundidade - b])
        translate([x, y, 0]) cube([b, b, altura]);
    // travessão da frente e barra superior de trás (ao longo de x)
    for (y = [0, profundidade - b])
        translate([0, y, altura - b]) cube([largura, b, b]);
    // barras superiores laterais (ao longo de y)
    for (x = [0, largura - b])
        translate([x, 0, altura - b]) cube([b, profundidade, b]);
    // barras de chão laterais (ao longo de y)
    for (x = [0, largura - b])
        translate([x, 0, 0]) cube([b, profundidade, b]);
    // barra de chão do fundo (ao longo de x); a frente fica aberta
    translate([0, profundidade - b, 0]) cube([largura, b, b]);
}

// ---------- Redes: faces rentes ao lado de fora da estrutura ----------
module redes() {
    b = barra; e = rede_barra;
    // fundo (plano x-z, rente a y = profundidade)
    translate([b / 2, profundidade, b / 2]) rotate([90, 0, 0])
        linear_extrude(e) rede2d(largura - b, altura - b, rede_passo, e);
    // topo (plano x-y, rente a z = altura)
    translate([b / 2, b / 2, altura - e])
        linear_extrude(e) rede2d(largura - b, profundidade - b, rede_passo, e);
    // laterais (plano y-z), esquerda rente a x = 0 e direita a x = largura
    for (x = [0, largura - e])
        translate([x, b / 2, b / 2]) rotate([90, 0, 90])
            linear_extrude(e) rede2d(profundidade - b, altura - b, rede_passo, e);
}

module trave() {
    union() {
        estrutura();
        redes();
    }
}

// ---------- Orientação de impressão ----------
// De cabeça para baixo: o teto (barras do topo e rede do topo) fica na mesa.
// Os 4 postes sobem na vertical, as redes laterais e do fundo viram paredes com
// losangos a 45° e as barras do chão ficam no alto, apoiadas pelas pontas da rede
// a cada rede_passo mm. Nenhuma barra de 120 mm fica em ponte, então não há suporte.
if (imprimir_deitada)
    translate([0, profundidade, altura]) rotate([180, 0, 0]) trave();
else
    trave();
