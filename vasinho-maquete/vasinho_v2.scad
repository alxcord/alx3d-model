// Vasinho de plantas para maquete (tema Caminito) - versao 2
// Vaso + planta tipo geranio, em dois corpos para impressao em duas cores.
// Orientacao: base do vaso plana na mesa (z = 0), sem suporte.
// Todas as medidas em mm. E = estimada (escala da maquete nao informada).

// Qual parte gerar: "conjunto", "vaso" (cor 1) ou "planta" (cor 2)
parte = "conjunto";

// ---------- Parametros do vaso (iguais a v1) ----------
altura        = 20;   // altura total do vaso (E)
diam_boca     = 18;   // diametro externo do aro superior (E)
diam_base     = 12;   // diametro externo da base (E)
altura_borda  = 3;    // altura do aro da borda (E)
folga_borda   = 1;    // quanto o aro sobressai alem da parede (E)
parede        = 1.2;  // espessura da parede do aro (multiplo de 0,4)
profund_terra = 2;    // distancia da terra ate o topo do aro
altura_monte  = 0.8;  // altura do montinho de terra
OV            = 0.1;  // sobreposicao entre partes (solido unico)

// ---------- Parametros da planta ----------
afunda        = 0.5;  // quanto o caule entra na terra (E)
diam_caule    = 2.4;  // caule central, onde as folhas se prendem
folha_raio    = 3.2;  // meio comprimento da folha
folha_esp     = 0.18; // espessura da folha / raio (0,18 -> ~1,2 mm)
n_folhas_baixo= 7;    // folhas da camada de baixo
n_folhas_alto = 5;    // folhas da camada de cima
n_flores      = 3;    // flores
flor_raio     = 1.7;  // raio da bolinha da flor
haste_diam    = 0.9;  // haste fina da flor (acima de 2 perimetros de 0,4)

$fn = 48;

// ---------- Vaso ----------

// Corpo conico do vaso (sem a borda)
module corpo() {
    cylinder(h = altura - altura_borda + OV,
             d1 = diam_base, d2 = diam_boca - 2 * folga_borda);
}

// Aro da borda no topo
module borda() {
    translate([0, 0, altura - altura_borda])
        cylinder(h = altura_borda, d = diam_boca);
}

// Rebaixo raso no topo onde fica a terra
module rebaixo() {
    translate([0, 0, altura - profund_terra])
        cylinder(h = profund_terra + 1, d = diam_boca - 2 * parede);
}

// Montinho de terra sobre o fundo do rebaixo
module monte() {
    d = diam_boca - 2 * parede;
    translate([0, 0, altura - profund_terra - OV])
        cylinder(h = altura_monte + OV, d1 = d - 0.5, d2 = d - 5);
}

module vaso() {
    union() {
        difference() {
            union() { corpo(); borda(); }
            rebaixo();
        }
        monte();
    }
}

// ---------- Planta ----------

// Altura do topo do montinho (onde a planta nasce)
zt = altura - profund_terra + altura_monte;

// Uma folha: elipsoide achatado inclinado para fora
// altura_z: onde nasce no caule, tilt: inclinacao em graus, ang: giro
module folha(altura_z, tilt, ang) {
    rotate([0, 0, ang])
        translate([0, 0, zt + altura_z])
            rotate([0, -tilt, 0])
                translate([folha_raio, 0, 0])
                    scale([1, 0.55, folha_esp]) sphere(r = folha_raio);
}

// Uma flor: haste fina saindo do caule e bolinha no topo
module flor(ang) {
    p0 = [0, 0, zt + 2];
    p1 = [3 * cos(ang), 3 * sin(ang), zt + 8];
    hull() {
        translate(p0) sphere(d = haste_diam, $fn = 12);
        translate(p1) sphere(d = haste_diam, $fn = 12);
    }
    translate(p1) sphere(r = flor_raio);
}

module planta() {
    // caule central entrando na terra
    translate([0, 0, zt - afunda])
        cylinder(h = 4 + afunda, d = diam_caule);
    // camada de folhas de baixo (mais abertas)
    for (i = [0 : n_folhas_baixo - 1])
        folha(1.0, 35, i * 360 / n_folhas_baixo);
    // camada de folhas de cima (mais fechadas, giradas entre as de baixo)
    for (i = [0 : n_folhas_alto - 1])
        folha(2.5, 65, 20 + i * 360 / n_folhas_alto);
    // flores entre as folhas de cima
    for (i = [0 : n_flores - 1])
        flor(55 + i * 360 / n_flores);
}

// ---------- Saida ----------
if (parte == "vaso")
    // tira da terra o que a planta ocupa, para os dois corpos so se encostarem
    difference() { vaso(); planta(); }
else if (parte == "planta")
    planta();
else {
    difference() { vaso(); planta(); }
    planta();
}
