function test_model(model_directory,input_directory, output_directory)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
% Test model and obtain test outputs
% *** Do not edit this script.
% Inputs:
% 1. Header files including the number of leads (header_data)
%
% Outputs:
% number of leads
% used lead names
% used leads index in header and data
% Unused leads names and index
%
% Author: Nadi Sadr, PhD, <nadi.sadr@dbmi.emory.edu>
% Version 1.0
% Date 9-Dec-2020
% Version 1.1, 23-Dec-2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find files.
input_files = {};
for f = dir(input_directory)'
    if exist(fullfile(input_directory, f.name), 'file') == 2 && f.name(1) ~= '.' && all(f.name(end - 2 : end) == 'mat')
        input_files{end + 1} = f.name;
    end
end

if ~exist(output_directory, 'dir')
    mkdir(output_directory)
end



%% Load model.
% Load your trained 12-lead ECG model.
% These functions are **required**.
% Do **not** change the arguments of this function.
disp('Loading 12 leads ECG model...')
model12 = load_ECG_12leads_model(model_directory);
%     model = load_ECG_12leads_model(model_directory);

% Load your trained 6-lead ECG model.
% These functions are **required**.
% Do **not** change the arguments of this function.
disp('Loading 6 leads ECG model...')
model6 = load_ECG_6leads_model(model_directory);
%     model = load_ECG_6leads_model(model_directory);

% Load your trained 2-lead ECG model.
% These functions are **required**.
% Do **not** change the arguments of this function.
disp('Loading 2 leads ECG model...')
model2 = load_ECG_2leads_model(model_directory);
%         model = load_ECG_2leads_model(model_directory);

%% Predicting the outputs
% Iterate over files.
disp('Predicting ECG leads labels...')
num_files = length(input_files);
for i = 1:num_files
    disp(['    ', num2str(i), '/', num2str(num_files), '...'])

    % Load test data.
    file_tmp=strsplit(input_files{i},'.');
    tmp_input_file = fullfile(input_directory, file_tmp{1});
    [data,header_data] = load_challenge_data(tmp_input_file);

    %% Check the number of available ECG leads
    [Used_leads, Used_leads_idx] = get_leads(header_data);

    %% Extract features
    tmp_features = get_features(data,header_data);

    %% Apply model to recording.
    if length(Used_leads)==12
    % 12 Leads model
    [current_score,current_label,classes] = team_testing_code(data,header_data,model12);
    elseif length(Used_leads)==6
    % 6 Leads model
    [current_score,current_label,classes] = team_testing_code(data,header_data,model6);
    elseif length(Used_leads)==2
    % 2 Leads model
    [current_score,current_label,classes] = team_testing_code(data,header_data,model2);
    end

    %% Save model outputs.
    save_challenge_predictions(output_directory,file_tmp{1}, current_score, current_label,classes);

end

disp('Done.')
end


%% Load test data
function [data,tlines] = load_challenge_data(filename)

% Opening header file
fid=fopen([filename '.hea']);
if (fid<=0)
    disp(['error in opening file ' filename]);
end

tline = fgetl(fid);
tlines = cell(0,1);
while ischar(tline)
    tlines{end+1,1} = tline;
    tline = fgetl(fid);
end
fclose(fid);

f=load([filename '.mat']);
try
    data = f.val;
catch ex
    rethrow(ex);
end

end

%% save predictions
function save_challenge_predictions(output_directory,recording, scores, labels,classes)

output_file = ([output_directory filesep recording '.csv']);

Total_classes = strjoin(classes,','); %insert commaas
%write header to file
fid = fopen(output_file,'w');
fprintf(fid,'#%s\n',recording);
fprintf(fid,'%s\n',Total_classes);
fclose(fid);

%write data to end of file
dlmwrite(output_file,labels,'delimiter',',','-append','precision',4);
dlmwrite(output_file,scores,'delimiter',',','-append','precision',4);

end

%% Load your trained 12-lead ECG model.
% This function is **required**.
% Do **not** change the arguments of this function.
function model = load_ECG_12leads_model(model_directory)

out_file='twelve_lead_ecg_model.mat';
filename=fullfile(model_directory,out_file);
A=load(filename);
model=A;

end


%% Load your trained 6-lead ECG model.
% This function is **required**.
% Do **not** change the arguments of this function.function model = load_ECG_6leads_model(model_directory)
function model = load_ECG_6leads_model(model_directory)
out_file='six_lead_ecg_model.mat';
filename=fullfile(model_directory,out_file);
A=load(filename);
model=A;

end

%% Load your trained 2-lead ECG model.
% This function is **required**.
% Do **not** change the arguments of this function.
function model = load_ECG_2leads_model(model_directory)

out_file='two_lead_ecg_model.mat';
filename=fullfile(model_directory,out_file);
A=load(filename);
model=A;

end

