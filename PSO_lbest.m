function [costs, bestSol] = PSO(jobs, m, n, particals, iterations, costFunc)
  c1 = 1.4944;
  c2 = 1.4944;
  w = 0.9;
  gbests = ones(1, n);
  gbest = costFunc(gbests, jobs, m, n);
  lbests = randi(m, particals, n);
  lbest = ones(1, particals);
  nbests = lbests;
  nbest = lbest;
  nsize = 2;
  for i = 1:particals
      lbest(i) = costFunc(lbests(i, :), jobs, m, n);
      %if lbest(i) < gbest
      %    gbest = lbest(i);
      %    gbests = lbests(i, :);
      %end
      nbest(i) = lbest(i);
  end
  for i = 1:particals
      for k = (i-nsize-1):(i+nsize-1)
          if lbest(i) < nbest(mod(k, particals) + 1)
              nbest(mod(k, particals) + 1) = lbest(i);
              nbests(mod(k, particals) + 1, :) = lbests(i, :);
          end
      end
  end
  x = lbests;
  v = zeros(particals, n);
  
  for i = 1:iterations
      ibests = ones(particals, n);
      ibest = ones(1, particals);
      r1 = rand(particals, 1);
      r2 = rand(particals, 1);
      %v = w*v + c1 * bsxfun(@times, r1, lbests - x) + ...
      %  c2 * bsxfun(@times, r2, (bsxfun(@minus, gbests, x)));
      v = w*v + c1 * bsxfun(@times, r1, lbests - x) + ...
        c2 * bsxfun(@times, r2, nbests - x);
      x = round(x + v);
      %x = bsxfun(@mod, x-1, m) + 1;
      x(x < 1) = 1;
      x(x > m) = m;
      for j = 1:particals
          c = costFunc(x(j, :), jobs, m, n);
          if c < lbest(j)
              lbest(j) = c;
              lbests(j, :) = x(j, :);
              for k = (j-nsize-1):(j+nsize-1)
                  if lbest(j) < nbest(mod(k, particals) + 1)
                      nbest(mod(k, particals) + 1) = lbest(j);
                      nbests(mod(k, particals) + 1, :) = lbests(j, :);
                  end
              end
          end
      end
      [ibest, idx] = min(lbest);
      %ibest
      ibests = lbests(idx, :);
      if ibest < gbest
          gbest = ibest;
          gbests = ibests;
      end
  end
  %v
  costs = gbest;
  bestSol = gbests;
end