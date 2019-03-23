% Questo file costruisce il dataset
% Mette feature e label in una singola tabella
% Omogeneo meno aggressivo, eterogeneo più aggressivo.

heterogeneous_files = dir('dataset/heterogeneous/*.nii');
homogeneous_files = dir('dataset/homogeneous/*.nii');
addpath(strcat(pwd, '\Tools-for-NIfTI-and-ANALYZE-image'));

features_he = zeros(length(heterogeneous_files), 6);

for i = 1:length(heterogeneous_files)
    file = heterogeneous_files(i);
    filepath = strcat(file.folder, '\', file.name);
    img = load_nii(filepath);
    header = niftiinfo(filepath);
    
    features_he(i, 1:5) = morphological_features(img, header);
    
    % label 1 per eterogenei, 0 per omogenei
    features_he(i, 6) = 1;
end

features_ho = zeros(length(homogeneous_files), 6);
for i = 1:length(homogeneous_files)
    file = homogeneous_files(i);
    filepath = strcat(file.folder, '\', file.name);
    img = load_nii(filepath);
    header = niftiinfo(filepath);
    
    features_ho(i, 1:5) = morphological_features(img, header);
    
    % label 1 per eterogenei, 0 per omogenei
    features_ho(i, 6) = 0;
end

dataset = [features_he; features_ho];
