Simscape Multibody Flexible Body Library
Copyright 2017-2019 The MathWorks, Inc.

This set of files contains a library and examples that show
how to model flexible bodies using Simscape Multibody. 
Please note that the General Flexible Beam block was added
in R2018b and the Reduced Order Flexible Solid block 
was added in R2019b.

Two methods are shown:
  1. Lumped parameter method
     Flexible body is modeled using a chain of mass-spring-dampers.
     User specifies material, beam cross-section, and number
     of flexible elements in the chain.

  2. Finite element import method
     Flexible body is modeled by superimposing deflection on
     rigid body motion.  Additional degrees of freedom are
     added to the rigid body, and the force resisting that
     deflection is calculated using mass and stiffness matrices
     which are often exported from finite element software

Run >> startup_flex_body.m to get started
See the examples to understand how the blocks are used.


#########  Release History  #########  
v 4.0 (R2019b)	Mar 2018      Updated for R2019b
                              Uses MATLAB Project

v 3.4 (R2018b)	Mar 2018      Updated for R2018b

v 3.3 (R2018a)	Mar 2018      Updated for R2018a

v 3.2 (R2017b)	Oct  2017      Damping parameterized with damping factor 
      (R2017a)  Replaced damping coefficient parameter in lumped parameter 
      (R2016b)  beam with damping factor.  This permits damping value to 
                scale with geometry and material.  Damping coefficient
                entered in flexible elements = (damping factor*stiffness).
                                

v 3.1 (R2017b)	Sept  2017     Updated for R2017b

v 3.0 (R2017a)	June  2017     New models and library
                Version number set to match File Exchange

                Library with Lumped Parameter and 
                Finite Element Import beam models
                Two cantilever beam examples and a 
                Slider-crank example are included


                


