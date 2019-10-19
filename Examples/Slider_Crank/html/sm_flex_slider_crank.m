%% Flexible Body Slider Crank
% 
% This example shows a slider crank modeled using flexible bodies. The
% crankshaft and the connecting rod can each be configured to use a
% lumped parameter flexible beam model or to model flexibility using data
% imported from finite element software
% 
% Copyright 2016-2019 The MathWorks, Inc.


%% Model

open_system('sm_flex_slider_crank')
hs_on = sm_flex_slider_crank_configure_hardstop(bdroot,'off');
set_param(find_system('sm_flex_slider_crank','FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')
set_param(bdroot,'SimulationCommand','update');

%% Results from Simscape Logging: Comparison with Literature
%
% The plot below shows the deflection of the connecting rod midpoint
% relative to an imaginary line connecting the endpoints of the rod.  The
% conditions for the simulation match a documented case that used another
% widely used approach for flexible multibody simulation [1].  The results
% match quite closely.
%
% *Test using beam modeled with data exported from finite element software*

hs_on = sm_flex_slider_crank_configure_hardstop(bdroot,'off');
set_param([bdroot '/Rod'],'OverrideUsingVariant','FE_Import_5Frames');
sim(bdroot)
sm_flex_slider_crank_plot1roddef
hold on
load('UIC_Slider_Crank_Midpt.mat');
plot(UIC_Slider_Crank_Midpt(:,1),UIC_Slider_Crank_Midpt(:,2));
hold off
legend({'Finite Element Import','Documented Test Case [1]'},'Location','Best');

%%
% *Test using beam modeled using lumped parameter method*

set_param([bdroot '/Rod'],'OverrideUsingVariant','Lumped_Parameter');
sim(bdroot)
sm_flex_slider_crank_plot1roddef
hold on
plot(UIC_Slider_Crank_Midpt(:,1),UIC_Slider_Crank_Midpt(:,2));
hold off
legend({'Lumped Parameter','Documented Test Case [1]'},'Location','Best');

%%
% _[1] Escalona, J.L., H.A. Hussien, and A.A. Shabana. "APPLICATION OF THE
% ABSOLUTE NODAL CO-ORDINATE FORMULATION TO MULTIBODY SYSTEM DYNAMICS". Journal of Sound and Vibration 214.5 (1998): 833-851. Web. 26 May 2017._
% https://doi.org/10.1006/jsvi.1998.1563

%% Results from Simscape Logging: Slider Strikes Hard Stop
%
% The plot below shows the deflection of the connecting rod midpoint
% relative to the ends when the slider encounters a hard stop. This test
% was performed with the finite import method model with 5 interface
% frames.

hs_on = sm_flex_slider_crank_configure_hardstop(bdroot,'on');
set_param([bdroot '/Rod'],'OverrideUsingVariant','FE_Import_5Frames');
hs_on = sm_flex_slider_crank_configure_hardstop(bdroot,'on');
sim(bdroot)
sm_flex_slider_crank_plot1roddef


%%
clear all
close all
bdclose all
