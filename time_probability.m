function proabilities = time_probability()
    easy_array = probability('all-easy.txt');
    hard_array = probability('all-hard.txt');
    proabilities = [easy_array, hard_array];
    %s = ns / 1000000000;
end

function easy_probs = probability(file_name)
    times_array_ns = time_array(file_name);
    times_array = times_array_ns / 1000000000;
    %catching divide by 0 error
    if isempty(times_array)
        Pr_slow = 0;
        Pr_fast = 0;
        return
    end
    %find range of average
    avg = mean(times_array);
    sd = std(times_array);
    low_range = avg - sd;
    high_range = avg + sd;
    %get all the values slower than average
    slow = times_array(1, times_array(1, :)>high_range);
    %get all the values faster than average
    fast = times_array(1, times_array(1, :)<low_range);
    
    Pr_slow = length(slow) / length(times_array);
    Pr_fast = length(fast) / length(times_array);
    Pr_avg = 1 - Pr_slow - Pr_fast; %allvalues should add up to 1
    easy_probs = [Pr_slow,Pr_fast,Pr_avg];
end

function times_array = time_array(file_name)
    data_from_file = readlines(file_name);
    by_student_matrix = [];
    data_split_by_student = string.empty;
    
    row = 1;
    for k = 1:length(data_from_file)
        if data_from_file(k) ~= ""
            data_split_by_student(end+1) = data_from_file(k);
        else
            by_student_matrix = [by_student_matrix, data_split_by_student.'];
            data_split_by_student = string.empty;
            row = row + 1;
        end
    end
    
    times_array = [];
    
    for k = 1:width(by_student_matrix)
        col = by_student_matrix(:, k);
        resonse_time = 0;
        for j = 1:length(col)
            row = col(j);
            if contains(row, "Estimated task time (ns): ")
                index = strfind(row, "Estimated task time (ns): ");
                i = strlength("Estimated task time (ns): ");
                resonse_time = str2double(extractBetween(row, index+i, strlength(row)));
                times_array = [times_array, resonse_time];
            end
        end
    end
end