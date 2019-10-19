%% Simscape Multibody Flexible Library: Overview
% 
% This Simscape Multibody Flexible Body offers two methods for modeling
% flexible bodies: lumped parameter method and finite element import
% method.  Your use case will determine which method is appropriate for
% you.  
%
% <matlab:web('Flex_Body_Library_Demo_Script.html'); Return to Summary>
% 
%
% *Lumped Parameter Method*
%
% <matlab:web('sm_flex_body_lib_lumped_par_beam.html'); View documentation for lumped parameter model>
%
% This method models the flexible body as a chain of mass-spring-
% dampers.  You specify the cross section of the body, material, and
% number of elements, and MATLAB calculates the necessary parameters and
% constructs the chain of flexible elements.
%
% This method is recommended if:
% 
% # The cross-section of the body does not vary along its length
% # Expected deflection is in the linear range
%
% *Finite Element Method*
%
% <matlab:web('sm_flex_body_lib_fe_import_body.html'); View documentation for finite element model>
%
% This method superimposes superimposes deflection of the body onto rigid
% body motion.  Degrees of freedom are added to the rigid body to model the
% deflection of the body.  Those deflections are used to calculate the
% forces that resist deflection.  That calculation is performed using the
% mass and stiffness matrices of the flexible body, which are often
% calcuated using finite element software.
%
% This method is recommended if:
% 
% # The geometry of the flexible body is complex
% # You have a means of calculating the mass and stiffness matrices for your
% flexible body (usually requires finite element software)
% # The connection points to the rest of the system are known and not
% likely to change.
%
