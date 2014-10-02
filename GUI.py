#! /usr/bin/env python

from prettytable import PrettyTable

def Print(pr):
  
  
  print "Bloques asignados: "
  print 'B',' ','T',' ', ' L',' ', 'M',' ', 'M', ' ', 'J', ' ', 'V'
  print '____________________________'
  for j in range(1,len(pr.blocks)+1):
    for i in range(1,len(pr.patientTypes)+1):
      print  j,' ',i,' |', str(pr.assignedBlock[i,j,1])[5],' ', str(pr.assignedBlock[i,j,2])[5],' ',str(pr.assignedBlock[i,j,3])[5],' ',str(pr.assignedBlock[i,j,4])[5],' ',str(pr.assignedBlock[i,j,5])[5], '|'
  
  print '----------------------------'
  print "Pabellones asignados: "
  print 'P',' ','T',' ', ' L',' ', 'M',' ', 'M', ' ', 'J', ' ', 'V'
  print '____________________________'
  for j in range(1,len(pr.operatingRooms)+1):
    for i in range(1,len(pr.patientTypes)+1):
      print  j,' ',i,' |', str(pr.assignedOR[i,j,1])[5],' ', str(pr.assignedOR[i,j,2])[5],' ',str(pr.assignedOR[i,j,3])[5],' ',str(pr.assignedOR[i,j,4])[5],' ',str(pr.assignedOR[i,j,5])[5], '|'
  print '----------------------------'