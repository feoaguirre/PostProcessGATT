function [xOut,yOut,zOut,tOut,varOut] = importFlowData(casePath,var,axLim,Steps)
NT = length(Steps);

meshFile = load([casePath,'mesh.mat']);
X = meshFile.X; NX = length(X);
Y = meshFile.Y; NY = length(Y);
Z = meshFile.Z; NZ = length(Z);

IX = find(abs(X-axLim(1))==min(abs(X-axLim(1))),1):find(abs(X-axLim(2))==min(abs(X-axLim(2))),1);
IY = find(abs(Y-axLim(3))==min(abs(Y-axLim(3))),1):find(abs(Y-axLim(4))==min(abs(Y-axLim(4))),1);
IZ = find(abs(Z-axLim(5))==min(abs(Z-axLim(5))),1):find(abs(Z-axLim(6))==min(abs(Z-axLim(6))),1);

IX = IX(IX>=1 & IX<=NX);
IY = IY(IY>=1 & IY<=NY);
IZ = IZ(IZ>=1 & IZ<=NZ);

x = X(IX); nx = length(x);
y = Y(IY); ny = length(y);
z = Z(IZ); nz = length(z);
nt = NT;

varOut = zeros(nx,ny,nz,nt);
tOut = zeros(1,nt);

for it = 1:NT
    disp(it/NT)
    flowData = matfile([casePath,'flow_',num2str(Steps(it),'%010.0f'),'.mat']);
    [NX,NY,NZ] = size(flowData,var);
    
    varOut(:,:,:,it) = flowData.(var)(IX,IY,IZ);
    tOut(it) = flowData.t;    
end

xOut = x;
yOut = y;
zOut = z;

end