Sets
	d   	days   
	b		blocks
	opr		operatingRooms
	st		surgeryTypes
	p		patients
	; 
Parameters
	numPatients(st)			numero de pacientes del tipo p, cantidad de casos de ese tipo
	ORAvailable(d)			salas de operaciones del tip op disponibles en dia d
	blockDuration(b)		duracion del bloque b
	alpha(st)				nivel de prioridad del paciente tipo p, es un ponderador usado en funcion objetivo
	ges(p) 					pacientes están en el ges o no
	waitingPeriod(p)		tiempo de espera hasta el momento de un paciente determinado
	surgeryLength(p)		tiempo de duracion de la cirugia para el paciente p
	anesthesiaType(p)		anestecia local 0 o general 1
	surgeryTypePatient(p)	tipo de paciente 
	beds(d)					cantidad de camas disponibles en un dia d 
	reInterventions(p)		cantidad de reintervensiones paciente p
	anesthetists(d)			cantidad de anestecistas disponibles para un dia d en el tipo de bloque 
	;

Table
	canPerformSurgeryOR(st, opr) se puede hacer la cirugia st en el pabellon opr
	;
	
Scalars
	beta					constante que le da el peso a que un paciente sea ges o no
	gamma					peso de los dias de espera
	delta					peso de las reintervenciones
	;
  
Variables
	x(st,opr,b,d)			se asigna el tipo de cirugía st al pabellon opr en el bloque b el dia d
	y(p,b,d)				si el paciente p se operara el dia d en el bloque b
	z						funcion objetivo
;
  
Binary variable x;
Binary variable y;

Equations

	objective_function						funcion objetivo
	rest_no_duplicate_patients(p)			asegura que no haya pacientes duplicados
	rest_no_duplicate_block(opr,d)  		asegura que no haya pabellones duplicados
	rest_max_num_patients_per_block(b,d)	no hay mas pacientes que el largo de los bloques
	rest_max_or(d)         					hay suficientes pabellones
	rest_anesthesists(d)         			hay suficientes anestesistas 
	rest_beds(d)          					hay suficientes camas
	rest_correspond_patient_rooms(st,b,d)	hay al menos un pabellon para operar a un paciente tipo st
	rest_perform_surgery(b,d,st,opr)		se puede realizar la cirugia en el pabellon
	;

objective_function ..	
z =e= sum((st,b,d,p,opr), ( x(st,opr,b,d)*alpha(st) +
y(p,b,d)*(
waitingPeriod(p)*gamma + 
beta*ges(p) + 
reInterventions(p)*delta))
);
  
rest_no_duplicate_patients(p)	.. 
	sum((d,b), y(p,b,d)) =l= 1;

rest_no_duplicate_block(opr,d)	..
	sum((st,b),x(st,opr,b,d)) =l= 1;

rest_max_num_patients_per_block(b,d) ..
	sum((p),y(p,b,d)*surgeryLength(p)) =l= blockDuration(b);
	
rest_max_or(d)	..
	sum((st,opr,b), x(st,opr,b,d)) =l= ORAvailable(d);
	
rest_anesthesists(d)	..
	sum((p), y(p,b,d)*anesthesiaType(p)) =l= anesthetists(d);
	
rest_beds(d)	..
sum((p,b), y(p,b,d)) =l= beds(d);

rest_correspond_patient_rooms(st,b,d)$(surgeryTypePatient(p)=st)	..
	(sum((p),y(p,b,d))/numPatients(st)) =l= sum((opr),x(st,opr,b,d));

rest_perform_surgery(b,d,st,opr)	..
	x(st,opr,b,d) =l= canPerformSurgeryOR(st,opr)
	

* Creación y ejecución del modelo

$include "model.inc" 

MODEL scheduling	/ all /;

*iteraciones
OPTION ITERLIM = 1900000000;
OPTION SYSOUT = ON;
*tiempo límite en segundos
OPTION RESLIM = 36000;
*grado de tolerancia
OPTION OPTCR = 0.01;
*numero deseado de filas
*OPTION LIMROW = 100;
*número deseado de columnas
*OPTION LIMCOL = 0;
*OPTION optfile = 1;

solve scheduling using mip minimizing z ;
*display x.l, x.m ;
