%% Creates a rectangular mesh and initialises weights

function map = CreateRandomRectangularSOM(input_samples,rows,columns)
elements = rows*columns;
[~,dimensions] = size(input_samples);
map = (normrnd(0,1,[elements,dimensions]));
end
