import glpk



class Engine:
  
  def __init__(self,date):
    self.date = date
  
  def solve(self):
    print "starting..."
    pr = glpk.glpk("Model/model.mod","Input/model.dat")
    pr.update()
    pr.solve()
    print "solution:", pr.solution()
    