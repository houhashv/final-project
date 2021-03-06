function gauss = setparmsdirect(gauss, mu, sigma)

% Set the Gaussian parameters
%
% function setparms(gauss, mu, sigma)
%  <mu> = M x 1 vector of means
%  <sigma> = M x M matrix  (covariance matrix)


if(nargin < 3)
  error('gaussian1.setparmsdirect(): requires 3 parameters');
end;

if(~(isa(gauss, 'gaussian1')))
  error('gaussian1.setparms(): wrong object');
end;

gauss = gaussian1(gauss);

parms = get(gauss, 'parms');


parms.mu = mu;
parms.sigma = sigma;

parms.ndim = size(mu,1);

parms.sigma_inverse = inv(sigma);
[v,d] = eig(sigma);
parms.A = v * sqrt(d);

% Gaussian normalization factor
parms.scale = 1/(((2 * pi).^(parms.ndim/2))*sqrt(det(parms.sigma)));

% Set the parameters for this object
gauss = set(gauss, 'parms', parms);

p = get(gauss, 'parms');
