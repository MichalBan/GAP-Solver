int: numClients = 20;

set of int: servers = 1..7;
set of int: clients = 1..numClients;

 

% resource requirements for given client for given server
array[servers, clients] of int: resourceRequirements = 
[|12 ,18 ,15 ,12 ,15 ,14 ,14 ,12 ,10 ,12 ,11 ,20 ,18 ,10 ,19 ,10 ,16 ,11 ,10 ,16
|12 ,10 ,12 ,14 ,19 ,20 ,19 ,15 ,10 ,18 ,19 ,10 ,10 ,18 ,11 ,17 ,20 ,14 ,15 ,17
|16 ,20 ,15 ,15 ,10 ,17 ,15 ,18 ,11 ,12 ,14 ,19 ,15 ,13 ,12 ,20 ,19 ,10 ,11 ,17
|17 ,17 ,17 ,12 ,13 ,17 ,19 ,18 ,16 ,13 ,11 ,16 ,10 ,13 ,14 ,18 ,19 ,18 ,14 ,20
|17 ,20 ,13 ,20 ,12 ,18 ,16 ,11 ,10 ,16 ,12 ,15 ,13 ,16 ,17 ,20 ,20 ,18 ,16 ,13
|17 ,19 ,12 ,18 ,16 ,20 ,12 ,16 ,12 ,15 ,15 ,20 ,16 ,14 ,11 ,17 ,20 ,18 ,14 ,20
|10 ,20 ,15 ,16 ,13 ,13 ,18 ,12 ,17 ,12 ,16 ,17 ,13 ,19 ,13 ,14 ,17 ,12 ,13 ,20|];

% resource requirement modifier for client
array[clients] of int: clientWeigh = 
[1, 1, 1, 1, 2, 2, 2, 2, 4, 4, 4, 4, 8, 8, 8, 8, 16, 16, 16, 16];
 

% cost of resources for given server
array[servers] of int: resourceCosts = 
[1, 1, 1, 2, 2, 4, 4];
 

% limit of resources for given server
array[servers] of int: serverResources = 
[300, 200, 100, 300, 200, 600, 600];


% array of allocations (1 on allocation, 0 otherwise)
array[servers, clients] of var int: allocations;

% cost to minimize

var int: finalCost = sum(i in clients, j in servers)(clientWeigh[i] * resourceRequirements[j, i] * allocations[j, i] * resourceCosts[j]);

 

% no negative allocations
constraint forall(i in clients, j in servers)( 
  allocations[j, i] >= 0
);

 

% a client must be allocated exactly once
constraint forall(i in clients)(
  sum(j in servers)(allocations[j, i]) == 1
);

% allocated resources must be smaller or equal than server resources  
constraint forall(j in servers)(
  sum(i in clients)(clientWeigh[i] * resourceRequirements[j, i] * allocations[j, i]) <= serverResources[j]

);     

solve minimize finalCost;

output ["\(allocations[j, i])" ++ if i == (numClients) then "\n" else " " endif | j in servers, i in clients] ++ ["\n\(finalCost)"]
%output ["\(finalCost)"]
