import RW 
import Engine 

def main():
  rows = RW.ReadExcel.read()
  #print rows
  e = Engine.Engine(rows[0].get("Date"))
  e.solve()
  
if __name__ == "__main__":
    main()