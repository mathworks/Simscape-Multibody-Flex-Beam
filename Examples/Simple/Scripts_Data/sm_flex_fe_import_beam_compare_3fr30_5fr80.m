% Code to plot simulation results from sm_flex_fe_import_beam
%% Plot Description:
%
% The plot below compares the behavior of a flexible beam modeled using
% finite element data with 3 interface frames with that has 5 interface
% frames.
%
% Copyright 2017-2019 The MathWorks, Inc.

%% Generate results: FEI beam, 3 Frames
open_system('sm_flex_fe_import_beam');

sm_flex_fe_import_beam_select_model(bdroot,'Body 3 Frames');
sm_flex_fe_import_beam_configure_load(bdroot,'Tip Load');
sm_flex_fe_import_beam_select_rigid_frame(bdroot,'Center');
sm_flex_fe_import_beam_select_massdistr(bdroot,'Per Interface Frame');

sm_flex_fe_import_beam_select_numdynmodes(bdroot,'40');
sim(bdroot)
simlog_dxyz_3f40 = logsout_sm_flex_fe_import_beam.get('dxyz');

%% Generate results: FEI beam, 5 Frames
sm_flex_fe_import_beam_select_model(bdroot,'Body 5 Frames');
sm_flex_fe_import_beam_configure_load(bdroot,'Tip Load');
sm_flex_fe_import_beam_select_rigid_frame(bdroot,'Center');
sm_flex_fe_import_beam_select_massdistr(bdroot,'Per Interface Frame');

sm_flex_fe_import_beam_select_numdynmodes(bdroot,'80');
sim(bdroot)
simlog_dxyz_5f80 = logsout_sm_flex_fe_import_beam.get('dxyz');

%% Compare model with 3 interface frames and 5 interface frames

% Reuse figure if it exists, else create new figure
if ~exist('h6_sm_flex_fe_import_beam', 'var') || ...
        ~isgraphics(h6_sm_flex_fe_import_beam, 'figure')
    h6_sm_flex_fe_import_beam = figure('Name', 'sm_flex_fe_import_beam');
end
figure(h6_sm_flex_fe_import_beam)
clf(h6_sm_flex_fe_import_beam)

% Plot results
plot(simlog_dxyz_3f40.Values.Time, simlog_dxyz_3f40.Values.Data(:,2), 'LineWidth', 1)
hold on
plot(simlog_dxyz_5f80.Values.Time, simlog_dxyz_5f80.Values.Data(:,2), 'LineWidth', 1)
hold off
legend({'3 Frames, 40 Dynamic Modes','5 Frames, 80 Dynamic Modes'},'Location','Best');
grid on
title('Compare Finite Element Beam (3 Frame, 5 Frames)');
ylabel('Tip Deflection (m)');
xlabel('Time (s)');
set(gca,'XLim',[0 1]);

