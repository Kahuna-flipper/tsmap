close all


%% Load train.tsv file from directory


directory = pwd;
searchcommand = strcat(pwd,'/*TRAIN.tsv');
name = dir(searchcommand).name;
TRAIN = load(name);


[m,n] = size(TRAIN);
shuffle = randperm(m,m);

norm_train = TRAIN(:,2:n);



%% Z Normalization
for i=1:m
    norm_train(i,:) = (norm_train(i,:)-mean(norm_train(i,:)))/std(norm_train(i,:));
end

errors = zeros(10,1);
diff_errors = zeros(19,1);
diff_errors2 = zeros(20,1);
labels = zeros(m,1);

num_centroids = max(TRAIN(:,1));

final_labels=zeros(m,10);

%% Calculating results with minimum alpha 
alpha = 0.9;
[~,final_weights] = FNInitialization(norm_train,num_centroids);
    for epochs= 1:10
        final_net = OneDTrain(norm_train,final_weights,alpha,m,0,num_centroids);
        final_weights = final_net;
        alpha = alpha/epochs;
        for i= 1:m
            dist = zeros(num_centroids,1);
            for j= 1:num_centroids
                dist(j) = dtw(norm_train(i,:),final_net(j,:));
            end
            [~,labels(i)] = min(dist);
        end
        final_labels(:,epochs)=labels;
        if(epochs>3)
            temp_sum=sum(final_labels(:,epochs)-final_labels(:,epochs-1));
            if(temp_sum==0)
                break
            end
        end
    end
