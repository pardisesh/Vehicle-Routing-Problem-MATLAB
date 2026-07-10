function [cost, feas] = cvrp_cost(routes, D, demand, cap)%محاسبه هزینه کل مسیرها و بررسی محدودیت ظرفیت
cost = 0;%مقدار اولیه هزینه
feas = true;
for k=1:numel(routes)%روی تمام مسیرها حرکت می‌کنه.
    r = routes{k};
    load = sum(demand(r(2:end-1)));%مجموع تقاضای مشتری‌های داخل مسیر
    if load > cap
        feas = false;
    end
    for i=1:numel(r)-1%بین هر دو نقطه پشت‌سرهم حرکت می‌کنه.
        cost = cost + D(r(i), r(i+1));%اضافه کردن فاصله بین دو نود متوالی به هزینه کل
    end
end
end