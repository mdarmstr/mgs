function data = generateData(clusters, N, obsRange)
%GENERATEDATA Generates N datasets with specified clusters and fixed total observations per cluster
%
% Description:
%   This function generates multiple datasets, each containing a specified number of 
%   clusters in a 2D space. The number of observations in each cluster is equal 
%   within a dataset and increases linearly across datasets based on the obsRange.
%
% Inputs:
%   clusters  - (Integer) Number of clusters per dataset
%   N         - (Integer) Number of datasets to generate
%   obsRange  - (Optional) 2-element vector [minObs, maxObs] specifying the 
%               range of total observations per cluster. Default is [100, 500].
%
% Outputs:
%   data      - 1xN cell array, each cell containing a Mx3 matrix where:
%               - Columns 1 & 2 are the standardized and rotated coordinates
%               - Column 3 contains class labels (1 to clusters)
%

    %% Input Validation and Default Settings
    if nargin < 3
        obsRange = [150, 300];  % Default observations range per cluster
    else
        % Validate obsRange
        if numel(obsRange) ~= 2 || obsRange(1) <= 0 || obsRange(2) < obsRange(1)
            error('obsRange must be a 2-element vector [minObs, maxObs] with minObs > 0 and maxObs >= minObs.');
        end
    end

    % Validate clusters
    if ~isscalar(clusters) || clusters < 1 || clusters ~= floor(clusters)
        error('clusters must be a positive integer.');
    end

    % Validate N
    if ~isscalar(N) || N < 1 || N ~= floor(N)
        error('N must be a positive integer.');
    end

    %% Preallocate Cell Array for Datasets
    data = cell(1, N);  % 1xN cell array

    %% Generate Cluster Parameters Once to Maintain Consistency
    clusterParams = struct('Pi', {}, 'X_0', {}, 'eig_maj', {}, 'eig_min', {});
    for qq = 1:clusters
        clusterParams(qq).Pi = rand(1) * 2 * pi;  % Random orientation angle [0, 2π]
        max_drift = 60;  % Maximum drift from origin
        clusterParams(qq).X_0 = [rand(1) * max_drift, rand(1) * max_drift];  % Cluster center

        max_eig = 20;  % Scaling factor for eigenvalues
        clusterParams(qq).eig_maj = normrnd(0.5, 0.1) * max_eig;  % Major axis length
        clusterParams(qq).eig_min = abs(normrnd(0.5, 0.1) * clusterParams(qq).eig_maj);  % Minor axis length
    end

    %% Linearly Space Total Observations for Datasets
    obsCounts = round(linspace(obsRange(1), obsRange(2), N));  % Increasing obs per cluster

    %% Generate Each Dataset
    for dd = 1:N
        dataset = [];  % Initialize empty matrix for current dataset
        num_obs = obsCounts(dd);  % Fixed number of observations per cluster for this dataset

        for qq = 1:clusters
            % Generate random points with specified eigenvalues
            ranx = normrnd(0, 1, [2, num_obs]) .* [clusterParams(qq).eig_maj; clusterParams(qq).eig_min];

            % Rotate the data points by Pi
            rotationMatrix = [cos(clusterParams(qq).Pi), -sin(clusterParams(qq).Pi);
                              sin(clusterParams(qq).Pi),  cos(clusterParams(qq).Pi)];
            rotated_ranx = ranx' * rotationMatrix;  % Resulting in num_obs x 2 matrix

            % Translate the rotated points by cluster center X_0
            translated_data = rotated_ranx + clusterParams(qq).X_0;

            % Append class label as the third column
            class_labels = repmat(qq, num_obs, 1);
            cluster_data = [translated_data, class_labels];

            % Concatenate with the dataset
            dataset = [dataset; cluster_data];  %#ok<AGROW>
        end

        %% Standardize Features
        % Subtract mean and divide by standard deviation for each feature
        dataset(:,1:2) = (dataset(:,1:2) - mean(dataset(:,1:2), 1)) ./ std(dataset(:,1:2), 0, 1);

        %% Apply Singular Value Decomposition (SVD) for Rotation
        [u, s, ~] = svd(dataset(:,1:2), 'econ');
        dataset(:,1:2) = (u * s);

        %% Store the Processed Dataset
        data{dd} = dataset;
    end

end
