# **Simscape Multibody Flexible Body Library**
Copyright 2017-2020 The MathWorks(TM), Inc.

[![View Flexible Body Models in Simscape Multibody on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/47051-flexible-body-models-in-simscape-multibody)

This set of files contains a library and examples that show
how to model flexible bodies using Simscape Multibody. 

**Please note that the General Flexible Beam block was added
in R2018b and the Reduced Order Flexible Solid block 
was added in R2019b. You should see if these blocks meet 
your needs before using this library**

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

Open Flexible_Body_Library.prj to get started
See the examples to understand how the blocks are used.

#########  Release History  #########  

**v4.0 Mar 2018** (R2019b)
1. Updated for R2019b. Uses MATLAB Project

**v3.4 Mar 2018** (R2018b)	
1. Updated for R2018b

**v3.3 Mar 2018** (R2018a)
1. Updated for R2018a

**v3.2 Oct 2017**(R2016b - R2017b)
1. Damping parameterized with damping factor 
   Replaced damping coefficient parameter in lumped parameter 
   beam with damping factor.  This permits damping value to 
   scale with geometry and material.  Damping coefficient
   entered in flexible elements = (damping factor*stiffness).
                                
**v3.1 Sept 2017** (R2017b)
1. Updated for R2017b

**v3.0 June  2017** (R2017a)	
1. New models and library
2. Version number set to match File Exchange
3. Library with Lumped Parameter and Finite Element Import beam models
   Two cantilever beam examples and a Slider-crank example are included
