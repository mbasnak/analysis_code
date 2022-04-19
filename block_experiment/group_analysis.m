%Group analysis code for the cue combination experiment

clear all; close all;

%% Load data

path = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability';

folderContents = dir(path);

for content = 1:length(folderContents)
   if contains(folderContents(content).name,'60D05')
       data(content) = load([folderContents(content).folder,'\',folderContents(content).name,'\analysis\data.mat']);
   end
end

%Remove empty rows
data = data(all(~cellfun(@isempty,struct2cell(data))));

%% Combine all data

offset_precision = [];
offset_precision_6_blocks = [];
heading_precision = [];
heading_precision_6_blocks = [];
offset_mean = [];
heading_mean = [];
thresh_BM_mean = [];
thresh_BW_mean = [];
total_mvt = [];
initial_cue_diff = [];
bar_offset_diff = [];
wind_offset_diff = [];
configuration = [];

allSummaryData = array2table(zeros(0,6),'VariableNames', {'BumpMag','BumpWidth','TotalMvt','YawSpeed','ForVel','BlockType'});
flyNumber = [];

for fly = 1:length(data)
    
    offset_precision = [offset_precision;data(fly).offset_precision];
    offset_precision_6_blocks = [offset_precision_6_blocks;data(fly).offset_precision_6_blocks];    
    heading_precision = [heading_precision;data(fly).heading_precision];    
    heading_precision_6_blocks = [heading_precision_6_blocks;data(fly).heading_precision_6_blocks];        
    offset_mean = [offset_mean;data(fly).offset_mean];
    heading_mean = [heading_mean;data(fly).heading_mean];
    thresh_BM_mean = [thresh_BM_mean;data(fly).allBM_thresh'];
    thresh_BW_mean = [thresh_BW_mean;data(fly).allBW_thresh'];  
    total_mvt = [total_mvt;data(fly).all_total_mvt_thresh'];
    initial_cue_diff(fly) = data(fly).initial_cue_diff;
    bar_offset_diff(fly) = data(fly).bar_offset_diff;
    wind_offset_diff(fly) = data(fly).wind_offset_diff;
    configuration(fly) = data(fly).configuration;

    allSummaryData = [allSummaryData;data(fly).summary_data];
    flyNumber = [flyNumber,repelem(fly,length(data(fly).summary_data.BumpMag))];
end
allSummaryData = addvars(allSummaryData,flyNumber');
allSummaryData.Properties.VariableNames{'Var7'} = 'Fly';


%% Plot offset precision vs bump parameters for each block

for block = 1:5
    
   figure,
   subplot(1,2,1)
   plot(offset_precision(:,block),thresh_BM_mean(:,block),'o')
   xlabel('Offset precision'); ylabel('Mean bump magnitude');
   
   subplot(1,2,2)
   plot(offset_precision(:,block),thresh_BW_mean(:,block),'o')
   xlabel('Offset precision'); ylabel('Mean bump width');
   
   suptitle(['Block # ',num2str(block)]);
   
   saveas(gcf,[path,'\groupPlots\offset_precision_vs_bump_pars_block',num2str(block),'.png']);

end

%% Plot offset precision per block

set(0,'DefaultTextInterpreter','none')

figure('Position',[100 100 800 800]),
subplot(1,2,1)
plot(offset_precision','-o','color',[.5 .5 .5]);
xlim([0 6]);
hold on
errorbar([1:5],nanmean(offset_precision),std(offset_precision)/sqrt(length(configuration)),'-ko','MarkerFaceColor','k','linewidth',3)
ylabel('Offset precision','fontsize',18);
ylim([0 1]);
xticks([1 2 3 4 5]);
xticklabels({'single cue','single cue','cue combination','single cue','single cue'})
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',16)

subplot(1,2,2)
plot(offset_precision_6_blocks','-o','color',[.5 .5 .5]);
xlim([0 7]);
hold on
errorbar([1:6],nanmean(offset_precision_6_blocks),std(offset_precision_6_blocks)/sqrt(length(configuration)),'-ko','MarkerFaceColor','k','linewidth',3)
ylabel('Offset precision','fontsize',18);
ylim([0 1]);
xticks([1 2 3 4 5 6]);
xticklabels({'single cue','single cue','cue combination 1st half','cue combination 2nd half','single cue','single cue'})
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',16)

saveas(gcf,[path,'\groupPlots\offset_precision.png']);
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Block-Experiment\offset_precision.svg');

%% averaging the initial single cue and final single cue bouts

averaged_offset_precision = zeros(length(offset_precision),3);
averaged_offset_precision(:,1) = mean([offset_precision(:,1),offset_precision(:,2)],2);
averaged_offset_precision(:,2) = offset_precision(:,3);
averaged_offset_precision(:,3) = mean([offset_precision(:,4),offset_precision(:,5)],2);

figure,
plot(averaged_offset_precision','-o','color',[.5 .5 .5]);
xlim([0 4]);
hold on
errorbar([1:3],nanmean(averaged_offset_precision),std(averaged_offset_precision)/sqrt(length(configuration)),'-ko','MarkerFaceColor','k','linewidth',3)
ylabel('Offset precision','fontsize',18);
ylim([0 1]);
xticks([1 2 3 4 5]);
xticklabels({'single cue','cue combination','single cue'})
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',16)


%save data for statistical analysis
offset_precision_data_3_blocks = [averaged_offset_precision,(1:length(averaged_offset_precision))'];
writematrix(offset_precision_data_3_blocks,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability\offset_precision_data_3_blocks.csv')


%% Plot heading precision per block

set(0,'DefaultTextInterpreter','none')

figure('Position',[100 100 800 800]),
subplot(1,2,1)
plot(heading_precision','-o','color',[.5 .5 .5]);
xlim([0 6]);
hold on
plot(nanmean(heading_precision),'-ko','linewidth',3,'MarkerFaceColor','k')
ylabel('Heading precision','fontsize',18);
ylim([0 1]);
xticks([1 2 3 4 5]);
xticklabels({'single cue','single cue','cue combination','single cue','single cue'})
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',16)

subplot(1,2,2)
plot(heading_precision_6_blocks','-o','color',[.5 .5 .5]);
xlim([0 7]);
hold on
plot(nanmean(heading_precision_6_blocks),'-ko','linewidth',3,'MarkerFaceColor','k')
ylabel('Heading precision','fontsize',18);
ylim([0 1]);
xticks([1 2 3 4 5 6]);
xticklabels({'single cue','single cue','cue combination 1st half','cue combination 2nd half','single cue','single cue'})
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',16)

saveas(gcf,[path,'\groupPlots\heading_precision.png']);
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Block-Experiment\heading_precision.svg');

%save data for statistical analysis
offset_precision_data_6_blocks = [offset_precision_6_blocks,(1:length(offset_precision_6_blocks))'];
heading_precision_data_6_blocks = [heading_precision_6_blocks,(1:length(heading_precision_6_blocks))'];
writematrix(offset_precision_data_6_blocks,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability\offset_precision_data_6_blocks.csv')
writematrix(heading_precision_data_6_blocks,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability\heading_precision_data_6_blocks.csv')

%% Combine plots of offset and heading precision

figure('Position',[100 100 800 1000]),
subplot(2,1,1)
plot(offset_precision','-o','color',[.5 .5 .5],'MarkerFaceColor',[.5 .5 .5]);
xlim([0 6]);
hold on
errorbar([1:5],nanmean(offset_precision),std(offset_precision)/sqrt(length(configuration)),'-ko','MarkerFaceColor','k','linewidth',3)
ylabel('Offset precision','fontsize',18);
ylim([0 1]);
xticks([1 2 3 4 5]);
xticklabels({})
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',16)

subplot(2,1,2)
plot(heading_precision','-o','color',[.5 .5 .5],'MarkerFaceColor',[.5 .5 .5]);
xlim([0 6]);
hold on
errorbar([1:5],nanmean(heading_precision),std(heading_precision)/sqrt(length(configuration)),'-ko','MarkerFaceColor','k','linewidth',3)
ylabel('Heading precision','fontsize',19);
ylim([0 1]);
xticks([1 2 3 4 5]);
xticklabels({'single cue','single cue','cue combination','single cue','single cue'})
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',16)

saveas(gcf,[path,'\groupPlots\offset_and_heading_precision.png']);
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Block-Experiment\offset_and_heading_precision.svg');

%Export data for statistics
offset_precision_data = [offset_precision,(1:length(offset_precision))'];
heading_precision_data = [heading_precision,(1:length(heading_precision))'];
writematrix(offset_precision_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability\offset_precision_data.csv')
writematrix(heading_precision_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability\heading_precision_data.csv')

%% Combine plots of offset and heading precision with 6 blocks

figure('Position',[100 100 800 1000]),
subplot(2,1,1)
plot(offset_precision_6_blocks','-o','color',[.5 .5 .5],'MarkerFaceColor',[.5 .5 .5]);
xlim([0 7]);
hold on
errorbar([1:6],nanmean(offset_precision_6_blocks),std(offset_precision_6_blocks)/sqrt(length(configuration)),'-ko','MarkerFaceColor','k','linewidth',3)
ylabel('Offset precision','fontsize',18);
ylim([0 1]);
xticks([1 2 3 4 5 6]);
xticklabels({})
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',16)

subplot(2,1,2)
plot(heading_precision_6_blocks','-o','color',[.5 .5 .5],'MarkerFaceColor',[.5 .5 .5]);
xlim([0 7]);
hold on
errorbar([1:6],nanmean(heading_precision_6_blocks),std(heading_precision_6_blocks)/sqrt(length(configuration)),'-ko','MarkerFaceColor','k','linewidth',3)
ylabel('Heading precision','fontsize',19);
ylim([0 1]);
xticks([1 2 3 4 5 6]);
xticklabels({'single cue','single cue','cue combination 1st half','cue combination 2nd half','single cue','single cue'})
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',16)

saveas(gcf,[path,'\groupPlots\offset_and_heading_precision_6_blocks.png']);
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Block-Experiment\offset_and_heading_precision_6_blocks.svg');

%% Plot thresholded bump parameters

figure('Position',[100 100 1400 1000]),
subplot(1,2,1)
plot(thresh_BM_mean','-o','color',[0.6 0.6 0.6],'MarkerFaceColor',[0.6 0.6 0.6]);
xlim([0 6]);
hold on
errorbar(1:5,nanmean(thresh_BM_mean),std(thresh_BM_mean)/sqrt(length(thresh_BM_mean)),'-ko','LineWidth',3,'MarkerFaceColor','k','MarkerSize',8)
xlabel('Block type','fontsize',20); xticks([1 2 3 4 5]);
xticklabels({'single cue','single cue','cue combination','single cue','single cue'})
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',18)
ylabel('Mean bump magnitude','fontsize',20);

subplot(1,2,2)
plot(thresh_BW_mean','-o','color',[0.6 0.6 0.6],'MarkerFaceColor',[0.6 0.6 0.6]);
xlim([0 6]);
hold on
errorbar(1:5,nanmean(thresh_BW_mean),std(thresh_BW_mean)/sqrt(length(thresh_BW_mean)),'-ko','LineWidth',3,'MarkerFaceColor','k','MarkerSize',8)
xlabel('Block type','fontsize',20); xticks([1 2 3 4 5]);
xticklabels({'single cue','single cue','cue combination','single cue','single cue'})
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',18)
ylabel('Mean bump width','fontsize',20);

saveas(gcf,[path,'\groupPlots\thresh_bump_parameters_evolution.png']);
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Block-Experiment\thresh_bump_parameters_evolution.svg');

%Export data for statistics
BM_mean = [thresh_BM_mean,(1:length(thresh_BM_mean))'];
BW_mean = [thresh_BW_mean,(1:length(thresh_BW_mean))'];
writematrix(BM_mean,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability\bump_mag_data.csv')
writematrix(BW_mean,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability\bump_width_data.csv')

%% Repeat averaging the single cue bouts

averaged_BM = zeros(length(thresh_BM_mean),3);
averaged_BM(:,1) = mean([thresh_BM_mean(:,1),thresh_BM_mean(:,2)],2);
averaged_BM(:,2) = thresh_BM_mean(:,3);
averaged_BM(:,3) = mean([thresh_BM_mean(:,4),thresh_BM_mean(:,5)],2);

averaged_BW = zeros(length(thresh_BW_mean),3);
averaged_BW(:,1) = mean([thresh_BW_mean(:,1),thresh_BW_mean(:,2)],2);
averaged_BW(:,2) = thresh_BW_mean(:,3);
averaged_BW(:,3) = mean([thresh_BW_mean(:,4),thresh_BW_mean(:,5)],2);

figure('Position',[100 100 1400 1000]),
subplot(1,2,1)
plot(averaged_BM','-o','color',[0.6 0.6 0.6],'MarkerFaceColor',[0.6 0.6 0.6]);
xlim([0 4]);
hold on
errorbar(1:3,nanmean(averaged_BM),std(averaged_BM)/sqrt(length(averaged_BM)),'-ko','LineWidth',3,'MarkerFaceColor','k','MarkerSize',8)
xlabel('Block type','fontsize',20); xticks([1 2 3 4 5]);
xticklabels({'single cue','cue combination','single cue'})
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',18)
ylabel('Mean bump magnitude','fontsize',20);

subplot(1,2,2)
plot(averaged_BW','-o','color',[0.6 0.6 0.6],'MarkerFaceColor',[0.6 0.6 0.6]);
xlim([0 4]);
hold on
errorbar(1:3,nanmean(averaged_BW),std(averaged_BW)/sqrt(length(averaged_BW)),'-ko','LineWidth',3,'MarkerFaceColor','k','MarkerSize',8)
xlabel('Block type','fontsize',20); xticks([1 2 3 4 5]);
xticklabels({'single cue','cue combination','single cue'})
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',18)
ylabel('Mean bump width','fontsize',20);

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Block-Experiment\thresh_bump_parameters_evolution_3_blocks.svg');

%Export data for statistics
BM_mean_3_blocks = [averaged_BM,(1:length(averaged_BM))'];
BW_mean_3_blocks = [averaged_BW,(1:length(averaged_BW))'];
writematrix(BM_mean_3_blocks,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability\bump_mag_data_3_blocks.csv')
writematrix(BW_mean_3_blocks,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability\bump_width_data_3_blocks.csv')

%% Plot zscored-bump parameters

zscored_BM = zscore(thresh_BM_mean,[],2);
zscored_BW = zscore(thresh_BW_mean,[],2);

figure('Position',[100 100 1200 1000]),
subplot(1,2,1)
plot(zscored_BM','-o','color',[.5 .5 .5]);
xlim([0 6]); xticks([1 2 3 4 5]);
hold on
plot(nanmean(zscored_BM),'-ko','linewidth',3,'MarkerFaceColor','k')
xticklabels({'single cue','single cue','cue combination','single cue','single cue'})
ylabel('Mean zscore','fontweight','bold','fontsize',14);
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',14,'FontWeight','bold')
title('Bump magnitude','fontsize',16);

subplot(1,2,2)
plot(zscored_BW','-o','color',[.5 .5 .5]);
xlim([0 6]); xticks([1 2 3 4 5]);
hold on
plot(nanmean(zscored_BW),'-ko','linewidth',3,'MarkerFaceColor','k')
xticklabels({'single cue','single cue','cue combination','single cue','single cue'})
ylabel('Mean zscore','fontweight','bold','fontsize',14);
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',14,'FontWeight','bold')
title('Bump width','fontsize',16);

saveas(gcf,[path,'\groupPlots\zscored_bump_parameters_evolution.png']);
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Block-Experiment\zscored_bump_parameters_evolution.svg');

%% Plot the distribution of cue offset differences with respect to the cue combination offset 

for fly = 1:length(data)
    single_cue_cc_diff_1(fly) = rad2deg(circ_dist(offset_mean(fly,3),offset_mean(fly,1)));
    single_cue_cc_diff_2(fly) = rad2deg(circ_dist(offset_mean(fly,3),offset_mean(fly,2)));
end

%As line plot
figure('Position',[100 100 1000 800]),
plot([abs(single_cue_cc_diff_1);abs(single_cue_cc_diff_2)],'-o','color',[0.6 0.6 0.6],'MarkerFaceColor',[0.6 0.6 0.6])
hold on
errorbar([1 2],[mean(abs(single_cue_cc_diff_1));mean(abs(single_cue_cc_diff_2))],[std(abs(single_cue_cc_diff_1))/sqrt(length(single_cue_cc_diff_1));std(abs(single_cue_cc_diff_2))/sqrt(length(single_cue_cc_diff_2))],'-ko','LineWidth',3,'MarkerFaceColor','k','MarkerSize',8)
xlim([0 3]);
xticks([1 2]);
xticklabels({'First cue','Second cue'});
ylabel('Cue combination offset - single cue offset (deg)','fontsize',20);
a = get(gca,'YTickLabel');
set(gca,'YTickLabel',a,'fontsize',18);
yticks([0:30:180]);
yticklabels({'0','30','60','90','120','150','180'});

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Block-Experiment\single_cue_cc_offset_diff.svg');

%save data for statistical analysis
cue_order_data = [abs(single_cue_cc_diff_1)',abs(single_cue_cc_diff_2)'];
writematrix(cue_order_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability\cue_order_data.csv');

%% Repeat plotting similarity instead of difference

single_cue_cc_sim_1 = 180 - abs(single_cue_cc_diff_1);
single_cue_cc_sim_2 = 180 - abs(single_cue_cc_diff_2);

%As line plot
figure('Position',[100 100 1000 800]),
plot([single_cue_cc_sim_1;single_cue_cc_sim_2],'-o','color',[0.6 0.6 0.6],'MarkerFaceColor',[0.6 0.6 0.6])
hold on
errorbar([1 2],[mean(single_cue_cc_sim_1);mean(single_cue_cc_sim_2)],[std(single_cue_cc_sim_1)/sqrt(length(single_cue_cc_diff_1));std(single_cue_cc_sim_2)/sqrt(length(single_cue_cc_diff_2))],'-ko','LineWidth',3,'MarkerFaceColor','k','MarkerSize',8)
xlim([0 3]);
xticks([1 2]);
xticklabels({'First cue','Second cue'});
ylabel({'Similarity between cue combination and';'single cue offset (deg)'},'fontsize',20);
a = get(gca,'YTickLabel');
set(gca,'YTickLabel',a,'fontsize',18);
yticks([0:30:180]);
yticklabels({'0','30','60','90','120','150','180'});

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Block-Experiment\single_cue_cc_offset_sim.svg');


%% Repeat color-coding by cue type

figure('Position',[100 100 1000 800]),
plot([single_cue_cc_sim_1(configuration == 1);single_cue_cc_sim_2(configuration == 1)],'-ro','MarkerFaceColor','r')
hold on
plot([single_cue_cc_sim_1(configuration == 2);single_cue_cc_sim_2(configuration == 2)],'-bo','MarkerFaceColor','b')
errorbar([1 2],[mean(single_cue_cc_sim_1);mean(single_cue_cc_sim_2)],[std(single_cue_cc_sim_1)/sqrt(length(single_cue_cc_diff_1));std(single_cue_cc_sim_2)/sqrt(length(single_cue_cc_diff_2))],'-ko','LineWidth',3,'MarkerFaceColor','k','MarkerSize',8)
xlim([0 3]);
xticks([1 2]);
xticklabels({'First cue','Second cue'});
ylabel({'Similarity between cue combination and';'single cue offset (deg)'},'fontsize',20);
a = get(gca,'YTickLabel');
set(gca,'YTickLabel',a,'fontsize',18);
yticks([0:30:180]);
yticklabels({'0','30','60','90','120','150','180'});

%% Cue plasticity vs size of conflict

for fly = 1:length(data)
    
    single_cue_diff_1(fly) = rad2deg(circ_dist(offset_mean(fly,4),offset_mean(fly,1)));
    single_cue_diff_2(fly) = rad2deg(circ_dist(offset_mean(fly,5),offset_mean(fly,2)));
    
    if offset_precision(fly,1) < 0.3 | offset_precision(fly,4) < 0.3 %I decided on the offset precision threshold looking at the individual data
        single_cue_diff_1_thresh(fly) = NaN;
    else
        single_cue_diff_1_thresh(fly) = rad2deg(circ_dist(offset_mean(fly,4),offset_mean(fly,1)));
    end
    if offset_precision(fly,2) < 0.3 | offset_precision(fly,5) < 0.3
        single_cue_diff_2_thresh(fly) = NaN;
    else
        single_cue_diff_2_thresh(fly) = rad2deg(circ_dist(offset_mean(fly,5),offset_mean(fly,2)));
    end
    
end


%Plot
figure('Position',[100 100 1000 1000]),

plot(single_cue_cc_diff_1,single_cue_diff_1,'ro', 'MarkerFaceColor','r','MarkerSize',8)
hold on
plot(single_cue_cc_diff_1,single_cue_diff_1+360,'ro', 'MarkerFaceColor','r','MarkerSize',8)
plot(single_cue_cc_diff_2,single_cue_diff_2,'ro', 'MarkerFaceColor','r','MarkerSize',8)
plot(single_cue_cc_diff_2,single_cue_diff_2+360,'ro', 'MarkerFaceColor','r','MarkerSize',8)

%add thresholded categories
plot(single_cue_cc_diff_1,single_cue_diff_1_thresh,'ko', 'MarkerFaceColor','k','MarkerSize',8)
plot(single_cue_cc_diff_1,single_cue_diff_1_thresh+360,'ko', 'MarkerFaceColor','k','MarkerSize',8)
plot(single_cue_cc_diff_2,single_cue_diff_2_thresh,'ko', 'MarkerFaceColor','k','MarkerSize',8)
plot(single_cue_cc_diff_2,single_cue_diff_2_thresh+360,'ko', 'MarkerFaceColor','k','MarkerSize',8)


ylabel({'Post - pre (deg)'},'fontweight','bold','fontsize',14);
xlabel({'Training - pre (deg)'},'fontweight','bold','fontsize',14);
xticks([-180 -90 0 90 180]);
xticklabels({'-180','-90','0','90','180'});
yticks([-180 0 180 360 540]);
yticklabels({'-180','0','180','360','540'});
xlim([-180 180]); ylim([-180 540]);
refline(1,0);
refline(1,360);
a = get(gca,'YTickLabel');
set(gca,'YTickLabel',a,'fontsize',12);

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Block-Experiment\plasticity_scales_with_conflict.svg');

%% Save data for statistical analysis

%group data
all_single_cue_cc_diff = [single_cue_cc_diff_1,single_cue_cc_diff_2];
all_single_cue_diff = [single_cue_diff_1,single_cue_diff_2];

%group thresholded data
all_single_cue_cc_diff_thresh = [single_cue_cc_diff_1(~isnan(single_cue_diff_1_thresh)),single_cue_cc_diff_2(~isnan(single_cue_diff_2_thresh))];
all_single_cue_diff_thresh = [single_cue_diff_1_thresh(~isnan(single_cue_diff_1_thresh)),single_cue_diff_2_thresh(~isnan(single_cue_diff_2_thresh))];

plasticity_data = table(all_single_cue_cc_diff',all_single_cue_diff','VariableNames',{'Conflict','Plasticity'});
plasticity_data_thresh = table(all_single_cue_cc_diff_thresh',all_single_cue_diff_thresh','VariableNames',{'Conflict','Plasticity'});

writetable(plasticity_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability\plasticity_data.csv')
writetable(plasticity_data_thresh,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability\plasticity_data_thresh.csv')


%% Total movement per block

for fly = 1:length(data)
    
    for block = 1:5
        
        t_mvt(fly,block) = nanmean(data(fly).summary_data.TotalMvt(data(fly).summary_data.BlockType == block));
    
    end
    
end

figure,
plot(t_mvt','color',[.6 .6 .6])
hold on
errorbar([1:5],mean(t_mvt),std(t_mvt)/sqrt(length(t_mvt)),'-k','LineWidth',3)
xlim([0 6]);
xticks([1:5]);
xticklabels({'single cue','single cue','cue combination','single cue','single cue'})
ylabel('Total movement (deg/s)');

saveas(gcf,[path,'\groupPlots\total_mvt_per_block.png']);

%% Angular speed per block

for fly = 1:length(data)
    
    for block = 1:5
        
        yaw_speed(fly,block) = nanmean(data(fly).summary_data.YawSpeed(data(fly).summary_data.BlockType == block));
    
    end
    
end

figure,
plot(yaw_speed','color',[.6 .6 .6])
hold on
errorbar([1:5],mean(yaw_speed),std(yaw_speed)/sqrt(length(yaw_speed)),'-k','LineWidth',3)
xlim([0 6]);
xticks([1:5]);
xticklabels({'single cue','single cue','cue combination','single cue','single cue'})
ylabel('Yaw speed (deg/s)');

saveas(gcf,[path,'\groupPlots\angular_speed_per_block.png']);

%% Forward vel per block

for fly = 1:length(data)
    
    for block = 1:5
        
        for_vel(fly,block) = nanmean(data(fly).summary_data.ForVel(data(fly).summary_data.BlockType == block));
    
    end
    
end

figure,
plot(for_vel','color',[.6 .6 .6])
hold on
errorbar([1:5],mean(for_vel),std(for_vel)/sqrt(length(for_vel)),'-k','LineWidth',3)
xlim([0 6]);
xticks([1:5]);
xticklabels({'single cue','single cue','cue combination','single cue','single cue'})
ylabel('For vel (mm/s)');

saveas(gcf,[path,'\groupPlots\for_vel_per_block.png']);

%% Probability of stopping per block

for fly = 1:length(data)
    
    for block = 1:5
        
        p_stopping(fly,block) = sum(data(fly).summary_data.TotalMvt(data(fly).summary_data.BlockType == block)<25)/length(data(fly).summary_data.TotalMvt(data(fly).summary_data.BlockType == block));
    
    end
    
end

figure,
plot(p_stopping','color',[.6 .6 .6])
hold on
errorbar([1:5],mean(p_stopping),std(p_stopping)/sqrt(length(p_stopping)),'-k','LineWidth',3)
xlim([0 6]);
xticks([1:5]);
xticklabels({'single cue','single cue','cue combination','single cue','single cue'})
ylabel('P stopping');

saveas(gcf,[path,'\groupPlots\p_stopping_per_block.png']);

%% Heading evolution (look at individual examples and then a plasticity metric of sorts?)

%1) Difference in heading between consecutive blocks

for fly = 1:length(data)
    for block = 1:4
        diff_heading(fly,block) = abs(circ_dist(data(fly).heading_mean(block),data(fly).heading_mean(block + 1)));
    end
end

figure,
plot(rad2deg(diff_heading'),'color',[.6 .6 .6])
hold on
plot(mean(rad2deg(diff_heading)),'-k','linewidth',2)
ylabel('Heading difference');
xlim([0 5]);
xticks([1:4]);
saveas(gcf,[path,'\groupPlots\diff_heading.png']);


%% 2) Plot similarity between cc block and single cue blocks

for fly = 1:length(data)
    single_cue_cc_heading_diff_1(fly) = rad2deg(circ_dist(heading_mean(fly,3),heading_mean(fly,1)));
    single_cue_cc_heading_diff_2(fly) = rad2deg(circ_dist(heading_mean(fly,3),heading_mean(fly,2)));
end
single_cue_cc_heading_sim_1 = 180 - abs(single_cue_cc_heading_diff_1);
single_cue_cc_heading_sim_2 = 180 - abs(single_cue_cc_heading_diff_2);

%As line plot
figure('Position',[100 100 1000 800]),
plot([single_cue_cc_heading_sim_1;single_cue_cc_heading_sim_2],'-o','color',[0.6 0.6 0.6],'MarkerFaceColor',[0.6 0.6 0.6])
hold on
errorbar([1 2],[mean(single_cue_cc_heading_sim_1);mean(single_cue_cc_heading_sim_2)],[std(single_cue_cc_heading_sim_1)/sqrt(length(single_cue_cc_heading_diff_1));std(single_cue_cc_heading_sim_2)/sqrt(length(single_cue_cc_heading_diff_2))],'-ko','LineWidth',3,'MarkerFaceColor','k','MarkerSize',8)
xlim([0 3]);
xticks([1 2]);
xticklabels({'First cue','Second cue'});
ylabel({'Similarity between cue combination and';'single cue heading (deg)'},'fontsize',20);
a = get(gca,'YTickLabel');
set(gca,'YTickLabel',a,'fontsize',18);
yticks([0:30:180]);
yticklabels({'0','30','60','90','120','150','180'});

saveas(gcf,[path,'\groupPlots\heading_similarity.png']);


%% Repeat color-coding by cue type

figure('Position',[100 100 1000 800]),
plot([single_cue_cc_heading_sim_1(configuration == 1);single_cue_cc_heading_sim_2(configuration == 1)],'-ro','MarkerFaceColor','r')
hold on
plot([single_cue_cc_heading_sim_1(configuration == 2);single_cue_cc_heading_sim_2(configuration == 2)],'-bo','MarkerFaceColor','b')
errorbar([1 2],[mean(single_cue_cc_heading_sim_1);mean(single_cue_cc_heading_sim_2)],[std(single_cue_cc_heading_sim_1)/sqrt(length(single_cue_cc_heading_diff_1));std(single_cue_cc_heading_sim_2)/sqrt(length(single_cue_cc_heading_diff_2))],'-ko','LineWidth',3,'MarkerFaceColor','k','MarkerSize',8)
xlim([0 3]);
xticks([1 2]);
xticklabels({'First cue','Second cue'});
ylabel({'Similarity between cue combination and';'single cue offset (deg)'},'fontsize',20);
a = get(gca,'YTickLabel');
set(gca,'YTickLabel',a,'fontsize',18);
yticks([0:30:180]);
yticklabels({'0','30','60','90','120','150','180'});


%% 3) Heading plasticity
for fly = 1:length(data)
    
    single_cue_heading_diff_1(fly) = rad2deg(circ_dist(heading_mean(fly,4),heading_mean(fly,1)));
    single_cue_heading_diff_2(fly) = rad2deg(circ_dist(heading_mean(fly,5),heading_mean(fly,2)));
    
    if heading_precision(fly,1) < 0.3 | heading_precision(fly,4) < 0.3 %I decided on the heading precision threshold looking at the individual data
        single_cue_heading_diff_1_thresh(fly) = NaN;
    else
        single_cue_heading_diff_1_thresh(fly) = rad2deg(circ_dist(heading_mean(fly,4),heading_mean(fly,1)));
    end
    if heading_precision(fly,2) < 0.3 | heading_precision(fly,5) < 0.3
        single_cue_heading_diff_2_thresh(fly) = NaN;
    else
        single_cue_heading_diff_2_thresh(fly) = rad2deg(circ_dist(heading_mean(fly,5),heading_mean(fly,2)));
    end
    
end


%Plot
figure('Position',[100 100 1000 1000]),

plot(single_cue_cc_heading_diff_1,single_cue_heading_diff_1,'ro', 'MarkerFaceColor','r','MarkerSize',8)
hold on
plot(single_cue_cc_heading_diff_1,single_cue_heading_diff_1+360,'ro', 'MarkerFaceColor','r','MarkerSize',8)
plot(single_cue_cc_heading_diff_2,single_cue_heading_diff_2,'ro', 'MarkerFaceColor','r','MarkerSize',8)
plot(single_cue_cc_heading_diff_2,single_cue_heading_diff_2+360,'ro', 'MarkerFaceColor','r','MarkerSize',8)

%add thresholded categories
plot(single_cue_cc_heading_diff_1,single_cue_heading_diff_1_thresh,'ko', 'MarkerFaceColor','k','MarkerSize',8)
plot(single_cue_cc_heading_diff_1,single_cue_heading_diff_1_thresh+360,'ko', 'MarkerFaceColor','k','MarkerSize',8)
plot(single_cue_cc_heading_diff_2,single_cue_heading_diff_2_thresh,'ko', 'MarkerFaceColor','k','MarkerSize',8)
plot(single_cue_cc_heading_diff_2,single_cue_heading_diff_2_thresh+360,'ko', 'MarkerFaceColor','k','MarkerSize',8)

ylabel({'Post - pre (deg)'},'fontweight','bold','fontsize',14);
xlabel({'Training - pre (deg)'},'fontweight','bold','fontsize',14);
xticks([-180 -90 0 90 180]);
xticklabels({'-180','-90','0','90','180'});
yticks([-180 0 180 360 540]);
yticklabels({'-180','0','180','360','540'});
xlim([-180 180]); ylim([-180 540]);
refline(1,0);
refline(1,360);
a = get(gca,'YTickLabel');
set(gca,'YTickLabel',a,'fontsize',12);

saveas(gcf,[path,'\groupPlots\heading_plasticity.png']);

%% Compare initial offset precision bar and wind

offset_precision_bar = [];
offset_precision_wind = [];
for fly = 1:length(data)
    if configuration(fly) == 1
        offset_precision_bar(fly) = offset_precision(fly,1);
        offset_precision_wind(fly) = offset_precision(fly,2);
    else
        offset_precision_bar(fly) = offset_precision(fly,2);
        offset_precision_wind(fly) = offset_precision(fly,1);
    end
end

all_initial_offset_precision = [offset_precision_bar,offset_precision_wind];
block_type = [repelem(1,1,length(offset_precision_bar)),repelem(2,1,length(offset_precision_wind))];
fly_num = [1:length(offset_precision_bar),1:length(offset_precision_wind)];
initial_offset_precision_data = table(all_initial_offset_precision',block_type',fly_num','VariableNames',{'offset_precision','block_type','fly_num'});
writetable(initial_offset_precision_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability\initial_offset_precision_data.csv')

%% Clear space

close all; clear all;