clear;
close all;

load('flow_0000000100.mat');
load('mesh.mat');


figure
pcolor(X,Y,U');
shading interp;
hold on;
xlabel('X');
ylabel('Y');
title('U(x,y)')
xlim([0 500]);
ylim([-10 20]);