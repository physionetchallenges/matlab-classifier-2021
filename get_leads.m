function [leads, leads_idx]= get_leads(header_data, num_leads)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
% Extract the available ECG leads
% 1. 12 leads are available or
% 2. Reduced leads: for any lead sets defined at the beginning in
% "lead_sets", e.g:
%    - If 6-leads are available: I, II, III, aVR, aVL & aVF or
%    - If 3-leads are avialable: I, II, III & V2 or
%    - If 4-leads are avialable: I, II & V2 or
%    - If 2-leads are avialable: I & V5, etc.

% Inputs:
% 1. Header files and the number of leads
%
% Outputs:
% leads: available leads names
% leads_idx: The index of available leads
%
% Author: Nadi Sadr, PhD, <nadi.sadr@dbmi.emory.edu>
% Version 1.0
% Date 9-Dec-2020
% Version 2.0 26-Jan-2021
% Version 3.0 26-April-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define lead sets (e.g 12, 6, 4, 3 and 2 lead ECG sets)
twelve_leads = [{'I'}, {'II'}, {'III'}, {'aVR'}, {'aVL'}, {'aVF'}, {'V1'}, {'V2'}, {'V3'}, {'V4'}, {'V5'}, {'V6'}];
six_leads    = [{'I'}, {'II'}, {'III'}, {'aVR'}, {'aVL'}, {'aVF'}];
four_leads   = [{'I'}, {'II'}, {'III'}, {'V2'}];
three_leads  = [{'I'}, {'II'}, {'V2'}];
two_leads    = [{'II'}, {'V5'}];
lead_sets = {twelve_leads, six_leads, four_leads, three_leads, two_leads};

leads = {};
jj =1;
tmp_hea = strsplit(header_data{1},' ');
[recording,Total_time,Max_leads] = extract_data_from_header(header_data);

% Extract 12 leads
if num_leads==12
    for ii=1:Max_leads
        tmp_hea   = strsplit(header_data{ii+1},' ');
        leads{ii} = tmp_hea{9};
        leads_idx{ii} = ii;
    end
    % Extract reduced leads (six-, four-, three- or two-leads, ...)
else
    for ileads =1:length(lead_sets)-1
        if num_leads == length(lead_sets{ileads})
            for ii=1:Max_leads
                tmp_hea   = strsplit(header_data{ii+1},' ');
                Lead_name{ii} = tmp_hea{9};
                switch Lead_name{ii}
                    case lead_sets{ileads}(ii)
                        leads_idx{jj} = ii;
                        leads{jj}  = Lead_name{ii};
                        jj = jj+1;
                end
            end
        end
    end
end
