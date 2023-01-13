
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
short_bm_bar_jump = [];
short_bw_bar_jump = [];
short_bm_wind_jump = [];
short_bw_wind_jump = [];

long_bm_bar_jump = [];
long_bw_bar_jump = [];
long_bm_wind_jump = [];
long_bw_wind_jump = [];

short_offset_bar_jump = [];
short_offset_wind_jump = [];
long_offset_bar_jump = [];
long_offset_wind_jump = [];

for fly = 1:length(data)
    
    short_bm_bar_jump = [short_bm_bar_jump;data(fly).short_bm_bar_jump];
    short_bw_bar_jump = [short_bw_bar_jump;data(fly).short_bw_bar_jump];
    short_bm_wind_jump = [short_bm_wind_jump;data(fly).short_bm_wind_jump];
    short_bw_wind_jump = [short_bw_wind_jump;data(fly).short_bw_wind_jump];
    
    long_bm_bar_jump = [long_bm_bar_jump;data(fly).long_bm_bar_jump];
    long_bw_bar_jump = [long_bw_bar_jump;data(fly).long_bw_bar_jump];
    long_bm_wind_jump = [long_bm_wind_jump;data(fly).long_bm_wind_jump];
    long_bw_wind_jump = [long_bw_wind_jump;data(fly).long_bw_wind_jump];
    
    short_offset_bar_jump = [short_offset_bar_jump;data(fly).short_offset_bar_jump];
    short_offset_wind_jump = [short_offset_wind_jump;data(fly).short_offset_wind_jump];
    long_offset_bar_jump = [long_offset_bar_jump;data(fly).long_offset_bar_jump];
    long_offset_wind_jump = [long_offset_wind_jump;data(fly).long_offset_wind_jump];   
    
end


%% Debug the bar jump lengths

% for jump = 1:length(short_offset_bar_jump)
%     
%     figure,
%     plot(short_offset_bar_jump(jump,:))
%     hold on
%     xline(19)
%     plot(19,short_offset_bar_jump(jump,19),'ro')
%     plot(20,short_offset_bar_jump(jump,20),'ro')
%     ylim([-180 180])
%     bar_offset_change(jump) = wrapTo180(short_offset_bar_jump(jump,20)-short_offset_bar_jump(jump,19));
%     title(['Bar offset change = ',num2str(bar_offset_change(jump))]);
%     
% end

bar_offset_change = wrapTo180(short_offset_bar_jump(:,20)-short_offset_bar_jump(:,19));

%Issues appear to come from:
%(1) sometimes the detected jump frame is one frame off
%(2) sometimes the jump appears to happen over two frames rather than one
%(possibly from smoothing?)
%(3) smoothing is likely making the jumps appear bigger or smaller at times
%*I will check all raw jumps to ensure they have the proper size


%Manual correction based on inspection of each case

%identify problems with each of the problematic cases
%jump 2: jump could be occurring over 2 frames, though it's hard to tell.
%In that case, it could make sense to omit frame 20
short_offset_bar_jump(2,:) = [short_offset_bar_jump(2,[1:19,21:end]),NaN];
%jump 3: jump potentially occurring over 2 frames, starting in frame 18.
%In that case, omit frame 19 and add nan at the beginning
short_offset_bar_jump(11,:) = [NaN,short_offset_bar_jump(3,[1:18,20:end])];

%jump 11: look at the raw data

%jump 14: could be happening over 2-3 frames?
short_offset_bar_jump(14,:) = [short_offset_bar_jump(14,[1:19,21:end]),NaN];
%jump 17: appears either to be happening over two frames, or to be shifted
%by 1 frame
short_offset_bar_jump(17,:) = [short_offset_bar_jump(17,[1:19,21:end]),NaN];
%jump 19: appears either to be happening over two frames, or to be shifted
%by 1 frame
short_offset_bar_jump(19,:) = [short_offset_bar_jump(19,[1:19,21:end]),NaN];
%jump 22: appears to be happening over two frames
short_offset_bar_jump(22,:) = [NaN,short_offset_bar_jump(22,[1:18,20:end])];
%jump 25: appears either to be happening over two frames
short_offset_bar_jump(25,:) = [short_offset_bar_jump(25,[1:19,21:end]),NaN];
%jump 26: appears either to be happening over two frames
short_offset_bar_jump(26,:) = [short_offset_bar_jump(26,[1:19,21:end]),NaN];
%jump 27: appears to be shifted by 1 frame
short_offset_bar_jump(27,:) = [NaN,short_offset_bar_jump(27,1:end-1)];
%jump 31: appears either to be happening over two frames, or to be shifted
%by 1 frame
short_offset_bar_jump(31,:) = [short_offset_bar_jump(31,[1:19,21:end]),NaN];
%jump 33: I think it's shifted by one frame
short_offset_bar_jump(33,:) = [NaN,short_offset_bar_jump(33,1:end-1)];
%jump 43: appears to be happening over two frames
short_offset_bar_jump(43,:) = [short_offset_bar_jump(43,[1:19,21:end]),NaN];
%jump 45: is shifted by one frame
short_offset_bar_jump(45,:) = [NaN,short_offset_bar_jump(45,1:end-1)];
%jump 45: is shifted by one frame
short_offset_bar_jump(46,:) = [NaN,short_offset_bar_jump(46,1:end-1)];
%jump 47: appears to be happening over two frames
short_offset_bar_jump(47,:) = [short_offset_bar_jump(47,[1:19,21:end]),NaN];
%jump 48: is shifted by one frame
short_offset_bar_jump(48,:) = [NaN,short_offset_bar_jump(48,1:end-1)];
%jump 50: appears to be happening over two frames
short_offset_bar_jump(50,:) = [short_offset_bar_jump(50,[1:19,21:end]),NaN];
%jump 56: appears shifted by one frame
short_offset_bar_jump(56,:) = [short_offset_bar_jump(56,2:end),NaN];

shifted_offset_short_bar = wrapTo180(short_offset_bar_jump-short_offset_bar_jump(:,19));

figure('Position',[100 100 600 600]),
imagesc(shifted_offset_short_bar)
colorbar
gray_wrap = vertcat(gray,flipud(gray));
colormap(gray_wrap)
hold on
xline(19.5,'r','linewidth',2)
xticks([1 19.5 37])
xticklabels({'-2','0','2'})
title('Bar jumps');


%%  Debug the wind jump lengths
% 
% for jump = 54%1:length(short_offset_wind_jump)
%     
%     figure,
%     plot(short_offset_wind_jump(jump,:))
%     hold on
%     xline(19)
%     plot(19,short_offset_wind_jump(jump,19),'ro')
%     plot(23,short_offset_wind_jump(jump,23),'ro')
%     ylim([-180 180])
%     wind_offset_change(jump) = wrapTo180(short_offset_wind_jump(jump,23)-short_offset_wind_jump(jump,19));
%     title(['Wind offset change = ',num2str(wind_offset_change(jump))]);
%     
% end


wind_offset_change = wrapTo180(short_offset_wind_jump(:,23)-short_offset_wind_jump(:,19));

%Issues appear to come from:
%(1) sometimes the detected jump frame is one frame off
%(2) sometimes the jump appears to happen over two frames rather than one
%(possibly from smoothing?)
%(3) weird wrapping issues with smoothing.
%*I will check all raw jumps to ensure they have the proper size

% %delete weird wrapping issues with smoothing
% for jump = 54%:length(short_offset_wind_jump)
%     test = short_offset_wind_jump(jump,:);
%     [~,short_offset_wind_jump(jump,:)] = removeWrappedLines([1:size(short_offset_wind_jump,2)]',test');
% end


%Manual correction based on inspection of each case
%jump 4: appears to be shifted by 1 frame
short_offset_wind_jump(4,:) = [NaN,short_offset_wind_jump(4,1:end-1)];
%jump 10: appears to be shifted by 1 frame
short_offset_wind_jump(10,:) = [NaN,short_offset_wind_jump(10,1:end-1)];
%jump 22: appears to be shifted by 1 frame
short_offset_wind_jump(22,:) = [NaN,short_offset_wind_jump(22,1:end-1)];
%jump 4: appears to be shifted by 2-3 frames? it's unclear
short_offset_wind_jump(24,:) = [short_offset_wind_jump(24,3:end),NaN,NaN];
%jump 35: appears to be shifted by 1 frame
short_offset_wind_jump(35,:) = [short_offset_wind_jump(35,2:end),NaN];
%jump 44: appears to be shifted by 1 frame
short_offset_wind_jump(44,:) = [NaN,short_offset_wind_jump(44,1:end-1)];

% %test manual corrections
figure,
jump = 44;
test = [NaN,short_offset_wind_jump(44,1:end-1)];
plot(test)
hold on
xline(19)
plot(19,test(19),'ro')
plot(24,test(24),'ro')
ylim([-180 180])
wind_offset_change = wrapTo180(test(24)-test(19));
title(['Wind offset change = ',num2str(wind_offset_change)]);

shifted_offset_short_wind = wrapTo180(short_offset_wind_jump-short_offset_wind_jump(:,19));
figure('Position',[100 100 600 600]),
imagesc(shifted_offset_short_wind)
colorbar
gray_wrap = vertcat(gray,flipud(gray));
colormap(gray_wrap)
hold on
xline(19.5,'r','linewidth',2)
xticks([1 19.5 37])
xticklabels({'-2','0','2'})
title('Wind jumps');

%% Analysis for the short time period

%Bump amplitude

%calculate the mean bump amplitude 2 sec pre-jump
mean_short_bm_bar = mean(short_bm_bar_jump(:,1:19),2);
mean_short_bm_wind = mean(short_bm_wind_jump(:,1:19),2);
%sort
[sorted_BM,Imb] = sort(mean_short_bm_bar);
[sorted_BM,Imw] = sort(mean_short_bm_wind);

%shift offset
shifted_offset_short_bar = wrapTo180(short_offset_bar_jump-short_offset_bar_jump(:,19));
shifted_offset_short_wind = wrapTo180(short_offset_wind_jump-short_offset_wind_jump(:,19));


%Plot offset around jumps
figure('Position',[100 100 600 600]),
subplot(2,1,1)
imagesc(shifted_offset_short_bar(Imb,2:end-1))
colorbar
gray_wrap = vertcat(gray,flipud(gray));
colormap(gray_wrap)
hold on
xline(18.5,'r','linewidth',2)
xticks([9.25 18.5 27.75])
xticklabels({'-1','0','1'})
title('Bar jumps');

subplot(2,1,2)
imagesc(shifted_offset_short_wind(Imw,2:end-1))
colorbar
gray_wrap = vertcat(gray,flipud(gray));
colormap(gray_wrap)
hold on
xline(18.5,'r','linewidth',2)
xticks([9.25 18.5 27.75])
xticklabels({'-1','0','1'})
title('Wind shifts');

suptitle('Offset');

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\short_cue_shift_offset_changes_sorted_by_BM.svg')


%% Analysis for the longer time period

%correct jumps
%bar
%identify problems with each of the problematic cases
%jump 2: jump could be occurring over 2 frames, though it's hard to tell.
%In that case, it could make sense to omit frame 20
long_offset_bar_jump(2,:) = [long_offset_bar_jump(2,[1:1103,1105:end]),NaN];
%jump 3: jump potentially occurring over 2 frames, starting in frame 18.
%In that case, omit frame 19 and add nan at the beginning
long_offset_bar_jump(11,:) = [NaN,long_offset_bar_jump(3,[1:1102,1104:end])];
%jump 14: could be happening over 2-3 frames?
long_offset_bar_jump(14,:) = [long_offset_bar_jump(14,[1:1103,1105:end]),NaN];
%jump 17: appears either to be happening over two frames, or to be shifted
%by 1 frame
long_offset_bar_jump(17,:) = [long_offset_bar_jump(17,[1:1103,1105:end]),NaN];
%jump 19: appears either to be happening over two frames, or to be shifted
%by 1 frame
long_offset_bar_jump(19,:) = [long_offset_bar_jump(19,[1:1103,1105:end]),NaN];
%jump 22: appears to be happening over two frames
long_offset_bar_jump(22,:) = [NaN,long_offset_bar_jump(22,[1:1102,1104:end])];
%jump 25: appears either to be happening over two frames
long_offset_bar_jump(25,:) = [long_offset_bar_jump(25,[1:1103,1105:end]),NaN];
%jump 26: appears either to be happening over two frames
long_offset_bar_jump(26,:) = [long_offset_bar_jump(26,[1:1103,1105:end]),NaN];
%jump 27: appears to be shifted by 1 frame
long_offset_bar_jump(27,:) = [NaN,long_offset_bar_jump(27,1:end-1)];
%jump 31: appears either to be happening over two frames, or to be shifted
%by 1 frame
long_offset_bar_jump(31,:) = [long_offset_bar_jump(31,[1:1103,1105:end]),NaN];
%jump 33: I think it's shifted by one frame
long_offset_bar_jump(33,:) = [NaN,long_offset_bar_jump(33,1:end-1)];
%jump 43: appears to be happening over two frames
long_offset_bar_jump(43,:) = [long_offset_bar_jump(43,[1:1103,1105:end]),NaN];
%jump 45: is shifted by one frame
long_offset_bar_jump(45,:) = [NaN,long_offset_bar_jump(45,1:end-1)];
%jump 45: is shifted by one frame
long_offset_bar_jump(46,:) = [NaN,long_offset_bar_jump(46,1:end-1)];
%jump 47: appears to be happening over two frames
long_offset_bar_jump(47,:) = [long_offset_bar_jump(47,[1:1103,1105:end]),NaN];
%jump 48: is shifted by one frame
long_offset_bar_jump(48,:) = [NaN,long_offset_bar_jump(48,1:end-1)];
%jump 50: appears to be happening over two frames
long_offset_bar_jump(50,:) = [long_offset_bar_jump(50,[1:1103,1105:end]),NaN];
%jump 56: appears shifted by one frame
long_offset_bar_jump(56,:) = [long_offset_bar_jump(56,2:end),NaN];

%wind
%jump 4: appears to be shifted by 1 frame
long_offset_wind_jump(4,:) = [NaN,long_offset_wind_jump(4,1:end-1)];
%jump 10: appears to be shifted by 1 frame
long_offset_wind_jump(10,:) = [NaN,long_offset_wind_jump(10,1:end-1)];
%jump 22: appears to be shifted by 1 frame
long_offset_wind_jump(22,:) = [NaN,long_offset_wind_jump(22,1:end-1)];
%jump 4: appears to be shifted by 2-3 frames? it's unclear
long_offset_wind_jump(24,:) = [long_offset_wind_jump(24,3:end),NaN,NaN];
%jump 35: appears to be shifted by 1 frame
long_offset_wind_jump(35,:) = [long_offset_wind_jump(35,2:end),NaN];
%jump 44: appears to be shifted by 1 frame
long_offset_wind_jump(44,:) = [NaN,long_offset_wind_jump(44,1:end-1)];


%shift offset
shifted_offset_long_bar = wrapTo180(long_offset_bar_jump-long_offset_bar_jump(:,1103));
shifted_offset_long_wind = wrapTo180(long_offset_wind_jump-long_offset_wind_jump(:,1103));


%Plot offset around jumps
figure('Position',[100 100 1800 600]),
subplot(1,2,1)
imagesc(shifted_offset_long_bar(Imb,1103-19:1103+550))
colorbar
gray_wrap = vertcat(gray,flipud(gray));
colormap(gray_wrap)
hold on
xline(20.5,'r','linewidth',2)
xticks([1 19.5 203.17 382.84 570.5])
xticklabels({'-2','0','20','40','60'})
xlabel('Time around cue shift (s)');
title('Bar jumps');

subplot(1,2,2)
imagesc(shifted_offset_long_wind(Imw,1103-19:1103+550))
colorbar
gray_wrap = vertcat(gray,flipud(gray));
colormap(gray_wrap)
hold on
xline(20.5,'r','linewidth',2)
xticks([1 19.5 203.17 383.84  570.5])
xticklabels({'-2','0','20','40','60'})
xlabel('Time around cue shift (s)');
title('Wind jumps');

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\long_cue_shift_offset_changes_sorted_by_BM.svg')
