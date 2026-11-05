// Suporte de notebook ajustável (5 ângulos) - inspirado no Ergo LSP14
// Impressora: Anycubic Kobra S1 V2 (mesa 250x250 mm)
// Peças: base, bandeja, apoio (prop) e trava frontal.
// Eixos da peça montada: x = profundidade (frente -> fundo), y = largura, z = altura.
// L = medida lida, E = medida estimada/de projeto.

PART = "montagem";   // "montagem" | "base" | "bandeja" | "apoio" | "trava"

// ---------- Parâmetros ----------
W    = 234;    // largura total da base, mm (E)
RL   = 236;    // comprimento dos trilhos da base, mm (E)
RH   = 12;     // altura dos trilhos, mm (E)
RW   = 24;     // largura de cada trilho, mm (E)

PIN   = 2.0;   // furo para pino de filamento 1,75 mm (E)
FOLGA = 0.4;   // folga entre peças móveis, mm (E)

HX = 12;       // x do eixo da dobradiça, mm (E)
PZ = 20;       // z do eixo da dobradiça, mm (E)

TL = 236;      // comprimento da bandeja a partir do eixo, mm (E)
TW = W - 2*(10 + FOLGA);  // largura da bandeja, mm
BR = 6;        // raio dos cilindros da dobradiça, mm (E)

PD = 120;      // distância do pino do apoio ao eixo, ao longo da bandeja, mm (E)
PV = -5;       // posição do pino do apoio abaixo do plano do eixo, mm (E)
L  = 94;       // distância entre o pino e o eixo do pé do apoio, mm (E)
ANGS = [14, 21, 28, 35, 42];   // 5 ângulos da bandeja, graus
ANG_SHOW = 28;                 // ângulo usado na montagem exibida

FZ = 11;       // z do centro do pé do apoio, mm (E)
FR = 3.5;      // raio do pé (barra redonda), mm (E)
NR = 3.7;      // raio dos encaixes na base, mm (E)

$fn = 48;

// ---------- Auxiliares ----------
// Cilindro com eixo ao longo de y, de y0 a y1, centrado em x=0, z=0
module cil_y(r, y0, y1) {
    translate([0, y0, 0]) rotate([-90, 0, 0]) cylinder(r = r, h = y1 - y0);
}
// Repete os filhos e o espelho deles em relação ao plano y = W/2
module espelha() {
    children();
    translate([0, W, 0]) mirror([0, 1, 0]) children();
}

// ---------- Cinemática do apoio ----------
// Posição do pino do apoio na bandeja inclinada de a graus
function px(a) = HX + PD*cos(a) - PV*sin(a);
function pz(a) = PZ + PD*sin(a) + PV*cos(a);
// x do pé do apoio: o apoio tem comprimento fixo L
function footx(a) = px(a) + sqrt(L*L - pow(pz(a) - FZ, 2));

// ---------- BASE ----------
module base() {
    difference() {
        union() {
            // trilhos laterais
            espelha() cube([RL, RW, RH]);
            // travessas: frente, meio e fundo
            translate([0, RW - 1, 0])      cube([20, W - 2*RW + 2, 6]);
            translate([110, RW - 1, 0])    cube([14, W - 2*RW + 2, 4]);
            translate([RL - 12, RW - 1, 0]) cube([12, W - 2*RW + 2, 8]);
            // orelhas da dobradiça (y de 0 a 10)
            espelha() hull() {
                translate([HX, 0, PZ]) cil_y(7, 0, 10);
                translate([HX - 7, 0, 0]) cube([14, 10, 2]);
            }
        }
        // furos do pino da dobradiça (orelha + cilindro da bandeja)
        espelha() translate([HX, -1, PZ]) cil_y(PIN/2, 0, 28);
        // encaixes do pé do apoio, um por ângulo
        espelha() for (a = ANGS)
            translate([footx(a), -1, FZ]) cil_y(NR, 0, RW + 2);
    }
}

// ---------- BANDEJA (no sistema local: u ao longo da bandeja, v para cima) ----------
// A origem é o eixo da dobradiça. Placa com v de 1 a 6.
module bandeja_local() {
    difference() {
        union() {
            // placa
            translate([0, 10 + FOLGA, 1]) cube([TL, TW, 5]);
            // cilindros da dobradiça
            espelha() hull() {
                translate([0, 10 + FOLGA, 0]) cil_y(BR, 0, 15.6);
                translate([0, 10 + FOLGA, 1]) cube([BR, 15.6, 5]);
            }
            // orelhas do pino do apoio (duas por lado, o braço passa no meio)
            espelha() for (y0 = [23, 34.8])
                hull() {
                    translate([PD, 0, PV]) cil_y(5, y0, y0 + 5);
                    translate([PD - 5, y0, 0.5]) cube([10, 5, 1.5]);
                }
        }
        // furo do pino da dobradiça
        espelha() translate([0, 9, 0]) cil_y(PIN/2, 0, 18);
        // furo do pino do apoio
        espelha() translate([PD, 22, PV]) cil_y(PIN/2, 0, 19);
        // janelas de ventilação (3 x 3)
        for (u = [40, 100, 160]) for (y = [48, 97, 146])
            translate([u, y, -1]) cube([50, 40, 10]);
        // furos dos pinos da trava frontal
        for (y = pegs_y()) translate([24.8, y - 0.2, 0]) cube([4.4, 4.4, 10]);
    }
}
function pegs_y() = [10 + FOLGA + 30, W/2 - 2, W - 10 - FOLGA - 34];

// Bandeja na orientação de impressão: face de cima na mesa
module bandeja() {
    translate([0, 0, 6]) mirror([0, 0, 1]) bandeja_local();
}

// ---------- TRAVA FRONTAL (no sistema local da bandeja) ----------
module trava_local() {
    translate([24, 10 + FOLGA, 6]) cube([6, TW, 12]);     // barra
    for (y = pegs_y()) translate([25, y, 1]) cube([4, 4, 5.1]);  // pinos de encaixe
}
// Trava deitada na mesa: comprimento em x, altura em y, espessura em z
module trava() {
    multmatrix([[0,1,0,-(10+FOLGA)], [0,0,1,-1], [1,0,0,-24], [0,0,0,1]]) trava_local();
}

// ---------- APOIO (no sistema do uso: pino na origem, pé em x = L) ----------
module apoio_uso() {
    espelha() {
        // braço
        hull() {
            translate([0, 28.4, 0]) cil_y(5.5, 0, 6);
            translate([L, 28.4, 0]) cil_y(FR, 0, 6);
        }
    }
    // barra do pé (com base plana para imprimir)
    intersection() {
        translate([L, 0, 0]) cil_y(FR, 2, W - 2);
        translate([-10, 0, -FR + 0.5]) cube([L + 20, W, 2*FR]);
    }
}
module apoio_furos() {
    espelha() translate([0, 27.4, 0]) cil_y(PIN/2, 0, 8);
}
module apoio_pecas() {
    difference() { apoio_uso(); apoio_furos(); }
}
// Apoio em pé sobre a borda: gira para a linha de baixo ficar horizontal
module apoio() {
    phi = asin((5.5 - FR) / L);
    translate([0, 0, 5.5]) rotate([0, phi, 0]) apoio_pecas();
}

// ---------- MONTAGEM (só para conferir a geometria) ----------
module montagem(a) {
    color("gray") base();
    translate([HX, 0, PZ]) rotate([0, -a, 0]) {
        color("steelblue") bandeja_local();
        color("orange") trava_local();
    }
    // apoio posicionado entre o pino da bandeja e o encaixe da base
    ang = atan2(FZ - pz(a), footx(a) - px(a));
    color("seagreen") translate([px(a), 0, pz(a)]) rotate([0, -ang, 0]) apoio_pecas();
}

// ---------- Seleção ----------
if (PART == "base") base();
else if (PART == "bandeja") bandeja();
else if (PART == "apoio") apoio();
else if (PART == "trava") trava();
else montagem(ANG_SHOW);

// Posições dos encaixes (mm, a partir do eixo x=0), para conferência
for (a = ANGS) echo(str("angulo ", a, " -> pe em x = ", footx(a)));
