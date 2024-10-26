%%==================================BOUNDARY===LAYER=====CALC=======================%%

function [s] = cfcalc()



set(groot,'defaultTextinterpreter','latex');

%load parameters and files

cd bin;
parameters;
cd ..;
disp('load data')
load mesh
load flow_mean

% creating variables

xsize = length(X);
ysize = length(Y);
xendcav = flowType.cav{1, 1}.x(2);
xind_end = find(abs(X-xEnd)==min(abs(X-xEnd)),1);
Uinf = 1;
mu = 1/flowParameters.Re;
nu = 1/flowParameters.Re;
Ue = 1;

Re = X(2:end)*Ue./nu;
[~,indY] = find(Y==0);
indY = indY+1;
U = mean(U,3);
R = mean(R,3);

dudy = diff4or(indY,U,Y);
Cfcalc = (mu*(dudy))./(0.5*R(:,indY)*(Uinf^2));

Cfturb = turbbl(Re);
Cflam = lambl(Re);

%%====================================CF plot========================================%%

figure

hold on;
plot(X(2:end)-flowType.cav{1, 1}.x(2),Cfturb,'g');
hold on
plot(X(2:end)-flowType.cav{1, 1}.x(2),Cflam,'r');
plot(X(82:xind_end),Cfcalc(82:xind_end,:),'g-.');
xlim([200 500]);
ylim([0 0.007]);
title('$C_f$ comparison across the plate');
legend('turbulent C_f','laminar C_f','Trailing edge Large D','Leading edge Large D','C_f Large D');
grid on;
xlabel ('$X-X_{endgap}$');
ylabel ('$C_f$');


end

%% functions calculate

function  deltal = deltal(Rex,X)

deltal = (4.91.*X(2:end))./sqrt(Rex);

end 

function deltat = deltat(Rex,X)

deltat = (0.16.*X(2:end))./(Rex).^(1/7);

end

function Cfturb = turbbl(Rex)

Cfturb = [2*log10(Rex) - 0.65].^-2.3;

end

function Cflam = lambl(Rex)

Cflam = 0.664./sqrt(Rex);

end

function diff4or = diff4or(index,U,Y)

diff4or = ((-25*U(:,index)+48*U(:,index+1)-36*U(:,index+2)+16*U(:,index+3)-3*U(:,index+4))/(12*Y(index)));

end

function diff2or = diff2or(index,U,Y)

diff4or = ((-3*U(:,index)+4*U(:,index+1)-U(:,index+2))/(2*Y(index)));

end

function I = simpsons(f,a,b,n)
    n=numel(f)-1; h=(b-a)/n;
    I= h/3*(f(1)+2*sum(f(3:2:end-2))+4*sum(f(2:2:end))+f(end));
end

