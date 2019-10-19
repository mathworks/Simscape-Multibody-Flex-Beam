% Code to plot simulation results from sm_flex_lumped_param_beam
%% Plot Description:
%
% The plot below shows the comparison between the tip deflection of a beam
% modeled using lumped parameter as the number of elements is varied. 
%
% Copyright 2017-2019 The MathWorks, Inc.

mdl = bdroot;

% Save current values for damping and number of elements
temp_numelem = get_param([mdl '/Flexible Beam'],'numelem');
temp_damping = get_param([mdl '/Flexible Beam'],'edf_beam');

% Ensure damping is high for static deflection calculation
set_param([mdl '/Flexible Beam'],'edf_beam',[temp_damping '*100']);

% Configure model to load beam using gravity
sm_flex_lumped_param_beam_configure_load(mdl,'Gravity');

% Theoretical value of static deflection
staticDefl_def = 0.0191;

% Run simulation for each desired number of elements
% and record deflection at conclusion of simulation
temp_vectornumelem = [5:5:30];
for temp_i = 1:length(temp_vectornumelem)
    num_elem = temp_vectornumelem(temp_i);
    set_param([mdl '/Flexible Beam'],'numelem',num2str(num_elem));
    sim(mdl)
    temp_tipDeflection = logsout_sm_flex_lumped_param_beam.get('dxyz');
    temp_sdef(temp_i) = temp_tipDeflection.Values.Data(end,2);
end

% Reuse figure if it exists, else create new figure
if ~exist('h3_sm_flex_lumped_param_beam', 'var') || ...
        ~isgraphics(h3_sm_flex_lumped_param_beam, 'figure')
    h3_sm_flex_lumped_param_beam = figure('Name', 'sm_flex_lumped_param_beam');
end
figure(h3_sm_flex_lumped_param_beam)
clf(h3_sm_flex_lumped_param_beam)

% Plot results
plot(temp_vectornumelem,temp_sdef,'Marker','o')
hold on
plot([0 max(temp_vectornumelem)],[-1 -1]*staticDefl_def ,'k--','LineWidth', 1)
hold off
grid on
ylabel('Deflection (m)');
set(gca,'YLim',[-round(1.1*staticDefl_def,2,'significant') 0]);

title('Static Deflection from Lumped Parameter Model');
xlabel('Number of Elements')

legend({'Simulation','Theory'},'Location','Best');

% Reset model to initial values for damping and number of elements
set_param([mdl '/Flexible Beam'],'edf_beam',temp_damping);
set_param([mdl '/Flexible Beam'],'numelem',temp_numelem);

% Remove temporary variables
clear simlog_handles
clear temp_i temp_numelem temp_sdef temp_vectornumelem

