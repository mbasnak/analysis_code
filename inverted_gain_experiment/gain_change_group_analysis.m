%Group analysis code for the gain change experiment

clear all; close all; clc;

%% Load data

path = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data';

folderContents = dir(path);

for content = 1:length(folderContents)
   if (contains(folderContents(content).name,'60D05'))
       data(content) = load([folderContents(content).folder,'\',folderContents(content).name,'\analysis\gain_change_data.mat']);
   end
end

%% Clean and combine data

%Remove empty rows
data = data(all(~cellfun(@isempty,struct2cell(data))));

%Make the moving variable a numerical variable for concatenation
for fly = 1:length(data)
    for window = 1:6
        data(fly).modelTable{1,window}.Moving = double(data(fly).modelTable{1,window}.Moving);
    end
end

for fly = 1:length(data)
   all_flies_data{fly} = data(fly).modelTable;
end

%Remove empty cells
all_flies_data = all_flies_data(~cellfun('isempty',all_flies_data));

%Combine all data
for window = 1:6
    flyNumber = [];
    allData{window} = array2table(zeros(0,12),'VariableNames', {'BarOffsetVariability','HeadingOffsetVariability','BarOffsetPrecision','HeadingOffsetPrecision','TotalMovement','Moving','YawSpeed','BumpMagnitude','BumpWidth','Rsq','HeadingOffset','BarOffset'});
    for fly = 1:length(data)
        flyNumber = [flyNumber,repelem(fly,length(all_flies_data{1,fly}{1,window}.BumpMagnitude))];
        allData{window} = [allData{window};all_flies_data{1,fly}{1,window}];
    end
    allData{window} = addvars(allData{window},flyNumber');
    allData{window}.Properties.VariableNames{'Var13'} = 'Fly';
end


%Combine all movement data
for fly = 1:length(data)
   all_movement_data{fly} = data(fly).movementData;
end
%Remove empty cells
all_movement_data = all_movement_data(~cellfun('isempty',all_movement_data));

flyNumber = [];
movementData = array2table(zeros(0,3),'VariableNames', {'for_vel','yaw_speed','total_mvt'});
for fly = 1:length(data)
    flyNumber = [flyNumber,repelem(fly,length(all_movement_data{1,fly}.total_mvt))];
    movementData = [movementData;all_movement_data{1,fly}];
end
movementData = addvars(movementData,flyNumber');
movementData.Properties.VariableNames{'Var4'} = 'Fly';

%% Combine NG data

for fly = 1:length(data)
   all_flies_ng_data{fly} = data(fly).modelTableNG;
end
all_flies_ng_data = all_flies_ng_data(~cellfun('isempty',all_flies_ng_data));

for window = 1:6
    flyNumber = [];
    allDataNG{window} = array2table(zeros(0,8),'VariableNames', {'HeadingOffsetVariability','HeadingOffsetPrecision','TotalMovement','BumpMagnitude','BumpWidth','HeadingVariability','Rsq','Offset'});
    for fly = 1:length(data)
        flyNumber = [flyNumber,repelem(fly,length(all_flies_ng_data{1,fly}{1,window}.BumpMagnitude))];
        allDataNG{window} = [allDataNG{window};all_flies_ng_data{1,fly}{1,window}];
    end
    allDataNG{window} = addvars(allDataNG{window},flyNumber');
    allDataNG{window}.Properties.VariableNames{'Var9'} = 'Fly';
end

%% Determine changes in gain

gain_changes = [1837,9183];


%Compare heading offset distribution in the 3 periods

for fly = 1:length(data)
    
    offset_data_ig = deg2rad(allData{1,1}.HeadingOffset(allData{1,1}.Fly == fly));    
    offset_data_ng = deg2rad(allDataNG{1,1}.Offset(allDataNG{1,1}.Fly == fly));
    
    figure,
    subplot(1,3,1)
    polarhistogram(offset_data_ng(1:gain_changes(1)),15,'FaceColor',[.6 .6 .6])
    hold on
    rl = rlim;
    offset_mean = circ_mean(offset_data_ng(1:gain_changes(1)));
    offset_precision = circ_r(offset_data_ng(1:gain_changes(1)));
    polarplot([offset_mean,offset_mean],[0,rl(2)*offset_precision],'k','linewidth',2)
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,3,2)
    polarhistogram(offset_data_ig,15,'FaceColor',[.6 .6 .6])
    hold on
    rl = rlim;
    offset_mean = circ_mean(offset_data_ig);
    offset_precision = circ_r(offset_data_ig);
    polarplot([offset_mean,offset_mean],[0,rl(2)*offset_precision],'k','linewidth',2)
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,3,3)
    polarhistogram(offset_data_ng(gain_changes(1)+1:end),15,'FaceColor',[.6 .6 .6])
    hold on
    rl = rlim;
    offset_mean = circ_mean(offset_data_ng(gain_changes(1)+1:end));
    offset_precision = circ_r(offset_data_ng(gain_changes(1)+1:end));
    polarplot([offset_mean,offset_mean],[0,rl(2)*offset_precision],'k','linewidth',2)
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
end


%% Plot distribution of offset precisions in the initial and final normal gain bout

for fly = 1:length(data)
    
    offset_data_ng = deg2rad(allDataNG{1,1}.Offset(allDataNG{1,1}.Fly == fly));
    total_mvt_ng = allDataNG{1,1}.TotalMovement(allDataNG{1,1}.Fly == fly);
    
    offset_data_ng_initial = offset_data_ng(1:gain_changes(1));
    total_mvt_ng_initial = total_mvt_ng(1:gain_changes(1));
    offset_precision_ng_initial(fly) = circ_r(offset_data_ng_initial(total_mvt_ng_initial > 25));       
    
    offset_data_ng_final = offset_data_ng(gain_changes(1)+1:end);
    total_mvt_ng_final = total_mvt_ng(gain_changes(1)+1:end);
    offset_precision_ng_final(fly) = circ_r(offset_data_ng_final(total_mvt_ng_final > 25));     
    
end

figure,
boxplot(offset_precision_ng_initial)
hold on
scatter(repelem(1,1,length(data)),offset_precision_ng_initial)
ylim([0 1]);
ylabel('Initial offset precision');

figure,
boxplot(offset_precision_ng_final)
hold on
scatter(repelem(1,1,length(data)),offset_precision_ng_final)
ylim([0 1]);
ylabel('Final offset precision');


block_type = [repelem(1,1,length(offset_precision_ng_initial)),repelem(2,1,length(offset_precision_ng_final))];
fly_number = [1:length(offset_precision_ng_initial),1:length(offset_precision_ng_final)];
all_offset_precision = [offset_precision_ng_initial,offset_precision_ng_final];
all_offset_precision_ng = table(all_offset_precision',block_type',fly_number','VariableNames',{'offset_precision','block','fly'});
writetable(all_offset_precision_ng,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\offset_precision_ng.csv')

%% Plot total movement in time per fly

for fly = 1:length(data)
   total_movement(:,fly) = data(fly).movementData.total_mvt;   
end

figure('Position',[100 100 1600 1000]),
for fly = 1:length(data)
    subplot(length(data),1,fly)
    plot(total_movement(:,fly))
    hold on
    xline(gain_changes(1),'color','r','linewidth',2);
    xline(gain_changes(2),'color','r','linewidth',2);
    set(gca,'xticklabel',{[]})
end

saveas(gcf,[path,'\groupPlots\total_movement_evo.png']);
  
%1) Plot mean total movement per block
mean_total_movement = [nanmean(total_movement(1:gain_changes(1),:));nanmean(total_movement(gain_changes(1):gain_changes(2),:));nanmean(total_movement(gain_changes(2):end,:))];

figure,
plot(mean_total_movement,'color',[.6 .6 .6])
xlim([0 4]);
xticks([1:3]);
xticklabels({'NG','IG','NG'});
hold on
plot(mean(mean_total_movement'),'-ko','linewidth',2)
ylabel('Mean total movement');

saveas(gcf,[path,'\groupPlots\total_movement_per_block.png']);


%% Repeat for angular speed

for fly = 1:length(data)
   yaw_speed(:,fly) = data(fly).movementData.yaw_speed;   
end

%plot
figure('Position',[100 100 1600 1000]),
for fly = 1:length(data)
    subplot(length(data),1,fly)
    plot(yaw_speed(:,fly))
    hold on
    xline(gain_changes(1),'color','r','linewidth',2);
    xline(gain_changes(2),'color','r','linewidth',2);
    set(gca,'xticklabel',{[]})
end

saveas(gcf,[path,'\groupPlots\yaw_speed_evo.png']);
  
%1) Plot mean yaw speed per block
mean_yaw_speed = [nanmean(yaw_speed(1:gain_changes(1),:));nanmean(yaw_speed(gain_changes(1):gain_changes(2),:));nanmean(yaw_speed(gain_changes(2):end,:))];

figure,
plot(mean_yaw_speed,'color',[.6 .6 .6])
xlim([0 4]);
xticks([1:3]);
xticklabels({'NG','IG','NG'});
hold on
plot(mean(mean_yaw_speed'),'-ko','linewidth',2)
ylabel('Mean yaw speed');

saveas(gcf,[path,'\groupPlots\yaw_speed_per_block.png']);

%2) Plot evolution of yaw speed within the inverted gain period
length_inverted_gain = gain_changes(2) - gain_changes(1);
mean_yaw_speed_ig = [nanmean(yaw_speed(1:floor(length_inverted_gain/4),:));
    nanmean(yaw_speed(floor(length_inverted_gain/4):floor(length_inverted_gain/2),:));
    nanmean(yaw_speed(floor(length_inverted_gain/2):3*floor(length_inverted_gain/4),:));
    nanmean(yaw_speed(3*floor(length_inverted_gain/4):end,:))];

figure,
plot(mean_yaw_speed_ig,'color',[.6 .6 .6])
xlim([0 5]);
xticks([1:4]);
xticklabels({'1st quarter','2nd quarter','3rd quarter','4th quarter'});
hold on
plot(mean(mean_yaw_speed_ig'),'-ko','linewidth',2)
ylabel('Mean yaw speed');

saveas(gcf,[path,'\groupPlots\yaw_speed_during_ig.png']);


%% Repeat for forward vel

for fly = 1:length(data)
   for_vel(:,fly) = data(fly).movementData.for_vel;   
end

%plot
figure('Position',[100 100 1600 1000]),
for fly = 1:length(data)
    subplot(length(data),1,fly)
    plot(for_vel(:,fly))
    hold on
    xline(gain_changes(1),'color','r','linewidth',2);
    xline(gain_changes(2),'color','r','linewidth',2);
    set(gca,'xticklabel',{[]})
end

saveas(gcf,[path,'\groupPlots\for_vel_evo.png']);

%1) Plot mean for vel per block
mean_for_vel = [nanmean(for_vel(1:gain_changes(1),:));nanmean(for_vel(gain_changes(1):gain_changes(2),:));nanmean(for_vel(gain_changes(2):end,:))];

figure,
plot(mean_for_vel,'color',[.6 .6 .6])
xlim([0 4]);
xticks([1:3]);
xticklabels({'NG','IG','NG'});
hold on
plot(mean(mean_for_vel'),'-ko','linewidth',2)
ylabel('Mean forward velocity');

saveas(gcf,[path,'\groupPlots\for_vel_per_block.png']);


%% Plot probability of stopping per block

for fly = 1:length(mean_total_movement)
   p_stopping_1(fly) = 100*sum(total_movement(1:gain_changes(1),fly) < 25) / length(total_movement(1:gain_changes(1),fly));
   p_stopping_2(fly) = 100*sum(total_movement(gain_changes(1):gain_changes(2),fly) < 25) / length(total_movement(gain_changes(1):gain_changes(2),fly));
   p_stopping_3(fly) = 100*sum(total_movement(gain_changes(2):end,fly) < 25) / length(total_movement(gain_changes(2):end,fly));
end

p_stopping = [p_stopping_1;p_stopping_2;p_stopping_3];

figure,
plot(p_stopping,'color',[.6 .6 .6])
xlim([0 4]);
xticks([1:3]);
xticklabels({'NG','IG','NG'});
hold on
plot(mean(p_stopping'),'-ko','linewidth',2)
ylabel('Probability of stopping');

saveas(gcf,[path,'\groupPlots\p_stop_per_block.png']);

%% Compute model for bump parameters as a function of bar offset precision for all flies

%Fit mixed linear model using fly number as a random variable
for window = 1:6
    mdl_BM{window} = fitlme(allData{window},'BumpMagnitude~BarOffsetPrecision+TotalMovement+(1|Fly)');
    mdl_BW{window} = fitlme(allData{window},'BumpWidth~BarOffsetPrecision+TotalMovement+(1|Fly)');    
    %Model Rsquared
    Rsquared_BM(window) = mdl_BM{window}.Rsquared.Adjusted;
    Rsquared_BW(window) = mdl_BW{window}.Rsquared.Adjusted;    
end

figure,
subplot(1,2,1)
plot(Rsquared_BM,'-o')
title('Bump magnitude model fit with total mvt');
ylabel('Rsquared');
xlabel('window #');

subplot(1,2,2)
plot(Rsquared_BW,'-o')
title('Bump width model fit with total mvt');
ylabel('Rsquared');
xlabel('window #');

%Get window for max Rsquared model
[m I] = max(Rsquared_BM);
%mdl_BM{I}
I = I;

[m Iw] = max(Rsquared_BW);
Iw = Iw;

%% Combine and save data corresponding to best fit window

allBarOffsetPrecision = [];
allHeadingOffsetPrecision = [];
allBumpMagnitude = [];
allBumpWidth = [];
allTotalMovement = [];
allAdjRsq = [];
fly_number = [];

for window = I %get the data for the best fit window
    for fly = 1:length(all_flies_data)
        allBarOffsetPrecision = [allBarOffsetPrecision;all_flies_data{1,fly}{1,window}.BarOffsetPrecision];
        allHeadingOffsetPrecision = [allHeadingOffsetPrecision;all_flies_data{1,fly}{1,window}.HeadingOffsetPrecision];        
        allBumpMagnitude = [allBumpMagnitude;zscore(all_flies_data{1,fly}{1,window}.BumpMagnitude)];
        allBumpWidth = [allBumpWidth;zscore(all_flies_data{1,fly}{1,window}.BumpWidth)];
        allTotalMovement = [allTotalMovement;all_flies_data{1,fly}{1,window}.TotalMovement];
        allAdjRsq = [allAdjRsq;all_flies_data{1,fly}{1,window}.Rsq];
        fly_number = [fly_number,repelem(fly,1,length(all_flies_data{1,fly}{1,window}.TotalMovement))];
    end
end

%save data for statistical analysis
plotting_data_inv_gain = table(allBumpMagnitude,allBarOffsetPrecision,allHeadingOffsetPrecision,allTotalMovement,allAdjRsq,allBumpWidth,fly_number','VariableNames',{'bump_mag','bar_offset_precision','heading_offset_precision','total_mvt','adj_rs','bump_width','fly'});
writetable(plotting_data_inv_gain,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\plotting_data.csv')
% 
% %% Plot bump parameters vs bar offset variability across flies for all window sizes
% 
% clear meanBin
% clear meanBinw
% 
% %Define bins
% nbins = 10;
% max_bin = prctile(allBarOffsetPrecision,95,'all');
% min_bin = prctile(allBarOffsetPrecision,5,'all');
% binWidth = (max_bin-min_bin)/nbins;
% Bins = [min_bin:binWidth:max_bin];
% 
% %Create axes for plot
% mvtAxes = Bins - binWidth;
% mvtAxes = mvtAxes(2:end);
% 
% for window = 1:6
%     
%     figure,
%     
%     for fly = 1:length(all_flies_data)
%         
%         subplot(1,2,1)
%         
%         %Getting binned means
%         allBumpMag = zscore(all_flies_data{1,fly}{1,window}.BumpMagnitude);
%         bar_offset_precision = all_flies_data{1,fly}{1,window}.BarOffsetVariability;
%         total_movement = all_flies_data{1,fly}{1,window}.TotalMovement;
%         adj_rs = all_flies_data{1,fly}{1,window}.Rsq;
%         mvt_thresh = 20;
%         nbins = 10;
%         
%         for bin = 1:length(Bins)-1
%             meanBin(fly,bin) = nanmean(allBumpMag((bar_offset_precision > Bins(bin)) & (total_movement > mvt_thresh) & (adj_rs > 0.5) & (bar_offset_precision < Bins(bin+1))));
%         end
%         
%         plot(mvtAxes,meanBin(fly,:),'color',[.5 .5 .5])
%         hold on
%         ylabel('Zscored bump magnitude'); xlabel('Bar offset variability');
%         ylim([min(min(meanBin))-0.5 max(max(meanBin))+0.5]);
%         xlim([mvtAxes(1) mvtAxes(end)]);
%         
%         subplot(1,2,2)
%         
%         allHalfWidth = zscore(all_flies_data{1,fly}{1,window}.BumpWidth);
%         for bin = 1:length(Bins)-1
%             meanBinw(fly,bin) = nanmean(allHalfWidth((bar_offset_precision > Bins(bin)) & (total_movement > mvt_thresh) & (adj_rs > 0.5) & (bar_offset_precision < Bins(bin+1))));
%         end
%         
%         plot(mvtAxes,meanBinw(fly,:),'color',[.5 .5 .5])
%         hold on
%         ylabel('Zscored bump half width'); xlabel('Bar offset variability');
%         ylim([min(min(meanBin))-0.5 max(max(meanBinw))+0.5]);
%         xlim([mvtAxes(1) mvtAxes(end)]);
%     end
%     
%     plot(mvtAxes,nanmean(meanBinw),'k','linewidth',2)
%     subplot(1,2,1)
%     plot(mvtAxes,nanmean(meanBin),'k','linewidth',2)
%     
%     suptitle(['Window = ',num2str(window)]);
%  
% end
% 
% %% Plot bump parameters vs bar offset precision across flies for all window sizes
% 
% clear meanBin
% clear meanBinw
% 
% %define bin limits
% allBarOffsetPrecision = [];
% allBumpMagnitude = [];
% allBumpWidth = [];
% for window = 1:6
%     for fly = 1:length(all_flies_data)
%         allBarOffsetPrecision = [allBarOffsetPrecision;all_flies_data{1,fly}{1,window}.BarOffsetPrecision];
%         allBumpMagnitude = [allBumpMagnitude;zscore(all_flies_data{1,fly}{1,window}.BumpMagnitude)];
%         allBumpWidth = [allBumpWidth;zscore(all_flies_data{1,fly}{1,window}.BumpWidth)];
%     end
% end
% %Define bins
% nbins = 10;
% max_bin = prctile(allBarOffsetPrecision,95,'all');
% min_bin = prctile(allBarOffsetPrecision,5,'all');
% binWidth = (max_bin-min_bin)/nbins;
% Bins = [min_bin:binWidth:max_bin];
% 
% %Create axes for plot
% mvtAxes = Bins - binWidth;
% mvtAxes = mvtAxes(2:end);
% 
% for window = 1:6
%     
%     figure,
%     
%     for fly = 1:length(all_flies_data)
%         
%         subplot(1,2,1)
%         
%         %Getting binned means
%         allBumpMag = zscore(all_flies_data{1,fly}{1,window}.BumpMagnitude);
%         bar_offset_precision = all_flies_data{1,fly}{1,window}.BarOffsetPrecision;
%         total_movement = all_flies_data{1,fly}{1,window}.TotalMovement;
%         adj_rs = all_flies_data{1,fly}{1,window}.Rsq;
%         mvt_thresh = 20;
%         nbins = 10;
%         
%         for bin = 1:length(Bins)-1
%             meanBin(fly,bin) = nanmean(allBumpMag((bar_offset_precision > Bins(bin)) & (total_movement > mvt_thresh) & (adj_rs > 0.5) & (bar_offset_precision < Bins(bin+1))));
%         end
%         
%         plot(mvtAxes,meanBin(fly,:),'color',[.5 .5 .5])
%         hold on
%         ylabel('Zscored bump magnitude'); xlabel('Bar offset precision');
%         ylim([min(min(meanBin))-0.5 max(max(meanBin))+0.5]);
%         xlim([mvtAxes(1) mvtAxes(end)]);
%         
%         subplot(1,2,2)
%         
%         allHalfWidth = zscore(all_flies_data{1,fly}{1,window}.BumpWidth);
%         for bin = 1:length(Bins)-1
%             meanBinw(fly,bin) = nanmean(allHalfWidth((bar_offset_precision > Bins(bin)) & (total_movement > mvt_thresh) & (adj_rs > 0.5) & (bar_offset_precision < Bins(bin+1))));
%         end
%         
%         plot(mvtAxes,meanBinw(fly,:),'color',[.5 .5 .5])
%         hold on
%         ylabel('Zscored bump half width'); xlabel('Bar offset precision');
%         ylim([min(min(meanBin))-0.5 max(max(meanBinw))+0.5]);
%         xlim([mvtAxes(1) mvtAxes(end)]);
%     end
%     
%     plot(mvtAxes,nanmean(meanBinw),'k','linewidth',2)
%     subplot(1,2,1)
%     plot(mvtAxes,nanmean(meanBin),'k','linewidth',2)
%     
%     suptitle(['Window = ',num2str(window)]);
%  
% end
% 
% %% Plot bump parameters vs heading offset variability across flies for all window sizes
% 
% clear meanBin
% clear meanBinw
% 
% %define bin limits
% allHeadingOffsetVariability = [];
% allBumpMagnitude = [];
% allBumpWidth = [];
% for window = 1:6
%     for fly = 1:length(all_flies_data)
%         allHeadingOffsetVariability = [allHeadingOffsetVariability;all_flies_data{1,fly}{1,window}.HeadingOffsetVariability];
%         allBumpMagnitude = [allBumpMagnitude;zscore(all_flies_data{1,fly}{1,window}.BumpMagnitude)];
%         allBumpWidth = [allBumpWidth;zscore(all_flies_data{1,fly}{1,window}.BumpWidth)];
%     end
% end
% %Define bins
% nbins = 10;
% max_bin = prctile(allHeadingOffsetVariability,95,'all');
% min_bin = prctile(allHeadingOffsetVariability,5,'all');
% binWidth = (max_bin-min_bin)/nbins;
% Bins = [min_bin:binWidth:max_bin];
% 
% %Create axes for plot
% mvtAxes = Bins - binWidth;
% mvtAxes = mvtAxes(2:end);
% 
% for window = 1:6
%     
%     figure,
%     
%     for fly = 1:length(all_flies_data)
%         
%         subplot(1,2,1)
%         
%         %Getting binned means
%         allBumpMag = zscore(all_flies_data{1,fly}{1,window}.BumpMagnitude);
%         heading_offset_variability = all_flies_data{1,fly}{1,window}.HeadingOffsetVariability;
%         total_movement = all_flies_data{1,fly}{1,window}.TotalMovement;
%         adj_rs = all_flies_data{1,fly}{1,window}.Rsq;
%         
%         mvt_thresh = 20;
%         nbins = 10;
%         
%         for bin = 1:length(Bins)-1
%             meanBin(fly,bin) = nanmean(allBumpMag((heading_offset_variability > Bins(bin)) & (total_movement > mvt_thresh) & (adj_rs > 0.5) & (heading_offset_variability < Bins(bin+1))));
%         end
%         
%         plot(mvtAxes,meanBin(fly,:),'color',[.5 .5 .5])
%         hold on
%         ylabel('Zscored bump magnitude'); xlabel('heading offset variability');
%         ylim([min(min(meanBin))-0.5 max(max(meanBin))+0.5]);
%         xlim([mvtAxes(1) mvtAxes(end)]);
%         
%         subplot(1,2,2)
%         
%         allHalfWidth = zscore(all_flies_data{1,fly}{1,window}.BumpWidth);
%         for bin = 1:length(Bins)-1
%             meanBinw(fly,bin) = nanmean(allHalfWidth((heading_offset_variability > Bins(bin)) & (total_movement > mvt_thresh) & (adj_rs > 0.5) & (heading_offset_variability < Bins(bin+1))));
%         end
%         
%         plot(mvtAxes,meanBinw(fly,:),'color',[.5 .5 .5])
%         hold on
%         ylabel('Zscored bump half width'); xlabel('heading offset variability');
%         ylim([min(min(meanBin))-0.5 max(max(meanBinw))+0.5]);
%         xlim([mvtAxes(1) mvtAxes(end)]);
%     end
%     
%     plot(mvtAxes,nanmean(meanBinw),'k','linewidth',2)
%     subplot(1,2,1)
%     plot(mvtAxes,nanmean(meanBin),'k','linewidth',2)
%     
%     suptitle(['Window = ',num2str(window)]);
%  
% end

% 
% %% Plot bump parameters vs heading offset precision across flies for all window sizes
% 
% clear meanBin
% clear meanBinw
% 
% %define bin limits
% allHeadingOffsetPrecision = [];
% allBumpMagnitude = [];
% allBumpWidth = [];
% for window = 1:6
%     for fly = 1:length(all_flies_data)
%         allHeadingOffsetPrecision = [allHeadingOffsetPrecision;all_flies_data{1,fly}{1,window}.HeadingOffsetPrecision];
%         allBumpMagnitude = [allBumpMagnitude;zscore(all_flies_data{1,fly}{1,window}.BumpMagnitude)];
%         allBumpWidth = [allBumpWidth;zscore(all_flies_data{1,fly}{1,window}.BumpWidth)];
%     end
% end
% %Define bins
% nbins = 10;
% max_bin = prctile(allHeadingOffsetPrecision,95,'all');
% min_bin = prctile(allHeadingOffsetPrecision,5,'all');
% binWidth = (max_bin-min_bin)/nbins;
% Bins = [min_bin:binWidth:max_bin];
% 
% %Create axes for plot
% mvtAxes = Bins - binWidth;
% mvtAxes = mvtAxes(2:end);
% 
% for window = 1:6
%     
%     figure,
%     
%     for fly = 1:length(all_flies_data)
%         
%         subplot(1,2,1)
%         
%         %Getting binned means
%         allBumpMag = zscore(all_flies_data{1,fly}{1,window}.BumpMagnitude);
%         heading_offset_precision = all_flies_data{1,fly}{1,window}.HeadingOffsetPrecision;
%         total_movement = all_flies_data{1,fly}{1,window}.TotalMovement;
%         adj_rs = all_flies_data{1,fly}{1,window}.Rsq;
%         
%         mvt_thresh = 20;
%         nbins = 10;
%         
%         for bin = 1:length(Bins)-1
%             meanBin(fly,bin) = nanmean(allBumpMag((heading_offset_precision > Bins(bin)) & (total_movement > mvt_thresh) & (adj_rs > 0.5) & (heading_offset_precision < Bins(bin+1))));
%         end
%         
%         plot(mvtAxes,meanBin(fly,:),'color',[.5 .5 .5])
%         hold on
%         ylabel('Zscored bump magnitude'); xlabel('heading offset precision');
%         ylim([min(min(meanBin))-0.5 max(max(meanBin))+0.5]);
%         xlim([mvtAxes(1) mvtAxes(end)]);
%         
%         subplot(1,2,2)
%         
%         allHalfWidth = zscore(all_flies_data{1,fly}{1,window}.BumpWidth);
%         for bin = 1:length(Bins)-1
%             meanBinw(fly,bin) = nanmean(allHalfWidth((heading_offset_precision > Bins(bin)) & (total_movement > mvt_thresh) & (adj_rs > 0.5) & (heading_offset_precision < Bins(bin+1))));
%         end
%         
%         plot(mvtAxes,meanBinw(fly,:),'color',[.5 .5 .5])
%         hold on
%         ylabel('Zscored bump half width'); xlabel('heading offset precision');
%         ylim([min(min(meanBin))-0.5 max(max(meanBinw))+0.5]);
%         xlim([mvtAxes(1) mvtAxes(end)]);
%     end
%     
%     plot(mvtAxes,nanmean(meanBinw),'k','linewidth',2)
%     subplot(1,2,1)
%     plot(mvtAxes,nanmean(meanBin),'k','linewidth',2)
%     
%     suptitle(['Window = ',num2str(window)]);
%  
% end

%% Cluster data to see if it can be naturally divided into learners or not based on initial normal gain parameters

%I will use for each fly the following criteria:
%offset_var
%heading_var
%total_mvt
%mean bump mag
%mean bump width at half max

%create array
for fly = 1:length(data)
    
    %type_of_fly(fly) = data(fly).type_of_fly;
    gof = data(fly).modelTableNG{1,1}.Rsq(1:1836);
    movement = data(fly).modelTableNG{1,1}.TotalMovement(1:1836);
    
    BM = data(fly).modelTableNG{1,1}.BumpMagnitude(1:1836);
    mean_NG_bump_mag_thresh(fly) = mean(BM(gof>0.45 & movement > 25));
    
    BW = data(fly).modelTableNG{1,1}.BumpWidth(1:1836);
    mean_NG_bump_width_thresh(fly) = mean(BW(gof>0.45 & movement > 25));
    
    offset = deg2rad(data(fly).modelTableNG{1,1}.Offset(1:1836));
    NG_offset_precision(fly) = circ_r(offset(movement > 25));
    
end


%% Classify the flies using the ratio of precisions of the heading offset 

quarter_period = floor(length(data(1).modelTable{1,1}.HeadingOffset)/4);

for fly = 1:length(data)
       
    %get offset, gof and total movement
    bar_offset_initial_quarter = deg2rad(data(fly).modelTable{1,1}.BarOffset(1:quarter_period));
    bar_offset_final_quarter = deg2rad(data(fly).modelTable{1,1}.BarOffset(end-quarter_period:end));
    heading_offset_initial_quarter = deg2rad(data(fly).modelTable{1,1}.HeadingOffset(1:quarter_period));
    heading_offset_final_quarter = deg2rad(data(fly).modelTable{1,1}.HeadingOffset(end-quarter_period:end));
    
    rsq_initial_quarter = data(fly).modelTable{1,1}.Rsq(1:quarter_period);
    rsq_final_quarter = data(fly).modelTable{1,1}.Rsq(end-quarter_period:end);
    
    mvt_initial_quarter = data(fly).modelTable{1,1}.TotalMovement(1:quarter_period);
    mvt_final_quarter = data(fly).modelTable{1,1}.TotalMovement(end-quarter_period:end);    
    
    %get offset precision
    bar_offset_precision_initial_quarter = circ_r(bar_offset_initial_quarter);
    bar_offset_precision_initial_quarter_thresh = circ_r(bar_offset_initial_quarter(rsq_initial_quarter > 0.45));
    bar_offset_precision_final_quarter = circ_r(bar_offset_final_quarter);
    bar_offset_precision_final_quarter_thresh = circ_r(bar_offset_final_quarter(rsq_final_quarter > 0.45 & mvt_final_quarter > 25));
    
    heading_offset_precision_initial_quarter = circ_r(heading_offset_initial_quarter);
    heading_offset_precision_initial_quarter_thresh = circ_r(heading_offset_initial_quarter(rsq_initial_quarter > 0.45));
    heading_offset_precision_final_quarter = circ_r(heading_offset_final_quarter);
    heading_offset_precision_final_quarter_thresh = circ_r(heading_offset_final_quarter(rsq_final_quarter > 0.45 & mvt_final_quarter > 25));   
    
    %get offset precision ratios
    heading_bar_offset_precision_ratio_initial_quarter(fly) = heading_offset_precision_initial_quarter/bar_offset_precision_initial_quarter;
    heading_bar_offset_precision_ratio_final_quarter(fly) = heading_offset_precision_final_quarter/bar_offset_precision_final_quarter;
    heading_bar_offset_precision_ratio_initial_quarter_thresh(fly) = heading_offset_precision_initial_quarter_thresh/bar_offset_precision_initial_quarter_thresh;
    heading_bar_offset_precision_ratio_final_quarter_thresh(fly) = heading_offset_precision_final_quarter_thresh/bar_offset_precision_final_quarter_thresh;
    
end


figure('Position',[100 100 800 800]),
plot([heading_bar_offset_precision_ratio_initial_quarter_thresh;heading_bar_offset_precision_ratio_final_quarter_thresh],'-o','color',[.5 .5 .5])
hold on
plot(mean([heading_bar_offset_precision_ratio_initial_quarter_thresh;heading_bar_offset_precision_ratio_final_quarter_thresh],2),'-ko','linewidth',2,'MarkerFaceColor','k')
xlim([0 3]);
xticks([1 2]);
xticklabels({'Initial quarter','Final quarter'});
ylabel('Heading/bar offset precision','fontsize',16);
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',14)

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\InvertedGain-Experiment\first_and_fourth_quarter.svg')

%save data to plot in R
heading_bar_offset_ratio = table(heading_bar_offset_precision_ratio_initial_quarter_thresh',heading_bar_offset_precision_ratio_final_quarter_thresh','VariableNames',{'Initial_hb_ratio','Final_hb_ratio'});
writetable(heading_bar_offset_ratio,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\hb_offset_ratio_evo.csv')

%% Plot the between the ratio of bar/heading offset precision in the last quarter vs normal gain par values

figure('Position',[100 100 1400 600]),
subplot(1,3,1)
plot(heading_bar_offset_precision_ratio_final_quarter_thresh,mean_NG_bump_mag_thresh,'ko')
% hold on
% plot(heading_bar_offset_precision_ratio_final_quarter_thresh(12),mean_NG_bump_mag_thresh(12),'ko','MarkerFaceColor','r')
% plot(heading_bar_offset_precision_ratio_final_quarter_thresh(13),mean_NG_bump_mag_thresh(13),'ko','MarkerFaceColor','r')
xlabel('Final heading/bar offset precision');
ylabel('Bump magnitude in the preceding block')
ylim([0.5 3]);

subplot(1,3,2)
plot(heading_bar_offset_precision_ratio_final_quarter_thresh,mean_NG_bump_width_thresh,'ko')
% hold on
% plot(heading_bar_offset_precision_ratio_final_quarter_thresh(12),mean_NG_bump_width_thresh(12),'ko','MarkerFaceColor','r')
% plot(heading_bar_offset_precision_ratio_final_quarter_thresh(13),mean_NG_bump_width_thresh(13),'ko','MarkerFaceColor','r')
xlabel('Final heading/bar offset precision');
ylabel('Bump width in the preceding block')
ylim([1.5 2.5]);

subplot(1,3,3)
plot(heading_bar_offset_precision_ratio_final_quarter_thresh,NG_offset_precision,'ko')
% hold on
% plot(heading_bar_offset_precision_ratio_final_quarter_thresh(12),NG_offset_precision(12),'ko','MarkerFaceColor','r')
% plot(heading_bar_offset_precision_ratio_final_quarter_thresh(13),NG_offset_precision(13),'ko','MarkerFaceColor','r')
xlabel('Final heading/bar offset precision');
ylabel('Offset precision in the preceding block')

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\InvertedGain-Experiment\learning_strategy_prediction.svg')

% Save data for statistical analysis in R
learning_data = table(heading_bar_offset_precision_ratio_final_quarter_thresh',mean_NG_bump_mag_thresh',mean_NG_bump_width_thresh',NG_offset_precision','VariableNames',{'offset_ratio','bump_mag','bump_width','offset_precision'});
writetable(learning_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\learning_data.csv')
% 
% %% Repeat eliminating flies that weren't walking
% 
% heading_bar_offset_precision_ratio_final_quarter_thresh(12:13) = [];
% mean_NG_bump_mag_thresh(12:13) = [];
% mean_NG_bump_width_thresh(12:13) = [];
% NG_offset_precision(12:13) = [];
% 
% figure('Position',[100 100 1400 600]),
% subplot(1,3,1)
% plot(heading_bar_offset_precision_ratio_final_quarter_thresh,mean_NG_bump_mag_thresh,'ko')
% xlabel('Final heading/bar offset precision');
% ylabel('Bump magnitude in the preceding block')
% ylim([0.5 3]);
% 
% subplot(1,3,2)
% plot(heading_bar_offset_precision_ratio_final_quarter_thresh,mean_NG_bump_width_thresh,'ko')
% xlabel('Final heading/bar offset precision');
% ylabel('Bump width in the preceding block')
% ylim([1.5 2.5]);
% 
% subplot(1,3,3)
% plot(heading_bar_offset_precision_ratio_final_quarter_thresh,NG_offset_precision,'ko')
% xlabel('Final heading/bar offset precision');
% ylabel('Offset precision in the preceding block')
% 
% saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\InvertedGain-Experiment\learning_strategy_prediction_without_poor_walkers.svg')
% 
% % Save data for statistical analysis in R
% learning_data_without_poor_walkers = table(heading_bar_offset_precision_ratio_final_quarter_thresh',mean_NG_bump_mag_thresh',mean_NG_bump_width_thresh',NG_offset_precision','VariableNames',{'offset_ratio','bump_mag','bump_width','offset_precision'});
% writetable(learning_data_without_poor_walkers,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\learning_data_without_poor_walkers.csv')


%% 
clear all; close all;