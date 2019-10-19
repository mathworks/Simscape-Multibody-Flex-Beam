% Calculate natural frequencies and mode shapes for flexible beam
% with one fixed end and one free end

% Copyright 2014-2019 The MathWorks, Inc.

mdl = 'sm_flex_lumped_param_beam';
flexbeam_h = [mdl '/Flexible Beam'];

% Save current values for damping, number of elements,
% and flexibility type
temp_damping = get_param(flexbeam_h,'edf_beam');
temp_numelem = get_param(flexbeam_h,'numelem');
temp_ftype   = get_param(flexbeam_h,'radio_flextype');

% Ensure damping is zero for mode calculation
% Set number of elements to 20 for plots
% Set flexibility type to bending within XY-plane
set_param(flexbeam_h,'edf_beam','0');
set_param(flexbeam_h,'numelem','20');
set_param(flexbeam_h,'radio_flextype','Rotation: Z')

% Determine flexible element length
element_length = str2num(get_param(flexbeam_h,'elem_length'));

% Find inputs and outputs for linearization
set_param(mdl,'SimulationCommand','update')
sys_io = getlinio(mdl);             

% Get state order for beam
state_order = sm_flex_body_lib_lpar_getstateorder(flexbeam_h);

% Linearize the model
linsys1 = linearize(mdl,sys_io,'StateOrder',state_order);    

% Find states of interest
w_state_inds = find(~cellfun(@isempty,strfind(linsys1.StateName,'.Rz.w')));
q_state_inds = find(~cellfun(@isempty,strfind(linsys1.StateName,'.Rz.q')));

% Get eigenvalues
lambda1 = eig(linsys1.a);           % Get eigenvalues (complex)
natural_freq = unique(abs(lambda1(w_state_inds))/(2*pi)); % Freq in Hz
%disp('Modes (Hz):');
sprintf('Modes (Hz):\n  %0.3f\n  %0.3f\n  %0.3f\n  %0.3f\n  %0.3f ',natural_freq(1:5));

% Get eigenvectors
[V, D] = eigs(linsys1(end,end).a,8,'sm');

%% Reuse figure if it exists, else create new figure
if ~exist('h4_sm_flex_lumped_param_beam', 'var') || ...
        ~isgraphics(h4_sm_flex_lumped_param_beam, 'figure')
    h4_sm_flex_lumped_param_beam = figure('Name', 'sm_flex_lumped_param_beam');
end
figure(h4_sm_flex_lumped_param_beam)
clf(h4_sm_flex_lumped_param_beam)

% Construct and plot mode shapes
for mode_num = 1:4
    % Find joint angle values within each eigenvector
    if abs(abs(imag(V(q_state_inds(1),2*mode_num))/abs(V(q_state_inds(1),2*mode_num)))-1)<1e-3
        joint_ang = imag(V(q_state_inds,2*mode_num)); 
    else
        joint_ang = real(V(q_state_inds,2*mode_num)); 
    end
    % Angle of current element with respect to horizontal
    % is sum of all angles between element and wall
    theta = cumsum(joint_ang);     
    
    % y-displacement of element = y-disp.of previous element + 1*sin(theta)
    y_mode = zeros(size(q_state_inds));
    for i = 2:length(q_state_inds)
        y_mode(i) = y_mode(i-1) + element_length*sin(theta(i-1));
    end
    subplot(2,2,mode_num)
    plot(y_mode,'LineWidth',2)
    title(['Mode Shape ' num2str(mode_num)]);
    text(0.05,0.1,['\bf\omega_{n}\rm = ' num2str(natural_freq(mode_num)) ' Hz'],...
        'Units','Normalized');
end

%% Reset damping value, number of elements, and flexibility type
set_param([mdl '/Flexible Beam'],'edf_beam',temp_damping);
set_param([mdl '/Flexible Beam'],'radio_flextype',temp_ftype)
set_param([mdl '/Flexible Beam'],'numelem',temp_numelem)

clear temp_damping temp_type temp_numelem theta y_mode joint_ang

