SMF_HomeDir = fileparts(which('startup_flex_body.m'));

cd([SMF_HomeDir filesep 'Scripts_Data' filesep 'Doc']);
publish_all_html
cd([SMF_HomeDir filesep 'Libraries' filesep 'html']);
publish_all_html
cd([SMF_HomeDir filesep 'Examples' filesep 'Simple' filesep 'html']);
publish_all_html
cd([SMF_HomeDir filesep 'Examples' filesep 'Slider_Crank' filesep 'html']);
publish_all_html
