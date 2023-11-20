%compute the fitness value
function error = fitness(x,inputnum,hiddennum_best,outputnum,net,inputn,outputn,output_train,outputps)

hiddennum=hiddennum_best;
%extract
setdemorandstream(pi);

w1=x(1:inputnum*hiddennum);%extract the weights between input and hidden layer
B1=x(inputnum*hiddennum+1:inputnum*hiddennum+hiddennum);%extract biases in hidden layer
w2=x(inputnum*hiddennum+hiddennum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum);%extract weights between hidden and output layer
B2=x(inputnum*hiddennum+hiddennum+hiddennum*outputnum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum);%extract biases of output layer

net.trainParam.showWindow=0;  %hide the simulation window

%assign network parameters
%disp(w1)
net.iw{1,1}=reshape(w1,hiddennum,inputnum);
net.lw{2,1}=reshape(w2,outputnum,hiddennum);%change the save format of the matrix
net.b{1}=reshape(B1,hiddennum,1);%biases of hidden layer
net.b{2}=reshape(B2,outputnum,1);

%network training
net=train(net,inputn,outputn);

an0=sim(net,inputn);
train_simu=mapminmax('reverse',an0,outputps);

error=sqrt(mse(output_train,train_simu)); %take rmse as fitness function


