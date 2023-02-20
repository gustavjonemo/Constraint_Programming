include "globals.mzn";
include "urban_2.dzn";
include "jacop.mzn";

int: n;
int: n_commercial; %0
int: n_residential; %1
array[1..n+1] of int: point_distribution;
array[1..n, 1..n] of var 0..1: grid;
array[1..n*2] of var int: points; %First half = row points, second half = column points

%Makes sure the right amount of commercial/residential entities are present in the grid and fills the points array with correct values from point_distribution. Lex2 to break symmetry and speed up calculations.
constraint sum(i, j in 1..n)(grid[i,j]) = n_residential;
constraint forall(i in 1..n)(
  points[i] = point_distribution[sum(grid[.., i])+1] /\ 
  points[n+i] = point_distribution[sum(grid[i, ..])+1]
);
constraint lex2(grid);

var int: score = sum(i in 1..n*2)(points[i]);
solve maximize score;

output["Score = " , show(score), "\nPoints = ", show(points), "\nGrid = ", show(grid)];