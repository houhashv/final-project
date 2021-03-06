%--------------------------------------------------------------------------
% Function: evaluate(self, qs)
%
% Evaluates the supplied Dimroth-Watson distribution using the query points 
% qs. qs should be a M x N matrix where M is the dimensionality of each 
% query point, and N is the number of query points. The u parameter of self
% should have the same number of rows as qs.
%
% param[in] self: A Dimroth-Watson distribution object.
% param[in] qs: An M x N matrix of query points.
% param[out] densities: A 1 x N vector of densities (one for each column of
% qs).
%--------------------------------------------------------------------------

function densities = evaluate(self, qs)
    % if self is not of the correct type
    if ~isa(self, 'dimrothwatson1')
        error('dimrothwatson1.evaluate(): Wrong object');
    end;

	if nargin < 2
		% Get prestored points.
		qs = optimized_points(self);
	else
		qs = optimized_points(self, qs);
	end

    m = size(qs,1);
    parms = get(self, 'parms');

    % if qs does not have the same number of rows as self.parms.u
    if(m ~= size(parms.u,1))
        error(['dimrothwatson1.evaluate(): ', ...
            'qs must have the same number or rows as dw1.parms.u']);
    end;

    u = parms.u;
    k = parms.k;  
    densities = estimate_F(k) * exp(k * ((qs' * u).^2))';
    if isreal(densities)==false
        display('here');
    end
end

%--------------------------------------------------------------------------
% Function: estimate_F(k)
%
% Estimates the value of the F(k) function for the specified value of k.
%
% param[in] k: The concentration parameter.
% param[out] out: The estimated value of F(k).
%--------------------------------------------------------------------------

function out = estimate_F(k)
    lim = 0;
    x = [0.1495    0.6049   -0.0994    0.8402];    
    out = x(1) .* exp(- x(2) .* k) + x(3) .* exp(- x(4) .* k) + lim;
end

