include"globals.mzn";
include "a1_data_1.dzn";
include "alldifferent.mzn";

int: n;
int: n_prefs;
array[1..n_prefs, 1..2] of var int: prefs;
array[1..n] of var 1..n: line; %index = person, value = position
array[1..n] of var 0..n: dist = [distance(i) | i in 1..n];

function var int: distance(int: i) =
    abs(line[prefs[i, 1]] - line[prefs[i, 2]]);

constraint alldifferent(line);
     
solve minimize max(dist);
output ["Line: " ++ show(line) ++ "\n" ++
"Distances = " ++ show(dist) ++ "\n" ++
"Max distance: " ++ show(max(dist))];