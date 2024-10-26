function [beta,omega,spec] = specCalc_zt(z,t,varFlow)

nm = length(t);
nk = length(z);
dzMean = mean(diff(z));
dtMean = mean(diff(t));

if sum(abs(diff(z)-dzMean))>=1e-6
    %fprintf('Warning! dz is not constant along interval... returning!\n');
    return
end

if sum(abs(diff(t)-dtMean))>=1e-6
    %fprintf('Warning! dt is not constant along interval... returning!\n');
    return
end

omega0 = 2*pi/(diff(t([1 end]))+dtMean);
beta0  = 2*pi/(diff(z([1 end]))+dzMean);

%fprintf('Spec-2d calc.\n')
%fprintf(' (Nm,Nk) = (%g, %g)     (omega0, beta0) = (%1.4f, %1.4f)\n',nm,nk,omega0,beta0)

m = -floor(nm/2):floor((nm-1)/2);
k = -floor(nk/2):floor((nk-1)/2);
omega = m*omega0;
beta  = k*beta0;
spec  = fft2(varFlow);
spec = fftshift(spec);



end