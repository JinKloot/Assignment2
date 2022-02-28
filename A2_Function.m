%I tried 
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
% In area, place boxes with new conduction
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
            F(n,1) = 1;
        elseif i == nx %Right Boundary V=Vo
            G(n,n) = 1;
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
figure('name', 'Solution')
surf(Vmap');

figure('name', 'Quiver')
[Ex,Ey] = gradient(Vmap);
quiver(-Ex,-Ey,1);