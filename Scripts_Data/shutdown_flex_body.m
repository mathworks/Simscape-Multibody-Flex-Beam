% Copyright 2017-2019 The MathWorks, Inc.
FBL_HomeDir = pwd;

curr_proj = simulinkproject;
cd(curr_proj.RootFolder)

cd('Libraries')
if((exist('+forcesPS','dir')==7 && (exist('forcesPS_Lib','file')==4)))
    ssc_clean forcesPS
end
cd(curr_proj.RootFolder)
