# ---------------------
# SETS
# ---------------------
set days;
set weeks;
set blocks; #bloques quirurgicos, deberian ir asociados a un determinado pabellon quirurgico
set surgeons;
set operatingRooms; #pabellones quirurgicos
set blocks_by_operatingRoom{blocks} within operatingRooms;
set patientTypes; #tipos de pacientes, ver .dat para mas detalles

# ---------------------
# PARAMETERS
# ---------------------
 

param numPatients{p in patientTypes} >=0; #numero de pacientes del tipo p, cantidad de casos de ese tipo
param ORAvailable{op in operatingRooms, d in days} >=0; #salas de operaciones del tip op disponibles en dia d
param totalBlocks{b in blocks, d in days} >=0 ; #numero total de bloques quirurgicos del tipo b en dia d
param alpha{p in patientTypes}; #nivel de prioridad del paciente tipo p, es un ponderador usado en funcion objetivo
#param waitingPeriod;#tiempo de espera hasta el momento de un paciente determinado
#param beds{d in days, w in weeks} >= 0; #cantidad de camas disponibles en un dia d y en una semana w
#param anesthetists{w in weeks}>=0; #cantidad de anestecistas disponibles para una semana w
#param weekBlocks{b in blocks, w in weeks} >=0; #cantidad de bloques del tipo b en la semana w
#param ORAvailableSurgeon{d in days, w in weeks, s un surgeons}; #salas de operaciones disponibles en dia d, semana w y para el cirujano s

# ---------------------
# VARIABLES
# ---------------------

#var assignedBlock{b in blocks, d in days, w in weeks} binary; #define si en un bloque se opera o no
var assignedBlock{p in patientTypes, b in blocks, d in days} binary; #define si se asigna un bloque determinado, en un dia determinado a un paciente tipo p

var assignedOR{p in patientTypes, op in operatingRooms, d in days} binary; #define si una sala de operaciones de asina en un dia determinado por un paciente p

# ---------------------
# OBJETCTIVE FUNCTION
# ---------------------

# Se maximiza la asignacion de bloques ponderada por la prioridad del tipo de paciente p

maximize ocupation:
  sum{p in patientTypes, b in blocks, d in days } assignedBlock[p,b,d]*alpha[p]; 
  #sum{b in blocks, d in days, w in weeks} assignedBlock[b,d,w]; #maximizar ocupacion, maximizando la suma de la ocupacion de los bloques

# ---------------------
# RESTRICTIONS
# ---------------------

subject to rest_max_blocks {b in blocks, d in days}:
  sum{p in patientTypes} assignedBlock[p,b,d] <= totalBlocks[b,d];

subject to rest_max_num_patients {p in patientTypes}:
  sum{b in blocks, d in days } assignedBlock[p,b,d] <= numPatients[p];
  
# La cantidad de bloques debe estar restringida a la cantidad de salas de operacion disponibles para un dia dado

subject to rest_blocks_by_operatingRoom {p in patientTypes, d in days, b in blocks}:
  assignedBlock[p,b,d] <= sum{op in blocks_by_operatingRoom[b]} assignedOR[p,op,d];
  