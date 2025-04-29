close all; clear all;

% Generate synthetic data
datasets = generateData(2,5,[100,1000]);

params = mgs(datasets{end});

% Plot results
plot_fn(params);

