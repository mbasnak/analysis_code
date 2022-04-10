%Code for the group analysis of the open-loop bouts

clear all; close all;

%% Load data

path = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts\';

folderContents = dir(path);

for content = 1:length(folderContents)
   if contains(folderContents(content).name,'60D05')
       data(content) = load([folderContents(content).folder,'\',folderContents(content).name,'\analysis\continuous_open_loop_data.mat']);
   end
end

%% Clean and combine data

%remove empty rows
data = data(all(~cellfun(@isempty,struct2cell(data))));

%combine the summary tables into one
allSummaryData = array2table(zeros(0,10),'VariableNames', {'stim_offset_var','stim_offset_precision','bump_mag','bump_width','bump_mag_thresh','bump_width_thresh','contrast_level','stim_vel','mvt_offset_var','mvt_offset_precision'});
flyNumber = [];
for fly = 1:length(data)
    flyNumber = [flyNumber,repelem(fly,length(data(fly).summarydata.contrast_level))];
    allSummaryData = [allSummaryData;data(fly).summarydata]; 
end

allSummaryData = addvars(allSummaryData,flyNumber');
allSummaryData.Properties.VariableNames{'Var11'} = 'Fly';

%combine the model tables into one
allModelData = array2table(zeros(0,7),'VariableNames', {'bump_mag','bump_width','zscored_bump_mag','zscored_bump_width','adj_rs','total_mvt','brightness'});
fly_number = [];
for fly = 1:length(data)
    fly_number = [fly_number,repelem(fly,length(data(fly).all_model_data.brightness))];
    allModelData = [allModelData;data(fly).all_model_data]; 
end

allModelData = addvars(allModelData,fly_number');
allModelData.Properties.VariableNames{'Var8'} = 'Fly';

%export model data to do the statistical analysis in R
writetable(allModelData,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts\all_bump_par_data_open_loop.csv')
writetable(allSummaryData,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts\offset_data_ol.csv')

%% Get and plot mean offset precision per fly and in total

figure('Position',[200 200 1000 800]),
%Get mean offset var by contrast per fly
mean_stim_offset_data_per_fly = varfun(@mean,allSummaryData,'InputVariables','stim_offset_precision',...
       'GroupingVariables',{'contrast_level','Fly'});
allFlies = [];
for fly = 1:length(data)
    fly_data{fly} = [mean_stim_offset_data_per_fly.mean_stim_offset_precision(fly),mean_stim_offset_data_per_fly.mean_stim_offset_precision(fly+length(data))];
    allFlies = [allFlies;fly_data{fly}];
end
plot(56:57,allFlies','-o','color',[0.6 0.6 0.6],'MarkerFaceColor',[0.6 0.6 0.6])
hold on
errorbar(56:57,mean(allFlies),std(allFlies)/sqrt(length(allFlies)),'-ko','LineWidth',2,'MarkerFaceColor','k','MarkerSize',8)
xlim([55 58]);
xticks(56:57);
xticklabels({'Low brightness','High brightness'});
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',18)
ylabel('Offset precision','FontSize',20);
ylim([0 1]);
yticks([0:0.5:1]);

%save figure
saveas(gcf,[path,'\continuousGroupPlots\mean_open_loop_stim_offset_var.png']);
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueBrightness-Experiment\open_loop_offset_precision.svg');
% 
% %% Offset precision per speed per contrast
% 
% figure('Position',[200 200 1000 800]),
% %Get mean offset var by contrast per stim speed
% mean_stim_offset_data_per_speed = varfun(@mean,allSummaryData,'InputVariables','stim_offset_precision',...
%        'GroupingVariables',{'contrast_level','stim_vel'});
% plot(mean_stim_offset_data_per_speed.stim_vel(mean_stim_offset_data_per_speed.contrast_level==56),mean_stim_offset_data_per_speed.mean_stim_offset_precision(mean_stim_offset_data_per_speed.contrast_level==56),'-o','lineWidth',2,'color',[0 0 0.6],'MarkerFaceColor',[0 0 0.6],'MarkerSize',8)
% %add lines per fly
% mean_stim_offset_data_per_speed_and_fly = varfun(@mean,allSummaryData,'InputVariables','stim_offset_precision',...
%        'GroupingVariables',{'contrast_level','stim_vel','Fly'});
% allFlies_data{1} = [];
% allFlies_data{2} = [];
% for fly = 1:length(data)
%     fly_offset_data{fly} = [mean_stim_offset_data_per_speed_and_fly.mean_stim_offset_precision(mean_stim_offset_data_per_speed_and_fly.contrast_level==56 & mean_stim_offset_data_per_speed_and_fly.Fly==fly),mean_stim_offset_data_per_speed_and_fly.mean_stim_offset_precision(mean_stim_offset_data_per_speed_and_fly.contrast_level==57 & mean_stim_offset_data_per_speed_and_fly.Fly==fly)];
%     allFlies_data{1} = [allFlies_data{1},fly_offset_data{fly}(:,1)]; 
%     allFlies_data{2} = [allFlies_data{1},fly_offset_data{fly}(:,2)]; 
% end
% 
% hold on
% plot(mean_stim_offset_data_per_speed.stim_vel(mean_stim_offset_data_per_speed.contrast_level==57),mean_stim_offset_data_per_speed.mean_stim_offset_precision(mean_stim_offset_data_per_speed.contrast_level==57),'-o','lineWidth',2,'color',[ 0.5 0.8 0.9],'MarkerFaceColor',[ 0.5 0.8 0.9],'MarkerSize',8)
% xlim([0 4]);
% xticks(1:3);
% xticklabels({'20','30','60'});
% %add custom legend
% h = zeros(2, 1);
% h(1) = plot(NaN,NaN,'ko','MarkerFaceColor',[ 0 0 0.6]);
% h(2) = plot(NaN,NaN,'ko','MarkerFaceColor',[ 0.5 0.8 0.9]);
% legend(h, 'Low brightness','High brightness');
% a = get(gca,'XTickLabel');  
% [~,h2]=suplabel('Stimulus angular velocity (deg/s)','x');
% set(h2,'FontSize',12,'FontWeight','bold')
% set(gca,'XTickLabel',a,'fontsize',12,'FontWeight','bold')
% ylabel('Offset precision','FontSize',12);
% ylim([0 1]);
% 
% %save figure
% saveas(gcf,[path,'\continuousGroupPlots\open_loop_offset_precision_per_speed.png']);

%% Get and plot mean bump magnitude

figure('Position',[200 200 1000 800]),
%Get mean bump mag by contrast per fly
mean_bump_data_per_fly = varfun(@mean,allSummaryData,'InputVariables','bump_mag_thresh',...
       'GroupingVariables',{'contrast_level','Fly'});
%Plot
%plot(mean_bump_data_per_fly.contrast_level,mean_bump_data_per_fly.mean_bump_mag,'o','color',[0.6 0.6 0.6],'MarkerFaceColor',[0.6 0.6 0.6])
%change the code above to be able to get lines per fly
AllFlies = [];
for fly = 1:length(data)
    bump_data{fly} = [mean_bump_data_per_fly.mean_bump_mag_thresh(fly),mean_bump_data_per_fly.mean_bump_mag_thresh(fly+length(data))];
    AllFlies = [AllFlies;bump_data{fly}];
end
plot(56:57,AllFlies','-o','color',[0.6 0.6 0.6],'MarkerFaceColor',[0.6 0.6 0.6])
hold on
errorbar(56:57,mean(AllFlies),std(AllFlies)/sqrt(length(AllFlies)),'-ko','LineWidth',2,'MarkerFaceColor','k','MarkerSize',8)
xlim([55 58]);
xticks(56:57);
xticklabels({'Low brightness','High brightness'});
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',18)
ylabel('Mean bump magnitude (DF/F)','FontSize',20);
ylim([0 max(mean_bump_data_per_fly.mean_bump_mag_thresh)+0.3]);

%save figure
saveas(gcf,[path,'\continuousGroupPlots\mean_open_loop_bump_mag.png']);
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueBrightness-Experiment\open_loop_mean_bump_mag.svg');
% 
% %% Bump magnitude per speed per contrast
% 
% figure('Position',[200 200 1000 800]),
% %Get mean offset var by contrast per stim speed
% mean_bump_mag_data_per_speed = varfun(@mean,allSummaryData,'InputVariables','bump_mag_thresh',...
%        'GroupingVariables',{'contrast_level','stim_vel'});
% plot(mean_bump_mag_data_per_speed.stim_vel(mean_bump_mag_data_per_speed.contrast_level==56),mean_bump_mag_data_per_speed.mean_bump_mag_thresh(mean_bump_mag_data_per_speed.contrast_level==56),'-o','lineWidth',2,'color',[0 0 0.6],'MarkerFaceColor',[0 0 0.6],'MarkerSize',8)
% hold on
% plot(mean_bump_mag_data_per_speed.stim_vel(mean_bump_mag_data_per_speed.contrast_level==57),mean_bump_mag_data_per_speed.mean_bump_mag_thresh(mean_bump_mag_data_per_speed.contrast_level==57),'-o','lineWidth',2,'color',[ 0.5 0.8 0.9],'MarkerFaceColor',[ 0.5 0.8 0.9],'MarkerSize',8)
% xlim([0 4]);
% xticks(1:3);
% xticklabels({'20 deg/s','30 deg/s','60 deg/s'});
% %add custom legend
% h = zeros(2, 1);
% h(1) = plot(NaN,NaN,'ko','MarkerFaceColor',[ 0 0 0.6]);
% h(2) = plot(NaN,NaN,'ko','MarkerFaceColor',[ 0.5 0.8 0.9]);
% legend(h, 'Low contrast','High Contrast');
% a = get(gca,'XTickLabel');  
% [ax,h2]=suplabel('Stimulus angular velocity','x');
% set(h2,'FontSize',12,'FontWeight','bold')
% set(gca,'XTickLabel',a,'fontsize',12,'FontWeight','bold')
% ylabel({'Bump magnitude','(DF/F)'},'FontSize',12);
% %ylim([min(mean_bump_mag_data_per_speed.mean_bump_mag)-0.3 max(mean_bump_mag_data_per_speed.mean_bump_mag)+0.3]);
% ylim([0 max(mean_bump_mag_data_per_speed.mean_bump_mag_thresh)+0.3]);
% saveas(gcf,[path,'\continuousGroupPlots\bump_mag_per_speed.png']);

%% Get and plot mean half width

figure('Position',[200 200 1000 800]),
%Get mean bump mag by contrast per fly
mean_bump_width_data_per_fly = varfun(@mean,allSummaryData,'InputVariables','bump_width_thresh',...
       'GroupingVariables',{'contrast_level','Fly'});
%Plot
AllFlies = [];
for fly = 1:length(data)
    bump_width_data{fly} = [mean_bump_width_data_per_fly.mean_bump_width_thresh(fly),mean_bump_width_data_per_fly.mean_bump_width_thresh(fly+length(data))];
    AllFlies = [AllFlies;bump_width_data{fly}];
end
plot(56:57,AllFlies','-o','color',[0.6 0.6 0.6],'MarkerFaceColor',[0.6 0.6 0.6])
hold on
errorbar(56:57,mean(AllFlies),std(AllFlies)/sqrt(length(AllFlies)),'-ko','LineWidth',2,'MarkerFaceColor','k','MarkerSize',8)
xlim([55 58]);
xticks(56:57);
xticklabels({'Low brightness','High brigthness'});
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',18)
ylabel('Mean bump width (rad)','FontSize',20);
ylim([0 2.2]);

%save figure
saveas(gcf,[path,'\continuousGroupPlots\mean_open_loop_bump_width.png']);
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueBrightness-Experiment\open_loop_mean_bump_width.svg');
% 
% %% Half width per speed per contrast
% 
% figure('Position',[200 200 1000 800]),
% %Get mean offset var by contrast per stim speed
% mean_bump_width_data_per_speed = varfun(@mean,allSummaryData,'InputVariables','bump_width_thresh',...
%        'GroupingVariables',{'contrast_level','stim_vel'});
% plot(mean_bump_width_data_per_speed.stim_vel(mean_bump_width_data_per_speed.contrast_level==56),mean_bump_width_data_per_speed.mean_bump_width_thresh(mean_bump_width_data_per_speed.contrast_level==56),'-o','lineWidth',2,'color',[0 0 0.6],'MarkerFaceColor',[0 0 0.6],'MarkerSize',8)
% hold on
% plot(mean_bump_width_data_per_speed.stim_vel(mean_bump_width_data_per_speed.contrast_level==57),mean_bump_width_data_per_speed.mean_bump_width_thresh(mean_bump_width_data_per_speed.contrast_level==57),'-o','lineWidth',2,'color',[ 0.5 0.8 0.9],'MarkerFaceColor',[ 0.5 0.8 0.9],'MarkerSize',8)
% xlim([0 4]);
% xticks(1:3);
% xticklabels({'20 deg/s','30 deg/s','60 deg/s'});
% %add custom legend
% h = zeros(2, 1);
% h(1) = plot(NaN,NaN,'ko','MarkerFaceColor',[ 0 0 0.6]);
% h(2) = plot(NaN,NaN,'ko','MarkerFaceColor',[ 0.5 0.8 0.9]);
% legend(h, 'Low contrast','High Contrast');
% a = get(gca,'XTickLabel');  
% [ax,h2]=suplabel('Stimulus angular velocity','x');
% set(h2,'FontSize',12,'FontWeight','bold')
% set(gca,'XTickLabel',a,'fontsize',12,'FontWeight','bold')
% ylabel('Bump half width','FontSize',12);
% ylim([0 max(mean_bump_width_data_per_speed.mean_bump_width_thresh)+0.3]);
% 
% saveas(gcf,[path,'\continuousGroupPlots\bump_width_per_speed.png']);

%%
clear all; close all;