import glpk

class Engine:
  
  def __init__(self):
    print "engine initiated"
    
  
  def Solve(self,rows):
    print "solving..."
    pr = glpk.glpk("Model/model.mod","Model/model.dat")
    pr.numPatients[1] = len(rows)
    #pr.numPatients[2] = len(rows)
    pr.update()
    pr.solve()
    return pr.solution()
    

    