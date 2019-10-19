%% Generate Results: Lumped Parameter Beam, Vary Number of Elements
open_system('sm_flex_lumped_param_beam');
set_param([bdroot '/Flexible Beam'],'radio_flextype','Rotation: Z');
sm_flex_lumped_param_beam_configure_load(bdroot,'Tip Load');

set_param([bdroot '/Flexible Beam'],'numelem','30');
sim(bdroot);
simlog_dxyz_lp30e = logsout_sm_flex_lumped_param_beam.get('dxyz');

%% Generate results: FEI beam, 3 Frames
open_system('sm_flex_fe_import_beam');
sm_flex_fe_import_beam_select_model(bdroot,'Body 3 Frames');
sm_flex_fe_import_beam_configure_load(bdroot,'Tip Load');
sm_flex_fe_import_beam_select_rigid_frame(bdroot,'Center');
sm_flex_fe_import_beam_select_massdistr(bdroot,'Per Interface Frame');

sm_flex_fe_import_beam_select_numdynmodes(bdroot,'40');
sim(bdroot)
simlog_dxyz_3f40 = logsout_sm_flex_fe_import_beam.get('dxyz');

%% Compare FEI Beam and Lumped Parameter Beam

% Reuse figure if it exists, else create new figure
if ~exist('h8_sm_flex_fe_import_beam', 'var') || ...
        ~isgraphics(h8_sm_flex_fe_import_beam, 'figure')
    h8_sm_flex_fe_import_beam = figure('Name', 'sm_flex_fe_import_beam');
end
figure(h8_sm_flex_fe_import_beam)
clf(h8_sm_flex_fe_import_beam)

plot(simlog_dxyz_lp30e.Values.Time, simlog_dxyz_lp30e.Values.Data(:,2), 'LineWidth', 1)
hold on
plot(simlog_dxyz_3f40.Values.Time, simlog_dxyz_3f40.Values.Data(:,2), 'LineWidth', 1)
hold off
legend({'Lumped Par., 30 Elements',' 3 Frames, 40 Dynamic Modes'},'Location','Best');
grid on
title('Comparison of Lumped Parameter and Finite Import Beam Models');
ylabel('Tip Deflection (m)');
xlabel('Time (s)');
set(gca,'XLim',[0 1]);

