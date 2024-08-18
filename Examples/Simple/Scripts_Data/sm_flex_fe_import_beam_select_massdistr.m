function sm_flex_fe_import_beam_select_massdistr(modelname,massdistr)
% This function configures the mass distribution for the cantilever beam
% in model sm_flex_fe_import_beam.slx.  

% Copyright 2017-2024 The MathWorks, Inc.

% Source library for flexible beam element
library_name = 'sm_flex_body_lib';

% Find flexible beam block within model
f    = Simulink.FindOptions('SearchDepth',1,'RegExp',true);
flexbeam_h = Simulink.findBlocks(modelname,'ReferenceBlock',[library_name '/FE Import/Bodies/Body.*'],f);

% Set parameter in mask.
% Mask initialization will assign mass to a single solid 
% or to separate solids at each interface frame
if(strcmpi(massdistr,'Single'))
    set_param(flexbeam_h,'popup_massdistr','Single');
else
    set_param(flexbeam_h,'popup_massdistr','Per Interface Frame');
end
