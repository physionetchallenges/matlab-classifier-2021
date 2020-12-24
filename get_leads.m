function [Used_leads, leads_idx, Unused_leads, UnusedLeads_idx]= get_leads(header_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
% Check the number of available ECG leads
% Extract features, if:
% 1. 2 leads are avialable: I & V5 or
% 2. 6 leads are available: I, II, III, aVR, aVL & aVF or
% 3. all 12 leads are available

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define 12, 6, and 2 lead ECG sets.
twelve_leads = ['I', 'II', 'III', 'aVR', 'aVL', 'aVF', 'V1', 'V2', 'V3', 'V4', 'V5', 'V6'];
six_leads    = ['I', 'II', 'III', 'aVR', 'aVL', 'aVF'];
two_leads    = ['II', 'V5'];

leads_idx = [];
UnusedLeads_idx = [];
Used_leads = {};
Unused_leads = {};
tmp_hea = strsplit(header_data{1},' ');
num_leads = str2num(tmp_hea{2});
if num_leads==12
    for ii=1:num_leads
        tmp_hea   = strsplit(header_data{ii+1},' ');
        Used_leads{ii} = tmp_hea{9};
        leads_idx = [leads_idx,ii];
    end
elseif num_leads==6
    for ii=1:num_leads
        tmp_hea   = strsplit(header_data{ii+1},' ');
        Lead_name{ii} = tmp_hea{9};
        switch Lead_name{ii}
            case 'I'
                leads_idx = [leads_idx,ii];
                Used_leads{ii}  = Lead_name{ii};
            case 'II'
                leads_idx = [leads_idx,ii];
                Used_leads{ii}  = Lead_name{ii};
            case 'III'
                leads_idx = [leads_idx,ii];
                Used_leads{ii}  = Lead_name{ii};
            case 'aVR'
                leads_idx = [leads_idx,ii];
                Used_leads{ii}  = Lead_name{ii};
            case 'aVL'
                leads_idx = [leads_idx,ii];
                Used_leads{ii}  = Lead_name{ii};
            case 'aVF'
                leads_idx = [leads_idx,ii];
                Used_leads{ii}  = Lead_name{ii};
            otherwise
                UnusedLeads_idx =[UnusedLeads_idx,ii];
                Unused_leads{ii}  = Lead_name{ii};
        end
    end
elseif num_leads==2
    for ii=1:num_leads
        tmp_hea   = strsplit(header_data{ii+1},' ');
        Lead_name{ii} = tmp_hea{9};
        switch Lead_name{ii}
            case 'II'
                leads_idx = [leads_idx,ii];
                Used_leads{ii}  = Lead_name{ii};
            case 'V5'
                leads_idx = [leads_idx,ii];
                Used_leads{ii}  = Lead_name{ii};
            otherwise
                UnusedLeads_idx =[UnusedLeads_idx,ii];
                Unused_leads{ii}  = Lead_name{ii};
        end
    end
end

end


