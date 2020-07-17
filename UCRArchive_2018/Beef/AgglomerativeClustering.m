close all
clc

%% Hierarchical Clustering 
tic


directory = pwd;
searchcommand = strcat(pwd,'/*TRAIN.tsv');
name = dir(searchcommand).name;
TRAIN = load(name);



[m,n] = size(TRAIN);
norm_train = TRAIN(:,2:n);
distances = zeros(m,m);
numclusters=max(TRAIN(:,1));

%% z -normalization :

for i=1:m
    norm_train(i,:) = (norm_train(i,:)-mean(norm_train(i,:)))/std(norm_train(i,:));
end



for i=1:m-1
    for j=1:m
        distances(i,j)=dtw(norm_train(i,:),norm_train(j,:));
    end
end

dist = zeros(1,m*(m-1)/2);
k=1;

for i=1:m
    for j=i+1:m
        dist(1,k)=distances(i,j);
        k=k+1;
    end
end



Z = linkage(dist);
dendrogram(Z);
T = cluster(Z,'maxclust',numclusters);

toc 
