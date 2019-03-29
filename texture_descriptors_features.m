function features = texture_descriptors_features(img, header)

addpath(genpath(strcat(pwd, '\TextureToolbox')));

[tumour_volume, levels] = prepareVolume(img, img, 'PETscan', ...
                              header.PixelDimensions(1), ...
                              header.PixelDimensions(3), 1, ...
                              header.PixelDimensions(3), ...
                              'Matrix', 'Uniform', 64);
                     
glcm = getGLCM(tumour_volume, levels);

features = getGLCMtextures(glcm);

return
end