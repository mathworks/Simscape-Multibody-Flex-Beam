function state_order = sm_flex_body_lib_lpar_getstateorder(b_h)
% This function returns the states within a flexible beam model in
% sequential order. This is used to plot the mode shapes. This function is
% called in the Mask Initialization function for the lumped parameter beam.

% Copyright 2014-2019 The MathWorks, Inc.

% Find all joints within flexible elements
u=find_system(b_h,'LookUnderMasks','on','FollowLinks','on','Name','Flex Joint');

% Get states in correct order
v=sort(u);

% Output order of states
state_order = v;


