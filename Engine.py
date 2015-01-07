#import glpk
import time
import datetime
from collections import defaultdict
import subprocess

class Engine:
  
  def __init__(self):
    print "engine initiated"
	
  def loadPatientsGams(self,rows):
    f = open('Model/variable.inc', 'w+')
    f.write('\n \n set p patients /')
    f.write(str(int(rows[0]['Patient']))+"*"+str(int(rows[len(rows)-1]['Patient'])))
    f.write('/ ;\n')
    f.write('\n parameter waitingPeriod(p) / ')
    for r in rows:
      waitingPeriod=datetime.datetime.now() -datetime.datetime.strptime((r['Date']), "%Y-%m-%d") 
      f.write(str(int(r['Patient']))+' '+str(waitingPeriod.days) +'\n')
    f.write('/ ; \n')
    self.addParameterGams(rows, f, 'Patient', 'ges','p')
    self.addParameterGams(rows, f, 'Patient', 'reInterventions','p')
    self.addParameterGams(rows, f, 'Patient', 'surgeryLength','p')
    self.addParameterGams(rows, f, 'Patient', 'anesthesiaType','p')
    self.addParameterGams(rows, f, 'Patient', 'surgeryTypePatient','p')

    #cuenta la cantidad de pacientes de tipo p y los agrega al arreglo countPatients
    countPatients = defaultdict(int)
    for r in rows:
      countPatients[r['surgeryTypePatient']] += 1  
    #entrega al parametro numPatients{p} la cantidad de pacientes de ese tpo
    f.write('\n parameter numPatients(st) /')
    for cp in range(1,len(countPatients)+1):
      f.write(str(cp)+' '+str(countPatients[cp])+'\n')
    f.write('/ ;') 
    f.write('\n table matrixPatientType(p,st) '+'\n	')
    for cp in range(1,len(countPatients)+1):
      f.write(str(cp)+' ')
	
    for r in rows:
	  f.write('\n'+str(int(r['Patient'])) +'	')
	  for cp in range(1,len(countPatients)+1):
	    f.write(str(int(cp==int(r['surgeryTypePatient'])))+' ')
    f.write(' ;') 
	
    f.close()
    
  def addParameterGams(self,rows, f, num, parameter, charParameter):
    f.write('\n parameter '+parameter+ '('+charParameter+') /')
    for r in rows:
      f.write(str(int(r[num]))+' '+str(int(r[parameter]))+'\n')
    f.write('/ ;\n')

  
  def createInputFileGams(self):         
    filenames = ['Model/constant.inc', 'Model/variable.inc']
    with open('Model/model.inc', 'w') as outfile:
      for fname in filenames:
	with open(fname) as infile:
	  for line in infile:
	    outfile.write(line)
	
  def LoadPatients(self,rows):
    f = open('Model/variable.dat', 'w+')
    f.write('\n \nset patients := ')
    for r in rows:
      f.write(str(int(r['Patient']))+' ')
    f.write(';\n')
    f.write('\nparam waitingPeriod := ')
    for r in rows:
      waitingPeriod=datetime.datetime.now() -datetime.datetime.strptime((r['Date']), "%Y-%m-%d") 
      f.write(str(int(r['Patient']))+' '+str(waitingPeriod.days) +'\n')
    f.write(';\n')
    self.AddParameter(rows, f, 'Patient', 'ges')
    self.AddParameter(rows, f, 'Patient', 'reInterventions')
    self.AddParameter(rows, f, 'Patient', 'surgeryLength')
    self.AddParameter(rows, f, 'Patient', 'anesthesiaType')
    self.AddParameter(rows, f, 'Patient', 'surgeryTypePatient')
    #cuenta la cantidad de pacientes de tipo p y los agrega al arreglo countPatients
    countPatients = defaultdict(int)
    for r in rows:
      countPatients[r['surgeryTypePatient']] += 1  
    #entrega al parametro numPatients{p} la cantidad de pacientes de ese tpo
    f.write('\n param numPatients := ')
    for cp in range(1,len(countPatients)+1):
      f.write(str(cp)+' '+str(countPatients[cp])+'\n')
    f.write(';') 
    f.close()
  
  def AddParameter(self,rows, f, num, parameter):
    f.write('\n param '+parameter+ ':= ')
    for r in rows:
      f.write(str(int(r[num]))+' '+str(int(r[parameter]))+'\n')
    f.write(';\n')
  
  def CreateInputFile(self):         
    filenames = ['Model/constant.dat', 'Model/variable.dat']
    with open('Model/model.dat', 'w') as outfile:
      for fname in filenames:
	with open(fname) as infile:
	  for line in infile:
	    outfile.write(line)
    
  def LoadProblem(self,rows):
	self.LoadPatients(rows)
	self.CreateInputFile()
	self.loadPatientsGams(rows)
	self.createInputFileGams()
    #se crea el problema y se le pasan el modelo y el .dat
    #pr = glpk.glpk("Model/model.mod","Model/model.dat")
    #return pr
 
  def solveGLPK(self,pr):
    print "Solving problem..."
    #capture = subprocess.check_output(["glpsol", "--math", "Model/model.mod", "--data", "Model/model.dat", "--tmlim","60", "--write", "Output/write.out"])
    subprocess.call(["glpsol", "--math", "Model/model.mod", "--data", "Model/model.dat", "--tmlim","360", "--output", "Output/output.out", "--write", "Output/write.out"])
    #subprocess.call(["glpsol", "--math", "Model/model.mod", "--data", "Model/model.dat", "--output", "Output/output.out", "--write", "Output/write.out"])
    return pr.solution()

  def solveGams(self):
	gamspath="C:\GAMS\win64\23.8\gams"
	filename="Model\model.gms"
	subprocess.call(["gams",  filename])
    
	
    
   

    
