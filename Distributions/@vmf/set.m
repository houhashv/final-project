%--------------------------------------------------------------------------
% Function: set(a, prop_name, val)
%
% Sets the specified property value of the specified object and returns the
% modified object. Valid property names include 'parms'. 
%
% param[in] a: An object.
% param[in] prop_name: A property name.
% param[in] val: The value of the specified property.
% param[out] a: A new object with the specified property value modified.
%--------------------------------------------------------------------------

function a = set(a, prop_name, val)

a = vmf(a); 

switch prop_name
    case 'parms'
        a.parms = val;
    case 'descriptor'
        error('vmf1.set(): Not allowed to change the descriptor');
    otherwise
        error(['vmf.set(): ', prop_name, ...
            ' is not a valid asset property']);
end 
