function lastprob = fftanalisetemporal(var,lastprob)
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

if nargin == 0  
   [~,lastprob] = size(log.U);
%    lastprob = 96;
   var = 'U';
   %stepstart = 1;
   [~,stepstart] = min(abs(log.t(:)-0));
   [~,stepend] = min(abs(log.t(:)-4355));
elseif nargin == 1
    [~,lastprob] = size(log.U);
    [~,stepstart] = min(abs(log.t(:)-2000));
    [~,stepend] = min(abs(log.t(:)-4000));
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
    
    %variable = zeros(L,lastprob);
    %fourier = zeros(L,lastprob);
    %P2 = zeros(L,lastprob);
    %P1 = zeros(l2+1,lastprob);
    
    Namostra = length(log.U(stepstart:stepend,1));
    windowsize = floor(Namostra/5);
    windowoverlap = floor(windowsize/5);
    
    P1 = zeros(windowsize*0.5+1,lastprob);
    fp1 = zeros(windowsize*0.5+1,lastprob);
    
    
    for ii = 1:lastprob
    % for ii = 4:lastprob   
        variable = file(stepstart:stepend,ii)-mean(file(stepstart:stepend,ii));
        %fourier(:,ii) =  fft(variable(:,ii));
        [S,f,~] =  spectrogram(variable,hamming(windowsize),windowoverlap,windowsize,Fs);
        %P2(:,ii) = abs(fourier(:,ii)/L);
        %P1(:,ii) = P2(1:l2+1,ii);
        %P1(2:end-1,ii) = 2*P1(2:end-1,ii);
        s = mean(abs(S/(windowsize*0.5)),2);
        P1(:,ii) = s;
        fp1(:,ii) = f;
    end
    
    name = strcat('spectogramvar',var);
    
    
    cd fft;
    
    save(name);
    cd ..;
    %figure;
    semilogy(fp1(:,:),P1(:,:));
end