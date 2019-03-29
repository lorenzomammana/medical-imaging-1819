function features = firstorder_features(tumour_volume)
    
    % THIS FUNCTION IS INCOMPLETE (see the code below)
    
    %
    % INPUT
    % tumour_volume is the segmented 3D volume of the lesion (x-by-y-by-z
    % matrix)
    %
    % OUTPUT
    % features is a matlab structure containing all the histogram-based
    % features extracted in the code
    %
    
    features = [];
    
    % Tip: some preprocessing needed here
    % >>>
    
    [count, ~] = hist(tumour_volume, 256); % The second argument represent the number of bins
    tot = sum(count);
    frequency = count/tot;

    tumour_dimension = size(tumour_volume);
    squared_matrix = tumour_volume.^2;
    
    % Maximum
    tumour_max = max(tumour_volume);
    features.max = tumour_max;
    
    % Minimum
    % >> INSERT CODE HERE
    
    % Mean
    % >> INSERT CODE HERE
    
    % Median
    % >> INSERT CODE HERE

    % Mean Absolute Deviation (MAD)
    m_dev = abs(tumour_volume - tumour_mean);
    MAD = mean(m_dev);
    features.mad = MAD;
    
    % Root Mean Square (RMS)
    % >> INSERT CODE HERE

    % Energy
    % >> INSERT CODE HERE
    
    % Entropy
    entropy_vector = frequency.*log2(frequency);
    for i=1:256
        if isnan(entropy_vector(1, i))
            entropy_vector(1, i) = 0;
        end
    end
    entropy = (-1) * sum(entropy_vector);
    features.entropy = entropy;

    % Kurtosis
    num_vector = (tumour_volume - tumour_mean).^4;
    den_vector = (tumour_volume - tumour_mean).^2;
    num = sum(num_vector)/tumour_dimension(1,1);
    den = ((sum(den_vector) / tumour_dimension(1,1)))^2;
    kurtosis = num / den;
    features.kurtosis = kurtosis;

    % Skewness
    temp_vector = (tumour_volume - tumour_mean).^3;
    num1 = sum(temp_vector)/tumour_dimension(1,1);
    den1 = (sqrt(sum(den_vector)/tumour_dimension(1,1)))^3;
    skewness = num1/den1;
    features.skewness = skewness;
    clear temp_vector
    
    % Standard Deviation 
    % >> INSERT CODE HERE

    % Uniformity
    uniformity_vector = frequency.*frequency;
    uniformity = sum(sum(uniformity_vector));
    features.uniformity = uniformity;

    % Variance
    temp_vector = (tumour_volume - tumour_mean).^2;
    variance = (1/(tumour_dimension(1,1)-1)) * sum(sum(temp_vector));
    features.variance = variance;
    clear temp_vector

end