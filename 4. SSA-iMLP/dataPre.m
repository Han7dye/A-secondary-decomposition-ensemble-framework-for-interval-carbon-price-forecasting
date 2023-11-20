% training-testing set splitting and normalization
function [output_train, inputn, outputn, inputn_test, outputps] = dataPre(imf, xl, xu, end_train, lag, horizon); 
        
        [xTrain1,yTrain1,xTest1,yTest1] = transfer(xl(:,imf),lag,horizon,1,1,end_train);
        [xTrain2,yTrain2,xTest2,yTest2] = transfer(xu(:,imf),lag,horizon,1,1,end_train);
        input_train = crossadd([xTrain2;xTrain1],lag); % 2*lag * n_tr
        output_train =[yTrain2;yTrain1];
        input_test = crossadd([xTest2;xTest1],lag);
        output_test=[yTest2;yTest1];

        %% normalization
        [inputn,inputps] = mapminmax(input_train);
        inputn_test = mapminmax('apply',input_test,inputps);
        [outputn,outputps] = mapminmax(output_train);

end

