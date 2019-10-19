% Code to plot simulation results from sm_flex_fe_import_beam
%% Plot Description:
%
% The plot below compares the effect of the included number of dynamic
% modes on the simulation results for the flexible beam modeled using
% finite element data with five interface frames.
%
% Copyright 2017-2019 The MathWorks, Inc.

%% Generate results: FEI beam, 3 Frames
open_system('sm_flex_fe_import_beam');
sm_flex_fe_import_beam_select_model(bdroot,'Body 3 Frames');
sm_flex_fe_import_beam_configure_load(bdroot,'Tip Load');
sm_flex_fe_import_beam_select_rigid_frame(bdroot,'Center');
sm_flex_fe_import_beam_select_massdistr(bdroot,'Per Interface Frame');

%% Generate results: FEI beam, 5 Frames
sm_flex_fe_import_beam_select_model(bdroot,'Body 5 Frames');
sm_flex_fe_import_beam_configure_load(bdroot,'Tip Load');
sm_flex_fe_import_beam_select_rigid_frame(bdroot,'Center');
sm_flex_fe_import_beam_select_massdistr(bdroot,'Per Interface Frame');

sm_flex_fe_import_beam_select_numdynmodes(bdroot,'20');
sim(bdroot)
simlog_dxyz_5f20 = logsout_sm_flex_fe_import_beam.get('dxyz');

sm_flex_fe_import_beam_select_numdynmodes(bdroot,'40');
sim(bdroot)
simlog_dxyz_5f40 = logsout_sm_flex_fe_import_beam.get('dxyz');

sm_flex_fe_import_beam_select_numdynmodes(bdroot,'80');
sim(bdroot)
simlog_dxyz_5f80 = logsout_sm_flex_fe_import_beam.get('dxyz');

%% Plot comparison for 5 frame beam, varying number of dynamic modes

% Reuse figure if it exists, else create new figure
if ~exist('h5_sm_flex_fe_import_beam', 'var') || ...
        ~isgraphics(h5_sm_flex_fe_import_beam, 'figure')
    h5_sm_flex_fe_import_beam = figure('Name', 'sm_flex_fe_import_beam');
end
figure(h5_sm_flex_fe_import_beam)
clf(h5_sm_flex_fe_import_beam)

% Plot results
plot(simlog_dxyz_5f20.Values.Time, simlog_dxyz_5f20.Values.Data(:,2), 'LineWidth', 2)
hold on
plot(simlog_dxyz_5f40.Values.Time, simlog_dxyz_5f40.Values.Data(:,2), 'LineWidth', 2,'LineStyle','--')
plot(simlog_dxyz_5f80.Values.Time, simlog_dxyz_5f80.Values.Data(:,2), 'LineWidth', 2,'LineStyle',':')
hold off
legend({'20 Dynamic Modes','40 Dynamic Modes','80 Dynamic Modes'},'Location','Best');
grid on
title('Effect of Included Dynamic Modes (FEI Beam, 5 Frames)');
ylabel('Tip Deflection (m)');
xlabel('Time (s)');
set(gca,'XLim',[0 1]);

