include "a2_data_2.dzn";
include "globals.mzn";
include "subcircuit.mzn";

int: graph_size;
int: start;
int: n_dests;
int: n_edges;
array[1..n_dests] of int: dest;
array[1..n_edges] of int: from;
array[1..n_edges] of int: to;
array[1..n_edges] of int: cost;
array[1..n_dests, 1..graph_size] of var int: circuits;
array[1..graph_size] of set of 1..graph_size: domains = [{i} union {to[j] | j in 1..n_edges where from[j] = i} union {from[j] | j in 1..n_edges where to[j] = i} union {start | j in 1..n_dests where dest[j] = i} | i in 1..graph_size];

array[1..n_dests] of var int: cost_vector = [cost(n) | n in 1..n_dests];
function var int: cost(int: n) = 
sum(i in 1..graph_size, j in 1..n_edges)(
  if 
    n>1 /\ 
    forall(m in 0..n-1)(
      (circuits[n-m,i] = to[j] /\  i = from[j]) \/ 
      (circuits[n-m,i] = from[j] /\ i = to[j])
      )
  then 0 elseif
    (circuits[n,i] = to[j] /\ i = from[j]) \/ 
    (circuits[n,i] = from[j] /\ i = to[j]) 
  then cost[j] else 0 
  endif
);

constraint forall(i in 1..graph_size, j in 1..n_dests)(circuits[j,i] in domains[i]); %Tie domains to nodes in circuit
constraint forall(j in 1..n_dests)(subcircuit(circuits[j,..])); %Each dest (row in circuits) creates a subcircuit
constraint forall(i in 1..n_dests)(circuits[i,dest[i]] = start); %Artificial path between start and dest to complete circuit

solve minimize sum(cost_vector);
output["Subcircuits = " , show(circuits),"\n", "Cost Vector ", show(cost_vector),"\n","Total Cost: ", show(sum(cost_vector))];