Sets
	d   	/1,2,3,4,5/   
	b		/1,2/
	opr		/1,2,3,4,5,6,7,8,9/
	st		/1,2,3,4,5,6,7,8,9/
	; 

Table canPerformSurgeryOR(st, opr)
  1 2 3 4 5 6 7 8 9 10  
1 1 1 1 1 1 0 0 0 0 1  
2 1 1 1 1 1 0 0 0 0 0  
3 1 1 1 1 1 0 0 0 0 1  
4 1 1 1 1 1 0 0 0 0 0 
5 1 1 1 1 1 0 0 0 0 1 
6 1 1 1 1 1 0 0 0 0 1  
7 1 1 1 1 1 0 0 0 0 1  
8 0 0 0 0 0 1 1 0 0 0 
9 0 0 0 0 0 0 0 1 1 0 
;  

Parameters
blockDuration(b)
/	1 6
	2 11	/

alpha(st)
/	1 10
2 4
3 5
4 5
5 8
6 2
7 5
8 8
9 5	/

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
1 20
2 27
3 18
4 25
5 15
;

Scalars
beta	/10/
gamma	/0.01/
delta	/0.5/;
