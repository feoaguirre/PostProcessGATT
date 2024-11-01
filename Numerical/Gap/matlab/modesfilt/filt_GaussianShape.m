function [filt] = filt_GaussianShape(x,x0,xSpan,tol)
%fprintf(' Gaussian shape (tol at edges: %1.2f): (center,span) = (%1.2f, %1.2f)\n',tol,x0,xSpan)
var = -( xSpan^2 / 4)/log(tol);
filt = (exp( -((x-x0).^2)/var ) + exp( -((x+x0).^2)/var ))/2;
end