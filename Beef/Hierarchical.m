close all
clc

%% Hierarchical Clustering 



directory = pwd;
searchcommand = strcat(pwd,'/*TRAIN.tsv');
name = dir(searchcommand).name;
TRAIN = load(name);



[m,n] = size(TRAIN);
distances = zeros(m,m);
numclusters=max(TRAIN(:,1));
%% Bringing to minimum commom elements
for i=1:m
    for j=1:n
        if(isnan(TRAIN(i,j)))
            TRAIN(i,j)=0;
        end
    end
end
norm_train = TRAIN(:,2:n);
%% z -normalization :
tic
for i=1:m
    norm_train(i,:) = (norm_train(i,:)-mean(norm_train(i,:)))/std(norm_train(i,:));
end



for i=1:m-1
    for j=1:m
        temp1= norm_train(i,:);
        temp2= norm_train(j,:);
        distances(i,j)=dtw(temp1,temp2);
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
T = cluster(Z,'maxclust',numclusters);

time = toc;
