%Code to analyze offset precision and bump parameters for the empty trials
%I will combine the empty trials from the inverted gain experiment with the
%empty trials from the 'offset control' experiment to get more data

clear all; close all;

%% Load data

%add trials from inverted gain experiment
folderNames = dir('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data');

offset_precision_standing = [];
offset_precision_moving = [];
mean_bump_mag_standing = [];
mean_bump_mag_moving = [];
mean_bump_width_standing = [];
mean_bump_width_moving = [];
bump_mag_moving = [];
bump_width_moving = [];
zbump_mag_moving = [];
zbump_width_moving = [];
rot_speed_moving = [];
fly_num = [];

%for the fly folders
for folder = 1:length(folderNames)
    if (contains(folderNames(folder).name,'60D05')==1 & contains(folderNames(folder).name,'20210127')==0 & contains(folderNames(folder).name,'20210218_60D05_7f_fly2')==0) %I'm excluding these two flies because I didn't run a darkness trial for them
        
        path = [folderNames(folder).folder,'\',folderNames(folder).name];
        %get the sessions info
        load([path,'\sessions_info.mat'])
        
        %load the empty trial and inverted gain trial data
        load([path,'\analysis\continuous_analysis_sid_',num2str(sessions_info.empty_trial),'_tid_0.mat']);
        
        moving = continuous_data.total_mvt_ds > 25;
        gof = continuous_data.adj_rs > 0.5;
        
        mean_bump_mag_standing = [mean(continuous_data.bump_magnitude(~moving & gof)),mean_bump_mag_standing];       
        mean_bump_mag_moving = [mean(continuous_data.bump_magnitude(moving & gof)),mean_bump_mag_moving];
        mean_bump_width_standing = [mean(continuous_data.bump_width(~moving & gof)),mean_bump_width_standing];
        mean_bump_width_moving = [mean(continuous_data.bump_width(moving & gof)),mean_bump_width_moving];
        
        offset = circ_dist(-continuous_data.heading,continuous_data.bump_pos');
        offset_precision_standing = [offset_precision_standing,circ_r(offset(~moving))];
        offset_precision_moving = [offset_precision_moving,circ_r(offset(moving))];
        
        bump_mag_moving = [continuous_data.bump_magnitude(moving & gof),bump_mag_moving];
        zbump_mag_moving = [zscore(continuous_data.bump_magnitude(moving & gof)),zbump_mag_moving];
        bump_width_moving = [continuous_data.bump_width(moving & gof),bump_width_moving];
        zbump_width_moving = [zscore(continuous_data.bump_width(moving & gof)),zbump_width_moving];
        rot_speed_moving = [abs(continuous_data.vel_yaw_ds(moving & gof)),rot_speed_moving];
        
        fly_num = [repelem(folder,1,length(continuous_data.bump_width(moving & gof))),fly_num];
        
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
        load([path,'\analysis\continuous_analysis_sid_',num2str(session_info.empty),'_tid_0.mat']);
        
        moving = continuous_data.total_mvt_ds > 25;
        gof = continuous_data.adj_rs > 0.45;
        
        mean_bump_mag_standing = [mean(continuous_data.bump_magnitude(~moving & gof)),mean_bump_mag_standing];       
        mean_bump_mag_moving = [mean(continuous_data.bump_magnitude(moving & gof)),mean_bump_mag_moving];
        mean_bump_width_standing = [mean(continuous_data.bump_width(~moving & gof)),mean_bump_width_standing];
        mean_bump_width_moving = [mean(continuous_data.bump_width(moving & gof)),mean_bump_width_moving];
        
        offset = circ_dist(-continuous_data.heading,continuous_data.bump_pos');
        offset_precision_standing = [offset_precision_standing,circ_r(offset(~moving))];
        offset_precision_moving = [offset_precision_moving,circ_r(offset(moving))];
        
        bump_mag_moving = [continuous_data.bump_magnitude(moving & gof),bump_mag_moving];
        zbump_mag_moving = [zscore(continuous_data.bump_magnitude(moving & gof)),zbump_mag_moving];
        bump_width_moving = [continuous_data.bump_width(moving & gof),bump_width_moving];
        zbump_width_moving = [zscore(continuous_data.bump_width(moving & gof)),zbump_width_moving];
        rot_speed_moving = [abs(continuous_data.vel_yaw_ds(moving & gof)),rot_speed_moving];
        
        fly_num = [repelem(folder+last_fly,1,length(continuous_data.bump_width(moving & gof))),fly_num];
    end
end

%% Save speed and bump pars data for analysis in r

all_movement_data_empty_trial = table(bump_mag_moving',bump_width_moving',zbump_mag_moving',zbump_width_moving',rot_speed_moving',fly_num','VariableNames',{'bump_mag','bump_width','zbump_mag','zbump_width','rot_speed','fly'});
writetable(all_movement_data_empty_trial,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\all_movement_data_empty_trial.csv')

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

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\MovementPanel\offset_precision_comparison_empty_trial.svg');
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\MovementPanel\offset_precision_comparison_empty_trial.png');

%stats
ranksum(offset_precision_standing,offset_precision_moving)

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

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\MovementPanel\bump_pars_comparison_empty_trial.svg');
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\MovementPanel\bump_pars_comparison_empty_trial.png');

ranksum(mean_bump_mag_standing,mean_bump_mag_moving)
ranksum(mean_bump_width_standing,mean_bump_width_moving)

