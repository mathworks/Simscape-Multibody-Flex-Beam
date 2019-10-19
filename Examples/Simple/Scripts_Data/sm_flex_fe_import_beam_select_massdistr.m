function sm_flex_fe_import_beam_select_massdistr(modelname,massdistr)
% This function configures the mass distribution for the cantilever beam
% in model sm_flex_fe_import_beam.slx.  

% Copyright 2017-2019 The MathWorks, Inc.

% Source library for flexible beam element
library_name = 'sm_flex_body_lib';

% Find flexible beam block within model
flexbeam_h = char(find_system(modelname,'regexp','on','SearchDepth',1,'ReferenceBlock',[library_name '/FE Import/Bodies/Body.*']));

% Set parameter in mask.
% Mask initialization will assign mass to a single solid 
% or to separate solids at each interface frame
if(strcmpi(massdistr,'Single'))
    set_param(flexbeam_h,'popup_massdistr','Single');
else
    set_param(flexbeam_h,'popup_massdistr','Per Interface Frame');
end
