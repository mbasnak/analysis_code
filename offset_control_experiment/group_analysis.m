%Code to analyze the pooled data for the offset control

clear all; close all;

%% Load data

path = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Offset_control\data';

folderNames = dir(path);

for folder = 1:length(folderNames)
   if (contains(folderNames(folder).name,'60D05') ==1)
       data(folder) = load(fullfile(path,folderNames(folder).name,'analysis\offset_precision_data.mat'));
   end
end

%Remove empty rows
data = data(all(~cellfun(@isempty,struct2cell(data))));

reordered_data = [data(:).offset_precision_bar;data(:).offset_precision_wind;data(:).offset_precision_empty];

%Save data for stats
all_offset_precision = [data(:).offset_precision_bar,data(:).offset_precision_wind,data(:).offset_precision_empty];
block_type = [repelem(1,1,length(data)),repelem(2,1,length(data)),repelem(3,1,length(data))];
fly_num = [1:10,1:10,1:10];
offset_precision_data = table(all_offset_precision',block_type',fly_num','VariableNames',{'offset_precision','block','fly'});
writetable(offset_precision_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Offset_control\data\offset_precision_data.csv');

%% Plot offset precision

figure,
plot(reordered_data,'-o','color',[.5 .5 .5])
hold on
errorbar(1:3,mean(reordered_data,2),std(reordered_data,[],2)/sqrt(size(reordered_data,2)),'-ko','LineWidth',2,'MarkerFaceColor','k','MarkerSize',6)
xticks(1:3);
xlim([0 4]);
xticklabels({'Bar','Wind','Empty'});
ylim([0 1]);
ylabel('Offset precision');

saveas(gcf,[path,'\groupPlots\offset_precision.png']);
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Offset-Control\offset_precision.svg');

%% Plot bump parameters


figure,

subplot(1,2,1)
bump_mag_data = [data(:).bump_mag_bar;data(:).bump_mag_wind;data(:).bump_mag_empty];
plot(bump_mag_data,'-o','color',[.5 .5 .5])
hold on
errorbar(1:3,mean(bump_mag_data,2),std(bump_mag_data,[],2)/sqrt(size(bump_mag_data,2)),'-ko','LineWidth',2,'MarkerFaceColor','k','MarkerSize',6)
xticks(1:3);
xlim([0 4]);
xticklabels({'Bar','Wind','Empty'});
ylim([0 2.5]);
ylabel('Bump mag');

subplot(1,2,2)
bump_width_data = [data(:).bump_width_bar;data(:).bump_width_wind;data(:).bump_width_empty];
plot(bump_width_data,'-o','color',[.5 .5 .5])
hold on
errorbar(1:3,mean(bump_width_data,2),std(bump_width_data,[],2)/sqrt(size(bump_width_data,2)),'-ko','LineWidth',2,'MarkerFaceColor','k','MarkerSize',6)
xticks(1:3);
xlim([0 4]);
xticklabels({'Bar','Wind','Empty'});
ylim([1 3]);
ylabel('Bump width');

saveas(gcf,[path,'\groupPlots\bump_pars.png']);
saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Offset-Control\bump_pars.svg');

%Save data for stats
all_bump_mag = [data(:).bump_mag_bar,data(:).bump_mag_wind,data(:).bump_mag_empty];
all_bump_width = [data(:).bump_width_bar,data(:).bump_width_wind,data(:).bump_width_empty];
bump_pars_data = table(all_bump_mag',all_bump_width',block_type',fly_num','VariableNames',{'bump_mag','bump_width','block','fly'});
writetable(bump_pars_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Offset_control\data\bump_pars_data.csv');

%% Plot relationship between offset precision and bump parameters

%1) For the empty trials
figure,
subplot(1,2,1)
for fly = 1:length(data)
   plot(data(fly).offset_precision_empty,data(fly).bump_mag_empty,'o')
    hold on
end
xlabel('Offset precision'); ylabel('Bump magnitude');

subplot(1,2,2)
for fly = 1:length(data)
   plot(data(fly).offset_precision_empty,data(fly).bump_width_empty,'o')
    hold on
end
xlabel('Offset precision'); ylabel('Bump width');


%2) For the bar trials
figure,
subplot(1,2,1)
for fly = 1:length(data)
   plot(data(fly).offset_precision_bar,data(fly).bump_mag_bar,'o')
    hold on
end
xlabel('Offset precision'); ylabel('Bump magnitude');

subplot(1,2,2)
for fly = 1:length(data)
   plot(data(fly).offset_precision_bar,data(fly).bump_width_bar,'o')
    hold on
end
xlabel('Offset precision'); ylabel('Bump width');

%3) For the wind trials
figure,
subplot(1,2,1)
for fly = 1:length(data)
   plot(data(fly).offset_precision_wind,data(fly).bump_mag_wind,'o')
    hold on
end
xlabel('Offset precision'); ylabel('Bump magnitude');

subplot(1,2,2)
for fly = 1:length(data)
   plot(data(fly).offset_precision_wind,data(fly).bump_width_wind,'o')
    hold on
end
xlabel('Offset precision'); ylabel('Bump width');


%% Clear space

clear all; close all;