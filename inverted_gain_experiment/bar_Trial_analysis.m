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
rot_speed_moving = [];
rolling_rot_speed = [];
rolling_offset_precision = [];
fly_num = [];
fly_number = [];

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
        
        mean_bump_mag_standing = [mean(continuous_data.bump_magnitude(~moving & gof)),mean_bump_mag_standing];       
        mean_bump_mag_moving = [mean(continuous_data.bump_magnitude(moving & gof)),mean_bump_mag_moving];
        mean_bump_mag_low_mvt = [mean(continuous_data.bump_magnitude(gof & continuous_data.total_mvt_ds > 25 & continuous_data.total_mvt_ds < 50)),mean_bump_mag_low_mvt];                        
        mean_bump_width_standing = [mean(continuous_data.bump_width(~moving & gof)),mean_bump_width_standing];
        mean_bump_width_moving = [mean(continuous_data.bump_width(moving & gof)),mean_bump_width_moving];
        mean_bump_width_low_mvt = [mean(continuous_data.bump_width(gof & continuous_data.total_mvt_ds > 25 & continuous_data.total_mvt_ds < 50)),mean_bump_width_low_mvt];                
        
        offset = circ_dist(-continuous_data.heading,continuous_data.bump_pos');
        offset_precision_standing = [offset_precision_standing,circ_r(offset(~moving))];
        offset_precision_moving = [offset_precision_moving,circ_r(offset(moving))];
        
        bump_mag_moving = [continuous_data.bump_magnitude(moving & gof),bump_mag_moving];
        zbump_mag_moving = [zscore(continuous_data.bump_magnitude(moving & gof)),zbump_mag_moving];
        bump_width_moving = [continuous_data.bump_width(moving & gof),bump_width_moving];
        zbump_width_moving = [zscore(continuous_data.bump_width(moving & gof)),zbump_width_moving];
        rot_speed_moving = [abs(continuous_data.vel_yaw_ds(moving & gof)),rot_speed_moving];
        
        fly_num = [repelem(folder,1,length(continuous_data.bump_width(moving & gof))),fly_num];
                
        %get averaged rot speed and offset precision
        unwrapped_heading = unwrap(continuous_data.heading(moving));
        smoothed_heading = smoothdata(unwrapped_heading,'rlowess',25);
        yaw_speed = abs(gradient(rad2deg(smoothed_heading)).* 25);
        rolling_rot_speed = [movmean(yaw_speed,100);rolling_rot_speed];
        
        rolling_offset_precision = [matlab.tall.movingWindow(fcn_precision,100,offset(moving));rolling_offset_precision];
        
        fly_number = [repelem(folder,1,length(continuous_data.bump_width(moving))),fly_number];

    end
end
last_fly = fly_num(1);

%Add trials from offset control
folderNames2 = dir('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Offset_control\data');

for folder = 1:length(folderNames2)
    if (contains(folderNames2(folder).name,'60D05')==1)
        
        path = [folderNames2(folder).folder,'\',folderNames2(folder).name];
        %get the sessions info
        load([path,'\analysis\session_info.mat'])
        
        %load the empty trial and inverted gain trial data
        load([path,'\analysis\continuous_analysis_sid_',num2str(session_info.bar),'_tid_0.mat']);
        
        moving = continuous_data.total_mvt_ds > 25;
        gof = continuous_data.adj_rs > 0.5;
        
        mean_bump_mag_standing = [mean(continuous_data.bump_magnitude(~moving & gof)),mean_bump_mag_standing];       
        mean_bump_mag_moving = [mean(continuous_data.bump_magnitude(moving & gof)),mean_bump_mag_moving];
        mean_bump_mag_low_mvt = [mean(continuous_data.bump_magnitude(gof & continuous_data.total_mvt_ds > 25 & continuous_data.total_mvt_ds < 50)),mean_bump_mag_low_mvt];                        
        mean_bump_width_standing = [mean(continuous_data.bump_width(~moving & gof)),mean_bump_width_standing];
        mean_bump_width_moving = [mean(continuous_data.bump_width(moving & gof)),mean_bump_width_moving];
        mean_bump_width_low_mvt = [mean(continuous_data.bump_width(gof & continuous_data.total_mvt_ds > 25 & continuous_data.total_mvt_ds < 50)),mean_bump_width_low_mvt];                
        
        offset = circ_dist(-continuous_data.heading,continuous_data.bump_pos');
        offset_precision_standing = [offset_precision_standing,circ_r(offset(~moving))];
        offset_precision_moving = [offset_precision_moving,circ_r(offset(moving))];
        
        bump_mag_moving = [continuous_data.bump_magnitude(moving & gof),bump_mag_moving];
        zbump_mag_moving = [zscore(continuous_data.bump_magnitude(moving & gof)),zbump_mag_moving];
        bump_width_moving = [continuous_data.bump_width(moving & gof),bump_width_moving];
        zbump_width_moving = [zscore(continuous_data.bump_width(moving & gof)),zbump_width_moving];
        rot_speed_moving = [abs(continuous_data.vel_yaw_ds(moving & gof)),rot_speed_moving];
        
        fly_num = [repelem(folder+last_fly,1,length(continuous_data.bump_width(moving & gof))),fly_num];
        
        %get averaged rot speed and offset precision
        unwrapped_heading = unwrap(continuous_data.heading(moving));
        smoothed_heading = smoothdata(unwrapped_heading,'rlowess',25);
        yaw_speed = abs(gradient(rad2deg(smoothed_heading)).* 25);
        rolling_rot_speed = [movmean(yaw_speed,100);rolling_rot_speed];
        
        rolling_offset_precision = [matlab.tall.movingWindow(fcn_precision,100,offset(moving));rolling_offset_precision];
        
        fly_number = [repelem(folder+last_fly,1,length(continuous_data.bump_width(moving))),fly_number];
        
    end
end


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
        
        mean_bump_mag_standing = [mean(continuous_data.bump_magnitude(~moving & gof)),mean_bump_mag_standing];       
        mean_bump_mag_moving = [mean(continuous_data.bump_magnitude(moving & gof)),mean_bump_mag_moving];
        mean_bump_mag_low_mvt = [mean(continuous_data.bump_magnitude(gof & continuous_data.total_mvt_ds > 25 & continuous_data.total_mvt_ds < 50)),mean_bump_mag_low_mvt];                        
        mean_bump_width_standing = [mean(continuous_data.bump_width(~moving & gof)),mean_bump_width_standing];
        mean_bump_width_moving = [mean(continuous_data.bump_width(moving & gof)),mean_bump_width_moving];
        mean_bump_width_low_mvt = [mean(continuous_data.bump_width(gof & continuous_data.total_mvt_ds > 25 & continuous_data.total_mvt_ds < 50)),mean_bump_width_low_mvt];                
        
        offset = circ_dist(-continuous_data.heading,continuous_data.bump_pos');
        offset_precision_standing = [offset_precision_standing,circ_r(offset(~moving))];
        offset_precision_moving = [offset_precision_moving,circ_r(offset(moving))];
        
        bump_mag_moving = [continuous_data.bump_magnitude(moving & gof),bump_mag_moving];
        zbump_mag_moving = [zscore(continuous_data.bump_magnitude(moving & gof)),zbump_mag_moving];
        bump_width_moving = [continuous_data.bump_width(moving & gof),bump_width_moving];
        zbump_width_moving = [zscore(continuous_data.bump_width(moving & gof)),zbump_width_moving];
        rot_speed_moving = [abs(continuous_data.vel_yaw_ds(moving & gof)),rot_speed_moving];
        
        fly_num = [repelem(folder+last_fly,1,length(continuous_data.bump_width(moving & gof))),fly_num];
        
        %get averaged rot speed and offset precision
        unwrapped_heading = unwrap(continuous_data.heading(moving));
        smoothed_heading = smoothdata(unwrapped_heading,'rlowess',25);
        yaw_speed = abs(gradient(rad2deg(smoothed_heading)).* 25);
        rolling_rot_speed = [movmean(yaw_speed,100);rolling_rot_speed];
        
        rolling_offset_precision = [matlab.tall.movingWindow(fcn_precision,100,offset(moving));rolling_offset_precision];
        fly_number = [repelem(folder+last_fly,1,length(continuous_data.bump_width(moving))),fly_number];
        
    end
end

%% Save speed and bump pars data for analysis in r

all_movement_data_bar_trial = table(bump_mag_moving',bump_width_moving',zbump_mag_moving',zbump_width_moving',rot_speed_moving',fly_num','VariableNames',{'bump_mag','bump_width','zbump_mag','zbump_width','rot_speed','fly'});
writetable(all_movement_data_bar_trial,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\all_movement_data_bar_trial.csv')

%% Save offset precision and rot speed data for analysis in r

rot_speed_offset_precision = table(rolling_rot_speed,rolling_offset_precision,fly_number','VariableNames',{'rot_speed','offset_precision','fly'});
writetable(rot_speed_offset_precision,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\rot_speed_offset_precision.csv')

%% Plot offset precision comparison

figure
plot([offset_precision_standing;offset_precision_moving],'color',[.6 .6 .6])
hold on
plot(mean([offset_precision_standing;offset_precision_moving],2),'k','linewidth',2);
xlim([0 3]);
xticks([1:2]);
xticklabels({'Standing','Moving'});
ylim([0 1]);
ylabel('Offset precision');

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\MovementPanel\offset_precision_comparison_bar_trial.svg');
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\MovementPanel\offset_precision_comparison_bar_trial.png');

%stats
ranksum(offset_precision_standing,offset_precision_moving)

offset_precision_bar_trials = [offset_precision_standing,offset_precision_moving];
movement = [repelem(0,1,length(offset_precision_standing)),repelem(1,1,length(offset_precision_moving))];
Fly = [1:length(offset_precision_standing),1:length(offset_precision_moving)];
offset_precision_data = table(offset_precision_bar_trials',movement',Fly','VariableNames',{'offset_precision','movement','fly'});
writetable(offset_precision_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\offset_precision_bar_data.csv')

%% Plot bump parameters comparison

figure
subplot(1,2,1)
plot([mean_bump_mag_standing;mean_bump_mag_moving],'color',[.6 .6 .6])
hold on
plot(mean([mean_bump_mag_standing;mean_bump_mag_moving],2),'k','linewidth',2);
xlim([0 3]);
xticks([1:2]);
xticklabels({'Standing','Moving'});
ylim([.5 3]);
ylabel('Bump magnitude');

subplot(1,2,2)
plot([mean_bump_width_standing;mean_bump_width_moving],'color',[.6 .6 .6])
hold on
plot(mean([mean_bump_width_standing;mean_bump_width_moving],2),'k','linewidth',2);
xlim([0 3]);
xticks([1:2]);
xticklabels({'Standing','Moving'});
ylim([.5 3]);
ylabel('Bump width');

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\MovementPanel\bump_pars_comparison_bar_trial.svg');
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\MovementPanel\bump_pars_comparison_bar_trial.png');

ranksum(mean_bump_mag_standing,mean_bump_mag_moving)
ranksum(mean_bump_width_standing,mean_bump_width_moving)

mean_bump_mag_bar_trials = [mean_bump_mag_standing,mean_bump_mag_moving];
mean_bump_width_bar_trials = [mean_bump_width_standing,mean_bump_width_moving];
bump_pars_data = table(mean_bump_mag_bar_trials',mean_bump_width_bar_trials',movement',Fly','VariableNames',{'bump_mag','bump_width','movement','fly'});
writetable(bump_pars_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\mean_bump_pars_bar_data.csv')


%% Plot bump parameters comparison transition to movement

figure
subplot(1,2,1)
plot([mean_bump_mag_standing;mean_bump_mag_low_mvt],'color',[.6 .6 .6])
hold on
plot(mean([mean_bump_mag_standing;mean_bump_mag_low_mvt],2),'k','linewidth',2);
xlim([0 3]);
xticks([1:2]);
xticklabels({'Standing still','Starting movement'});
ylim([.5 3]);
ylabel('Bump magnitude');

subplot(1,2,2)
plot([mean_bump_width_standing;mean_bump_width_low_mvt],'color',[.6 .6 .6])
hold on
plot(mean([mean_bump_width_standing;mean_bump_width_low_mvt],2),'k','linewidth',2);
xlim([0 3]);
xticks([1:2]);
xticklabels({'Standing still','Starting movement'});
ylim([.5 3]);
ylabel('Bump width');

ranksum(mean_bump_mag_standing,mean_bump_mag_low_mvt)
ranksum(mean_bump_width_standing,mean_bump_width_low_mvt)

mean_bump_mag_bar_trials = [mean_bump_mag_standing,mean_bump_mag_low_mvt];
mean_bump_width_bar_trials = [mean_bump_width_standing,mean_bump_width_low_mvt];
bump_pars_data = table(mean_bump_mag_bar_trials',mean_bump_width_bar_trials',movement',Fly','VariableNames',{'bump_mag','bump_width','movement','fly'});
writetable(bump_pars_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\mean_bump_pars_bar_data_mvt_transition.csv')
