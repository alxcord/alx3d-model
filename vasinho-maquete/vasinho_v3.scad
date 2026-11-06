// Vasinho de plantas para maquete (tema Caminito) - versao 3
// Planta densa que enche a abertura do vaso. O vaso termina plano no topo e a
// planta comeca exatamente nessa altura: so ha UMA troca de cor (em z = altura),
// o que reduz o filamento gasto na torre de purga.
// Orientacao: base do vaso plana na mesa (z = 0), sem suporte.
// Todas as medidas em mm. E = estimada (escala da maquete nao informada).

// Qual parte gerar: "conjunto", "vaso" (cor 1) ou "planta" (cor 2)
parte = "conjunto";

// ---------- Parametros do vaso ----------
altura        = 20;   // altura do vaso, topo plano (E)
diam_boca     = 18;   // diametro externo do aro superior (E)
diam_base     = 12;   // diametro externo da base (E)
altura_borda  = 3;    // altura do aro da borda (E)
folga_borda   = 1;    // quanto o aro sobressai alem da parede (E)

// ---------- Parametros da planta ----------
raio_copa     = 7.8;  // raio da copa na base (E), cabe dentro do aro
fator_altura  = 0.8;  // altura da copa / raio (0,8 -> copa de ~6 mm)
folha_raio    = 2.6;  // meio comprimento da folha (E)
folha_esp     = 0.22; // espessura da folha / raio (~1,1 mm)
n_flores      = 5;    // flores em volta da copa
flor_raio     = 1.6;  // raio da bolinha da flor
haste_diam    = 1.0;  // haste fina da flor (mais de 2 perimetros de 0,4)

$fn = 48;

// ---------- Vaso ----------

// Corpo conico do vaso (sem a borda)
module corpo() {
    cylinder(h = altura - altura_borda + 0.1,
             d1 = diam_base, d2 = diam_boca - 2 * folga_borda);
}

// Aro da borda no topo (fecha o vaso com topo plano)
module borda() {
    translate([0, 0, altura - altura_borda])
        cylinder(h = altura_borda, d = diam_boca);
}

module vaso() {
    union() { corpo(); borda(); }
}

// ---------- Planta ----------

// Copa: meia esfera achatada, sem balanco, imprime sem suporte
module copa() {
    translate([0, 0, altura])
        scale([1, 1, fator_altura]) sphere(r = raio_copa);
}

// Uma folha: elipsoide achatado inclinado para fora, centrado no anel
// raio: distancia do centro, alt: altura acima do topo do vaso, tilt: graus
module folha(raio, alt, tilt, ang) {
    rotate([0, 0, ang])
        translate([raio, 0, altura + alt])
            rotate([0, -tilt, 0])
                scale([1, 0.55, folha_esp]) sphere(r = folha_raio);
}

// Um anel de folhas em volta da copa
module anel(n, raio, alt, tilt, giro) {
    for (i = [0 : n - 1])
        folha(raio, alt, tilt, giro + i * 360 / n);
}

// Uma flor: haste saindo da copa e bolinha no topo
module flor(p0, p1) {
    hull() {
        translate(p0) sphere(d = haste_diam, $fn = 12);
        translate(p1) sphere(d = haste_diam, $fn = 12);
    }
    translate(p1) sphere(r = flor_raio);
}

module flores() {
    // uma flor no centro, mais alta
    flor([0, 0, altura + 4], [0, 0, altura + 8.5]);
    // flores em volta, entre as folhas
    for (i = [0 : n_flores - 1]) {
        a = 20 + i * 360 / n_flores;
        flor([3.6 * cos(a), 3.6 * sin(a), altura + 4],
             [4.2 * cos(a), 4.2 * sin(a), altura + 7]);
    }
}

module planta() {
    // corta tudo abaixo do topo do vaso: base plana, so encosta no vaso
    intersection() {
        union() {
            copa();
            // aneis na superficie da copa (z = fator_altura * sqrt(R^2 - r^2))
            anel(11, 6.2, 3.8, 25, 0);     // anel de baixo, mais aberto
            anel(8, 4.8, 5.1, 40, 15);     // anel do meio
            anel(5, 3.0, 5.9, 55, 30);     // anel de cima, mais fechado
            flores();
        }
        translate([0, 0, altura]) cylinder(h = 30, d = 40);
    }
}

// ---------- Saida ----------
if (parte == "vaso") vaso();
else if (parte == "planta") planta();
else { vaso(); planta(); }
