%analysis for the closed-loop bouts of the change in contrast experiment

%% Load data

clear all; close all;

path = uigetdir('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data');

%Find and load the gain change trial
sessions_info = load([path,'\sessions_info.mat']);
sid = sessions_info.sessions_info.gain_change;
load([path,'\analysis\continuous_analysis_sid_',num2str(sid),'_tid_0.mat']);

%% Make directory to save plots

%Move to the analysis folder
%List the contents
contents = dir([path,'\analysis\']);
%if there isn't a 'plots' folder already, create one
if (contains([contents.name],'continuous_plots') == 0)
   mkdir(path,'\analysis\continuous_plots'); 
end

%% Determine changes in gain

gain_changes = [1837,9183]; %the gain changes occurred always in those frames

%% Extract and save movement data

for_vel = continuous_data.vel_for_ds;
yaw_speed = abs(continuous_data.vel_yaw_ds);
total_mvt = continuous_data.total_mvt_ds;

movementData = table(for_vel,yaw_speed',total_mvt','VariableNames',{'for_vel','yaw_speed','total_mvt'});

%% Set block limits

blockLimits{1} = [1,gain_changes(1)-1];
blockLimits{2} = [gain_changes(1),gain_changes(2)];
blockLimits{3} = [gain_changes(2)+1,length(continuous_data.time)];

%Define gain per block
gain_per_block = [1,-1,1];

%Set color palette based on gain
for block = 1:3
    if gain_per_block(block) == 1
        color_gradient{block} = [.4 0.1 0.1];
    else
        color_gradient{block} = [.1 0.4 0.2];
    end
end

%% Compute heading offset variability

%Compute heading offset
heading_offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
[x_out_heading_offset, heading_offset_to_plot] = removeWrappedLines(continuous_data.time,heading_offset);

%I will analyze offset variability by computing a rolling window of circular
%standard deviation of offset and taking the inverse
fcn = @(x) adapted_circ_std(x);
fcn_precision = @(x) circ_r(x);
%Compute the offset variability and precision over different window sizes, from 1 s to
%50 s
window_sizes = [10,30,50,100,200,500];
for window = 1:length(window_sizes)
    heading_offset_variability(:,window) = matlab.tall.movingWindow(fcn,window_sizes(window),deg2rad(heading_offset));
    heading_offset_precision(:,window) = matlab.tall.movingWindow(fcn_precision,window_sizes(window),deg2rad(heading_offset));    
end
smoothed_heading_offset_variability = smooth(heading_offset_variability(:,3),150,'rloess');

figure('Position',[100 100 1600 400]),
subplot(3,1,1)
plot(x_out_heading_offset,heading_offset_to_plot,'k')
hold on
for change = 1:length(gain_changes)
    line([continuous_data.time(gain_changes(change)) continuous_data.time(gain_changes(change))], [-180 180], 'LineWidth', 2, 'color', [0, 0.5, 0]);
end
ylim([-180 180]);
title('Heading offset');
set(gca,'xticklabel',{[]});

subplot(3,1,2)
plot(continuous_data.time,heading_offset_variability(:,3),'k')
hold on
for change = 1:length(gain_changes)
    line([continuous_data.time(gain_changes(change)) continuous_data.time(gain_changes(change))], [0 4], 'LineWidth', 2, 'color', [0, 0.5, 0]);
end
title('Heading offset variability');
set(gca,'xticklabel',{[]});

subplot(3,1,3)
plot(continuous_data.time,smoothed_heading_offset_variability,'k')
hold on
for change = 1:length(gain_changes)
    line([continuous_data.time(gain_changes(change)) continuous_data.time(gain_changes(change))], [0 2], 'LineWidth', 2, 'color', [0, 0.5, 0]);
end
title('Smoothed heading offset variability');
xlabel('Time (sec)');

%save figure
saveas(gcf,[path,'\analysis\continuous_plots\heading_offset_var.png']);

%% Repeat for bar offset

bar_offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',deg2rad(continuous_data.visual_stim_pos))));
[x_out_offset, offset_to_plot] = removeWrappedLines(continuous_data.time,bar_offset);

for window = 1:length(window_sizes)
    bar_offset_variability(:,window) = matlab.tall.movingWindow(fcn,window_sizes(window),deg2rad(bar_offset));
    bar_offset_precision(:,window) = matlab.tall.movingWindow(fcn_precision,window_sizes(window),deg2rad(bar_offset));    
end
smoothed_bar_offset_variability = smooth(bar_offset_variability(:,3),150,'rloess');


figure('Position',[100 100 1600 400]),
subplot(3,1,1)
plot(x_out_offset,offset_to_plot,'k')
hold on
for change = 1:length(gain_changes)
    line([continuous_data.time(gain_changes(change)) continuous_data.time(gain_changes(change))], [-180 180], 'LineWidth', 2, 'color', [0, 0.5, 0]);
end
ylim([-180 180]);
title('Bar offset');
set(gca,'xticklabel',{[]});

subplot(3,1,2)
plot(continuous_data.time,bar_offset_variability(:,3),'k')
hold on
for change = 1:length(gain_changes)
    line([continuous_data.time(gain_changes(change)) continuous_data.time(gain_changes(change))], [0 2], 'LineWidth', 2, 'color', [0, 0.5, 0]);
end
title('Bar offset variability');
set(gca,'xticklabel',{[]});

subplot(3,1,3)
plot(continuous_data.time,smoothed_bar_offset_variability,'k')
hold on
for change = 1:length(gain_changes)
    line([continuous_data.time(gain_changes(change)) continuous_data.time(gain_changes(change))], [0 2], 'LineWidth', 2, 'color', [0, 0.5, 0]);
end
title('Smoothed bar offset variability');
xlabel('Time (sec)');

%save figure
saveas(gcf,[path,'\analysis\continuous_plots\bar_offset_var.png']);
    
%% Obtain bump parameters

%Bump magnitude
allBumpMag = [];
for block = 1:length(blockLimits)
   bump_mag{block} = continuous_data.bump_magnitude(1,blockLimits{block}(1):blockLimits{block}(2)); 
   allBumpMag = [allBumpMag,bump_mag{block}];
end

%Bump width at half max
allBumpWidth = [];
for block = 1:length(blockLimits)
   bump_width{block} = continuous_data.bump_width(blockLimits{block}(1):blockLimits{block}(2)); 
   allBumpWidth = [allBumpWidth,bump_width{block}];
end

%% Get goodness of fit

all_adj_rs = [];
for block = 1:length(blockLimits)
   adj_rs{block} = continuous_data.adj_rs(blockLimits{block}(1):blockLimits{block}(2)); 
   all_adj_rs = [all_adj_rs,adj_rs{block}];
end

%% Heatmap plot with heading offset var including bump magnitude

% Plot the heatmap of EPG activity
figure('Position',[100 100 1400 800]),
subplot(5,1,1)
%I'm flipping the dff matrix for it to make sense along with the fly's
%heading
imagesc(flip(continuous_data.dff_matrix'))
colormap(flipud(gray))
hold on
%add the changes in stim
for change = 1:length(gain_changes)
    line([gain_changes(change) gain_changes(change)], [0 size(continuous_data.dff_matrix,2)], 'LineWidth', 2, 'color', [0, 0.5, 0]);
end
ylabel('PB glomerulus','fontsize',10);
title('EPG activity in the PB','fontsize',12);
set(gca,'XTickLabel',[]);
legend('Change in stimulus');

% Plot the bar position and the EPG phase
subplot(5,1,2)
%Get heading position to plot
heading = wrapTo180(-continuous_data.heading_deg);
[x_out_heading, heading_to_plot] = removeWrappedLines(continuous_data.time,heading);
plot(x_out_heading,heading_to_plot,'color',[0.6 0.3 0.8],'LineWidth',1.5)
hold on
phase = wrapTo180(rad2deg(continuous_data.bump_pos'));
[x_out_phase, phase_to_plot] = removeWrappedLines(continuous_data.time,phase);
plot(x_out_phase,phase_to_plot,'color',[0.9 0.3 0.4],'LineWidth',1.5)
%add the changes in stim
for change = 1:length(gain_changes)
    line([continuous_data.time(gain_changes(change)) continuous_data.time(gain_changes(change))], [-180 180], 'LineWidth', 2, 'color',  [0, 0.5, 0]);
end
legend('Fly heading', 'EPG phase');
title('EPG phase and fly heading','fontweight','bold','fontsize',12);
ylim([-180, 180]);
xlim([0,continuous_data.time(end)]);
ylabel('Deg','fontweight','bold','fontsize',10);
set(gca,'XTickLabel',[]);

% Plot the offset
subplot(5,1,3)
plot(x_out_heading_offset,heading_offset_to_plot,'LineWidth',1.5,'color','k')
%Add the changes in stim
for change = 1:length(gain_changes)
    line([continuous_data.time(gain_changes(change)) continuous_data.time(gain_changes(change))], [-180 180], 'LineWidth', 2, 'color',  [0, 0.5, 0]);
end
ylim([-180 180]);
ylabel('Deg','fontweight','bold','fontsize',10);
set(gca,'XTickLabel',[]);
title('Heading offset','fontweight','bold','fontsize',12);

%Plot the bump magnitude
subplot(5,1,4)
for block = 1:length(blockLimits)
    plot(continuous_data.time(blockLimits{block}(1):blockLimits{block}(2)),smooth(bump_mag{block}),'color',color_gradient{block},'linewidth',1.5)
    hold on
end
title('Bump magnitude','fontweight','bold','fontsize',12);
ylabel('Bump magnitude (DF/F)','fontweight','bold','fontsize',10);
set(gca,'xticklabel',{[]});
xlim([0 continuous_data.time(end)]);

subplot(5,1,5)
for block = 1:length(blockLimits)
    plot(continuous_data.time(blockLimits{block}(1):blockLimits{block}(2)),smooth(bump_width{block}),'color',color_gradient{block},'linewidth',1.5)
    hold on
end
title('Bump width','fontweight','bold','fontsize',12);
ylabel('Bump width (rad)','fontweight','bold','fontsize',10);
xlabel('Time (sec)','fontweight','bold','fontsize',10);
xlim([0 continuous_data.time(end)]);

%save figure
saveas(gcf,[path,'\analysis\continuous_plots\heading_offset_with_bump_parameters.png']);
    
%% Repeat for bar offset variability
    
% Plot the heatmap of EPG activity
figure('Position',[100 100 1400 800]),
subplot(5,1,1)
imagesc(flip(continuous_data.dff_matrix'))
colormap(flipud(gray))
hold on
%Add the changes in stim
for change = 1:length(gain_changes)
    line([gain_changes(change) gain_changes(change)], [0 size(continuous_data.dff_matrix,2)], 'LineWidth', 2, 'color', [0,0.5,0]);
end
ylabel('PB glomerulus','fontsize',10);
title('EPG activity in the PB','fontweight','bold','fontsize',12);
set(gca,'XTickLabel',[]);
legend('Change in stimulus');

% Plot the bar position and the EPG phase
subplot(5,1,2)
bar_position = wrapTo180(continuous_data.visual_stim_pos);
[x_out_bar, bar_pos_to_plot] = removeWrappedLines(continuous_data.time,bar_position);
plot(x_out_bar,bar_pos_to_plot,'color',[0.2 0.6 0.7],'LineWidth',1.5)
hold on
%Get EPG phase to plot
phase = wrapTo180(rad2deg(continuous_data.bump_pos'));
[x_out_phase,phase_to_plot] = removeWrappedLines(continuous_data.time,phase);
plot(x_out_phase,phase_to_plot,'color',[0.9 0.3 0.4],'LineWidth',1.5)
%Add the changes in stim
for change = 1:length(gain_changes)
    line([continuous_data.time(gain_changes(change)) continuous_data.time(gain_changes(change))], [-180 180], 'LineWidth', 2, 'color', [0,0.5,0]);
end
legend('Bar position', 'EPG phase');
title('EPG phase and bar position','fontweight','bold','fontsize',12);
ylim([-180, 180]);
xlim([0,continuous_data.time(end)]);
ylabel('Deg','fontweight','bold','fontsize',10);
set(gca,'XTickLabel',[]);

% Plot the offset
subplot(5,1,3)
plot(x_out_offset,offset_to_plot,'LineWidth',1.5,'color','k')
%Add the changes in stim
for change = 1:length(gain_changes)
    line([continuous_data.time(gain_changes(change)) continuous_data.time(gain_changes(change))], [-180 180], 'LineWidth', 2, 'color', [0,0.5,0]);
end
ylim([-180 180]);
title('Bar offset','fontweight','bold','fontsize',12);
ylabel('Deg','fontweight','bold','fontsize',10);

%Plot the bump magnitude
subplot(5,1,4)
for block = 1:length(blockLimits)
    plot(continuous_data.time(blockLimits{block}(1):blockLimits{block}(2)),smooth(bump_mag{block}),'color',color_gradient{block},'linewidth',1.5)
    hold on
end
title('Bump magnitude','fontweight','bold','fontsize',12);
ylabel('Bump magnitude (DF/F)','fontweight','bold','fontsize',10);
set(gca,'xticklabel',{[]});
xlim([0 continuous_data.time(end)]);

subplot(5,1,5)
for block = 1:length(blockLimits)
    plot(continuous_data.time(blockLimits{block}(1):blockLimits{block}(2)),smooth(bump_width{block}),'color',color_gradient{block},'linewidth',1.5)
    hold on
end
title('Bump width','fontweight','bold','fontsize',12);
ylabel('Bump width (rad)','fontweight','bold','fontsize',10);
xlabel('Time (sec)','fontweight','bold','fontsize',10);
xlim([0 continuous_data.time(end)]);

%Save figure
saveas(gcf,[path,'\analysis\continuous_plots\bar_offset_with_bump_parameters.png']);

% 
% %% Zooming in (uncomment if trying to plot this)
% 
% sec_to_frames = (gain_changes(2)-gain_changes(1))/800;
% frames_to_sec = 800/(gain_changes(2)-gain_changes(1));
% 
% 
% %plot heading, bar and bump for good learners
% figure('Position',[100 100 1600 400]),
% 
% subplot(2,1,1)
% plot(phase,'.')
% hold on
% plot(heading,'.')
% plot(bar_position,'.')
% legend('bump','heading','bar')
% xlim([gain_changes(2)-floor(200*sec_to_frames), gain_changes(2)])
% ylim([-180 180]);
% title('Position');
% 
% subplot(2,1,2)
% plot(heading_offset,'.','color',[0.8500 0.3250 0.0980])
% hold on
% plot(bar_offset,'.','color',[0.9290 0.6940 0.1250])
% legend('heading','bar')
% xlim([gain_changes(2)-floor(200*sec_to_frames), gain_changes(2)])
% ylim([-180 180]);
% title('Offset');

% 
% %% cross correlation between stim and fly velocity
% 
% stim_vel = diff(unwrap(deg2rad(bar_position)));
% fly_vel = diff(unwrap(deg2rad(heading)));
% 
% 
% %normal gain period
% [r,lags] = xcorr(stim_vel(1:gain_changes(1)),fly_vel(1:gain_changes(1)));
% 
% figure('Position',[100 100 1200 1000]),
% subplot(2,1,1)
% plot(lags,r)
% title('Normal gain');
% 
% %inverted gain period
% [r,lags] = xcorr(stim_vel(gain_changes(1):gain_changes(2)),fly_vel(gain_changes(1):gain_changes(2)));
% 
% subplot(2,1,2)
% plot(lags,r)
% title('Inverted gain');

% 
% %% distribution of rotational speeds
% 
% figure,
% rot_speed_normal_gain = [abs(continuous_data.vel_yaw_ds(1:gain_changes(1))),abs(continuous_data.vel_yaw_ds(gain_changes(2):end)),];
% h1 = histogram(rot_speed_normal_gain,20);
% hold on
% h2 = histogram(abs(continuous_data.vel_yaw_ds(gain_changes(1):gain_changes(2))),20);
% h1.Normalization = 'probability';
% h2.Normalization = 'probability';
% legend('Normal gain','Inverted gain');
% title('Distribution of rot speed');

%% Determine the type of fly based on the ratio between bar and offset variability

%Compute the variability ratios during the inverted gain period
for window = 1:length(window_sizes)
    ratio_means(window) = mean(bar_offset_variability(blockLimits{1,2}(1):blockLimits{1,2}(2),window))/mean(heading_offset_variability(blockLimits{1,2}(1):blockLimits{1,2}(2),window));
    ratio_medians(window) = median(bar_offset_variability(blockLimits{1,2}(1):blockLimits{1,2}(2),window))/median(heading_offset_variability(blockLimits{1,2}(1):blockLimits{1,2}(2),window));
end

all_ratios = [ratio_means;ratio_medians];

figure,
plot(all_ratios,'-o','linewidth',2)
hold on
yline(1,'r','linewidth',2)
text(0.2,1.2,'Type 1');
text(0.2,0.8,'Type 2');
ylim([0 4]);
xlim([0 3]);
xticks([1 2])
legend({'10 frames','30','50','100','200','500'},'location','best');
xticklabels({'ratio of means','ratio of medians'})
ylabel('Bar offset variability / heading offset variability');
%Save figure
saveas(gcf,[path,'\analysis\continuous_plots\fly_classification.png']);

%Classify fly
if mean(all_ratios) > 1
    type_of_fly = 1; %fly that learns the new mapping (and where heading offset is more stable)
else
    type_of_fly = 2; %fly that ignores proprioceptive cues (and where bar offset is more stable)
end

%% Plot the h and b offset + the ratio of mean offset variabilities + the pre-post for heading offset var in the same plot

figure('Position',[100 100 1600 1000]),
%heading
subplot(6,6,[1 6])
plot(x_out_heading,heading_to_plot,'LineWidth',1.5,'color',[.8 .2 .7])
%Add the changes in stim
for change = 1:length(gain_changes)
    line([continuous_data.time(gain_changes(change)) continuous_data.time(gain_changes(change))], [-180 180], 'LineWidth', 2, 'color',  [0, 0.5, 0]);
end
ylim([-180 180]);
ylabel('Deg','fontweight','bold','fontsize',10);
set(gca,'XTickLabel',[]);
title('Heading','fontweight','bold','fontsize',12);

%heading offset
subplot(6,6,[7 12])
plot(x_out_heading_offset,heading_offset_to_plot,'.','color',[.6 .6 .6])
%Add the changes in stim
for change = 1:length(gain_changes)
    line([continuous_data.time(gain_changes(change)) continuous_data.time(gain_changes(change))], [-180 180], 'LineWidth', 2, 'color',  [0, 0.5, 0]);
end
ylim([-180 180]);
ylabel('Deg','fontweight','bold','fontsize',10);
set(gca,'XTickLabel',[]);
title('Heading offset','fontweight','bold','fontsize',12);

%bar offset
subplot(6,6,[19 24])
%smooth bar position
smooth_bar_pos = smoothdata(continuous_data.visual_stim_pos,'rlowess',25);
%get bar offset to plot
smooth_bar_offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',deg2rad(smooth_bar_pos))));
[x_out_smooth_bar_offset, smooth_bar_offset_to_plot] = removeWrappedLines(continuous_data.time,smooth_bar_offset);
plot(x_out_smooth_bar_offset,smooth_bar_offset_to_plot,'.','color',[.1 .1 .9])
%Add the changes in stim
for change = 1:length(gain_changes)
    line([continuous_data.time(gain_changes(change)) continuous_data.time(gain_changes(change))], [-180 180], 'LineWidth', 2, 'color', [0,0.5,0]);
end
ylim([-180 180]);
title('Bar offset','fontweight','bold','fontsize',12);
ylabel('Deg','fontweight','bold','fontsize',10);

%ratio of b to h offset var in the different quarters
%Heading offset variability
quarter_limits = [gain_changes(1),gain_changes(1)+floor(diff(gain_changes)/4),...
    gain_changes(1)+2*floor(diff(gain_changes)/4),...
    gain_changes(1)+3*floor(diff(gain_changes)/4),...
    gain_changes(2)];

for quarter = 1:4
    
    [~, heading_offset_var(quarter)] = circ_std(deg2rad(heading_offset(quarter_limits(quarter):quarter_limits(quarter+1))));
    [~, bar_offset_var(quarter)] = circ_std(deg2rad(bar_offset(quarter_limits(quarter):quarter_limits(quarter+1))));
    ratio_of_offset_var(quarter) = bar_offset_var(quarter)/heading_offset_var(quarter);
    
    %plot heading offset variability
    subplot(6,6,13+quarter)
    polarhistogram(deg2rad(heading_offset(quarter_limits(quarter):quarter_limits(quarter+1))),15)
    rticklabels({})
    thetaticklabels({})
    title(['Off var = ',num2str(round(heading_offset_var(quarter),2))]);

    %plot bar offset variability
    subplot(6,6,25+quarter)
    polarhistogram(deg2rad(bar_offset(quarter_limits(quarter):quarter_limits(quarter+1))),15)
    rticklabels({})
    thetaticklabels({})
    title(['Off var = ',num2str(round(bar_offset_var(quarter),2))]);
    
end

subplot(6,6,[32 35])
plot(ratio_of_offset_var,'-ko','linewidth',2)
xlim([0.5 4.5]);
title('Bar offset variability / heading offset variability');
xticks([1:4]);
xlabel('Quarter #');

%Save figure
saveas(gcf,[path,'\analysis\continuous_plots\fly_classification_analysis.png']);

%% Heading variability

heading_variability = matlab.tall.movingWindow(fcn,50,deg2rad(heading));
smoothed_heading_variability = smooth(heading_variability,150,'rloess');

figure('Position',[100 100 1600 400]),
subplot(3,1,1)
plot(x_out_heading,heading_to_plot,'k')
hold on
for change = 1:length(gain_changes)
    line([continuous_data.time(gain_changes(change)) continuous_data.time(gain_changes(change))], [-180 180], 'LineWidth', 2, 'color', [0,0.5,0]);
end
ylim([-180 180]);
title('Heading');

subplot(3,1,2)
plot(continuous_data.time,smooth(heading_variability),'k')
hold on
for change = 1:length(gain_changes)
    line([continuous_data.time(gain_changes(change)) continuous_data.time(gain_changes(change))], [0 2], 'LineWidth', 2, 'color', [0,0.5,0]);
end
title('Heading variability');

subplot(3,1,3)
plot(continuous_data.time,smoothed_heading_variability,'k')
hold on
for change = 1:length(gain_changes)
    line([continuous_data.time(gain_changes(change)) continuous_data.time(gain_changes(change))], [0 2], 'LineWidth', 2, 'color', [0,0.5,0]);
end
title('Smoothed heading variability');

%save figure
saveas(gcf,[path,'\analysis\continuous_plots\heading_variability.png']);

%% Correlate BM and HW with heading offset variability during the inverted gain portion

%Set a mvt threshold
mvt_thresh = 25;

BumpMagIG = bump_mag{2};
HalfWidthIG = bump_width{2};
adj_rsIG = adj_rs{2};
heading_offset_variabilityIG = heading_offset_variability(gain_changes(1):gain_changes(2),:);
bar_offset_variabilityIG = bar_offset_variability(gain_changes(1):gain_changes(2),:);
heading_offset_precisionIG = heading_offset_precision(gain_changes(1):gain_changes(2),:);
bar_offset_precisionIG = bar_offset_precision(gain_changes(1):gain_changes(2),:);
total_mvtIG = continuous_data.total_mvt_ds(gain_changes(1):gain_changes(2));
yaw_speedIG = abs(continuous_data.vel_yaw_ds(gain_changes(1):gain_changes(2)));
heading_offsetIG = heading_offset(gain_changes(1):gain_changes(2));
bar_offsetIG = bar_offset(gain_changes(1):gain_changes(2));

   
figure,

nbins = 10;

%Define bins
max_bin = prctile(heading_offset_variabilityIG,95,'all');
min_bin = prctile(heading_offset_variabilityIG,5,'all');
binWidth = (max_bin-min_bin)/nbins;
Bins = [min_bin:binWidth:max_bin];

%Create axes for plot
mvtAxes = Bins - binWidth;
mvtAxes = mvtAxes(2:end);

%Getting binned means for the different windowSizes
for bin = 1:length(Bins)-1
    for window = 1:length(window_sizes)
        meanBin(bin,window) = nanmean(BumpMagIG((heading_offset_variabilityIG(:,window) > Bins(bin)) & (heading_offset_variabilityIG(:,window) < Bins(bin+1)) & (total_mvtIG' > mvt_thresh) & (adj_rsIG' > 0.5) ));
    end
end

%Plot
subplot(1,2,1)
plot(mvtAxes,meanBin)
ylabel('Bump magnitude (DF/F)'); xlabel('Heading offset variability');
ylim([0 3]);
xlim([mvtAxes(1) mvtAxes(end)]);
legend({'10 frames','30','50','100','200','500'},'location','best');
title('Bump magnitude');

%Getting binned means
for bin = 1:length(Bins)-1
    for window = 1:length(window_sizes)
        meanBin(bin,window) = nanmean(HalfWidthIG((heading_offset_variabilityIG(:,window) > Bins(bin)) & (total_mvtIG' > mvt_thresh) &(heading_offset_variabilityIG(:,window) < Bins(bin+1)) & (adj_rsIG' > 0.5) ));
    end
end

%Plot
subplot(1,2,2)
plot(mvtAxes,meanBin)
ylabel('Bump width (rad)'); xlabel('Heading offset variability');
ylim([0 4]);
xlim([mvtAxes(1) mvtAxes(end)]);
legend({'10 frames','30','50','100','200','500'},'location','best');
title('Bump width');


%save figure
saveas(gcf,[path,'\analysis\continuous_plots\heading_offset_vs_mean_bump_pars_IG.png']);
    
%% Repeat for bar offset variability
    
figure,

nbins = 10;

%Define bins
max_bin = prctile(heading_offset_variabilityIG,95,'all');
min_bin = prctile(heading_offset_variabilityIG,5,'all');
binWidth = (max_bin-min_bin)/nbins;
Bins = [min_bin:binWidth:max_bin];

%Create axes for plot
mvtAxes = Bins - binWidth;
mvtAxes = mvtAxes(2:end);

%Getting binned means for the different windowSizes
for bin = 1:length(Bins)-1
    for window = 1:length(window_sizes)
        meanBin(bin,window) = nanmean(BumpMagIG((bar_offset_variabilityIG(:,window) > Bins(bin)) & (bar_offset_variabilityIG(:,window) < Bins(bin+1)) & (total_mvtIG' > mvt_thresh) & (adj_rsIG' > 0.5) ));
    end
end

%Plot
subplot(1,2,1)
plot(mvtAxes,meanBin)
ylabel('Bump magnitude (DF/F)'); xlabel('Bar offset variability');
ylim([0 3]);
xlim([mvtAxes(1) mvtAxes(end)]);
legend({'10 frames','30','50','100','200','500'},'location','best');
title('Bump magnitude');

%Getting binned means
for bin = 1:length(Bins)-1
    for window = 1:length(window_sizes)
        meanBin(bin,window) = nanmean(HalfWidthIG((bar_offset_variabilityIG(:,window) > Bins(bin)) & (total_mvtIG' > mvt_thresh) &(bar_offset_variabilityIG(:,window) < Bins(bin+1)) & (adj_rsIG' > 0.5) ));
    end
end

%Plot
subplot(1,2,2)
plot(mvtAxes,meanBin)
ylabel('Bump width (rad)'); xlabel('Bar offset variability');
ylim([0 4]);
xlim([mvtAxes(1) mvtAxes(end)]);
legend({'10 frames','30','50','100','200','500'},'location','best');
title('Bump width');

%save figure
saveas(gcf,[path,'\analysis\continuous_plots\bar_offset_vs_mean_bump_pars_IG.png']);

%% Models of bump parameters

%We will model the two bump parameters as a function of total movement, (maybe a binary movement variable) and
%offset variability 

%Create binary movement variable
moving = total_mvtIG > mvt_thresh;

%Create table with the model's variables (only for the timepoints where the
%goodness of fit is above .5
for window = 1:length(window_sizes)
    
    modelTable{window} = table(bar_offset_variabilityIG(:,window),heading_offset_variabilityIG(:,window),bar_offset_precisionIG(:,window),heading_offset_precisionIG(:,window),total_mvtIG',moving',yaw_speedIG',BumpMagIG',HalfWidthIG',adj_rsIG',heading_offsetIG,bar_offsetIG,'VariableNames',{'BarOffsetVariability','HeadingOffsetVariability','BarOffsetPrecision','HeadingOffsetPrecision','TotalMovement','Moving','YawSpeed','BumpMagnitude','BumpWidth','Rsq','HeadingOffset','BarOffset'});
    
    %heading offset var
    mdl_BM_heading{window} = fitlm(modelTable{window},'BumpMagnitude~HeadingOffsetVariability+TotalMovement');
    mdl_BW_heading{window} = fitlm(modelTable{window},'BumpWidth~HeadingOffsetVariability+TotalMovement');
    Rsquared_BM_heading(window) = mdl_BM_heading{window}.Rsquared.Adjusted;
    Rsquared_BW_heading(window) = mdl_BW_heading{window}.Rsquared.Adjusted;
    
    %bar offset var
    mdl_BM_bar{window} = fitlm(modelTable{window},'BumpMagnitude~BarOffsetVariability+TotalMovement');
    mdl_BW_bar{window} = fitlm(modelTable{window},'BumpWidth~BarOffsetVariability+TotalMovement');
    Rsquared_BM_bar(window) = mdl_BM_bar{window}.Rsquared.Adjusted;
    Rsquared_BW_bar(window) = mdl_BW_bar{window}.Rsquared.Adjusted;
    
end

%Plot model fit with the different time windows
figure,

%heading
subplot(2,2,1)
plot(Rsquared_BM_heading,'-o')
title('Bump magnitude');
ylabel('Rsquared heading offset var model');
xlabel('window #');

subplot(2,2,2)
plot(Rsquared_BW_heading,'-o')
title('Bump width');
xlabel('window #');

%bar
subplot(2,2,3)
plot(Rsquared_BM_bar,'-o')
title('Bump magnitude');
ylabel('Rsquared bar offset var model');
xlabel('window #');

subplot(2,2,4)
plot(Rsquared_BW_bar,'-o')
title('Bump width');
xlabel('window #');

saveas(gcf,[path,'\analysis\continuous_plots\model_fit.png']);

%% Correlate BM and BW with offset variability during the normal gain portion
%heading and bar offset are the same in the normal gain bouts, so we only
%need to compute one

BumpMagNG = allBumpMag([1:gain_changes(1),gain_changes(2):end]);
HalfWidthNG = allBumpWidth([1:gain_changes(1),gain_changes(2):end]);
heading_offset_variabilityNG = heading_offset_variability([1:gain_changes(1),gain_changes(2):end],:);
heading_offset_precisionNG = heading_offset_precision([1:gain_changes(1),gain_changes(2):end],:);
adj_rsNG = all_adj_rs([1:gain_changes(1),gain_changes(2):end]);
total_mvtNG = continuous_data.total_mvt_ds([1:gain_changes(1),gain_changes(2):end]);
heading_variabilityNG = heading_variability([1:gain_changes(1),gain_changes(2):end]);
offsetNG = heading_offset([1:gain_changes(1),gain_changes(2):end]);

figure,

nbins = 10;

%Define bins
max_bin = prctile(heading_offset_variabilityNG,95,'all');
min_bin = prctile(heading_offset_variabilityNG,5,'all');
binWidth = (max_bin-min_bin)/nbins;
Bins = [min_bin:binWidth:max_bin];

%Create axes for plot
mvtAxes = Bins - binWidth;
mvtAxes = mvtAxes(2:end);

%Getting binned means for the different windowSizes
for bin = 1:length(Bins)-1
    for window = 1:length(window_sizes)
        meanBin(bin,window) = nanmean(BumpMagNG((heading_offset_variabilityNG(:,window) > Bins(bin)) & (heading_offset_variabilityNG(:,window) < Bins(bin+1)) & (total_mvtNG' > mvt_thresh) & (adj_rsNG' > 0.5) ));
    end
end

%Plot
subplot(1,2,1)
plot(mvtAxes,meanBin)
ylabel('Bump magnitude (DF/F)'); xlabel('Heading offset variability');
ylim([0 max(max(meanBin))+0.5]);
xlim([mvtAxes(1) mvtAxes(end)]);
legend({'10 frames','30','50','100','200','500'},'location','best');
title('Bump magnitude');

%Getting binned means
for bin = 1:length(Bins)-1
    for window = 1:length(window_sizes)
        meanBin(bin,window) = nanmean(HalfWidthNG((heading_offset_variabilityNG(:,window) > Bins(bin)) & (total_mvtNG' > mvt_thresh) &(heading_offset_variabilityNG(:,window) < Bins(bin+1)) & (adj_rsNG' > 0.5) ));
    end
end

%Plot
subplot(1,2,2)
plot(mvtAxes,meanBin)
ylabel('Bump width (rad)'); xlabel('Heading offset variability');
ylim([0 max(max(meanBin))+0.5]);
xlim([mvtAxes(1) mvtAxes(end)]);
legend({'10 frames','30','50','100','200','500'},'location','best');
title('Bump width');

%Save figure
saveas(gcf,[path,'\analysis\continuous_plots\offset_vs_mean_bump_pars_NG.png']);

%% Run models for the normal gain portion

%Create table with the model's variables
for window = 1:length(window_sizes)
    
    modelTableNG{window} = table(heading_offset_variabilityNG(:,window),heading_offset_precisionNG(:,window),total_mvtNG',BumpMagNG',HalfWidthNG',heading_variabilityNG,adj_rsNG',offsetNG,'VariableNames',{'HeadingOffsetVariability','HeadingOffsetPrecision','TotalMovement','BumpMagnitude','BumpWidth','HeadingVariability','Rsq','Offset'});
    mdl_BM_NG{window} = fitlm(modelTableNG{window},'BumpMagnitude~HeadingOffsetVariability+TotalMovement');
    mdl_BW_NG{window} = fitlm(modelTableNG{window},'BumpWidth~HeadingOffsetVariability+TotalMovement');
    %Model Rsquared
    Rsquared_BM_NG(window) = mdl_BM_NG{window}.Rsquared.Adjusted;
    Rsquared_HW_NG(window) = mdl_BW_NG{window}.Rsquared.Adjusted;
    
end

%Plot model fit with the different time windows
figure,
subplot(1,2,1)
plot(Rsquared_BM_NG,'-o')
title('Bump magnitude');
ylabel('Rsquared');
xlabel('window #');

subplot(1,2,2)
plot(Rsquared_HW_NG,'-o')
title('Bump width');
ylabel('Rsquared');
xlabel('window #');

saveas(gcf,[path,'\analysis\continuous_plots\model_fit_NG.png']);


%% Save relevant data

save([path,'\analysis\gain_change_data.mat'],'modelTable','modelTableNG','type_of_fly','ratio_of_offset_var','movementData');

%%
close all; clear all;
