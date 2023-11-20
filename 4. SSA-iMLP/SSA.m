function [GBestX, curve, net] = SSA(inputn, outputn, output_train, inputnum, outputnum, hiddennum_best, outputps)

disp(' ')
disp('SSA-iMLP')
net=newff(inputn,outputn,hiddennum_best,{'tansig','purelin'},'trainlm');% create a model

%network parameter setting
net.trainParam.epochs=1000;         
net.trainParam.lr=0.001;                   % learning rate
net.trainParam.mc=0.6;                 % momentum
net.trainParam.showWindow = false; 
net.trainParam.showCommandLine = false; %does not show training window

%initialize SSA parameter
popsize=20;   %initial population size
maxgen=10;   %maximum generation
dim=inputnum*hiddennum_best+hiddennum_best+hiddennum_best*outputnum+outputnum;    %number of parameters
lb=repmat(-3,1,dim);    %lower limit
ub=repmat(3,1,dim);   %upper limit
ST = 0.6;%safe value
PD = 0.2;%proportion of producers
SD = 0.2;%proportion of sparrows aware of danger
PDNumber = popsize*PD; %number of producers
SDNumber = popsize - popsize*PD;%number of sparrows aware of danger

%% swarm initialization
X0 = [];
for i=1:dim
    ub_i=ub(i);
    lb_i=lb(i);
    rand('seed',sum(100*clock));
    X0(:, i)=rand(popsize,1).*(ub_i-lb_i)+lb_i;
end
%save(['X0' num2str(repeat) num2str(imf)], 'X0');
X = X0;
%% compute initial fitness value
fit = zeros(1,popsize);
for i = 1:popsize
    fit(i) =  fitness(X(i,:),inputnum,hiddennum_best,outputnum,net,inputn,outputn,output_train,outputps);
end
[fit, index]= sort(fit);%sort
BestF = fit(1);
WorstF = fit(end);
GBestF = fit(1);%global optimal fitness value
for i = 1:popsize
    X(i,:) = X0(index(i),:);
end
curve=zeros(1,maxgen);
GBestX = X(1,:);%global optimal position
X_new = X;
%% start optimizing
for i = 1: maxgen
    disp(['iteration: ',num2str(i)])
    BestF = fit(1);
    WorstF = fit(end);
    rand('seed',sum(100*clock)+i);
    R2 = rand(1);  %alarm value
    %update the position of producers
    for j = 1:PDNumber
        rand('seed',sum(100*clock)+j);
        if(R2<ST)
            X_new(j,:) = X(j,:).*exp(-j/(rand(1)*maxgen));
        else
            X_new(j,:) = X(j,:) + randn()*ones(1,dim);
        end
    end
    %update the position of scroungers
    for j = PDNumber+1:popsize
        randn('seed',sum(100*clock)+j);
        if(j>(popsize - PDNumber)/2 + PDNumber)
            X_new(j,:)= randn().*exp((X(end,:) - X(j,:))/j^2);
        else
            %random choice between -1 and 1
            A = ones(1,dim);
            for a = 1:dim
                rand('seed',sum(100*clock)+a);
                if(rand()>0.5)
                    A(a) = -1;
                end
            end
            AA = A'*inv(A*A');
            %disp(['dimension of AA£º', num2str(size(AA'))])
            %disp(['dimension of X(1,:)£º', num2str(size(X(1,:)))])
            X_new(j,:)= X(1,:) + abs(X(j,:) - X(1,:)).*AA';
        end
    end
    %update the positon of sparrows aware of the danger
    rand('seed',sum(100*clock)+i);
    Temp = randperm(popsize);
    SDchooseIndex = Temp(1:SDNumber);
    for j = 1:SDNumber
        rand('seed',sum(100*clock)+j);
        if(fit(SDchooseIndex(j))>BestF)
            X_new(SDchooseIndex(j),:) = X(1,:) + randn().*abs(X(SDchooseIndex(j),:) - X(1,:));
        elseif(fit(SDchooseIndex(j))== BestF)
            K = 2*rand() -1;
            X_new(SDchooseIndex(j),:) = X(SDchooseIndex(j),:) + K.*(abs( X(SDchooseIndex(j),:) - X(end,:))./(fit(SDchooseIndex(j)) - fit(end) + 10^-8));
        end
    end
    %control the boundaries
    for j = 1:popsize
        for a = 1: dim
            if(X_new(j,a)>ub)
                X_new(j,a) =ub(a);
            end
            if(X_new(j,a)<lb)
                X_new(j,a) =lb(a);
            end
        end
    end
    %get the new locations
    fitness_new = zeros(1, popsize);
    for j=1:popsize
        fitness_new(j) = fitness(X_new(j,:),inputnum,hiddennum_best,outputnum,net,inputn,outputn,output_train,outputps);
    end
    for j = 1:popsize
        % if the location is better than before, update
        if(fitness_new(j) < GBestF)
            GBestF = fitness_new(j);
            GBestX = X_new(j,:);
        end
    end
    X = X_new;
    fit = fitness_new;
    %update the sorting
    [fit, index]= sort(fit);%sort
    BestF = fit(1);
    WorstF = fit(end);
    for j = 1:popsize
        X(j,:) = X(index(j),:);
    end
    curve(i) = GBestF;

end
