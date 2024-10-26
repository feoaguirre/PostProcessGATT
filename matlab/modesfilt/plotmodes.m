clear, 
cd 'E:\DNS\new\m05-FINAL';

load('vortktest.mat')
Vortk = vortksteps;
Re  = 734;
Ma  = 0.5;
D = 6.11;
L   = 2*D;
% iso_value3 = 0.001;
% iso_value4 = 0.001;
iso_value3 = 0.002;
iso_value4 = 0.002;
linColV = lines(10);
figure('units','normalized','outerposition',[0 0 1 1],'Visible','on'); clf;
ax(1) = gca; grid on; box on;

mz = mz(141:160,:,:);
my = my(141:160,:,:);
mx = mx(141:160,:,:);
wall = wall(141:160,:,:);

for ii = 1:1

    ax(ii).BoxStyle = 'full'; %#ok<*SAGROW>
    ax(ii).XLim = xStations([1 end]);
    ax(ii).YLim = yStations([1 end]);
    ax(ii).ZLim = Z([141 end]);
    ax(ii).XTick = xStations(1):2*L:xStations(end);
    ax(ii).XTickLabel = fix([xStations(1):2*L:xStations(end)]); %#ok<*NBRAK>
    ax(ii).YTick = -D:0.5*D:D;
    ax(ii).YTickLabel = {'-D','-0.5D','0','0.5D','D'};
    ax(ii).ZTick = [Z(141) Z(end)];
    ax(ii).ZTickLabel = [Z(141) Z(end)];
    ax(ii).FontSize = 20;
    ax(ii).XLabel.String = '$x$';
    ax(ii).YLabel.String = '$y$';
    ax(ii).ZLabel.String = '$z$';
end

for tt = 1:length(Vortk(:,1,1,1))
    clc
    disp(strcat('plot', num2str(tt), 'from', num2str(steps(end)-steps(1))));
    if tt == 1       
        pWall4 = patch(ax(1),isosurface(mx,my,mz,wall,0)); %descomentar qndo for rodar full
        set(pWall4,'FaceColor',[1 1 1]*0,'EdgeColor','none','facealpha',0.4); %descomentar qndo for rodar full
    else
        delete(p32);%descomentar qndo for rodar full
        delete(p42);%descomentar qndo for rodar full
        delete(h3);%descomentar qndo for rodar full
    end
    varAux = squeeze(Vortk(tt,:,:,141:160));
    varAux = permute(varAux,[3 2 1]);
    p32 = patch(ax(1),isosurface(mx,my,mz,varAux,-iso_value3));
    set(p32,'FaceColor',linColV(1,:),'EdgeColor','none','facealpha',0.8);
    p42 = patch(ax(1),isosurface(mx,my,mz,varAux, iso_value4));
    set(p42,'FaceColor',linColV(2,:),'EdgeColor','none','facealpha',0.8);
    daspect(ax(1),[4,2,0.7])
    h3 = camlight(ax(1));
    lightangle(h3,-235,-60);
    lighting(ax(1),'gouraud');
    view(ax(1),[-130 50])
    if  tt ==1
        camroll(ax(1),235);
    end
    pause(0.5);
    print(['/home/felipe/autolst/m05-FINAL/figs/rossiter_band/Vortkstep_',num2str(steps(tt),'%04.0f'),'.png'],'-dpng');
end