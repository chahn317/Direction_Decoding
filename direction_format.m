% User inputs
folder = pwd; % Current directory
data_file = "DirectionTimes.mat";
results_dir = "Directions_Formatted";

% Load all data
direction_times = load(strcat(folder, "/", data_file));
datasets = fieldnames(direction_times);

% Create directory to save results
mkdir(results_dir);

for i = 1:length(datasets)

    % Get data and name of dataset
    dataset = datasets{i};
    data = direction_times.(dataset);
    fprintf("%s\n", strcat("Processing ", dataset, "..."))

    % Process direction data
    outputs = data.Direction;
    output_start = data.StartTime(1);
    if contains(dataset, "Fd") % 100 ms for feeding experiments
        output_times = transpose(output_start:0.1:output_start+0.1*(length(data.StartTime) - 1));
    else % 500 ms for drinking experiments
        output_times = transpose(output_start:0.5:output_start+0.5*(length(data.StartTime) - 1));
    end
    
    % Process neural data
    valid_m1 = data.M1(~cellfun('isempty',data.M1)); % Remove empty neurons
    m1s = cell(length(valid_m1), 1);

    valid_s1 = data.S1(~cellfun('isempty',data.S1));
    s1s = cell(length(valid_s1), 1);

    time_diff = data.StartTime - output_times;

    for j = 1:length(data.StartTime)
        start_time = data.StartTime(j);
        end_time = data.EndTime(j);

        % Process M1 data
        for k = 1:length(valid_m1)

            % Extract spikes between start and end
            tf = valid_m1{1, k} > start_time & valid_m1{1, k} < end_time;
            extract = valid_m1{1, k}(tf);

            % Modify valid spike times to match interval
            m1s{k, 1} = cat(1, m1s{k, 1}, extract - time_diff(j));
        end

        % Process S1 data
        for k = 1:length(valid_s1)

            % Extract spikes between start and end
            tf = valid_s1{1, k} > start_time & valid_s1{1, k} < end_time;
            extract = valid_s1{1, k}(tf);

            % Modify valid spike times to match interval
            s1s{k, 1} = cat(1, s1s{k, 1}, extract - time_diff(j));
        end

    end

    m1s = m1s(~cellfun('isempty', m1s)); % Remove empty neurons
    s1s = s1s(~cellfun('isempty', s1s));

    % Save results
    parent = cd(results_dir);
    save(strcat(dataset, "_M1.mat"), 'm1s', 'output_times', 'outputs');
    save(strcat(dataset, "_S1.mat"), 's1s', 'output_times', 'outputs');
    cd(parent);
end

