// Suporte inclinado para pote de gato (v8, OpenSCAD)
//
// Placa inclinada com furo passante, duas pernas laterais com patinha vazada
// e quatro reforcos curvos (2 atras, 2 na frente).
//
// Assento em rampa conica (funil): a boca e larga e a rampa estreita para
// baixo ate o furo. A borda do pote apoia no MEIO da rampa, entao ele se
// centraliza sozinho, tem folga para entrar e nao cai pelo furo.
// A rampa e a unica superficie de apoio, sem prateleira plana, e tem
// inclinacao de 45 graus ou mais. Assim a peca imprime sem suporte e o
// assento sai liso.
//
// O modelo sai na orientacao de impressao: face do pote na mesa (z = 0).
// Unidades em milimetros. L = medida lida, E = estimada.

/* [Pote] */
BORDA_D = 157;       // L  diametro da borda larga do pote
CORPO_D = 130;       // E  diametro do corpo abaixo da borda (so para conferir o furo)

/* [Rampa] */
ANGULO_RAMPA = 50;   // graus em relacao a horizontal; 45 ou mais imprime sem suporte (44 fica no limite)
PROF_RAMPA   = 6.0;  // profundidade da rampa; quanto maior, maior a boca e menor o furo
RAIO_BORDA   = 2.0;  // arredondamento da boca e do fundo da rampa

/* [Estrutura] */
INCLINACAO     = 15;   // graus
PLACA          = 7;    // espessura da placa, perpendicular a face (precisa ser maior que PROF_RAMPA)
PERNA          = 7;    // espessura de cada lateral
ALTURA_FRENTE  = 40;   // E  altura do lado baixo (precisa passar a profundidade do corpo do pote)
RAIO_CANTO     = 20;   // arredondamento dos cantos, vista de cima
PATA           = 38;   // altura da patinha vazada
REFORCO_TRAS   = 48;   // tamanho do reforco curvo atras
REFORCO_FRENTE = 26;   // tamanho do reforco curvo na frente
REFORCO_ESP    = 8;    // espessura dos reforcos, no sentido do comprimento

/* [Resolucao] */
RES = 240;             // lados do cone da rampa (use 96 para testar rapido)
$fn = 48;              // lados dos arcos pequenos

// ---------- Calculos derivados ----------
t = INCLINACAO;
avanco  = PROF_RAMPA / tan(ANGULO_RAMPA);              // avanco horizontal da rampa
R_BOCA  = BORDA_D / 2 + avanco / 2;                    // raio da boca, na face
R_FURO  = BORDA_D / 2 - avanco / 2;                    // raio do furo, no fundo da rampa
R_MAX   = 100;                                         // maior que a peca, so para o cortador

LARGURA = 2 * R_BOCA + 2 * PERNA;                      // largura total
comp    = LARGURA * cos(t);                            // comprimento no chao
function z_topo(x) = ALTURA_FRENTE + x * tan(t);       // altura da face inclinada
alt_fundo = z_topo(comp);
e = PLACA / cos(t);                                    // espessura vertical da placa
centro_face = [comp / 2, 0, z_topo(comp / 2)];         // centro da rampa na face

echo(str("Boca D", 2 * R_BOCA, " | furo D", 2 * R_FURO,
         " | folga da boca por lado ", R_BOCA - BORDA_D / 2,
         " | pote apoia a ", PROF_RAMPA / 2, " mm da face",
         " | largura ", LARGURA, " | comprimento no chao ", comp));

// ---------- Corpo: cunha, miolo oco e reforcos ----------
// Extruda um perfil 2D (x, z) na direcao Y, centrado em Y = 0.
module extrude_y(largura) {
    rotate([90, 0, 0]) linear_extrude(height = largura, center = true) children();
}

module cunha() {
    extrude_y(LARGURA)
        polygon([[0, 0], [comp, 0], [comp, alt_fundo], [0, ALTURA_FRENTE]]);
}

module miolo() {
    extrude_y(LARGURA - 2 * PERNA)
        polygon([[-1, -1], [comp + 1, -1],
                 [comp + 1, z_topo(comp + 1) - e], [-1, z_topo(-1) - e]]);
}

// Reforco com curva para dentro, ligando a perna a placa.
// lado = +1 / -1 (em Y); pos = "tras" / "frente".
module reforco(lado, pos) {
    y_in = LARGURA / 2 - PERNA;                        // face interna da perna
    x0 = (pos == "tras") ? comp - REFORCO_ESP - 6 : 6;
    L  = (pos == "tras") ? REFORCO_TRAS : REFORCO_FRENTE;
    z_u  = z_topo(x0) - e;                             // face de baixo da placa
    z_hi = z_topo(x0 + REFORCO_ESP);                   // topo (entra na placa)
    yc = y_in - L;  zc = z_u - L;                      // centro do quarto de circulo
    arco = [for (i = [0 : 40]) let (a = 90 - 90 * i / 40)
            [yc + L * cos(a), zc + L * sin(a)]];
    mirror([0, lado < 0 ? 1 : 0, 0])
        translate([x0, 0, 0])
            // (u, v, w) -> (x, y, z) = (w, u, v)
            multmatrix([[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]])
                linear_extrude(height = REFORCO_ESP)
                    polygon(concat([[y_in + 1, z_hi], [y_in - L, z_hi]],
                                   arco, [[y_in + 1, z_u - L]]));
}

// ---------- Patinha vazada ----------
PATA_H0 = 37.5;   // altura natural do desenho da patinha
PATA_CZ = 2.7;    // centro vertical do desenho da patinha

module pata_2d() {
    translate([0, -7]) scale([12, 9]) circle(1);                 // almofada
    for (d = [[-15, 7, 25], [-5.5, 15, 8], [5.5, 15, -8], [15, 7, -25]])
        translate([d[0], d[1]]) rotate(d[2]) scale([4.5, 6.5]) circle(1);   // dedos
}

module patas() {
    x_c = comp / 2;
    z_meio = (z_topo(x_c) - e) / 2;                    // meio do vao da perna
    extrude_y(LARGURA + 4)
        translate([x_c, z_meio]) scale(PATA / PATA_H0)
            translate([0, -PATA_CZ]) pata_2d();
}

// ---------- Rampa conica ----------
// Perfil (r, z) do que sai da placa, z = 0 na face e negativo para baixo.
// As quinas sao vivas aqui e arredondadas em perfil_suave().
module perfil_vivo() {
    polygon([
        [-10, 10], [-10, -12],                         // eixo do furo (lado de dentro)
        [R_FURO, -12], [R_FURO, -PROF_RAMPA],          // parede do furo
        [R_BOCA, 0],                                   // rampa ate a face
        [R_MAX, 0], [R_MAX, 10]
    ]);
}

module perfil_suave() {
    intersection() {
        translate([0, -20]) square([R_MAX + 5, 40]);   // so r >= 0, para o rotate_extrude
        // arredonda as quinas de plastico (boca e fundo da rampa)
        offset(r = -RAIO_BORDA) offset(delta = RAIO_BORDA)
            perfil_vivo();
    }
}

module rampa() {
    translate(centro_face) rotate([0, -t, 0])          // eixo perpendicular a face
        rotate_extrude($fn = RES) perfil_suave();
}

// ---------- Cantos arredondados (vista de cima) ----------
module prisma() {
    translate([0, 0, -10]) linear_extrude(height = alt_fundo + 20)
        offset(r = RAIO_CANTO) offset(delta = -RAIO_CANTO)
            translate([0, -LARGURA / 2]) square([comp, LARGURA]);
}

// ---------- Montagem na posicao de uso ----------
module suporte_uso() {
    intersection() {
        difference() {
            union() {
                difference() { cunha(); miolo(); }     // placa + duas pernas
                for (lado = [1, -1], pos = ["tras", "frente"])
                    intersection() { reforco(lado, pos); cunha(); }
            }
            patas();
            rampa();
        }
        prisma();
    }
}

// ---------- Orientacao de impressao: face do pote na mesa ----------
translate([0, 0, ALTURA_FRENTE * cos(t)])
    rotate([180, 0, 0]) rotate([0, t, 0])
        suporte_uso();
