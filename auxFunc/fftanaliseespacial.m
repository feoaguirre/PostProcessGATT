function lastprob = fftanaliseespacial(flowin,flowof,flowspace)

if nargin == 0
   flowspace = 1;
end
for var = ['U' 'V' 'W' 'E' 'R']
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
    L=length(log.U(:,1));
    l2 = round(L/2);
    Fs = 0.175;
    f = Fs*(0:l2)/L;
    
    disp('calc fft');
    
    variable = zeros(steps,lastprob);
    fourier = zeros(steps,lastprob);
    P2 = zeros(steps,lastprob);
    P1 = zeros(l2+1,lastprob);
    
    for ii = 1:lastprob
        variable(:,ii) = file(:,ii)-mean(file(:,ii));
        fourier(:,ii) =  fft(variable(:,ii));
        P2(:,ii) = abs(fourier(:,ii)/L);
        P1(:,ii) = P2(1:l2+1,ii);
        P1(2:end-1,ii) = 2*P1(2:end-1,ii);

    end
    
    name = strcat('fftvar',var);
    
    save(name);
    plot(f,P1(:,:));
end    
end