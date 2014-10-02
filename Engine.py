import glpk
from collections import defaultdict

class Engine:
  
  def __init__(self):
    print "engine initiated"
    
  def LoadProblem(self,rows):
    
    pr = glpk.glpk("Model/model.mod","Model/model.dat")
 
    countPatients = defaultdict(int)
    #cuenta la cantidad de pacientes de tipo p y los agrega al arreglo countPatients
    for r in rows:
      countPatients[r['PatientType']] += 1
      
    print countPatients
    
    #entrega al parametro numPatients{p} la cantidad de pacientes de ese tpo
    for p in range(1,8):
      pr.numPatients[p] = countPatients[p]
    
    return pr
    
  
  def Solve(self,pr):
    print "Solving problem..."
    pr.update()
    pr.solve()
    return pr.solution()
    

    