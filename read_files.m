function avgs = read_files()
    avg_given_hard = get_probability('all-hard.txt');
    avg_given_easy = get_probability('all-easy.txt');
    avgs = [avg_given_easy, avg_given_hard];
end

function avg_given = get_probability(file_name)
    data_from_files_array = readlines(file_name);
    student_matrix = [];
    data_split_by_student = string.empty;
    
    row = 1;
    for k = 1:length(data_from_files_array)
        if data_from_files_array(k) ~= ""
            data_split_by_student(end+1) = data_from_files_array(k);
        else
            student_matrix = [student_matrix, data_split_by_student.'];
            data_split_by_student = string.empty;
            row = row + 1;
        end
    end
    
    data_summary_values = [];
    
    for k = 1:width(student_matrix)
        col = student_matrix(:, k);
        num_questions = 0;
        num_correct = 0;
        for j = 1:length(col)
            row = col(j);
            if contains(row, "Number Questions Asked: ")
                i = strlength("Number Questions Asked: ");
                num_questions = str2double(extractBetween(row, i+1, strlength(row)));
            end
            if contains(row, "Number Questions Correctly Answered: ")
                i = strlength("Number Questions Correctly Answered: ");
                num_correct = str2double(extractBetween(row, i+1, strlength(row)));
            end
        end
        array = [num_questions, num_correct];
        data_summary_values = [data_summary_values, array.'];
    end
    
    total_correct = 0;
    count = 0;
    for k = 1:length(data_summary_values)
        row = data_summary_values(:, k);
        count = count + 1;
        total_correct = total_correct + (row(2) / row(1));
    end
    
    if count ~= 0
        avg_correct = total_correct / count;
    end
    avg_given = avg_correct;
end