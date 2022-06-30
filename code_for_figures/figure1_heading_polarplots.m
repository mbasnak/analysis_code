
% Polar plot of heading per condition, representing each fly as a vector


clear all; close all;

%% Load data

path = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts';
%Get folder names
folderContents = dir(path);

%Load the summary data of the folder that correspond to experimental flies
for content = 1:length(folderContents)
   if contains(folderContents(content).name,'60D05')
       data(content) = load([folderContents(content).folder,'\',folderContents(content).name,'\analysis\continuous_summary_data.mat']);
   end
end

%Remove empty rows
data = data(all(~cellfun(@isempty,struct2cell(data))));

%% Plot

figure('Position',[100 100 1600 600]),

for fly = 1:length(data)
    
%zero contrast
subplot(1,3,1)

heading = data(fly).modelTable.Heading;
moving = zeros(1,size(heading,1));
moving(data(fly).modelTable.TotalMovement > 20) = 1;
zero_contrast = zeros(1,size(heading,1));
zero_contrast(data(fly).modelTable.ContrastLevel == 1) = 1;
heading = heading(moving & zero_contrast);

heading_mean = circ_mean(deg2rad(heading));
heading_strength = circ_r(deg2rad(heading));
polarplot([heading_mean,heading_mean],[0,heading_strength],'k','linewidth',4)
set(gca,'ThetaZeroLocation','top',...
    'ThetaDir','clockwise');
rlim([0 1])
rticklabels({}); 
rticks([]);
thetaticks([0,90,180,270]);
ax = gca;
ax.FontSize = 20;
hold on
title('Zero contrast');


%low contrast
subplot(1,3,2)

heading = data(fly).modelTable.Heading;
moving = zeros(1,size(heading,1));
moving(data(fly).modelTable.TotalMovement > 20) = 1;
low_contrast = zeros(1,size(heading,1));
low_contrast(data(fly).modelTable.ContrastLevel == 2) = 1;
heading = heading(moving & low_contrast);

heading_mean = circ_mean(deg2rad(heading));
heading_strength = circ_r(deg2rad(heading));
polarplot([heading_mean,heading_mean],[0,heading_strength],'k','linewidth',4)
set(gca,'ThetaZeroLocation','top',...
    'ThetaDir','clockwise');
rlim([0 1])
rticklabels({}); 
rticks([]);
thetaticks([0,90,180,270]);
ax = gca;
ax.FontSize = 20;
hold on
title('Low contrast');

%high contrast
subplot(1,3,3)

heading = data(fly).modelTable.Heading;
moving = zeros(1,size(heading,1));
moving(data(fly).modelTable.TotalMovement > 20) = 1;
high_contrast = zeros(1,size(heading,1));
high_contrast(data(fly).modelTable.ContrastLevel == 3) = 1;
heading = heading(moving & high_contrast);

heading_mean = circ_mean(deg2rad(heading));
heading_strength = circ_r(deg2rad(heading));
polarplot([heading_mean,heading_mean],[0,heading_strength],'k','linewidth',4)
set(gca,'ThetaZeroLocation','top',...
    'ThetaDir','clockwise');
rlim([0 1])
rticklabels({}); 
rticks([]);
thetaticks([0,90,180,270]);
ax = gca;
ax.FontSize = 20;
hold on
title('High contrast');

end

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\ExtraFigures\figure1_heading_polarhistograms.svg')