%code to analyze experiment 40 (offset control)

close all; clear all;

%get directory
[path] = uigetdir('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Offset_control\data');
fileNames = dir([path,'\analysis']);

%get session information
session_info = load([path,'\analysis\session_info.mat']);

%% Make dir to save plots

mkdir([path,'\analysis'],'\plots')

%% 

%load files
for file = 1:length(fileNames)
    
    if contains(fileNames(file).name,'continuous')
        
        %load the data
        load(fullfile(fileNames(file).folder,fileNames(file).name))
               
        %Plot full trial
        figure('Position',[100 100 1800 1000]),
        subplot(5,1,1)
        dff = continuous_data.dff_matrix';
        imagesc(flip(dff))
        colormap(flipud(gray))
        title('EPG activity');
        set(gca,'xticklabel',{[]});
        set(gca,'yticklabel',{[]});
        
        subplot(5,1,2)
        bump_pos = wrapTo180(rad2deg(continuous_data.bump_pos));
        %Remove wrapped lines to plot
        [x_out_bump,bump_to_plot] = removeWrappedLines(continuous_data.time,bump_pos');
        plot(x_out_bump,bump_to_plot,'LineWidth',1.5)
        hold on
        %add fly position
        fly_pos = wrapTo180(-continuous_data.heading_deg);
        [x_out_fly,fly_to_plot] = removeWrappedLines(continuous_data.time,fly_pos);
        plot(x_out_fly,fly_to_plot,'.','LineWidth',1.5)
        title('Bump and fly position');
        legend('Bump estimate','Fly position')
        ylim([-180 180]);
        xlim([0 x_out_bump(end-1)]);
        set(gca,'xticklabel',{[]})
        
        subplot(5,1,3)
        offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
        [x_out_offset,offset_to_plot] = removeWrappedLines(continuous_data.time,offset);
        plot(x_out_offset,offset_to_plot,'LineWidth',1.5,'color',[0.8500 0.3250 0.0980])
        title('Offset');
        ylim([-180 180]);
        xlim([0 x_out_offset(end-1)]);
        set(gca,'xticklabel',{[]})
        
        subplot(5,1,4)
        plot(continuous_data.time(continuous_data.adj_rs>=0.5),continuous_data.bump_magnitude(continuous_data.adj_rs>=0.5),'r.','handleVisibility','off')
        hold on
        plot(continuous_data.time(continuous_data.adj_rs<0.5),continuous_data.bump_magnitude(continuous_data.adj_rs<0.5),'k.','handleVisibility','off')
        title('Bump magnitude')
        xlim([0 continuous_data.time(end)]);
        set(gca,'xticklabel',{[]})
        
        subplot(5,1,5)
        plot(continuous_data.time(continuous_data.adj_rs>=0.5),continuous_data.bump_width(continuous_data.adj_rs>=0.5),'r.','handleVisibility','off')
        hold on
        plot(continuous_data.time(continuous_data.adj_rs<0.5),continuous_data.bump_width(continuous_data.adj_rs<0.5),'k.','handleVisibility','off')
        xlabel('Time (sec)');
        title('Bump width');
        xlim([0 continuous_data.time(end)]);
        
        %store relevant data
        %determine type of trial
        sid = str2num(fileNames(file).name(25:end-10));
        
        if sid == session_info.session_info.empty
            trial = 'empty';
            offset_empty = offset(continuous_data.total_mvt_ds > 25);
            bump_mag_empty = nanmean(continuous_data.bump_magnitude(continuous_data.adj_rs>=0.45 & continuous_data.total_mvt_ds > 25));
            bump_width_empty = nanmean(continuous_data.bump_width(continuous_data.adj_rs>=0.45 & continuous_data.total_mvt_ds > 25));
        elseif sid == session_info.session_info.bar
            trial = 'bar';
            offset_bar = offset(continuous_data.total_mvt_ds > 25);
            bump_mag_bar = nanmean(continuous_data.bump_magnitude(continuous_data.adj_rs>=0.45 & continuous_data.total_mvt_ds > 25));
            bump_width_bar = nanmean(continuous_data.bump_width(continuous_data.adj_rs>=0.45 & continuous_data.total_mvt_ds > 25));
        else
            trial = 'wind';
            offset_wind = offset(continuous_data.total_mvt_ds > 25);
            bump_mag_wind = nanmean(continuous_data.bump_magnitude(continuous_data.adj_rs>=0.45 & continuous_data.total_mvt_ds > 25));
            bump_width_wind = nanmean(continuous_data.bump_width(continuous_data.adj_rs>=0.45 & continuous_data.total_mvt_ds > 25));
        end
        
        
    end
       
end

%% Plot offset distribution

%Plot offset distribution
figure,
subplot(1,3,1)
polarhistogram(deg2rad(offset_empty),15,'FaceColor',[.5 .5 .5])
title('Empty trial');
rticklabels({});
set(gca,'ThetaZeroLocation','top');

subplot(1,3,2)
polarhistogram(deg2rad(offset_wind),15,'FaceColor',[.5 .5 .5])
title('Wind trial');
rticklabels({})
set(gca,'ThetaZeroLocation','top');

subplot(1,3,3)
polarhistogram(deg2rad(offset_bar),15,'FaceColor',[.5 .5 .5])
title('Bar trial');
rticklabels({})
set(gca,'ThetaZeroLocation','top');

saveas(gcf,[path,'\analysis\plots\offset_distribution.png'])

%% Get and plot offset variability 

[~, offset_var_empty] = circ_std(deg2rad(offset_empty));
[~, offset_var_wind] = circ_std(deg2rad(offset_wind));
[~, offset_var_bar] = circ_std(deg2rad(offset_bar));

all_offset_var = [offset_var_empty,offset_var_wind,offset_var_bar];

figure,
plot(all_offset_var,'-ko')
xlim([0 4]);
ylim([0 3]);
xticks([1:3]);
xticklabels({'Empty trial','Wind trial','Bar trial'});
ylabel('Offset variability (rad)');

%save figure
saveas(gcf,[path,'\analysis\plots\offset_var.png'])

%% Get and plot offset precision

offset_precision_empty = circ_r(deg2rad(offset_empty));
offset_precision_wind = circ_r(deg2rad(offset_wind));
offset_precision_bar = circ_r(deg2rad(offset_bar));

all_offset_precision = [offset_precision_empty,offset_precision_wind,offset_precision_bar];

figure,
plot(all_offset_precision,'-ko')
xlim([0 4]);
ylim([0 1]);
xticks([1:3]);
xticklabels({'Empty trial','Wind trial','Bar trial'});
ylabel('Offset precision');

%save figure
saveas(gcf,[path,'\analysis\plots\offset_precision.png'])

%% Plot bump parameters

all_bump_mag = [bump_mag_empty,bump_mag_wind,bump_mag_bar];
all_bump_width = [bump_width_empty,bump_width_wind,bump_width_bar];

figure,
subplot(1,2,1)
plot(all_bump_mag,'-ko')
xlim([0 4]);
%ylim([0 1]);
xticks([1:3]);
xticklabels({'Empty trial','Wind trial','Bar trial'});
ylabel('Bump magnitude');

subplot(1,2,2)
plot(all_bump_width,'-ko')
xlim([0 4]);
%ylim([0 1]);
xticks([1:3]);
xticklabels({'Empty trial','Wind trial','Bar trial'});
ylabel('Bump width');

%save figure
saveas(gcf,[path,'\analysis\plots\bump_pars.png'])

%% Save data

save([path,'\analysis\offset_var_data.mat'],'offset_var_bar','offset_var_wind','offset_var_empty')
save([path,'\analysis\offset_precision_data.mat'],'offset_precision_bar','offset_precision_wind','offset_precision_empty','bump_mag_bar','bump_mag_wind','bump_mag_empty','bump_width_bar','bump_width_wind','bump_width_empty')

%%
clear all; close all;
