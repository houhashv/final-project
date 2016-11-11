function self = subsasgn(self, index, val)

if length(index) > 1
	% Pass it down recursively (and why does MATLAB work this way?).
	sub = subsref(self, index(1));
	sub = subsasgn(sub, index(2:end), val);
	self = subsasgn(self, index(1), sub);
elseif index.type == '.'
	switch index.subs
	case 'parms'
		self.parms = val;
	case 'points'
		self.points = val;
		% TODO Set points in subdists, but this is done in initEM right now.
	otherwise
		error('Invalid field name')
	end
else
	error('only .field supported')
end
