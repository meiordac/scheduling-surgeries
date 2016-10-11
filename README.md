# Models for scheduling surgeries #

The purpose of this paper is to study the use of mathematical models for scheduling
elective surgeries and to derive guidelines from the results of these models. With the aim
of improving the quality of service delivered, we proposed the development of mathematical
programming models using different methodologies including the formulation of
a mixed integer linear model which we solved in order to obtain the optimal allocation
of resources involved.

### How do I get set up? ###

* You need to install the library glpk (GNU Linear Programming Kit) in case you want to use this library or GAMS, I've implemented models for these two.
* All the input is in Excel files, in the input folder, the program reads them and passes them to the engine, and prepares the files for the solvers (depending on which one you are going to use).
* Run the main.py, this is the main file and has the main method which runs everything else.
