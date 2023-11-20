% do a complete prediction, return forecasting results on testing set
function p_test = forecast_SSA(xl, xu, end_train, lag, horizon, Y_Ttest)

    [~, col] = size(xl);
    pl_test = zeros(size(Y_Ttest,1),col); % save left series predictions
    pu_test = zeros(size(Y_Ttest,1),col);
    
    parfor imf=1:col
        disp(['###now forecast IMF: ', num2str(imf) ,'###']); % xTrain1: lag*n_tr        
        %% training-testing split and normalization
        [output_train, inputn, outputn, inputn_test, outputps] = dataPre(imf, xl, xu, end_train, lag, horizon);  

        %% Obtain the number of input layer nodes and output layer nodes£¬and determine the optimal number of hidden layer nodes
        inputnum=size(inputn,1);
        outputnum=size(outputn,1);     
        hiddennum_best = hiddennum(inputnum, outputnum, inputn, outputn);
        
        %% SSA to find optimal weights
        [Best_pos, curve, net] = SSA(inputn, outputn, output_train, inputnum, outputnum, hiddennum_best, outputps); 
        Best_score = curve(end); 
        setdemorandstream(pi);
        
        %% plot evolution curve
        figure
        plot(curve,'r-','linewidth',2)
        xlabel('generation')
        ylabel('rmse')
        legend('best fitness')
        title('SSA evolution converge curve')
        w1=Best_pos(1:inputnum*hiddennum_best);         %weights between input and hidden layer
        B1=Best_pos(inputnum*hiddennum_best+1:inputnum*hiddennum_best+hiddennum_best);   %biases of hidden layer
        w2=Best_pos(inputnum*hiddennum_best+hiddennum_best+1:inputnum*hiddennum_best+hiddennum_best+hiddennum_best*outputnum);   %weights between hidden and output layer
        B2=Best_pos(inputnum*hiddennum_best+hiddennum_best+hiddennum_best*outputnum+1:inputnum*hiddennum_best+hiddennum_best+hiddennum_best*outputnum+outputnum);   %biases of output layer
        %weight matrix reshape 
        net.iw{1,1}=reshape(w1,hiddennum_best,inputnum);
        net.lw{2,1}=reshape(w2,outputnum,hiddennum_best);
        net.b{1}=reshape(B1,hiddennum_best,1);
        net.b{2}=reshape(B2,outputnum,1);

        %% train with optimal weights
        net=train(net,inputn,outputn);

        %% forecast on testing set
        an1=net(inputn_test);
        test_simu1=mapminmax('reverse',an1,outputps)'; 

        %% save preditions
        pu_test(:, imf) = test_simu1(:,1); 
        pl_test(:, imf) = test_simu1(:,2); 
        
    end
    
    %% ensemble
    p_test = [sum(pl_test,2) sum(pu_test,2)]; 

end

