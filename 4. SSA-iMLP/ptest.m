% point forecast error metrics calculation
function [Dstat,MAPE,RMSE,MSE,MAE]=ptest(AA,TT)
% this programme is used to evaluate the accuracy lever of prediction result AA

% input: AA -1*k         the prediction result
%        TT -1*k or k*1  the actual value of the predicted data 

% output: aaa=[Dstat;MAPE;RMSE]; MAPE - mean absolute percetage error;
%         RMSE - root mean squared error; Dstat - directional statistics

 sum1=0;sum2=0;sum3=0;sum4=0;
[g,k]=size(AA);
if k == 1
    AA = AA';
else
    AA =AA ;
end

[g,k]=size(AA);

for kk=1:k
    
    a=abs((AA(kk)-TT(kk))/TT(kk));   % MAPE
    sum1=a+sum1;
    
    b=(AA(kk)-TT(kk))^2;             % RMSE
    sum2=b+sum2;
    
    d = abs(AA(kk)-TT(kk));
    sum4 = sum4+d;
end

MAPE=100*sum1/k;        % MAPE
RMSE=(sum2/k)^0.5;  % RMSE
MSE = sum2/k;
MAE = sum4/k;
% [g2,k2]=size(TT);  
% if g2 == 1
%     TT = TT';
% else
%     TT = TT;
% end
for kkk=2:k
    if (AA(kkk)-TT(kkk-1))*(TT(kkk)-TT(kkk-1))>=0   %(AA(kkk)-TT(kkk-1))*(TT(kkk)-TT(kkk-1))>=0
        c(kkk)=1;
    else
        c(kkk)=0;
    end
        sum3=sum3+c(kkk);
end

Dstat=sum3/(k-1);  % Dstat
end


%  %draw a figure of AA and TT
%  plot(AA,'red');
%  hold on
%  plot(TT);
%  hold off