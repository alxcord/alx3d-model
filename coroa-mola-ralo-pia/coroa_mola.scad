// Coroa-mola do ralo da pia Tramontina
//
// Peca de reposicao do anel plastico branco que ficava entre o cesto e a
// valvula. Encaixa no ralo, apoia o aro no fundo e as pontas dos dentes
// empurram o cesto para cima, mantendo a separacao que deixa a agua escoar
// pelos recortes em V.
//
// Os dentes se unem na base, entao a saia e um cone facetado continuo e os
// recortes so aparecem na metade de cima. Isso deixa a peca rigida.
//
// Medidas em milimetros. Origem: L = lida no paquimetro, E = estimada.

/* ---------------- MEDIDAS ---------------- */

d_ext    = 80;    // L  diametro externo do aro, igual ao do ralo
d_int    = 34;    // E  diametro no circulo das pontas dos dentes
subida   = 14;    // E  altura da ponta do dente em relacao ao aro
larg_aro = 3;     // E  largura da faixa lisa do aro
esp      = 2.4;   // E  espessura da chapa
n_dentes = 20;    // E  quantidade de dentes
larg_pta = 2.0;   // E  largura do dente na ponta
sobrep   = 1.12;  // E  sobreposicao na base: e o que solda um dente no outro

/* ---------------- CALCULADOS ---------------- */

$fn = 240;

r_ext  = d_ext / 2;             // raio externo do aro
r_base = r_ext - larg_aro;      // raio onde nasce o dente
r_pta  = d_int / 2;             // raio da ponta do dente
comp   = r_base - r_pta;        // comprimento do dente em planta
ang    = asin(subida / comp);   // inclinacao do dente para cima
passo  = 360 / n_dentes;        // passo angular entre dentes
w_base = 2 * r_base * sin(passo / 2) * sobrep;  // largura do dente na base

/* ---------------- MODELO ---------------- */

// Aro liso da borda: e a face que assenta na mesa de impressao.
module aro() {
    linear_extrude(height = esp)
        difference() {
            circle(r = r_ext);
            circle(r = r_base);
        }
}

// Um dente: trapezio deitado, inclinado para cima em torno do eixo Y.
module dente() {
    rotate([0, ang, 0])
        translate([0, 0, -esp / 2])
            linear_extrude(height = esp)
                polygon([
                    [0,      w_base / 2],
                    [0,     -w_base / 2],
                    [-comp, -larg_pta / 2],
                    [-comp,  larg_pta / 2]
                ]);
}

// Peca completa: aro mais a coroa de dentes.
module coroa_mola() {
    union() {
        aro();
        for (i = [0 : n_dentes - 1])
            rotate([0, 0, i * passo])
                translate([r_base, 0, esp / 2])
                    dente();
    }
}

coroa_mola();
