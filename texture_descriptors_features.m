function features = texture_descriptors_features(img, header)

addpath(genpath(strcat(pwd, '\TextureToolbox')));

[tumour_volume, levels] = prepareVolume(img, img, 'PETscan', ...
                              header.PixelDimensions(1), ...
                              header.PixelDimensions(3), 1, ...
                              header.PixelDimensions(3), ...
                              'Matrix', 'Uniform', 64);
                     
glcm = getGLCM(tumour_volume, levels);
glrlm = getGLRLM(tumour_volume, levels);
glszm = getGLSZM(tumour_volume, levels);
[ngtdm, countValid] = getNGTDM(tumour_volume, levels);

glcm = getGLCMtextures(glcm);
glrlm = getGLRLMtextures(glrlm);
glszm = getGLSZMtextures(glszm);
ngtdm = getNGTDMtextures(ngtdm, countValid);

glcm = struct2array(glcm);
glrlm = struct2array(glrlm);
glszm = struct2array(glszm);
ngtdm = struct2array(ngtdm);

features = [glcm, glrlm, glszm, ngtdm];

return
end