% Parameters for beam used in sm_flex_fe_import_beam.slx
% Copyright 2017-2019 The MathWorks, Inc.

load beamFEData

% Reference coefficients not present in saved data
beamLink.coefs.cdf.a_tx = 0;
beamLink.coefs.cdf.a_ty = 0;
beamLink.coefs.cdf.a_tz = 0;

% Extract data to variables with meaningful names
% Beam exported from FE with 3 frames and differing number of dynamic modes
beamFE_3fr.splitBodyProps = beamLink.splitBodyProps(2).props;
beamFE_3fr10m = beamLink.models(4);
beamFE_3fr20m = beamLink.models(5);
beamFE_3fr40m = beamLink.models(6);

% Beam exported from FE with 5 frames and differing number of dynamic modes
beamFE_5fr.splitBodyProps = beamLink.splitBodyProps(3).props;
beamFE_5fr20m = beamLink.models(7);
beamFE_5fr40m = beamLink.models(8);
beamFE_5fr80m = beamLink.models(9);

% Calculate static deflection
q = beamLink.mat.rho*beamLink.cs.b*beamLink.cs.a*(9.81*100);
I = beamLink.cs.b*beamLink.cs.a^3/12;
delta = q*beamLink.L^4/(8*beamLink.mat.E*I);

% Calculate natural frequencies
A=[3.52 22.0 61.7 121.0];
wn = A*(beamLink.mat.E*I*(9.81*100)/(q*beamLink.L^4))^0.5/(2*pi);

% Define force pulse
tip_force = 2e1;
tip_force_duration = 5;



