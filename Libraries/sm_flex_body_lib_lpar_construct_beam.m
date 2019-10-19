function sm_flex_body_lib_lpar_construct_beam(b_h,numelem,flextype)
% Support function for Flex_Body element.
% Automatically constructs chain of mass-spring-dampers based on arguments
% in mask of Flex_Body subsystem.

% Copyright 2014-2019 The MathWorks, Inc.

% Save handle to flex beam block
thisblock = b_h;

% Set annotation
anno = sprintf('No of Elem: %s\n%s',num2str(numelem),flextype);
set_param(thisblock, 'AttributesFormatString',anno);

% Load model where elements are saved
srcLib = 'sm_flex_body_lib';
load_system(srcLib);

if numelem <1
    error('Number of Flexible elements should be greater than 0')
end

% Get number of digits for element name
% Element names will be padded with zeros to ensure sorting order
numDigits = length(num2str(floor(numelem)));

% Check for existing blocks for linearizable beam
in_h = find_system(thisblock,'LookUnderMasks','all','SearchDepth',1,'BlockType','Inport');
out_h = find_system(thisblock,'LookUnderMasks','all','SearchDepth',1,'BlockType','Outport');
mxc_h = find_system(thisblock,'LookUnderMasks','all','SearchDepth',1,'BlockType','Concatenate');

% If existing chain of elements has a different length than request,
% or if the linearization configuration has changed, rebuild chain.
prev_flex_bod = find_system(thisblock,'LookUnderMasks','all','FollowLinks','on','RegExp','on','Name','Flex_Elem_*');
prev_transformF = find_system(thisblock,'LookUnderMasks','all','FollowLinks','on','RegExp','on','Name','Transform.*PortF');
if ((~isempty(prev_flex_bod) && length(prev_flex_bod) ~= numelem))
    
    delete_block(prev_flex_bod(1:end))
    delete_block(prev_transformF)
    
    flex_elem_src = [srcLib '/Lumped Parameter/Bodies/Flex_Element'];
    
    % Delete lines
    linehan = find_system(thisblock,'LookUnderMasks','all','FollowLinks','on','FindAll','on','type','line');
    if ~isempty(linehan)
        delete_line(linehan)
    end
    
    % Create Multibody Connection Port
    blk_or = [105 155 140 195];
    set_param([thisblock '/B'],'Position',blk_or)
    
    % Create and connect first rigid transform
    set_param([thisblock '/' sprintf('Transform\nBeamX')],'Position',blk_or+[80 0 80 0])
    add_line(thisblock,['B/Rconn1'],[sprintf('Transform\nBeamX') '/Lconn1'],'autorouting','on');
    
    % Add and connect first flexible element
    % Flexible element saved in separate model file
    elem_name_prefix = repmat('0',1,numDigits-1);
    be_h=add_block(flex_elem_src,[thisblock '/Flex_Elem_' elem_name_prefix '1'],'Position',blk_or+[80 0 80 0]*2);
    add_line(thisblock,[sprintf('Transform\nBeamX') '/Rconn1'],['Flex_Elem_' elem_name_prefix '1' '/Lconn1'],'autorouting','on');
    
    % Add and connect remainder of flexible elements
    %numelem_per_row = 20;
    numelem_per_row = ceil(sqrt(numelem));
    if (numelem>1)
        for i = 2:1:numelem
            %disp(['Num elem = ' num2str(i)]);
            elem_name_prefix = repmat('0',1,numDigits-length(num2str(i)));
            elem_x = mod(i,numelem_per_row);
            elem_y = floor(i/numelem_per_row);
            add_block(flex_elem_src,[thisblock '/Flex_Elem_' elem_name_prefix num2str(i)],'Position',blk_or+(elem_x+1)*[80 0 80 0]+(elem_y)*[0 80 0 80])
            elem_name_prefix_prev = repmat('0',1,numDigits-length(num2str(i-1)));
            add_line(thisblock,['Flex_Elem_' elem_name_prefix_prev num2str(i-1) '/Rconn1'],['Flex_Elem_' elem_name_prefix num2str(i) '/Lconn1'],'autorouting','on');
        end
    else % only one element
        i=1;
    end
    
    % Create and connect last rigid transform (orient as starting frame)
    add_block('sm_lib/Frames and Transforms/Rigid Transform',[thisblock '/TransformPortF'],'Position',blk_or+(numelem_per_row+2)*[80 0 80 0])
    %set_param([thisblock '/' sprintf('Transform\nBeamF')],'Position',blk_or+(numelem+2)*[80 0 80 0])
    add_line(thisblock,['Flex_Elem_' elem_name_prefix num2str(i) '/Rconn1'],[sprintf('TransformPortF') '/Lconn1'],'autorouting','on');
    
    % Add F Port
    set_param([thisblock '/F'],'Position',blk_or+(numelem_per_row+3)*[80 0 80 0]);
    add_line(thisblock,[sprintf('TransformPortF') '/Rconn1'],['F/Rconn1'],'autorouting','on');
    
    set_param([thisblock '/TransformPortF'],...
        'Name',sprintf('Transform\nPortF'),...
        'RotationMethod','StandardAxis',...
        'RotationStandardAxis','+Y',...
        'RotationAngle','-90',...
        'RotationAngleUnits','deg');
    
end

% Set flexibility type
flex_elem_h = find_system(b_h,'regexp','on','LookUnderMasks','on','FollowLinks','on','Name','Flex_Elem_.*');
for fei = 1:length(flex_elem_h)
    set_param(flex_elem_h{fei},'radio_flextype_elem',flextype)
end

