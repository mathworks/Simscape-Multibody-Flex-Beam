% Code to plot simulation results from sm_flex_fe_import_beam
%% Plot Description:
%
% The plot below compares the effect of the included number of dynamic
% modes on the simulation results for the flexible beam modeled using
% finite element data with three interface frames.
%
% Copyright 2017-2019 The MathWorks, Inc.

%% Generate results: FEI beam, 3 Frames
open_system('sm_flex_fe_import_beam');
mdl = 'sm_flex_fe_import_beam';

sm_flex_fe_import_beam_select_model(mdl,'Body 3 Frames');
sm_flex_fe_import_beam_configure_load(mdl,'Tip Load');
sm_flex_fe_import_beam_select_rigid_frame(mdl,'Center');
sm_flex_fe_import_beam_select_massdistr(mdl,'Per Interface Frame');

sm_flex_fe_import_beam_select_numdynmodes(mdl,'10');
sim(mdl)
simlog_dxyz_3f10 = logsout_sm_flex_fe_import_beam.get('dxyz');

sm_flex_fe_import_beam_select_numdynmodes(mdl,'20');
sim(mdl)
simlog_dxyz_3f20 = logsout_sm_flex_fe_import_beam.get('dxyz');

sm_flex_fe_import_beam_select_numdynmodes(mdl,'40');
sim(mdl)
simlog_dxyz_3f40 = logsout_sm_flex_fe_import_beam.get('dxyz');


%% Plot comparison for 3 frame beam, varying number of dynamic modes

% Reuse figure if it exists, else create new figure
if ~exist('h4_sm_flex_fe_import_beam', 'var') || ...
        ~isgraphics(h4_sm_flex_fe_import_beam, 'figure')
    h4_sm_flex_fe_import_beam = figure('Name', 'sm_flex_fe_import_beam');
end
figure(h4_sm_flex_fe_import_beam)
clf(h4_sm_flex_fe_import_beam)


% Plot results
plot(simlog_dxyz_3f10.Values.Time, simlog_dxyz_3f10.Values.Data(:,2), 'LineWidth', 2)
hold on
plot(simlog_dxyz_3f20.Values.Time, simlog_dxyz_3f20.Values.Data(:,2), 'LineWidth', 2,'LineStyle','--')
plot(simlog_dxyz_3f40.Values.Time, simlog_dxyz_3f40.Values.Data(:,2), 'LineWidth', 2,'LineStyle',':')
hold off
legend({'10 Dynamic Modes','20 Dynamic Modes','40 Dynamic Modes'},'Location','Best');
grid on
title('Effect of Included Dynamic Modes (FEI Beam, 3 Frames)');
ylabel('Tip Deflection (m)');
xlabel('Time (s)');
set(gca,'XLim',[0 1]);
