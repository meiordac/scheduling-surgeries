import RW 
import Engine 

def main():
  rows = RW.ReadExcel.Read()
  #print rows
  e = Engine.Engine()
  s = e.Solve(rows)
  RW.ReadExcel.Write(s)
  
if __name__ == "__main__":
    main()