function [costs, bestSol] = TS(jobs, m, n, listLength, iterations, costFunc, getBestNeighbor)
% This function implements the tabu search algorithm for Hybird Job Shop Sceduling
	
	costs = [];
    tabuList = zeros(2,listLength);
    
    % Firstly, randomly generate an initial solution given m and n
    % Set the best solution to the initial solution
    bestSol = ones(1, n);
    for i = 1 : m
        bestSol(i) = randi([1,m],1);
    end
    bestSolCost = costFunc(bestSol, jobs, m, n);
	costs(1)=bestSolCost;

	sol = bestSol;
    for i = 2 : (iterations+1)
        % Get the best solution in the neighbourhood of the current solution
        % avoiding Tabu moves
		[sol, solCost, tabuList, cantMove] = getBestNeighbor(sol, jobs, m, n, tabuList, bestSolCost, costFunc);
		costs(i)=solCost;
        if (cantMove ==1)
			break;
		else% Update the best solution
			if (solCost<bestSolCost)
				bestSol = sol;
				bestSolCost = solCost;
			end
		end
    end
end
