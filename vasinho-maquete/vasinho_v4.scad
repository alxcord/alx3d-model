// Vasinho de plantas para maquete (tema Caminito) - versao 4
// Proporcional a um poste de rua de 31 x 31 x 70 mm (escala ~1:65, poste de ~4,5 m).
// Vaso real de ~38 cm -> ~6 mm. Planta simplificada: sem hastes nem folhas finas,
// porque detalhes abaixo de ~0,5 mm nao imprimem com bico de 0,4.
// So ha UMA troca de cor, em z = altura (vaso termina plano, planta comeca ali).
// Orientacao: base do vaso plana na mesa (z = 0), sem suporte.
// Todas as medidas em mm. E = estimada (escala assumida).

// Qual parte gerar: "conjunto", "vaso" (cor 1) ou "planta" (cor 2)
parte = "conjunto";

// ---------- Parametros do vaso ----------
altura        = 6;     // altura do vaso, topo plano (E)
diam_boca     = 6.4;   // diametro externo do aro superior (E)
diam_base     = 4.2;   // diametro externo da base (E)
altura_borda  = 1.0;   // altura do aro da borda (E)
folga_borda   = 0.3;   // quanto o aro sobressai alem da parede (E)

// ---------- Parametros da planta ----------
raio_copa     = 2.9;   // raio da copa na base, cabe dentro do aro (E)
fator_altura  = 0.85;  // altura da copa / raio (copa de ~2,5 mm)
folha_raio    = 1.0;   // meio comprimento da folha (E)
folha_esp     = 0.6;   // espessura da folha / raio (~1,2 mm no total)
flor_raio     = 0.55;  // raio da bolinha da flor (diametro 1,1 mm)

$fn = 32;

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

// Uma folha: elipsoide inclinado para fora, centrado no anel
// raio: distancia do centro, alt: altura acima do topo do vaso, tilt: graus
module folha(raio, alt, tilt, ang) {
    rotate([0, 0, ang])
        translate([raio, 0, altura + alt])
            rotate([0, -tilt, 0])
                scale([1, 0.7, folha_esp]) sphere(r = folha_raio);
}

// Um anel de folhas em volta da copa
module anel(n, raio, alt, tilt, giro) {
    for (i = [0 : n - 1])
        folha(raio, alt, tilt, giro + i * 360 / n);
}

// Flores: bolinhas apoiadas direto na copa (sem haste)
module flores() {
    translate([0, 0, altura + 2.6]) sphere(r = flor_raio);
    for (i = [0 : 3]) {
        a = 70 + i * 90;
        translate([1.5 * cos(a), 1.5 * sin(a), altura + 2.3]) sphere(r = flor_raio);
    }
}

module planta() {
    // corta tudo abaixo do topo do vaso: base plana, so encosta no vaso
    intersection() {
        union() {
            copa();
            // aneis na superficie da copa (z = fator_altura * sqrt(R^2 - r^2))
            anel(7, 2.1, 1.7, 25, 0);      // anel de baixo, mais aberto
            anel(4, 1.0, 2.3, 45, 25);     // anel de cima, mais fechado
            flores();
        }
        translate([0, 0, altura]) cylinder(h = 10, d = 20);
    }
}

// ---------- Saida ----------
if (parte == "vaso") vaso();
else if (parte == "planta") planta();
else { vaso(); planta(); }
