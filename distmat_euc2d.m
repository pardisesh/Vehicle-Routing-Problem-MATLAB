function D = distmat_euc2d(coords)%ماتریس فاصله بین همه نقاط
n = size(coords,1);%محاسبه تعداد نقاط
D = zeros(n,n);%ماتریس خالی برای ذخیره فاصله‌ها
for i=1:n%انتخاب اولین نقطه
    for j=i+1:n%محاسبه نصف ماتریس برای کاهش محاسبات
        d = hypot(coords(i,1)-coords(j,1), coords(i,2)-coords(j,2));%فاصله اقلیدسی بین دو نقطه
        D(i,j)=d; D(j,i)=d;
    end
end
end