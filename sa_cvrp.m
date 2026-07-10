function [bestRoutes, bestCost] = sa_cvrp(routes0, D, demand, cap, opts)%بهینه سازی مسیرهابا SAا
% opts: T0, Tmin, alpha, itersPerT, penalty

if ~isfield(opts,'T0'), opts.T0=1000; end%دمای اولیه
if ~isfield(opts,'Tmin'), opts.Tmin=1e-3; end%وقتی دما خیلی کم شد → توقف
if ~isfield(opts,'alpha'), opts.alpha=0.95; end%نرخ سرد شدن
if ~isfield(opts,'itersPerT'), opts.itersPerT=500; end%تعداد تکرار در هر دما
if ~isfield(opts,'penalty'), opts.penalty=1e6; end%اگر ظرفیت نقض شد → جریمه بزرگ
%شروع از جواب Greedy
cur = routes0;
[curCost, curFeas] = cvrp_cost(cur,D,demand,cap);%هزینه و معتبر بودن جواب اولیه
curObj = curCost + (~curFeas)*opts.penalty;% هزینه نهایی با در نظر گرفتن جریمه نقض محدودیت

bestRoutes = cur;
bestCost = curCost;
%SA
T = opts.T0;
while T > opts.Tmin%تا وقتی دما بالاست ادامه بده
    for it=1:opts.itersPerT%در هر دما چند بار تلاش می‌کنه
        neigh = neighbor_move(cur, demand, cap);
        [ncost, nfeas] = cvrp_cost(neigh,D,demand,cap);%ارزیابی همسایه
        nobj = ncost + (~nfeas)*opts.penalty;

        dE = nobj - curObj;%اختلاف کیفیت جواب جدیدوجواب فعلی 
        if dE < 0 || rand < exp(-dE/T)
            cur = neigh; curObj = nobj;%اپدیت جواب
            curCost = ncost; curFeas = nfeas;
            if curFeas && curCost < bestCost
                bestCost = curCost;
                bestRoutes = cur;
            end
        end
    end
    T = T * opts.alpha;%دما کم‌کم کاهش پیدا می‌کنه.
end
end

function neigh = neighbor_move(routes, demand, cap)
% pick a move type
p = rand;
if p < 0.4
    neigh = move_relocate(routes);
elseif p < 0.8
    neigh = move_swap(routes);
else
    neigh = move_2opt(routes);
end
% (feasibility will be handled by penalty; you can also enforce feasibility here)
end

function out = move_relocate(routes)
out = routes;
if numel(out) < 1, return; end

% pick source route with at least 1 customer
idx = find(cellfun(@(r) numel(r)>3, out));
if isempty(idx), return; end
a = idx(randi(numel(idx)));%انتخاب تصادفی مسیر
ra = out{a};

% یک مشتری تصادفی حذف میشه.
pos = randi([2, numel(ra)-1]);
node = ra(pos);
ra(pos) = [];

% pick target route
b = randi(numel(out));
rb = out{b};%مشتری در مسیر جدید قرار می‌گیره.
insertPos = randi([2, numel(rb)]); % before last depot allowed
rb = [rb(1:insertPos-1), node, rb(insertPos:end)];%درج مشتری

out{a}=ra; out{b}=rb;
end
%خوبه چون توزیع مشتری ها بهتر میشه و ظرفیت ها متعادل تر میشن

function out = move_swap(routes)
out = routes;
idx = find(cellfun(@(r) numel(r)>3, out));
if numel(idx) < 1, return; end
a = idx(randi(numel(idx)));%انتخاب دو مسیر
b = idx(randi(numel(idx)));

ra = out{a}; rb = out{b};
pa = randi([2, numel(ra)-1]);%انتخاب دو مشتری
pb = randi([2, numel(rb)-1]);

tmp = ra(pa); ra(pa)=rb(pb); rb(pb)=tmp;
out{a}=ra; out{b}=rb;
end
%خوبه چون ترتیب مشتری ها بهتر میشه و هزینه ها کاهش پیدا میکنه
function out = move_2opt(routes)%بخشی از مسیر برعکس میشه که مسیر کوتاهتر بشه
out = routes;
idx = find(cellfun(@(r) numel(r)>4, out));
if isempty(idx), return; end
a = idx(randi(numel(idx)));
r = out{a};

i = randi([2, numel(r)-3]);
j = randi([i+1, numel(r)-2]);

r( i:j ) = r( j:-1:i );%برعکس کردن ترتیب.
out{a} = r;
end
%سادس و برای مسیریابی عالیه