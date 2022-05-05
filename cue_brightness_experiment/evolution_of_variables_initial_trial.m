%%code to analyze the evolution of offset precision, heading precision and
%%bump parameters in initial offset stabilizer blocks


clear all; close all;

%% Load data

%add trials from inverted gain experiment
folderNames = dir('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts');

offset_precision = [];
bump_mag = [];
bump_width = [];
heading_precision = [];
fly_num = [];
fly_num_precision = [];
precision_time = [];
bump_pars_time = [];
total_mvt = [];
rot_speed = [];
for_vel = [];

fcn_precision = @(x) circ_r(x);
fcn_mean = @(x) nanmean(x);

%for the fly folders
for folder = 1:length(folderNames)
    if (contains(folderNames(folder).name,'60D05')==1)
        
        path = [folderNames(folder).folder,'\',folderNames(folder).name];
        %get the sessions info
        load([path,'\sessions_info.mat'])
        
        %load the empty trial and inverted gain trial data
        load([path,'\analysis\continuous_analysis_sid_',num2str(sessions_info.offset_stabilizer),'_tid_0.mat']);
        
        moving = continuous_data.total_mvt_ds > 20;
        gof = continuous_data.adj_rs > 0.45;
        
        offset = circ_dist(-continuous_data.heading,continuous_data.bump_pos');
        %Compute the offset variability and precision over different window sizes, from 1 s to
        %50 s
        window_sizes = 550;
        offset_precision_fly = [];
        bump_mag_fly = [];
        bump_width_fly = [];
        heading_precision_fly = [];
        for window = 1:length(window_sizes)
            offset_precision_fly(:,window) = matlab.tall.movingWindow(fcn_precision,window_sizes(window),offset(moving & gof));
            heading_precision_fly(:,window) = matlab.tall.movingWindow(fcn_precision,window_sizes(window),continuous_data.heading(moving & gof));
            bump_mag_fly(:,window) = movmean(continuous_data.bump_magnitude(moving & gof),window_sizes);
            bump_width_fly(:,window) = movmean(continuous_data.bump_width(moving & gof),window_sizes);
        end
        
        offset_precision = [offset_precision_fly;offset_precision];
        heading_precision = [heading_precision_fly;heading_precision];
        bump_mag = [bump_mag_fly;bump_mag];
        bump_width = [bump_width_fly;bump_width];
        
        fly_num = [repelem(folder,1,length(continuous_data.bump_width(moving & gof))),fly_num];
        fly_num_precision = [repelem(folder,1,length(continuous_data.bump_width(moving))),fly_num_precision];
        precision_time = [continuous_data.time(moving);precision_time];
        bump_pars_time = [continuous_data.time(moving & gof);bump_pars_time];
        
        total_mvt = [continuous_data.total_mvt_ds(moving & gof),total_mvt];
        rot_speed = [abs(continuous_data.vel_yaw_ds(moving & gof)),rot_speed];
        for_vel = [continuous_data.vel_for_ds(moving & gof);for_vel];        
        
    end
end
last_fly = fly_num(1);


%Add trials from inverted gain
folderNames2 = dir('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data');

for folder = 1:length(folderNames2)
    if (contains(folderNames2(folder).name,'60D05')==1 & contains(folderNames2(folder).name, '20220415_60D05_7f')==0)
        
        path = [folderNames2(folder).folder,'\',folderNames2(folder).name];
        %get the sessions info
        load([path,'\sessions_info.mat'])
        
        %load the empty trial and inverted gain trial data
        load([path,'\analysis\continuous_analysis_sid_',num2str(sessions_info.offset_stabilizer),'_tid_0.mat']);
        
        moving = continuous_data.total_mvt_ds > 20;
        gof = continuous_data.adj_rs > 0.45;
        
        offset = circ_dist(-continuous_data.heading,continuous_data.bump_pos');
        %Compute the offset variability and precision over different window sizes, from 1 s to
        %50 s
        window_sizes = 550;
        offset_precision_fly = [];
        bump_mag_fly = [];
        bump_width_fly = [];
        heading_precision_fly = [];
        for window = 1:length(window_sizes)
            offset_precision_fly(:,window) = matlab.tall.movingWindow(fcn_precision,window_sizes(window),offset(moving & gof));
            heading_precision_fly(:,window) = matlab.tall.movingWindow(fcn_precision,window_sizes(window),continuous_data.heading(moving & gof));
            bump_mag_fly(:,window) = movmean(continuous_data.bump_magnitude(moving & gof),window_sizes);
            bump_width_fly(:,window) = movmean(continuous_data.bump_width(moving & gof),window_sizes);
        end
        
        offset_precision = [offset_precision_fly;offset_precision];
        heading_precision = [heading_precision_fly;heading_precision];
        bump_mag = [bump_mag_fly;bump_mag];
        bump_width = [bump_width_fly;bump_width];
        
        fly_num = [repelem(folder+last_fly,1,length(continuous_data.bump_width(moving & gof))),fly_num];
        fly_num_precision = [repelem(folder+last_fly,1,length(continuous_data.bump_width(moving))),fly_num_precision];
        precision_time = [continuous_data.time(moving);precision_time];
        bump_pars_time = [continuous_data.time(moving & gof);bump_pars_time];
        
        total_mvt = [continuous_data.total_mvt_ds(moving & gof),total_mvt];
        rot_speed = [abs(continuous_data.vel_yaw_ds(moving & gof)),rot_speed];
        for_vel = [continuous_data.vel_for_ds(moving & gof);for_vel];        

    end
end


%% Save speed and bump pars data for analysis in r

bump_pars_evo_data_bar_trial = table(bump_mag,bump_width,bump_pars_time,total_mvt',rot_speed',for_vel,fly_num','VariableNames',{'bump_mag','bump_width','time','total_mvt','rot_speed','for_vel','fly'});
%precision_evo_data_bar_trial = table(offset_precision,heading_precision,precision_time,fly_num_precision','VariableNames',{'offset_precision','heading_precision','time','fly'});
all_data_bar_trial = table(offset_precision,heading_precision,bump_mag,bump_width,bump_pars_time,fly_num','VariableNames',{'offset_precision','heading_precision','bump_mag','bump_width','time','fly'});
writetable(bump_pars_evo_data_bar_trial,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts\bump_pars_evo_data_bar_trial.csv')
%writetable(precision_evo_data_bar_trial,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts\precision_evo_data_bar_trial.csv')
writetable(all_data_bar_trial,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts\all_data_bar_trial.csv')


%% Clear space

clear all;close all;
