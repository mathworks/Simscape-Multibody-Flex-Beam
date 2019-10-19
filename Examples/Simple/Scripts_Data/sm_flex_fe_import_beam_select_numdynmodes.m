function sm_flex_fe_import_beam_select_numdynmodes(modelname,numdynmodes)
% This function parameterizes the beam with the set of data exported from
% FE software with the desired number of dynamic modes for currently
% configured number of interface frames.

% Copyright 2017-2019 The MathWorks, Inc.

% Source library for flexible beam element
library_name = 'sm_flex_body_lib';

% Find flexible beam block within model
flexbeam_h = char(find_system(modelname,'regexp','on','SearchDepth',1,'ReferenceBlock',[library_name '/FE Import/Bodies/Body.*']));
numframes = char(get_param(flexbeam_h,'numframes'));

% Get name of variable based on number of frames and desired modes
if(numframes == '3')
    splitbodypropsname = 'beamFE_3fr';
    switch numdynmodes
        case '10', varname = 'beamFE_3fr10m';
        case '20', varname = 'beamFE_3fr20m';
        case '40', varname = 'beamFE_3fr40m';
        otherwise
            error('Unknown setting for numdynmodes');
    end
elseif(numframes == '5')
    splitbodypropsname = 'beamFE_5fr';
    switch numdynmodes
        case '20', varname = 'beamFE_5fr20m';
        case '40', varname = 'beamFE_5fr40m';
        case '80', varname = 'beamFE_5fr80m';
        otherwise
            error('Unknown setting for numdynmodes');
    end
end

% Set parameters on beam model
% Mass matrix, stiffness matrix, and other values
% *** Consider for-loop if multiple beams found ***
set_param(flexbeam_h,...
    'T',[varname '.T'],...
    'K',[varname '.K'],...
    'M',[varname '.M'],...
    'H',[varname '.H'],...
    'dofIdxMap',[varname '.dofIdxMap'],...
    'splitBodyProps',[splitbodypropsname '.splitBodyProps']);
    