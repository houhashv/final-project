function n = nparms(gauss)

% Return the number of parameters required for this model

if(~(isa(gauss, 'gaussian1')))
  error('gaussian.nparms(): wrong object');
end;

parms = gauss.parms;

% Means + covariance matrix
n = parms.ndim + parms.ndim * parms.ndim;



