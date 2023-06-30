
numClients = 20;
numServers = 7;
lb = ones(numClients, 1);
ub = ones(numClients, 1) * numServers;
opts = optimoptions('ga',...
    'PlotFcn',@gaplotbestf,...
    'MaxGenerations', 1200,...
    'MaxStallGenerations', 1200,...
    'PopulationSize', 3200,...
    'EliteCount', 1,...
    'SelectionFcn', {@selectiontournament,6},...
    'CrossoverFraction', 1,...
    'CrossoverFcn', 'crossoverscattered',...
    'MigrationFraction', 0.0,...
    'FitnessScalingFcn', 'fitscalingprop');

intcon = linspace(1, numClients, numClients);

indexes = ga(@finalCost, numClients,[],[],[],[],...
    lb,ub,[],intcon,opts);

%%-------------------------------------------------------------------------------------------------

allocations = false(numServers, numClients);
for i = 1:numClients
    allocations(indexes(i), i) = true;
end
display(allocations);


%%-------------------------------------------------------------------------------------------------

resourceRequirements = ...
[12 ,18 ,15 ,12 ,15 ,14 ,14 ,12 ,10 ,12 ,11 ,20 ,18 ,10 ,19 ,10 ,16 ,11 ,10 ,16;
12 ,10 ,12 ,14 ,19 ,20 ,19 ,15 ,10 ,18 ,19 ,10 ,10 ,18 ,11 ,17 ,20 ,14 ,15 ,17;
16 ,20 ,15 ,15 ,10 ,17 ,15 ,18 ,11 ,12 ,14 ,19 ,15 ,13 ,12 ,20 ,19 ,10 ,11 ,17;
17 ,17 ,17 ,12 ,13 ,17 ,19 ,18 ,16 ,13 ,11 ,16 ,10 ,13 ,14 ,18 ,19 ,18 ,14 ,20;
17 ,20 ,13 ,20 ,12 ,18 ,16 ,11 ,10 ,16 ,12 ,15 ,13 ,16 ,17 ,20 ,20 ,18 ,16 ,13;
17 ,19 ,12 ,18 ,16 ,20 ,12 ,16 ,12 ,15 ,15 ,20 ,16 ,14 ,11 ,17 ,20 ,18 ,14 ,20;
10 ,20 ,15 ,16 ,13 ,13 ,18 ,12 ,17 ,12 ,16 ,17 ,13 ,19 ,13 ,14 ,17 ,12 ,13 ,20];

clientWeigh = ...
[1, 1, 1, 1, 2, 2, 2, 2, 4, 4, 4, 4, 8, 8, 8, 8, 16, 16, 16, 16];  

resourceCosts = ...
[1, 1, 1, 2, 2, 4, 4];

serverResources = ...
[300, 200, 100, 300, 200, 600, 600];

for j = 1:numServers
    resources = 0;
    for i = 1:numClients
        if allocations(j, i)
            resources = resources + clientWeigh(i) * resourceRequirements(j, i);
        end
    end

    overload = resources - serverResources(j);
    if overload > 0
        y = y + overload * overloadConstant;
    end
    display(overload);
end

%%-------------------------------------------------------------------------------------------------

y = 0;
for i = 1:numClients
    for j = 1:numServers
        if allocations(j, i)
            y = y + clientWeigh(i) * resourceRequirements(j, i) * resourceCosts(j);
        end
    end
end
display(y);

%%-------------------------------------------------------------------------------------------------
function y = finalCost(indexes)
    numClients = 20;
    numServers = 7;

    allocations = false(numServers, numClients);
    for i = 1:numClients
        allocations(indexes(i), i) = true;
    end

    resourceRequirements = ...
    [12 ,18 ,15 ,12 ,15 ,14 ,14 ,12 ,10 ,12 ,11 ,20 ,18 ,10 ,19 ,10 ,16 ,11 ,10 ,16;
    12 ,10 ,12 ,14 ,19 ,20 ,19 ,15 ,10 ,18 ,19 ,10 ,10 ,18 ,11 ,17 ,20 ,14 ,15 ,17;
    16 ,20 ,15 ,15 ,10 ,17 ,15 ,18 ,11 ,12 ,14 ,19 ,15 ,13 ,12 ,20 ,19 ,10 ,11 ,17;
    17 ,17 ,17 ,12 ,13 ,17 ,19 ,18 ,16 ,13 ,11 ,16 ,10 ,13 ,14 ,18 ,19 ,18 ,14 ,20;
    17 ,20 ,13 ,20 ,12 ,18 ,16 ,11 ,10 ,16 ,12 ,15 ,13 ,16 ,17 ,20 ,20 ,18 ,16 ,13;
    17 ,19 ,12 ,18 ,16 ,20 ,12 ,16 ,12 ,15 ,15 ,20 ,16 ,14 ,11 ,17 ,20 ,18 ,14 ,20;
    10 ,20 ,15 ,16 ,13 ,13 ,18 ,12 ,17 ,12 ,16 ,17 ,13 ,19 ,13 ,14 ,17 ,12 ,13 ,20];
    
    clientWeigh = ...
    [1, 1, 1, 1, 2, 2, 2, 2, 4, 4, 4, 4, 8, 8, 8, 8, 16, 16, 16, 16];  

    resourceCosts = ...
    [1, 1, 1, 2, 2, 4, 4];
    
    serverResources = ...
    [300, 200, 100, 300, 200, 600, 600];

    y = 0;
    for i = 1:numClients
        for j = 1:numServers
            if allocations(j, i)
                y = y + clientWeigh(i) * resourceRequirements(j, i) * resourceCosts(j);
            end
        end
    end

    % soft constrains
    overloadConstant = 500;

    % server resources
    for j = 1:numServers
        resources = 0;
        for i = 1:numClients
            if allocations(j, i)
                resources = resources + clientWeigh(i) * resourceRequirements(j, i);
            end
        end

        overload = resources - serverResources(j);
        if overload > 0
            y = y + overload * overloadConstant;
        end
    end
end
