# ---------------------
# SETS
# ---------------------

set days;
set weeks;
set blocks; #bloques quirurgicos, deberian ir asociados a un determinado pabellon quirurgico
#set surgeons;
set operatingRooms; #pabellones quirurgicos
#set blocks_by_operatingRoom{blocks} within operatingRooms;
set surgeryTypes; #tipos de pacientes, ver .dat para mas detalles
set patients;

# ---------------------
# PARAMETERS
# ---------------------
 
param numPatients{st in surgeryTypes} >=0; #numero de pacientes del tipo p, cantidad de casos de ese tipo
param ORAvailable{d in days} >=0; #salas de operaciones del tip op disponibles en dia d
param blockDuration{b in blocks}; #duracion del bloque b
param totalBlocks{b in blocks, d in days} >=0; #numero total de bloques quirurgicos del tipo b en dia d
param alpha{st in surgeryTypes}; #nivel de prioridad del paciente tipo p, es un ponderador usado en funcion objetivo
param ges{p in patients} binary; #pacientes están en el ges o no
param beta; #constante que le da el peso a que un paciente sea ges o no
param gamma; #peso de los dias de espera
param delta; #peso de las reintervenciones
param waitingPeriod{p in patients};#tiempo de espera hasta el momento de un paciente determinado
param surgeryLength{p in patients};#tiempo de duracion de la cirugia para el paciente p
param anesthesiaType{p in patients};#anestecia local (0) o general (1)
param surgeryTypePatient{p in patients};#tipo de paciente 
param beds{d in days} >= 0; #cantidad de camas disponibles en un dia d 
param anesthetists{b in blocks,d in days} >= 0; #cantidad de anestecistas disponibles para un dia d en el tipo de bloque b
param reInterventions{p in patients} >=0; #cantidad de reintervensiones paciente p
param canPerformSurgeryOR{st in surgeryTypes, opr in operatingRooms} >=0;#matriz que dice si se puede realizar un tipo de cirugía st en pabellón opr
#param weekBlocks{b in blocks, w in weeks} >= 0; #cantidad de bloques del tipo b en la semana w
#param availableSurgeons{d in days, st in surgeryTypes, b in blocks};


# ---------------------
# VARIABLES
# ---------------------

var assignedPatient{p in patients, b in blocks, d in days} binary;
var assignedBlock{st in surgeryTypes,opr in operatingRooms, b in blocks, d in days} binary; #define si se asigna un bloque determinado, en un dia determinado a un paciente tipo p

# ---------------------
# OBJECTIVE FUNCTION
# ---------------------

maximize objectiveFunction:
  sum{st in surgeryTypes, b in blocks, d in days, p in patients, opr in operatingRooms} (
  + assignedBlock[st,opr,b,d]*alpha[st] 
  + assignedPatient[p,b,d]*(
  + waitingPeriod[p]*gamma
  + beta*ges[p]
  + reInterventions[p]*delta)
# + assignedPatient[p,b,d]*surgeryLength[p]
  ); 
    
# ---------------------
# RESTRICTIONS
# ---------------------

#subject to rest_surgeons{d in days, p in patients}:
#sum{b in blocks} assignedPatient[p,b,d] <= availableSurgeons[d,st,b];

#subject to corresponding_block_patient{d in days, st in surgeryTypes, p in patients, b in blocks}:
#assignedPatient[p,b,d] <= sum{opr in operatingRooms} assignedBlock[st,opr,b,d];

#subject to rest_corresponding_patient_types{p in patients,d in days, b in blocks}:
#sum{st in surgeryTypes : surgeryTypePatient[p] !=st } assignedPatient[p,st,b,d] = 0;

#subject to rest_max_blocks {b in blocks, d in days}:
#sum{st in surgeryTypes, opr in operatingRooms} assignedBlock[st,opr,b,d] <= totalBlocks[b,d];

subject to rest_no_duplicate_patients {p in patients}: 
  sum{d in days, b in blocks} assignedPatient[p,b,d] <= 1;

subject to rest_assign_block_type_surgery_operating_room {opr in operatingRooms, d in days}:
  sum{st in surgeryTypes,b in blocks} assignedBlock[st,opr, b, d ] <= 1;

subject to rest_max_num_patients_per_block {b in blocks, d in days}:
  sum{p in patients} assignedPatient[p,b,d]*surgeryLength[p] <=  blockDuration[b];
  
subject to rest_max_or{d in days}:
  sum{st in surgeryTypes, opr in operatingRooms,b in blocks} assignedBlock[st,opr,b,d] <= ORAvailable[d];
  
subject to rest_anesthesists{d in days, b in blocks}:
  sum{p in patients} assignedPatient[p,b,d]*anesthesiaType[p] <= anesthetists[b,d];
   
subject to rest_beds {d in days}:
  sum{p in patients, b in blocks} assignedPatient[p,b,d] <= beds[d];
  
subject to rest_corresponding_patient_rooms {st in surgeryTypes, b in blocks, d in days}:
  (sum{p in patients : surgeryTypePatient[p] =st } assignedPatient[p,b,d])/numPatients[st] <= sum{opr in operatingRooms} assignedBlock[st,opr,b,d];
  
subject to rest_cap_or_trauma { b in blocks, d in days, st in surgeryTypes, opr in operatingRooms}:
  assignedBlock[st,opr,b,d] <= canPerformSurgeryOR[st, opr];
   
  