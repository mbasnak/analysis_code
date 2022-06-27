%Code for the group analysis of the closed-loop bouts using the continuous
%method

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

%% Clean and combine data

%Remove empty rows
data = data(all(~cellfun(@isempty,struct2cell(data))));

%Combine the tables into one
allSummaryData = array2table(zeros(0,7),'VariableNames', {'contrast','offset_var','offset_precision','mean_bump_mag','mean_bump_width','heading_var','heading_precision'});
flyNumber= [];
for fly = 1:length(data)
    flyNumber = [flyNumber,repelem(fly,length(data(fly).summary_data.contrast))];
    allSummaryData = [allSummaryData;data(fly).summary_data]; 
end

%Add the fly ID as a variable
if size(allSummaryData,2) < 8
    allSummaryData = addvars(allSummaryData,nominal(flyNumber'));
    allSummaryData.Properties.VariableNames{'Var8'} = 'Fly';
end

%save data to csv for statistical analysis in R
writetable(allSummaryData,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts\offset_and_heading_data.csv')

%% Reorder data to bring the darkness observation to the first row, such that the model

%will use 'darkness' as the default
reordered_data = allSummaryData;
reordered_data(height(reordered_data)+1,:) = reordered_data(1,:);
reordered_data(1,:) = reordered_data(2,:);
reordered_data(2,:) = reordered_data(height(reordered_data),:);
reordered_data(height(reordered_data),:) = [];

%% Plot mean offset precision

figure('Position',[200 200 1000 800]),
%Get mean offset var by contrast per fly
mean_offset_data_per_fly = varfun(@mean,allSummaryData,'InputVariables','offset_precision',...
       'GroupingVariables',{'contrast','Fly'});
%Plot
allFlies = [];
for fly = 1:length(data)
    fly_data{fly} = [mean_offset_data_per_fly.mean_offset_precision(fly),mean_offset_data_per_fly.mean_offset_precision(fly+2*length(data)),mean_offset_data_per_fly.mean_offset_precision(fly+length(data))];
    allFlies = [allFlies;fly_data{fly}];
end
plot(1:3,allFlies','-o','color',[0.6 0.6 0.6],'MarkerFaceColor',[0.6 0.6 0.6])

%Get mean offset variation by contrast
mean_offset_data = varfun(@mean,allSummaryData,'InputVariables','offset_precision',...
       'GroupingVariables',{'contrast'});
%Get error in offset variation
std_offset_data = varfun(@std,allSummaryData,'InputVariables','offset_precision',...
       'GroupingVariables',{'contrast'});
hold on
%Add mean and error
errorbar(1:3,mean(allFlies),std(allFlies)/sqrt(length(allFlies)),'-ko','LineWidth',2,'MarkerFaceColor','k','MarkerSize',8)
xlim([0 4]);
xticks(1:3);
xticklabels({'Darkness','Low contrast','High contrast'});
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',18)
ylabel('Offset precision','FontSize',20);
yticks([0:0.5:1]);
ylim([0 1]);

%save figure
saveas(gcf,[path,'\continuousGroupPlots\mean_closed_loop_offset_precision.png']);
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueBrightness-Experiment\mean_closed_loop_offset_precision.svg');

%% Plot group heading precision

%Get mean heading var by contrast per fly
mean_heading_data_per_fly = varfun(@mean,allSummaryData,'InputVariables','heading_precision',...
       'GroupingVariables',{'contrast','Fly'});
   
figure('Position',[200 200 1000 800]),
%Plot
allflies = [];
for fly = 1:length(data)
    fly_data_heading{fly} = [mean_heading_data_per_fly.mean_heading_precision(fly),mean_heading_data_per_fly.mean_heading_precision(fly+2*length(data)),mean_heading_data_per_fly.mean_heading_precision(fly+length(data))];
    allflies = [allflies;fly_data_heading{fly}];
end
plot(1:3,allflies','-o','color',[0.6 0.6 0.6],'MarkerFaceColor',[0.6 0.6 0.6])

%Get mean heading var by contrast in total
mean_heading_data = varfun(@mean,allSummaryData,'InputVariables','heading_precision',...
       'GroupingVariables',{'contrast'});
hold on
errorbar(1:3,mean(allflies),std(allflies)/sqrt(length(allFlies)),'-ko','LineWidth',2,'MarkerFaceColor','k','MarkerSize',8)
xlim([0 4]);
xticks(1:3);
xticklabels({'Darkness','Low brightness','High brightness'});
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',18)
ylabel('Heading precision','FontSize',20);
ylim([0 1]);
yticks([0:0.5:1]);

%save figure
saveas(gcf,[path,'\continuousGroupPlots\mean_closed_loop_heading_precision.png']);
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueBrightness-Experiment\mean_closed_loop_heading_precision.svg');

%% Plot offset and heading precision

figure('Position',[200 200 1000 900]),
subplot(2,1,1)
plot(1:3,allFlies','color',[0.6 0.6 0.6],'MarkerFaceColor',[0.6 0.6 0.6])
hold on
%Add mean and error
errorbar(1:3,mean(allFlies),std(allFlies)/sqrt(length(allFlies)),'-k','LineWidth',3,'MarkerFaceColor','k','MarkerSize',8)
xlim([0 4]);
xticklabels({});
ylabel('Offset precision','FontSize',20);
ylim([0 1]);
yticks([0:0.5:1]);
a = get(gca,'YTickLabel');  
set(gca,'YTickLabel',a,'fontsize',18)

subplot(2,1,2)
plot(1:3,allflies','color',[0.6 0.6 0.6],'MarkerFaceColor',[0.6 0.6 0.6])
hold on
errorbar(1:3,mean(allflies),std(allflies)/sqrt(length(allFlies)),'-k','LineWidth',3,'MarkerFaceColor','k','MarkerSize',8)
xlim([0 4]);
xticks(1:3);
xticklabels({'Darkness','Low brightness','High brightness'});
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',18)
ylabel('Heading precision','FontSize',20);
ylim([0 1]);
yticks([0:0.5:1]);

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueBrightness-Experiment\mean_closed_loop_offset_and_heading_precision.svg');


%% Combine bump parameters tables into one

%Add zscored bump magnitude and bump width to the tables for each
%individual fly
for fly = 1:length(data)   
    zscoredBM = zscore(data(fly).modelTable.BumpMagnitude);
    zscoredBW = zscore(data(fly).modelTable.BumpWidth);
    if size(data(fly).modelTable,2) < 16
        data(fly).modelTable = addvars(data(fly).modelTable,zscoredBM,'NewVariableNames','zscoredBM');
        data(fly).modelTable = addvars(data(fly).modelTable,zscoredBW,'NewVariableNames','zscoredBW');
    end
end


%Combine the tables into one
allModelData = array2table(zeros(0,16),'VariableNames', {'ContrastLevel','ForVelocity','ZscoredForVel','SideSpeed','ZscoredSideSpeed','YawSpeed','ZscoredYawSpeed','TotalMovement','ZscoredTotalMovement','Time','BumpMagnitude','AdjRSquare','BumpWidth','Heading','zscoredBM','zscoredBW'});
Fly = [];
for fly = 1:length(data)
    Fly = [Fly,repelem(fly,length(data(fly).modelTable.ContrastLevel))];
    allModelData = [allModelData;data(fly).modelTable]; 
end
%Add fly id as a categorical variable
if size(data(fly).modelTable,2) < 17
    allModelData = addvars(allModelData,nominal(Fly'));
    allModelData.Properties.VariableNames{'Var17'} = 'Fly';
end

%Change contrast level as a categorical variable
allModelData.ContrastLevel = nominal(allModelData.ContrastLevel);

% Add binary variables to the table to define if the animal was moving and if the fit is good
moving = zeros(1,size(allModelData,1));
moving(allModelData.TotalMovement > 20) = 1;

%add to table
if size(data(fly).modelTable,2) < 18
    allModelData = addvars(allModelData,nominal(moving'));
    allModelData.Properties.VariableNames{'Var18'} = 'Moving';
end

good_fit = zeros(1,size(allModelData,1));
good_fit(allModelData.AdjRSquare >= 0.5) = 1;

%add to table
if size(data(fly).modelTable,2) < 19
    allModelData = addvars(allModelData,nominal(good_fit'));
    allModelData.Properties.VariableNames{'Var19'} = 'GoodFit';    
end

%save table to file for statistical analysis in R
writetable(allModelData,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts\allModelData.csv');

%% Plot zscored bump parameters vs total movement, parsed by contrast

all_contrast_levels = str2num(char(allModelData.ContrastLevel));
allzBumpMag = allModelData.zscoredBM;
allzBumpWidth = allModelData.zscoredBW;
adj_rs = allModelData.AdjRSquare;

color_gradient = {[0,0,0],[0 0 0.6],[ 0.5 0.8 0.9]};

%Define bin limits
nbins = 20;
TotalMvt = allModelData.TotalMovement;
maxBinTM = prctile(TotalMvt,97.5); %upper limit
minBinTM = prctile(TotalMvt,2.5);
binWidthTM = (maxBinTM-minBinTM)/nbins;
totalMvtBins = [minBinTM:binWidthTM:maxBinTM];

%Create axes for plot, centering them in the middle of the bin
totalMvtAxes = totalMvtBins-binWidthTM/2;
totalMvtAxes = totalMvtAxes(2:end);

figure('Position',[100 100 1200 800]),

%Total movement
subplot(1,2,1)
%Get binned means
for contrast = 1:3
    for bin = 1:length(totalMvtBins)-1
        doubleBin(bin,contrast) = nanmean(allzBumpMag((TotalMvt(1:length(allzBumpMag)) > totalMvtBins(bin)) & (TotalMvt(1:length(allzBumpMag)) < totalMvtBins(bin+1)) & (adj_rs >= 0.5) & (all_contrast_levels == contrast)));
        st_deviation = std(allzBumpMag((TotalMvt(1:length(allzBumpMag)) > totalMvtBins(bin)) & (TotalMvt(1:length(allzBumpMag)) < totalMvtBins(bin+1)) & (adj_rs >= 0.5) & (all_contrast_levels == contrast)));
        n_points = length(allzBumpMag((TotalMvt(1:length(allzBumpMag)) > totalMvtBins(bin)) & (TotalMvt(1:length(allzBumpMag)) < totalMvtBins(bin+1)) & (adj_rs >= 0.5) & (all_contrast_levels == contrast)));
        st_error(bin,contrast) = st_deviation./sqrt(n_points);
    end
    boundedline(totalMvtAxes,doubleBin(:,contrast),st_error(:,contrast),'cmap',color_gradient{contrast})
    hold on
end
ylabel('Mean zscored bump magnitude','fontsize',20); xlabel('Total movement (deg/s)','fontsize',20);
xlim([minBinTM-binWidthTM/2 maxBinTM+binWidthTM/2]);
ylim([-0.8 0.8]);
yticks([-0.8:0.4:0.8]);
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',14)
%add custom legend
h = zeros(3, 1);
for brightness = 1:length(h)
    h(brightness) = plot(NaN,NaN,'color',color_gradient{brightness});
end
legend(h,'Darkness','Low brightness','High brightness','location','best');

%Bump width
subplot(1,2,2)
%Get binned means
for contrast = 1:3
    for bin = 1:length(totalMvtBins)-1
        doubleBin(bin,contrast) = nanmean(allzBumpWidth((TotalMvt(1:length(allzBumpWidth)) > totalMvtBins(bin)) & (TotalMvt(1:length(allzBumpWidth)) < totalMvtBins(bin+1)) & (adj_rs >= 0.5) & (all_contrast_levels == contrast)));
        st_deviation = std(allzBumpMag((TotalMvt(1:length(allzBumpWidth)) > totalMvtBins(bin)) & (TotalMvt(1:length(allzBumpWidth)) < totalMvtBins(bin+1)) & (adj_rs >= 0.5) & (all_contrast_levels == contrast)));
        n_points = length(allzBumpWidth((TotalMvt(1:length(allzBumpWidth)) > totalMvtBins(bin)) & (TotalMvt(1:length(allzBumpWidth)) < totalMvtBins(bin+1)) & (adj_rs >= 0.5) & (all_contrast_levels == contrast)));
        st_error(bin,contrast) = st_deviation./sqrt(n_points);
    end
    boundedline(totalMvtAxes,doubleBin(:,contrast),st_error(:,contrast),'cmap',color_gradient{contrast})
    hold on
end
ylabel('Mean zscored bump width','fontsize',20); xlabel('Total movement (deg/s)','fontsize',20);
xlim([minBinTM-binWidthTM/2 maxBinTM+binWidthTM/2]);
ylim([-0.8 0.8]);
yticks([-0.8:0.4:0.8]);
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',14)
%add custom legend
h = zeros(3, 1);
for brightness = 1:length(h)
    h(brightness) = plot(NaN,NaN,'color',color_gradient{brightness});
end
legend(h,'Darkness','Low brightness','High brightness','location','best');

%save figure
saveas(gcf,[path,'\continuousGroupPlots\z_bump_parameters_vs_mvt_and_contrast.png']);
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueBrightness-Experiment\z_bump_parameters_vs_mvt_and_contrast.svg');


%%
clear all; close all; clc