include "globals.mzn";
include "urban_3.dzn";
int : n;
int : n_commercial;
int : n_residential;
array[1..n+1] of int : point_distribution;

% Placements represents a grid of ones and zeros, 1 = residential, 0 = commercial.
% The points array saves all points in a array representing first row then cols. 
% This is calculated by a one-liner that sums the residentials in a row or col and gets the point for that row or col from the point distribution. 
% The + 1 is needed as arrays in minizinc starts at 1.
array[1..n, 1..n] of var 0..1 : placements;
array[1..n*2] of var int : points = [point_distribution[sum(j in 1..n)(if i <= n then placements[i,j] else placements[j, i-n] endif) + 1] | i in 1..n*2];

% lex2 is used for breaking sym
% sum(placements) = n_residential is for making sure we always have n_residential and n_commercial in our grid.  
constraint lex2(placements);
constraint sum(placements) = n_residential;

solve :: int_search(placements, first_fail, indomain_max, complete) maximize sum(points);

%output["\(sum(points))"];
output["\(sum(points))", "\nPoints = ", show(points), "\nGrid = ", show(placements)];