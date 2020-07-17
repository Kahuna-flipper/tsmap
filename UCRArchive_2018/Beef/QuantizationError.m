function error = QuantizationError(input, weights)

[m,~] = size(input);
[p,~] = size(weights);
distance_matrix = zeros(p,1);
sum=0;
for i=1:m
    for j=1:p
        distance_matrix(j)=dtw(input(i,:),weights(j,:));
    end
    sum=sum+min(distance_matrix);
end

error = sum/m;

end
    