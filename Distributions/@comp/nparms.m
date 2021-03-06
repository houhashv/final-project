%--------------------------------------------------------------------------
% Function: nparms(c)
%
% Returns the number of parameters required for the specified composite
% distribution object.
%
% param[in] c: A composite distribution object.
% param[out] n: The number of parameters required for c.
%--------------------------------------------------------------------------

function n = nparms(c)

% if c is not of type composite
if(~(isa(c, 'comp')))
    error('composite.nparms(): Wrong object');
end;

n = 0;
parms = get(c,'parms');

% sum over the number of parms for each distribution in the composite
for i=1:parms.N
    n = n + nparms(parms.dists{i});
end;