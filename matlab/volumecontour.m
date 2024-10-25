function h = volumecontour(x,y,z,V,n,vmin,vmax)

flip = 1;

V = permute(V,[2 1 3]);

alpha = 0.5;

if nargin == 4
    n = 5;
end

if length(n) > 1
    levels = n;
    n = length(n);
    %vmin = levels(1);
    %vmax = levels(end);
else
    if nargin < 7
        vmin = min(V(:));
        vmax = max(V(:));
    end
    levels = linspace(vmin,vmax,n+2);
    levels = levels(2:end-1);
end

colors = parula(n);

hold on
for i = 1:n
    if flip == 0
        fv = isosurface(x,y,z,V,levels(i));
    else
        fv = isosurface(x,z,y,permute(V,[3 2 1]),levels(i));
    end
    
    if nargout == 1
        h{i} = patch(fv,'FaceColor',colors(i,:),'FaceAlpha',alpha,'EdgeColor','none');
    else
        patch(fv,'FaceColor',colors(i,:),'FaceAlpha',alpha,'EdgeColor','none');
    end
end
