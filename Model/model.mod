# ---------------------
# SETS
# ---------------------
set days;
set weeks;
set blocks; #bloques quirurgicos, deberian ir asociados a un determinado pabellon quirurgico
#set surgeons;
set operatingRooms; #pabellones quirurgicos
#set blocks_by_operatingRoom{blocks} within operatingRooms;
set patientTypes; #tipos de pacientes, ver .dat para mas detalles
set patients;

# ---------------------
# PARAMETERS
# ---------------------
 

param numPatients{pt in patientTypes} >=0; #numero de pacientes del tipo p, cantidad de casos de ese tipo
param ORAvailable{d in days} >=0; #salas de operaciones del tip op disponibles en dia d
param blockDuration{b in blocks}; #duracion del bloque b
param totalBlocks{b in blocks, d in days} >=0; #numero total de bloques quirurgicos del tipo b en dia d
param alpha{pt in patientTypes}; #nivel de prioridad del paciente tipo p, es un ponderador usado en funcion objetivo
param ges{p in patients} binary; #pacientes están en el ges o no
param beta; #constante que le da el peso a que un paciente sea ges o no
param waitingPeriod{p in patients};#tiempo de espera hasta el momento de un paciente determinado
param surgeryLength{p in patients};#tiempo de duracion de la cirugia para el paciente p
param anesthesiaType{p in patients};#anestecia local (0) o general (1)
#param availableSurgeons{d in days, pt in patientTypes, b in blocks};
#param beds{d in days} >= 0; #cantidad de camas disponibles en un dia d y en una semana w
param anesthetists{b in blocks,d in days} >= 0; #cantidad de anestecistas disponibles para un dia d en el tipo de bloque b
#param weekBlocks{b in blocks, w in weeks} >= 0; #cantidad de bloques del tipo b en la semana w

# ---------------------
# VARIABLES
# ---------------------

var assignedPatient{p in patients, b in blocks, d in days} binary;
var assignedBlock{pt in patientTypes,op in operatingRooms, b in blocks, d in days} binary; #define si se asigna un bloque determinado, en un dia determinado a un paciente tipo p
#var assignedOR{op in operatingRooms, d in days} binary; #define si una sala de operaciones de asina en un dia determinado por un paciente p

# ---------------------
# OBJETCTIVE FUNCTION
# ---------------------

# Se maximiza la asignacion de bloques ponderada por la prioridad del tipo de paciente p

maximize objectiveFunction:
  sum{pt in patientTypes, b in blocks, d in days, p in patients, op in operatingRooms} (assignedBlock[pt,op,b,d]*alpha[pt] + assignedPatient[p,b,d]*waitingPeriod[p]+assignedPatient[p,b,d]*beta*ges[p]+assignedPatient[p,b,d]*surgeryLength[p]); 
    
# ---------------------
# RESTRICTIONS
# ---------------------

subject to rest_max_blocks {b in blocks, d in days}:
  sum{pt in patientTypes, op in operatingRooms} assignedBlock[pt,op,b,d] <= totalBlocks[b,d];
  
subject to rest_no_duplicate_patients {p in patients}: 
  sum{d in days, b in blocks} assignedPatient[p,b,d] <= 1;
  
  #asigna un pabellon op, en el dia d a un tipo de cirugia y un tipo de bloque especifico
 subject to rest_assign_block_type_surgery_operating_room {op in operatingRooms, d in days}:
  sum{pt in patientTypes,b in blocks} assignedBlock[pt,op, b, d ] <= 1;

subject to rest_max_num_patients_per_block {b in blocks, d in days}:
  sum{p in patients} assignedPatient[p,b,d]*surgeryLength[p] <=  blockDuration[b];
  
subject to rest_max_or{d in days}:
  sum{pt in patientTypes, op in operatingRooms,b in blocks} assignedBlock[pt,op,b,d] <= ORAvailable[d];
  
subject to rest_anesthesists{d in days, b in blocks}:
  sum{p in patients} assignedPatient[p,b,d]*anesthesiaType[p] <= anesthetists[b,d];
   
#subject to rest_beds{d in days}:
#sum{p in patients, b in blocks} assignedPatient[p,b,d] <= beds[d];

#subject to rest_surgeons{d in days, p in patients}:
#sum{b in blocks} assignedPatient[p,b,d] <= availableSurgeons[d,pt,b];
