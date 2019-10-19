% Copyright 2017-2019 The MathWorks, Inc.
FBL_HomeDir = pwd;
addpath(genpath(pwd))

cd Libraries
if((exist('+forcesPS','dir')==7 && ~(exist('forcesPS_Lib','file')==4)))
    ssc_build forcesPS
end
cd ..

FBL_libname = 'sm_flex_body_lib';
load_system(FBL_libname);
FBL_ver = get_param(FBL_libname,'Description');
disp(FBL_ver);
which(FBL_libname)

web('Flex_Body_Library_Demo_Script.html')