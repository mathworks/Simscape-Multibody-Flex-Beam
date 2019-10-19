function sm_flex_fe_import_beam_select_model(modelname,modeltype)
% This function replaces the beam in model sm_flex_fe_import_beam.slx with
% the selected variant that has the desired number of interface frames.
% Function replace_block() is used instead of variant subsystems so that
% the mask and block annotations are visible at the top level of the model.

% Copyright 2017-2019 The MathWorks, Inc.

% Source library for flexible beam element
library_name = 'sm_flex_body_lib';
load_system(library_name);

% Find flexible beam block within model
flexbeam_h = char(find_system(modelname,'regexp','on','SearchDepth',1,'ReferenceBlock',[library_name '/FE Import/Bodies/Body .*']));
ref_flexbeam = get_param(flexbeam_h,'ReferenceBlock');

% Replace beam element in model with variant that has 
% the desired number of interface frames
if(strcmpi(modeltype,'Body 3 Frames'))
    if(strfind(ref_flexbeam,'Body 5 Frames'))
        replace_block(modelname,'Name',char(get_param(flexbeam_h,'Name')),[library_name '/FE Import/Bodies/Body 3 Frames'],'noprompt');
    end
elseif(strcmpi(modeltype,'Body 5 Frames'))
    if(strfind(ref_flexbeam,'Body 3 Frames'))
        replace_block(modelname,'Name',char(get_param(flexbeam_h,'Name')),[library_name '/FE Import/Bodies/Body 5 Frames'],'noprompt');
    end
end

% Set parameter values for this example
set_param(flexbeam_h,'rigid_body_filename','''BeamLink.stl''');
set_param(flexbeam_h,'mass','beamLink.iner.mass');
set_param(flexbeam_h,'com','beamLink.iner.com');
set_param(flexbeam_h,'moi','beamLink.iner.moi');
set_param(flexbeam_h,'poi','beamLink.iner.poi');
set_param(flexbeam_h,'ksi','0.05');
set_param(flexbeam_h,'tau','1e-7');
set_param(flexbeam_h,'intf_graphic_color', '[0.0 0.4 0.6]');
set_param(flexbeam_h,'intf_body_color', '[0.0 0.4 0.6]');
set_param(flexbeam_h,'rigid_body_color', '[0.0 0.4 0.6]');
