function out = evaluate(self, pts)

if ~isa(self, 'mixture')
	error('mixture.evaluate(): wrong object');
end;

if nargin < 2
	% Retrieve saved points.
	pts = optimized_points(self);
else
	pts = optimized_points(self, pts);
end

parms = self.parms;

out = zeros(1, size(pts, 2));

for i=1:parms.N
	if nargin < 2

		values = evaluate(parms.dists{i});
	else
		values = evaluate(parms.dists{i}, pts);
	end
	out = out + parms.scale(i) * values;
end;
