include "globals.mzn";
include "ar_1_1.dzn";

int: del_add;
int: del_mul;
int: number_add;
int: number_mul;
int: n;
set of int: last;
set of int: add;
set of int: mul;
array[1..n] of set of int : dependencies;
int: del_max = if del_add > del_mul then del_add else del_mul endif;
int: number_max = if number_add > number_mul then number_add else number_mul endif;

%Time, delay and resource arrays for the nodes
array[1..n] of var 0..n*del_max: time;
array[1..n] of var 1..del_max: delay;
array[1..n] of var 1..number_max: resource;
var int : score;

%Makes sure nodes are handled in sequence and that the delay for each operation is applied
constraint forall(i in add, j in dependencies[i])(time[i] + del_add <= time[j]);
constraint forall(i in mul, j in dependencies[i])(time[i] + del_mul <= time[j]);
constraint forall(i in add)(delay[i] = del_add);
constraint forall(i in mul)(delay[i] = del_mul);
constraint forall(i in last)(time[i] + delay[i] <= score);

%Sequencially orders the operations in regard to resource use (number of adders/multipliers). Schedules operations. Ceiling = max number of simultanious operations.
constraint cumulative([time[i] | i in add],[del_add | i in add], [1 | i in add], number_add);
constraint cumulative([time[i] | i in mul],[del_mul | i in mul], [1 | i in mul], number_mul);

%Constructs 2-dimensional rectangles that cannot overlap. This is necessary since mul & add cannot happen simultiniously, and since number of simlutainuous mul and add operations are limited.
constraint diff2([time[i] | i in add], [resource[i] | i in add], [del_add | i in add], [1 | i in add]);
constraint diff2([time[i] | i in mul], [resource[i] | i in mul], [del_mul | i in mul], [1 | i in mul]);

 %Smallest finds variable with smallest domain, indomain_min chooses smallest in domain
solve ::  int_search(time, smallest, indomain_min)
          minimize score;

%output[show(i in add)(resource[i]), "\n", show(i in mul)(resource[i])];