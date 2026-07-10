function run_vrp_A32()%تابع اصلی پروژه
data = read_vrp_tsplib("A-n32-k5.vrp");
D = distmat_euc2d(data.coords); %فاصله ی بین همه ی نقاط  

routes0 = initial_greedy_cvrp(D, data.demand, data.capacity, data.depot); % ساخت یک جواب اولیه با الگوریتم گریدی
[c0, feas0] = cvrp_cost(routes0, D, data.demand, data.capacity);% محاسبه هزینه و بررسی معتبر بودن جواب اولیه
fprintf("Initial cost = %.2f | feasible=%d\n", c0, feas0);
plot_routes(routes0, data.coords, data.depot, sprintf("Initial | cost=%.2f", c0));%رسم مسیر اولیه
%SA
opts = struct('T0',2000,'Tmin',1e-2,'alpha',0.95,'itersPerT',800,'penalty',1e8);
[bestRoutes, bestCost] = sa_cvrp(routes0, D, data.demand, data.capacity, opts);

fprintf("SA best cost = %.2f\n", bestCost);
plot_routes(bestRoutes, data.coords, data.depot, sprintf("SA | cost=%.2f", bestCost));%مسیرهای بهینه 

% Benchmark comparison
BKS = 784; %بهترین جواب شناخته‌شده.
gap = (bestCost - BKS)/BKS*100;%اگه کوچک باشه خوبه
fprintf("BKS=%d | gap=%.2f%%\n", BKS, gap);
end