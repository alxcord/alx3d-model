// Ralo plastico da cuba redonda de apoio Deca 30 cm (cod. L12030.17)
// Disco com fendas + corpo superior com aneis + tampa com grelha + cesto inferior que entra no ralo.
// Todas as medidas em mm. Peca no sentido de impressao: tampa na mesa (z = 0), cesto para cima.
// Abrir no OpenSCAD, F6 para renderizar e Arquivo > Exportar > STL.

$fn = 96;   // resolucao dos circulos

// ---------------- Medidas ----------------
// (L) = lida no paquimetro, (E) = estimada pelas fotos. Confira as estimadas com a peca real.

// Disco
DISC_D     = 57.0;  // (L) diametro do disco
DISC_T     = 1.6;   // (E) espessura do disco
SLOTS_N    = 20;    // fendas radiais do disco (contadas)
SLOT_W     = 1.6;   // (E) largura da fenda
SLOT_R_IN  = 16.5;  // (E) raio onde a fenda comeca
SLOT_R_OUT = 25.5;  // (E) raio onde a fenda termina

// Corpo (gaiola de aneis ligados por colunas)
NECK_D     = 27.0;  // (L) diametro externo do corpo
WALL       = 2.0;   // (L) espessura da parede
POSTS_N    = 8;     // (E) colunas verticais
POST_W     = 2.0;   // (E) largura de cada coluna

// Corpo superior, entre o disco e a tampa (tem rosca)
NECK_H     = 13.0;  // (L) distancia do disco ate a face interna da tampa (o corpo entra no copo da tampa)
RIBS_N     = 4;     // (E) aneis
RIB_H      = 2.0;   // (E) altura de cada anel
RIB_PROUD  = 0.6;   // (E) quanto o anel sobressai do corpo

// Cesto inferior, o que entra no ralo
CAGE_L     = 16.0;  // (L) comprimento
CAGE_RINGS = 4;     // (E) aneis
CAGE_RIB_H = 2.4;   // (E) altura de cada anel

// Tampa com grelha
CAP_D      = 32.0;  // (L) diametro externo
CAP_RIM    = 2.0;   // (E) parede lateral
CAP_H      = 3.2;   // (E) altura total
PLATE_T    = 1.2;   // (E) espessura da placa da grelha
GRILLE_RINGS = [[4.0, 5.6], [7.2, 8.8], [10.4, 12.0]];  // (E) [raio interno, raio externo] de cada anel de arcos
GRILLE_ARCS  = 8;   // (E) arcos por anel
GRILLE_SPOKE = 1.6; // (E) largura do raio fechado entre arcos

// ---------------- Valores derivados ----------------
R_NECK    = NECK_D / 2;
R_NECK_IN = R_NECK - WALL;

OV     = 0.1;                   // sobreposicao entre pecas, garante uma unica peca solida
Z_NECK = CAP_H;                 // face interna da tampa
Z_DISC = Z_NECK + NECK_H;       // base do disco
Z_CAGE = Z_DISC + DISC_T;       // base do cesto inferior

// ---------------- Modulos ----------------

// Anel (cilindro vazado) de altura h a partir de z0
module ring(r_out, r_in, z0, h) {
    translate([0, 0, z0])
        difference() {
            cylinder(r = r_out, h = h);
            translate([0, 0, -0.1]) cylinder(r = r_in, h = h + 0.2);
        }
}

// Gaiola: aneis igualmente espacados, ligados por colunas verticais
module cage(z0, len, n_rings, ring_h, r_out, n_posts) {
    pitch = (len - ring_h) / (n_rings - 1);
    for (i = [0 : n_rings - 1])
        ring(r_out, R_NECK_IN, z0 + i * pitch, ring_h);
    for (i = [0 : n_posts - 1])
        rotate([0, 0, 360 * i / n_posts])
            translate([R_NECK_IN, -POST_W / 2, z0])
                cube([WALL, POST_W, len]);
}

// Fenda radial com pontas arredondadas
module radial_slot(z0, h) {
    hull() {
        translate([SLOT_R_IN + SLOT_W / 2, 0, z0]) cylinder(d = SLOT_W, h = h, $fn = 24);
        translate([SLOT_R_OUT - SLOT_W / 2, 0, z0]) cylinder(d = SLOT_W, h = h, $fn = 24);
    }
}

// Disco com 20 fendas e furo central
module disc() {
    translate([0, 0, Z_DISC])
        difference() {
            cylinder(d = DISC_D, h = DISC_T);
            translate([0, 0, -0.1]) cylinder(r = R_NECK_IN, h = DISC_T + 0.2);
            for (i = [0 : SLOTS_N - 1])
                rotate([0, 0, 360 * i / SLOTS_N])
                    radial_slot(-0.1, DISC_T + 0.2);
        }
}

// Arco (setor de anel) entre os raios r0 e r1, de a0 ate a0 + span (graus)
module arc_slot(r0, r1, a0, span, z0, h) {
    translate([0, 0, z0])
        rotate([0, 0, a0])
            rotate_extrude(angle = span, $fn = 64)
                translate([r0, 0]) square([r1 - r0, h]);
}

// Tampa: aro lateral + placa com grelha concentrica (placa na mesa)
module cap() {
    r_cap = CAP_D / 2;
    step  = 360 / GRILLE_ARCS;
    // aro lateral
    ring(r_cap, r_cap - CAP_RIM, 0, CAP_H);
    // placa com os arcos vazados
    difference() {
        cylinder(r = r_cap - CAP_RIM + 0.05, h = PLATE_T);
        for (k = [0 : len(GRILLE_RINGS) - 1]) {
            r0   = GRILLE_RINGS[k][0];
            r1   = GRILLE_RINGS[k][1];
            rmid = (r0 + r1) / 2;
            span = step - (GRILLE_SPOKE / rmid) * 180 / PI;   // deixa um raio fechado entre arcos
            off  = (k % 2) * step / 2;                         // aneis alternados
            for (j = [0 : GRILLE_ARCS - 1])
                arc_slot(r0, r1, off + j * step - span / 2, span, -0.1, PLATE_T + 0.2);
        }
    }
}

// ---------------- Peca completa ----------------
// O corpo superior entra no copo da tampa ate a placa da grelha e entra no disco por OV.
// O cesto inferior tambem entra no disco por OV.
Z_BODY0 = PLATE_T - OV;
Z_BODY1 = Z_DISC + OV;

union() {
    cap();
    cage(Z_BODY0, Z_BODY1 - Z_BODY0, RIBS_N, RIB_H, R_NECK + RIB_PROUD, POSTS_N);   // corpo superior
    disc();
    cage(Z_CAGE - OV, CAGE_L + OV, CAGE_RINGS, CAGE_RIB_H, R_NECK, POSTS_N);        // cesto inferior
}
