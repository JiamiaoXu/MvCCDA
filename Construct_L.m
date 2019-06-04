function L = Construct_L(labels)

nClass = length(unique(labels{1}));
sampleNum = length(labels{1});
L = zeros(sampleNum, nClass);

for i = 1 : sampleNum
    label = labels{1}(i);
    L(i, label) = 1;
end

L = L.';
end