% Code to plot simulation results from sm_flex_lumped_param_beam
%% Plot Description:
%
% The plot below compares the effect of the  number of flexible elements on
% the simulation results for a flexible beam modeled using the lumped
% parameter method.
%
% Copyright 2017-2019 The MathWorks, Inc.

%% Generate Results: Lumped Parameter Beam, Vary Number of Elements

open_system('sm_flex_lumped_param_beam');
set_param([bdroot '/Flexible Beam'],'radio_flextype','Rotation: Z');

set_param([bdroot '/Flexible Beam'],'numelem','10');
sim(bdroot);
simlog_dxyz_lp10e = logsout_sm_flex_lumped_param_beam.get('dxyz');

set_param([bdroot '/Flexible Beam'],'numelem','20');
sim(bdroot);
simlog_dxyz_lp20e = logsout_sm_flex_lumped_param_beam.get('dxyz');

set_param([bdroot '/Flexible Beam'],'numelem','30');
sim(bdroot);
simlog_dxyz_lp30e = logsout_sm_flex_lumped_param_beam.get('dxyz');


%% Plot comparison for lumped parameter beam, varying number of elements

% Reuse figure if it exists, else create new figure
if ~exist('h7_sm_flex_fe_import_beam', 'var') || ...
        ~isgraphics(h7_sm_flex_fe_import_beam, 'figure')
    h7_sm_flex_fe_import_beam = figure('Name', 'sm_flex_fe_import_beam');
end
figure(h7_sm_flex_fe_import_beam)
clf(h7_sm_flex_fe_import_beam)

% Plot results
plot(simlog_dxyz_lp10e.Values.Time, simlog_dxyz_lp10e.Values.Data(:,2), 'LineWidth', 1)
hold on
plot(simlog_dxyz_lp20e.Values.Time, simlog_dxyz_lp20e.Values.Data(:,2), 'LineWidth', 1)
plot(simlog_dxyz_lp30e.Values.Time, simlog_dxyz_lp30e.Values.Data(:,2), 'LineWidth', 1)
hold off
legend({'Lumped Par., 10 Elements','Lumped Par., 20 Elements','Lumped Par., 30 Elements'},'Location','Best');
grid on
title('Effect of Number of Flexible Elements in Lumped Parameter Beam');
ylabel('Tip Deflection (m)');
xlabel('Time (s)');
set(gca,'XLim',[0 1])

