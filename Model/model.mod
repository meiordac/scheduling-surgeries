# ---------------------
# SETS
# ---------------------
set days;
set weeks;
set blocks; #block surgical durations
set surgeons;
set operatingRooms; #pabellones quirurgicos
set patientTypes; #tipos de pacientes

# ---------------------
# PARAMETERS
# ---------------------
 
#param beds{d in days, w in weeks} >= 0; #cantidad de camas disponibles en un dia d y en una semana w
#param anesthetists{w in weeks}>=0; #cantidad de anestecistas disponibles para una semana w
param weekBlocks{b in blocks, w in weeks} >=0; #cantidad de bloques del tipo b en la semana w
param numPatients{p in patientTypes} >=0; #numero de pacientes del tipo p
#param ORAvailable{d in days, w in weeks};
#param alpha{p}; # prioridad que tiene de operarse a un tipo de paciente p, ponderador se ocupa en FO para determinar si operar antes un cancer o una cirugia de corazon
#param WaitingPeriod;

# ---------------------
# VARIABLES
# ---------------------

#var WaitingPeriod; tiempo espera puede ser variable, dependiendo como se defina

var assignedBlock{b in blocks, d in days, w in weeks} binary; #dias, pabellon, bloque + tipo de paciente

# ---------------------
# OBJETCTIVE FUNCTION
# ---------------------

#funcion objetivo puede ser minimizar el tiempo de espera de paciente p
#maximize WaitingPeriod*alpha;

maximize ocupation:
  sum{b in blocks, d in days, w in weeks} assignedBlock[b,d,w]; #maximizar ocupacion, maximizando la suma de la ocupacion de los bloques

# ---------------------
# RESTRICTIONS
# ---------------------

subject to max_week_blocks {w in weeks}:
  sum{b in blocks, d in days} assignedBlock[b,d,w] <= sum{b in blocks} weekBlocks[b,w];

subject to max_num_patients{w in weeks}:
  sum{b in blocks, d in days} assignedBlock[b,d,w] <= sum{p in patientTypes} numPatients[p];
  