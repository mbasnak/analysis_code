%Code to analyze the results across flies, using the continuous dff method

%Clean workspace
clear all; close all;

%% Import data

%Define main directory
exp_dir = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\GCaMP_control\data';

%List all the folders
folderNames = dir(exp_dir);

for folder = 1:length(folderNames)
    if contains(folderNames(folder).name,'60D05')
        load(fullfile(folderNames(folder).folder,folderNames(folder).name,'analysis\open_loop_data.mat'));
        summary_data{folder} = summarydata;
        flyID = repelem(folder,1,size(summarydata,1));
        summary_data{folder} = addvars(summary_data{folder},flyID');
    end
end

%Remove empty cells
summary_data = summary_data(~cellfun('isempty',summary_data));
all_data = table;
for fly = 1:length(summary_data)
    all_data = [all_data;summary_data{fly}];
end
all_data.Properties.VariableNames{'Var10'} = 'Fly';

%Sort by stimulus velocity
all_data = sortrows(all_data,{'Fly','stim_vel'},{'ascend','ascend'});
%Average data with same stimulus speed
all_data = varfun(@nanmean,all_data,'InputVariables',{'offset_var','offset_var_thresh','offset_precision','bump_mag','bump_mag_thresh','bump_width','bump_width_thresh','total_mvt'},...
       'GroupingVariables',{'stim_vel','Fly'});

mean_offset_precision = varfun(@mean,all_data,'InputVariables','nanmean_offset_precision',...
       'GroupingVariables',{'stim_vel'});
mean_bm_data = varfun(@mean,all_data,'InputVariables','nanmean_bump_mag',...
       'GroupingVariables',{'stim_vel'});
mean_bm_data_thresh = varfun(@mean,all_data,'InputVariables','nanmean_bump_mag_thresh',...
       'GroupingVariables',{'stim_vel'});
mean_bw_data = varfun(@mean,all_data,'InputVariables','nanmean_bump_width',...
       'GroupingVariables',{'stim_vel'});
mean_bw_data_thresh = varfun(@mean,all_data,'InputVariables','nanmean_bump_width_thresh',...
       'GroupingVariables',{'stim_vel'});
mean_mvt_data = varfun(@nanmedian,all_data,'InputVariables','nanmean_total_mvt',...
       'GroupingVariables',{'stim_vel'});
   
%% Plot

figure('Position',[100 100 1400 800]),
    
for fly = 3:9
    subplot(1,3,1)
    plot(all_data.stim_vel(all_data.Fly == fly),all_data.nanmean_offset_precision(all_data.Fly == fly),'-o','color',[.5 .5 .5])
    hold on
    
    subplot(1,3,2)
    plot(all_data.stim_vel(all_data.Fly == fly),all_data.nanmean_bump_mag(all_data.Fly == fly),'-o','color',[.5 .5 .5])
    hold on
    
    subplot(1,3,3)
    plot(all_data.stim_vel(all_data.Fly == fly),rad2deg(all_data.nanmean_bump_width(all_data.Fly == fly)),'-o','color',[.5 .5 .5])
    hold on
       
end
%Add mean trends
subplot(1,3,1)
plot(mean_offset_precision.stim_vel,mean_offset_precision.mean_nanmean_offset_precision,'-ko','linewidth',2)
ylim([0 1]);
xlabel('Stimulus velocity (deg/s)');
ylabel('HD encoding reliability');

subplot(1,3,2)
plot(mean_bm_data.stim_vel,mean_bm_data.mean_nanmean_bump_mag,'-ko','linewidth',2)
ylim([0 2]);
xlabel('Stimulus velocity (deg/s)');
ylabel('Bump amplitude (DF/F)');

subplot(1,3,3)
plot(mean_bw_data.stim_vel,rad2deg(mean_bw_data.mean_nanmean_bump_width),'-ko','linewidth',2)
ylim([80 150]);
xlabel('Stimulus velocity (deg/s)');
ylabel('Bump width (deg)');

saveas(gcf,[exp_dir,'\groupPlots\parameters_vs_stim_speed.png'])
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\GCaMP-control\parameters_vs_stim_speed.svg')

%% Repeat thresholding by gof

figure('Position',[100 100 1600 700]),
    
for fly = 3:9
    subplot(1,3,1)
    plot(all_data.stim_vel(all_data.Fly == fly),all_data.nanmean_offset_precision(all_data.Fly == fly),'-o','color',[.5 .5 .5])
    hold on
    
    subplot(1,3,2)
    plot(all_data.stim_vel(all_data.Fly == fly),all_data.nanmean_bump_mag_thresh(all_data.Fly == fly),'-o','color',[.5 .5 .5])
    hold on
    
    subplot(1,3,3)
    plot(all_data.stim_vel(all_data.Fly == fly),rad2deg(all_data.nanmean_bump_width_thresh(all_data.Fly == fly)),'-o','color',[.5 .5 .5])
    hold on
    
end
%Add mean trends
subplot(1,3,1)
plot(mean_offset_precision.stim_vel,mean_offset_precision.mean_nanmean_offset_precision,'-ko','linewidth',2)
ylim([0 1]);
xlabel('Stimulus velocity (deg/s)');
ylabel('Offset variability (rad)');

subplot(1,3,2)
plot(mean_bm_data_thresh.stim_vel,mean_bm_data_thresh.mean_nanmean_bump_mag_thresh,'-ko','linewidth',2)
ylim([0 2]);
xlabel('Stimulus velocity (deg/s)');
ylabel('Bump magnitude (DF/F)');

subplot(1,3,3)
plot(mean_bw_data_thresh.stim_vel,rad2deg(mean_bw_data_thresh.mean_nanmean_bump_width_thresh),'-ko','linewidth',2)
ylim([70 150]);
xlabel('Stimulus velocity (deg/s)');
ylabel('Bump width (deg)');

saveas(gcf,[exp_dir,'\groupPlots\parameters_vs_stim_speed_thresh.png'])
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\GCaMP-control\parameters_vs_stim_speed_thresh.svg')


%save data for statistical analysis
writetable(all_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\GCaMP_control\data\all_data.csv')