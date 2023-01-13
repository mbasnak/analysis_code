%load data

clear all; close all;

%% Load data

path = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts';
%Get folder names
folderContents = dir(path);

%Load the summary data of the folder that correspond to experimental flies
for content = 1:length(folderContents)
   if contains(folderContents(content).name,'60D05')
       data(content) = load([folderContents(content).folder,'\',folderContents(content).name,'\analysis\continuous_summary_data.mat']);
   end
end

%Remove empty rows
data = data(all(~cellfun(@isempty,struct2cell(data))));


%% Get bump par data around the cues

%initialize empty variables
bm_d_to_b = [];
bw_d_to_b = [];
bm_b_to_d = [];
bw_b_to_d = [];

%For each fly
for fly = 1:length(data)
    
    %Find the bouts of darkness (contrast 1)
    darkness_frames = find(data(fly).modelTable.ContrastLevel < 2);
    block_change = find(diff(darkness_frames)>1);
    darkness_blocks{1} = darkness_frames(1):darkness_frames(block_change);
    darkness_blocks{2} = darkness_frames(block_change+1):darkness_frames(end);
    
    %For each bout of darkness
    for block = 1:2
        
        %Find transition darkness to high brightness
        
        %Find the last frame of the bout
        end_dblock(block) = darkness_blocks{block}(end);
        
        %if there is a bout after it, find its ID
        if length(data(fly).modelTable.ContrastLevel) > end_dblock(block) + 200
            
            id_block_after_d = data(fly).modelTable.ContrastLevel(end_dblock(block) + 10);
            
            %if it's ID is high contrast (contrast 3)
            if id_block_after_d == 3
                
                %Find the hc block
                bright_frames_on = data(fly).modelTable.ContrastLevel(end_dblock(block) + 1 : end);
                block_changes = find(abs(diff(bright_frames_on))>0.5);
                end_bblock = block_changes(1);
                bright_block = end_dblock(block)+1 : end_dblock(block)+1+end_bblock;
                
                %get the BM and BW values from start of bout level 1 to end
                %of bout level 3
                bm_darkness_to_bright{fly,block} = data(fly).modelTable.BumpMagnitude(darkness_blocks{block}(1):bright_block(end));
                bw_darkness_to_bright{fly,block} = data(fly).modelTable.BumpWidth(darkness_blocks{block}(1):bright_block(end));
                
                %only keep values where the gof > 0.5
                gof = data(fly).modelTable.AdjRSquare(darkness_blocks{block}(1):bright_block(end));
                bm_darkness_to_bright{fly,block}(gof < 0.5) = NaN;
                bw_darkness_to_bright{fly,block}(gof < 0.5) = NaN;
                
                %Linearly interpolate the bump par data to all have the same length
                bm_d_block = interp1(darkness_blocks{block}(1):darkness_blocks{block}(end),bm_darkness_to_bright{fly,block}(1:length(darkness_blocks{block})),linspace(darkness_blocks{block}(1),darkness_blocks{block}(end),1836));
                bm_b_block = interp1(bright_block(1):bright_block(end),bm_darkness_to_bright{fly,block}(length(darkness_blocks{block})+1:end),linspace(bright_block(1),bright_block(end),1836));
                full_bm = [bm_d_block,bm_b_block];
                bm_d_to_b = [bm_d_to_b;full_bm];
                
                bw_d_block = interp1(darkness_blocks{block}(1):darkness_blocks{block}(end),bw_darkness_to_bright{fly,block}(1:length(darkness_blocks{block})),linspace(darkness_blocks{block}(1),darkness_blocks{block}(end),1836));
                bw_b_block = interp1(bright_block(1):bright_block(end),bw_darkness_to_bright{fly,block}(length(darkness_blocks{block})+1:end),linspace(bright_block(1),bright_block(end),1836));
                full_bw = [bw_d_block,bw_b_block];
                bw_d_to_b = [bw_d_to_b;full_bw];
                
            end
            
        end
        
        %Find transition high brightness to darkness
        
        %Find the first frame of the bout
        start_dblock(block) = darkness_blocks{block}(1);
        
        %if there is a bout before it, find its ID
         if start_dblock(block) - 200 > 0
            
            id_block_before_d = data(fly).modelTable.ContrastLevel(start_dblock(block) - 10);
            
            %if it's ID is high contrast (contrast 3)
            if id_block_before_d == 3
                
                %Find the hc block
                bright_frames_on = data(fly).modelTable.ContrastLevel(1 : start_dblock(block)-1);
                block_changes = find(abs(diff(bright_frames_on))>0.5);
                if ~isempty(block_changes)
                    start_bblock = block_changes(end);
                else
                    start_bblock = 1;
                end
                bright_block = start_bblock : start_dblock(block)-1;
                
                %get the BM and BW values from start of bout level 1 to end
                %of bout level 3
                bm_bright_to_darkness{fly,block} = data(fly).modelTable.BumpMagnitude(bright_block(1):darkness_blocks{block}(end));
                bw_bright_to_darkness{fly,block} = data(fly).modelTable.BumpWidth(bright_block(1):darkness_blocks{block}(end));
                
                %only keep values where the gof > 0.5
                gof = data(fly).modelTable.AdjRSquare(bright_block(1):darkness_blocks{block}(end));
                bm_bright_to_darkness{fly,block}(gof < 0.5) = NaN;
                bw_bright_to_darkness{fly,block}(gof < 0.5) = NaN;
                
                %Linearly interpolate the bump par data to all have the same length
                bm_b_block = interp1(bright_block(1):bright_block(end),bm_bright_to_darkness{fly,block}(1:length(bright_block)),linspace(bright_block(1),bright_block(end),1836));
                bm_d_block = interp1(darkness_blocks{block}(1):darkness_blocks{block}(end),bm_bright_to_darkness{fly,block}(length(bright_block)+1:end),linspace(darkness_blocks{block}(1),darkness_blocks{block}(end),1836));            
                full_bm = [bm_b_block,bm_d_block];
                bm_b_to_d = [bm_b_to_d;full_bm];
                
                bw_b_block = interp1(bright_block(1):bright_block(end),bw_bright_to_darkness{fly,block}(1:length(bright_block)),linspace(bright_block(1),bright_block(end),1836));
                bw_d_block = interp1(darkness_blocks{block}(1):darkness_blocks{block}(end),bw_bright_to_darkness{fly,block}(length(bright_block)+1:end),linspace(darkness_blocks{block}(1),darkness_blocks{block}(end),1836));                
                full_bw = [bw_b_block,bw_d_block];
                bw_b_to_d = [bw_b_to_d;full_bw];
                
            end
         end
        
    end
end


%% Get rolling means

for fly = 1:10
    
    rolling_bm_d_to_b(fly,:) = movmean(bm_d_to_b(fly,:),100,'omitnan');
    rolling_bw_d_to_b(fly,:) = movmean(bw_d_to_b(fly,:),100,'omitnan');
    
    rolling_bm_b_to_d(fly,:) = movmean(bm_b_to_d(fly,:),100,'omitnan');
    rolling_bw_b_to_d(fly,:) = movmean(bw_b_to_d(fly,:),100,'omitnan');
    
end

%% Plot

%create time vector
frames = 1:length(rolling_bm_d_to_b);
shifted_frames = frames-1836;
time = shifted_frames / 9.18;

figure('Position',[100,100,1200,1000]),

%darkness to brightness
%bump width
subplot(2,2,1)
boundedline(time,rad2deg(mean(rolling_bw_d_to_b,'omitnan')),rad2deg(std(rolling_bw_d_to_b,'omitnan'))/sqrt(10),'k')
ylabel('Mean bump width')
title('No cue to bright cue');
hold on
xline(0,'color','r','linewidth',2)
ylim([70 130]);
%add horizontal lines with means
d_bw_mean = mean(rad2deg(nanmean(rolling_bw_d_to_b(:,1:1836))));
line([time(1),0],[d_bw_mean,d_bw_mean]);
b_bw_mean = mean(rad2deg(nanmean(rolling_bw_d_to_b(:,1837:end))));
line([0,time(end)],[b_bw_mean,b_bw_mean]);

%bump amplitude
subplot(2,2,3)
boundedline(time,mean(rolling_bm_d_to_b,'omitnan'),std(rolling_bm_d_to_b,'omitnan')/sqrt(10),'k')
ylabel('Mean bump amplitude')
xlabel('Time around the cue (sec)')
hold on
xline(0,'color','r','linewidth',2)
ylim([1 2]);
%add horizontal lines with means
d_bm_mean = mean(nanmean(rolling_bm_d_to_b(:,1:1836)));
line([time(1),0],[d_bm_mean,d_bm_mean]);
b_bm_mean = mean(nanmean(rolling_bm_d_to_b(:,1837:end)));
line([0,time(end)],[b_bm_mean,b_bm_mean]);

%brightness to darkness
subplot(2,2,2)
boundedline(time,rad2deg(nanmean(rolling_bw_b_to_d)),rad2deg(std(rolling_bw_b_to_d,'omitnan'))/sqrt(10),'k')
ylabel('Mean bump width')
title('Bright cue to no cue');
hold on
xline(0,'color','r','linewidth',2)
ylim([70 130]);
%add horizontal lines with means
b_bw_mean = mean(rad2deg(nanmean(rolling_bw_b_to_d(:,1:1836))));
line([time(1),0],[b_bw_mean,b_bw_mean]);
d_bw_mean = mean(rad2deg(nanmean(rolling_bw_b_to_d(:,1837:end))));
line([0,time(end)],[d_bw_mean,d_bw_mean]);

%bump amplitude
subplot(2,2,4)
boundedline(time,nanmean(rolling_bm_b_to_d),std(rolling_bm_b_to_d,'omitnan')/sqrt(10),'k')
ylabel('Mean bump amplitude')
xlabel('Time around the cue (sec)')
hold on
xline(0,'color','r','linewidth',2)
ylim([1 2]);
%add horizontal lines with means
b_bm_mean = mean(nanmean(rolling_bm_b_to_d(:,1:1836)));
line([time(1),0],[b_bm_mean,b_bm_mean]);
d_bm_mean = mean(nanmean(rolling_bm_b_to_d(:,1837:end)));
line([0,time(end)],[d_bm_mean,d_bm_mean]);

print('-painters','-dsvg','C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\ExtraFigures\change_in_bump_par_around_cue.svg') 
