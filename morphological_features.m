cd 'C:\Users\loren\Documents\MATLAB\thirdparty-libraries\Tools-for-NIfTI-and-ANALYZE-image\Tools-for-NIfTI-and-ANALYZE-image';

[file, path] = uigetfile;

img = load_nii(strcat(path, file));

header = niftiinfo(strcat(path, file));

non_zero_voxel = (img.img ~= 0);

number_of_voxel = sum(non_zero_voxel(:));

% Dividiamo per 10 in modo tale da avere unità di misura cm^3

voxel_volume = prod(header.PixelDimensions / 10);

mtv = voxel_volume * number_of_voxel;

surface = compute__area(img.img, header.PixelDimensions);
% calcoliamo il raggio di una sfera che hai il volume di 1)

radius = ((3 / 4) * (mtv / pi)) ^ (1 / 3);

sphere_surface = 4 * pi * (radius ^ 2);

spherical_disproportion = surface / sphere_surface;

sphericity = 1 / spherical_disproportion;

stv_ratio = surface / mtv;

view_nii(img);

% Omogeneo meno aggressivo, eterogeneo più aggressivo.

% Sphericity è l'inversa della 3



