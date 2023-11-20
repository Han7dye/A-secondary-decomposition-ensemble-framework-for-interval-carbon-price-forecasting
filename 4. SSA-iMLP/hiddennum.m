function hiddennum_best = hiddennum(inputnum, outputnum, inputn, outputn)

        disp('/////////////////////////////////')
        disp('neural network structure...')
        disp(['number of input layer nodes: ',num2str(inputnum)])
        disp(['number of output layer nodes: ',num2str(outputnum)])
        disp(' ')
        disp('now determine the number of hidden layer...')

        %use empirical formula, hiddennum=sqrt(m+n)+a£¬m is number of input layer nodes£¬n is number of output layer nodes£¬a is an integer ranging from 1 to 10
        RMSE=1e+5; %initialize the minumum error
        for hiddennum=fix(sqrt(inputnum+outputnum))+1:fix(sqrt(inputnum+outputnum))+10
            %create a network
            net=feedforwardnet(hiddennum);
            % network parameters
            net.trainParam.epochs=1000;         
            net.trainParam.lr=0.001;                   
            net.trainParam.showWindow = false; 
            net.trainParam.showCommandLine = false; 
            % network training
            net=train(net,inputn,outputn);
            an0=net(inputn);  %simulation results
            rmse0=sqrt(mse(outputn,an0));  %rmse
            disp(['when number of hidden layer nodes is: ',num2str(hiddennum),'£¬rmse on training set is£º',num2str(rmse0)])

            %update
            if rmse0<RMSE
                RMSE=rmse0;
                hiddennum_best=hiddennum;
            end
        end
        disp(['best number of hidden layer nodes is: ',num2str(hiddennum_best),'£¬corresponding rmse is: ',num2str(RMSE)])


end

