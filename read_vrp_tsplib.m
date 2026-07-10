function data = read_vrp_tsplib(filename)
%مجموعه داده استاندارد

txt = fileread(filename);
lines = splitlines(string(txt));
%متغیرهای اولیه ساخته میشن.
data.name = "";
data.capacity = NaN;
data.dimension = NaN;

%header
for i=1:numel(lines)
    L = strtrim(lines(i));%حذف فاصله‌های اضافی
    if startsWith(L,"NAME")%بررسی میکنه ایا این خط با اسم شروع شده .
        data.name = strtrim(extractAfter(L, ":"));
    elseif startsWith(L,"DIMENSION")
        data.dimension = str2double(strtrim(extractAfter(L, ":")));
    elseif startsWith(L,"CAPACITY")
        data.capacity = str2double(strtrim(extractAfter(L, ":")));
    end
end

% locate sections
idxCoord = find(contains(lines,"NODE_COORD_SECTION"),1);
idxDem   = find(contains(lines,"DEMAND_SECTION"),1);
idxDepot = find(contains(lines,"DEPOT_SECTION"),1);

n = data.dimension;

% مختصات
coords = zeros(n,2);
for k=1:n
    parts = sscanf(lines(idxCoord+k), "%d %f %f");%خواندن مختصات
    coords(parts(1),:) = parts(2:3).';
end

% تقاضا
dem = zeros(n,1);
for k=1:n
    parts = sscanf(lines(idxDem+k), "%d %f");%خواندن شماره نود و مقدار تقاضا
    dem(parts(1)) = parts(2);%استخراج تقاضای هر مشتری
end

% depot
%خواندنdepot 
depotId = sscanf(lines(idxDepot+1), "%d");%معمولا اولین عدد
data.depot = depotId;
%همه داده‌ها داخل struct ذخیره میشن.
data.coords = coords;
data.demand = dem;
end