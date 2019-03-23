dataset = load('dataset.mat');

features = dataset.features;
labels = dataset.labels;

indices = crossvalind('Kfold', labels, 10);

accuracies = zeros(10, 1);

for i = 1:10
    test = (indices == i);
    train = ~test;
    
    svm =  fitcsvm(features(train), labels(train), 'Standardize', true);
    [label, score] = predict(svm, features(test));
    
    accuracies(i) = sum(strcmp(labels(test), label)) / length(labels(test));
end

accuracy = sum(accuracies) / 10;

