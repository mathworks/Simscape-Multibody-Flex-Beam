function sm_flex_body_lib_lpar_configure_flextype(b_h,flextype)
% This function configures the number of degrees of freedom for flexible
% elements within lumped parameter beam.

% Copyright 2014-2024 The MathWorks, Inc.

% Source subsystem within library
srcLib = 'sm_flex_body_lib/Lumped Parameter';

% Find Rigid Transform blocks attached to joint that models degrees of
% freedom for flexibility
f    = Simulink.FindOptions('LookUnderMasks','all','FollowLinks',true);
rtf_bDOF_h = Simulink.findBlocks(b_h,'Name','Transform Bending DOF',f);
rtf_haBF_h = Simulink.findBlocks(b_h,'Name','Transform HalfBeamF',f);

if(flextype==1)
    % 1-Axis Bending
    replace_block(b_h,'LookUnderMasks','on','FollowLinks','on','Name','Flex Joint',[srcLib '/Bodies/Revolute Joint'],'noprompt')
    for i=1:length(rtf_bDOF_h)
        set_param(rtf_bDOF_h(i),...
            'RotationMethod','StandardAxis',...
            'RotationStandardAxis','+Y',...
            'RotationAngle','90',...
            'RotationAngleUnits','deg');
    end
    for i=1:length(rtf_haBF_h)
        set_param(rtf_haBF_h(i),...
            'RotationMethod','StandardAxis',...
            'RotationStandardAxis','+Y',...
            'RotationAngle','90',...
            'RotationAngleUnits','deg');
    end
elseif(flextype==2)
    % 3-Axis Bending, Elongation
    replace_block(b_h,'LookUnderMasks','on','FollowLinks','on','Name','Flex Joint',[srcLib '/Bodies/Bearing Joint'],'noprompt')
    for i=1:length(rtf_bDOF_h)
        set_param(rtf_bDOF_h(i),...
            'RotationMethod','None');
    end
    for i=1:length(rtf_haBF_h)
        set_param(rtf_haBF_h(i),...
            'RotationMethod','None');
    end
end

