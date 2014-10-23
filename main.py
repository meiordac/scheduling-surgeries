import RW 
import Engine 
import GUI

def main():
  rows = RW.ReadExcel.Read()
  e = Engine.Engine()
  pr = e.LoadProblem(rows)
  s = e.Solve(pr)
  RW.ReadExcel.generateExcel(pr,rows)
  #GUI.Print(pr)
  
if __name__ == "__main__":
    main()