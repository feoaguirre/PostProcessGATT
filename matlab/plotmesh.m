function h = plotmesh(start)
    load('mesh.mat');
    cd bin;
    parameters;
    cd ..;
    
    if ~exist('mesh','dir')
        mkdir('mesh')
    end

    cd mesh;
    
    % full mesh %
    meshx = gradient(X);
    meshy = gradient(Y);
    meshz = gradient(Z);
    
    namex = ('meshxfull');
    namey = ('meshyfull');
    namez = ('meshzfull');
    
    f = figure('visible', 'off');
    title('mesh X full');
    plot(X,meshx)
    saveas(f, namex, 'fig');
    close(f);
    
    f = figure('visible', 'off');
    title('mesh Y full');
    plot(Y,meshy)
    saveas(f, namey, 'fig');
    close(f);
    
    f = figure('visible', 'off');
    title('mesh Z full');
    plot(Z,meshz)
    saveas(f, namez, 'fig');
    close(f);
    
    % gap mesh%
    namex = ('meshxgap');
    namey = ('meshygap');
    
    
    [~,indx1]=min(abs(X-x1));
    [~,indx2]=min(abs(X-x2));
    idy = find(Y==0);
    
    
    meshx = gradient(X(indx1:indx2));
    meshy = gradient(Y(1:idy));
    
    f = figure('visible', 'off');
    title('mesh X gap');
    plot(X(indx1:indx2),meshx)
    saveas(f, namex, 'fig');
    close(f);
    
    f = figure('visible', 'off');
    title('mesh Y gap');
    plot(Y(1:idy),meshy)
    saveas(f, namey, 'fig');
    close(f);
    
    % downstream mesh %
    
    namex = ('meshxdown');
    namey = ('meshydown');
    
    [~,indxend]=min(abs(X-xEnd));
    [~,indyend]=min(abs(Y-yEnd));
    
    meshx = gradient(X(indx2:indxend));
    meshy = gradient(Y(idy:indyend));
    
    f = figure('visible', 'off');
    title('mesh X gap');
    plot(X(indx2:indxend),meshx)
    saveas(f, namex, 'fig');
    close(f);
    
    f = figure('visible', 'off');
    title('mesh Y gap');
    plot(Y(idy:indyend),meshy)
    saveas(f, namey, 'fig');
    close(f);
    
    
    cd ..;
end