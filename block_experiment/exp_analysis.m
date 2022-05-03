%Full experiment analysis
%Code to analyze the full experiment


%% Load data

clear all; close all;

%Get the pre-processed data
[path] = uigetdir('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\');

% Import sessions information
load([path,'\analysis\sessions_info.mat'])

%% Set colormap

folderNames = dir(path(1:69));
flyNames = struct();
for folder = 1:length(folderNames)
    if (contains(folderNames(folder).name,'60D05') & ~contains(folderNames(folder).name,'txt'))
        flyNames(folder).name = folderNames(folder).name;
    end
end
%Remove empty rows
flyNames = flyNames(~cellfun(@isempty,{flyNames.name}));

%Assign fly number
for fly = 1:length(flyNames)
    %if strcmp(flyNames(fly).name,path(54:end))
    if strcmp(flyNames(fly).name,path(71:end)) %70 for low reliability/71 for high reliability (code this)
        fly_ID = fly;
    end
end

%Set colors for individual fly plots
colors_for_plots = [0.2 0.8 0.8 ; 1 0.5 0; 0 0.5 1;...
    0 0.6 0.3;  1 0.2 0.2; 0.9290 0.6940 0.1250;...
    0.6350 0.0780 0.1840; 0.4660 0.6740 0.1880;...
    0 0.4470 0.7410; 0.75, 0.1, 0.75; 0.75, 0.75, 0;...
    0 0.75 0.75; 0.75 0 0.75; 1 0.2 0.2; 0.2 1 0.2; 0.2 0.2 1;...
    0.25 0.25 0.25; 0.25 0.45 0.15; 0.70 0.15 0.50];

%Assign color for this fly's plots
fly_color = colors_for_plots(fly_ID,:);

%% Make directory to save plots

%Move to the analysis folder
contents = dir([path,'\analysis']);

%if there isn't a 'plots' folder already, create one
if (contains([contents.name],'continuous_plots') == 0)
   mkdir(path,'\analysis\continuous_plots'); 
end

%% Analyze initial closed-loop panels

%% Full experiment plot

load([path,'\analysis\continuous_analysis_sid_',num2str(sessions.initial_cl_bar),'_tid_0.mat'])

figure('Position',[100 100 1200 800]),
subplot(5,1,1)
dff = continuous_data.dff_matrix';
imagesc(flip(dff))
colormap(flipud(gray))
title('EPG activity');
set(gca,'xticklabel',{[]})

subplot(5,1,2)
bump_pos = wrapTo180(rad2deg(continuous_data.bump_pos));
%Remove wrapped lines to plot
[x_out_bump,bump_to_plot] = removeWrappedLines(continuous_data.time,bump_pos');
plot(x_out_bump,bump_to_plot,'LineWidth',1.5)
hold on
heading = wrapTo180(-continuous_data.heading_deg);
pre_panels_heading = deg2rad(heading);
pre_panels_heading_thresh = pre_panels_heading(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds > 25);
heading_precision_pre_panels = circ_r(pre_panels_heading_thresh);
[x_out_heading,heading_to_plot] = removeWrappedLines(continuous_data.time,heading);
plot(x_out_heading,heading_to_plot,'LineWidth',1.5)
title('Bump and fly position');
legend('Bump estimate','Fly position','Location','best')
ylim([-180 180]);
set(gca,'xticklabel',{[]})

subplot(5,1,3)
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
%store offset for later
pre_panels_offset_above_thresh = deg2rad(offset(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds > 25));
[~, offset_var_pre_panels_offset_above_thresh] = circ_std(pre_panels_offset_above_thresh);
offset_precision_pre_panels = circ_r(pre_panels_offset_above_thresh);
[x_out_offset,offset_to_plot] = removeWrappedLines(continuous_data.time,offset);
plot(x_out_offset,offset_to_plot,'LineWidth',1.5,'color','k')
title('Offset')
ylim([-180 180]);
set(gca,'xticklabel',{[]})

subplot(5,1,4)
plot(continuous_data.time(continuous_data.adj_rs>=0.5),continuous_data.bump_magnitude(continuous_data.adj_rs>=0.5),'r.')
hold on
plot(continuous_data.time(continuous_data.adj_rs<0.5),continuous_data.bump_magnitude(continuous_data.adj_rs<0.5),'k.')
title('Bump magnitude')

subplot(5,1,5)
plot(continuous_data.time(continuous_data.adj_rs>=0.5),continuous_data.bump_width(continuous_data.adj_rs>=0.5),'r.')
hold on
plot(continuous_data.time(continuous_data.adj_rs<0.5),continuous_data.bump_width(continuous_data.adj_rs<0.5),'k.')
title('Bump width')

suptitle('Initial trial with just panels');

saveas(gcf,[path,'\analysis\continuous_plots\initial_panels_full_experiment.png']);

%% Bump parameters

%Get mean bump parameters
meanBM_thresh_pre_panels = nanmean(continuous_data.bump_magnitude(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25));
meanBW_thresh_pre_panels = nanmean(continuous_data.bump_width(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25));
%Get mean vel
mean_total_mvt_thresh_pre_panels = nanmean(continuous_data.total_mvt_ds(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25));

%Store all bump param and mvt values
allBumpMag = continuous_data.bump_magnitude;
allBumpWidth = continuous_data.bump_width;
allTotalMvt = continuous_data.total_mvt_ds;
allYawSpeed = abs(continuous_data.vel_yaw_ds);
allVelFor = continuous_data.vel_for_ds';
blockType = repelem(1,1,length(continuous_data.bump_magnitude));

%%  Analyze initial closed-loop wind

%% Full experiment plot

load([path,'\analysis\continuous_analysis_sid_',num2str(sessions.initial_cl_wind),'_tid_0.mat'])

figure('Position',[100 100 1200 800]),
subplot(5,1,1)
dff = continuous_data.dff_matrix';
imagesc(flip(dff))
colormap(flipud(gray))
title('EPG activity');
set(gca,'xticklabel',{[]})

subplot(5,1,2)
bump_pos = wrapTo180(rad2deg(continuous_data.bump_pos));
%Remove wrapped lines to plot
[x_out_bump,bump_to_plot] = removeWrappedLines(continuous_data.time,bump_pos');
plot(x_out_bump,bump_to_plot,'LineWidth',1.5)
hold on
heading = wrapTo180(-continuous_data.heading_deg);
pre_wind_heading = deg2rad(heading);
pre_wind_heading_thresh = pre_wind_heading(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds > 25);
heading_precision_pre_wind = circ_r(pre_wind_heading_thresh);
[x_out_heading,heading_to_plot] = removeWrappedLines(continuous_data.time,heading);
plot(x_out_heading,heading_to_plot,'LineWidth',1.5)
title('Bump and fly position');
legend('Bump estimate','Fly position','Location','best')
ylim([-180 180]);
set(gca,'xticklabel',{[]})

subplot(5,1,3)
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
%store offset for later
pre_wind_offset_above_thresh = deg2rad(offset(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25));
[~, offset_var_pre_wind] = circ_std(pre_wind_offset_above_thresh);
offset_precision_pre_wind = circ_r(pre_wind_offset_above_thresh);
[x_out_offset,offset_to_plot] = removeWrappedLines(continuous_data.time,offset);
plot(x_out_offset,offset_to_plot,'LineWidth',1.5,'color','k')
title('Offset')
ylim([-180 180]);
set(gca,'xticklabel',{[]})

subplot(5,1,4)
plot(continuous_data.time(continuous_data.adj_rs>=0.5),continuous_data.bump_magnitude(continuous_data.adj_rs>=0.5),'r.')
hold on
plot(continuous_data.time(continuous_data.adj_rs<0.5),continuous_data.bump_magnitude(continuous_data.adj_rs<0.5),'k.')
title('Bump magnitude')

subplot(5,1,5)
plot(continuous_data.time(continuous_data.adj_rs>=0.5),continuous_data.bump_width(continuous_data.adj_rs>=0.5),'r.')
hold on
plot(continuous_data.time(continuous_data.adj_rs<0.5),continuous_data.bump_width(continuous_data.adj_rs<0.5),'k.')
title('Bump width')

suptitle('Initial trial with just wind');

saveas(gcf,[path,'\analysis\continuous_plots\initial_wind_full_experiment.png']);

%% Bump parameters

%Get mean bump parameters
meanBM_thresh_pre_wind = nanmean(continuous_data.bump_magnitude(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25));
meanBW_thresh_pre_wind = nanmean(continuous_data.bump_width(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25));
%Get mean vel
mean_total_mvt_thresh_pre_wind = nanmean(continuous_data.total_mvt_ds(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25));

%Store all bump param and mvt values
allBumpMag = [allBumpMag,continuous_data.bump_magnitude];
allBumpWidth = [allBumpWidth,continuous_data.bump_width];
allTotalMvt = [allTotalMvt,continuous_data.total_mvt_ds];
allYawSpeed = [allYawSpeed,abs(continuous_data.vel_yaw_ds)];
allVelFor = [allVelFor,continuous_data.vel_for_ds'];
blockType = [blockType,repelem(2,1,length(continuous_data.bump_magnitude))];

%% Analyze the cue combination trial

%% Full experiment analysis

load([path,'\analysis\continuous_analysis_sid_',num2str(sessions.cue_combination),'_tid_0.mat'])

%Cut the data for the fly for which fictrac failed
if contains(path, '20210922')
    frames = find(floor(continuous_data.time) == 600);
    first_frame = frames(1);
    continuous_data.dff_matrix = continuous_data.dff_matrix(1:first_frame,:);
    continuous_data.bump_pos = continuous_data.bump_pos(1:first_frame);
    continuous_data.heading_deg = continuous_data.heading_deg(1:first_frame);
    continuous_data.time = continuous_data.time(1:first_frame);
    continuous_data.heading = continuous_data.heading(1:first_frame);
    continuous_data.adj_rs = continuous_data.adj_rs(1:first_frame);
    continuous_data.bump_magnitude = continuous_data.bump_magnitude(1:first_frame);
    continuous_data.bump_width = continuous_data.bump_width(1:first_frame);
    continuous_data.total_mvt_ds = continuous_data.total_mvt_ds(1:first_frame);
    continuous_data.vel_yaw_ds = continuous_data.vel_yaw_ds(1:first_frame);
    continuous_data.vel_for_ds = continuous_data.vel_for_ds(1:first_frame);
end

figure('Position',[100 100 1200 800]),
subplot(5,1,1)
dff = continuous_data.dff_matrix';
imagesc(flip(dff))
colormap(flipud(gray))
title('EPG activity');
set(gca,'xticklabel',{[]});

subplot(5,1,2)
bump_pos = wrapTo180(rad2deg(continuous_data.bump_pos));
%Remove wrapped lines to plot
[x_out_bump,bump_to_plot] = removeWrappedLines(continuous_data.time,bump_pos');
plot(x_out_bump,bump_to_plot,'LineWidth',1.5)
hold on
heading = wrapTo180(-continuous_data.heading_deg);
combined_heading = deg2rad(heading);
combined_heading_thresh = combined_heading(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds > 25);
heading_precision_combined = circ_r(combined_heading_thresh);
%store a version of the heading precision in the two halves of the block
heading_first_half = deg2rad(heading(1:floor(length(heading)/2)));
adj_rs_first_half = continuous_data.adj_rs(1:floor(length(heading)/2));
total_mvt_first_half = continuous_data.total_mvt_ds(1:floor(length(heading)/2));
heading_first_half_thresh = heading_first_half(adj_rs_first_half > 0.5 & total_mvt_first_half > 25);
heading_precision_combined_first_half = circ_r(heading_first_half_thresh);
heading_second_half = deg2rad(heading(end-floor(length(heading)/2):end));
adj_rs_second_half = continuous_data.adj_rs(end-floor(length(heading)/2):end);
total_mvt_second_half = continuous_data.total_mvt_ds(end-floor(length(heading)/2):end);
heading_second_half_thresh = heading_second_half(adj_rs_second_half > 0.5 & total_mvt_second_half > 25);
heading_precision_combined_second_half = circ_r(heading_second_half_thresh);

[x_out_heading,heading_to_plot] = removeWrappedLines(continuous_data.time,heading);
plot(x_out_heading,heading_to_plot,'LineWidth',1.5)
title('Bump and fly position');
legend('Bump estimate','Fly position','Location','Best');
set(gca,'xticklabel',{[]});
ylim([-180 180]);
xlim([0 x_out_heading(end)]);

subplot(5,1,3)
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
%store offset for later
combined_offset_above_thresh = deg2rad(offset(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25));
[~, offset_var_combined] = circ_std(combined_offset_above_thresh);
offset_precision_combined = circ_r(combined_offset_above_thresh);
%store a version of the offset precision in the two halves of the block
offset_first_half = deg2rad(offset(1:floor(length(offset)/2)));
adj_rs_first_half = continuous_data.adj_rs(1:floor(length(offset)/2));
total_mvt_first_half = continuous_data.total_mvt_ds(1:floor(length(offset)/2));
offset_first_half_thresh = offset_first_half(adj_rs_first_half > 0.5 & total_mvt_first_half > 25);
offset_precision_combined_first_half = circ_r(offset_first_half_thresh);
offset_second_half = deg2rad(offset(end-floor(length(offset)/2):end));
adj_rs_second_half = continuous_data.adj_rs(end-floor(length(offset)/2):end);
total_mvt_second_half = continuous_data.total_mvt_ds(end-floor(length(offset)/2):end);
offset_second_half_thresh = offset_second_half(adj_rs_second_half > 0.5 & total_mvt_second_half > 25);
offset_precision_combined_second_half = circ_r(offset_second_half_thresh);

[x_out_offset,offset_to_plot] = removeWrappedLines(continuous_data.time,offset);
plot(x_out_offset,offset_to_plot,'LineWidth',1.5,'color','k')
title('Offset');
ylim([-180 180]);
xlim([0 x_out_offset(end-1)]);

subplot(5,1,4)
plot(continuous_data.time(continuous_data.adj_rs>=0.5),continuous_data.bump_magnitude(continuous_data.adj_rs>=0.5),'r.')
hold on
plot(continuous_data.time(continuous_data.adj_rs<0.5),continuous_data.bump_magnitude(continuous_data.adj_rs<0.5),'k.')
title('Bump magnitude');
xlim([0 continuous_data.time(end)]);

subplot(5,1,5)
plot(continuous_data.time(continuous_data.adj_rs>=0.5),continuous_data.bump_width(continuous_data.adj_rs>=0.5),'r.')
hold on
plot(continuous_data.time(continuous_data.adj_rs<0.5),continuous_data.bump_width(continuous_data.adj_rs<0.5),'k.')
title('Bump width');
xlim([0 continuous_data.time(end)]);

suptitle('Trial with both cues');

saveas(gcf,[path,'\analysis\continuous_plots\cue_combination_full_experiment.png']);

%% Bump parameters

%Get mean bump parameters
meanBM_thresh_combined = mean(continuous_data.bump_magnitude(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25));
meanBW_thresh_combined = mean(continuous_data.bump_width(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25));

%Get mean vel
mean_total_mvt_thresh_combined = nanmean(continuous_data.total_mvt_ds(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25));

%Store all bump param and mvt values
allBumpMag = [allBumpMag,continuous_data.bump_magnitude];
allBumpWidth = [allBumpWidth,continuous_data.bump_width];
allTotalMvt = [allTotalMvt,continuous_data.total_mvt_ds];
allYawSpeed = [allYawSpeed,abs(continuous_data.vel_yaw_ds)];
allVelFor = [allVelFor,continuous_data.vel_for_ds'];
blockType = [blockType,repelem(3,1,length(continuous_data.bump_magnitude))];

%% Analyze final closed-loop panels

%% Full experiment analysis

load([path,'\analysis\continuous_analysis_sid_',num2str(sessions.final_cl_bar),'_tid_0.mat'])

figure('Position',[100 100 1200 800]),
subplot(5,1,1)
dff = continuous_data.dff_matrix';
imagesc(flip(dff))
colormap(flipud(gray))
title('EPG activity');
set(gca,'xticklabel',{[]})

subplot(5,1,2)
bump_pos = wrapTo180(rad2deg(continuous_data.bump_pos));
%Remove wrapped lines to plot
[x_out_bump,bump_to_plot] = removeWrappedLines(continuous_data.time,bump_pos');
plot(x_out_bump,bump_to_plot,'LineWidth',1.5)
hold on
heading = wrapTo180(-continuous_data.heading_deg);
post_panels_heading = deg2rad(heading);
post_panels_heading_thresh = post_panels_heading(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25);
heading_precision_post_panels = circ_r(post_panels_heading_thresh);
[x_out_heading,heading_to_plot] = removeWrappedLines(continuous_data.time,heading);
plot(x_out_heading,heading_to_plot,'LineWidth',1.5)
title('Bump and fly position');
legend('Bump estimate','Fly position','Location','best')
ylim([-180 180]);
set(gca,'xticklabel',{[]})

subplot(5,1,3)
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
%store offset for later
post_panels_offset_above_thresh = deg2rad(offset(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25));
[~, offset_var_post_panels] = circ_std(post_panels_offset_above_thresh);
offset_precision_post_panels = circ_r(post_panels_offset_above_thresh);
[x_out_offset,offset_to_plot] = removeWrappedLines(continuous_data.time,offset);
plot(x_out_offset,offset_to_plot,'LineWidth',1.5,'color','k')
title('Offset')
ylim([-180 180]);
set(gca,'xticklabel',{[]})

subplot(5,1,4)
plot(continuous_data.time(continuous_data.adj_rs>=0.5),continuous_data.bump_magnitude(continuous_data.adj_rs>=0.5),'r.')
hold on
plot(continuous_data.time(continuous_data.adj_rs<0.5),continuous_data.bump_magnitude(continuous_data.adj_rs<0.5),'k.')
title('Bump magnitude')

subplot(5,1,5)
plot(continuous_data.time(continuous_data.adj_rs>=0.5),continuous_data.bump_width(continuous_data.adj_rs>=0.5),'r.')
hold on
plot(continuous_data.time(continuous_data.adj_rs<0.5),continuous_data.bump_width(continuous_data.adj_rs<0.5),'k.')
title('Bump width')

suptitle('Final trial with just panels');

saveas(gcf,[path,'\analysis\continuous_plots\final_panels_full_experiment.png']);

%% Bump parameters

%Get mean bump parameters
meanBM_thresh_post_panels = nanmean(continuous_data.bump_magnitude(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds > 25));
meanBW_thresh_post_panels = nanmean(continuous_data.bump_width(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds > 25));

%Get fly vel
mean_total_mvt_thresh_post_panels = nanmean(continuous_data.total_mvt_ds(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds > 25));

%Store all bump param and mvt values
allBumpMag = [allBumpMag,continuous_data.bump_magnitude];
allBumpWidth = [allBumpWidth,continuous_data.bump_width];
allTotalMvt = [allTotalMvt,continuous_data.total_mvt_ds];
allYawSpeed = [allYawSpeed,abs(continuous_data.vel_yaw_ds)];
allVelFor = [allVelFor,continuous_data.vel_for_ds'];
blockType = [blockType,repelem(4,1,length(continuous_data.bump_magnitude))];

%%  Analyze final closed-loop wind

%% Full experiment analysis

load([path,'\analysis\continuous_analysis_sid_',num2str(sessions.final_cl_wind),'_tid_0.mat'])

figure('Position',[100 100 1200 800]),
subplot(5,1,1)
dff = continuous_data.dff_matrix';
imagesc(flip(dff))
colormap(flipud(gray))
title('EPG activity');
set(gca,'xticklabel',{[]})

subplot(5,1,2)
bump_pos = wrapTo180(rad2deg(continuous_data.bump_pos));
%Remove wrapped lines to plot
[x_out_bump,bump_to_plot] = removeWrappedLines(continuous_data.time,bump_pos');
plot(x_out_bump,bump_to_plot,'LineWidth',1.5)
hold on
heading = wrapTo180(-continuous_data.heading_deg);
post_wind_heading = deg2rad(heading);
post_wind_heading_thresh = post_wind_heading(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds > 25);
heading_precision_post_wind = circ_r(post_wind_heading_thresh);
[x_out_heading,heading_to_plot] = removeWrappedLines(continuous_data.time,heading);
plot(x_out_heading,heading_to_plot,'LineWidth',1.5)
title('Bump and fly position');
legend('Bump estimate','Fly position','Location','best')
ylim([-180 180]);
set(gca,'xticklabel',{[]})

subplot(5,1,3)
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
%store offset for later
post_wind_offset_above_thresh = deg2rad(offset(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds > 25));
[~, offset_var_post_wind] = circ_std(post_wind_offset_above_thresh);
offset_precision_post_wind = circ_r(post_wind_offset_above_thresh);
[x_out_offset,offset_to_plot] = removeWrappedLines(continuous_data.time,offset);
plot(x_out_offset,offset_to_plot,'LineWidth',1.5,'color','k')
title('Offset')
ylim([-180 180]);
set(gca,'xticklabel',{[]})

subplot(5,1,4)
plot(continuous_data.time(continuous_data.adj_rs>=0.5),continuous_data.bump_magnitude(continuous_data.adj_rs>=0.5),'r.')
hold on
plot(continuous_data.time(continuous_data.adj_rs<0.5),continuous_data.bump_magnitude(continuous_data.adj_rs<0.5),'k.')
title('Bump magnitude')

subplot(5,1,5)
plot(continuous_data.time(continuous_data.adj_rs>=0.5),continuous_data.bump_width(continuous_data.adj_rs>=0.5),'r.')
hold on
plot(continuous_data.time(continuous_data.adj_rs<0.5),continuous_data.bump_width(continuous_data.adj_rs<0.5),'k.')
title('Bump width')

suptitle('Final trial with just wind');

saveas(gcf,[path,'\analysis\continuous_plots\final_wind_full_experiment.png']);

%% Bump parameters

%Get mean bump parameters
meanBM_thresh_post_wind = nanmean(continuous_data.bump_magnitude(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds > 25));
meanBW_thresh_post_wind = nanmean(continuous_data.bump_width(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds > 25));

%Get fly vel
mean_total_mvt_thresh_post_wind = nanmean(continuous_data.total_mvt_ds(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds > 25));

%Store all bump param and mvt values
allBumpMag = [allBumpMag,continuous_data.bump_magnitude];
allBumpWidth = [allBumpWidth,continuous_data.bump_width];
allTotalMvt = [allTotalMvt,continuous_data.total_mvt_ds];
allYawSpeed = [allYawSpeed,abs(continuous_data.vel_yaw_ds)];
allVelFor = [allVelFor,continuous_data.vel_for_ds'];
blockType = [blockType,repelem(5,1,length(continuous_data.bump_magnitude))];

%% Offset and heading precision

%Combine data
if sessions.initial_cl_wind < sessions.initial_cl_bar
    
    offset_precision = [offset_precision_pre_wind,offset_precision_pre_panels,offset_precision_combined,offset_precision_post_wind,offset_precision_post_panels];
    offset_precision_6_blocks = [offset_precision_pre_wind,offset_precision_pre_panels,offset_precision_combined_first_half,offset_precision_combined_second_half,offset_precision_post_wind,offset_precision_post_panels];
    heading_precision = [heading_precision_pre_wind,heading_precision_pre_panels,heading_precision_combined,heading_precision_post_wind,heading_precision_post_panels];    
    heading_precision_6_blocks = [heading_precision_pre_wind,heading_precision_pre_panels,heading_precision_combined_first_half,heading_precision_combined_second_half,heading_precision_post_wind,heading_precision_post_panels];    
    
elseif sessions.initial_cl_wind > sessions.initial_cl_bar
    
    offset_precision = [offset_precision_pre_panels,offset_precision_pre_wind,offset_precision_combined,offset_precision_post_panels,offset_precision_post_wind];
    offset_precision_6_blocks = [offset_precision_pre_panels,offset_precision_pre_wind,offset_precision_combined_first_half,offset_precision_combined_second_half,offset_precision_post_panels,offset_precision_post_wind];     
    heading_precision = [heading_precision_pre_panels,heading_precision_pre_wind,heading_precision_combined,heading_precision_post_panels,heading_precision_post_wind];
    heading_precision_6_blocks = [heading_precision_pre_panels,heading_precision_pre_wind,heading_precision_combined_first_half,heading_precision_combined_second_half,heading_precision_post_panels,heading_precision_post_wind];     
end

%Plot offset precision per block
figure,
subplot(1,2,1)
plot(offset_precision,'-ko');
ylabel('Offset precision');
xlabel('Block #');
xlim([0 6]); ylim([0 1]);

subplot(1,2,2)
plot(offset_precision_6_blocks,'-ko');
ylabel('Offset precision');
xlabel('Block #');
xlim([0 7]); ylim([0 1]);

saveas(gcf,[path,'\analysis\continuous_plots\offset_precision_per_block.png']);

%Plot heading precision per plot
figure,
subplot(1,2,1)
plot(heading_precision,'-ko');
ylabel('Heading precision');
xlabel('Block #');
xlim([0 6]); ylim([0 1]);

subplot(1,2,2)
plot(heading_precision_6_blocks,'-ko');
ylabel('Heading precision');
xlabel('Block #');
xlim([0 7]); ylim([0 1]);

saveas(gcf,[path,'\analysis\continuous_plots\heading_precision_per_block.png']);

%% Get circ_mean of offset per block

if sessions.initial_cl_wind < sessions.initial_cl_bar
    
    offset_mean = [circ_mean(pre_wind_offset_above_thresh),circ_mean(pre_panels_offset_above_thresh),circ_mean(combined_offset_above_thresh),circ_mean(post_wind_offset_above_thresh),circ_mean(post_panels_offset_above_thresh)];
    
elseif sessions.initial_cl_wind > sessions.initial_cl_bar
    
    offset_mean = [circ_mean(pre_panels_offset_above_thresh),circ_mean(pre_wind_offset_above_thresh),circ_mean(combined_offset_above_thresh),circ_mean(post_panels_offset_above_thresh),circ_mean(post_wind_offset_above_thresh)];
    
end

%% Plot offset evolution with overlaid mean

if sessions.initial_cl_wind > sessions.initial_cl_bar
    
    figure('Position',[100 100 1400 400]),
    
    subplot(1,5,1)
    polarhistogram(pre_panels_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([offset_mean(1),offset_mean(1)],[0,rl(2)*offset_precision_pre_panels],'k','linewidth',3)
    title('Initial visual offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,2)
    polarhistogram(pre_wind_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([offset_mean(2),offset_mean(2)],[0,rl(2)*offset_precision_pre_wind],'k','linewidth',3)
    title('Initial wind offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,3)
    polarhistogram(combined_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([offset_mean(3),offset_mean(3)],[0,rl(2)*offset_precision_combined],'k','linewidth',3)
    title('Cue combination offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,4)
    polarhistogram(post_panels_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([offset_mean(4),offset_mean(4)],[0,rl(2)*offset_precision_post_panels],'k','linewidth',3)
    title('Final visual offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,5)
    polarhistogram(post_wind_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([offset_mean(5),offset_mean(5)],[0,rl(2)*offset_precision_post_wind],'k','linewidth',3)
    title('Final wind offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
else
    
    figure('Position',[100 100 1400 400]),
    
    subplot(1,5,1)
    polarhistogram(pre_wind_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([offset_mean(1),offset_mean(1)],[0,rl(2)*offset_precision_pre_wind],'k','linewidth',3)
    title('Initial wind offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,2)
    polarhistogram(pre_panels_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([offset_mean(2),offset_mean(2)],[0,rl(2)*offset_precision_pre_panels],'k','linewidth',3)
    title('Initial visual offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,3)
    polarhistogram(combined_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([offset_mean(3),offset_mean(3)],[0,rl(2)*offset_precision_combined],'k','linewidth',3)
    title('Cue combination offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,4)
    polarhistogram(post_wind_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([offset_mean(4),offset_mean(4)],[0,rl(2)*offset_precision_post_wind],'k','linewidth',3)
    title('Final wind offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,5)
    polarhistogram(post_panels_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([offset_mean(5),offset_mean(5)],[0,rl(2)*offset_precision_post_panels],'k','linewidth',3)
    title('Final visual offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
end

saveas(gcf,[path,'\analysis\continuous_plots\offset_evo_with_mean.png']);

%% Get circ_mean of heading per block

if sessions.initial_cl_wind < sessions.initial_cl_bar
    
    heading_mean = [circ_mean(pre_wind_heading_thresh),circ_mean(pre_panels_heading_thresh),circ_mean(combined_heading_thresh),circ_mean(post_wind_heading_thresh),circ_mean(post_panels_heading_thresh)];
    
elseif sessions.initial_cl_wind > sessions.initial_cl_bar
    
    heading_mean = [circ_mean(pre_panels_heading_thresh),circ_mean(pre_wind_heading_thresh),circ_mean(combined_heading_thresh),circ_mean(post_panels_heading_thresh),circ_mean(post_wind_heading_thresh)];
     
end

%% Overlay heading mean over heading evolution plot

if sessions.initial_cl_wind > sessions.initial_cl_bar
    
    figure('Position',[100 100 1400 400]),
    
    subplot(1,5,1)
    polarhistogram(pre_panels_heading_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([heading_mean(1),heading_mean(1)],[0,rl(2)*heading_precision_pre_panels],'k','linewidth',3)
    title('Initial visual heading','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,2)
    polarhistogram(pre_wind_heading_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([heading_mean(2),heading_mean(2)],[0,rl(2)*heading_precision_pre_wind],'k','linewidth',3)
    title('Initial wind heading','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,3)
    polarhistogram(combined_heading_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([heading_mean(3),heading_mean(3)],[0,rl(2)*heading_precision_combined],'k','linewidth',3)
    title('Cue combination heading','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,4)
    polarhistogram(post_panels_heading_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([heading_mean(4),heading_mean(4)],[0,rl(2)*heading_precision_post_panels],'k','linewidth',3)
    title('Final visual heading','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,5)
    polarhistogram(post_wind_heading_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([heading_mean(5),heading_mean(5)],[0,rl(2)*heading_precision_post_wind],'k','linewidth',3)
    title('Final wind heading','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
else
    
    figure('Position',[100 100 1400 400]),
    
    subplot(1,5,1)
    polarhistogram(pre_wind_heading_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([heading_mean(1),heading_mean(1)],[0,rl(2)*heading_precision_pre_wind],'k','linewidth',2)
    title('Initial wind heading','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,2)
    polarhistogram(pre_panels_heading_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([heading_mean(2),heading_mean(2)],[0,rl(2)*heading_precision_pre_panels],'k','linewidth',2)
    title('Initial visual heading','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,3)
    polarhistogram(combined_heading_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([heading_mean(3),heading_mean(3)],[0,rl(2)*heading_precision_combined],'k','linewidth',2)
    title('Cue combination heading','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,4)
    polarhistogram(post_wind_heading_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([heading_mean(4),heading_mean(4)],[0,rl(2)*heading_precision_post_wind],'k','linewidth',2)
    title('Final wind heading','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,5)
    polarhistogram(post_panels_heading_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color)
    hold on
    rl = rlim;
    polarplot([heading_mean(5),heading_mean(5)],[0,rl(2)*heading_precision_post_panels],'k','linewidth',2)
    title('Final visual heading','fontsize',12);
    set(gca,'ThetaZeroLocation','top');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
end

saveas(gcf,[path,'\analysis\continuous_plots\heading_evo_with_mean.png']);

%%  Bump parameter evolution using threshold

if sessions.initial_cl_wind < sessions.initial_cl_bar
    allBM_thresh = [meanBM_thresh_pre_wind;meanBM_thresh_pre_panels;meanBM_thresh_combined;meanBM_thresh_post_wind;meanBM_thresh_post_panels];
    allBW_thresh = [meanBW_thresh_pre_wind;meanBW_thresh_pre_panels;meanBW_thresh_combined;meanBW_thresh_post_wind;meanBW_thresh_post_panels];
    all_total_mvt_thresh = [mean_total_mvt_thresh_pre_wind;mean_total_mvt_thresh_pre_panels;mean_total_mvt_thresh_combined;mean_total_mvt_thresh_post_wind;mean_total_mvt_thresh_post_panels];
elseif sessions.initial_cl_wind > sessions.initial_cl_bar
    allBM_thresh = [meanBM_thresh_pre_panels;meanBM_thresh_pre_wind;meanBM_thresh_combined;meanBM_thresh_post_panels;meanBM_thresh_post_wind];  
    allBW_thresh = [meanBW_thresh_pre_panels;meanBW_thresh_pre_wind;meanBW_thresh_combined;meanBW_thresh_post_panels;meanBW_thresh_post_wind]; 
    all_total_mvt_thresh = [mean_total_mvt_thresh_pre_panels;mean_total_mvt_thresh_pre_wind;mean_total_mvt_thresh_combined;mean_total_mvt_thresh_post_panels;mean_total_mvt_thresh_post_wind]; 
end

figure('Position',[100 100 1000 600]),
subplot(1,2,1)
yyaxis left
plot(allBM_thresh,'-o')
ylim([0 3]);
ylabel('Bump magnitude');
yyaxis right
plot(all_total_mvt_thresh,'-o')
xlim([0 6]);
ylim([0 300]);
ylabel('Total movement (deg/s)');
xlabel('Block #');

subplot(1,2,2)
yyaxis left
plot(allBW_thresh,'-o')
ylim([0 3.5]);
ylabel('Bump width');
yyaxis right
plot(all_total_mvt_thresh,'-o')
xlim([0 6]);
ylim([0 300]);

saveas(gcf,[path,'\analysis\continuous_plots\bump_par_evolution_thresh.png']);

%% Link plasticity to initial differences between bar and wind offset

initial_cue_diff = rad2deg(circ_dist(circ_mean(pre_wind_offset_above_thresh),circ_mean(pre_panels_offset_above_thresh)));
bar_offset_diff = rad2deg(circ_dist(circ_mean(pre_panels_offset_above_thresh),circ_mean(post_panels_offset_above_thresh)));
wind_offset_diff = rad2deg(circ_dist(circ_mean(pre_wind_offset_above_thresh),circ_mean(post_wind_offset_above_thresh)));

%% Determine and save configuration

if sessions.initial_cl_wind > sessions.initial_cl_bar
    configuration = 1;
else
    configuration = 2;
end

%% Combine certain variables in table

summary_data = table(allBumpMag',allBumpWidth',allTotalMvt',allYawSpeed',allVelFor',blockType','VariableNames',{'BumpMag','BumpWidth','TotalMvt','YawSpeed','ForVel','BlockType'});

%% Save variables

save([path,'\analysis\data.mat'],'summary_data','offset_precision','offset_precision_6_blocks','heading_precision','heading_precision_6_blocks','offset_mean','heading_mean','allBM_thresh','allBW_thresh','all_total_mvt_thresh','initial_cue_diff','bar_offset_diff','wind_offset_diff','configuration')

%% Clear

close all; clear all