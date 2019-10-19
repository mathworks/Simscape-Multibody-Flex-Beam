function [...
    krot_beamz, krot_beamy, krot_beamx, ktra_beamx, ...
    brot_beamz, brot_beamy, brot_beamx, btra_beamx, ...
    element_length, Ixx, Iyy, J, crossArea] = ...
    sm_flex_body_lib_lpar_compute_flexprop(youngsM, shearM, numelem, beam_length, ...
    edf_beam, sdf_beam, xc_type, xc_params)
% This function computes the stiffness properties and element length for
% the flexible elements in the lumped parameter flexible beam.

% Copyright 2014-2019 The MathWorks, Inc.

% Calculate element length
element_length = beam_length/numelem;

% Calculate area moments of inertia depending on beam cross section shape
if(xc_type==1)
    % Hollow rectangle
    x    = xc_params(1);
    x_in = xc_params(2);
    y    = xc_params(3);
    y_in = xc_params(4);
    [Ixx, Iyy, ~, J, crossArea] = Area_Moment_Inertia_Rectangle(x,x_in,y,y_in);
elseif(xc_type==2)
    % Hollow circle
    d    = xc_params(1);
    d_in = xc_params(2);
    [Ixx, Iyy, ~, J, crossArea] = Area_Moment_Inertia_Circle(d,d_in);
elseif(xc_type==3)
    % Custom
    Ixx  = xc_params(1);
    Iyy  = xc_params(2);
    %Ip   = xc_params(3);
    J    = xc_params(4);
    extrusion_data_vec = xc_params(5:end);
    extrusion_data = reshape(extrusion_data_vec,[length(extrusion_data_vec)/2,2]);
    crossArea = Extr_Data_Calc_Area(extrusion_data);
end

% Cantilever bending stiffness
krot_beamz = youngsM * Ixx / element_length;
krot_beamy = youngsM * Iyy / element_length;
krot_beamx = shearM * J / element_length;
ktra_beamx = youngsM * crossArea/element_length;

% Damping calculation - elastic and shear damping factors
brot_beamz = edf_beam*krot_beamz;
brot_beamy = edf_beam*krot_beamy;
brot_beamx = sdf_beam*krot_beamx;
btra_beamx = edf_beam*ktra_beamx;

%Optional Messages
%disp('sm_flex_body');
%disp(['Ixx ' num2str(Ixx) '; stiffness ' num2str(youngsM * Ixx/beam_length/4) '; moment ' num2str(Ixend) '; damping ' num2str(brot_beamz)]) 

end

function [Ixx, Iyy, Ip, J, crossArea] = Area_Moment_Inertia_Rectangle(x,x_in,y,y_in)
% Calculate area moments of inertia for a hollow rectangle

% Beam element area moment of inertia along the direction of bending (m^4)
Ixx = x*y^3/12-x_in*y_in^3/12;
Iyy = y*x^3/12-y_in*x_in^3/12;
Ip = Ixx + Iyy;

% Torsion constant formula assumes thickly walled cross section
% Corrections needed for thin-walled cross section
min_side = min(x,y);
max_side = max(x,y);
J = max_side*min_side^3*(1/3-0.21*(min_side/max_side)*(1-min_side^4/(12*min_side^4)));

% Cross-sectional area
crossArea = x*y-x_in*y_in;

end

function [Ixx, Iyy, Ip, J, crossArea] = Area_Moment_Inertia_Circle(d,d_in)
% Calculate area moments of inertia for a hollow rectangle

% Beam element area moment of inertia along the direction of bending (m^4)
Ixx = pi/64*(d^4-d_in^4);
Iyy = Ixx;
Ip = Ixx + Iyy;

% Torsion constant formula assumes thickly walled cross section
% Corrections needed for thin-walled cross section
J = Ip;

% Cross-sectional area
crossArea = pi/4*(d^2-d_in^2);

end

