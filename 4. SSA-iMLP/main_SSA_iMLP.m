tic;

clear
close all
clc
warning off

%% load data
data=load('hb.txt');
xl = load('hbl.txt'); 
xu = load('hbu.txt'); 
end_train = floor(0.8*length(data));
Y_Ttest=data(end_train+1:end,:);

lag = 5;
horizons=[1 2 3]; % forecasting step size
repeat_times = 5; % repeat to overcome randomness

for ind=1:3 % loop over step size setting
    results = cell(1, repeat_times); 
    errors = zeros(repeat_times, 5); % save error metric values of each repeated trial
    horizon = horizons(ind);
    
    parfor repeat=1:1:repeat_times

        %% forecast on testing set
        p_test = forecast_SSA(xl, xu, end_train, lag, horizon, Y_Ttest);
        results{repeat} = p_test;
        %% error metric computing
        [U,ARV,MAPEI,CR,RMSDE]=iptest(p_test, Y_Ttest);
        error = [U,ARV,MAPEI,CR,RMSDE];
        errors(repeat,:) = error;

    end
    
    save(['results/SSA-iMLP-primary/GD-' num2str(lag) '-' num2str(horizon)]);

end
toc;
