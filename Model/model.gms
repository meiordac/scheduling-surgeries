$include "Model/model.inc" 
  
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
z =e= (sum((st,b,d,opr), ( x(st,opr,b,d)*alpha(st))) + sum((p,b,d), y(p,b,d)*(waitingPeriod(p)*gamma + beta*ges(p) + reInterventions(p)*delta)))
;
  
rest_no_duplicate_patients(p)	.. 
	sum((d,b), y(p,b,d)) =l= 1;

rest_no_duplicate_block(opr,d)	..
	sum((st,b),x(st,opr,b,d)) =l= 1;

rest_max_num_patients_per_block(b,d) ..
	sum((p),y(p,b,d)*surgeryLength(p)) =l= blockDuration(b);
	
rest_max_or(d)	..
	sum((st,opr,b), x(st,opr,b,d)) =l= ORAvailable(d);
	
rest_anesthesists(d)	..
	sum((b,p), (y(p,b,d)*anesthesiaType(p) )) =l= anesthetists(d);
	
rest_beds(d)	..
sum((p,b), y(p,b,d)) =l= beds(d);

rest_correspond_patient_rooms(st,b,d)	..
	(sum((p)$(matrixPatientType(p,st)),y(p,b,d))/numPatients(st)) =l= sum((opr),x(st,opr,b,d));

rest_perform_surgery(b,d,st,opr)	..
	x(st,opr,b,d) =l= canPerformSurgeryOR(st,opr)
	

* Creación y ejecución del modelo

MODEL scheduling	/ all /;

*iteraciones
OPTION ITERLIM = 1900000000;
OPTION SYSOUT = ON;
*tiempo límite en segundos
OPTION RESLIM = 360;
*grado de tolerancia
OPTION OPTCR = 0.001;
*numero deseado de filas
*OPTION LIMROW = 100;
*número deseado de columnas
*OPTION LIMCOL = 0;
*OPTION optfile = 1;

solve scheduling using mip maximizing z ;
*display x.l, x.m ;


* Obtener los datos del modelo

file vx /x(st,opr,b,d).txt/;
put vx;
loop(st,
         loop(opr,
                 loop(b,
                         loop(d,
                                 if(x.l(st,opr,b,d) > 0,
                                 put  d.tl, opr.tl, b.tl,  st.tl;
                                 put""/
                                 );
                        );
                  );
         );
);

* Obtener los datos del modelo

file vy /y(p,b,d).txt/;
put vy;
loop(p,
        loop(b,
                loop(d,
                        if(y.l(p,b,d) > 0,
                            put  p.tl, d.tl, b.tl;
                            put""/
                           );
                    );
            );
);
