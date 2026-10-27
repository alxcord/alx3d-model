// Bandeja Gridfinity para pastas e papeis A4 deitados.
// Quarto da bandeja: 3 x 4 unidades. Quatro quartos formam 6 x 8 (252 x 336 mm).
// Unidas por chaves borboleta (rabo de andorinha) impressas a parte.
// Orientacao de impressao: pes Gridfinity na mesa (z = 0), sem suporte.
// L = lida, E = estimada.

// ---------- Parametros ----------
modo = "peca_esq";    // "peca_esq", "peca_dir", "chave_piso", "chave_parede", "explodida", "montagem"

U        = 42;        // mm, passo Gridfinity (padrao)
NX       = 3;         // unidades em X (padrao: 3)
NY       = 4;         // unidades em Y (padrao: 4)
TOL      = 0.25;      // mm, folga do Gridfinity nos lados externos (padrao)
FOOT_H   = 4.75;      // mm, altura do pe Gridfinity (padrao)
FLOOR_TOP = 9;        // mm, topo do piso (E, define a espessura do piso)
H_TOTAL  = 49;        // mm, altura total, 7 unidades de 7 mm (E)
WALL     = 3;         // mm, espessura das paredes externas (E)
OV       = 0.1;       // mm, sobreposicao para virar um unico solido
CL       = 0.3;       // mm, folga do encaixe de cada lado, ja inclui espaco para cola (AJUSTE ESTE VALOR)

SLOT_BOT = 5.5;       // mm, fundo dos rasgos (acima do pe, que termina em 4,75)

// Chave borboleta: [largura do pescoco, largura da ponta, comprimento de cada lado]
KEY_F = [8, 14, 9];   // chave do piso
KEY_W = [5, 8, 6];    // chave da parede (menor, cabe no pilar)

PIL_X = 13;           // mm, largura do pilar de uniao da parede
PIL_Y = 9;            // mm, profundidade do pilar

SCOOP_HALF = 30;      // mm, meia largura do rebaixo frontal (total 60 na bandeja)
SCOOP_R    = 12;      // mm, raio da curva do rebaixo

$fn = 32;

// ---------- Pe Gridfinity ----------
// Quadrado com cantos arredondados, centralizado, em uma altura z
module slab(w, r, z) {
    translate([0, 0, z])
        linear_extrude(height = 0.01)
            offset(r = r) square(w - 2 * r, center = true);
}

// Perfil padrao: 35,6 -> 37,2 (0,8) -> 37,2 (1,8) -> 41,5 (2,15)
module foot() {
    hull() { slab(35.6, 0.8, 0); slab(37.2, 1.6, 0.8); }
    hull() { slab(37.2, 1.6, 0.8); slab(37.2, 1.6, 2.6); }
    hull() { slab(37.2, 1.6, 2.6); slab(41.5, 3.75, FOOT_H); }
}

// ---------- Chave borboleta (2D, pescoco na origem, eixo u para os dois lados) ----------
// cl = folga extra (0 para a chave, CL para o rasgo)
module key2d(k, cl = 0) {
    n = k[0] / 2 + cl;       // meio pescoco
    e = k[1] / 2 + cl;       // meia ponta
    d = k[2] + cl;           // comprimento de cada lado
    polygon([[-d, -e], [-d, e], [0, n], [d, e], [d, -e], [0, -n]]);
}

// Metade do rasgo: abre na face de uniao (u = 0) e entra na peca no sentido +u
module slot_half2d(k) {
    n = k[0] / 2 + CL;
    e = k[1] / 2 + CL;
    d = k[2] + CL;
    polygon([[-1, -n], [-1, n], [0, n], [d, e], [d, -e], [0, -n]]);
}

// Rasgo vertical em (x, y); ang gira o sentido de entrada (180 = entra para -x, -90 = entra para -y)
module slot(x, y, ang, k, z0 = SLOT_BOT) {
    translate([x, y, z0])
        linear_extrude(height = H_TOTAL + 1 - z0)
            rotate(ang) slot_half2d(k);
}

// ---------- Peca (quarto frontal esquerdo) ----------
SX = NX * U;   // face de uniao direita (x)
SY = NY * U;   // face de uniao traseira (y)

module corpo() {
    // piso, comeca dentro do pe (OV) e vai ate o topo do piso
    translate([TOL, TOL, FOOT_H - OV])
        cube([SX - TOL, SY - TOL, FLOOR_TOP - FOOT_H + OV]);
    // parede esquerda e parede frontal
    translate([TOL, TOL, FLOOR_TOP - OV])
        cube([WALL, SY - TOL, H_TOTAL - FLOOR_TOP + OV]);
    translate([TOL, TOL, FLOOR_TOP - OV])
        cube([SX - TOL, WALL, H_TOTAL - FLOOR_TOP + OV]);
    // pilar na ponta traseira da parede esquerda (recebe a chave da parede)
    translate([TOL, SY - PIL_Y, FLOOR_TOP - OV])
        cube([PIL_X, PIL_Y, H_TOTAL - FLOOR_TOP + OV]);
}

// Rebaixo na parede frontal para puxar as pastas (metade; a outra metade fica na peca vizinha)
module rebaixo() {
    // parte de baixo: fundo plano com o canto esquerdo arredondado
    hull() {
        translate([SX - SCOOP_HALF + SCOOP_R, -1, FLOOR_TOP + SCOOP_R])
            rotate([-90, 0, 0]) cylinder(r = SCOOP_R, h = WALL + 2);
        translate([SX - 1, -1, FLOOR_TOP]) cube([2, WALL + 2, SCOOP_R]);
    }
    // parte de cima: lado esquerdo reto ate o topo
    translate([SX - SCOOP_HALF, -1, FLOOR_TOP + SCOOP_R])
        cube([SCOOP_HALF + 1, WALL + 2, H_TOTAL]);
}

module rasgos() {
    // face direita (x = SX): duas chaves do piso, entram para -x
    for (y = [50, 126]) slot(SX, y, 180, KEY_F);
    // face traseira (y = SY): duas chaves do piso, entram para -y
    for (x = [35, 90]) slot(x, SY, -90, KEY_F);
    // chave da parede, no pilar
    slot(TOL + PIL_X / 2, SY, -90, KEY_W);
}

module peca() {
    difference() {
        union() {
            for (i = [0 : NX - 1], j = [0 : NY - 1])
                translate([U * (i + 0.5), U * (j + 0.5), 0]) foot();
            corpo();
        }
        rebaixo();
        rasgos();
    }
}

// ---------- Chaves (impressas deitadas, sem suporte) ----------
KEY_F_H = FLOOR_TOP - SLOT_BOT - 0.4;   // fica 0,4 mm abaixo do piso
KEY_W_H = H_TOTAL - SLOT_BOT - 0.5;     // fica 0,5 mm abaixo do topo

module chave_piso()   { linear_extrude(height = KEY_F_H) key2d(KEY_F); }
module chave_parede() { linear_extrude(height = KEY_W_H) key2d(KEY_W); }

// ---------- Visualizacao ----------
// Chaves de uma bandeja montada (posicao nos rasgos, z na altura de encaixe)
module chaves_montadas(dz = 0, ey = 0) {
    // ey = abertura entre as metades em y (so para a vista explodida)
    for (y = [50, 126]) translate([SX, y, SLOT_BOT + dz]) chave_piso();
    for (x = [35, 90]) translate([x, SY + ey / 2, SLOT_BOT + dz])
        rotate(90) chave_piso();
    translate([TOL + PIL_X / 2, SY + ey / 2, SLOT_BOT + dz]) rotate(90) chave_parede();
}

// Dois quartos esquerdos (frontal e traseiro), afastados em y, chaves suspensas
module explodida() {
    gap = 40;
    peca();
    translate([0, 2 * SY + gap, 0]) mirror([0, 1, 0]) peca();
    // chaves da face traseira e da parede (as do eixo x ficam fora desta vista)
    for (x = [35, 90]) translate([x, SY + gap / 2, SLOT_BOT + 30]) rotate(90) chave_piso();
    translate([TOL + PIL_X / 2, SY + gap / 2, SLOT_BOT + 30]) rotate(90) chave_parede();
}

// Pecas direita = espelho da esquerda (espelhada em x, apoiada em x = 0 a SX)
module peca_dir() { translate([SX, 0, 0]) mirror([1, 0, 0]) peca(); }
module peca_esq() { peca(); }

// Bandeja inteira 6 x 8, com chaves encaixadas.
// Frente: esq + dir. Fundo: as mesmas pecas giradas 180 graus (esq vira fundo-direita).
module montagem() {
    peca_esq();
    translate([2 * SX, 0, 0]) mirror([1, 0, 0]) peca();
    translate([2 * SX, 2 * SY, 0]) rotate(180) peca_esq();
    translate([0, 2 * SY, 0]) mirror([0, 1, 0]) peca();
    // chaves do piso entre esquerda e direita
    for (y = [50, 126, 2 * SY - 50, 2 * SY - 126])
        translate([SX, y, SLOT_BOT]) chave_piso();
    // chaves do piso entre frente e fundo (esquerda e direita)
    for (x = [35, 90, 2 * SX - 35, 2 * SX - 90])
        translate([x, SY, SLOT_BOT]) rotate(90) chave_piso();
    // chaves das paredes laterais
    for (x = [TOL + PIL_X / 2, 2 * SX - TOL - PIL_X / 2])
        translate([x, SY, SLOT_BOT]) rotate(90) chave_parede();
}

if (modo == "peca_esq") peca_esq();
else if (modo == "peca_dir") peca_dir();
else if (modo == "chave_piso") chave_piso();
else if (modo == "chave_parede") chave_parede();
else if (modo == "explodida") explodida();
else if (modo == "montagem") montagem();
