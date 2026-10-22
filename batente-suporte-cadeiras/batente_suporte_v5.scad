// Batente v5 para a ponta do suporte das cadeiras (OpenSCAD)
// Eixos: X ao longo do suporte (X=0 na ponta, cresce para dentro do suporte),
//        Y na largura (centrado), Z para cima (Z=0 no fundo do canal).
// Medidas em mm. Parafuso M4 x 16 + porca M4. Cavidades com o formato exato.
// O suporte nao tem paredes externas: a peca tem 22 mm de largura em todos os pontos.

$fn = 64;

// ---------- Medidas do suporte ----------
LARG      = 22;     // largura total (tambem a largura da peca)
DIV       = 3;      // divisao do meio
ALT_CANAL = 18;     // altura do canal
FURO_X    = 23;     // centro do furo de 5 mm, a partir da ponta

// ---------- Parametros da peca ----------
FOLGA      = 0.3;   // folga de encaixe para impressao 3D
ESP_PAREDE = 6;     // espessura da parede na ponta (X de -6 a 0)
ALT_PAREDE = 18;    // altura da parede acima do canal
COMP_GARRA = 36;    // comprimento das garras dentro dos canais

// ---------- Parafuso M4 x 16 e porca M4 ----------
FURO_D     = 4.5;   // furo passante M4
CABECA_D   = 8.6;   // cabeca panela M4 (8,0) + folga
CABECA_PROF = 5.0;  // cabeca panela (3,1) ou cilindrica (4,0) fica rebaixada
PORCA_AF   = 7.3;   // porca M4: 7,0 entre faces + folga
PORCA_PROF = 5.0;   // porca M4 (3,2) encostada no fundo; M4x16 atravessa a porca inteira

// ---------- Derivados ----------
VAO        = DIV + 2*FOLGA;             // vao central onde passa a divisao
LARG_GARRA = (LARG - VAO) / 2;          // cada garra vai da borda de 22 mm ate o vao
Y_CENTRO   = VAO/2 + LARG_GARRA/2;      // centro de cada garra
Y_EXT      = LARG/2;                    // face externa da garra (|Y| = 11)
Z_FURO     = ALT_CANAL/2;
R_PORCA    = PORCA_AF / sqrt(3);        // raio circunscrito do sextavado
TOPO       = ALT_CANAL + ALT_PAREDE;

// ---------- Perfil lateral: parede + rampa que termina rente ao topo do canal ----------
N = 60;
rampa = [ for (i = [0:N]) let(t = i/N)
          [ COMP_GARRA*t, ALT_CANAL + ALT_PAREDE*0.5*(1 + cos(180*t)) ] ];
perfil = concat([[-ESP_PAREDE, 0], [-ESP_PAREDE, TOPO]],
                rampa,
                [[COMP_GARRA, ALT_CANAL], [0, ALT_CANAL], [0, 0]]);

module cabeca() {
    // perfil em XZ extrudado ao longo de Y, centrado
    rotate([90, 0, 0]) linear_extrude(height = LARG, center = true) polygon(perfil);
}

module garras() {
    // duas garras com largura total de 22 mm e vao no meio para a divisao
    for (lado = [-1, 1])
        translate([-0.5, lado*Y_CENTRO - LARG_GARRA/2, 0])
            cube([COMP_GARRA + 0.5, LARG_GARRA, ALT_CANAL]);
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
    furo_parafuso();
    rebaixo_cabeca();
    sextavado_porca();
}
