tic;

clear
close all
clc
warning off

%% load data
data=load('gd.txt');
xl = load('gdl.txt'); 
xu = load('gdu.txt'); 
end_train = floor(0.8*length(data));
Y_Ttest=data(end_train+1:end,:);

lag=10;
horizons = [1 2 3]; 
repeat_times = 5;

for ind = 1:3
    results = cell(1, repeat_times); 
    errors = zeros(repeat_times, 7); 
    horizon = horizons(ind);
    parfor repeat=1:1:repeat_times
        %% prections on testing set
        p_test = forecast(xl, xu, end_train, lag, horizon, Y_Ttest)
        results{repeat} = p_test;
        %% error metrics
        [U,ARV,MAPEI,CR,RMSDE]=iptest(p_test, Y_Ttest);
        error = [U,ARV,MAPEI,CR,RMSDE];
        errors(repeat,:) = error;
    end
    save(['results/iMLP-primary/GD-' num2str(lag) '-' num2str(horizon)]);
end
toc;