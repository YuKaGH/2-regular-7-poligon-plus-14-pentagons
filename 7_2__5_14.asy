import three;
size(15cm);
currentprojection = perspective(5,5,5);

int n = 7;
real pi = 4*atan(1);
real a = pi/n; // π/7

real Rv = 1/(2*sin(a));
real L = 2*cos(a);
real y = L * sin(3a);          // sin(3a) = sin(4a)
real h = sin(a);
real yE = y + h;

real cot3a = cos(3a)/sin(3a);
real cota  = cos(a)/sin(a);
real cosTheta = cot3a * cota;
real sinTheta = sqrt(1 - cosTheta^2);

triple[] V, C, E;
V = new triple[n];
C = new triple[n];
E = new triple[n];

for(int i=0; i<n; ++i) {
    real phi = 2*pi*i/n;
    V[i] = Rv * (cos(phi), sin(phi), 0);   
    real psi = phi + a;
    triple u = (-sin(psi), cos(psi), 0);       // вдоль стороны
    triple n_vec = (cos(psi), sin(psi), 0);    // наружу в плоскости основания
    
    real xC = L * cos(4a);                     // отрицательно
    real xD = 1 + L * cos(3a);                 // положительно
    C[i] = V[i] + xC * u + y * (cosTheta * n_vec + sinTheta * Z);
    E[i] = V[i] + 0.5 * u + yE * (cosTheta * n_vec + sinTheta * Z);
}

// Центр масс всех точек пояса (C и E) – 14 вершин
triple O = (0,0,0);
for(int i=0; i<n; ++i) {
    O += C[i] + E[i];
}
O = O / (2*n);

// Верхний семиугольник – отражение нижнего относительно O
triple[] Vp;
Vp = new triple[n];
for(int i=0; i<n; ++i) {
    Vp[i] = 2*O - V[i];
}

// ---- Функция для рисования грани с заливкой и контуром ----
void drawFace(triple[] pts, pen contourPen=blue+0.8bp, pen fillPen=lightblue+opacity(0.3)) {
    path3 g = pts[0];
    for(int i=1; i<pts.length; ++i) g = g -- pts[i];
    g = g -- cycle;
    draw(g, contourPen);
    surface s = surface(g);
    draw(s, fillPen);
}

// ---- Рисуем все грани ----

// Нижний семиугольник
drawFace(V, blue+1.2bp, lightblue+opacity(0.2));

// Верхний семиугольник
drawFace(Vp, blue+1.2bp, lightblue+opacity(0.2));

// Нижние пятиугольники (7 штук)
for(int i=0; i<n; ++i) {
    int ip1 = (i+1) % n;
    triple[] pent = {V[i], V[ip1], C[(i+1) % n], E[i], C[i]};
    drawFace(pent, blue+0.8bp, lightblue+opacity(0.3));
}

// Верхние пятиугольники (7 штук) – используют те же C, D, E
for(int i=0; i<n; ++i) {
    int ip1 = (i+1) % n;
    triple[] pent = {Vp[i], Vp[ip1], E[(i+4) % n], C[(i+4) % n], E[(i+3) % n]};
    drawFace(pent, blue+0.8bp, lightblue+opacity(0.3));
}

// ---- Подписи (опционально) ----
//label("$V_0$", V[0], S);
//label("$C_0$", C[0], S);
//label("$E_0$", E[0], N);
//label("$C_1$", C[1],N);
//label("$C_2$", C[2], S);
//label("$C_3$", C[3], S);
//label("$V_1$", V[1], S);
//label("$E_1$", E[1], N);
//label("$Vp_5$", Vp[5], S);

// Точки для наглядности (можно убрать)
dot(V, green);
dot(Vp, green);
dot(C, green);
dot(E, green);
dot(O, red);
