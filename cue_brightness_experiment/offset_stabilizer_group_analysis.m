%group analysis for the offset stabilizer block

clear all; close all;

%% Load data

path = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts';
%Get folder names
folderContents = dir(path);

%Load the summary data of the folder that correspond to experimental flies
for content = 1:length(folderContents)
    if contains(folderContents(content).name,'60D05')
        data(content) = load([folderContents(content).folder,'\',folderContents(content).name,'\analysis\offset_stabilizer_data.mat']);
    end
end

%% Clean and combine data

%Remove empty rows
data = data(all(~cellfun(@isempty,struct2cell(data))));

all_mvt_data = array2table(zeros(0,5),'VariableNames', {'zbump_magnitude','zbump_width','total_mvt','rot_speed','for_vel'});
flyNumber= [];
for fly = 1:length(data)
    flyNumber = [flyNumber,repelem(fly,length(data(fly).all_mvt_data.zbump_width))];
    all_mvt_data = [all_mvt_data;data(fly).all_mvt_data]; 
end

%Add the fly ID as a variable
if size(all_mvt_data,2) < 6
    all_mvt_data = addvars(all_mvt_data,nominal(flyNumber'));
    all_mvt_data.Properties.VariableNames{'Var6'} = 'Fly';
end

%save table to file for statistical analysis in R
writetable(all_mvt_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts\all_mvt_data_offset_stabilizer.csv');



all_thresh_mvt_data = array2table(zeros(0,3),'VariableNames', {'zbump_mag','zbump_width','rot_speed'});
flyNum= [];
for fly = 1:length(data)
    flyNum = [fly,repelem(fly,length(data(fly).all_thresh_mvt_data.zbump_width))];
    all_thresh_mvt_data = [all_thresh_mvt_data;data(fly).all_thresh_mvt_data]; 
end

%Add the fly ID as a variable
if size(all_thresh_mvt_data,2) < 4
    all_thresh_mvt_data = addvars(all_thresh_mvt_data,nominal(flyNum'));
    all_thresh_mvt_data.Properties.VariableNames{'Var4'} = 'Fly';
end

%save table to file for statistical analysis in R
writetable(all_thresh_mvt_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts\all_thresh_mvt_data_offset_stabilizer.csv');



%% Plot offset precision and bump parameters

%With all flies
figure,

for fly = 1:length(data)
    
    subplot(3,1,1)
    plot(data(fly).time(data(fly).moving),data(fly).offset_precision)
    hold on
    ylabel('Offset precision');
    
    subplot(3,1,2)
    plot(data(fly).time(data(fly).moving & data(fly).gof),data(fly).bump_mag)
    hold on
    ylabel('Bump magnitude');
    
    subplot(3,1,3)
    plot(data(fly).time(data(fly).moving & data(fly).gof),data(fly).bump_width)
    hold on
    ylabel('Bump width');
    xlabel('Time (sec)');
       
end

%% Plot heading precision

figure,

for fly = 1:length(data)
    
    plot(data(fly).time(data(fly).moving),data(fly).heading_precision)
    hold on
    ylabel('Heading precision');
       
end

%% Compare offset precision when moving and standing

figure
for fly = 1:length(data)
    standing_offset_precision(fly) = data(fly).global_standing_offset_precision;
    offset_precision(fly) = data(fly).global_offset_precision;    
   plot([standing_offset_precision;offset_precision],'color',[.6 .6 .6]) 
   hold on
end
plot(mean([standing_offset_precision;offset_precision],2),'k','linewidth',2);
xlim([0 3]);
xticks([1:2]);
xticklabels({'Standing','Moving'});
ylim([0 1]);
ylabel('Offset precision');


%% Compare bump pars when moving and standing

figure

subplot(1,2,1)
for fly = 1:length(data)
    standing_bump_mag(fly) = data(fly).mean_bump_mag_standing;
    moving_bump_mag(fly) = data(fly).mean_bump_mag_moving;    
   plot([standing_bump_mag;moving_bump_mag],'color',[.6 .6 .6]) 
   hold on
end
plot(mean([standing_bump_mag;moving_bump_mag],2),'k','linewidth',2);
xlim([0 3]);
xticks([1:2]);
xticklabels({'Standing','Moving'});
ylim([0.5 3]);
ylabel('Bump magnitude');

subplot(1,2,2)
for fly = 1:length(data)
    standing_bump_width(fly) = data(fly).mean_bump_width_standing;
    moving_bump_width(fly) = data(fly).mean_bump_width_moving;    
   plot([standing_bump_width;moving_bump_width],'color',[.6 .6 .6]) 
   hold on
end
plot(mean([standing_bump_width;moving_bump_width],2),'k','linewidth',2);
xlim([0 3]);
xticks([1:2]);
xticklabels({'Standing','Moving'});
ylim([0.5 3]);
ylabel('Bump width');