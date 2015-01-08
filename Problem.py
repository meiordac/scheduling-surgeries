import time
import datetime
from collections import defaultdict

class Problem:
  def __init__(self,rows):
    print "loading problem"
  
  def LoadProblem(self,rows):
    self.loadPatientsGams(rows)
  
  def LoadProblem(self,rows):
    self.LoadPatients(rows)
    #se crea el problema y se le pasan el modelo y el .dat
    #pr = glpk.glpk("Model/model.mod","Model/model.dat")
    #return pr
 
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
   self.addPatientParameters(rows,f)
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

  def addPatientParameters(self,rows,f):
    self.AddParameter(rows, f, 'Patient', 'ges')
    self.AddParameter(rows, f, 'Patient', 'reInterventions')
    self.AddParameter(rows, f, 'Patient', 'surgeryLength')
    self.AddParameter(rows, f, 'Patient', 'anesthesiaType')
    self.AddParameter(rows, f, 'Patient', 'surgeryTypePatient')

  def addPatientParametersGams(self,rows,f):
    self.addParameterGams(rows, f, 'Patient', 'ges','p')
    self.addParameterGams(rows, f, 'Patient', 'reInterventions','p')
    self.addParameterGams(rows, f, 'Patient', 'surgeryLength','p')
    self.addParameterGams(rows, f, 'Patient', 'anesthesiaType','p')
    self.addParameterGams(rows, f, 'Patient', 'surgeryTypePatient','p')
    
  def buildMatrixPatientType(self,rows,countPatients,f):
    f.write('\n table matrixPatientType(p,st) '+'\n	')
    for cp in range(1,len(countPatients)+1):
      f.write(str(cp)+' ')
    for r in rows:
      f.write('\n'+str(int(r['Patient'])) +'	')
      for cp in range(1,len(countPatients)+1):
	f.write(str(int(cp==int(r['surgeryTypePatient'])))+' ')
    f.write(' ;') 
    

  def loadPatientsGams(self,rows):
    f = open('Model/variable.inc', 'w+')
    f.write('\n \n set p patients /')
    f.write(str(int(rows[0]['Patient']))+"*"+str(int(rows[len(rows)-1]['Patient'])))
    f.write('/ ;\n')
    #cuenta la cantidad de pacientes de tipo p y los agrega al arreglo countPatients
    countPatients = defaultdict(int)
    for r in rows:
      countPatients[r['surgeryTypePatient']] += 1  
    #entrega al parametro numPatients{p} la cantidad de pacientes de ese tpo
    f.write('\n parameter numPatients(st) /')
    for cp in range(1,len(countPatients)+1):
      f.write(str(cp)+' '+str(countPatients[cp])+'\n')
    f.write('/ ;') 
    
    self.addPatientParametersGams(rows,f)
    self.buildMatrixPatientType(rows,countPatients,f)
    
    f.write('\n parameter waitingPeriod(p) \n / ')
    for r in rows:
      waitingPeriod=datetime.datetime.now() -datetime.datetime.strptime((r['Date']), "%Y-%m-%d") 
      f.write(str(int(r['Patient']))+' '+str(waitingPeriod.days) +'\n')
    f.write('/ ; \n')
    f.close()
    
  def addParameterGams(self,rows, f, num, parameter, charParameter):
    f.write('\n parameter '+parameter+ '('+charParameter+') /')
    for r in rows:
      f.write(str(int(r[num]))+' '+str(int(r[parameter]))+'\n')
    f.write('/ ;\n')
