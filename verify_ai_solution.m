function verify_ai_solution(aiText, vrpFile)


data = read_vrp_tsplib(vrpFile);
D = distmat_euc2d(data.coords);%ماتریس فاصله

routes = parse_ai_routes(aiText);

% Basic checks
[ok, report] = check_cvrp_solution(routes, data.demand, data.capacity, data.depot, size(data.coords,1));%بررسی اولیه (ساختاری + ظرفیت)
disp(report);

% Compute true cost (EUC_2D)
[cost, feas] = cvrp_cost(routes, D, data.demand, data.capacity);
fprintf("Computed total distance (MATLAB): %.2f | feasible=%d\n", cost, feas);

% Plot
plot_routes(routes, data.coords, data.depot, sprintf("AI solution | cost=%.2f | feasible=%d", cost, feas));
end

function routes = parse_ai_routes(aiText)%متن AI رو تبدیل می‌کنه به مسیر واقعی

lines = splitlines(string(aiText));
routes = {};

for i = 1:numel(lines)
    L = strtrim(lines(i));%حذف فاصله
    if startsWith(lower(L), "route")
        % take part after ':'
        if ~contains(L, ":"), continue; end
        rhs = strtrim(extractAfter(L, ":"));%فقط مسیر باقی می‌مونه.

        % remove anything after '('
        p = strfind(rhs, "(");
        if ~isempty(p)
            rhs = strtrim(extractBefore(rhs, p(1)));
        end

        % split by '-' and parse ints
        parts = split(rhs, "-");%اعداد را جدا می‌کند.
        nums = zeros(1, numel(parts));
        for k=1:numel(parts)
            nums(k) = str2double(strtrim(parts(k)));%تبدیل متن به عدد
        end
        nums = nums(~isnan(nums));

        if numel(nums) >= 2
            routes{end+1} = nums; 
        end
    end
end

if isempty(routes)
    error("Could not parse any routes. Make sure AI output uses 'Route k: 1 - ... - 1'.");
end
end

function [ok, report] = check_cvrp_solution(routes, demand, cap, depot, nNodes)

customers = setdiff(1:nNodes, depot);%مشتری بدون دیپوت
seen = [];%ذخیره مشتری هایی که دیده شدند

ok = true;
msgs = strings(0,1);

for r = 1:numel(routes)
    rt = routes{r};
    if rt(1) ~= depot || rt(end) ~= depot
        ok = false;
        msgs(end+1) = sprintf("Route %d does not start/end at depot (%d).", r, depot);
    end

    inner = rt(2:end-1);
    if any(inner == depot)
        ok = false;
        msgs(end+1) = sprintf("Route %d contains depot inside the route.", r);
    end

    load = sum(demand(inner));
    if load > cap
        ok = false;
        msgs(end+1) = sprintf("Route %d violates capacity: load=%g > cap=%g.", r, load, cap);
    end

    seen = [seen, inner(:)']; 
end

% Check each customer appears exactly once
missing = setdiff(customers, unique(seen));%برسی مشتری هایی که سرویس نگرفتن
dup = customers(histcounts(seen, 0.5:1:(nNodes+0.5)) > 1);%اگر مشتری دوبار دیده شود مشخص میشه

if ~isempty(missing)
    ok = false;
    msgs(end+1) = "Missing customers: " + join(string(missing), ", ");
end
if ~isempty(dup)
    ok = false;
    msgs(end+1) = "Duplicated customers: " + join(string(dup), ", ");
end

% Check for invalid nodes
invalid = setdiff(unique(seen), customers);
if ~isempty(invalid)
    ok = false;
    msgs(end+1) = "Invalid nodes used: " + join(string(invalid), ", ");
end

if ok
    report = "✅ AI routes PASS structural+capacity checks.";
else
    report = "❌ AI routes FAIL checks:" + newline + join(msgs, newline);
end
end