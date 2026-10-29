// Suporte inclinado para pote de gato (v11, OpenSCAD): suporte + anel de apoio
//
// Duas pecas impressas separadas. Troque PECA para exportar cada uma:
//   "suporte"   o suporte inclinado, com o vao em funil
//   "anel"      o anel de apoio que encaixa no funil
//   "conjunto"  os dois montados, so para ver (nao imprimir)
//
// O vao do suporte e um cone de ANGULO graus. O anel tem a mesma borda
// conica, entao assenta no funil como uma cunha, centrado e firme. O pote
// apoia no topo do anel, dentro do vao, com folga dos lados.
// Os dois cones tem 45 graus ou mais, entao nenhuma das pecas precisa de
// suporte. O suporte imprime com a face do pote na mesa. O anel imprime com
// a face que recebe o pote na mesa, que sai lisa.
//
// Unidades em milimetros. L = medida lida, E = estimada.

PECA = "suporte";   // "suporte", "anel" ou "conjunto"

/* [Pote] */
BORDA_D = 158;       // L  diametro da borda larga do pote
CORPO_D = 130;       // E  diametro do corpo abaixo da borda (so para conferir o furo do anel)
POTE_ALT = 31;       // L  altura do pote, da borda ate o fundo (so para conferir a folga ao chao)

/* [Anel e vao] */
ANGULO     = 50;     // graus em relacao a horizontal; 45 ou mais imprime sem suporte
FOLGA_POTE = 3.0;    // folga por lado entre a borda do pote e a parede do vao, na altura do topo do anel
FOLGA_ANEL = 0.25;   // folga radial entre o anel e o cone do suporte (impressao FDM: 0.2 a 0.3)
ANEL_TOPO  = 5.0;    // profundidade do topo do anel em relacao a face do suporte
ANEL_ESP   = 4.0;    // espessura do anel
APOIO      = 4.5;    // quanto da borda do pote apoia no anel (define o furo do anel)
RAIO_BOCA  = 1.5;    // arredondamento da boca e do fundo do vao no suporte
RAIO_FURO  = 1.0;    // arredondamento da borda do furo do anel, onde o pote encosta

/* [Estrutura] */
INCLINACAO     = 15;   // graus
PLACA          = 8;    // espessura da placa, perpendicular a face (o funil desce alem dela, no colar)
COLAR_PAREDE   = 5;    // parede do colar em volta do funil, na base (so ele desce abaixo da placa)
PERNA          = 7;    // espessura de cada lateral
ALTURA_FRENTE  = 40;   // E  altura do lado baixo (precisa passar a profundidade do corpo do pote)
RAIO_CANTO     = 20;   // arredondamento dos cantos, vista de cima
PATA           = 38;   // altura da patinha vazada
REFORCO_TRAS   = 48;   // tamanho do reforco curvo atras
REFORCO_FRENTE = 26;   // tamanho do reforco curvo na frente
REFORCO_ESP    = 8;    // espessura dos reforcos, no sentido do comprimento

/* [Resolucao] */
RES = 240;             // lados dos cones (use 96 para testar rapido)
$fn = 48;              // lados dos arcos pequenos

// ---------- Calculos derivados ----------
t  = INCLINACAO;
tg = tan(ANGULO);
R_POCO     = BORDA_D / 2 + FOLGA_POTE;                 // raio do vao na altura do topo do anel
R_BOCA     = R_POCO + ANEL_TOPO / tg;                  // raio da boca, na face
PROF_FUNIL = ANEL_TOPO + ANEL_ESP + 1;                 // profundidade do funil: anel mais 1 mm ate o fundo
PROF_COLAR = PROF_FUNIL + 1;                           // o colar desce ate aqui (1 mm de parede reta no fundo)
R_FUNDO    = R_POCO - (PROF_FUNIL - ANEL_TOPO) / tg;   // raio do furo do suporte, no fundo do funil
R_COLAR    = R_FUNDO + COLAR_PAREDE;                   // raio externo do colar
R_ANEL_TOPO = R_POCO - FOLGA_ANEL;                     // raio externo do anel, no topo
R_ANEL_BASE = R_ANEL_TOPO - ANEL_ESP / tg;             // raio externo do anel, embaixo
R_ANEL_FURO = BORDA_D / 2 - APOIO;                     // raio do furo do anel
R_MAX = 100;                                           // maior que a peca, so para o cortador

LARGURA = 2 * R_BOCA + 2 * PERNA;                      // largura total do suporte
comp    = LARGURA * cos(t);                            // comprimento no chao
function z_topo(x) = ALTURA_FRENTE + x * tan(t);       // altura da face inclinada
alt_fundo = z_topo(comp);
e = PLACA / cos(t);                                    // espessura vertical da placa
centro_face = [comp / 2, 0, z_topo(comp / 2)];         // centro do vao na face

echo(str("Boca D", 2 * R_BOCA, " | vao no topo do anel D", 2 * R_POCO,
         " | fundo do funil D", 2 * R_FUNDO,
         " | anel: externo D", 2 * R_ANEL_TOPO, " / D", 2 * R_ANEL_BASE,
         " furo D", 2 * R_ANEL_FURO, " espessura ", ANEL_ESP,
         " | largura ", LARGURA, " | comprimento no chao ", comp));
if (2 * R_ANEL_FURO < CORPO_D + 6)
    echo("ATENCAO: o furo do anel esta apertado para o corpo do pote");
if (PROF_COLAR < PLACA)
    echo("ATENCAO: o colar ficou acima da placa");
// Borda mais baixa do fundo do pote em relacao a mesa, com o pote inclinado.
// O corpo e o fundo cabem entre as pernas, o frontal e o traseiro sao abertos.
fundo_z = z_topo(comp / 2) - (ANEL_TOPO + POTE_ALT) * cos(t) - (CORPO_D / 2) * sin(t);
echo(str("Fundo do pote: borda mais baixa a ", fundo_z, " mm da mesa"));
if (fundo_z < 3)
    echo("ATENCAO: o fundo do pote encosta na mesa, aumente ALTURA_FRENTE");
if (R_ANEL_BASE - R_ANEL_FURO < 3)
    echo("ATENCAO: a parede do anel ficou fina na base (menos de 3 mm)");

// ---------- Corpo do suporte: cunha, miolo oco e reforcos ----------
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

// ---------- Vao em funil do suporte ----------
// Perfil (r, z) do que sai da placa, z = 0 na face e negativo para baixo.
// As quinas sao vivas aqui e arredondadas em perfil_suave().
module perfil_vivo() {
    polygon([
        [-10, 10], [-10, -12],                         // eixo do furo (lado de dentro)
        [R_FUNDO, -12], [R_FUNDO, -PROF_FUNIL],        // parede reta do fundo
        [R_BOCA, 0],                                   // cone ate a face
        [R_MAX, 0], [R_MAX, 10]
    ]);
}

module perfil_suave() {
    intersection() {
        translate([0, -20]) square([R_MAX + 5, 40]);   // so r >= 0, para o rotate_extrude
        // arredonda as quinas de plastico (boca e fundo do funil)
        offset(r = -RAIO_BOCA) offset(delta = RAIO_BOCA)
            perfil_vivo();
    }
}

module funil() {
    translate(centro_face) rotate([0, -t, 0])          // eixo perpendicular a face
        rotate_extrude($fn = RES) perfil_suave();
}

// ---------- Colar ----------
// Anel de material em volta do funil que desce abaixo da placa. Assim so o
// meio fica mais fundo e o resto da placa continua fino.
module colar() {
    translate(centro_face) rotate([0, -t, 0])
        translate([0, 0, -PROF_COLAR])
            cylinder(r = R_COLAR, h = PROF_COLAR - PLACA + 1, $fn = RES);
}

// ---------- Cantos arredondados (vista de cima) ----------
module prisma() {
    translate([0, 0, -10]) linear_extrude(height = alt_fundo + 20)
        offset(r = RAIO_CANTO) offset(delta = -RAIO_CANTO)
            translate([0, -LARGURA / 2]) square([comp, LARGURA]);
}

// ---------- Suporte na posicao de uso ----------
module suporte_uso() {
    intersection() {
        difference() {
            union() {
                difference() { cunha(); miolo(); }     // placa + duas pernas
                colar();                               // colar em volta do funil
                for (lado = [1, -1], pos = ["tras", "frente"])
                    intersection() { reforco(lado, pos); cunha(); }
            }
            patas();
            funil();
        }
        prisma();
    }
}

// ---------- Anel de apoio ----------
// Perfil (r, z) do anel na posicao de uso: topo em z = 0, corpo para baixo.
module anel_perfil() {
    c_r = R_ANEL_FURO + RAIO_FURO;  c_z = -RAIO_FURO;  // centro do arredondamento do furo
    arco = [for (i = [0 : 12]) let (a = 180 - 90 * i / 12)
            [c_r + RAIO_FURO * cos(a), c_z + RAIO_FURO * sin(a)]];
    polygon(concat([[R_ANEL_FURO, -ANEL_ESP]],         // base, lado do furo
                   arco,                               // sobe o furo e arredonda a borda
                   [[R_ANEL_TOPO, 0],                  // topo, onde o pote apoia
                    [R_ANEL_BASE, -ANEL_ESP]]));       // cone externo ate a base
}

module anel_corpo() {
    rotate_extrude($fn = RES) anel_perfil();
}

// ---------- Orientacoes de impressao e montagem ----------
// Suporte: face do pote na mesa (z = 0).
module suporte_impressao() {
    translate([0, 0, ALTURA_FRENTE * cos(t)])
        rotate([180, 0, 0]) rotate([0, t, 0])
            suporte_uso();
}

// Anel: face que recebe o pote na mesa (z = 0), cone estreitando para cima.
module anel_impressao() {
    rotate([180, 0, 0]) anel_corpo();
}

// Conjunto montado, so para conferir o encaixe.
module conjunto() {
    suporte_uso();
    color("orange") translate(centro_face) rotate([0, -t, 0])
        translate([0, 0, -ANEL_TOPO]) anel_corpo();
}

if (PECA == "suporte") suporte_impressao();
else if (PECA == "anel") anel_impressao();
else conjunto();
