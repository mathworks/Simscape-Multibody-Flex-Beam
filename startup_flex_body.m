% Copyright 2017 The MathWorks, Inc.
addpath(genpath(pwd))

cd Libraries
if((exist('+forcesPS','dir')==7 && ~(exist('forcesPS_Lib','file')==4)))
    ssc_build forcesPS
end
cd ..

web('Flex_Body_Library_Demo_Script.html')