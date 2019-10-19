%% Flexible Beam from Finite Element Data
% 
% This example shows a cantilever beam modeled by superimposing the
% deflection predicted by finite element models on rigid body motion.  In a
% simple test, transient simulation can be used to determine the static
% deflection of the beam due to gravity.  A force can also be applied to
% the tip of the beam. Hyperlinks in the model let you adjust the loading
% method and other settings of the flexible beam element.
% 
% Copyright 2016-2019 The MathWorks, Inc.


%% Model

open_system('sm_flex_fe_import_beam')
set_param(find_system('sm_flex_fe_import_beam','FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')

%% Flexible Beam Subsystem (Finite Element Import Method)
%
% This subsystem models the flexible body.  It consists of a rigid body and
% a number of interface frames.  All interface frames except one have six
% degrees of freedom between them and the rigid body.  Data exported from
% finite element software is used within the state-space block to calculate
% the force resisting the deformation of the rigid body. One interface
% frame has no degrees of freedom associated with it so that the rigid body
% modes of the flexible body are not added twice.

set_param('sm_flex_fe_import_beam/Flexible Beam','LinkStatus','none')
open_system('sm_flex_fe_import_beam/Flexible Beam','force')
close_system('sm_flex_fe_import_beam/Flexible Beam/Frame 1/Flex');

%% Interface Frame Degrees of Freedom
%
% A Bushing Joint models the degrees of freedom for the interface frames.
% Position, velocity, and acceleration are measured from each degree of
% freedom and are fed to the state-space block.  The forces and torques
% calculated by the state-space block are applied to this joint.  A filter
% is required to break the algebraic loop.

load_system('sm_flex_body_lib');
set_param('sm_flex_body_lib','Lock','off')
open_system('sm_flex_body_lib/FE Import/Bodies/Frame 1/Flex','force');
set_param('sm_flex_body_lib/FE Import/Bodies/Frame 1','OverrideUsingVariant','Flex');

%%
bdclose('sm_flex_fe_import_beam')
open_system('sm_flex_fe_import_beam')

%% Results from Simscape Logging: Static Deflection
%
% This plot shows the vertical deflection of the beam tip when it is
% subject to a distributed load (Earth's gravity * 100)
%
% In this model, the default values are for a 0.3m long beam
% constructed of aluminum (modulus of elasticity = 70 GPa, density = 2800
% kg/m^3). The beam is 0.015m wide and 0.005m thick.  For this test, we
% have increased gravity by a factor of 100 so that we can see the
% deflection.
%
% Euler-Bernoulli beam theory predicts the static deflection for a
% cantilever beam with one fixed end and one free end with equation (1)
% 
% $\delta={qL^4\over 8EI}\quad\quad\quad(1)$  
% 
% Where
%
% $q$ = Uniform load on the beam (force/unit length) 
% 
% $q  = rho*area*gravity$ 
% 
% = 2800*(0.015*0.005)*9.81*100/0.3 = 205.93 N/m
%
% $L$ = Length of the beam
%
% $E$ = Modulus of elasticity
%
% $I$ = Area moment of inertia of cross section
%
% The area moment of inertia for a rectangular cross section is: 
%
% $I = {(x_{width} \cdot x_{thickness}^3) / 12}\quad\quad\quad(2)$
%
% (0.015*0.005^3)/12 = 1.5625e-10 m^4
%
% Plugging these values into equation (1) yields
% 205.93*0.3^4/(8*70e9*1.5625e-10) = 0.0191 m
%
% Transient simulation results match theory quite well.

sm_flex_fe_import_beam_configure_load('sm_flex_fe_import_beam','Gravity');
sim('sm_flex_fe_import_beam');
sm_flex_fe_import_beam_plot1ydef
hold on
plot([0 10],-0.0191*[1 1],'k--')
temp_leg = legend(gca);
temp_leg_str = temp_leg.String;
set(legend(gca),'String',{temp_leg.String{1:2},'Theoretical Deflection'})

%% Results from Simscape Logging: Tip Load
%
% This plot shows the vertical deflection of the beam tip when it is
% a force is applied to the tip of the beam for a period of time.
%
% The peaks are used to calculate the damping ratio. We obtained damping
% ratio by examining the rate of decay in the simulation results for the
% beam. Looking at successive peaks, we found the logarithmic decrement
% using the following formula:
%
% $\delta = 1/n \cdot ln(x(t)/x(t+nT))$
%
% The damping ratio can be found from the logarithmic decrement
%
% $\zeta = 1/\sqrt{1+(2\pi/\delta)^2}$

sm_flex_fe_import_beam_configure_load('sm_flex_fe_import_beam','Tip Load');
sim('sm_flex_fe_import_beam');
sm_flex_fe_import_beam_plot1ydef

%% Results from Simscape Logging: Varying Number of Included Dynamic Modes, 3 Frames
%
% This plot shows the effect of increasing the number of dynamic modes
% included in the data imported from the finite element software for the model with 3 interface frames.

sm_flex_fe_import_beam_compare_numdynmodes_3fr

%% Results from Simscape Logging: Varying Number of Included Dynamic Modes, 5 Frames
%
% This plot shows the effect of increasing the number of dynamic modes
% included in the data imported from the finite element software for the model with 5 interface frames.

sm_flex_fe_import_beam_compare_numdynmodes_5fr

%% Results from Simscape Logging: Compare Models with 3 and 5 Interface Frames
%
% This plot compares the simulation results for models with 3 and 5 interface frames.

sm_flex_fe_import_beam_compare_3fr30_5fr80

%% Results from Simscape Logging: Set Damping Factor Using Measured Data
%
% The plot below compares the simulation results of the lumped parameter
% beam with a beam modeled using data exported from finite element
% software. This step was performed to set the damping factor, which is
% most reliably set using measured data.  The elastic damping factor in the
% lumped parameter model was tuned until the simulation results matched the
% results from the FE import beam model.  This process can be used on
% measured data taken directly from finite element software and
% measurements taken from hardware.
%

open_system('sm_flex_lumped_param_beam')
set_param(find_system('sm_flex_lumped_param_beam','FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')
sm_flex_beam_compare_feimport_lumpedpar

%%
%clear all
close all
bdclose all
