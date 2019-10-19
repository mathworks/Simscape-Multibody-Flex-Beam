function sm_flex_fe_import_beam_configure_load(modelname,loadtype)
% This function configures the loading conditions for the cantilever beam
% in model sm_flex_fe_import_beam.slx

% Copyright 2017-2019 The MathWorks, Inc.

if(strcmpi(loadtype,'Tip Load'))
    % Enable tip load force and disable gravity
    set_param([modelname '/Mechanism Configuration'],'UniformGravity','None');
    set_param([modelname '/Load'],'A','tip_force');
    set_param([modelname '/Load'],'coefs','beamLink.coefs.ctl');
    evalin('base','gravity_vector = [0 0 0];');

elseif(strcmpi(loadtype,'Gravity'))
    % Enable gravity and disable tip load force
    set_param([modelname '/Mechanism Configuration'],'UniformGravity','Constant');
    set_param([modelname '/Load'],'A','0');
    set_param([modelname '/Load'],'coefs','beamLink.coefs.cdf');
    % Enable gravity is set to 100x Earth's gravity 
    % so that deflection of body is visible
    evalin('base','gravity_vector = [0 -9.80665 0]*100;');
end