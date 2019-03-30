function features = morphological_features(img, header)

non_zero_voxel = (img ~= 0);

number_of_voxel = sum(non_zero_voxel(:));

% Dividiamo per 10 in modo tale da avere unità di misura cm^3
voxel_volume = prod(header.PixelDimensions / 10);

mtv = voxel_volume * number_of_voxel;

surface = compute_area(img, header.PixelDimensions);

% calcoliamo il raggio di una sfera che ha volume uguale a mtv
radius = ((3 / 4) * (mtv / pi)) ^ (1 / 3);

sphere_surface = 4 * pi * (radius ^ 2);

spherical_disproportion = surface / sphere_surface;

% Sphericity è l'inversa della disproportion
sphericity = 1 / spherical_disproportion;

stv_ratio = surface / mtv;

features = [mtv, surface, spherical_disproportion, sphericity, stv_ratio];

return;




