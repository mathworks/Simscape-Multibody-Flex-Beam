% Code to plot simulation results from sm_flex_slider_crank
%% Plot Description:
%
% The plot below shows the deflection of the connecting rod midpoint
% relative to the ends.
%
% Copyright 2017-2019 The MathWorks, Inc.

% Generate simulation results if they don't exist
if ~exist('simlog_sm_flex_slider_crank', 'var')
    sim('sm_flex_slider_crank')
end

% Check for data before creating figure
try
    temp_rodChildids = simlog_sm_flex_slider_crank.Rod.childIds;
catch
    error('No flexible frames in connecting rod');
end


% Reuse figure if it exists, else create new figure
if ~exist('h1_sm_flex_slider_crank', 'var') || ...
        ~isgraphics(h1_sm_flex_slider_crank, 'figure')
    h1_sm_flex_slider_crank = figure('Name', 'sm_flex_slider_crank');
end
figure(h1_sm_flex_slider_crank)
clf(h1_sm_flex_slider_crank)

temp_colororder = get(gca,'defaultAxesColorOrder');

% Get simulation results
simlog_dxyz = logsout_sm_flex_slider_crank.get('rod_dxyz');
simlog_rodlen = logsout_sm_flex_slider_crank.get('rod_length');

% Logic to find Bushing Joint associated with end frames
% Paths depend on beam model selection and configuration of interface frame
simlog_rod_data = simlog_sm_flex_slider_crank.Rod.(char(temp_rodChildids));
temp_frameIds = simlog_rod_data.childIds;
temp_sortedFrameIds = sort(simlog_rod_data.childIds);

if (strncmpi(temp_sortedFrameIds{1},'Frame',5))
    % FEI Beam
    % Deflection of midpoint = sum(Deflection of endpoints from midpoint)/2
    simlog_t = simlog_rod_data.(temp_sortedFrameIds{1}).Flex.Bushing_Joint.Py.p.series.time;
    simlog_fBy = simlog_rod_data.(temp_sortedFrameIds{1}).Flex.Bushing_Joint.Py.p.series.values('m');
    simlog_fFy = simlog_rod_data.(temp_sortedFrameIds{end}).Flex.Bushing_Joint.Py.p.series.values('m');
    simlog_midpoint_deflection = (simlog_fBy+simlog_fFy)/2;
else
    % Lumped Parameter Beam
    % Sum y contribution to deflection by each element from end to midpoint
    temp_jointChildIds = simlog_rod_data.(temp_sortedFrameIds{1}).Flex_Joint.childIds;
    
    % Pick logged field name based on joint type
    if(find(strcmp(temp_jointChildIds,'Rx')))
        % Bending X-Y-Z, Elongation Z - use Rx
        DofField = 'Rx';
    else
        % Bending Z - use Rz
        DofField = 'Rz';
    end
    
    % Get joint deflection angles through midpoint
    simlog_t = simlog_rod_data.(temp_sortedFrameIds{1}).Flex_Joint.(DofField).q.series.time;
    
    simlog_Rq = [];
    for i=1:floor(length(temp_sortedFrameIds)/2)
        simlog_Rq(:,i) = simlog_rod_data.(temp_sortedFrameIds{i}).Flex_Joint.(DofField).q.series.values('deg');
    end
    
    % Get angle of first half-element
    simlog_qR1 = atand(simlog_dxyz.Values.Data(:,2)./simlog_rodlen.Values.Data);
    
    % Angle of each element is cumulative sum of angles of previous joints
    simlog_Rqall = [simlog_qR1 simlog_Rq];
    cumSum_q = cumsum(simlog_Rqall');
    
    % Get length of element
    temp_elemlength = str2num(get_param('sm_flex_slider_crank/Rod/Lumped Parameter','elem_length'));

    % Adjust calculation based on number of elements
    if (mod(length(temp_sortedFrameIds), 2) == 0)
        % Even: midpoint of beam is between joints
        % Only multiple last angle by half of element length
        elem_len_vect = [ones(size(cumSum_q,1)-1,1);0.5]*temp_elemlength;
    else
        % Odd: midpoint of beam is at a flex joint
        elem_len_vect = [ones(size(cumSum_q,1),1)]*temp_elemlength;
    end
    
    % Sum y-deflection from first flex joint to midpoint
    cumSum_dy = sum(sind(cumSum_q).*elem_len_vect);
    
    % Get y-deflection from first half element
    halfelem1_dy = sind(simlog_qR1')*temp_elemlength/2;
    
    % Sum to obtain midpoint deflection
    simlog_midpoint_deflection = (cumSum_dy+halfelem1_dy);
end

% Plot results
plot(simlog_t, simlog_midpoint_deflection, 'LineWidth', 1)
grid on
title('Deflection of Connecting Rod Midpoint')
ylabel('Deflection (m)')

xlabel('Time (s)')

% Remove temporary variables
clear simlog_t simlog_handles temp_colororder
clear simlog_Rq simlog_qR1 simlog_Rqall
clear simlog_dxyz simlog_fBy simlog_fFy
clear temp_frameIds temp_sortedFrameIds
clear simlog_midpoint_deflection simlog_rod_data simlog_rodlen
clear temp_elemlength temp_jointChildIds temp_rodChildids
clear halfelem1_dy cumSum_dy cumSum_q elem_len_vect

