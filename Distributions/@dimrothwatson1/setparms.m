%--------------------------------------------------------------------------
% Function: setparms(dw1, scale, pts)
%
% Updates the parameters of the specified Dimroth-Watson distribution using
% pts and scale. The scale argument is optional and is the probability that
% each point in pts belongs to dw1. pts may have an arbitrary number of
% rows as long as dw1.parms.u has the same number of rows (although the 
% Dimroth-Watson distribution is designed for quaternions). scale should 
% have the same number of columns as pts.
%
% param[in] self: A Dimroth-Watson distribution object.
% param[in] pts: An M x N matrix (data set).
% param[in] scale: A 1 x N vector (weights of each data point in pts).
% param[out] a: A new Dimroth-Watson distribution object with updated
% parameters.
%--------------------------------------------------------------------------

function a = setparms(self,scale,pts) 
    % if less than 2 arguments are supplied
    if nargin < 2
        error('dimrothwatson1.setparms(): Requires 2 parameters');
    end

	if nargin < 3
		% Retrieve saved points.
		pts = optimized_points(self);
	else
		pts = optimized_points(self, pts);
	end

    [m,n] = size(pts); 
    a = dimrothwatson1(self); 
    parms = get(a,'parms'); 
    
    % if pts does not have the same number of rows as dw1.parms.u
    if(m ~= size(parms.u,1))
        error(['dimrothwatson1.setparms(): ', ...
            'pts must have the same number of rows as dw1.parms.u']);    
        
    % if scale does not have the same number as columns as pts
    elseif(size(scale,2) ~= n) 
        error(['dimrothwatson1.setparms(): ', ...
            'scale must have the same number of columns as pts']); 
        
    % if a small number of points belongs to this distribution return to
    % avoid numerical issues (k could be set to a very large value)
    elseif(sum(isnan(scale)) > 0 | mean(scale) < .01)
        return;
    end;     
       
    % update the parameters of dw1 and return it
    u = mle_of_u(pts,scale);  
    k = mle_of_k(u,pts,scale);    
    
    parms.u = u;    
    parms.k = k;
    parms.ndim = m;
    a = set(a,'parms',parms); 
end

%--------------------------------------------------------------------------
% Function: mle_of_u(X, scale)
%
% Calculates the maximum likelyhood estimate of u given the data set X. X 
% is an M x N matrix where each column of X is a data point.
%
% param[in] X: An M x N matrix.
% param[in] scale: A 1 x N vector (weights of each data point in X).
% param[out] u: The maximum likelyhood estimate of u given X.
%--------------------------------------------------------------------------

function u = mle_of_u(X, scale)   
    wpts = X .* (ones(size(X,1),1) * scale);
    lambda = (wpts * X') / sum(scale);      
    
    % Get the eigenvectors and eigenvalues of lambda
    [V,D] = eig(lambda);
    
    % Put the eigenvalues of lambda into a vector
    d = diag(D);

    % Sort the eigenvalues in descending order
    [dvals, delems] = sort(d, 'descend');

    % Get the first eigenvector
    u = V(:, delems(1));       
end

%--------------------------------------------------------------------------
% Function: mle_of_k(u, X, scale)
%
% Calculates the maximum likelihood estimate of k given u and X. X is 
% assumed to be an M x N matrix where each column of X is a data point.
%
% param[in] u: The u parameter of a Dimroth-Watson distribution object.
% param[in] X: An M x N matrix (data set).
% param[in] scale: A 1 x N vector (weights of each data point in X). 
% param[out] k: The maximum likelihood estimate of k.
%--------------------------------------------------------------------------

function k = mle_of_k(u, X, scale)
    temp = scale * ((X' * u).^2);
    rhs = -(sum(temp) / sum(scale)) + 1;    

    % replace 0's in rhs with realmin so log(rhs) will not contain -inf
    elems = find(rhs == 0);
    rhs(elems) = realmin;

    x = [1.9090   -3.4599    1.6376];
    k = x(1) - x(2) * log(rhs) .* log(x(3) * (rhs));
end