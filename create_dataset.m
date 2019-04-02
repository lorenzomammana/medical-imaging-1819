% Questo file costruisce il dataset
% Mette feature e label in una singola tabella
% Omogeneo meno aggressivo, eterogeneo più aggressivo.

heterogeneous_files = dir('dataset/heterogeneous/*.nii');
homogeneous_files = dir('dataset/homogeneous/*.nii');
addpath(strcat(pwd, '\Tools-for-NIfTI-and-ANALYZE-image'));

features_he = zeros(length(heterogeneous_files), ...
    5 + 13 + 9 + 13 + 13 + 5 + 1);

labels_he = cell(length(heterogeneous_files), 1);

for i = 1:length(heterogeneous_files)
    file = heterogeneous_files(i);
    filepath = strcat(file.folder, '\', file.name);
    img = load_nii(filepath);
    header = niftiinfo(filepath);
    
    morphological_f = morphological_features(img.img, header);
    firstorder_f = firstorder_features(img.img);
    texture_f = texture_descriptors_features(img.img, header);
    features_he(i, :) = [morphological_f, firstorder_f, texture_f, 1];
    labels_he(i) = {'heterogeneous'};
end

features_ho = zeros(length(homogeneous_files), ...
    5 + 13 + 9 + 13 + 13 + 5 + 1);

labels_ho = cell(length(homogeneous_files), 1);

for i = 1:length(homogeneous_files)
    file = homogeneous_files(i);
    filepath = strcat(file.folder, '\', file.name);
    img = load_nii(filepath);
    header = niftiinfo(filepath);
    
    morphological_f = morphological_features(img.img, header);
    firstorder_f = firstorder_features(img.img);
    texture_f = texture_descriptors_features(img.img, header);
    features_ho(i, :) = [morphological_f, firstorder_f, texture_f, 0];
    labels_ho(i, 1) = {'homogeneous'};
    break
end

return
features = [features_he; features_ho];

% Riscalo le features nel range [0, 1]
colmin = min(features);
colmax = max(features);

features = rescale(features, 'InputMin', colmin, 'InputMax', colmax);
labels = [labels_he; labels_ho];

save('dataset.mat', 'features', 'labels');
