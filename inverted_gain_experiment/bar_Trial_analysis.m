%Code to analyze offset precision and bump parameters for the bright bar trials
%I will combine the bar trials from the cue brightness, inverted gain and
%offset control experiments

clear all; close all;

%% Load data

%add trials from inverted gain experiment
folderNames = dir('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts');

fcn_precision = @(x) circ_r(x);

offset_precision_standing = [];
offset_precision_moving = [];
mean_bump_mag_standing = [];
mean_bump_mag_moving = [];
mean_bump_mag_low_mvt = [];
mean_bump_width_standing = [];
mean_bump_width_moving = [];
mean_bump_width_low_mvt = [];
bump_mag_moving = [];
bump_width_moving = [];
zbump_mag_moving = [];
zbump_width_moving = [];
rolling_bump_mag = [];
rolling_bump_width = [];
rot_speed_moving = [];
for_vel_moving = [];
rolling_rot_speed = [];
rolling_rot_speed_thresh = [];
rolling_for_vel_thresh = [];
rolling_offset_precision = [];
fly_num = [];
fly_number = [];
fly_ID = string();

%for the fly folders
for folder = 1:length(folderNames)
    if (contains(folderNames(folder).name,'60D05')==1)
        
        path = [folderNames(folder).folder,'\',folderNames(folder).name];
        %get the sessions info
        load([path,'\sessions_info.mat'])
        
        %load the empty trial and inverted gain trial data
        load([path,'\analysis\continuous_analysis_sid_',num2str(sessions_info.offset_stabilizer),'_tid_0.mat']);
        
        moving = continuous_data.total_mvt_ds > 25;
        gof = continuous_data.adj_rs > 0.5;
         
        offset = circ_dist(-continuous_data.heading,continuous_data.bump_pos'); 
        rolling_offset_precision = [matlab.tall.movingWindow(fcn_precision,92,offset);rolling_offset_precision];  
    
        %get thresholded rolling rot speed and bump pars
%         unwrapped_heading = unwrap(continuous_data.heading);
%         smoothed_heading = smoothdata(unwrapped_heading,'rlowess',25);
%         yaw_speed = abs(gradient(rad2deg(smoothed_heading)).* 25);
%         rolling_rot_speed_thresh = [movmean(yaw_speed,92);rolling_rot_speed_thresh];
        yaw_speed = abs(continuous_data.vel_yaw_ds);
        rolling_rot_speed = [movmean(yaw_speed,92),rolling_rot_speed];
        yaw_speed(~gof) = NaN;
        rolling_rot_speed_thresh = [movmean(yaw_speed,92),rolling_rot_speed_thresh];
        for_vel = continuous_data.vel_for_ds;
        for_vel(~gof) = NaN;
        rolling_for_vel_thresh = [movmean(for_vel,92);rolling_for_vel_thresh];
        bump_mag = continuous_data.bump_magnitude;
        bump_mag(~gof) = NaN;
        bm = (bump_mag - nanmean(bump_mag))/nanstd(bump_mag);
        rolling_bump_mag = [movmean(bm,92),rolling_bump_mag];
        bump_width = continuous_data.bump_width;
        bump_width(~gof) = NaN;
        bw = (bump_width - nanmean(bump_width))./nanstd(bump_width);
        rolling_bump_width = [movmean(bw,92),rolling_bump_width];   
        fly_num = [repelem(folder,1,length(continuous_data.bump_width)),fly_num];


    end
end
last_fly = fly_num(1);


%Add trials from inverted gain
folderNames3 = dir('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data');

for folder = 1:length(folderNames3)
    if (contains(folderNames3(folder).name,'60D05')==1) & (contains(folderNames3(folder).name, '20220415_60D05_7f') == 0)
        
        path = [folderNames3(folder).folder,'\',folderNames3(folder).name];
        %get the sessions info
        load([path,'\sessions_info.mat'])
        
        %load the empty trial and inverted gain trial data
        load([path,'\analysis\continuous_analysis_sid_',num2str(sessions_info.offset_stabilizer),'_tid_0.mat']);
        
        moving = continuous_data.total_mvt_ds > 25;
        gof = continuous_data.adj_rs > 0.5;
         
        offset = circ_dist(-continuous_data.heading,continuous_data.bump_pos'); 
        rolling_offset_precision = [matlab.tall.movingWindow(fcn_precision,92,offset);rolling_offset_precision];  
    
        %get thresholded rolling rot speed and bump pars
%         unwrapped_heading = unwrap(continuous_data.heading);
%         smoothed_heading = smoothdata(unwrapped_heading,'rlowess',25);
%         yaw_speed = abs(gradient(rad2deg(smoothed_heading)).* 25);
%         rolling_rot_speed_thresh = [movmean(yaw_speed,92);rolling_rot_speed_thresh];
        yaw_speed = abs(continuous_data.vel_yaw_ds);
        rolling_rot_speed = [movmean(yaw_speed,92),rolling_rot_speed];
        yaw_speed(~gof) = NaN;
        rolling_rot_speed_thresh = [movmean(yaw_speed,92),rolling_rot_speed_thresh];
        for_vel = continuous_data.vel_for_ds;
        for_vel(~gof) = NaN;
        rolling_for_vel_thresh = [movmean(for_vel,92);rolling_for_vel_thresh];
        bump_mag = continuous_data.bump_magnitude;
        bump_mag(~gof) = NaN;
        bm = (bump_mag - nanmean(bump_mag))/nanstd(bump_mag);
        rolling_bump_mag = [movmean(bm,92),rolling_bump_mag];
        bump_width = continuous_data.bump_width;
        bump_width(~gof) = NaN;
        bw = (bump_width - nanmean(bump_width))./nanstd(bump_width);
        rolling_bump_width = [movmean(bw,92),rolling_bump_width];   
        fly_num = [repelem(folder+last_fly,1,length(continuous_data.bump_width)),fly_num];
        
    end
end

%% Save speed and bump pars data for analysis in r

all_movement_data_bar_trial = table(rolling_offset_precision,rolling_rot_speed_thresh',rolling_for_vel_thresh,rolling_bump_mag',rolling_bump_width',fly_num','VariableNames',{'offset_precision','rolling_rot_speed','rolling_for_vel','rolling_bump_mag','rolling_bump_width','fly'});
writetable(all_movement_data_bar_trial,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\all_movement_data_bar_trial_including_rest_10_sec.csv')

%% Save offset precision and rot speed data for analysis in r

% rot_speed_offset_precision = table(rolling_rot_speed,rolling_offset_precision,fly_number','VariableNames',{'rot_speed','offset_precision','fly'});
% writetable(rot_speed_offset_precision,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\rot_speed_offset_precision.csv')
% % 
% %% Plot offset precision comparison
% 
% figure
% plot([offset_precision_standing;offset_precision_moving],'color',[.6 .6 .6])
% hold on
% plot(mean([offset_precision_standing;offset_precision_moving],2),'k','linewidth',2);
% xlim([0 3]);
% xticks([1:2]);
% xticklabels({'Standing','Moving'});
% ylim([0 1]);
% ylabel('Offset precision');
% 
% saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\MovementPanel\offset_precision_comparison_bar_trial.svg');
% saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\MovementPanel\offset_precision_comparison_bar_trial.png');
% 
% %stats
% ranksum(offset_precision_standing,offset_precision_moving)
% 
% offset_precision_bar_trials = [offset_precision_standing,offset_precision_moving];
% movement = [repelem(0,1,length(offset_precision_standing)),repelem(1,1,length(offset_precision_moving))];
% Fly = [1:length(offset_precision_standing),1:length(offset_precision_moving)];
% offset_precision_data = table(offset_precision_bar_trials',movement',Fly','VariableNames',{'offset_precision','movement','fly'});
% writetable(offset_precision_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\offset_precision_bar_data.csv')
% 
% %% Plot bump parameters comparison
% 
% figure
% subplot(1,2,1)
% plot([mean_bump_mag_standing;mean_bump_mag_moving],'color',[.6 .6 .6])
% hold on
% plot(mean([mean_bump_mag_standing;mean_bump_mag_moving],2),'k','linewidth',2);
% xlim([0 3]);
% xticks([1:2]);
% xticklabels({'Standing','Moving'});
% ylim([.5 3]);
% ylabel('Bump magnitude');
% 
% subplot(1,2,2)
% plot([mean_bump_width_standing;mean_bump_width_moving],'color',[.6 .6 .6])
% hold on
% plot(mean([mean_bump_width_standing;mean_bump_width_moving],2),'k','linewidth',2);
% xlim([0 3]);
% xticks([1:2]);
% xticklabels({'Standing','Moving'});
% ylim([.5 3]);
% ylabel('Bump width');
% 
% saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\MovementPanel\bump_pars_comparison_bar_trial.svg');
% saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\MovementPanel\bump_pars_comparison_bar_trial.png');
% 
% ranksum(mean_bump_mag_standing,mean_bump_mag_moving)
% ranksum(mean_bump_width_standing,mean_bump_width_moving)
% 
% mean_bump_mag_bar_trials = [mean_bump_mag_standing,mean_bump_mag_moving];
% mean_bump_width_bar_trials = [mean_bump_width_standing,mean_bump_width_moving];
% bump_pars_data = table(mean_bump_mag_bar_trials',mean_bump_width_bar_trials',movement',Fly','VariableNames',{'bump_mag','bump_width','movement','fly'});
% writetable(bump_pars_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\mean_bump_pars_bar_data.csv')
% 
% 
% %% Plot bump parameters comparison transition to movement
% 
% figure
% subplot(1,2,1)
% plot([mean_bump_mag_standing;mean_bump_mag_low_mvt],'color',[.6 .6 .6])
% hold on
% plot(mean([mean_bump_mag_standing;mean_bump_mag_low_mvt],2),'k','linewidth',2);
% xlim([0 3]);
% xticks([1:2]);
% xticklabels({'Standing still','Starting movement'});
% ylim([.5 3]);
% ylabel('Bump magnitude');
% 
% subplot(1,2,2)
% plot([mean_bump_width_standing;mean_bump_width_low_mvt],'color',[.6 .6 .6])
% hold on
% plot(mean([mean_bump_width_standing;mean_bump_width_low_mvt],2),'k','linewidth',2);
% xlim([0 3]);
% xticks([1:2]);
% xticklabels({'Standing still','Starting movement'});
% ylim([.5 3]);
% ylabel('Bump width');
% 
% ranksum(mean_bump_mag_standing,mean_bump_mag_low_mvt)
% ranksum(mean_bump_width_standing,mean_bump_width_low_mvt)
% 
% mean_bump_mag_bar_trials = [mean_bump_mag_standing,mean_bump_mag_low_mvt];
% mean_bump_width_bar_trials = [mean_bump_width_standing,mean_bump_width_low_mvt];
% bump_pars_data = table(mean_bump_mag_bar_trials',mean_bump_width_bar_trials',movement',Fly','VariableNames',{'bump_mag','bump_width','movement','fly'});
% writetable(bump_pars_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\mean_bump_pars_bar_data_mvt_transition.csv')
