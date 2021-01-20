function  model = team_training_code(input_directory,output_directory) % train_ECG_leads_classifier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: Train ECG leads and obtain classifier models
% for 12-lead, 6-leads and 2-leads ECG sets
% Inputs:
% 1. input_directory
% 2. output_directory
%
% Outputs:
% model: trained model
% 3 logistic regression models for 3 different sets of leads
%
% Author: Erick Andres Perez Alday, PhD, <perezald@ohsu.edu>
% Version 1.0 Aug-2020
% Edit History
% By: Nadi Sadr, PhD, <nadi.sadr@dbmi.emory.edu>
% Version 2.0  1-Dec-2020
% Version 2.1 23-Dec-2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Loading data...')

% Find files.
input_files = {};
features =[];
for f = dir(input_directory)'
    if exist(fullfile(input_directory, f.name), 'file') == 2 && f.name(1) ~= '.' && all(f.name(end - 2 : end) == 'mat')
        input_files{end + 1} = f.name;
    end
end

% Extract classes from dataset.
% read number of unique classes
classes = get_classes(input_directory,input_files);
num_classes = length(classes);     % number of classes
num_files   = length(input_files);
Total_data  = cell(1,num_files);
Total_header= cell(1,num_files);

%% Load data recordings and header files
% Iterate over files.
for i = 1:num_files
    disp(['    ', num2str(i), '/', num2str(num_files), '...'])
    % Load data.
    file_tmp = strsplit(input_files{i},'.');
    tmp_input_file = fullfile(input_directory, file_tmp{1});
    [data,hea_data] = load_challenge_data(tmp_input_file);
    Total_data{i}=data;
    Total_header{i}=hea_data;

end

disp('Training model..')

label=zeros(num_files,num_classes);

for i = 1:num_files

    disp(['    ', num2str(i), '/', num2str(num_files), '...']);

    data = Total_data{i};
    header_data = Total_header{i};
    %% Check the number of available ECG leads
    [Used_leads, Used_leads_idx] = get_leads(header_data);

    %% Extract features
    tmp_features = get_features(data,header_data,Used_leads);
    features(i,:) = tmp_features(:);
    %% Extract labels
    for j = 1 : length(header_data)
        if startsWith(header_data{j},'#Dx')
            tmp = strsplit(header_data{j},': ');
            % Take more than one label if avialable - Nadi Sadr 22-Dec-2020
            tmp_c = strsplit(tmp{2},',');
            for k=1:length(tmp_c)
                idx=find(strcmp(classes,tmp_c{k}));
                label(i,idx)=1;
            end
            break
        end
    end


end

%% train 3 logistic regression models for 3 different sets of leads
% Train 12-lead ECG model
disp('Training 12-lead ECG model...')
Features_leads = features(:,[Used_leads_idx(:)',1+Used_leads_idx(end),2+Used_leads_idx(end)]);
model = mnrfit(Features_leads,label,'model','hierarchical');
save_ECG12leads_model(model,output_directory,classes);

% Train 6-lead ECG model
disp('Training 6-lead ECG model...')
Features_leads = features(:,[Used_leads_idx(:)',1+Used_leads_idx(end),2+Used_leads_idx(end)]);
model = mnrfit(Features_leads,label,'model','hierarchical');
save_ECG6leads_model(model,output_directory,classes);

% Train 2-lead ECG model
disp('Training 2-lead ECG model...')
Features_leads = features(:,[Used_leads_idx(:)',1+Used_leads_idx(end),2+Used_leads_idx(end)]);
model = mnrfit(Features_leads,label,'model','hierarchical');
save_ECG2leads_model(model,output_directory,classes);

end

function save_ECG12leads_model(model,output_directory,classes) %save_ECG_model
% Save results.
tmp_file = 'twelve_lead_ecg_model.mat';
filename=fullfile(output_directory,tmp_file);
save(filename,'model','classes','-v7.3');

disp('Done.')
end

function save_ECG6leads_model(model,output_directory,classes) %save_ECG_model
% Save results.
tmp_file = 'six_lead_ecg_model.mat';
filename=fullfile(output_directory,tmp_file);
save(filename,'model','classes','-v7.3');

disp('Done.')
end

function save_ECG2leads_model(model,output_directory,classes) %save_ECG_model
% Save results.
tmp_file = 'two_lead_ecg_model.mat';
filename=fullfile(output_directory,tmp_file);
save(filename,'model','classes','-v7.3');

disp('Done.')
end


% find unique number of classes
function classes = get_classes(input_directory,files)

classes={};
num_files = length(files);
k=1;
for i = 1:num_files
    g = strrep(files{i},'.mat','.hea');
    input_file = fullfile(input_directory, g);
    fid=fopen(input_file);
    tline = fgetl(fid);
    tlines = cell(0,1);

    while ischar(tline)
        tlines{end+1,1} = tline;
        tline = fgetl(fid);
        if startsWith(tline,'#Dx')
            tmp = strsplit(tline,': ');
            tmp_c = strsplit(tmp{2},',');
            for j=1:length(tmp_c)
                idx2 = find(strcmp(classes,tmp_c{j}));
                if isempty(idx2)
                    classes{k}=tmp_c{j};
                    k=k+1;
                end
            end
            break
        end
    end

    fclose(fid);

end
classes=sort(classes);
end

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

% function save_ECGleads_features(features,output_directory) %save_ECG_model
% % Save results.
% tmp_file = 'features.mat';
% filename=fullfile(output_directory,tmp_file);
% save(filename,'features');
% end
