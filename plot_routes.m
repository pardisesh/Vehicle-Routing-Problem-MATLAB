function plot_routes(routes, coords, depot, ttl)

figure; hold on;


plot(coords(:,1), coords(:,2), 'ko', 'MarkerFaceColor','w');%مشتری‌ها رو رسم می‌کنه

% plot depot
plot(coords(depot,1), coords(depot,2), 'rs', ...
     'MarkerSize',10,'LineWidth',2,'MarkerFaceColor','r');

colors = lines(numel(routes));   

for k = 1:numel(routes)
    r = routes{k};%مسیر مربوط به وسیله نقلیه k

    % حذف مسیر خالی
    if numel(r) <= 2
        continue;
    end

    xy = coords(r,:);%مختصات مسیر رو استخراج می‌کنه
    plot(xy(:,1), xy(:,2), '-o', ...
         'Color', colors(k,:), ...
         'LineWidth', 1.5, ...
         'MarkerSize', 5);
end

title(ttl);
axis equal;%محور برابر است
grid on;

end