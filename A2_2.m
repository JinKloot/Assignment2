clc; close all; clear all;

%Jinseng Vanderkloot 
%101031534

%Simulation to test different parameter, Turn the common for loop into a
%function to be able to change the parameters for the report by calling the
%function. 

nx = 75; % # of colums
ny = 50; % # of rows
G = sparse(nx*ny,ny*nx);
F = zeros(nx*ny,1);

% Add bottleneck 
boxCond = 0.001;
Carea = ones(nx,ny); %set conduction area to 1
%Box dimensions 
xBox = 25; 
yBox = 15; 
x0 = 1;
x1 = 0;
% In area, place boxes with new conduction - Use array indexing suggested
% by TA from lab 1 to get rid of for loops and make code faster
Carea(nx/2 - xBox/2:nx/2 + yBox/2,1:yBox) = boxCond; %Bottom Box 
Carea(nx/2 - xBox/2:nx/2 + yBox/2,ny-yBox:ny) = boxCond; %Top Box


for i = 1:nx
    for j = 1:ny
        n = j + (i-1) * ny;     % middle
        nxm = j + (i-2) * ny;   % right
        nxp = j + i * ny;       % left
        nym = j-1 + (i-1) * ny; % top
        nyp = j+1 + (i-1) * ny; % down
        if i == 1 %Left Boundary V=Vo
            G(n,n) = 1;
            F(n,1) = x0;
        elseif i == nx %Right Boundary V=Vo
            G(n,n) = 1;
            F(n,1) = x1;
        elseif j == 1 %Bottom Boundary (Free)
            bxm = (Carea(i,j) + Carea(i-1,j)) / 2;
            bxp = (Carea(i,j) + Carea(i+1,j)) / 2;
            byp = (Carea(i,j) + Carea(i,j+1)) / 2;

            G(n,n) = -(bxm + bxp + byp);
            G(n,nxm) = bxm;
            G(n,nxp) = bxp;
            G(n,nyp) = byp;
        elseif j == ny %Top Boundary (Free)
            bxm = (Carea(i,j) + Carea(i-1,j)) / 2;
            bxp = (Carea(i,j) + Carea(i+1,j)) / 2;
            bym = (Carea(i,j) + Carea(i,j-1)) / 2;

            G(n,n) = -(bxm + bxp + bym);
            G(n,nxm) = bxm;
            G(n,nxp) = bxp;
            G(n,nym) = bym;
        else %Middle
            bxm = (Carea(i,j) + Carea(i-1,j)) / 2;
            bxp = (Carea(i,j) + Carea(i+1,j)) / 2;
            byp = (Carea(i,j) + Carea(i,j+1)) / 2;
            bym = (Carea(i,j) + Carea(i,j-1)) / 2;
            
            G(n,n) = -(bxm + bxp + bym + byp);
            G(n,nxm) = bxm;
            G(n,nxp) = bxp;
            G(n,nym) = bym;
            G(n,nyp) = byp;
        end
    end
end

figure('name', 'G Matrix')
spy(G);

V = G\F;
Vmap = reshape(V, [ny, nx]); % Reshaping Vector to a matrix
figure('name', 'Voltage Solution')
surf(Vmap'), view(2);

% Conductivity Map
figure('name', 'Conductivity Map');
surf(Carea), title('Conductivity Map');

% Electric Field
[Ex,Ey] = gradient(-Vmap);
figure('name', 'Electric Field');
quiver(Ex,Ey), title('Electric Field');

% Current Flow
Jx = Carea'.* Ex;
Jy = Carea'.* Ey;
figure('name', 'Current Flow');
quiver(Jx,Jy), title('Current Flow');


