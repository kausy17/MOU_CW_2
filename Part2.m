% Load shift vectors and bias values
load('sphere_func_data.mat');       % Loads variable `o` for F1
load('rosenbrock_func_data.mat');   % Loads variable `o` for F6
load('EF8F2_func_data.mat');        % Loads variable `o` for F13
load('fbias_data.mat');             % Loads variable `f_bias`, a 1x25 vector

%% DEFINING FUNCTIONS
function f = F1_Sphere(x)
    % F1: Shifted Sphere Function from CEC 2005
    persistent o f_bias
    if isempty(o)
        load('sphere_func_data.mat', 'o');  % 1x100 shift vector
        load('fbias_data.mat', 'f_bias');   % 1x25 bias vector
    end
    D = length(x);
    z = x - o(1:D);
    f = sum(z.^2) + f_bias(1);  % F1 is at index 1
end

function f = F6_Rosenbrock(x)
    % F6: Shifted Rosenbrock Function from CEC 2005
    persistent o f_bias
    if isempty(o)
        load('rosenbrock_func_data.mat', 'o');
        load('fbias_data.mat', 'f_bias');
    end
    D = length(x);
    z = x - o(1:D) + 1;  % Shifted input
    f = sum(100*(z(2:D) - z(1:D-1).^2).^2 + (z(1:D-1) - 1).^2) + f_bias(6);
end

function f = F13_ExpExpGR(x)
    % F13: Expanded Expanded Griewank + Rosenbrock Function from CEC 2005
    persistent o f_bias
    if isempty(o)
        load('EF8F2_func_data.mat', 'o');
        load('fbias_data.mat', 'f_bias');
    end
    D = length(x);
    z = x - o(1:D) + 1;
    
    f = 0;
    for i = 1:D-1
        f = f + griewank_rosenbrock(z(i), z(i+1));
    end
    f = f + griewank_rosenbrock(z(D), z(1));  % Wrap-around
    f = f + f_bias(13);
end

function val = griewank_rosenbrock(x1, x2)
    temp = 100*(x1^2 - x2)^2 + (x1 - 1)^2;
    val = temp^2 / 4000 - cos(temp) + 1;
end

%%
function run_cec_experiments()
    funcs = {@F1_Sphere, @F6_Rosenbrock, @F13_ExpExpGR};
    func_names = {'F1_Sphere', 'F6_Rosenbrock', 'F13_ExpExpGR'};
    bounds = {[-100, 100], [-100, 100], [-5, 5]};  % Based on CEC definitions
    dimensions = [2, 10];
    nRuns = 15;
    
    algorithms = {@run_ga, @run_pso, @run_sa};
    algo_names = {'GA', 'PSO', 'SA'};
    
    results = struct();

    for d = dimensions
        for i = 1:length(funcs)
            fprintf('\n========== Function: %s | D = %d ==========\n', func_names{i}, d);
            lb = bounds{i}(1) * ones(1, d);
            ub = bounds{i}(2) * ones(1, d);
            for a = 1:length(algorithms)
                [best, worst, avg, stdev, all_runs] = algorithms{a}(funcs{i}, d, lb, ub, nRuns);
                fprintf('%s => Best: %.4f | Worst: %.4f | Mean: %.4f | Std: %.4f\n', ...
                    algo_names{a}, best, worst, avg, stdev);
                % Save results to struct
                results.(func_names{i}).(['D' num2str(d)]).(algo_names{a}) = struct( ...
                    'Best', best, 'Worst', worst, 'Mean', avg, 'Std', stdev, 'Runs', all_runs);
            end
        end
    end

    % Save results to file
    save('cec_results.mat', 'results');
end

%%
function [best, worst, avg, stdev, all_runs] = run_ga(fun, D, lb, ub, nRuns)
    all_runs = zeros(nRuns, 1);
    options = optimoptions('ga', ...
        'MaxGenerations', 100, ...
        'PopulationSize', 50, ...
        'Display', 'off');
    for i = 1:nRuns
        [~, fval] = ga(fun, D, [], [], [], [], lb, ub, [], options);
        all_runs(i) = fval;
    end
    best = min(all_runs);
    worst = max(all_runs);
    avg = mean(all_runs);
    stdev = std(all_runs);
end

%%
function [best, worst, avg, stdev, all_runs] = run_pso(fun, D, lb, ub, nRuns)
    all_runs = zeros(nRuns, 1);
    options = optimoptions('particleswarm', ...
        'SwarmSize', 30, ...
        'MaxIterations', 100, ...
        'Display', 'off');
    for i = 1:nRuns
        [~, fval] = particleswarm(fun, D, lb, ub, options);
        all_runs(i) = fval;
    end
    best = min(all_runs);
    worst = max(all_runs);
    avg = mean(all_runs);
    stdev = std(all_runs);
end

%%
function [best, worst, avg, stdev, all_runs] = run_sa(fun, D, lb, ub, nRuns)
    all_runs = zeros(nRuns, 1);
    options = optimoptions('simulannealbnd', ...
        'MaxIterations', 200, ...
        'Display', 'off');
    for i = 1:nRuns
        x0 = lb + rand(1, D) .* (ub - lb);  % Random starting point
        [~, fval] = simulannealbnd(fun, x0, lb, ub, options);
        all_runs(i) = fval;
    end
    best = min(all_runs);
    worst = max(all_runs);
    avg = mean(all_runs);
    stdev = std(all_runs);
end

%%
run_cec_experiments

%%
function plot_performance_comparison()
    load('cec_results.mat');  % loads the 'results' struct
    
    func_names = {'F1_Sphere', 'F6_Rosenbrock', 'F13_ExpExpGR'};
    dims = [2, 10];
    algos = {'GA', 'PSO', 'SA'};
    n_funcs = length(func_names);
    n_dims = length(dims);
    n_algos = length(algos);
    
    % Preallocate matrices
    mean_vals = zeros(n_funcs * n_dims, n_algos);
    std_vals = zeros(n_funcs * n_dims, n_algos);
    labels = strings(n_funcs * n_dims, 1);
    
    % Fill matrices
    row = 1;
    for f = 1:n_funcs
        for d = 1:n_dims
            fname = func_names{f};
            dim = dims(d);
            labels(row) = sprintf('%s D=%d', strrep(fname, '_', '\_'), dim);
            for a = 1:n_algos
                algo = algos{a};
                stats = results.(fname).(['D' num2str(dim)]).(algo);
                mean_vals(row, a) = stats.Mean;
                std_vals(row, a) = stats.Std;
            end
            row = row + 1;
        end
    end

    % Plot
    figure;
    bar_handle = bar(mean_vals);
    hold on;

    % Add error bars
    [num_groups, num_bars] = size(mean_vals);
    group_width = min(0.8, num_bars/(num_bars + 1.5));
    for i = 1:num_bars
        x = (1:num_groups) - group_width/2 + (2*i-1) * group_width / (2*num_bars);
        errorbar(x, mean_vals(:, i), std_vals(:, i), 'k', 'linestyle', 'none', 'LineWidth', 1);
    end

    hold off;
    legend(algos, 'Location', 'northeast');
    xticks(1:num_groups);
    xticklabels(labels);
    xtickangle(45);
    ylabel('Mean Fitness');
    title('Performance Comparison of Optimization Techniques');
    grid on;
end

%%
plot_performance_comparison

%%
function plot_per_function_performance()
    load('cec_results.mat');  % load 'results' struct

    func_names = {'F1_Sphere', 'F6_Rosenbrock', 'F13_ExpExpGR'};
    dims = [2, 10];
    algos = {'GA', 'PSO', 'SA'};
    colors = [0.85 0.33 0.1; 0.1 0.45 0.8; 0.47 0.67 0.19];  % Distinct colors

    for f = 1:length(func_names)
        fname = func_names{f};
        for d = 1:length(dims)
            dim = dims(d);
            means = zeros(1, length(algos));
            stds = zeros(1, length(algos));
            
            for a = 1:length(algos)
                stats = results.(fname).(['D' num2str(dim)]).(algos{a});
                means(a) = stats.Mean;
                stds(a) = stats.Std;
            end
            
            % Plotting
            figure;
            b = bar(means, 'FaceColor', 'flat');
            for k = 1:length(algos)
                b.CData(k, :) = colors(k, :);
            end
            hold on;
            errorbar(1:length(algos), means, stds, 'k', 'linestyle', 'none', 'LineWidth', 1.5);
            hold off;

            xticks(1:length(algos));
            xticklabels(algos);
            ylabel('Mean Fitness');
            title(sprintf('Performance Comparison – %s (D=%d)', strrep(fname, '_', '\_'), dim));
            grid on;
            saveas(gcf, sprintf('Performance_%s_D%d.png', fname, dim));
        end
    end
end

%%
plot_per_function_performance

