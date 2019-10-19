function sm_flex_fe_import_beam_select_rigid_frame(modelname,rigidframe)
% This function configures the degrees of freedom at each interface frame.
% There is only one rigid connection, the rest have 6 degrees of freedom.

% Copyright 2017-2019 The MathWorks, Inc.

% Source library for flexible beam element
library_name = 'sm_flex_body_lib';

% Find flexible beam block within model
flexbeam_h = char(find_system(modelname,'regexp','on','SearchDepth',1,'ReferenceBlock',[library_name '/FE Import/Bodies/Body.*']));
numframes = char(get_param(flexbeam_h,'numframes'));

% Convert input argument ('B', 'Center', 'F') to frame index 
% and then set beam mask parameter for rigid frame.
% Mask initialization will reconfigure DOFs for each interface frame
if(numframes == '3')
    switch rigidframe
        case 'B', set_param(flexbeam_h,'rigidbodyframe','1');
        case 'Center', set_param(flexbeam_h,'rigidbodyframe','2');
        case 'F', set_param(flexbeam_h,'rigidbodyframe','3');
        otherwise
            error('Unknown setting for rigid frame');
    end
elseif(numframes == '5')
    switch rigidframe
        case 'B', set_param(flexbeam_h,'rigidbodyframe','1');
        case 'Center', set_param(flexbeam_h,'rigidbodyframe','3');
        case 'F', set_param(flexbeam_h,'rigidbodyframe','5');
        otherwise
            error('Unknown setting for rigid frame');
    end
end
