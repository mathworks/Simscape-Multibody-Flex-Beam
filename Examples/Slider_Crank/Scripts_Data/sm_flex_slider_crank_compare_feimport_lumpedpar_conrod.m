%% Generate Results: Lumped Parameter Beam, Vary Number of Elements

% Configure test
open_system('sm_flex_lumped_param_beam');
set_param([bdroot '/Flexible Beam'],'radio_flextype','Rotation: Z');
sm_flex_lumped_param_beam_configure_load(bdroot,'Tip Load');
set_param([bdroot '/Flexible Beam'],'numelem','30');

% Set parameters
% Test
tip_force_temp = tip_force;
tip_force = 2e1*0.001;
tip_force_duration_temp = tip_force_duration;
tip_force_duration = 40;

% Beam
beam_h = [bdroot '/Flexible Beam'];
set_param(beam_h,...
    'popup_material','Custom',...
    'rho_cust','shabanaConnectingRod.mat.rho',...
    'youngsM_cust','shabanaConnectingRod.mat.E',...
    'shearM_cust','shabanaConnectingRod.mat.G',...
    'edf_beam','6.03e-04',...
    'popup_xc','Hollow Rectangle',...
    'beam_width','shabanaConnectingRod.cs.b',...
    'beam_width_in','0',...
    'beam_height','shabanaConnectingRod.cs.a',...
    'beam_height_in','0',...
    'beam_length','shabanaConnectingRod.L');

set_param(bdroot,'MaxStep','1e-2');
sim(bdroot);
simlog_dxyz_lpConRod = logsout_sm_flex_lumped_param_beam.get('dxyz');

% Calculate damping ratio
% Obtain equilibrium value
temp_ind_0p80pulse = find(simlog_dxyz_lpConRod.Values.Time<=(tip_force_duration*0.8),1,'last');
temp_ind_0p99pulse = find(simlog_dxyz_lpConRod.Values.Time<(tip_force_duration*0.99),1,'last');
temp_equ_lp = mean(simlog_dxyz_lpConRod.Values.Data(temp_ind_0p80pulse:temp_ind_0p99pulse,2));

% Find peaks for lumped parameter test
temp_ind_start = 1;
temp_ind_finish = find(simlog_dxyz_lpConRod.Values.Time<=(tip_force_duration*0.5),1,'last');
temp_ind_set = [temp_ind_start:temp_ind_finish];
temp_posdata_lp = simlog_dxyz_lpConRod.Values.Data(temp_ind_set,2);
temp_postime_lp = simlog_dxyz_lpConRod.Values.Time(temp_ind_set);
temp_pos_peak_inds_lp = find(diff(sign(diff(temp_posdata_lp)))<0);

temp_ksi_lp = [];
if(length(temp_pos_peak_inds_lp)<6)
    temp_enough_peaks_lp = 0;
    temp_ksi_lp = 0;
else
    temp_enough_peaks_lp = 1;
    temp_pos_peak_inds_lp = temp_pos_peak_inds_lp(5:end)+1;
    temp_pos_peaks = temp_posdata_lp(temp_pos_peak_inds_lp);
    
    % Calculate damping ratio
    for pk_i = 2:length(temp_pos_peaks)
        temp_ratio = 1/(pk_i-1)*log((temp_pos_peaks(1)-temp_equ_lp)/(temp_pos_peaks(pk_i)-temp_equ_lp));
        temp_ksi_lp(pk_i-1) = temp_ratio/(sqrt(4*pi^2+temp_ratio^2));
    end
end


%% Generate results: FEI beam, 3 Frames

% Configure test
open_system('sm_flex_fe_import_beam');
sm_flex_fe_import_beam_select_model(bdroot,'Body 5 Frames');
sm_flex_fe_import_beam_configure_load(bdroot,'Tip Load');
sm_flex_fe_import_beam_select_rigid_frame(bdroot,'Center');
sm_flex_fe_import_beam_select_massdistr(bdroot,'Per Interface Frame');
sm_flex_fe_import_beam_select_numdynmodes(bdroot,'40');

% Beam
beam_h = [bdroot '/Flexible Beam'];
set_param(beam_h,...
    'splitBodyProps','shabanaConnectingRod.splitBodyProps(3).props',...
    'rigid_body_filename','''ShabanaConnectingRod.stl''',...
    'T','shabanaConnectingRod.models(7).T',...
    'K','shabanaConnectingRod.models(7).K',...
    'M','shabanaConnectingRod.models(7).M',...
    'ksi','0.05',...
    'dofIdxMap','shabanaConnectingRod.models(7).dofIdxMap',...
    'H','shabanaConnectingRod.models(7).H');

set_param(bdroot,'MaxStep','1e-3');
sim(bdroot)
simlog_dxyz_feConRod = logsout_sm_flex_fe_import_beam.get('dxyz');

% Calculate damping ratio
% Obtain equilibrium value
temp_ind_0p80pulse = find(simlog_dxyz_feConRod.Values.Time<=(tip_force_duration*0.8),1,'last');
temp_ind_0p99pulse = find(simlog_dxyz_feConRod.Values.Time<(tip_force_duration*0.99),1,'last');
temp_equ_fe = mean(simlog_dxyz_feConRod.Values.Data(temp_ind_0p80pulse:temp_ind_0p99pulse,2));

% Find peaks for finite element test
temp_ind_start = 1;
temp_ind_finish = find(simlog_dxyz_feConRod.Values.Time<=(tip_force_duration*0.5),1,'last');
temp_ind_set = [temp_ind_start:temp_ind_finish];
temp_posdata_fe = simlog_dxyz_feConRod.Values.Data(temp_ind_set,2);
temp_postime_fe = simlog_dxyz_feConRod.Values.Time(temp_ind_set);
temp_pos_peak_inds_fe = find(diff(sign(diff(temp_posdata_fe)))<0);

temp_ksi_fe = [];
if(length(temp_pos_peak_inds_fe)<6)
    temp_enough_peaks_fe = 0;
    temp_ksi_fe = 0;
else
    temp_enough_peaks_fe = 1;
    temp_pos_peak_inds_fe = temp_pos_peak_inds_fe(5:end)+1;
    temp_pos_peaks = temp_posdata_fe(temp_pos_peak_inds_fe);
    
    % Calculate damping ratio
    for pk_i = 2:length(temp_pos_peaks)
        temp_ratio = 1/(pk_i-1)*log((temp_pos_peaks(1)-temp_equ_fe)/(temp_pos_peaks(pk_i)-temp_equ_fe));
        temp_ksi_fe(pk_i-1) = temp_ratio/(sqrt(4*pi^2+temp_ratio^2));
    end
end


%% Compare FEI Beam and Lumped Parameter Beam

% Reuse figure if it exists, else create new figure
if ~exist('h9_sm_flex_fe_import_beam', 'var') || ...
        ~isgraphics(h9_sm_flex_fe_import_beam, 'figure')
    h9_sm_flex_fe_import_beam = figure('Name', 'sm_flex_fe_import_beam');
end
figure(h9_sm_flex_fe_import_beam)
clf(h9_sm_flex_fe_import_beam)

plot(simlog_dxyz_lpConRod.Values.Time, simlog_dxyz_lpConRod.Values.Data(:,2), 'LineWidth', 1)
hold on
if(temp_enough_peaks_lp)
    plot(temp_postime_lp(temp_pos_peak_inds_lp(2:end)),temp_posdata_lp(temp_pos_peak_inds_lp(2:end)),'bo');
else
    plot(0,0,'bo');
    text(0,0,'Not enough peaks')
end

plot(simlog_dxyz_feConRod.Values.Time, simlog_dxyz_feConRod.Values.Data(:,2), 'LineWidth', 1)
if(temp_enough_peaks_fe)
    plot(temp_postime_fe(temp_pos_peak_inds_fe(2:end)),temp_posdata_fe(temp_pos_peak_inds_fe(2:end)),'ro');
else
    plot(0,0,'ro');
    text(0,0,'Not enough peaks')
end

hold off
legend({'Lumped Par., 30 Elements',['Peaks: \zeta = ' sprintf('%0.5f',mean(temp_ksi_lp))],...
    ' 5 Frames, 40 Dynamic Modes',['Peaks: \zeta = ' sprintf('%0.5f',mean(temp_ksi_fe))]},'Location','Best');
grid on
title('Comparison of Lumped Parameter and Finite Import Beam Models');
ylabel('Tip Deflection (m)');
xlabel('Time (s)');
set(gca,'XLim',[0 tip_force_duration]);

bdclose('sm_flex_lumped_param_beam')
bdclose('sm_flex_fe_import_beam')