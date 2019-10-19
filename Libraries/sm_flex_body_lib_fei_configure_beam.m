function [Nf, frameBody, frameGraphic] = sm_flex_body_lib_fei_configure_beam(blk_h,splitBodyProps)
% This function configures the FE import beam.  It sets the properties of
% the rigid bodies according to the settings from the user interface, and
% configures the degrees of freedom associated with the interface frames.

% Copyright 2014-2019 The MathWorks, Inc.

% Determine number of frames
frames_h = find_system(blk_h,'LookUnderMasks','all','FollowLinks','on','SearchDepth',1,'regexp','on','Variant','on','Name','Frame.*');
Nf = length(frames_h);

% Set properties in Solid block representing single rigid body
% Set file name
blk_rb = [blk_h '/Rigid Body'];
rigid_body_filename = get_param(blk_h,'rigid_body_filename');
rigid_body_filename = rigid_body_filename(2:end-1);
set_param(blk_rb, 'ExtGeomFileName', rigid_body_filename);

if(verLessThan('matlab','9.7'))
    if(strcmpi(rigid_body_filename(end-2:end),'stl'))
        set_param(blk_rb, 'ExtGeomFileType', 'STL');
    else
        set_param(blk_rb, 'ExtGeomFileType', 'STEP');
    end
end

% Check configuration for mass distribution
piecesBody = strcmpi(get_param(blk_h,'popup_massdistr'),'Per Interface Frame');
if piecesBody
    % If mass should be associated with interface frames
    % set mass properties of single rigid body to 0
    set_param(blk_rb, 'Mass', '0');
    set_param(blk_rb, 'CenterOfMass', '[0 0 0]');
    set_param(blk_rb, 'MomentsOfInertia', '[0 0 0]');
    set_param(blk_rb, 'ProductsOfInertia', '[0 0 0]');
else
    % Else assign properties from block mask to single rigid body
    set_param(blk_rb, 'Mass', get_param(blk_h, 'mass'));
    set_param(blk_rb, 'CenterOfMass', get_param(blk_h, 'com'));
    set_param(blk_rb, 'MomentsOfInertia', get_param(blk_h, 'moi'));
    set_param(blk_rb, 'ProductsOfInertia', get_param(blk_h, 'poi'));
end

% Set properties associated with the interface frames
if piecesBody
    % Assign mass to interface frames using mask parameter
    frameBody = splitBodyProps;
else
    % Set minimum mass and inertia to interface frames
    for k = 1:Nf
        frameBody(k).dim    = str2num(get_param(blk_h, 'smallInertiaDim'))*ones(1,3); %#ok<*AGROW,*ST2NM>
        frameBody(k).mass   = str2num(get_param(blk_h, 'smallInertiaMass'));
        frameBody(k).com    = [0 0 0];
        frameBody(k).moi    = str2num(get_param(blk_h, 'smallInertiaMass'))*str2num(get_param(blk_h,'smallInertiaDim'))^2/6*ones(1,3);
        frameBody(k).poi    = [0 0 0];
        frameBody(k).offset = [0 0 0];
    end
end

% Set visual properties for interface bodies and interface graphic elements
for k = 1:Nf
    frameBody(k).color   = str2num(get_param(blk_h, 'intf_body_color'));
    frameBody(k).opacity = str2num(get_param(blk_h, 'intf_body_opacity'));
    frameGraphic(k).color   = str2num(get_param(blk_h, 'intf_graphic_color'));
    frameGraphic(k).opacity = str2num(get_param(blk_h, 'intf_graphic_opacity'));
end

% Set degrees of freedom for interface frames
% Since we are calling this from Mask Initialization, we can only override
% the variant once per subsystem.
%
% Find all variant subsystems that set interface frame degrees of freedom
rigid_fr = find_system(blk_h,'LookUnderMasks','all','FollowLinks','on','ActiveVariant','Rigid');

for i=1:length(rigid_fr)
    rigid_frame_name = get_param(rigid_fr{i},'Name');
    
    % Configure degrees of freedom for flexible frames only
    if(~strcmpi(rigid_frame_name,['Frame ' get_param(blk_h,'rigidBodyFrame')]))
        set_param(rigid_fr{i},'OverrideUsingVariant','Flex');
    end
end

% Set degrees of freedom to zero for one interface frame
% as specified in block mask
set_param([blk_h '/Frame ' get_param(blk_h,'rigidBodyFrame')],'OverrideUsingVariant','Rigid');

