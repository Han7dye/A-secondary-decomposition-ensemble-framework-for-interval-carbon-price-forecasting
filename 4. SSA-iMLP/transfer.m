function [X_train,Y_train,X_test,Y_test]=transfer(indata,lag_day,horizon,interval,start_train,end_train)

%   input   
%  indata          : N * m vector with the input of original data
%  lag             : 1 * 1
%  horizon         : 1 * 1
%  start_train     : 1 * 1
%  end_train       : 1 * 1
%  length_test     : 1 * 1

%  output

%    X_train              : x  for training 
%    Y_train              : y  for training 
%    X_test               : x  for testing
%    Y_test               : y  for testing

total_lag_day=lag_day+horizon-1;
input_node=ceil(lag_day/interval);
index=start_train;
train_size=end_train-start_train+1-total_lag_day;
for i=1:train_size
   orip(:,i)= indata(index:index+lag_day -1);
   T(i)=indata(index+total_lag_day,1);
   pointer=lag_day;
   for j=input_node:-1:1 
      P(j,i)=orip(pointer,i);
      pointer=pointer-interval;
   end
   index=index+1;
end
start_test=end_train+1;
start_test=start_test-total_lag_day;
index=start_test;
testsize=length(indata)-start_test+1-total_lag_day;
for i=1:testsize
   oritestp(:,i) = indata(index:index+lag_day -1);
   act(i)=indata(index + total_lag_day );
   pointer= lag_day;
   for j=input_node:-1:1
      testp(j,i)=oritestp(pointer,i);
      pointer=pointer-interval;
   end
   index=index+1;
end

X_train=P;
Y_train=T;
X_test=testp;
Y_test=act;

