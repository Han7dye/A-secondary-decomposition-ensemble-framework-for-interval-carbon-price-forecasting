% interval error metrics calculation
function [U,ARV,MAPEI,CR,RMSDE]= iptest(Y_pred,Y_true)
AA = Y_true;
TT = Y_pred;

%tranform into column vectors, n*2
[g,k]=size(TT);
if k == 2
    TT = TT;
else
    TT =TT';
end
[g,k]=size(AA);
if k == 2
    AA = AA;
else
    AA =AA';
end

% U, ARV
a1 =0;a2=0;a3=0;a4=0;a5 =0;a6=0;
[g,k]=size(AA);
AA_m = mean(AA); 
for i = 2:1:g
    %upper limit is the first column, lower limit is the second column
    a = (AA(i,2)-TT(i,2))^2;
    a1 = a1+a;
    
    b = (AA(i,1)-TT(i,1))^2;
    a2 =a2+b;
    
    c = (AA(i,2)-AA(i-1,2))^2;
    a3 =a3+c;

    d = (AA(i,1)-AA(i-1,1))^2;
    a4 =a4+d;
    
    e = (AA(i,2)-AA_m(2))^2;
    a5=a5+e;
    
    f = (AA(i,1)-AA_m(1))^2;
    a6=a6+f;
    
end

U=((a1+a2)/(a3+a4))^0.5;
ARV=(a1+a2)/(a5+a6);

% CR
CR=[];

RMSDE = 0;
for i=1:g
    ub = min(AA(i,2),TT(i,2));
    lb = max(AA(i,1),TT(i,1));
    if lb >= ub
        cr = 0;
    else
        cr = (ub-lb)/(AA(i,2)-AA(i,1));
    end
    CR = [CR cr];
    RMSDE =RMSDE+ (AA(i,1)-TT(i,1))^2 + (AA(i,2)-TT(i,2))^2 + 2*abs(AA(i,1)-TT(i,1))*abs(AA(i,2)-TT(i,2));
end
CR = mean(CR);
RMSDE = sqrt(RMSDE)/g;

% MAPEI
[~,MAPE1,~,~,~] = ptest(TT(:,1),AA(:,1));
[~,MAPE2,~,~,~] = ptest(TT(:,2),AA(:,2));
MAPEI = 1/2 * (MAPE1+MAPE2);

end