%Group analysis code for the cue combination experiment

clear all; close all;

%% Load data

path = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp38\data\third_version';

folderContents = dir(path);

for content = 1:length(folderContents)
   if contains(folderContents(content).name,'60D05')
       data(content) = load([folderContents(content).folder,'\',folderContents(content).name,'\analysis\data.mat']);
   end
end

%Remove empty rows
data = data(all(~cellfun(@isempty,struct2cell(data))));


%% Combine all data

%Initialize variables
pref_index = [];
pref_index_2 = [];
heading_pref_index = [];
stick_index = [];
PI = [];
heading_PI = [];
SI = [];

initial_bar_bm = [];
initial_wind_bm = [];
initial_bar_bw = [];
initial_wind_bw = [];
initial_bar_offset = [];
initial_wind_offset = [];

short_bm_bar_jump = [];
short_bw_bar_jump = [];
short_bm_wind_jump = [];
short_bw_wind_jump = [];

long_bm_bar_jump = [];
long_bw_bar_jump = [];
long_bm_wind_jump = [];
long_bw_wind_jump = [];

long_total_mvt_bar_jump = [];
long_rot_speed_bar_jump = [];
long_total_mvt_wind_jump = [];
long_rot_speed_wind_jump = [];

short_bm_pref_cue = [];
short_bw_pref_cue = [];
short_bm_non_pref_cue = [];
short_bw_non_pref_cue = [];

adj_rs_aj_pref_cue = [];
adj_rs_aj_non_pref_cue = [];

long_bm_pref_cue = [];
long_bw_pref_cue = [];
long_bm_non_pref_cue = [];
long_bw_non_pref_cue = [];


bar_offset_precision_abj_10 = [];
bar_offset_precision_awj_10 = [];
wind_offset_precision_abj_10 = [];
wind_offset_precision_awj_10 = [];

bar_offset_precision_abj_25 = [];
bar_offset_precision_awj_25 = [];
wind_offset_precision_abj_25 = [];
wind_offset_precision_awj_25 = [];

bar_offset_precision_abj_75 = [];
bar_offset_precision_awj_75 = [];
wind_offset_precision_abj_75 = [];
wind_offset_precision_awj_75 = [];


configuration = [];

for fly = 1:length(data)
    
    pref_index = [pref_index;data(fly).pref_index];
    pref_index_2 = [pref_index_2;data(fly).pref_index_2];    
    heading_pref_index = [heading_pref_index;data(fly).heading_pref_index];
    stick_index = [stick_index;data(fly).stick_index];
    PI = [PI,data(fly).PI];
    heading_PI = [heading_PI,data(fly).PI_heading];
    SI = [SI,data(fly).SI];
    
    initial_bar_bm{fly} = data(fly).initial_bar_bm;
    initial_wind_bm{fly} = data(fly).initial_wind_bm;
    initial_bar_bw{fly} = data(fly).initial_bar_bw;
    initial_wind_bw{fly} = data(fly).initial_wind_bw;
    initial_bar_offset{fly} = data(fly).initial_bar_offset;
    initial_wind_offset{fly} = data(fly).initial_wind_offset;
    
    short_bm_bar_jump = [short_bm_bar_jump;data(fly).short_bm_bar_jump];
    short_bw_bar_jump = [short_bw_bar_jump;data(fly).short_bw_bar_jump];
    short_bm_wind_jump = [short_bm_wind_jump;data(fly).short_bm_wind_jump];
    short_bw_wind_jump = [short_bw_wind_jump;data(fly).short_bw_wind_jump];
    
    long_bm_bar_jump = [long_bm_bar_jump;data(fly).long_bm_bar_jump];
    long_bw_bar_jump = [long_bw_bar_jump;data(fly).long_bw_bar_jump];
    long_bm_wind_jump = [long_bm_wind_jump;data(fly).long_bm_wind_jump];
    long_bw_wind_jump = [long_bw_wind_jump;data(fly).long_bw_wind_jump];
    
    long_total_mvt_bar_jump = [long_total_mvt_bar_jump;data(fly).long_total_mvt_bar_jump];
    long_rot_speed_bar_jump = [long_rot_speed_bar_jump;data(fly).long_rot_speed_bar_jump];
    long_total_mvt_wind_jump = [long_total_mvt_wind_jump;data(fly).long_total_mvt_wind_jump];
    long_rot_speed_wind_jump = [long_rot_speed_wind_jump;data(fly).long_rot_speed_wind_jump];
    
    short_bm_pref_cue = [short_bm_pref_cue;data(fly).short_bm_pref_cue];
    short_bw_pref_cue = [short_bw_pref_cue;data(fly).short_bw_pref_cue];
    short_bm_non_pref_cue = [short_bm_non_pref_cue;data(fly).short_bm_non_pref_cue];
    short_bw_non_pref_cue = [short_bw_non_pref_cue;data(fly).short_bw_non_pref_cue];    
    
    adj_rs_aj_pref_cue = [adj_rs_aj_pref_cue;data(fly).adj_rs_aj_pref_cue];
    adj_rs_aj_non_pref_cue = [adj_rs_aj_non_pref_cue;data(fly).adj_rs_aj_non_pref_cue];
    
    long_bm_pref_cue = [long_bm_pref_cue;data(fly).long_bm_pref_cue];
    long_bw_pref_cue = [long_bw_pref_cue;data(fly).long_bw_pref_cue];
    long_bm_non_pref_cue = [long_bm_non_pref_cue;data(fly).long_bm_non_pref_cue];
    long_bw_non_pref_cue = [long_bw_non_pref_cue;data(fly).long_bw_non_pref_cue];
        
    bar_offset_precision_abj_10 = [bar_offset_precision_abj_10;data(fly).bar_offset_precision_abj_10];
    bar_offset_precision_awj_10 = [bar_offset_precision_awj_10;data(fly).bar_offset_precision_awj_10];
    wind_offset_precision_abj_10 = [wind_offset_precision_abj_10;data(fly).wind_offset_precision_abj_10];
    wind_offset_precision_awj_10 = [wind_offset_precision_awj_10;data(fly).wind_offset_precision_awj_10];
    
    bar_offset_precision_abj_25 = [bar_offset_precision_abj_25;data(fly).bar_offset_precision_abj_25];
    bar_offset_precision_awj_25 = [bar_offset_precision_awj_25;data(fly).bar_offset_precision_awj_25];
    wind_offset_precision_abj_25 = [wind_offset_precision_abj_25;data(fly).wind_offset_precision_abj_25];
    wind_offset_precision_awj_25 = [wind_offset_precision_awj_25;data(fly).wind_offset_precision_awj_25];
    
    bar_offset_precision_abj_75 = [bar_offset_precision_abj_75;data(fly).bar_offset_precision_abj_75];
    bar_offset_precision_awj_75 = [bar_offset_precision_awj_75;data(fly).bar_offset_precision_awj_75];
    wind_offset_precision_abj_75 = [wind_offset_precision_abj_75;data(fly).wind_offset_precision_abj_75];
    wind_offset_precision_awj_75 = [wind_offset_precision_awj_75;data(fly).wind_offset_precision_awj_75];
    
    configuration = [configuration;data(fly).configuration];
end


%% Short timescale raster plots

%2) z-scored
%zscore
zscored_short_bm_bar_jump = zscore(short_bm_bar_jump,[],2);
zscored_short_bm_wind_jump = zscore(short_bm_wind_jump,[],2);
zscored_short_bw_bar_jump = zscore(short_bw_bar_jump,[],2);
zscored_short_bw_wind_jump = zscore(short_bw_wind_jump,[],2);

%Plot bump magnitude
figure('Position',[100 100 600 600]),
subplot(2,1,1)
imagesc(zscored_short_bm_bar_jump)
hold on
xline(19,'r','linewidth',2)
colormap(flipud(gray))
title('Bar jumps');

subplot(2,1,2)
imagesc(zscored_short_bm_wind_jump)
hold on
xline(19,'r','linewidth',2)
colormap(flipud(gray))
title('Wind jumps');

suptitle('Bump magnitude');

saveas(gcf,[path,'\groupPlots\bump_mag_rasterplots.png'])


%Plot bump width
figure('Position',[100 100 600 600]),
subplot(2,1,1)
imagesc(zscored_short_bw_bar_jump)
hold on
xline(19,'r','linewidth',2)
colormap(flipud(gray))
title('Bar jumps');

subplot(2,1,2)
imagesc(zscored_short_bw_wind_jump)
hold on
xline(19,'r','linewidth',2)
colormap(flipud(gray))
title('Wind jumps');

suptitle('Bump width');

saveas(gcf,[path,'\groupPlots\bump_width_rasterplots.png'])

%% Long raster plots

%zscore
zscored_long_bm_bar_jump = zscore(long_bm_bar_jump,[],2);
zscored_long_bm_wind_jump = zscore(long_bm_wind_jump,[],2);
zscored_long_bw_bar_jump = zscore(long_bw_bar_jump,[],2);
zscored_long_bw_wind_jump = zscore(long_bw_wind_jump,[],2);

%Plot bump magnitude
figure('Position',[100 100 600 600]),
subplot(2,1,1)
imagesc(zscored_long_bm_bar_jump)
hold on
xline(1103,'r','linewidth',2)
colormap(flipud(gray))
title('Bar jumps');

subplot(2,1,2)
imagesc(zscored_long_bm_wind_jump)
hold on
xline(1103,'r','linewidth',2)
colormap(flipud(gray))
title('Wind jumps');

suptitle('Bump magnitude');

%saveas(gcf,[path,'\groupPlots\bump_mag_long_rasterplots.png'])


%Plot bump width
figure('Position',[100 100 600 600]),
subplot(2,1,1)
imagesc(zscored_long_bw_bar_jump)
hold on
xline(1103,'r','linewidth',2)
colormap(flipud(gray))
title('Bar jumps');

subplot(2,1,2)
imagesc(zscored_long_bw_wind_jump)
hold on
xline(1103,'r','linewidth',2)
colormap(flipud(gray))
title('Wind jumps');

suptitle('Bump width');

%saveas(gcf,[path,'\groupPlots\bump_width_long_rasterplots.png'])
% 
% %% Mean bump parameters around the jumps, all cues
% 
% figure('Position',[100 100 1400 1000]),
% 
% %bump magnitude around cue jumps
% subplot(1,2,1)
% mean_bm_around_cue_jump = nanmean([short_bm_bar_jump;short_bm_wind_jump]);
% std_bm_around_cue_jump = std([short_bm_bar_jump;short_bm_wind_jump]);
% ste_bm_around_cue_jump = std_bm_around_cue_jump/sqrt(size(short_bm_bar_jump,1)*2);
% boundedline([1:size(short_bm_bar_jump,2)],mean_bm_around_cue_jump,ste_bm_around_cue_jump,'cmap',gray)
% hold on
% line([size(short_bm_bar_jump,2)/2 size(short_bm_bar_jump,2)/2],[0 3],'color','r','linewidth',3);
% xlim([0 size(short_bm_bar_jump,2)]);
% xticks([0 size(short_bm_bar_jump,2)/4 size(short_bm_bar_jump,2)/2 size(short_bm_bar_jump,2)*(3/4) size(short_bm_bar_jump,2)]);
% xticklabels({'-2','-1','0','1','2'});
% ylabel('Bump magnitude');
% xlabel('Time (s)');
% title('Cue jumps');
% 
% %bump width around cue jumps
% subplot(1,2,2)
% mean_bw_around_cue_jump = nanmean([short_bw_bar_jump;short_bw_wind_jump]);
% std_bw_around_cue_jump = std([short_bw_bar_jump;short_bw_wind_jump]);
% ste_bw_around_cue_jump = std_bw_around_cue_jump/sqrt(size(short_bw_bar_jump,1)*2);
% boundedline([1:size(short_bw_bar_jump,2)],mean_bw_around_cue_jump,ste_bw_around_cue_jump,'cmap',gray)
% hold on
% line([size(short_bm_bar_jump,2)/2 size(short_bm_bar_jump,2)/2],[0 3],'color','r','linewidth',3);
% xlim([0 size(short_bm_bar_jump,2)]);
% xticks([0 size(short_bm_bar_jump,2)/4 size(short_bm_bar_jump,2)/2 size(short_bm_bar_jump,2)*(3/4) size(short_bm_bar_jump,2)]);
% xticklabels({'-2','-1','0','1','2'});
% ylabel('Bump width');
% xlabel('Time (s)');
% title('Cue jumps');
% 
% saveas(gcf,[path,'\groupPlots\mean_bump_pars_aj_all_cues.png'])
% 
% %% Mean bump parameters around the jumps, by cue type
% 
% figure('Position',[100 100 1400 1000]),
% 
% %bump magnitude around bar jumps
% subplot(2,2,1)
% mean_bm_around_bar_jump = nanmean(short_bm_bar_jump);
% std_bm_around_bar_jump = std(short_bm_bar_jump);
% ste_bm_around_bar_jump = std_bm_around_bar_jump/sqrt(size(short_bm_bar_jump,1));
% boundedline([1:size(short_bm_bar_jump,2)],mean_bm_around_bar_jump,ste_bm_around_bar_jump,'cmap',gray)
% hold on
% line([size(short_bm_bar_jump,2)/2 size(short_bm_bar_jump,2)/2],[0 3],'color','r','linewidth',3);
% xlim([0 size(short_bm_bar_jump,2)]);
% xticks([0 size(short_bm_bar_jump,2)/4 size(short_bm_bar_jump,2)/2 size(short_bm_bar_jump,2)*(3/4) size(short_bm_bar_jump,2)]);
% xticklabels({'-2','-1','0','1','2'});
% %ylim([1 2]);
% ylabel('Bump magnitude');
% title('Bar jumps');
% 
% %bump magnitude around wind jumps
% subplot(2,2,2)
% mean_bm_around_wind_jump = nanmean(short_bm_wind_jump);
% std_bm_around_wind_jump = std(short_bm_wind_jump);
% ste_bm_around_wind_jump = std_bm_around_wind_jump/sqrt(size(short_bm_wind_jump,1));
% boundedline([1:size(short_bm_wind_jump,2)],mean_bm_around_wind_jump,ste_bm_around_wind_jump,'cmap',gray)
% hold on
% line([size(short_bm_bar_jump,2)/2 size(short_bm_bar_jump,2)/2],[0 3],'color','r','linewidth',3);
% xlim([0 size(short_bm_bar_jump,2)]);
% xticks([0 size(short_bm_bar_jump,2)/4 size(short_bm_bar_jump,2)/2 size(short_bm_bar_jump,2)*(3/4) size(short_bm_bar_jump,2)]);
% xticklabels({'-2','-1','0','1','2'});
% %ylim([1 2]);
% title('Wind jumps');
% 
% %bump width around bar jumps
% subplot(2,2,3)
% mean_bw_around_bar_jump = nanmean(short_bw_bar_jump);
% std_bw_around_bar_jump = std(short_bw_bar_jump);
% ste_bw_around_bar_jump = std_bw_around_bar_jump/sqrt(size(short_bw_bar_jump,1));
% boundedline([1:size(short_bw_bar_jump,2)],mean_bw_around_bar_jump,ste_bw_around_bar_jump,'cmap',gray)
% hold on
% line([size(short_bm_bar_jump,2)/2 size(short_bm_bar_jump,2)/2],[0 3],'color','r','linewidth',3);
% xlim([0 size(short_bm_bar_jump,2)]);
% xticks([0 size(short_bm_bar_jump,2)/4 size(short_bm_bar_jump,2)/2 size(short_bm_bar_jump,2)*(3/4) size(short_bm_bar_jump,2)]);
% xticklabels({'-2','-1','0','1','2'});
% ylabel('Bump width');
% %ylim([2 3]);
% xlabel('Time (s)');
% 
% %bump magnitude around wind jumps
% subplot(2,2,4)
% mean_bw_around_wind_jump = nanmean(short_bw_wind_jump);
% std_bw_around_wind_jump = std(short_bw_wind_jump);
% ste_bw_around_wind_jump = std_bw_around_wind_jump/sqrt(size(short_bw_wind_jump,1));
% boundedline([1:size(short_bw_wind_jump,2)],mean_bw_around_wind_jump,ste_bw_around_wind_jump,'cmap',gray)
% hold on
% line([size(short_bm_bar_jump,2)/2 size(short_bm_bar_jump,2)/2],[0 3],'color','r','linewidth',3);
% xlim([0 size(short_bm_bar_jump,2)]);
% xticks([0 size(short_bm_bar_jump,2)/4 size(short_bm_bar_jump,2)/2 size(short_bm_bar_jump,2)*(3/4) size(short_bm_bar_jump,2)]);
% xticklabels({'-2','-1','0','1','2'});
% xlabel('Time (s)');
% %ylim([2 3]);
% 
% saveas(gcf,[path,'\groupPlots\mean_bump_pars_aj_by_cue_type.png'])

%% By preferred cue type

figure('Position',[100 100 700 1000]),

%bump magnitude around preferred cue
subplot(2,2,1)
mean_bm_around_pref_cue = nanmean(short_bm_pref_cue);
std_bm_around_pref_cue = std(short_bm_pref_cue);
ste_bm_around_pref_cue = std_bm_around_pref_cue/sqrt(size(short_bm_pref_cue,1));
boundedline([1:size(short_bm_pref_cue,2)],mean_bm_around_pref_cue,ste_bm_around_pref_cue,'cmap',gray)
hold on
line([size(short_bm_pref_cue,2)/2 size(short_bm_pref_cue,2)/2],[0 3],'color','r','linewidth',2,'linestyle','-.');
xlim([0 size(short_bm_pref_cue,2)]);
xticks([0 size(short_bm_pref_cue,2)/4 size(short_bm_pref_cue,2)/2 size(short_bm_pref_cue,2)*(3/4) size(short_bm_pref_cue,2)]);
xticklabels({'-2','-1','0','1','2'});
ylim([1 2]);
ylabel('Bump magnitude');
title('Preferred cue');

%bump magnitude around non preferred cue
subplot(2,2,2)
mean_bm_around_non_pref_cue = nanmean(short_bm_non_pref_cue);
std_bm_around_non_pref_cue = std(short_bm_non_pref_cue);
ste_bm_around_non_pref_cue = std_bm_around_non_pref_cue/sqrt(size(short_bm_non_pref_cue,1));
boundedline([1:size(short_bm_non_pref_cue,2)],mean_bm_around_non_pref_cue,ste_bm_around_non_pref_cue,'cmap',gray)
hold on
line([size(short_bm_non_pref_cue,2)/2 size(short_bm_non_pref_cue,2)/2],[0 3],'color','r','linewidth',2,'linestyle','-.');
xlim([0 size(short_bm_non_pref_cue,2)]);
xticks([0 size(short_bm_non_pref_cue,2)/4 size(short_bm_non_pref_cue,2)/2 size(short_bm_non_pref_cue,2)*(3/4) size(short_bm_non_pref_cue,2)]);
xticklabels({'-2','-1','0','1','2'});
ylim([1 2]);
title('Non-preferred cue');

%bump width around preferred cue
subplot(2,2,3)
mean_bw_around_pref_cue = nanmean(short_bw_pref_cue);
std_bw_around_pref_cue = std(short_bw_pref_cue);
ste_bw_around_pref_cue = std_bw_around_pref_cue/sqrt(size(short_bw_pref_cue,1));
boundedline([1:size(short_bw_pref_cue,2)],mean_bw_around_pref_cue,ste_bw_around_pref_cue,'cmap',gray)
hold on
line([size(short_bw_pref_cue,2)/2 size(short_bw_pref_cue,2)/2],[0 3],'color','r','linewidth',2,'linestyle','-.');
xlim([0 size(short_bw_pref_cue,2)]);
xticks([0 size(short_bw_pref_cue,2)/4 size(short_bw_pref_cue,2)/2 size(short_bw_pref_cue,2)*(3/4) size(short_bw_pref_cue,2)]);
xticklabels({'-2','-1','0','1','2'});
ylabel('Bump width');
ylim([1.5 2.5]);
xlabel('Time (s)');

%bump magnitude around non preferred cue
subplot(2,2,4)
mean_bw_around_non_pref_cue = nanmean(short_bw_non_pref_cue);
std_bw_around_non_pref_cue = std(short_bw_non_pref_cue);
ste_bw_around_non_pref_cue = std_bw_around_non_pref_cue/sqrt(size(short_bw_non_pref_cue,1));
boundedline([1:size(short_bw_non_pref_cue,2)],mean_bw_around_non_pref_cue,ste_bw_around_non_pref_cue,'cmap',gray)
hold on
line([size(short_bw_non_pref_cue,2)/2 size(short_bw_non_pref_cue,2)/2],[0 3],'color','r','linewidth',2,'linestyle','-.');
xlim([0 size(short_bw_non_pref_cue,2)]);
xticks([0 size(short_bw_non_pref_cue,2)/4 size(short_bw_non_pref_cue,2)/2 size(short_bw_non_pref_cue,2)*(3/4) size(short_bw_non_pref_cue,2)]);
xticklabels({'-2','-1','0','1','2'});
xlabel('Time (s)');
ylim([1.5 2.5]);

saveas(gcf,[path,'\groupPlots\mean_bump_pars_aj_by_pref_cue.png'])
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueJump-Experiment\mean_bump_pars_aj_by_pref_cue.png')

%% Plot the mean of bump pars for preferred and non-preferred cues 1 sec prior vs 1 sec post jump

half_position = floor(size(short_bm_pref_cue,2)/2);


figure('Position',[50 50 900 1000]),

%Bump magnitude
subplot(9,2,[1,3,5,7])
imagesc(zscore(short_bm_pref_cue,[],2))
hold on
line([half_position half_position],[1 length(short_bm_pref_cue)],'color','r','linewidth',2)
colormap(flipud(gray))
title('Bump magnitude');

subplot(9,2,9)
plot(nanmean(short_bm_pref_cue),'k')
hold on
xline(half_position,'color','r','linewidth',2)
xlim([1 size(short_bm_pref_cue,2)]);
ylim([1 2]);

subplot(9,2,[11,13,15,17]);
mean_aj_bm_pref_cue = [nanmean(short_bm_pref_cue(:,half_position-10:half_position),2),nanmean(short_bm_pref_cue(:,half_position+1:half_position+11),2)];
plot(mean_aj_bm_pref_cue','color',[.5 .5 .5])
hold on
plot(mean(mean_aj_bm_pref_cue),'-ko','linewidth',2)
xlim([0 3]);
xticks([1:2]);
xticklabels({'pre jump','post jump'});

%Bump width
subplot(9,2,[2,4,6,8])
imagesc(zscore(short_bw_pref_cue,[],2))
hold on
line([half_position half_position],[1 length(short_bw_pref_cue)],'color','r','linewidth',2)
colormap(flipud(gray))
title('Bump width');

subplot(9,2,10)
plot(nanmean(short_bw_pref_cue),'k')
hold on
xline(half_position,'color','r','linewidth',2)
xlim([1 size(short_bw_pref_cue,2)]);
ylim([1.5 2.5]);

subplot(9,2,[12,14,16,18]);
mean_aj_bw_pref_cue = [nanmean(short_bw_pref_cue(:,half_position-10:half_position),2),nanmean(short_bw_pref_cue(:,half_position+1:half_position+11),2)];
plot(mean_aj_bw_pref_cue','color',[.5 .5 .5])
hold on
plot(mean(mean_aj_bw_pref_cue),'-ko','linewidth',2)
xlim([0 3]);
xticks([1:2]);
xticklabels({'pre jump','post jump'});

%Statistical analysis
signrank(mean_aj_bm_pref_cue(:,1),mean_aj_bm_pref_cue(:,2))
signrank(mean_aj_bw_pref_cue(:,1),mean_aj_bw_pref_cue(:,2))

suptitle('Preferred cue type');



figure('Position',[50 50 900 1000]),

%Bump magnitude
subplot(9,2,[1,3,5,7])
imagesc(zscore(short_bm_non_pref_cue,[],2))
hold on
line([half_position half_position],[1 length(short_bm_non_pref_cue)],'color','r','linewidth',2)
colormap(flipud(gray))
title('Bump magnitude');

subplot(9,2,9)
plot(nanmean(short_bm_non_pref_cue),'k')
hold on
xline(half_position,'color','r','linewidth',2)
xlim([1 size(short_bm_non_pref_cue,2)]);
ylim([1 2]);

subplot(9,2,[11,13,15,17]);
mean_aj_bm_non_pref_cue = [nanmean(short_bm_non_pref_cue(:,half_position-10:half_position),2),nanmean(short_bm_non_pref_cue(:,half_position+1:half_position+11),2)];
plot(mean_aj_bm_non_pref_cue','color',[.5 .5 .5])
hold on
plot(mean(mean_aj_bm_non_pref_cue),'-ko','linewidth',2)
xlim([0 3]);
xticks([1:2]);
xticklabels({'pre jump','post jump'});

%Bump width
subplot(9,2,[2,4,6,8])
imagesc(zscore(short_bw_non_pref_cue,[],2))
hold on
line([half_position half_position],[1 length(short_bw_non_pref_cue)],'color','r','linewidth',2)
colormap(flipud(gray))
title('Bump width');

subplot(9,2,10)
plot(nanmean(short_bw_non_pref_cue),'k')
hold on
xline(half_position,'color','r','linewidth',2)
xlim([1 size(short_bw_non_pref_cue,2)]);
ylim([1.5 2.5]);

subplot(9,2,[12,14,16,18]);
mean_aj_bw_non_pref_cue = [nanmean(short_bw_non_pref_cue(:,half_position-10:half_position),2),nanmean(short_bw_non_pref_cue(:,half_position+1:half_position+11),2)];
plot(mean_aj_bw_non_pref_cue','color',[.5 .5 .5])
hold on
plot(mean(mean_aj_bw_non_pref_cue),'-ko','linewidth',2)
xlim([0 3]);
xticks([1:2]);
xticklabels({'pre jump','post jump'});

%Statistical analysis
signrank(mean_aj_bm_non_pref_cue(:,1),mean_aj_bm_non_pref_cue(:,2))
signrank(mean_aj_bw_non_pref_cue(:,1),mean_aj_bw_non_pref_cue(:,2))

suptitle('Non-preferred cue type');

%% Replace poor gof by NaNs and repeat

for trial = 1:length(short_bm_pref_cue)
    short_bm_pref_cue(trial,adj_rs_aj_pref_cue(trial,:) < 0.5) = NaN;
    short_bw_pref_cue(trial,adj_rs_aj_pref_cue(trial,:) < 0.5) = NaN;
end

imAlpha_bm_pref = ones(size(short_bm_pref_cue));
imAlpha_bm_pref(isnan(short_bm_pref_cue)) = 0;
imAlpha_bw_pref = ones(size(short_bw_pref_cue));
imAlpha_bw_pref(isnan(short_bw_pref_cue)) = 0;


figure('Position',[50 50 900 1000]),

%Bump magnitude
subplot(9,2,[1,3,5,7])
zscored_bm_pref_cue = (short_bm_pref_cue' - nanmean(short_bm_pref_cue'))./nanstd(short_bm_pref_cue');
imagesc(zscored_bm_pref_cue','AlphaData',imAlpha_bm_pref)
hold on
line([half_position half_position],[1 length(short_bm_pref_cue)],'color','r','linewidth',2)
title('Bump magnitude');

subplot(9,2,9)
plot(nanmean(short_bm_pref_cue),'k')
hold on
xline(half_position,'color','r','linewidth',2)
xlim([1 size(short_bm_pref_cue,2)]);
ylim([1 2]);

subplot(9,2,[11,13,15,17]);
mean_aj_bm_pref_cue = [nanmean(short_bm_pref_cue(:,half_position-10:half_position),2),nanmean(short_bm_pref_cue(:,half_position+1:half_position+11),2)];
plot(mean_aj_bm_pref_cue','color',[.5 .5 .5])
hold on
plot(nanmean(mean_aj_bm_pref_cue),'-ko','linewidth',2)
xlim([0 3]);
xticks([1:2]);
xticklabels({'pre jump','post jump'});

%Bump width
subplot(9,2,[2,4,6,8])
zscored_bw_pref_cue = (short_bw_pref_cue' - nanmean(short_bw_pref_cue'))./nanstd(short_bw_pref_cue');
imagesc(zscored_bw_pref_cue','AlphaData',imAlpha_bw_pref)
hold on
line([half_position half_position],[1 length(short_bw_pref_cue)],'color','r','linewidth',2)
title('Bump width');

subplot(9,2,10)
plot(nanmean(short_bw_pref_cue),'k')
hold on
xline(half_position,'color','r','linewidth',2)
xlim([1 size(short_bw_pref_cue,2)]);
ylim([1.5 2.5]);

subplot(9,2,[12,14,16,18]);
mean_aj_bw_pref_cue = [nanmean(short_bw_pref_cue(:,half_position-10:half_position),2),nanmean(short_bw_pref_cue(:,half_position+1:half_position+11),2)];
plot(mean_aj_bw_pref_cue','color',[.5 .5 .5])
hold on
plot(nanmean(mean_aj_bw_pref_cue),'-ko','linewidth',2)
xlim([0 3]);
xticks([1:2]);
xticklabels({'pre jump','post jump'});

%Statistical analysis
signrank(mean_aj_bm_pref_cue(:,1),mean_aj_bm_pref_cue(:,2))
signrank(mean_aj_bw_pref_cue(:,1),mean_aj_bw_pref_cue(:,2))

suptitle('Preferred cue type');


%% Repeat for non-preferred cue

for trial = 1:length(short_bm_non_pref_cue)
    short_bm_non_pref_cue(trial,adj_rs_aj_non_pref_cue(trial,:) < 0.5) = NaN;
    short_bw_non_pref_cue(trial,adj_rs_aj_non_pref_cue(trial,:) < 0.5) = NaN;
end

imAlpha_bm_non_pref = ones(size(short_bm_non_pref_cue));
imAlpha_bm_non_pref(isnan(short_bm_non_pref_cue)) = 0;
imAlpha_bw_non_pref = ones(size(short_bw_non_pref_cue));
imAlpha_bw_non_pref(isnan(short_bw_non_pref_cue)) = 0;


figure('Position',[50 50 900 1000]),

%Bump magnitude
subplot(9,2,[1,3,5,7])
zscored_bm_non_pref_cue = (short_bm_non_pref_cue' - nanmean(short_bm_non_pref_cue'))./nanstd(short_bm_non_pref_cue');
imagesc(zscored_bm_non_pref_cue','AlphaData',imAlpha_bm_non_pref)
hold on
line([half_position half_position],[1 length(short_bm_non_pref_cue)],'color','r','linewidth',2)
title('Bump magnitude');

subplot(9,2,9)
plot(nanmean(short_bm_non_pref_cue),'k')
hold on
xline(half_position,'color','r','linewidth',2)
xlim([1 size(short_bm_non_pref_cue,2)]);
ylim([1 2]);

subplot(9,2,[11,13,15,17]);
mean_aj_bm_non_pref_cue = [nanmean(short_bm_non_pref_cue(:,half_position-10:half_position),2),nanmean(short_bm_non_pref_cue(:,half_position+1:half_position+11),2)];
plot(mean_aj_bm_non_pref_cue','color',[.5 .5 .5])
hold on
plot(nanmean(mean_aj_bm_non_pref_cue),'-ko','linewidth',2)
xlim([0 3]);
xticks([1:2]);
xticklabels({'pre jump','post jump'});

%Bump width
subplot(9,2,[2,4,6,8])
zscored_bw_non_pref_cue = (short_bw_non_pref_cue' - nanmean(short_bw_non_pref_cue'))./nanstd(short_bw_non_pref_cue');
imagesc(zscored_bw_non_pref_cue','AlphaData',imAlpha_bw_non_pref)
hold on
line([half_position half_position],[1 length(short_bw_non_pref_cue)],'color','r','linewidth',2)
title('Bump width');

subplot(9,2,10)
plot(nanmean(short_bw_non_pref_cue),'k')
hold on
xline(half_position,'color','r','linewidth',2)
xlim([1 size(short_bw_non_pref_cue,2)]);
ylim([1.5 2.5]);

subplot(9,2,[12,14,16,18]);
mean_aj_bw_non_pref_cue = [nanmean(short_bw_non_pref_cue(:,half_position-10:half_position),2),nanmean(short_bw_non_pref_cue(:,half_position+1:half_position+11),2)];
plot(mean_aj_bw_non_pref_cue','color',[.5 .5 .5])
hold on
plot(nanmean(mean_aj_bw_non_pref_cue),'-ko','linewidth',2)
xlim([0 3]);
xticks([1:2]);
xticklabels({'pre jump','post jump'});

%Statistical analysis
signrank(mean_aj_bm_non_pref_cue(:,1),mean_aj_bm_non_pref_cue(:,2))
signrank(mean_aj_bw_non_pref_cue(:,1),mean_aj_bw_non_pref_cue(:,2))

suptitle('Non-preferred cue type');

% 
% %% Longer mean bump parameters around the jumps
% 
% figure('Position',[100 100 1400 1000]),
% 
% %bump magnitude around cue jumps
% subplot(1,2,1)
% long_mean_bm_around_cue_jump = nanmean([long_bm_bar_jump;long_bm_wind_jump]);
% long_std_bm_around_cue_jump = std([long_bm_bar_jump;long_bm_wind_jump]);
% long_ste_bm_around_cue_jump = long_std_bm_around_cue_jump/sqrt(size(long_bm_bar_jump,1)*2);
% boundedline([1:size(long_bm_bar_jump,2)],long_mean_bm_around_cue_jump,long_ste_bm_around_cue_jump,'cmap',gray)
% hold on
% line([length(long_bm_bar_jump)/2 length(long_bm_bar_jump)/2],[0 3],'color','r','linewidth',3);
% xlim([0 length(long_bm_bar_jump)]);
% xticks([0 length(long_bm_bar_jump)/4 length(long_bm_bar_jump)/2 length(long_bm_bar_jump)*(3/4) length(long_bm_bar_jump)]);
% xticklabels({'-120','-60','0','60','120'});
% ylabel('Bump magnitude');
% xlabel('Time (s)');
% title('Cue jumps');
% 
% %bump width around cue jumps
% subplot(1,2,2)
% long_mean_bw_around_cue_jump = nanmean([long_bw_bar_jump;long_bw_wind_jump]);
% long_std_bw_around_cue_jump = std([long_bw_bar_jump;long_bw_wind_jump]);
% long_ste_bw_around_cue_jump = long_std_bw_around_cue_jump/sqrt(size(long_bw_bar_jump,1)*2);
% boundedline([1:size(long_bw_bar_jump,2)],long_mean_bw_around_cue_jump,long_ste_bw_around_cue_jump,'cmap',gray)
% hold on
% line([length(long_bm_bar_jump)/2 length(long_bm_bar_jump)/2],[0 3],'color','r','linewidth',3);
% xlim([0 length(long_bm_bar_jump)]);
% xticks([0 length(long_bm_bar_jump)/4 length(long_bm_bar_jump)/2 length(long_bm_bar_jump)*(3/4) length(long_bm_bar_jump)]);
% xticklabels({'-120','-60','0','60','120'});
% ylabel('Bump width');
% xlabel('Time (s)');
% title('Cue jumps');
% 
% saveas(gcf,[path,'\groupPlots\long_mean_bump_pars_aj_all_cues.png'])
% 
% %% Mean bump parameters around the jumps, by cue type
% 
% figure('Position',[100 100 1400 1000]),
% 
% %bump magnitude around bar jumps
% subplot(2,2,1)
% long_mean_bm_around_bar_jump = nanmean(long_bm_bar_jump);
% long_std_bm_around_bar_jump = std(long_bm_bar_jump);
% long_ste_bm_around_bar_jump = long_std_bm_around_bar_jump/sqrt(size(long_bm_bar_jump,1));
% boundedline([1:size(long_bm_bar_jump,2)],long_mean_bm_around_bar_jump,long_ste_bm_around_bar_jump,'cmap',gray)
% hold on
% line([length(long_bm_bar_jump)/2 length(long_bm_bar_jump)/2],[0 3],'color','r','linewidth',3);
% xlim([0 length(long_bm_bar_jump)]);
% xticks([0 length(long_bm_bar_jump)/4 length(long_bm_bar_jump)/2 length(long_bm_bar_jump)*(3/4) length(long_bm_bar_jump)]);
% xticklabels({'-120','-60','0','60','120'});
% ylabel('Bump magnitude');
% title('Bar jumps');
% 
% %bump magnitude around wind jumps
% subplot(2,2,2)
% long_mean_bm_around_wind_jump = nanmean(long_bm_wind_jump);
% long_std_bm_around_wind_jump = std(long_bm_wind_jump);
% long_ste_bm_around_wind_jump = long_std_bm_around_wind_jump/sqrt(size(long_bm_wind_jump,1));
% boundedline([1:size(long_bm_wind_jump,2)],long_mean_bm_around_wind_jump,long_ste_bm_around_wind_jump,'cmap',gray)
% hold on
% line([length(long_bm_bar_jump)/2 length(long_bm_bar_jump)/2],[0 3],'color','r','linewidth',3);
% xlim([0 length(long_bm_bar_jump)]);
% xticks([0 length(long_bm_bar_jump)/4 length(long_bm_bar_jump)/2 length(long_bm_bar_jump)*(3/4) length(long_bm_bar_jump)]);
% xticklabels({'-2','-1','0','1','2'});
% title('Wind jumps');
% 
% %bump width around bar jumps
% subplot(2,2,3)
% long_mean_bw_around_bar_jump = nanmean(long_bw_bar_jump);
% long_std_bw_around_bar_jump = std(long_bw_bar_jump);
% long_ste_bw_around_bar_jump = long_std_bw_around_bar_jump/sqrt(size(long_bw_bar_jump,1));
% boundedline([1:size(long_bw_bar_jump,2)],long_mean_bw_around_bar_jump,long_ste_bw_around_bar_jump,'cmap',gray)
% hold on
% line([length(long_bm_bar_jump)/2 length(long_bm_bar_jump)/2],[0 3],'color','r','linewidth',3);
% xlim([0 length(long_bm_bar_jump)]);
% xticks([0 length(long_bm_bar_jump)/4 length(long_bm_bar_jump)/2 length(long_bm_bar_jump)*(3/4) length(long_bm_bar_jump)]);
% xticklabels({'-2','-1','0','1','2'});
% ylabel('Bump width');
% xlabel('Time (s)');
% 
% %bump magnitude around wind jumps
% subplot(2,2,4)
% long_mean_bw_around_wind_jump = nanmean(long_bw_wind_jump);
% long_std_bw_around_wind_jump = std(long_bw_wind_jump);
% long_ste_bw_around_wind_jump = long_std_bw_around_wind_jump/sqrt(size(long_bw_wind_jump,1));
% boundedline([1:size(long_bw_wind_jump,2)],long_mean_bw_around_wind_jump,long_ste_bw_around_wind_jump,'cmap',gray)
% hold on
% line([length(long_bm_bar_jump)/2 length(long_bm_bar_jump)/2],[0 3],'color','r','linewidth',3);
% xlim([0 length(long_bm_bar_jump)]);
% xticks([0 length(long_bm_bar_jump)/4 length(long_bm_bar_jump)/2 length(long_bm_bar_jump)*(3/4) length(long_bm_bar_jump)]);
% xticklabels({'-2','-1','0','1','2'});
% xlabel('Time (s)');
% 
% saveas(gcf,[path,'\groupPlots\long_mean_bump_pars_aj_by_cue_type.png'])

%% Mean bump parameters by preferred cue

figure('Position',[100 100 1600 1000]),

%bump magnitude around preferred cue
subplot(2,2,1)
mean_long_bm_around_pref_cue = nanmean(long_bm_pref_cue);
std_long_bm_around_pref_cue = std(long_bm_pref_cue);
ste_long_bm_around_pref_cue = std_long_bm_around_pref_cue/sqrt(size(long_bm_pref_cue,1));
boundedline([1:size(long_bm_pref_cue,2)],mean_long_bm_around_pref_cue,ste_long_bm_around_pref_cue,'cmap',gray)
hold on
line([size(long_bm_pref_cue,2)/2 size(long_bm_pref_cue,2)/2],[0 3],'color','r','linewidth',2,'linestyle','-.');
xlim([size(long_bw_non_pref_cue,2)/4 3*size(long_bw_non_pref_cue,2)/4]);
xticks([size(long_bw_non_pref_cue,2)/4 size(long_bw_non_pref_cue,2)/2 size(long_bw_non_pref_cue,2)*(3/4)]);
xticklabels({'-60','0','60'});
ylim([1 2]);
ylabel('Bump magnitude');
title('Preferred cue');

%bump magnitude around non preferred cue
subplot(2,2,2)
mean_long_bm_around_non_pref_cue = nanmean(long_bm_non_pref_cue);
std_long_bm_around_non_pref_cue = std(long_bm_non_pref_cue);
ste_long_bm_around_non_pref_cue = std_long_bm_around_non_pref_cue/sqrt(size(long_bm_non_pref_cue,1));
boundedline([1:size(long_bm_non_pref_cue,2)],mean_long_bm_around_non_pref_cue,ste_long_bm_around_non_pref_cue,'cmap',gray)
hold on
line([size(long_bm_pref_cue,2)/2 size(long_bm_pref_cue,2)/2],[0 3],'color','r','linewidth',2,'linestyle','-.');
xlim([size(long_bw_non_pref_cue,2)/4 3*size(long_bw_non_pref_cue,2)/4]);
xticks([size(long_bw_non_pref_cue,2)/4 size(long_bw_non_pref_cue,2)/2 size(long_bw_non_pref_cue,2)*(3/4)]);
xticklabels({'-60','0','60'});
ylim([1 2]);
title('Non-preferred cue');

%bump width around preferred cue
subplot(2,2,3)
mean_long_bw_around_pref_cue = nanmean(long_bw_pref_cue);
std_long_bw_around_pref_cue = std(long_bw_pref_cue);
ste_long_bw_around_pref_cue = std_long_bw_around_pref_cue/sqrt(size(long_bw_pref_cue,1));
boundedline([1:size(long_bw_pref_cue,2)],mean_long_bw_around_pref_cue,ste_long_bw_around_pref_cue,'cmap',gray)
hold on
line([size(long_bm_pref_cue,2)/2 size(long_bm_pref_cue,2)/2],[0 3],'color','r','linewidth',2,'linestyle','-.');
xlim([size(long_bw_non_pref_cue,2)/4 3*size(long_bw_non_pref_cue,2)/4]);
xticks([size(long_bw_non_pref_cue,2)/4 size(long_bw_non_pref_cue,2)/2 size(long_bw_non_pref_cue,2)*(3/4)]);
xticklabels({'-60','0','60'});
ylabel('Bump width');
ylim([1.5 2.5]);
xlabel('Time (s)');

%bump magnitude around non preferred cue
subplot(2,2,4)
mean_long_bw_around_non_pref_cue = nanmean(long_bw_non_pref_cue);
std_long_bw_around_non_pref_cue = std(long_bw_non_pref_cue);
ste_long_bw_around_non_pref_cue = std_long_bw_around_non_pref_cue/sqrt(size(long_bw_non_pref_cue,1));
boundedline([1:size(long_bw_non_pref_cue,2)],mean_long_bw_around_non_pref_cue,ste_long_bw_around_non_pref_cue,'cmap',gray)
hold on
line([size(long_bm_pref_cue,2)/2 size(long_bm_pref_cue,2)/2],[0 3],'color','r','linewidth',2,'linestyle','-.');
xlim([size(long_bw_non_pref_cue,2)/4 3*size(long_bw_non_pref_cue,2)/4]);
xticks([size(long_bw_non_pref_cue,2)/4 size(long_bw_non_pref_cue,2)/2 size(long_bw_non_pref_cue,2)*(3/4)]);
xticklabels({'-60','0','60'});
xlabel('Time (s)');
ylim([1.5 2.5]);

saveas(gcf,[path,'\groupPlots\mean_long_bump_pars_aj_by_pref_cue.png'])
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueJump-Experiment\mean_long_bump_pars_aj_by_pref_cue.svg')

%% Mean offset precision around the jumps, all cues

%window = 10 frames
figure('Position',[100 100 1400 1000]),
mean_offset_precision_around_cue_jump_10 = nanmean([wind_offset_precision_abj_10;bar_offset_precision_awj_10]);
std_offset_precision_around_cue_jump_10 = std([wind_offset_precision_abj_10;bar_offset_precision_awj_10]);
ste_offset_precision_around_cue_jump_10 = std_offset_precision_around_cue_jump_10/sqrt(size(short_bm_bar_jump,1)*2);
boundedline([1:size(bar_offset_precision_abj_10,2)],mean_offset_precision_around_cue_jump_10,ste_offset_precision_around_cue_jump_10,'cmap',gray)
hold on
line([length(bar_offset_precision_abj_10)/2 length(bar_offset_precision_abj_10)/2],[0 1],'color','r','linewidth',2,'linestyle','-.');
xlim([length(bar_offset_precision_abj_75)/4 3*length(bar_offset_precision_abj_75)/4]);
xticks([length(bar_offset_precision_abj_75)/4 length(bar_offset_precision_abj_75)/2 length(bar_offset_precision_abj_75)*(3/4)]);
xticklabels({'-60','0','60'});
ylim([0 1]);
ylabel('Offset precision (circ std)');
xlabel('Time (s)');
title('window = 10 frames');
saveas(gcf,[path,'\groupPlots\mean_offset_precision_all_cues_10_frames.png'])

%window = 25 frames
figure('Position',[100 100 1400 1000]),
mean_offset_precision_around_cue_jump_25 = nanmean([wind_offset_precision_abj_25;bar_offset_precision_awj_25]);
std_offset_precision_around_cue_jump_25 = std([wind_offset_precision_abj_25;bar_offset_precision_awj_25]);
ste_offset_precision_around_cue_jump_25 = std_offset_precision_around_cue_jump_25/sqrt(size(short_bm_bar_jump,1)*2);
boundedline([1:size(bar_offset_precision_abj_25,2)],mean_offset_precision_around_cue_jump_25,ste_offset_precision_around_cue_jump_25,'cmap',gray)
hold on
line([length(bar_offset_precision_abj_25)/2 length(bar_offset_precision_abj_25)/2],[0 1],'color','r','linewidth',2,'linestyle','-.');
xlim([length(bar_offset_precision_abj_75)/4 3*length(bar_offset_precision_abj_75)/4]);
xticks([length(bar_offset_precision_abj_75)/4 length(bar_offset_precision_abj_75)/2 length(bar_offset_precision_abj_75)*(3/4)]);
xticklabels({'-60','0','60'});
ylim([0 1]);
ylabel('Offset precision (circ std)');
xlabel('Time (s)');
title('window = 25 frames');
saveas(gcf,[path,'\groupPlots\mean_offset_precision_all_cues_25_frames.png'])


%window = 75 frames
figure('Position',[100 100 1400 1000]),
mean_offset_precision_around_cue_jump_75 = nanmean([wind_offset_precision_abj_75;bar_offset_precision_awj_75]);
std_offset_precision_around_cue_jump_75 = std([wind_offset_precision_abj_75;bar_offset_precision_awj_75]);
ste_offset_precision_around_cue_jump_75 = std_offset_precision_around_cue_jump_75/sqrt(size(short_bm_bar_jump,1)*2);
boundedline([1:size(bar_offset_precision_abj_75,2)],mean_offset_precision_around_cue_jump_75,ste_offset_precision_around_cue_jump_75,'cmap',gray)
hold on
line([length(bar_offset_precision_abj_75)/2 length(bar_offset_precision_abj_75)/2],[0 1],'color','r','linewidth',2,'linestyle','-.');
xlim([length(bar_offset_precision_abj_75)/4 3*length(bar_offset_precision_abj_75)/4]);
xticks([length(bar_offset_precision_abj_75)/4 length(bar_offset_precision_abj_75)/2 length(bar_offset_precision_abj_75)*(3/4)]);
xticklabels({'-60','0','60'});
ylim([0 1]);
ylabel('Offset precision (circ std)');
xlabel('Time (s)');
title('Window = 75 frames');
saveas(gcf,[path,'\groupPlots\mean_offset_precision_all_cues_75_frames.png'])


%% Mean offset precision around the jumps, by cue

%window = 10 frames
figure('Position',[100 100 1400 1000]),
subplot(1,2,1)
mean_offset_precision_around_bar_jump_10 = nanmean(wind_offset_precision_abj_10);
std_offset_precision_around_bar_jump_10 = std(wind_offset_precision_abj_10);
ste_offset_precision_around_bar_jump_10 = std_offset_precision_around_bar_jump_10/sqrt(size(short_bm_bar_jump,1)*2);
boundedline([1:size(bar_offset_precision_abj_10,2)],mean_offset_precision_around_bar_jump_10,ste_offset_precision_around_bar_jump_10,'cmap',gray)
hold on
line([length(bar_offset_precision_abj_10)/2 length(bar_offset_precision_abj_10)/2],[0 1],'color','r','linewidth',3,'linestyle','--');
xlim([length(bar_offset_precision_abj_75)/4 3*length(bar_offset_precision_abj_75)/4]);
xticks([length(bar_offset_precision_abj_75)/4 length(bar_offset_precision_abj_75)/2 length(bar_offset_precision_abj_75)*(3/4)]);
xticklabels({'-60','0','60'});
ylim([0 1]);
ylabel('Offset precision (rad)');
xlabel('Time (s)');
title('Bar jumps');

subplot(1,2,2)
mean_offset_precision_around_wind_jump_10 = nanmean(bar_offset_precision_awj_10);
std_offset_precision_around_wind_jump_10 = std(bar_offset_precision_awj_10);
ste_offset_precision_around_wind_jump_10 = std_offset_precision_around_wind_jump_10/sqrt(size(short_bm_bar_jump,1)*2);
boundedline([1:size(bar_offset_precision_abj_10,2)],mean_offset_precision_around_wind_jump_10,ste_offset_precision_around_wind_jump_10,'cmap',gray)
hold on
line([length(bar_offset_precision_abj_10)/2 length(bar_offset_precision_abj_10)/2],[0 1],'color','r','linewidth',3,'linestyle','--');
xlim([length(bar_offset_precision_abj_75)/4 3*length(bar_offset_precision_abj_75)/4]);
xticks([length(bar_offset_precision_abj_75)/4 length(bar_offset_precision_abj_75)/2 length(bar_offset_precision_abj_75)*(3/4)]);
xticklabels({'-60','0','60'});
ylim([0 1]);
xlabel('Time (s)');
title('Wind jumps');

saveas(gcf,[path,'\groupPlots\mean_offset_precision_aj_by_cue_type_10_frames.png'])
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueJump-Experiment\mean_offset_precision_aj_by_cue_type_10_frames.svg')


%% Repeat for 25 frames

figure('Position',[100 100 1400 1000]),
subplot(1,2,1)
mean_offset_precision_around_bar_jump_25 = nanmean(wind_offset_precision_abj_25);
std_offset_precision_around_bar_jump_25 = std(wind_offset_precision_abj_25);
ste_offset_precision_around_bar_jump_25 = std_offset_precision_around_bar_jump_25/sqrt(size(short_bm_bar_jump,1)*2);
boundedline([1:size(bar_offset_precision_abj_25,2)],mean_offset_precision_around_bar_jump_25,ste_offset_precision_around_bar_jump_25,'cmap',gray)
hold on
line([length(bar_offset_precision_abj_25)/2 length(bar_offset_precision_abj_25)/2],[0 1],'color','r','linewidth',2,'linestyle','-.');
xlim([length(bar_offset_precision_abj_75)/4 3*length(bar_offset_precision_abj_75)/4]);
xticks([length(bar_offset_precision_abj_75)/4 length(bar_offset_precision_abj_75)/2 length(bar_offset_precision_abj_75)*(3/4)]);
xticklabels({'-60','0','60'});
ylim([0 1]);
ylabel('Offset precision');
xlabel('Time (s)');
title('Bar jumps');

subplot(1,2,2)
mean_offset_precision_around_wind_jump_25 = nanmean(bar_offset_precision_awj_25);
std_offset_precision_around_wind_jump_25 = std(bar_offset_precision_awj_25);
ste_offset_precision_around_wind_jump_25 = std_offset_precision_around_wind_jump_25/sqrt(size(short_bm_bar_jump,1)*2);
boundedline([1:size(bar_offset_precision_abj_25,2)],mean_offset_precision_around_wind_jump_25,ste_offset_precision_around_wind_jump_25,'cmap',gray)
hold on
line([length(bar_offset_precision_abj_25)/2 length(bar_offset_precision_abj_25)/2],[0 1],'color','r','linewidth',2,'linestyle','-.');
xlim([length(bar_offset_precision_abj_75)/4 3*length(bar_offset_precision_abj_75)/4]);
xticks([length(bar_offset_precision_abj_75)/4 length(bar_offset_precision_abj_75)/2 length(bar_offset_precision_abj_75)*(3/4)]);
xticklabels({'-60','0','60'});
ylim([0 1]);
xlabel('Time (s)');
title('Wind jumps');

saveas(gcf,[path,'\groupPlots\mean_offset_precision_aj_by_cue_type_25_frames.png'])


%% Repeat for 75 frames

figure('Position',[100 100 1400 1000]),
subplot(1,2,1)
mean_offset_precision_around_bar_jump_75 = nanmean(wind_offset_precision_abj_75);
std_offset_precision_around_bar_jump_75 = std(wind_offset_precision_abj_75);
ste_offset_precision_around_bar_jump_75 = std_offset_precision_around_bar_jump_75/sqrt(size(short_bm_bar_jump,1)*2);
boundedline([1:size(bar_offset_precision_abj_75,2)],mean_offset_precision_around_bar_jump_75,ste_offset_precision_around_bar_jump_75,'cmap',gray)
hold on
line([length(bar_offset_precision_abj_75)/2 length(bar_offset_precision_abj_75)/2],[0 1],'color','r','linewidth',2,'linestyle','-.');
xlim([length(bar_offset_precision_abj_75)/4 3*length(bar_offset_precision_abj_75)/4]);
xticks([length(bar_offset_precision_abj_75)/4 length(bar_offset_precision_abj_75)/2 length(bar_offset_precision_abj_75)*(3/4)]);
xticklabels({'-60','0','60'});
ylim([0 1]);
ylabel('Offset precision');
xlabel('Time (s)');
title('Bar jumps');

subplot(1,2,2)
mean_offset_precision_around_wind_jump_75 = nanmean(bar_offset_precision_awj_75);
std_offset_precision_around_wind_jump_75 = std(bar_offset_precision_awj_75);
ste_offset_precision_around_wind_jump_75 = std_offset_precision_around_wind_jump_25/sqrt(size(short_bm_bar_jump,1)*2);
boundedline([1:size(bar_offset_precision_abj_75,2)],mean_offset_precision_around_wind_jump_75,ste_offset_precision_around_wind_jump_75,'cmap',gray)
hold on
line([length(bar_offset_precision_abj_75)/2 length(bar_offset_precision_abj_75)/2],[0 1],'color','r','linewidth',2,'linestyle','-.');
xlim([length(bar_offset_precision_abj_75)/4 3*length(bar_offset_precision_abj_75)/4]);
xticks([length(bar_offset_precision_abj_75)/4 length(bar_offset_precision_abj_75)/2 length(bar_offset_precision_abj_75)*(3/4)]);
xticklabels({'-60','0','60'});
ylim([0 1]);
xlabel('Time (s)');
title('Wind jumps');

saveas(gcf,[path,'\groupPlots\mean_offset_precision_aj_by_cue_type_75_frames.png'])

%% Preference index (bump)

figure('Position',[100 100 1400 1000]),
boxplot(PI,'color','k')
hold on
yline(0);
scatter(repmat([1:length(data)],8,1),PI,[],[.5 .5 .5],'filled')
set(findobj(gca,'type','line'),'linew',2)
xlabel('Fly #');
ylabel('Bump preference index');
ylim([-1 1]);
    
saveas(gcf,[path,'\groupPlots\bump_PI_across_flies.png'])
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueJump-Experiment\bump_PI_across_flies.svg')

%Sorting it by the median PI
[~, median_sorting_order] = sort(median(PI));

figure('Position',[100 100 1400 1000]),
boxplot(PI(:,median_sorting_order),'color','k')
hold on
yline(0);
scatter(repmat([1:length(data)],8,1),PI(:,median_sorting_order),[],[.5 .5 .5],'filled')
set(findobj(gca,'type','line'),'linew',2)
xlabel('Fly #');
ylabel('Bump preference index');
ylim([-1 1]);

saveas(gcf,[path,'\groupPlots\bump_PI_across_flies_median_sorted.png'])
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueJump-Experiment\bump_PI_across_flies_median_sorted.svg')

%Sorting it by the mean PI
[~, mean_sorting_order] = sort(mean(PI));

figure('Position',[100 100 1400 1000]),
boxplot(PI(:,mean_sorting_order),'color','k')
hold on
yline(0);
scatter(repmat([1:length(data)],8,1),PI(:,mean_sorting_order),[],[.5 .5 .5],'filled')
set(findobj(gca,'type','line'),'linew',2)
xlabel('Fly #');
ylabel('Bump preference index');
ylim([-1 1]);

saveas(gcf,[path,'\groupPlots\bump_PI_across_flies_mean_sorted.png'])
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueJump-Experiment\bump_PI_across_flies_mean_sorted.svg')


%save data for stats
sorted_bump_PI = PI(:,mean_sorting_order);
writematrix(sorted_bump_PI,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp38\data\third_version\sorted_bump_PI.csv')

%% Behavioral preference index (bump)

figure('Position',[100 100 1400 1000]),
boxplot(heading_PI,'color','k')
hold on
yline(0);
scatter(repmat([1:length(data)],8,1),heading_PI,[],[.5 .5 .5],'filled')
set(findobj(gca,'type','line'),'linew',2)
xlabel('Fly #');
ylabel('Behavioral preference index');
ylim([-1 1]);
    
saveas(gcf,[path,'\groupPlots\heading_PI_across_flies.png'])
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueJump-Experiment\heading_PI_across_flies.svg')

%Sort by median of bump PI
figure('Position',[100 100 1400 1000]),
boxplot(heading_PI(:,median_sorting_order),'color','k')
hold on
yline(0);
scatter(repmat([1:length(data)],8,1),heading_PI(:,median_sorting_order),[],[.5 .5 .5],'filled')
set(findobj(gca,'type','line'),'linew',2)
xlabel('Fly #');
ylabel('Behavioral preference index');
ylim([-1 1]);

saveas(gcf,[path,'\groupPlots\heading_PI_across_flies_median_sorted.png'])
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueJump-Experiment\heading_PI_across_flies_median_sorted.svg')

%Sort by mean of bump PI
figure('Position',[100 100 1400 1000]),
boxplot(heading_PI(:,mean_sorting_order),'color','k')
hold on
yline(0);
scatter(repmat([1:length(data)],8,1),heading_PI(:,mean_sorting_order),[],[.5 .5 .5],'filled')
set(findobj(gca,'type','line'),'linew',2)
xlabel('Fly #');
ylabel('Behavioral preference index');
ylim([-1 1]);

saveas(gcf,[path,'\groupPlots\heading_PI_across_flies_mean_sorted.png'])
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueJump-Experiment\heading_PI_across_flies_mean_sorted.svg')

%save data for stats
sorted_heading_PI = heading_PI(:,mean_sorting_order);
writematrix(sorted_heading_PI,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp38\data\third_version\sorted_heading_PI.csv')


%% Stickiness index

figure('Position',[100 100 1400 1000]),
boxplot(SI,'color','k')
hold on
yline(0);
scatter(repmat([1:length(data)],8,1),SI,[],[.5 .5 .5],'filled')
set(findobj(gca,'type','line'),'linew',2)
xlabel('Fly #');
ylabel('Stickiness index');
ylim([-1 1]);
    
saveas(gcf,[path,'\groupPlots\SI_across_flies.png'])
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueJump-Experiment\SI_across_flies.svg')

%save data for analysis
writematrix(SI,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp38\data\third_version\SI.csv')


%% Relationship between bump and behavior preference index

bump_PI_across_flies = reshape(PI,8*length(data),1);
heading_PI_across_flies = reshape(heading_PI,8*length(data),1);

figure('Position',[100 100 900 900]),
plot(bump_PI_across_flies,heading_PI_across_flies,'ko','MarkerFaceColor','k')
xlabel('Bump preference index','fontsize',20);
ylabel('Heading preference index','fontsize',20);
line([0 0],[-1 1],'color','r','linewidth',2);
line([-1 1],[0 0],'color','r','linewidth',2);
xticks([-1:0.5:1]);
yticks([-1:0.5:1]);
ax = gca;
ax.FontSize = 16;

saveas(gcf,[path,'\groupPlots\bump_vs_heading_PI.png'])
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueJump-Experiment\bump_vs_heading_PI.svg')

all_PI_data = table(bump_PI_across_flies,heading_PI_across_flies,'VariableNames',{'bump PI','heading PI'});
writetable(all_PI_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp38\data\third_version\all_PI_data.csv')

%% Relationship between mean PI and initial cue precision ratio

%1) compute initial offset ratio
for fly = 1:length(data)
    initial_bar_offset_precision(fly) = circ_r(deg2rad(initial_bar_offset{fly}));
    initial_wind_offset_precision(fly) = circ_r(deg2rad(initial_wind_offset{fly}),[],[],2);
    initial_offset_ratio(fly) = initial_bar_offset_precision(fly)/initial_wind_offset_precision(fly);
end
%if the ratio < 1, then bar offset var < wind offset var

%2) relate preference index to initial offset variabililty
figure('Position',[100 100 1000 800]),
plot(initial_offset_ratio(configuration==1),pref_index(configuration==1),'ko','MarkerFaceColor','r','MarkerSize',12)
hold on
plot(initial_offset_ratio(configuration==2),pref_index(configuration==2),'ko','MarkerFaceColor','b','MarkerSize',12)
legend('Bar first','Wind first');
xlabel({'Initial offset precision ratio'; '(bar offset precision / wind offset precision)'},'fontsize',20);
ylabel('Bump preference index','fontsize',20);
ylim([-1 1]);
xline(1,'HandleVisibility','off','linewidth',2); yline(0,'HandleVisibility','off','linewidth',2);
xticks([0.5:0.5:2]);
yticks([-1:0.5:1]);
ax = gca;
ax.FontSize = 16;

saveas(gcf,[path,'\groupPlots\pref_ind_vs_initial_offset_precision.png'])
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueJump-Experiment\pref_ind_vs_initial_offset_precision.svg')

[rho,p] = corrcoef(initial_offset_ratio,pref_index)

%save data
repeated_offset_ratio = repmat(initial_offset_ratio,8,1);
offset_ratio_data = table(repeated_offset_ratio',PI','VariableNames',{'initial_offset_ratio','pref_index'});
offset_ratio_mean_data = table(initial_offset_ratio',pref_index,'VariableNames',{'initial_offset_ratio','pref_index'});
writetable(offset_ratio_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp38\data\third_version\offset_ratio_data.csv')
writetable(offset_ratio_mean_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp38\data\third_version\offset_ratio_mean_data.csv')


%% 3) repeat for behavioral preference index

figure,
plot(initial_offset_ratio(configuration==1),heading_pref_index(configuration==1),'ko','MarkerFaceColor','r')
hold on
plot(initial_offset_ratio(configuration==2),heading_pref_index(configuration==2),'ko','MarkerFaceColor','b')
legend('Bar first','Wind first');xlabel('Initial offset precision ratio (bar offset var / wind offset var)');
ylabel('Behavioral preference index');
ylim([-1 1]);
xline(1,'HandleVisibility','off'); yline(0,'HandleVisibility','off');
saveas(gcf,[path,'\groupPlots\heading_pref_ind_vs_initial_offset_precision.png'])
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueJump-Experiment\behavioral_pref_ind_vs_initial_offset_precision.svg')

[rho,p] = corrcoef(initial_offset_ratio,heading_pref_index)


%save data
offset_ratio_behavior_data = table(repeated_offset_ratio',heading_PI','VariableNames',{'initial_offset_ratio','heading_pref_index'});
writetable(offset_ratio_behavior_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp38\data\third_version\offset_ratio_behavior_data.csv')

%% Repeat with the opposite ratio to make sure the trend is real


%1) compute initial offset ratio
for fly = 1:length(data)
    initial_bar_offset_precision(fly) = circ_r(deg2rad(initial_bar_offset{fly}));
    initial_wind_offset_precision(fly) = circ_r(deg2rad(initial_wind_offset{fly}),[],[],2);
    initial_offset_ratio2(fly) = initial_wind_offset_precision(fly)/initial_bar_offset_precision(fly);
end
%if the ratio < 1, then bar offset var < wind offset var

%2) relate preference index to initial offset variabililty
figure('Position',[100 100 1000 800]),
plot(initial_offset_ratio2(configuration==1),pref_index(configuration==1),'ko','MarkerFaceColor','r','MarkerSize',12)
hold on
plot(initial_offset_ratio2(configuration==2),pref_index(configuration==2),'ko','MarkerFaceColor','b','MarkerSize',12)
legend('Bar first','Wind first');
xlabel({'Initial offset precision ratio'; '(wind offset precision / bar offset precision)'},'fontsize',20);
ylabel('Bump preference index','fontsize',20);
ylim([-1 1]);
xline(1,'HandleVisibility','off','linewidth',2); yline(0,'HandleVisibility','off','linewidth',2);
xticks([0.5:0.5:2]);
yticks([-1:0.5:1]);
ax = gca;
ax.FontSize = 16;

[rho,p] = corrcoef(initial_offset_ratio2,pref_index)
saveas(gcf,[path,'\groupPlots\pref_ind_vs_initial_offset_precision2.png'])

%save data
repeated_offset_ratio2 = repmat(initial_offset_ratio2,8,1);
offset_ratio_data2 = table(repeated_offset_ratio2',PI','VariableNames',{'initial_offset_ratio','pref_index'});
offset_ratio_mean_data2 = table(initial_offset_ratio2',pref_index,'VariableNames',{'initial_offset_ratio','pref_index'});
writetable(offset_ratio_data2,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp38\data\third_version\offset_ratio_data2.csv')
writetable(offset_ratio_mean_data2,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp38\data\third_version\offset_ratio_mean_data2.csv')


% 
% %% Look at PI evolution to see if there are consistent trends
% 
% for fly = 1:length(PI)
%     
%     figure,
%     plot(PI(:,fly),'-ko')
%     hold on
%     if configuration(fly) == 1
%        plot([1:2:8],PI(1:2:8,fly),'ko','MarkerFaceColor','r')
%        plot([2:2:8],PI(2:2:8,fly),'ko','MarkerFaceColor','b')       
%     else
%        plot([1:2:8],PI(1:2:8,fly),'ko','MarkerFaceColor','b')
%        plot([2:2:8],PI(2:2:8,fly),'ko','MarkerFaceColor','r')    
%     end
%     ylim([-1 1]);
%     ylabel('Preference index');
%     xlabel('Jump #');
%     yline(0);
%     title(['Fly #',num2str(fly)]);
%     
% end

%% Using the preference index computed as the ratio of means

figure,
plot(initial_offset_ratio,pref_index_2,'ko')
xlabel('Initial offset precision ratio (bar offset precision / wind offset precision)');
ylabel('Preference index');
ylim([-1 1]);
xline(1); yline(0);
saveas(gcf,[path,'\groupPlots\pref_ind_2_vs_initial_offset_precision.png'])


%% Relationship between mean PI and initial bump parameters ratio

%1) compute initial offset ratio
for fly = 1:length(data)
    initial_bm_ratio(fly) = mean(initial_bar_bm{fly})/mean(initial_wind_bm{fly});
    initial_bw_ratio(fly) = mean(initial_bar_bw{fly})/mean(initial_wind_bw{fly}); 
    initial_bm_ratio2(fly) = mean(initial_wind_bm{fly})/mean(initial_bar_bm{fly});
    initial_bw_ratio2(fly) = mean(initial_wind_bw{fly})/mean(initial_bar_bw{fly}); 
end
%if the ratio < 1, then bar offset var < wind offset var

%2) relate preference index to initial offset variabililty
figure('Position',[100 100 1600 800]),
subplot(1,2,1)
plot(initial_bm_ratio(configuration==1),pref_index(configuration==1),'ko','MarkerFaceColor','r','MarkerSize',8)
hold on
plot(initial_bm_ratio(configuration==2),pref_index(configuration==2),'ko','MarkerFaceColor','b','MarkerSize',8)
legend('Bar first','Wind first');
xlabel('Initial bump magnitude ratio (bar bm / wind bm)','fontsize',14);
ylabel('Preference index','fontsize',14);
ylim([-1 1]);
xline(1,'HandleVisibility','off'); yline(0,'HandleVisibility','off');

subplot(1,2,2)
plot(initial_bw_ratio(configuration==1),pref_index(configuration==1),'ko','MarkerFaceColor','r','MarkerSize',8)
hold on
plot(initial_bw_ratio(configuration==2),pref_index(configuration==2),'ko','MarkerFaceColor','b','MarkerSize',8)
legend('Bar first','Wind first');
xlabel('Initial bump width ratio (bar bw / wind bw)','fontsize',14);
ylabel('Preference index','fontsize',14);
ylim([-1 1]);
xline(1,'HandleVisibility','off'); yline(0,'HandleVisibility','off');

%save figure
saveas(gcf,[path,'\groupPlots\pref_ind_vs_initial_bump_pars.png'])
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueJump-Experiment\pref_ind_vs_initial_bump_pars.svg')

%save data
repeated_bm_ratio = repmat(initial_bm_ratio,8,1);
repeated_bw_ratio = repmat(initial_bw_ratio,8,1);
bump_pars_ratio_data = table(repeated_bm_ratio',repeated_bw_ratio',PI','VariableNames',{'initial_bm_ratio','initial_bw_ratio','pref_index'});
writetable(bump_pars_ratio_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp38\data\third_version\bump_pars_ratio_data.csv')
repeated_bm_ratio2 = repmat(initial_bm_ratio2,8,1);
repeated_bw_ratio2 = repmat(initial_bw_ratio2,8,1);
bump_pars_ratio_data2 = table(repeated_bm_ratio2',repeated_bw_ratio2',PI','VariableNames',{'initial_bm_ratio','initial_bw_ratio','pref_index'});
writetable(bump_pars_ratio_data2,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp38\data\third_version\bump_pars_ratio_data2.csv')


%% repeat with the inverse ratio

figure('Position',[100 100 1600 800]),
subplot(1,2,1)
plot(initial_bm_ratio2(configuration==1),pref_index(configuration==1),'ko','MarkerFaceColor','r','MarkerSize',8)
hold on
plot(initial_bm_ratio2(configuration==2),pref_index(configuration==2),'ko','MarkerFaceColor','b','MarkerSize',8)
legend('Bar first','Wind first');
xlabel('Initial bump magnitude ratio (wind bm / bar bm)','fontsize',14);
ylabel('Preference index','fontsize',14);
ylim([-1 1]);
xline(1,'HandleVisibility','off'); yline(0,'HandleVisibility','off');

subplot(1,2,2)
plot(initial_bw_ratio2(configuration==1),pref_index(configuration==1),'ko','MarkerFaceColor','r','MarkerSize',8)
hold on
plot(initial_bw_ratio2(configuration==2),pref_index(configuration==2),'ko','MarkerFaceColor','b','MarkerSize',8)
legend('Bar first','Wind first');
xlabel('Initial bump width ratio (wind bw / bar bw)','fontsize',14);
ylabel('Preference index','fontsize',14);
ylim([-1 1]);
xline(1,'HandleVisibility','off'); yline(0,'HandleVisibility','off');


saveas(gcf,[path,'\groupPlots\pref_ind_vs_initial_bump_pars2.png'])
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\CueJump-Experiment\pref_ind_vs_initial_bump_pars2.svg')


%% Repeat for behavioral index

figure('Position',[100 100 1600 800]),
subplot(1,2,1)
plot(initial_bm_ratio(configuration==1),heading_pref_index(configuration==1),'ko','MarkerFaceColor','r','MarkerSize',8)
hold on
plot(initial_bm_ratio(configuration==2),heading_pref_index(configuration==2),'ko','MarkerFaceColor','b','MarkerSize',8)
legend('Bar first','Wind first');
xlabel('Initial bump magnitude ratio (bar bm / wind bm)','fontsize',14);
ylabel('Preference index','fontsize',14);
ylim([-1 1]);
xline(1,'HandleVisibility','off'); yline(0,'HandleVisibility','off');

subplot(1,2,2)
plot(initial_bw_ratio(configuration==1),heading_pref_index(configuration==1),'ko','MarkerFaceColor','r','MarkerSize',8)
hold on
plot(initial_bw_ratio(configuration==2),heading_pref_index(configuration==2),'ko','MarkerFaceColor','b','MarkerSize',8)
legend('Bar first','Wind first');
xlabel('Initial bump width ratio (bar bw / wind bw)','fontsize',14);
ylabel('Preference index','fontsize',14);
ylim([-1 1]);
xline(1,'HandleVisibility','off'); yline(0,'HandleVisibility','off');


%% Offset precision vs bump parameters

figure,
subplot(1,2,1)
plot(initial_bar_offset_precision,cellfun(@mean,initial_bar_bm),'o')
xlabel('Offset precision'); ylabel('Bump magnitude');

subplot(1,2,2)
plot(initial_bar_offset_precision,cellfun(@mean,initial_bar_bw),'o')
xlabel('Offset precision'); ylabel('Bump width');

suptitle('Bar');

saveas(gcf,[path,'\groupPlots\offset_precision_bump_pars_bar.png'])



figure,
subplot(1,2,1)
plot(initial_wind_offset_precision,cellfun(@mean,initial_wind_bm),'o')
xlabel('Offset precision'); ylabel('Bump magnitude');

subplot(1,2,2)
plot(initial_wind_offset_precision,cellfun(@mean,initial_wind_bw),'o')
xlabel('Offset precision'); ylabel('Bump width');

suptitle('Wind');

saveas(gcf,[path,'\groupPlots\offset_precision_bump_pars_wind.png'])


%% Fly rot speed around the jumps

half_position = floor(size(long_rot_speed_bar_jump,2)/2);


figure('Position',[50 50 900 1000]),

%Bar jumps
subplot(9,2,[1,3,5,7])
imagesc(zscore(long_rot_speed_bar_jump(:,half_position-50:half_position+51),[],2))
hold on
line([50 50],[1 length(long_rot_speed_bar_jump)],'color','r','linewidth',2)
colormap(flipud(gray))
title('Bar jumps');

subplot(9,2,9)
plot(nanmean(long_rot_speed_bar_jump(:,half_position-50:half_position+51)),'k')
hold on
xline(50,'color','r','linewidth',2)
xlim([1 size(long_rot_speed_bar_jump(:,half_position-50:half_position+51),2)]);
ylim([0 50]);

subplot(9,2,[11,13,15,17]);
mean_aj_rot_speed_bar = [nanmean(long_rot_speed_bar_jump(:,half_position-9:half_position),2),nanmean(long_rot_speed_bar_jump(:,half_position+1:half_position+10),2)];
plot(mean_aj_rot_speed_bar','color',[.5 .5 .5])
hold on
plot(mean(mean_aj_rot_speed_bar),'-ko','linewidth',2)
xlim([0 3]);
xticks([1:2]);
xticklabels({'pre jump','post jump'});

%Wind jumps
subplot(9,2,[2,4,6,8])
imagesc(zscore(long_rot_speed_wind_jump(:,half_position-50:half_position+51),[],2))
hold on
line([50 50],[1 length(long_rot_speed_wind_jump)],'color','r','linewidth',2)
colormap(flipud(gray))
title('Wind jumps');

subplot(9,2,10)
plot(nanmean(long_rot_speed_wind_jump(:,half_position-50:half_position+51)),'k')
hold on
xline(50,'color','r','linewidth',2)
xlim([1 size(long_rot_speed_wind_jump(:,half_position-50:half_position+51),2)]);
ylim([0 50]);

subplot(9,2,[12,14,16,18]);
mean_aj_rot_speed_wind = [nanmean(long_rot_speed_wind_jump(:,half_position-50:half_position),2),nanmean(long_rot_speed_wind_jump(:,half_position+1:half_position+51),2)];
plot(mean_aj_rot_speed_wind','color',[.5 .5 .5])
hold on
plot(mean(mean_aj_rot_speed_wind),'-ko','linewidth',2)
xlim([0 3]);
xticks([1:2]);
xticklabels({'pre jump','post jump'});

suptitle('Rotational speed');

%% Simpler version of the plot

figure('Position',[50 50 1000 400]),

frames_to_sec = 1/9.18;
time = linspace(-51*frames_to_sec,51*frames_to_sec,102);

%Bar jumps
subplot(1,2,1)
plot(time,nanmean(long_rot_speed_bar_jump(:,half_position-50:half_position+51)),'k')
hold on
xline(0,'color','r','linewidth',2)
xlim([-5 5]);
ylim([0 50]);
title('Bar jumps');
ylabel('Rotational speed (deg/s)');

%Wind jumps
subplot(1,2,2)
plot(time,nanmean(long_rot_speed_wind_jump(:,half_position-50:half_position+51)),'k')
hold on
xline(0,'color','r','linewidth',2)
xlim([-5 5]);
ylim([0 50]);
title('Wind jumps');

%save data for statistical analysis
rot_speed_abj = long_rot_speed_bar_jump(:,half_position-50:half_position+51);
rot_speed_awj = long_rot_speed_wind_jump(:,half_position-50:half_position+51);

writematrix(rot_speed_abj,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp38\data\third_version\rot_speed_abj.csv')
writematrix(rot_speed_abj,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp38\data\third_version\rot_speed_awj.csv')

%% Repeat for total movement

figure('Position',[50 50 900 1000]),

%Bar jumps
subplot(9,2,[1,3,5,7])
imagesc(zscore(long_total_mvt_bar_jump(:,half_position-50:half_position+51),[],2))
hold on
line([50 50],[1 length(long_total_mvt_bar_jump)],'color','r','linewidth',2)
colormap(flipud(gray))
title('Bar jumps');

subplot(9,2,9)
plot(nanmean(long_total_mvt_bar_jump(:,half_position-50:half_position+51)),'k')
hold on
xline(50,'color','r','linewidth',2)
xlim([1 size(long_total_mvt_bar_jump(:,half_position-50:half_position+51),2)]);
ylim([0 200]);

subplot(9,2,[11,13,15,17]);
mean_aj_total_mvt_bar = [nanmean(long_total_mvt_bar_jump(:,half_position-50:half_position),2),nanmean(long_total_mvt_bar_jump(:,half_position+1:half_position+51),2)];
plot(mean_aj_total_mvt_bar','color',[.5 .5 .5])
hold on
plot(mean(mean_aj_total_mvt_bar),'-ko','linewidth',2)
xlim([0 3]);
xticks([1:2]);
xticklabels({'pre jump','post jump'});

%Wind jumps
subplot(9,2,[2,4,6,8])
imagesc(zscore(long_total_mvt_wind_jump(:,half_position-50:half_position+51),[],2))
hold on
line([50 50],[1 length(long_total_mvt_wind_jump)],'color','r','linewidth',2)
colormap(flipud(gray))
title('Wind jumps');

subplot(9,2,10)
plot(nanmean(long_total_mvt_wind_jump(:,half_position-50:half_position+51)),'k')
hold on
xline(50,'color','r','linewidth',2)
xlim([1 size(long_total_mvt_wind_jump(:,half_position-50:half_position+51),2)]);
ylim([0 200]);

subplot(9,2,[12,14,16,18]);
mean_aj_total_mvt_wind = [nanmean(long_total_mvt_wind_jump(:,half_position-50:half_position),2),nanmean(long_total_mvt_wind_jump(:,half_position+1:half_position+51),2)];
plot(mean_aj_total_mvt_wind','color',[.5 .5 .5])
hold on
plot(mean(mean_aj_total_mvt_wind),'-ko','linewidth',2)
xlim([0 3]);
xticks([1:2]);
xticklabels({'pre jump','post jump'});

suptitle('Total movement');


%% Clear space

clear all; close all;
