#!/usr/bin/env python
import datetime
import json
from os.path import join
from xlrd import open_workbook,cellname


class ReadExcel:
  
  @staticmethod
  def Read():
    rows = []
    book = open_workbook('Input/LE.xls')
    sheet = book.sheet_by_index(0)
 
    for row_index in range(1,sheet.nrows):
      rows.append({"Name":sheet.cell_value(row_index,0),"Date":sheet.cell_value(row_index,1),"Age":sheet.cell_value(row_index,2), "Rut":sheet.cell_value(row_index,3) })

    return rows
  
  @staticmethod
  def Write(solution):
    i = datetime.datetime.now()
    f = open('Output/output '+ str(i.day)+'-'+ str(i.month)+'-'+str(i.year)+'.json' , 'w+')
    json.dump(solution, f)
    f.close()
    

