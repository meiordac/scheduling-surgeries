#!/usr/bin/env python

from os.path import join
from xlrd import open_workbook,cellname

class ReadExcel:
  
  @staticmethod
  def read():
    rows = []
    book = open_workbook('LE.xls')
    sheet = book.sheet_by_index(0)
 
    for row_index in range(1,sheet.nrows):
      rows.append({"Rut":sheet.cell_value(row_index,0),"Nombre":sheet.cell_value(row_index,1),"Fecha":sheet.cell_value(row_index,2) })

    return rows

rows = ReadExcel.read()
print rows
