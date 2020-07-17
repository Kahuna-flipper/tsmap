close all


%% Load train.tsv file from directory


directory = pwd;
searchcommand = strcat(pwd,'/*TRAIN.tsv');
name = dir(searchcommand).name;
TRAIN = load(name);


[m,n] = size(TRAIN);
shuffle = randperm(m,m);

tic
for i=1:m
    TRAIN(i,:)=TRAIN(shuffle(i),:);
end
norm_train = TRAIN(:,2:n);


%% Z Normalization
for i=1:m
    norm_train(i,:) = (norm_train(i,:)-mean(norm_train(i,:)))/std(norm_train(i,:));
end

errors = zeros(20,1);
diff_errors = zeros(19,1);
diff_errors2 = zeros(20,1);
labels = zeros(m,1);
alpha = 0.8;
num_centroids = max(TRAIN(:,1));

%% Quantization error vs clusters
% for c=2:20
%     [~,weights] = FNInitialization(norm_train,c);
%     for epochs = 1:10
%         net = OneDTrain(norm_train,weights,alpha,m,0,c);
%         weights = net;
%         alpha=alpha/epochs;
%     end
%     errors(c)=QuantizationError(norm_train,net);
% end
% 
% 
% for i=1:19
% diff_errors(i) = abs(errors(i)-errors(i+1));
% end
% 
% for i=2:19
% diff_errors2(i) = abs(errors(i)-errors(i+1))+abs(errors(i)-errors(i-1));
% end


%% Calculating for minimum QE for each alpha
% 
% errors2 = zeros(9,1);
% alpha = [0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1];
% 
% for iter=1:9
%     [~,final_weights] = FNInitialization(norm_train,num_centroids);
%     for epochs= 1:10
%         final_net = OneDTrain(norm_train,final_weights,alpha(iter),m,0,num_centroids);
%         final_weights = final_net;
%         alpha(iter) = alpha(iter)/epochs;
%     end
% 
%     for i= 1:m
%         dist = zeros(num_centroids,1);
%         for j= 1:num_centroids
%             dist(j) = dtw(norm_train(i,:),final_net(j,:));
%         end
%         [~,labels(i)] = min(dist);
%     end
%     errors2(iter)=QuantizationError(norm_train,final_weights);
% end


%% Calculating results with minimum alpha 
alpha = 0.8;
[~,final_weights] = FNInitialization(norm_train,num_centroids);
    for epochs= 1:10
        final_net = OneDTrain(norm_train,final_weights,alpha,m,0,num_centroids);
        final_weights = final_net;
        alpha = alpha/epochs;
    end

    for i= 1:m
        dist = zeros(num_centroids,1);
        for j= 1:num_centroids
            dist(j) = dtw(norm_train(i,:),final_net(j,:));
        end
        [~,labels(i)] = min(dist);
    end
toc