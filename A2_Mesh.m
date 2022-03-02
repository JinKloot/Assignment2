clc; close all; clear all;
%Visualize meshing density and see effect.

%Jinseng Vanderkloot 
%101031534

mesh = 1:1:5; %increase mesh 5 times and see effect 
x0 = 1; %voltage at right side of area 
x1 = 0; %Voltage at left side of area
cur = zeros(size(mesh,2),1);
global Carea %Must declare global for both in and out of function 

for a = 1:size(mesh,2)
    %Size of area and box changes to increase mesh 
    nx = 75*a; % # of colums
    ny = 50*a; % # of rows
    
    xBox = 25*a; %Width of box 
    yBox = 15*a; %Length of box 

    V=A2_Function(nx, ny, xBox, yBox, a, x0, x1);
    Vmap = reshape(V, [ny, nx]);
    J = Carea'.*gradient(-Vmap);
    cur(a,1) = max(J,[],"all"); %look for highest value current in an area 

    figure('name', 'Voltage Solution')
    surf(Vmap');
end

figure('name', 'Max Current vs Mesh size');
plot(mesh,cur, 'r');
xlabel('Mesh size');
ylabel('Maximum Current Density (A/m^2)');
title('Max Current vs Mesh size');