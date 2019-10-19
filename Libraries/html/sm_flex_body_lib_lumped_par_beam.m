%% Flexible Beam from Lumped Parameters
% 
% Models a flexible beam based on lumped parameter method. Number of
% flexible elements, material properties as well as beam cross section and
% dimensions can be varied from mask parameters.
% 
% Copyright 2016-2019 The MathWorks, Inc.


%% Model

open_system('sm_flex_body_lib');
set_param('sm_flex_body_lib','Lock','off')
open_system('sm_flex_body_lib/Lumped Parameter/Bodies');
delete_block([gcs '/Flex_Element']);
delete_block([gcs '/Revolute Joint']);
delete_block([gcs '/Bearing Joint']);

%% 
bdclose('sm_flex_body_lib')

%% Diagram
%
% The following diagram shows the generic structure of the beam represented
% by these blocks.  A chain of flexible elements connects frames B and F
% which are the ports of the block.  The number of elements can be varied,
% as can the degrees of freedom permitted by the spring-damper within each
% flexible element.
%
%%
% <<sm_flex_body_lib_doc_lpar_diagram.png>>
%
%

%% Parameters, Tab |Material|
%
% *Material*: Define the material properties of the beam.  Exact values can
% be provided or standard values for common materials can be selected.
%
% * |Custom| - Provide exact values for relevant material properties.
% * |Steel| - Use standard values for steel, which are shown in the dialog box.
% * Many other standard properties can be selected
%
% These parameters are needed to calculate solid and deflection properties
% of the beam
%
% * *Material Density*: Density of the material
% * *Modulus of Elasticity*: Young's Modulus of the material
% * *Shear Modulus*: Shear Modulus of the material
%
% *Damping*: Specify damping for the beam.  Damping is specified by two
% damping factors.  This parameterization enables the damping to scale with
% the dimensions and material used in the beam.  
%
% * *Elastic Damping Factor*: Damping factor for bending and elongation
% * *Shear Damping Factor*: Damping factor for torsion
% 
% The damping coefficient $b$ used in the flexible elements is calculated
% according to the following formula:
%
% $b_{b} = factor_{elastic} \cdot E \cdot Ia_{beam} / l_{element}$
%
% $b_{e} = factor_{elastic} \cdot E \cdot A_{beam} / l_{element}$ 
%
% $b_{t} = factor_{shear} \cdot G \cdot J_{beam} / l_{element}$ 
%
% Where
%
% $b_{b}, b_{e}, b_{t}$ = Damping coefficient for bending, elongation, and
% torsion
%
% $Ia_{beam}$ = Area moment of inertia
%
% $A_{beam}$ = Cross sectional area of beam
%
% $J_{beam}$ = Torsional constant for beam
%
% $E$ = Modulus of Elasticity
%
% $G$ = Shear Modulus
%
% $l_{element}$ = Length of flexible beam element
%
% *Print internal values to Command Window*: Prints internal values to
% MATLAB Command Window. Resulting values can be inspected to verify that
% provided parameters are correct.  An example of the printed values is
% shown below.

open_system('sm_flex_body_lib');
set_param('sm_flex_body_lib','Lock','off')
open_system('sm_flex_body_lib/Lumped Parameter/Bodies');

set_param(gcb,'checkbox_internalvalues','on');
bdclose('sm_flex_body_lib')

%% Parameters, Tab |Geometry|
%
% *Cross-Section Type*: Select the cross-section type for the beam.  Exact
% values can be provided, or some standard shapes can be used.
%
% * |Hollow Rectangle| - Define cross-section as a hollow rectangle.
% Selecting this option exposes parameters for defining the inner and outer
% dimensions of the hollow rectangle.  The inner dimension can be set to
% zero in order to define a solid rectangle.  Area moments of inertia,
% polar moments of inertia are calculated automatically. *Note*: torsion
% constant calculation assumes thickly walled cross section.  See code if
% you wish to verify formula used.
% * |Hollow Circle| - Define cross-section as a hollow circle. Selecting
% this option exposes parameters for defining the inner and outer diameters
% of the hollow circle.  The inner dimension can be set to zero in order to
% define a solid circle. Area moments of inertia, polar moments of inertia,
% and torsion constant are calculated automatically.  *Note*: torsion
% constant calculation assumes thickly walled cross section.  See code if
% you wish to verify formula used.
% * |Custom| - Specify the exact properties of the cross-section. Selecting
% this option exposes parameters for defining the area moments of inertia,
% polar moments of inertia, torsion constant, and the extrusion data.
%
% *Length*: Overall length of the beam
% 
% *Number of elements*: Number of flexible elements used to construct the
% beam.  A higher number of elements typically results in higher accuracy
% but longer computation times.
% 
% *Color*: 3-vector with values between 0-1 defining color of rigid body solid [RGB]
%
% *Opacity*: Scalar value between 0-1 defining opacity
%

%% Parameters, Tab |Flexibility Type|
%
% *Flexible Element Degrees of Freedom*:  Select the number of degrees of freedom permitted by
% the spring-damper element in each flexible element.
%
% * |Rotation: Z| - Permits one rotational degree of freedom in the
% flexible element along the z-axis.
% * |Rotation: X, Y, Z; Translation: X| - Permits three rotational degree of
% freedom and one translational degree of freedom along the x-axis.
%

%%
%clear all
close all
bdclose all
