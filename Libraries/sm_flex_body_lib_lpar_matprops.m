function [rho, E, G] = sm_flex_body_lib_lpar_matprops(materialtype)
% Returns density, Young's Modulus, and Shear Modulus properties for
% requested material

% Copyright 2017-2019 The MathWorks, Inc.

% Data below taken from 
% L. Cremer and M. Heckl, Structure-Borne Sound, 
% Springer-Verlag, New York, 1988.

% Data
material.aluminum.rho = 2800; % kg/m^3
material.aluminum.E   = 70e9; % N/m^2
material.aluminum.G   = 27e9; % N/m^2

material.lead.rho = 11300; % kg/m^3
material.lead.E   = 17e9; % N/m^2
material.lead.G   = 6e9; % N/m^2

material.iron.rho = 7800; % kg/m^3
material.iron.E   = 200e9; % N/m^2
material.iron.G   = 77e9; % N/m^2

material.gold.rho = 19300; % kg/m^3
material.gold.E   = 80e9; % N/m^2
material.gold.G   = 28e9; % N/m^2

material.copper.rho = 8900; % kg/m^3
material.copper.E   = 125e9; % N/m^2
material.copper.G   = 46e9; % N/m^2

material.magnesium.rho = 1740; % kg/m^3
material.magnesium.E   = 43e9; % N/m^2
material.magnesium.G   = 17e9; % N/m^2

material.brass.rho = 8500; % kg/m^3
material.brass.E   = 36e9; % N/m^2
material.brass.G   = 77e9; % N/m^2

material.nickel.rho = 8900; % kg/m^3
material.nickel.E   = 205e9; % N/m^2
material.nickel.G   = 77e9; % N/m^2

material.silver.rho = 10500; % kg/m^3
material.silver.E   = 80e9; % N/m^2
material.silver.G   = 29e9; % N/m^2

material.bismuth.rho = 9800; % kg/m^3
material.bismuth.E   = 3.3e9; % N/m^2
material.bismuth.G   = 1.3e9; % N/m^2

material.zinc.rho = 7130; % kg/m^3
material.zinc.E   = 13.1e9; % N/m^2
material.zinc.G   = 5e9; % N/m^2

material.tin.rho = 7280; % kg/m^3
material.tin.E   = 4.4e9; % N/m^2
material.tin.G   = 1.6e9; % N/m^2

material.steel.rho = 7800; % kg/m^3
material.steel.E   = 200e9; % N/m^2
material.steel.G   = 77.2e9; % N/m^2

% Assign output
rho = material.(lower(materialtype)).rho;
E = material.(lower(materialtype)).E;
G = material.(lower(materialtype)).G;
