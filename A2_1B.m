clc; close all; clear all;

nx = 75; % # of colums
ny = 50; % # of rows
G = sparse(nx*ny,ny*nx);
F = zeros(nx*ny,1);
for i = 1:nx
    for j = 1:ny
        n = j + (i-1) * ny;     % middle
        nxm = j + (i-2) * ny;   % right
        nxp = j + i * ny;       % left
        nym = j-1 + (i-1) * ny; % top
        nyp = j+1 + (i-1) * ny; % down
        if i == 1 %Left Boundary V=Vo
            G(n,n) = 1;
            F(n,1) = 1;
        elseif i == nx %Right Boundary V=Vo
            G(n,n) = 1;
            F(n,1) = 1;
        elseif j == 1 %Bottom Boundary V=0
            G(n,n) = 1;
            F(n,1) = 0;
        elseif j == ny %Top Boundary V=0
            G(n,n) = 1;
            F(n,1) = 0;
        else %Middle
            G(n,n) = -4;
            G(n,nxm) = 1;
            G(n,nxp) = 1;
            G(n,nym) = 1;
            G(n,nyp) = 1;
        end
    end
end

figure('name', 'G Matrix'), spy(G);

V = G\F;
Vmap = reshape(V, [ny, nx]); % Reshaping Vector to a matrix
figure('name', 'Solution'), surf(Vmap');

[Ex,Ey] = gradient(Vmap);
figure('name', 'Quiver'), quiver(-Ex,-Ey,1);


% Mathmatical Solution
L = 75;
W = 50;
a = L;
b = W/2;
x = linspace(-b, b, nx);
y = linspace(0, a, ny);
V2 = zeros(ny, nx);

figure('name', 'Equation Solution')
[X,Y] = meshgrid(x,y);
for n = 1:2:99 %1,3,5,7...99
    V2 = V2 + ( (1/n) * (cosh((n*pi*X)/a)/cosh((n*pi*b)/a)).* sin((n*pi*Y)/a) );
    surf(4/pi*V2'), title('Equation Solution');
    pause(0.01);
end

