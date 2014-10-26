import glpk
import time
import datetime
from collections import defaultdict
import subprocess

class Engine:
  
  def __init__(self):
    print "engine initiated"
    
  def LoadPatients(self,rows):
    #se carga la lista de pacientes que seran procesados
    f = open('Model/variable.dat', 'w+')
    f.write('\nset patients := ')
    for r in rows:
      f.write(str(int(r['Patient']))+' ')
    f.write(';\n')
    f.write('\nparam waitingPeriod := ')
    for r in rows:
      waitingPeriod=datetime.datetime.now() -datetime.datetime.strptime((r['Date']), "%Y-%m-%d") 
      f.write(str(int(r['Patient']))+' '+str(waitingPeriod.days) +'\n')
    f.write(';\n')
    f.write('\nparam ges := ')
    for r in rows:
      f.write(str(int(r['Patient']))+' '+str(int(r['GES']))+'\n')
    f.write(';\n')
    f.write('\nparam surgeryLength := ')
    for r in rows:
      f.write(str(int(r['Patient']))+' '+str(r['SurgeryLength'])+'\n')
    f.write(';')
    f.close()
    
  def CreateInputFile(self):    
  #se crea el archivo de input final que junta el modelo.dat (parametros fijos) y los parametros variables      
    filenames = ['Model/constant.dat', 'Model/variable.dat']
    with open('Model/model.dat', 'w') as outfile:
      for fname in filenames:
	with open(fname) as infile:
	  for line in infile:
	    outfile.write(line)
    
  def LoadProblem(self,rows):
    self.LoadPatients(rows)
    self.CreateInputFile()
    #se crea el problema y se le pasan el modelo y el .dat
    pr = glpk.glpk("Model/model.mod","Model/model.dat")
    #cuenta la cantidad de pacientes de tipo p y los agrega al arreglo countPatients
    countPatients = defaultdict(int)
    for r in rows:
      countPatients[r['PatientType']] += 1  
    #entrega al parametro numPatients{p} la cantidad de pacientes de ese tpo
    for p in range(1,len(countPatients)+1):
      pr.numPatients[p] = countPatients[p]
    
    return pr
 
  def Solve(self,pr):
    print "Solving problem..."
    #capture = subprocess.check_output(["glpsol", "--math", "Model/model.mod", "--data", "Model/model.dat", "--tmlim","60", "--write", "Output/write.out"])
    #subprocess.call(["glpsol", "--math", "Model/model.mod", "--data", "Model/model.dat", "--tmlim","60", "--write", "Output/write.out"])
    subprocess.call(["glpsol", "--math", "Model/model.mod", "--data", "Model/model.dat", "--tmlim","60", "--output", "Output/output.out"])
    return pr.solution()
    

    