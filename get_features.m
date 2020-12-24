function features = get_features(data, header_data,Used_leads) %get_ECGLeads_features

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: Extract features from ECG signals of every lead
% Inputs:
% 1. ECG data from available leads (data)
% 2. Header files including the number of leads (header_data)
% 3. Recording ID number (i)
%
% Outputs:
% features for every ECG lead:
% 1. Age 2. Sex 3. root square mean of the ECG leads
%
% Author: Nadi Sadr, PhD, <nadi.sadr@dbmi.emory.edu>
% Version 1.0
% Date 25-Nov-2020
% Version 2.0
% Date 15-Dec-2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% read number of leads, sample frequency and gain from the header.
[recording,Total_time,num_leads,Fs,gain,age,sex,Baseline] = extract_data_from_header(header_data);

try
    % ECG processing
    % Preprocessing: gain and repeat signal patterns
    for i =1:num_leads
        % Apply gain and remove baseline
        LeadswGain(i,:)   = (data(i,:)-Baseline(i))* gain(i);
       
    end
        
    % Edit by Nadi Sadr, 25-Nov-2020
    for i=1: length(Used_leads) %1:num_leads
        RMS(i) = sqrt(sum(LeadswGain(i,:)).^2)./length(LeadswGain(i,:));       
        %Include all features from available leads
        features(i) = RMS(i);
    end
    
catch
    features_length = num_leads;
    features = nan(1,features_length);
end

% The last two features are age and sex from header file
features(num_leads+1) = age;
features(num_leads+2) = sex;
end
