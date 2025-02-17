%% definitions and loads
fstart = 300;
fend = 400;

cd 'E:\DNS\m09final'
aux3 = load('mesh.mat');
nx = length(aux3.X); ny = length(aux3.Y); nz = length(aux3.Z);

%% start the loop 

for Flow= fstart:fend
    
    % load files 

    flowname = strcat(sprintf('flow_%010d.mat',Flow));
    flow = matfile(sprintf('flow_%010d.mat',Flow));
    [nx,ny,nz] = size(flow,'U');
    [nx,ny,nz] = size(flow,'V');
    [nx,ny,nz] = size(flow,'W');
   
    disp(flowname);
    if ~exist('flow','file')
        continue;
    end

    % checking if l2 and q, if not exist compute the derivatives

    if ~exist('l2','dir') && ~exist('q','dir') 

        U = flow.U;
        U(isnan(U)) = 0;
        V = flow.V;
        V(isnan(V)) = 0;
        W = flow.W;
        W(isnan(W)) = 0;
        
        [Uy, Ux, Uz] = gradient(U);
        [Vy, Vx, Vz] = gradient(V);
        [Wy, Wx, Wz] = gradient(W);
        
        Ux = Ux./gradient(aux3.X');
        Uy = Uy./gradient(aux3.Y);
        Uz = Uz./permute(gradient(aux3.Z),[1 3 2]);
        
        Vx = Vx./gradient(aux3.X');
        Vy = Vy./gradient(aux3.Y);
        Vz = Vz./permute(gradient(aux3.Z),[1 3 2]);
        
        Wx = Wx./gradient(aux3.X');
        Wy = Wy./gradient(aux3.Y);
        Wz = Wz./permute(gradient(aux3.Z),[1 3 2]);   

    end
        
    % check if exist L2 compute or append


    if exist('l2','dir')
        aux1 = load(strcat('l2-f',num2str(Flow),'.mat')); %colocar função que calcula L2
        L2 = aux1.omega;
    else
        % compute L2
        L2 = 0*U;
        
        for i = 60:size(U,1)
            for j = 1:size(U,2)-60
                if any(U(i,j,:)~=0)
                    for k = 1:size(U,3)
                        L2(i,j,k) = lambda2([Ux(i,j,k) Uy(i,j,k) Uz(i,j,k); Vx(i,j,k) Vy(i,j,k) Vz(i,j,k); Wx(i,j,k) Wy(i,j,k) Wz(i,j,k)]);
                        if L2(i,j,k) >= 0
                            L2(i,j,k) = NaN;
                        end
                    end
                end
            end
        end
        
    end
    
    % check if exist q compute or append
    
    if exist('q','dir')
        cd q;
        aux2 = load(strcat('q-f',num2str(Flow),'.mat')); %colocar função que calcula Q-criterium
        Q = aux2.omega;
        cd ..;
    else
       q = 0*U;
        qs = 0*U;
        
        S11 = Ux;
        S12 = 0.5*(Uy+Vx);
        S13 = 0.5*(Uz+Wx);
        S22 = Vy;
        S23 = 0.5*(Vz+Wy);
        S33 = Wz;
        Omga12 = 0.5*(Uy-Vx);
        Omga13 = 0.5*(Uz-Wx);
        Omga23 = 0.5*(Vz-Wy);
        
        
        
        for i = 60:size(U,1)
            for j = 1:size(U,2)-60
                if any(U(i,j,:)~=0)
                    for k = 1:size(U,3)
                        q(i,j,k) = qcrit(Omga12(i,j,k),Omga13(i,j,k),Omga23(i,j,k),S11(i,j,k),S22(i,j,k),S33(i,j,k),S12(i,j,k),S13(i,j,k),S23(i,j,k));
                        qs(i,j,k) = NaN;
                        if q(i,j,k) <= 0
                            qs(i,j,k) = q(i,j,k);
                            q(i,j,k) = NaN;
                        end
                    end
                end
            end
        end
        mq = max(max(max(q)));
        Q = q./mq;
    end
    
    %compute other important variables

    Dilatation = (Ux+Vy+Wz);
    
    
    aux3 = load('mesh.mat');
    gama = 1.4;
    X = aux3.X;
    Y = aux3.Y;
    Z = aux3.Z;
    wall = aux3.wall;
    flowParameters = aux3.flowParameters;
    flowType = aux3.flowType;
    P = 0.4.*flow.R.*flow.E;
    T = flow.E.*gama.*(gama-1).*(flowParameters.Ma.*flowParameters.Ma);
    [~,~,Vortk,~] = vorticidade(flow);
    Mach = (1/sqrt(gama.*(gama-1))).*flow.U./sqrt(flow.E);
    
    
    

    save(flowname,'L2','Q','Dilatation','P','T','Mach',"Vortk",'-append')
    clear flow aux1 aux2 L2 Q X dilatation U V W Ux Uy Vortk Uz Vx Vy Vz Wx Wy Wz mq q qs S11 S12 S13 S22 S23 S33 Omega12 Omega13 Omega23;
end



function [Vorti,Vortj,Vortk,Vort] = vorticidade(flow)

[Vorti,Vortj,Vortk] = curl(flow.U,flow.V,flow.W);
Vort = sqrt(Vorti.*Vorti + Vortj.*Vortj + Vortk.*Vortk);

end

function l2 = lambda2(J)
S = (J + J')/2;
O = (J - J')/2;

L = eig(S^2 + O^2);
l2 = real(L(2));
end

function q = qcrit(Omga12,Omga13,Omga23,S11,S22,S33,S12,S13,S23)
A = 2*(Omga12^2) + 2*(Omga13^2) + 2*(Omga23^2) - S11^2 - S22^2 - S33^2 - 2*(S12^2) - 2*(S13^2) - 2*(S23^2);
q = 0.5*A;
end