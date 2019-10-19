% Code to plot simulation results from sm_flex_lumped_param_beam
%% Plot Description:
%
% The plot below shows the vertical deflection of the tip of the beam.
%
% Copyright 2017-2019 The MathWorks, Inc.

% Generate simulation results if they don't exist
if ~exist('simlog_sm_flex_lumped_param_beam', 'var')
    sim('sm_flex_lumped_param_beam')
end

% Reuse figure if it exists, else create new figure
if ~exist('h1_sm_flex_lumped_param_beam', 'var') || ...
        ~isgraphics(h1_sm_flex_lumped_param_beam, 'figure')
    h1_sm_flex_lumped_param_beam = figure('Name', 'sm_flex_lumped_param_beam');
end
figure(h1_sm_flex_lumped_param_beam)
clf(h1_sm_flex_lumped_param_beam)

temp_colororder = get(gca,'defaultAxesColorOrder');

% Get simulation results
simlog_dxyz = logsout_sm_flex_lumped_param_beam.get('dxyz');

% Calculate damping ratio
% Obtain equilibrium value
temp_ind_0p80pulse = find(simlog_dxyz.Values.Time<=(tip_force_duration*0.8),1,'last');
temp_ind_0p99pulse = find(simlog_dxyz.Values.Time<(tip_force_duration*0.99),1,'last');
temp_equ = mean(simlog_dxyz.Values.Data(temp_ind_0p80pulse:temp_ind_0p99pulse,2));

% Find peaks
temp_ind_start = 1;
temp_ind_finish = find(simlog_dxyz.Values.Time<=(tip_force_duration*0.5),1,'last');
temp_ind_set = [temp_ind_start:temp_ind_finish];
temp_posdata = simlog_dxyz.Values.Data(temp_ind_set,2);
temp_postime = simlog_dxyz.Values.Time(temp_ind_set);
temp_pos_peak_inds = find(diff(sign(diff(temp_posdata)))<0);

if(length(temp_pos_peak_inds)<6)
    temp_enough_peaks = 0;
    temp_ksi = 0;
else
    temp_enough_peaks = 1;
    temp_pos_peak_inds = temp_pos_peak_inds(5:end)+1;
    temp_pos_peaks = temp_posdata(temp_pos_peak_inds);
    
    % Calculate damping ratio
    for pk_i = 2:length(temp_pos_peaks)
        temp_ratio = 1/(pk_i-1)*log((temp_pos_peaks(1)-temp_equ)/(temp_pos_peaks(pk_i)-temp_equ));
        temp_ksi(pk_i-1) = temp_ratio/(sqrt(4*pi^2+temp_ratio^2));
    end
end

% Plot results
plot(simlog_dxyz.Values.Time, simlog_dxyz.Values.Data(:,2), 'LineWidth', 1)
if(temp_enough_peaks)
    hold on
    plot(temp_postime(temp_pos_peak_inds(2:end)),temp_posdata(temp_pos_peak_inds(2:end)),'go');
    hold off
else
    hold on
    plot(0,0,'go');
    hold off
    text(0,0,'Not enough peaks')
end
grid on
title('Vertical Deflection of Beam Tip')
ylabel('Deflection (m)')
legend({'Tip Deflection',['Peaks: \zeta = ' sprintf('%0.5f',mean(temp_ksi))]})

xlabel('Time (s)')

% Remove temporary variables
clear simlog_t simlog_handles temp_colororder
clear simlog_dxyz temp_ksi
clear temp_equ temp_posdata temp_postime
clear temp_ind_start temp_ind_finish temp_ind_set
clear temp_pos_peak_inds temp_pos_peaks
clear temp_ind_4s temp_ind_5s
clear temp_ratio

