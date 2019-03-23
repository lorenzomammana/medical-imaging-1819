% Questo file costruisce il dataset
% Mette feature e label in una singola tabella
% Omogeneo meno aggressivo, eterogeneo più aggressivo.

heterogeneous_files = dir('dataset/heterogeneous/*.nii');
homogeneous_files = dir('dataset/homogeneous/*.nii');
addpath(strcat(pwd, '\Tools-for-NIfTI-and-ANALYZE-image'));

features_he = zeros(length(heterogeneous_files), 5);
labels_he = cell(length(heterogeneous_files), 1);

for i = 1:length(heterogeneous_files)
    file = heterogeneous_files(i);
    filepath = strcat(file.folder, '\', file.name);
    img = load_nii(filepath);
    header = niftiinfo(filepath);
    
    features_he(i, :) = morphological_features(img, header);
    labels_he(i) = {'heterogeneous'};
end

features_ho = zeros(length(homogeneous_files), 5);
labels_ho = cell(length(homogeneous_files), 1);

for i = 1:length(homogeneous_files)
    file = homogeneous_files(i);
    filepath = strcat(file.folder, '\', file.name);
    img = load_nii(filepath);
    header = niftiinfo(filepath);
    
    features_ho(i, :) = morphological_features(img, header);
    labels_ho(i, 1) = {'homogeneous'};
end

features = [features_he; features_ho];
labels = [labels_he; labels_ho];

save('dataset.mat', 'features', 'labels');
