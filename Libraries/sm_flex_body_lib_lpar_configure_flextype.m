function sm_flex_body_lib_lpar_configure_flextype(b_h,flextype)
% This function configures the number of degrees of freedom for flexible
% elements within lumped parameter beam.

% Copyright 2014-2019 The MathWorks, Inc.

% Source subsystem within library
srcLib = 'sm_flex_body_lib/Lumped Parameter';

% Find Rigid Transform blocks attached to joint that models degrees of
% freedom for flexibility
rtf_bDOF_h = find_system(b_h,'LookUnderMasks','on','FollowLinks','on','Name','Transform Bending DOF');
rtf_haBF_h = find_system(b_h,'LookUnderMasks','on','FollowLinks','on','Name','Transform HalfBeamF');

if(flextype==1)
    % 1-Axis Bending
    replace_block(b_h,'LookUnderMasks','on','FollowLinks','on','Name','Flex Joint',[srcLib '/Bodies/Revolute Joint'],'noprompt')
    for i=1:length(rtf_bDOF_h)
        set_param(rtf_bDOF_h{i},...
            'RotationMethod','StandardAxis',...
            'RotationStandardAxis','+Y',...
            'RotationAngle','90',...
            'RotationAngleUnits','deg');
    end
    for i=1:length(rtf_haBF_h)
        set_param(rtf_haBF_h{i},...
            'RotationMethod','StandardAxis',...
            'RotationStandardAxis','+Y',...
            'RotationAngle','90',...
            'RotationAngleUnits','deg');
    end
elseif(flextype==2)
    % 3-Axis Bending, Elongation
    replace_block(b_h,'LookUnderMasks','on','FollowLinks','on','Name','Flex Joint',[srcLib '/Bodies/Bearing Joint'],'noprompt')
    for i=1:length(rtf_bDOF_h)
        set_param(rtf_bDOF_h{i},...
            'RotationMethod','None');
    end
    for i=1:length(rtf_haBF_h)
        set_param(rtf_haBF_h{i},...
            'RotationMethod','None');
    end
end

