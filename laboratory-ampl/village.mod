##AUXILIARY PARAMETERS
param nrows;
param ncolumns;
param nvillages;

#SETS
set I := 1..nrows;						#Rows in Grid
set J := 1..ncolumns;					#Set of columns in Grid
set C := 1..2;							#Coordinates of a Village
set V := 1..nvillages;					#Set of Villages
set P := -(nrows-1)..(nrows-1);			#Rows in Grid, considering negative values
set Q := -(ncolumns-1)..(ncolumns-1);	#Columns in Grid, considering negative values

#PARAMS
param villages{C, V};	#Matrix: each column is a village, rows are its coordinates
param distance{P, Q};	#Distance matrix: distance[i-x, j-y] returns the distance from (i,j) to (x,y)
#### We decided to hide the abs() from the .mod to make it easy readable.
#### .dat is a bit dirtier but redundant data are easily computable(its a constant factor of 4...), we assumed it is fine.

#VARS
var packet1{I,J}, binary; 	#Grid that identifies the position of the first packet: each element is 1 if the packet is in that place, 0 otherwise
var packet2{I,J}, binary; 	#Grid that identifies the position of the second packet: each element is 1 if the packet is in that place, 0 otherwise

var dist{V}; 				#Array of real values in which each element stores the distance from the village to the closest packet
var indicator{V}, binary;	#0 if the village gets resources from packet1, 1 if the village gets resources from packet2

#OBJECTIVE FUNCTION
## Trivially minimize the distance of all villages from a generic packet 
minimize obj_funct:
	sum{v in V} dist[v];

#INDICATOR TRICK
## With this trick we are able to let the objective function decide which packet is the closest to a village
subject to packet_choice{v in V}:
	indicator[v] = 0 ==> dist[v] = (sum{i in I, j in I} distance[i - villages[1,v],j - villages[2,v]]*packet1[i,j])
	else dist[v] = (sum{i in I, j in I} distance[i - villages[1,v],j - villages[2,v]]*packet2[i,j]);

#CONSTRAINTS
## The first matrix/grid should only contain one packet (packet1)
subject to matric1:
	sum{i in I, j in I} packet1[i,j] = 1;

## The second matrix/grid should only contain one packet (packet2)
subject to matrix2:
	sum{i in I, j in I} packet2[i,j] = 1;


## Result is achieved with 240 constraints and 2 variables, which is quite satisfactory.