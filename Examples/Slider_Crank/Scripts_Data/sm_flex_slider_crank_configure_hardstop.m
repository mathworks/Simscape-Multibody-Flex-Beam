function hs_on = sm_flex_slider_crank_configure_hardstop(modelname,enable)
% sm_flex_slider_crank_configure_hardstop  Enable/Disable hardstop in
% model sm_flex_slider_crank

% Copyright 2017-2019 The MathWorks, Inc.

switch lower(enable)
    case 'on'
        hs_on = 1;
        set_param([modelname '/SignHSForce'],'Tag','on');
    case 'off'
        hs_on = 0;
        set_param([modelname '/SignHSForce'],'Tag','off');
end
