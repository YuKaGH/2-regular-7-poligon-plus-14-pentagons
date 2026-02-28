import three;
size(15cm);
currentprojection = perspective(5,5,5);

int n = 7;
real pi = 4*atan(1);
real a = pi/n; // π/7

real Rv = 1/(2*sin(a));
real L = 2*cos(a);
real y = L * sin(3a); // sin(3a)=sin(4a)
real h = sin(a);
real yE = y + h;

real cot3a = cos(3a)/sin(3a);
real cota = cos(a)/sin(a);
real cosTheta = cot3a * cota;
real sinTheta = sqrt(1 - cosTheta^2);

triple[] V, C, D, E;
V = new triple[n];
C = new triple[n];
D = new triple[n];
E = new triple[n];

for(int i=0; i<n; ++i) {
    real phi = 2*pi*i/n;
    V[i] = Rv * (cos(phi), sin(phi), 0);
    
    real psi = phi + a;
    triple u = (-sin(psi), cos(psi), 0);
    triple n_vec = (cos(psi), sin(psi), 0);
    
    real xC = L * cos(4a);
    real xD = 1 + L * cos(3a);
    C[i] = V[i] + xC * u + y * (cosTheta * n_vec + sinTheta * Z);
    D[i] = V[i] + xD * u + y * (cosTheta * n_vec + sinTheta * Z);
    E[i] = V[i] + 0.5 * u + yE * (cosTheta * n_vec + sinTheta * Z);
}

// Центр масс всех точек C и D (14 вершин)
triple O = (0,0,0);
for(int i=0; i<n; ++i) {
    O += C[i] + D[i];
}
O = O / (2*n);

// Отражённые вершины (верхняя часть) относительно O
triple[] V_ref, C_ref, D_ref, E_ref;
V_ref = new triple[n];
C_ref = new triple[n];
D_ref = new triple[n];
E_ref = new triple[n];
for(int i=0; i<n; ++i) {
    V_ref[i] = 2*O - V[i];
    C_ref[i] = 2*O - C[i];
    D_ref[i] = 2*O - D[i];
    E_ref[i] = 2*O - E[i];
}

// Вычисляем сдвиг по вертикали, чтобы уровнять z-координаты E0 и E'0
real dz = E[0].z - E_ref[0].z;

// Сдвигаем верхнюю часть вверх на dz/2
triple[] Vp, Cp, Dp, Ep;
Vp = new triple[n];
Cp = new triple[n];
Dp = new triple[n];
Ep = new triple[n];
for(int i=0; i<n; ++i) {
    Vp[i] = V_ref[i] + (0,0,dz/2);
    Cp[i] = C_ref[i] + (0,0,dz/2);
    Dp[i] = D_ref[i] + (0,0,dz/2);
    Ep[i] = E_ref[i] + (0,0,dz/2);
}

// Функция для рисования грани
void drawFace(triple[] pts, pen contourPen=blue+0.8bp, pen fillPen=lightblue+opacity(0.3)) {
    path3 g = pts[0];
    for(int i=1; i<pts.length; ++i) g = g -- pts[i];
    g = g -- cycle;
    draw(g, contourPen);
    surface s = surface(g);
    draw(s, fillPen);
}

// Нижний семиугольник
drawFace(V, blue+1.2bp, lightblue+opacity(0.2));

// Верхний семиугольник
drawFace(Vp, blue+1.2bp, lightblue+opacity(0.2));

// Нижние пятиугольники
for(int i=0; i<n; ++i) {
    int ip1 = (i+1) % n;
    triple[] pent = {V[i], V[ip1], D[i], E[i], C[i]};
    drawFace(pent, blue+0.8bp, lightblue+opacity(0.3));
}

// Верхние пятиугольники
for(int i=0; i<n; ++i) {
    int ip1 = (i+1) % n;
    triple[] pent = {Vp[i], Vp[ip1], Dp[i], Ep[i], Cp[i]};
    drawFace(pent, blue+0.8bp, lightblue+opacity(0.3));
}

// Опционально: точки и подписи
dot(V, blue);
dot(Vp, blue);
dot(C, red);
dot(D, red);
dot(E, green);
dot(Cp, red);
dot(Dp, red);
dot(Ep, green);
