%% merge the end points of interval data
function data=crossadd(datai,lag)
[g,k]=size(datai);
for i =1:1:k
    AA = datai(1:lag,i);
    TT = datai(lag+1:end,i);
    c=[AA,TT];
    Seriesi = reshape(c',[],1);
    data(:,i) = Seriesi;
end


end