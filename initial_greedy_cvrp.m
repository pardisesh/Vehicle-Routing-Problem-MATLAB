function routes = initial_greedy_cvrp(D, demand, cap, depot)%جواب اولیه سریع و مناسب براب اس ای
% routes: cell array, each route is [depot ... depot]
n = size(D,1);
customers = setdiff(1:n, depot);%مشتری‌هااز دیپوت جدا میشن
unserved = true(1,n);
unserved(depot)=false;%دیپوت از اول سرویس گرفته فرض میشودچون مشتری نیس

routes = {};
while any(unserved(customers))
%شروع مسیر جدید
    load = 0;%بار فعلی ماشین
    cur = depot;%نقطه فعلی (شروع از depot)
    r = depot;%مسیر جدید

    while true
        cand = customers(unserved(customers));
        if isempty(cand), break; end

        % feasible candidates by remaining capacity
        feas = cand(demand(cand) + load <= cap);%فقط مشتری‌هایی رو انتخاب می‌کنه که ظرفیت رو نقض نکنن
        if isempty(feas), break; end

        % nearest feasible
        [~,ix] = min(D(cur,feas));%نزدیکترین مشتری
        nxt = feas(ix);

        r(end+1)=nxt;%مشتری به مسیر اضافه میشه.
        load = load + demand(nxt);
        unserved(nxt)=false;
        cur = nxt;
    end

    r(end+1)=depot;
    routes{end+1}=r; %ذخیره مسیر ساخته‌شده
end
end