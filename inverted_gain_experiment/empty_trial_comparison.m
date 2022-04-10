%code to compare the inverted gain portion to the empty trial to see how
%the heading or bar offset is much more stable during the inverted gain
%portion

clear all; close all;

%% Load data

%list all of the folders in the directory
folderNames = dir('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data');

%initialize necessary empty arrays
gain_change_offset_var = [];
gain_change_offset_precision = [];
gain_change_heading_precision = [];
gain_change_offset_precision_first_q = [];
gain_change_heading_precision_first_q = [];
gain_change_offset_precision_granular = NaN(length(folderNames),8);
gain_change_heading_precision_granular = NaN(length(folderNames),8);

empty_offset_var = [];
empty_offset_precision = [];
empty_offset_precision_first_half = [];
empty_offset_precision_second_half = [];
empty_heading_precision = [];
empty_heading_precision_first_half = [];
empty_heading_precision_second_half = [];
empty_rot_speed = [];
initial_normal_gain_rot_speed = [];
final_normal_gain_rot_speed = [];
inverted_gain_rot_speed = [];

%for the fly folders
for folder = 1:length(folderNames)
    if (contains(folderNames(folder).name,'60D05')==1 & contains(folderNames(folder).name,'20210127')==0 & contains(folderNames(folder).name,'20210218_60D05_7f_fly2')==0) %I'm excluding these two flies because I didn't run a darkness trial for them
        
        path = [folderNames(folder).folder,'\',folderNames(folder).name];
        %get the sessions info
        load([path,'\sessions_info.mat'])
        
        %load the empty trial and inverted gain trial data
        empty_trial = load([path,'\analysis\continuous_analysis_sid_',num2str(sessions_info.empty_trial),'_tid_0.mat']);
        gain_change = load([path,'\analysis\continuous_analysis_sid_',num2str(sessions_info.gain_change),'_tid_0.mat']);
        
        %load info about whether this is a type 1 or type 2 fly, to know which
        %offset to compare to
        load([path,'\analysis\gain_change_data.mat'])
        
        % Compute mean offset precision during the inverted gain period
        %get hdf5 files in directory
        file_names = dir(fullfile([path,'\ball\'],'*hdf5'));
        for file = 1:length(file_names)
            if contains(file_names(file).name,['sid_',num2str(sessions_info.gain_change),'_'])
                hdf5_file_to_read = fullfile(file_names(file).folder,file_names(file).name);
            end
        end       
        gain_yaw = double(h5read(hdf5_file_to_read,'/gain_yaw'));
        %downsample to match data length
        gain_yaw_ds = resample(gain_yaw,length(gain_change.continuous_data.time),length(gain_yaw));
        gain_yaw_ds(gain_yaw_ds<0) = -1;
        gain_yaw_ds(gain_yaw_ds>0) = 1;        
        %determine gain changes
        gain_changes = find(abs(diff(gain_yaw_ds))>0.5);
        gain_changes = gain_changes(1:2);
        
        % Set block limits      
        blockLimits{1} = [1,gain_changes(1)-1];
        blockLimits{2} = [gain_changes(1),gain_changes(2)];
        blockLimits{3} = [gain_changes(2)+1,length(gain_change.continuous_data.time)];
        
        
        % Set conversion factor
        sec_to_frames = (blockLimits{2}(2) - blockLimits{2}(1))/800;
        
        %get parameters for empty trial
        empty_trial_heading_offset = circ_dist(-empty_trial.continuous_data.heading,empty_trial.continuous_data.bump_pos');
        [var empty_trial_offset_var] = circ_std(empty_trial_heading_offset);
        empty_trial_moving = empty_trial.continuous_data.total_mvt_ds > 25;
        empty_trial_offset_precision = circ_r(empty_trial_heading_offset(empty_trial_moving));
        empty_offset_precision = [empty_offset_precision,empty_trial_offset_precision];
        half_empty_trial = floor(length(empty_trial_heading_offset)/2);
        empty_trial_offset_precision_first_half = circ_r(empty_trial_heading_offset(1:half_empty_trial));
        empty_trial_offset_precision_second_half = circ_r(empty_trial_heading_offset(half_empty_trial+1:end));        
        empty_offset_var = [empty_offset_var,empty_trial_offset_var];        
        empty_offset_precision_first_half = [empty_offset_precision_first_half,empty_trial_offset_precision_first_half]; 
        empty_offset_precision_second_half = [empty_offset_precision_second_half,empty_trial_offset_precision_second_half];         
        empty_trial_heading_precision = circ_r(empty_trial.continuous_data.heading(empty_trial_moving));
        empty_heading_precision = [empty_heading_precision,empty_trial_heading_precision];        
        empty_trial_heading_precision_first_half = circ_r(empty_trial.continuous_data.heading(1:half_empty_trial));
        empty_trial_heading_precision_second_half = circ_r(empty_trial.continuous_data.heading(half_empty_trial+1:end));        
        empty_heading_precision_first_half = [empty_heading_precision_first_half,empty_trial_heading_precision_first_half];
        empty_heading_precision_second_half = [empty_heading_precision_second_half,empty_trial_heading_precision_second_half];        
        empty_trial_rot_speed = nanmean(abs(empty_trial.continuous_data.vel_yaw_ds));
        empty_rot_speed = [empty_rot_speed,empty_trial_rot_speed];
        
        %gain change rot speed
        initial_normal_gain_rot_speed_trial = nanmean(abs(gain_change.continuous_data.vel_yaw_ds(1:gain_changes(1))));
        final_normal_gain_rot_speed_trial = nanmean(abs(gain_change.continuous_data.vel_yaw_ds(gain_changes(2):end)));
        inverted_gain_rot_speed_trial = nanmean(abs(gain_change.continuous_data.vel_yaw_ds(gain_changes(1):gain_changes(2))));
        initial_normal_gain_rot_speed = [initial_normal_gain_rot_speed,initial_normal_gain_rot_speed_trial];
        final_normal_gain_rot_speed = [final_normal_gain_rot_speed,final_normal_gain_rot_speed_trial];        
        inverted_gain_rot_speed = [inverted_gain_rot_speed,inverted_gain_rot_speed_trial];
        
        %last quarter of gain change
        gain_change_heading_offset = circ_dist(-gain_change.continuous_data.heading,gain_change.continuous_data.bump_pos');
        ig_heading_offset = gain_change_heading_offset(blockLimits{2}(2)-length(empty_trial_heading_offset):blockLimits{2}(2));
        gain_change_movement = gain_change.continuous_data.total_mvt_ds((blockLimits{2}(2)-length(empty_trial_heading_offset):blockLimits{2}(2)));
        ig_moving = gain_change_movement > 25;
        [var gain_change_trial_offset_var] = circ_std(gain_change_heading_offset(blockLimits{2}(2)-length(empty_trial_heading_offset):blockLimits{2}(2)));
        gain_change_trial_offset_precision = circ_r(ig_heading_offset(ig_moving));        
        gain_change_offset_precision = [gain_change_offset_precision,gain_change_trial_offset_precision];
        ig_heading = gain_change.continuous_data.heading(blockLimits{2}(2)-length(empty_trial_heading_offset):blockLimits{2}(2));
        gain_change_trial_heading_precision = circ_r(ig_heading(ig_moving));
        gain_change_heading_precision = [gain_change_heading_precision,gain_change_trial_heading_precision];
        
        %first quarter of gain change
        ig_heading_offset_final = gain_change_heading_offset(blockLimits{2}(1):blockLimits{2}(1)+length(empty_trial_heading_offset));
        ig_movement_final = gain_change.continuous_data.total_mvt_ds(blockLimits{2}(1):blockLimits{2}(1)+length(empty_trial_heading_offset));
        ig_moving_final = ig_movement_final > 25;
        gain_change_trial_offset_precision_first_q = circ_r(ig_heading_offset_final(ig_moving_final));        
        gain_change_offset_precision_first_q = [gain_change_offset_precision_first_q,gain_change_trial_offset_precision_first_q];
        ig_heading_final = gain_change.continuous_data.heading(blockLimits{2}(1):blockLimits{2}(1)+length(empty_trial_heading_offset));
        gain_change_trial_heading_precision_first_q = circ_r(ig_heading_final(ig_moving_final));
        gain_change_heading_precision_first_q = [gain_change_heading_precision_first_q,gain_change_trial_heading_precision_first_q];
   
        %dividing into 100 sec windows
        for block = 1:8
            inverted_gain_heading_offset = gain_change_heading_offset(blockLimits{2}(1):blockLimits{2}(2));
            gain_change_offset_precision_granular(folder,block) = circ_r(inverted_gain_heading_offset(1+100*sec_to_frames*(block-1):100+100*sec_to_frames*(block-1)));
            inverted_gain_heading = gain_change.continuous_data.heading(blockLimits{2}(1):blockLimits{2}(2));
            gain_change_heading_precision_granular(folder,block) = circ_r(inverted_gain_heading(1+100*sec_to_frames*(block-1):100+100*sec_to_frames*(block-1)));
        end
            
    end
    
end

gain_change_offset_precision_granular(any(isnan(gain_change_offset_precision_granular), 2), :) = [];
gain_change_heading_precision_granular(any(isnan(gain_change_heading_precision_granular), 2), :) = [];

%% Rot speed per block

all_rot_speed = [initial_normal_gain_rot_speed;inverted_gain_rot_speed;final_normal_gain_rot_speed;empty_rot_speed];

figure,
plot(all_rot_speed,'color',[.6 .6 .6])
hold on
plot(mean(all_rot_speed'),'k','linewidth',2)
xlim([0 5]);
xticks([1:4]);
xticklabels({'NG','IG','NG','Empty'});
ylabel('Mean rotational speed (deg/s)');

%% Plot heading offset precision (using last quarter data)

allData = [empty_offset_precision',gain_change_offset_precision'];

%plot
figure('Position',[100 100 800 800]),
plot(allData','color',[.5 .5 .5])
hold on
errorbar(mean(allData),std(allData)/length(empty_offset_precision),'-ko','markerfacecolor','k','linewidth',2)
xlim([0 3]);
ylim([0 1]);
xticks([1 2])
xticklabels({'Empty trial', 'Gain change trial'})
ylabel('Heading offset precision','fontsize',20);
yticks([0:0.5:1]);
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',18)

%save figure
saveas(gcf,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\groupPlots\empty_trial_offset_comparison.png');
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\InvertedGain-Experiment\empty_trial_offset_comparison.svg');

%save data for statistical analysis in R
empty_trial_comparison_data = table(empty_offset_precision',gain_change_offset_precision','VariableNames',{'empty_trial_offset_precision','gain_change_offset_precision'});
writetable(empty_trial_comparison_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\empty_trial_comparison_data.csv')


%% Plot heading precision (using last quarter data)

allHeadingData = [empty_heading_precision',gain_change_heading_precision'];

%plot
figure('Position',[100 100 800 800]),
plot(allHeadingData','color',[.5 .5 .5])
hold on
errorbar(mean(allHeadingData),std(allHeadingData)/length(empty_heading_precision),'-ko','markerfacecolor','k','linewidth',2)
xlim([0 3]);
ylim([0 1]);
xticks([1 2])
xticklabels({'Empty trial', 'Gain change trial'})
ylabel('Heading precision','fontsize',20);
yticks([0:0.5:1]);
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',18)

%save figure
saveas(gcf,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\groupPlots\empty_trial_heading_comparison.png');
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\InvertedGain-Experiment\empty_trial_heading_comparison.svg');

%save data for statistical analysis in R
empty_trial_heading_comparison_data = table(empty_heading_precision',gain_change_heading_precision','VariableNames',{'empty_trial_heading_precision','gain_change_heading_precision'});
writetable(empty_trial_heading_comparison_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\empty_trial_heading_comparison_data.csv')


%% Plot heading offset precision using first quarter data

allData_first_q = [empty_offset_precision',gain_change_offset_precision_first_q'];

%plot
figure('Position',[100 100 800 800]),
plot(allData_first_q','color',[.5 .5 .5])
hold on
errorbar(mean(allData_first_q),std(allData_first_q)/length(empty_offset_precision),'-ko','markerfacecolor','k','linewidth',2)
xlim([0 3]);
ylim([0 1]);
xticks([1 2])
xticklabels({'Empty trial', 'Gain change trial'})
ylabel('Heading offset precision (first quarter)','fontsize',20);
yticks([0:0.5:1]);
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',18)

%save figure
saveas(gcf,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\groupPlots\empty_trial_offset_comparison_first_q.png');
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\InvertedGain-Experiment\empty_trial_offset_comparison_first_q.svg');

%save data for statistical analysis in R
empty_trial_comparison_data_first_q = table(empty_offset_precision',gain_change_offset_precision_first_q','VariableNames',{'empty_trial_offset_precision','gain_change_offset_precision'});
writetable(empty_trial_comparison_data_first_q,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\empty_trial_comparison_data_first_q.csv')



%% Plot heading precision (using first quarter data)

allHeadingData_first_q = [empty_heading_precision',gain_change_heading_precision_first_q'];

%plot
figure('Position',[100 100 800 800]),
plot(allHeadingData_first_q','color',[.5 .5 .5])
hold on
errorbar(mean(allHeadingData_first_q),std(allHeadingData_first_q)/length(empty_heading_precision),'-ko','markerfacecolor','k','linewidth',2)
xlim([0 3]);
ylim([0 1]);
xticks([1 2])
xticklabels({'Empty trial', 'Gain change trial'})
ylabel('Heading precision (first quarter)','fontsize',20);
yticks([0:0.5:1]);
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',18)

%save figure
saveas(gcf,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\groupPlots\empty_trial_heading_comparison_first_q.png');
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\InvertedGain-Experiment\empty_trial_heading_comparison_first_q.svg');

%save data for statistical analysis in R
empty_trial_heading_comparison_data_first_q = table(empty_heading_precision',gain_change_heading_precision_first_q','VariableNames',{'empty_trial_heading_precision','gain_change_heading_precision'});
writetable(empty_trial_heading_comparison_data_first_q,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\empty_trial_heading_comparison_data_first_q.csv')


%% Combine first and last quarter heading offset precision data in a single plot

all_heading_offset_precison_data = [empty_offset_precision',gain_change_offset_precision_first_q',gain_change_offset_precision'];

%plot
figure('Position',[100 100 800 800]),
plot(all_heading_offset_precison_data','color',[.6 .6 .6])
hold on
errorbar(mean(all_heading_offset_precison_data),std(all_heading_offset_precison_data)/length(empty_offset_precision),'-ko','markerfacecolor','k','linewidth',2)
xlim([0 4]);
ylim([0 1]);
xticks([1:3])
xticklabels({'Empty trial', 'Gain change trial (initial part)', 'Gain change trial (final part)'})
ylabel('Heading offset precision','fontsize',20);
yticks([0:0.5:1]);
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',18)

%save figure
saveas(gcf,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\groupPlots\empty_trial_offset_comparison_all_data.png');
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\InvertedGain-Experiment\empty_trial_offset_comparison_all_data.svg');

%save data for statistical analysis in R
empty_trial_comparison_all_data = table(empty_offset_precision',gain_change_offset_precision_first_q',gain_change_offset_precision','VariableNames',{'empty_trial_offset_precision','initial_gain_change_offset_precision','final_gain_change_offset_precision'});
writetable(empty_trial_comparison_all_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\empty_trial_comparison_all_data.csv')

%% Repeat for heading precision

all_heading_precison_data = [empty_heading_precision',gain_change_heading_precision_first_q',gain_change_heading_precision'];

%plot
figure('Position',[100 100 800 800]),
plot(all_heading_precison_data','color',[.6 .6 .6])
hold on
errorbar(mean(all_heading_precison_data),std(all_heading_precison_data)/length(empty_offset_precision),'-ko','markerfacecolor','k','linewidth',2)
xlim([0 4]);
ylim([0 1]);
xticks([1:3])
xticklabels({'Empty trial', 'Gain change trial (initial part)', 'Gain change trial (final part)'})
ylabel('Heading precision','fontsize',20);
yticks([0:0.5:1]);
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',18)

%save figure
saveas(gcf,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\groupPlots\empty_trial_heading_comparison_all_data.png');
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\InvertedGain-Experiment\empty_trial_heading_comparison_all_data.svg');

%save data for statistical analysis in R
empty_trial_heading_comparison_all_data = table(empty_heading_precision',gain_change_heading_precision_first_q',gain_change_heading_precision','VariableNames',{'empty_trial_heading_precision','initial_gain_change_heading_precision','final_gain_change_heading_precision'});
writetable(empty_trial_heading_comparison_all_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\empty_trial_heading_comparison_all_data.csv')

%% Adding more granularity to the analysis

all_heading_offset = [empty_offset_precision_first_half;empty_offset_precision_second_half;gain_change_offset_precision_granular'];

figure,
plot(all_heading_offset,'color',[.6 .6 .6])
hold on
plot(mean(all_heading_offset'),'-ko','linewidth',2)
xticks(1:10);
xticklabels({'initial empty trial','final empty trial','block 1 IG','block 2 IG', 'block 3 IG', 'block 4 IG','block 5 IG','block 6 IG', 'block 7 IG', 'block 8 IG'}); 
xlim([0 11]);
ylabel('Heading offset precision');

all_heading = [empty_heading_precision_first_half;empty_heading_precision_second_half;gain_change_heading_precision_granular'];

figure,
plot(all_heading,'color',[.6 .6 .6])
hold on
plot(mean(all_heading'),'-ko','linewidth',2)
xticks(1:10);
xticklabels({'initial empty trial','final empty trial','block 1 IG','block 2 IG', 'block 3 IG', 'block 4 IG','block 5 IG','block 6 IG', 'block 7 IG', 'block 8 IG'}); 
xlim([0 11]);
ylabel('Heading precision');


%% Clear space

clear all; close all;