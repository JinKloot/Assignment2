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
        elseif i == nx %Right Boundary V=0
            G(n,n) = 1;
        elseif j == 1 %Bottom
            G(n,n) = -3;
            G(n,nxm) = 1;
            G(n,nxp) = 1;
            G(n,nyp) = 1;
        elseif j == ny %Top
            G(n,n) = -3;
            G(n,nxm) = 1;
            G(n,nxp) = 1;
            G(n,nym) = 1;
        else %Middle 
            G(n,n) = -4;
            G(n,nxm) = 1;
            G(n,nxp) = 1;
            G(n,nym) = 1;
            G(n,nyp) = 1;
        end
    end
end


figure('name', 'G Matrix');
spy(G);

V = G\F;
Vmap = reshape(V, [ny, nx]); % Reshaping Vector to a matrix
figure('name', 'Solution');
surf(Vmap'), title('Solution');

figure('name', 'Quiver');
[Ex,Ey] = gradient(Vmap);
quiver(-Ex,-Ey,1);