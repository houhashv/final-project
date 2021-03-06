%--------------------------------------------------------------------------
% Function: setparms(self, scale, points)
%
% Updates the parameters of the specified composite distribution using points
% and scale. The scale argument is optional and is the probability that
% each point in points belongs to self. points must have self.parms.ndim rows. scale
% should have the same number of columns as points.
%
% param[in] self: A composite distribution object.
% param[in] points: A struct of data sets.
% param[in] scale: A 1 x N vector (weights of each data point in points).
% param[out] a: A new composite distribution object with updated parameters.
%--------------------------------------------------------------------------

function a = setparms(self, scale, points)
	% if less than 2 arguments are supplied
	if nargin < 2
		error('composite.setparms(): Requires 2 parameters');
	end;

	if nargin < 3
		% Get prestored points.
		points = optimized_points(self);
	end

	n = size(points, 2);
	a = comp(self);
	cparms = get(self, 'parms');

	% TODO This doesn't mean anything anymore with the points going abstract.
	% if points does not have self.parms.ndim rows
	%if(m ~= cparms.ndim)
	%	error(['composite.setparms(): ', ...
	%		'points must have self.parms.ndim rows']);

	% if scale does not have the same number as columns as points
	if size(scale, 2) ~= n
		error(['composite.setparms(): ', ...
			'scale must have the same number of columns as points']);
	end

	% set each distributions parameters
	for i = 1:cparms.N
		dist = cparms.dists{i}; % get the ith dist of the composite
		dparms = get(dist, 'parms'); % get the parameters of dist
		% Set the parameters of dist.
		if nargin < 3
			% No data passed in, so presume the subdists already have it, too.
            
			dist = setparms(dist, scale); 
        else
            if strcmp(class(dist),'gaussian1') && i==1
                dist=setparms(dist,scale,points(1:3,:));
            
            else
                
                if strcmp(class(dist),'dimrothwatson1') || strcmp(class(dist),'dimrothwatson2') || strcmp(class(dist),'vmf') 
                   dist = setparms(dist, scale, points(4:7,:));
                else
                    if strcmp(class(dist),'gaussian1') && i==2
                        dist=setparms(dist,scale,points(4:6,:));
                end
                
            end
			
		end
		cparms.dists{i} = dist;
	end

	a = set(a, 'parms', cparms);
end
