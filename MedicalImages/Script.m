close all
TRAIN = load('MedicalImages_TRAIN');% Only this line needs to be changed to test a different dataset. 
[m,n] = size(TRAIN);
norm_train = TRAIN(:,2:n);


%% Z Normalization
for i=1:m
    norm_train(i,:) = (norm_train(i,:)-mean(norm_train(i,:)))/std(norm_train(i,:));
end

errors = zeros(20,1);
diff_errors = zeros(19,1);
labels = zeros(m,1);
num_centroids = 10;

%% Quantization error vs clusters
for c=1:20
    [~,weights] = FNInitialization(norm_train,c);
    for epochs = 1:100
        net = OneDTrain(norm_train,weights,0.9,381,0,c);
        weights = net;
    end
    errors(c)=QuantizationError(norm_train,net);
end


for i=1:19
diff_errors(i) = errors(i)-errors(i+1);
end


final_weights = FNInitialization(norm_train,num_centroids);

for epochs= 1:100
    final_net = OneDTrain(norm_train,final_weights,0.9,381,0,c);
    final_weights = final_net;
end
    
for i= 1:m
    dist = zeros(num_centroids,1);
    for j= 1:num_centroids
        dist(j) = dtw(norm_train(i,:),final_net(j,:));
    end
    [~,labels(i)] = min(dist);
end