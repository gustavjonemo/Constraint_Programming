include "a1_data_1.dzn";
include "globals.mzn";
include "Alldifferent.mzn";

int: n;
int: n_prefs;
array[1..n_prefs, 1..2] of 1..n: prefs;
array[1..n] of var 1..n: line;
array[1..n_prefs] of var 1..n_prefs: dist = [count(i) | i in 1..n_prefs];


constraint alldifferent(line);
 
function var int: count(int: i) = abs(line[prefs[i, 1]]-line[prefs[i, 2]]);
  
var int: pref_match = sum(i in 1..n) (dist[i] = 1);

solve maximize pref_match;
output ["Photo line: " ++ show(line) ++ "\n" ++ 
"#pref. matches: " ++ show(pref_match)];