// Vasinho de plantas para maquete
// Orientacao de impressao: base plana na mesa (z = 0), sem suporte.
// Todas as medidas em mm. E = estimada (escala da maquete nao informada).

// ---------- Parametros ----------
altura        = 20;   // altura total do vaso (E)
diam_boca     = 18;   // diametro externo do aro superior (E)
diam_base     = 12;   // diametro externo da base (E)
altura_borda  = 3;    // altura do aro da borda (E)
folga_borda   = 1;    // quanto o aro sobressai alem da parede (E)
parede        = 1.2;  // espessura da parede do aro (multiplo de 0,4)
profund_terra = 2;    // distancia da terra ate o topo do aro
altura_monte  = 0.8;  // altura do montinho de terra
OV            = 0.1;  // sobreposicao entre partes (solido unico)
$fn           = 96;   // resolucao das curvas

// ---------- Modulos ----------

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

// Rebaixo raso no topo onde fica a terra (base fica maciça: sem pontes)
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

// ---------- Peca ----------
union() {
    difference() {
        union() { corpo(); borda(); }
        rebaixo();
    }
    monte();
}
