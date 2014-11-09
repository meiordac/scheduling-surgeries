import RW 
import Engine 

def main():
  rows = RW.ReadExcel.Read()
  e = Engine.Engine()
  pr = e.LoadProblem(rows)
  s = e.Solve(pr)
  RW.ReadExcel.generateExcel(pr,rows)
  
if __name__ == "__main__":
    main()