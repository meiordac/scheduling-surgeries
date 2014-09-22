# ---------------------
# SETS
# ---------------------
set days;
set weeks;
set blocks; #block surgical durations
set surgeons;
set operating_rooms; #pabellones quirurgicos
set patient_types; #tipos de pacientes

# ---------------------
# PARAMETERS
# ---------------------
 
param beds{d in days, w in weeks} >= 0; #cantidad de camas disponibles en un dia d y en una semana w
param anesthetists{w in weeks}>=0; #cantidad de anestecistas disponibles para una semana w
param weekBlocks{b in blocks, w in weeks} >=0; #cantidad de bloques del tipo b en la semana w
param numPatients{p in patient_types} >=0; #numero de pacientes del tipo p

# ---------------------
# VARIABLES
# ---------------------

var x{b in blocks, d in days, w in weeks} binary; #define si en un bloque se opera o no

# ---------------------
# OBJETCTIVE FUNCTION
# ---------------------

maximize ocupation:
  sum{b in blocks, d in days, w in weeks} x[b,d,w]; #maximizar ocupacion, maximizando la suma de la ocupacion de los bloques

# ---------------------
# RESTRICTIONS
# ---------------------

subject to max_week_blocks {w in weeks}:
  sum{b in blocks, d in days} x[b,d,w] <= sum{b in blocks} weekBlocks[b,w];

subject to max_num_patients{w in weeks}:
  sum{b in blocks, d in days} x[b,d,w] <= sum{p in patient_types} numPatients[p];
  