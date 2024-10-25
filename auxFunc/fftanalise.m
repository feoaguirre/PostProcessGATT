function [] = fftanalise(var,lastprob)
    disp('loading data');
    
    disp('LOAD LOGS');
    
    if ~exist('fft','dir')
       mkdir('fft'); 
    end
    
rawdata = importdata('log.txt');
data = rawdata.data;
log.t = data(:,3);
log.dt = data(:,4);
log.res = data(:,6:10);
log.U = data(:,11:5:end);
log.V = data(:,12:5:end);
log.W = data(:,13:5:end);
log.R = data(:,14:5:end);
log.E = data(:,15:5:end);
%tmax = max(log.t);


ts = 1; %tempo inicial
te = 1300; %tempo final

if nargin == 0
   [~,lastprob] = size(log.U);
   var = 'U';
%    stepstart = 1;
   [~,stepstart] = min(abs(log.t(:)-ts));
   [~,stepend] = min(abs(log.t(:)-te));
%    [stepend,~] = size(log.U);
elseif nargin == 1
    [~,lastprob] = size(log.U);
%     stepstart = 1;
    [~,stepstart] = min(abs(log.t(:)-ts));
    [~,stepend] = min(abs(log.t(:)-te));
%     [stepend,~] = size(log.U);
else nargin == 2
    [~,stepstart] = min(abs(log.t(:)-ts));
    [~,stepend] = min(abs(log.t(:)-te));
end    


    

if strcmp(var,'U')
    file = log.U;
elseif strcmp(var,'V')
    file = log.V;
elseif strcmp(var,'W')
    file = log.W;
elseif strcmp(var,'E')
    file = log.E;
elseif strcmp(var,'R')
    file = log.R;
end    



    L=length(log.U(stepstart:stepend,1));
    l2 = round(L/2);
    Fs = (length(log.U(stepstart:stepend,1)))/(log.t(stepend)-log.t(stepstart));
    df = 1/(log.t(stepend)-log.t(stepstart));
    f = (Fs*(0:l2)/L)*2*pi;
    
    disp('calc fft');
    
    variable = zeros(L,lastprob);
    fourier = zeros(L,lastprob);
    P2 = zeros(L,lastprob);
    P1 = zeros(l2+1,lastprob);
    
    for ii = 1:lastprob
        variable(:,ii) = file(stepstart:stepend,ii) - mean(file(stepstart:stepend,ii));
        fourier(:,ii) =  fft(variable(:,ii));
        P2(:,ii) = abs(fourier(:,ii)/L);
        P1(:,ii) = P2(1:l2+1,ii);
%         P1(:,ii) = P2(1:l2,ii);
        P1(2:end-1,ii) = 2*P1(2:end-1,ii);

    end
    
    name = strcat('fftvar',var);
    
    for i =1:lastprob
       legenda{i} = strcat('prob: ',num2str(i));
    end
    
    cd fft;
    ft = P1;
    save(name,'ft');
    cd ..;
    plot(f,ft(:,:));
    legend(legenda{:})
end