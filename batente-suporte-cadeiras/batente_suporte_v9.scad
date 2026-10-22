// Batente v9 para a ponta do suporte das cadeiras (OpenSCAD)
// Eixos: X ao longo do suporte (X=0 na ponta, cresce para dentro do suporte),
//        Y na largura (centrado), Z para cima (Z=0 no fundo do canal).
// Medidas em mm. Parafuso M4 x 16 + porca M4. Cavidades com o formato exato.
// O suporte nao tem paredes externas: a peca tem 22 mm de largura em todos os pontos.
// v8: garras 10 mm mais longas, base 2 mm mais baixa (sem folga), parede 5 mm mais baixa,
//     rampa mais fina com 1 mm de material no fim, curva que cai rente a parede e ponta suave.
// v9: furo do parafuso deslocado 10 mm (acompanha o aumento da extremidade): fica a 13 mm do fim das garras.

$fn = 64;

// ---------- Medidas do suporte ----------
LARG      = 22;     // largura total (tambem a largura da peca)
DIV       = 3;      // divisao do meio
ALT_CANAL = 18;     // altura do canal
EXT_EXTREMIDADE = 10;   // quanto a peca foi alongada do lado da parede (ponta do suporte fica 10 mm depois da parede)
FURO_X    = 23 + EXT_EXTREMIDADE;  // furo de 5 mm: 23 mm da ponta do suporte, medido a partir da parede

// ---------- Parametros da peca ----------
FOLGA      = 0.3;   // folga de encaixe para impressao 3D
ESP_PAREDE = 6;     // espessura da parede na ponta (X de -6 a 0)
ALT_PAREDE = 13;    // altura da parede acima do canal (era 18)
COMP_GARRA = 46;    // comprimento das garras dentro dos canais (era 36)
BASE_EXTRA = 2;     // a peca desce 2 mm alem do fundo antigo, para eliminar a folga na base
FOLGA_SULCO = 0.5;  // folga extra de cada lado do sulco (sulco 1 mm mais largo)
R_BORDA    = 3;     // raio do arredondamento das bordas da face externa da parede
H_FIM      = 1.0;   // espessura da rampa no fim, acima das garras (evita falta de material)
R_NARIZ    = 0.9;   // raio do arredondamento da ponta da rampa (ponta suave, sem quina)
P_CURVA    = 3;     // forca da curva: maior = cai mais rapido junto da parede

// ---------- Parafuso M4 x 16 e porca M4 ----------
FURO_D     = 4.5;   // furo passante M4
CABECA_D   = 8.6;   // cabeca panela M4 (8,0) + folga
CABECA_PROF = 5.0;  // cabeca panela (3,1) ou cilindrica (4,0) fica rebaixada
PORCA_AF   = 7.3;   // porca M4: 7,0 entre faces + folga
PORCA_PROF = 5.0;   // porca M4 (3,2) encostada no fundo; M4x16 atravessa a porca inteira

// ---------- Derivados ----------
VAO        = DIV + 2*FOLGA + 2*FOLGA_SULCO; // sulco central onde passa a divisao (4,6 mm)
LARG_GARRA = (LARG - VAO) / 2;          // cada garra vai da borda de 22 mm ate o vao
Y_CENTRO   = VAO/2 + LARG_GARRA/2;      // centro de cada garra
Y_EXT      = LARG/2;                    // face externa da garra (|Y| = 11)
Z_FURO     = ALT_CANAL/2;               // altura do furo, igual a v7 (ja estava certo)
R_PORCA    = PORCA_AF / sqrt(3);        // raio circunscrito do sextavado
TOPO       = ALT_CANAL + ALT_PAREDE;

// ---------- Perfil lateral: parede + rampa concava que cai rente a parede ----------
N = 60;
LC = COMP_GARRA - R_NARIZ;               // comprimento da curva, antes da ponta arredondada
// espessura da rampa acima das garras: cai rapido junto da parede e acaba plana
rampa = [ for (i = [0:N]) let(t = i/N)
          [ LC*t, ALT_CANAL + H_FIM + (ALT_PAREDE - H_FIM)*pow(1 - t, P_CURVA) ] ];

function arco(cx, cz, r, a0, a1) = [ for (i = [0:12]) let(a = a0 + (a1 - a0)*i/12)
                                     [ cx + r*cos(a), cz + r*sin(a) ] ];
perfil = concat([[0, -BASE_EXTRA]],
                arco(-ESP_PAREDE + R_BORDA, -BASE_EXTRA + R_BORDA, R_BORDA, 270, 180),  // canto de baixo
                arco(-ESP_PAREDE + R_BORDA, TOPO - R_BORDA, R_BORDA, 180, 90),          // canto de cima
                rampa,
                arco(LC, ALT_CANAL + H_FIM - R_NARIZ, R_NARIZ, 90, 0),                  // ponta suave
                [[COMP_GARRA, ALT_CANAL], [0, ALT_CANAL]]);

module cabeca() {
    // perfil em XZ extrudado ao longo de Y, centrado; a planta arredonda as duas
    // quinas verticais da face externa da parede
    intersection() {
        rotate([90, 0, 0]) linear_extrude(height = LARG, center = true) polygon(perfil);
        translate([0, 0, -BASE_EXTRA - 1]) linear_extrude(height = TOPO + BASE_EXTRA + 2) hull() {
            translate([-ESP_PAREDE + R_BORDA, -LARG/2])
                square([ESP_PAREDE + COMP_GARRA - R_BORDA, LARG]);
            for (lado = [-1, 1])
                translate([-ESP_PAREDE + R_BORDA, lado*(LARG/2 - R_BORDA)]) circle(r = R_BORDA);
        }
    }
}

module garra(y0, y1) {
    // garra reta entre y0 e y1; entra 0,5 mm na parede para soldar no mesmo corpo
    translate([-0.5, y0, -BASE_EXTRA]) cube([COMP_GARRA + 0.5, y1 - y0, ALT_CANAL + BASE_EXTRA]);
}

module garras() {
    // duas garras que somam 22 mm de largura, com o sulco no meio
    garra(-Y_EXT, -VAO/2);
    garra(VAO/2, Y_EXT);
}

module sulco_passante() {
    // sulco central de ponta a ponta: atravessa tambem a parede da ponta
    translate([-ESP_PAREDE - 1, -VAO/2, -BASE_EXTRA - 1])
        cube([ESP_PAREDE + COMP_GARRA + 2, VAO, ALT_CANAL + BASE_EXTRA + 1]);
}

module furo_parafuso() {
    translate([FURO_X, 0, Z_FURO]) rotate([90, 0, 0])
        cylinder(d = FURO_D, h = LARG + 4, center = true);
}

module rebaixo_cabeca() {   // cilindro exato, no lado -Y
    translate([FURO_X, -Y_EXT - 0.01, Z_FURO]) rotate([-90, 0, 0])
        cylinder(d = CABECA_D, h = CABECA_PROF + 0.01);
}

module sextavado_porca() {  // sextavado exato, no lado +Y
    translate([FURO_X, Y_EXT + 0.01, Z_FURO]) rotate([90, 0, 0])
        rotate([0, 0, 30])  // cantos para cima/baixo, faces planas nas laterais
            cylinder(r = R_PORCA, h = PORCA_PROF + 0.01, $fn = 6);
}

difference() {
    union() { cabeca(); garras(); }
    sulco_passante();
    furo_parafuso();
    rebaixo_cabeca();
    sextavado_porca();
}
