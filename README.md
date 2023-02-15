# Self-Adaptive Complex Root Tracing Algorithm

##### Programming language: MATLAB

[![Version](https://img.shields.io/badge/version-1.0-green.svg)](README.md) [![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)

---
## Program goals
The Self-Adaptive Complex Root Tracing Algorithm (**SACRTA**) aims to **follow the zero or pole of the complex function as a function of an additional parameter** (belonging to the real numbers). The main establishment of this approach is used in the **generalization of Cauchy's Argument Principle** in the discretization version with self-adaptive modifications.

In many fields of science, it is crucial to accomplish complex root calculations. Primarily the program is dedicated and optimized in computational electrodynamics. Ordinarily, the zero/poles represent the propagation coefficient, but the flexible approach enables one to solve similar problems that occur, e.g., in acoustics, control theory, or quantum mechanics (the overall class of functions can be analyzed).

## Solution method
The function should be defined in the [fun.m](2_cylindrical_waveguide/fun.m) at the beginning of the process. In order to start the procedure, an **initial point** (representing zero/pole) on the complex plane is required. This root, for the starting value of the additional parameter, can be obtained with any root searching algorithm (recommend using [GRPF](https://ieeexplore.ieee.org/document/10025853) [code](https://github.com/PioKow/SAGRPF)). After that, the user sets the extent of variability of the extra parameter and the chain edges length (corresponding to accuracy) in the [analysis_parameters.m](2_cylindrical_waveguide/analysis_parameters.m).

In the first step of the algorithm, the initial point is surrounded by an equilateral triangle. Next, the suspect edge is selected based on Self-Adaptive DCAP (**it does not require the function's derivative and integration over the contour**), and a new point is introduced: the fourth vertex of the regular tetrahedron. In this way, the extra parameter of the analysis is changed, **represented by the z-coordinate in the vertexes**. Based on the candidate edge, a face is chosen that becomes the basis for a new tetrahedron. This procedure which means adding the new point and selecting the face (creating a new tetrahedron), is repeated until the final value of the additional parameter is reached.


## Scientific work
If the code is used in a scientific work, then **reference should be made to the following publication**:
1. S. Dziedziewicz, R. Lech and P. Kowalczyk, "**A Self-Adaptive Complex Root Tracing Algorithm for the Analysis of Propagation and Radiation Problem**," in _IEEE Transactions on Antennas and Propagation_, vol. 69, no. 8, pp. 5171-5174, Aug. 2021, doi: 10.1109/TAP.2021.3060047. [link](https://ieeexplore.ieee.org/document/9362232)

---
## Manual
1. **[SACRTA.m](SACRTA.m) - starts the program**
2. [analysis_parameters.m](1_graphene_transmission_line/analysis_parameters.m) - contains all parameters of the analysis, e.g.:
    * start root: (**zStart**)
	* range of the extra parameter: (**tStart**,**tFinal**)
    * accuracy: (**a**)
	* advanced settings:
		- optional fun parameters e.g scale the extra parameter: (**Optional**)
		- orientation of the initial triangle on the complex plane: (**InitRotation**) 
	* buffers: (**MaxInitNodes**, **NodesMax**)
3. [fun.m](1_graphene_transmission_line/fun.m) - definition of the function for which roots and poles will be calculated
4. **to run examples**: add folder **uncomment line 23 or 24 in the [SACRTA.m](SACRTA.m) (addpath)** in order to include the folder with (analysis_parameters.m) and (fun.m) files or copy them from the folder containing the example to the main folder and start SAGRPF program.
 
## Short description of the functions
- [SACRTA.m](SACRTA.m) - main body of the algorithm  
	- [analysis_parameters.m](1_graphene_transmission_line/analysis_parameters.m) - analysis parameters definition
	- [fun.m](1_graphene_transmission_line/fun.m) - function definition
	- [vinq.m](vinq.m) - converts the function value into proper quadrants
	- [CAP_triangle.m](CAP_triangle.m) - verifies the change quadrant number in equilateral triangle contour
	- [CAP_tetrahedron.m](CAP_tetrahedron.m) - verifies the change quadrant number in equilateral tetrahedron contour
	- [set_new_nodes.m](set_new_nodes.m) - divides the segments in half and extends the node vectors with new indices
	- [vis.m](vis.m) - results visualization, plots the curve of the roots

## Additional comments
The algorithm works efficiently when the **traced characteristic has a single path form**. However, when the curve bifurcates, the algorithm is not suited to look for multiple roots value in a single tetrahedron due to the lack of termination condition. Generally, it is possible to detect multiple roots on any face of a tetrahedron. The algorithm signalizes this situation but **automatically proceeds with a single root tracing**. After completing the first path, it is possible to return to the second root by manually starting a new analysis, with the starting point being the branch location. **The shape of the path is influenced by the rotation of the initial triangle**. A user can control this parameter by changing the **InitRotation** variable (setting angle in the radians). For more details, please see the following communication indicating the possible way of analysing multipath root tracing.
1. S. Dziedziewicz, M. Warecka, R. Lech and P. Kowalczyk, "**Multipath Complex Root Tracing,**" 2022 _24th International Microwave and Radar Conference (MIKON)_, Gdansk, Poland, 2022, pp. 1-4, doi: 10.23919/MIKON54314.2022.9924911. [link](https://ieeexplore.ieee.org/document/9924911)
## Authors
The project has been developed in **Gdansk University of Technology**, Faculty of Electronics, Telecommunications and Informatics by **Sebastian Dziedziewicz, Rafał Lech, Małgorzata Warecka, Piotr Kowalczyk** ([Department of Microwave and Antenna Engineering](https://eti.pg.edu.pl/en/kima-en)). 

Corresponding e-mail: sebastian.dziedziewicz@pg.edu.pl

## License
GRPF is an open-source Matlab code licensed under the [MIT license](LICENSE).
