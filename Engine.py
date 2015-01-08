#import glpk
import Problem
import time
import datetime
from collections import defaultdict
import subprocess

class Engine:
  
  def __init__(self,rows):
    print "engine initiated"
    p = Problem.Problem(rows)
    p.LoadProblem(rows)
    self.CreateInputFile()
    self.createInputFileGams()
    
  def createInputFileGams(self):         
    filenames = ['Model/constant.inc', 'Model/variable.inc']
    with open('Model/model.inc', 'w') as outfile:
      for fname in filenames:
	with open(fname) as infile:
	  for line in infile:
	    outfile.write(line)
	

  def CreateInputFile(self):         
    filenames = ['Model/constant.dat', 'Model/variable.dat']
    with open('Model/model.dat', 'w') as outfile:
      for fname in filenames:
	with open(fname) as infile:
	  for line in infile:
	    outfile.write(line)
    

  def solveGLPK(self,pr):
    print "Solving problem..."
    #capture = subprocess.check_output(["glpsol", "--math", "Model/model.mod", "--data", "Model/model.dat", "--tmlim","60", "--write", "Output/write.out"])
    subprocess.call(["glpsol", "--math", "Model/model.mod", "--data", "Model/model.dat", "--tmlim","360", "--output", "Output/output.out", "--write", "Output/write.out"])
    #subprocess.call(["glpsol", "--math", "Model/model.mod", "--data", "Model/model.dat", "--output", "Output/output.out", "--write", "Output/write.out"])
    return pr.solution()

  def solveGams(self):
    filename="Model/model.gms"
    subprocess.call(["gams",  filename])