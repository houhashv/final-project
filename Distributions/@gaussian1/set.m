function self = set(self, prop_name, val)

% TODO Is this really needed?
self = gaussian1(self);

switch prop_name
	case 'descriptor'
		error('Not allowed to change the descriptor');
	case 'parms'
		self.parms = val;
	otherwise
		error([prop_name ' is not a valid asset property'])
end
