#!/usr/bin/env python
import datetime
import json
from os.path import join
from xlrd import open_workbook,cellname
import csv

class ReadExcel:
  
  @staticmethod
  def Read():
    rows = []
    book = open_workbook('Input/LE.xls')
    sheet = book.sheet_by_index(0)
    for row_index in range(1,sheet.nrows):
      rows.append({"Name":sheet.cell_value(row_index,1),"Date":sheet.cell_value(row_index,2),"Age":sheet.cell_value(row_index,3), "Rut":sheet.cell_value(row_index,4), "PatientType":sheet.cell_value(row_index,13),"Patient":sheet.cell_value(row_index,0),"GES":sheet.cell_value(row_index,14),"SurgeryLength":sheet.cell_value(row_index,15),"anesthesiaType":sheet.cell_value(row_index,16) })
    return rows
  
  @staticmethod
  def Write(solution):
    i = datetime.datetime.now()
    f = open('Output/output '+ str(i.day)+'-'+ str(i.month)+'-'+str(i.year)+'.json' , 'w+')
    json.dump(solution, f)
    f.close()
    
  @staticmethod
  def generateExcel(pr, rows):
    lines=[]
    with open('Output/write.out', 'r+') as f:
        for line in f:
           lines.append(line.rstrip('\n'))
    #me muevo en el archivo por la cantidad de restricciones que existan
    i = len(pr.patients) + 3*(len(pr.days))*(len(pr.blocks)) + len(pr.days)+len(pr.days)*len(pr.operatingRooms)+len(pr.days)*len(pr.blocks)*len(pr.patients) + 3  
    print i
    #primera linea son cantidad de variables, iteraciones y luego valor de FO
    with open('Output/Patients.csv', 'wb') as csvfile:
      progWriter = csv.writer(csvfile, dialect="excel")
      progWriter.writerow(['id','nombre','edad','rut','tipo paciente','duracion de cirugia','dia','bloque'])
      for pt in range(1,len(pr.patientTypes)+1):
	for b in range(1,len(pr.blocks)+1):
	  for d in range(1,len(pr.days)+1):
	    for p in range(1,len(pr.patients)+1):    
		#print p,rows[p-1]["Name"].encode('utf8'),rows[p-1]["Age"],rows[p-1]["Rut"],rows[p-1]["PatientType"],rows[p-1]["SurgeryLength"],d,b
		#print p, pt, b, d
		if int(lines[i]) == 1:
		  name=rows[p-1]["Name"].encode('utf8')
		  progWriter.writerow([ p,name,rows[p-1]["Age"],rows[p-1]["Rut"],rows[p-1]["PatientType"],rows[p-1]["SurgeryLength"],d,b])
		i = i + 1
      print i
      with open('Output/Schedule.csv', 'wb') as csvfile:
	progWriter = csv.writer(csvfile,dialect="excel")
	progWriter.writerow(['Day','Operating Room','Block','Specialty'])
	for pt in range(1,len(pr.patientTypes)+1):
	  for b in range(1,len(pr.blocks)+1):
	    for d in range(1,len(pr.days)+1):
	      for op in range(1,len(pr.operatingRooms)+1):
		if int(lines[i]) == 1:
		  #print d,' ',op,' ',b, ' ',pt
		  progWriter.writerow([d,op,b,pt])
		i = i + 1
      print i
      

