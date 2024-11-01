function [] = walllaw(xend,type)

%some types of definitions 

if nargin == 0
%     type = 'gif';
    type = 'png';
    xend = 500;
    xend = 800;
elseif nargin == 1
    xend = 500;
end

%find mean flow or calculate meanflow

if ~exist('flow_mean.mat','file')

    fi = input('fi \n');
    fe = input('fi \n');
    meanflow(fi,fe);
    
end



timeDelay = 0.5;
disp(' start plot surf ');
disp('load files');

%load parameters, mesh, meanflow

cd bin;

parameters;

cd ..;

load mesh
load flow_mean

%Variables

disp('load vars')
x1 = flowType.cav{1, 1}.x(1);
x2 = flowType.cav{1, 1}.x(2);
[~,indx2]=min(abs(X-x2));
idY = find(Y==0);
idx2 = find(X==x2);
idxend = find (X==xEnd);
mu = 1/flowParameters.Re;
nu = 1/flowParameters.Re;
Uinf = 1.0792;
Ue = 1;
Re = X(2:end).*Ue./nu;
[~,indY] = find(Y==0);
indY = indY+1;
U = mean(U,3);
R = mean(R,3);
dudy = diff4or(indY,U,Y);
Cfcalc = (mu*(dudy))./(0.5*R(:,indY)*(Uinf^2));
Cfturb = turbbl(Re);
Cflam = lambl(Re);


%%=========================================%%================
% calculate law of the wall

n= 0;
disp('start calc law of the wal')


if type == 'png'
    dtype = [280];
elseif type == 'gif'
    dtype = idx2:10:idxend;
end    
for indwall = dtype
    clc;
    ii = find(abs(X-indwall)==min(abs(X-indwall)),1);
    disp(strcat('progress : ',num2str((n/length(dtype))*100),'%'));
    n=n+1;
    jjj= 1;
    %Utal = ((meanDUDY(ii,idY+1)*mu)/meanR(ii,idY+1))^0.5;
    tau_wall = Cfcalc(ii).*0.5.*R(ii,indY)*(Uinf^2);
    Utal = (tau_wall/R(ii,idY))^0.5;
    %tau_wall_lami = Cflam(ii).*0.5*1*(Uinf^2);
    tau_wall_turb = Cfturb(ii).*0.5*1*(Uinf^2);
    %Utal_lami = (tau_wall_lami/1)^0.5;
    Utal_turb = (tau_wall_turb/1)^0.5;
    for jj = idY:160
        jjj = jjj+1;
        ymais(n,jjj) = ((Y(jj)/nu)*Utal);
        umais(n,jjj) = (U(ii,jj)/(1*Utal));
        %umais2(n,jjj) = (U(ii,jj)/(2*Utal));
        %(Utal)
        %ymaisturb(n,jjj) = ((Y(jj)/nu)*Utal_turb);
        %         ymaislami(n,jjj) = ((Y(jj)/nu)*Utal_lami);
        %umaisturb(n,jjj) = (U(ii,jj)/Utal_turb);
        %         umaislami(n,jjj) = (U(ii,jj)/Utal_lami);
    end
    idx = ii;
    if type == 'png'
        ny = size(Y);
        filenameprofile = strcat('logboundaryprofile_X=',num2str(X(ii)),'.png');
        
        semilogx(abs(ymais(n,:)),abs(umais(n,:)),'-');
        
       
        
        %semilogx(abs(ymais(n,1:10)),abs(ymais(n,1:10)),'o-');
%         plot([5 5],[0 50],'g-')
%         plot([30 30],[0 50],'g-')
%         plot([150 150],[0 50],'g-')
        annotation('arrow',[0.15 0.3],[0.8 0.8])
        annotation('textbox',[0.15 0.8 0.18 0.05],'String','Viscous Sublayer','LineStyle','none','FontSize',10)
        annotation('doublearrow',[0.3 0.5],[0.8 0.8])
        annotation('textbox',[0.3 0.8 0.2 0.05],'String','Buffer Layer','LineStyle','none','FontSize',10)
        annotation('doublearrow',[0.5 0.67],[0.8 0.8])
        annotation('textbox',[0.5 0.8 0.17 0.05],'String','Log-law region','LineStyle','none','FontSize',10)
        
        legend('Wall Law short cavity','Log Law','FontSize',12);
    elseif type == 'gif'
        gifn = strcat('law_of_the_wall','.gif');
        f = figure('visible', 'off');
        grid on;
        box on;
        semilogx(abs(ymais(n,:)),abs(umais(n,:)),'*-');
        hold on;
        xlabel ('Y+');
        ylabel ('U+');
        hold on;
        semilogx(abs(ymais(n,:)),((2.44*log(abs(ymais(n,:))))+5.45),'o-');
        semilogx(abs(ymais(n,1:15)),abs(ymais(n,1:15)),'o-');
        title(strcat('Boundary Layer Law of the wall ','X=',num2str(X(ii))));
        legend('loglaw calculado','turb teste','loglaw turbulento','loglaw laminar');
        % Capture the plot as an image
        frame = getframe(f);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        % Write to the GIF File
        if ii == 1
            imwrite(imind,cm,gifn,'gif', 'Loopcount',inf,'DelayTime',timeDelay);
        elseif ~exist(gifn)
            imwrite(imind,cm,gifn,'gif', 'Loopcount',inf,'DelayTime',timeDelay);
        else
            imwrite(imind,cm,gifn,'gif','WriteMode','append','DelayTime',timeDelay);
        end
        
        close(f);
    end     
end
end

%% functions

function diff4or = diff4or(index,U,Y)

diff4or = ((-25*U(:,index)+48*U(:,index+1)-36*U(:,index+2)+16*U(:,index+3)-3*U(:,index+4))/(12*Y(index)));

end

function Cfturb = turbbl(Rex)

Cfturb = [2*log10(Rex) - 0.65].^-2.3;

end

function Cflam = lambl(Rex)

Cflam = 0.664./sqrt(Rex);

end