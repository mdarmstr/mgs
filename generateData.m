function data = generateData(clusters, N, obsRange, dims)
%GENERATEDATA Generates N datasets with specified clusters and variable observations in arbitrary dimensions
%
% Usage:
%   data = generateData(clusters, N)
%   data = generateData(clusters, N, obsRange)
%   data = generateData(clusters, N, obsRange, dims)
%
% Inputs:
%   clusters  - Integer specifying the number of clusters per dataset
%   N         - Integer specifying the number of datasets to generate
%   obsRange  - (Optional) 2-element vector [minObs, maxObs] specifying the 
%               range of observations per cluster. Default is [100, 500].
%   dims      - (Optional) Integer specifying the number of dimensions. 
%               Default is 2.
%
% Outputs:
%   data      - 1xN cell array, each cell containing a Mx(dims+1) matrix where:
%               - Columns 1 to dims are the standardized and rotated coordinates
%               - Column dims+1 contains class labels (1 to clusters)
%
% Example:
%   datasets = generateData(3, 5, [150, 300], 4);

    % Check and set default obsRange if not provided
    if nargin < 3
        obsRange = [100, 500];  % Default range: 100 to 500 observations per cluster
    else
        % Validate obsRange
        if numel(obsRange) ~= 2 || obsRange(1) <= 0 || obsRange(2) < obsRange(1)
            error('obsRange must be a 2-element vector [minObs, maxObs] with minObs > 0 and maxObs >= minObs.');
        end
    end

    % Check and set default dims if not provided
    if nargin < 4
        dims = 2;  % Default number of dimensions
    else
        % Validate dims
        if ~isscalar(dims) || dims < 1 || dims ~= floor(dims)
            error('dims must be a positive integer scalar representing the number of dimensions.');
        end
    end

    % Preallocate cell array for N datasets
    data = cell(1, N);

    % Generate and store cluster parameters to maintain consistency across datasets
    clusterParams = struct('Pi', {}, 'X_0', {}, 'eig_vals', {}, 'rotationMatrix', {});
    for qq = 1:clusters
        % Random orientation: generate a random orthogonal rotation matrix
        rotationMatrix = orth(randn(dims));  % Random orthogonal matrix via QR decomposition
        clusterParams(qq).rotationMatrix = rotationMatrix;

        % Random cluster center within a specified range
        max_drift = 60;
        clusterParams(qq).X_0 = rand(1, dims) * max_drift;  % Random cluster center in 'dims' dimensions

        % Generate eigenvalues for the covariance matrix
        max_eig = 20;
        % Ensure eigenvalues are positive
        eig_vals = abs(normrnd(0.5, 0.1, [1, dims])) * max_eig;
        clusterParams(qq).eig_vals = eig_vals;
    end

    % Loop over each dataset to generate data
    for dd = 1:N
        dataset = [];  % Initialize empty matrix for the current dataset

        for qq = 1:clusters
            % Randomly determine the number of observations for this cluster
            num_obs = randi(obsRange);

            % Generate random points with specified eigenvalues (variance in each dimension)
            % Assuming independent features before rotation
            ranx = normrnd(0, 1, [dims, num_obs]) .* clusterParams(qq).eig_vals';

            % Rotate the data points using the precomputed rotation matrix
            rotated_ranx = (clusterParams(qq).rotationMatrix * ranx)';  % Resulting in num_obs x dims matrix

            % Translate the rotated points by cluster center X_0
            translated_data = rotated_ranx + clusterParams(qq).X_0;

            % Append class label as the last column
            class_labels = repmat(qq, num_obs, 1);
            cluster_data = [translated_data, class_labels];

            % Concatenate with the dataset
            dataset = [dataset; cluster_data];  %#ok<AGROW>
        end

        % Standardize the feature columns (1 to dims)
        dataset(:,1:dims) = (dataset(:,1:dims) - mean(dataset(:,1:dims), 1)) ./ std(dataset(:,1:dims), 0, 1);

        % Perform Singular Value Decomposition (SVD) for rotation in higher dimensions
        [U, S, ~] = svd(dataset(:,1:dims), 'econ');
        dataset(:,1:dims) = (U * S);

        % Store the processed dataset in the cell array
        data{dd} = dataset;
    end

end
