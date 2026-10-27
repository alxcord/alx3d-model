// Suporte inclinado para pote de gato (v7, OpenSCAD)
//
// Placa inclinada com furo passante, duas pernas laterais com patinha vazada
// e quatro reforcos curvos (2 atras, 2 na frente).
//
// Sulco em V (novo na v7): a boca tem parede externa inclinada, a parede de
// dentro e menor e termina numa prateleira plana, onde a borda do pote apoia.
// O fundo do V e as quinas de plastico sao arredondados. As duas paredes do V
// tem inclinacao maior que 45 graus, entao a peca imprime sem suporte.
//
// O modelo sai na orientacao de impressao: face do pote na mesa (z = 0).
// Unidades em milimetros. L = medida lida, E = estimada.

/* [Pote] */
BORDA_D = 157;       // L  diametro da borda larga do pote
CORPO_D = 130;       // E  diametro do corpo abaixo da borda (so para conferir o furo)

/* [Sulco em V] */
FOLGA_V    = 4.0;    // folga total (diametro) entre a borda e a parede externa, na altura da prateleira
PRAT_PROF  = 3.0;    // profundidade da prateleira onde o pote apoia
V_PROF     = 6.0;    // profundidade do vertice teorico do V (antes de arredondar)
V_INCL     = 1.5;    // profundidade / avanco das paredes do V (1.5 = ~56 graus; use >= 1 para nao precisar de suporte)
PRAT_LARG  = 3.0;    // largura da prateleira, do labio ate o furo
RAIO_FUNDO = 1.5;    // raio de arredondamento do fundo do V
RAIO_BORDA = 1.0;    // raio das quinas de plastico (boca, labio e borda do furo)

/* [Estrutura] */
INCLINACAO     = 15;   // graus
PLACA          = 7;    // espessura da placa, perpendicular a face
PERNA          = 7;    // espessura de cada lateral
ALTURA_FRENTE  = 40;   // E  altura do lado baixo (precisa passar a profundidade do corpo do pote)
RAIO_CANTO     = 20;   // arredondamento dos cantos, vista de cima
PATA           = 38;   // altura da patinha vazada
REFORCO_TRAS   = 48;   // tamanho do reforco curvo atras
REFORCO_FRENTE = 26;   // tamanho do reforco curvo na frente
REFORCO_ESP    = 8;    // espessura dos reforcos, no sentido do comprimento

/* [Resolucao] */
RES = 240;             // lados do cilindro do sulco (use 96 para testar rapido)
$fn = 48;              // lados dos arcos pequenos

// ---------- Calculos derivados ----------
t = INCLINACAO;
R_PRAT_EXT = (BORDA_D + FOLGA_V) / 2;                  // raio da parede externa na altura da prateleira
R_BOCA  = R_PRAT_EXT + PRAT_PROF / V_INCL;             // raio da boca, na face
R_FUNDO = R_BOCA - V_PROF / V_INCL;                    // raio do vertice do V
R_LABIO = R_FUNDO - (V_PROF - PRAT_PROF) / V_INCL;     // raio onde a parede interna chega a prateleira
R_FURO  = R_LABIO - PRAT_LARG;                         // raio do furo passante
R_MAX   = 100;                                         // maior que a peca, so para o cortador

LARGURA = 2 * R_BOCA + 2 * PERNA;                      // largura total
comp    = LARGURA * cos(t);                            // comprimento no chao
function z_topo(x) = ALTURA_FRENTE + x * tan(t);       // altura da face inclinada
alt_fundo = z_topo(comp);
e = PLACA / cos(t);                                    // espessura vertical da placa
centro_face = [comp / 2, 0, z_topo(comp / 2)];         // centro do sulco na face

echo(str("Boca D", 2 * R_BOCA, " | fundo do V D", 2 * R_FUNDO,
         " | labio D", 2 * R_LABIO, " | furo D", 2 * R_FURO,
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

// ---------- Sulco em V ----------
// Perfil (r, z) do que sai da placa, z = 0 na face e negativo para baixo.
// As quinas sao vivas aqui e arredondadas em perfil_suave().
module perfil_vivo() {
    polygon([
        [-10, 10], [-10, -12],                         // eixo do furo (lado de dentro)
        [R_FURO, -12], [R_FURO, -PRAT_PROF],           // parede do furo
        [R_LABIO, -PRAT_PROF],                         // prateleira
        [R_FUNDO, -V_PROF],                            // fundo do V
        [R_BOCA, 0],                                   // parede externa ate a face
        [R_MAX, 0], [R_MAX, 10]
    ]);
}

module perfil_suave() {
    intersection() {
        translate([0, -20]) square([R_MAX + 5, 40]);   // so r >= 0, para o rotate_extrude
        // 2) arredonda as quinas de plastico (boca, labio, borda do furo)
        offset(r = -RAIO_BORDA) offset(delta = RAIO_BORDA)
            // 1) arredonda o fundo do V
            offset(r = RAIO_FUNDO) offset(delta = -RAIO_FUNDO)
                perfil_vivo();
    }
}

module sulco() {
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
            sulco();
        }
        prisma();
    }
}

// ---------- Orientacao de impressao: face do pote na mesa ----------
translate([0, 0, ALTURA_FRENTE * cos(t)])
    rotate([180, 0, 0]) rotate([0, t, 0])
        suporte_uso();
