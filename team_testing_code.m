%% Apply classifier model to test set

function [score, label,classes,num_leads,Used_leads] = team_testing_code(data,header_data, loaded_model)

model   = loaded_model.model;
classes = loaded_model.classes;

num_classes = length(classes);

label = zeros([1,num_classes]);

score = ones([1,num_classes]);

% Extract features from test data
features = get_features(data,header_data);

% Use your classifier here to obtain a label and score for each class.
score = mnrval(model,features);
[~,idx] = max (score);

label(idx)=1;
end
