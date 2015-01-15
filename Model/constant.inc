Sets
	d		'days'     			/1,2,3,4,5/   
	b		'blocks'			/1,2/
	opr		'operatingRooms'	/1,2,3,4,5,6,7,8,9,10/
	st		'surgeryTypes'		/1,2,3,4,5,6,7,8,9/
	; 

table canPerformSurgeryOR(st, opr) 'se puede realizar la cirugia'

	1 2 3 4 5 6 7 8 9 10  

1 	1 1 1 1 1 0 0 0 0 1  
2 	1 1 1 1 1 0 0 0 0 1  
3	1 1 1 1 1 0 0 0 0 1  
4 	1 1 1 1 1 0 0 0 0 1 
5 	1 1 1 1 1 0 0 0 0 1 
6 	1 1 1 1 1 0 0 0 0 1  
7 	1 1 1 1 1 0 0 0 0 1  
8 	0 0 0 0 0 1 1 0 0 0 
9 	0 0 0 0 0 0 0 1 1 0 ;  

Parameters

blockDuration(b)
/	1 6
	2 11	/

alpha(st)
/	
1	5
2	4
3	4
4	1
5	4
6	1
7	5
8	2
9	3
/

ORAvailable(d)
/
1 8
2 9
3 9
4 9
5 9	/

anesthetists(d)
/
1 10
2 11
3 12
4 10
5 11	/

beds(d)
/
1 20
2 27
3 18
4 25
5 15
/
;

Scalars
beta	/1000/
gamma	/0.01/
delta	/5/;
