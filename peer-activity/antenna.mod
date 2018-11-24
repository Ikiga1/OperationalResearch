# SETS
set Z;		#set of zones to be covered
set S;		#set of sites for antennas

# PARAMS
param p{S,Z}, default 0;
param DELTA;
param delta;

# VARIABLES
var x{S}, binary; 	# |x| = number of active antennas
var y{Z}, binary;	# |y| = number of covered zones

#SOLVE
#maximize number of active zones
maximize zones:
	sum{z in Z} y[z];

#CONSTRAINTS
subject to antennas{z in Z}:
	sum{s in S: p[s,z] >= DELTA} x[s] <= 1; #zones can be served at most by 1 antenna

subject to signal{z in Z}:
	y[z] <= sum{s in S: p[s,z] >= DELTA} x[s]; #zone is served if signal is greater or equal than DELTA 

#VARIANT
subject to interference{z in Z}:
	((sum{s in S} (p[s,z]*x[s])) - (sum{s in S: p[s,z] >= DELTA} (p[s,z]*x[s]))) <= delta; #interference should

