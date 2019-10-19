curr_proj = simulinkproject;
SMF_HomeDir = curr_proj.RootFolder;
%fileparts(which('startup_flex_body.m'));

cd([SMF_HomeDir filesep 'Scripts_Data' filesep 'Doc']);
publish_flex_body_html
cd([SMF_HomeDir filesep 'Libraries' filesep 'html']);
publish_flex_body_html
cd([SMF_HomeDir filesep 'Examples' filesep 'Simple' filesep 'html']);
publish_flex_body_html
cd([SMF_HomeDir filesep 'Examples' filesep 'Slider_Crank' filesep 'html']);
publish_flex_body_html

function publish_flex_body_html
filelist_m=dir('*.m');

filenames_m = {filelist_m.name};

warning('off','Simulink:Engine:MdlFileShadowedByFile');

for i=1:length(filenames_m)
    if ~(strcmp(filenames_m{i},'publish_all_html.m'))
    publish(filenames_m{i},'showCode',false)
    end
end
end