%analysis for the stabilizing offset bout

%% Load data

clear all; close all;

path = uigetdir('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental');

load([path,'\sessions_info.mat'])

sid = sessions_info.offset_stabilizer;
load([path,'\analysis\continuous_analysis_sid_',num2str(sid),'_tid_0.mat'])

%% Make directory to save plots

%Move to the analysis folder
cd([path,'\analysis'])
%List the contents
contents = dir();
%if there isn't a 'plots' folder already, create one
if (contains([contents.name],'continuous_plots') == 0)
   mkdir(path,'continuous_plots'); 
end

%% Plot heatmap with bar position, phase and offset

figure('Position',[200 200 1000 600]),
subplot(3,6,[1 5])
%Plot heatmap of EPG activity
dff_matrix = continuous_data.dff_matrix';
imagesc(flip(dff_matrix))
colormap(flipud(gray))
ylabel('PB glomerulus','fontweight','bold','fontsize',12);
set(gca,'ytick',[]);
set(gca,'yticklabel',{[]});
title('EPG activity in the PB','fontweight','bold','fontsize',12);
set(gca,'xtick',[]);
set(gca,'xticklabel',{[]});

subplot(3,6,[7 11])
%Get bar position to plot
bar_position = wrapTo180(continuous_data.panel_angle);
%Remove lines that wrap around using auxiliary function
[x_bar_pos,bar_position_to_plot] = removeWrappedLines(continuous_data.time,bar_position);
plot(x_bar_pos,bar_position_to_plot,'LineWidth',1.5,'color',[0.2 0.6 0.7])
hold on
%Get EPG phase to plot
phase = wrapTo180(rad2deg(continuous_data.bump_pos'));
%Remove lines that wrap around using auxiliary function
[x_out_phase,phase_to_plot] = removeWrappedLines(continuous_data.time,phase);
plot(x_out_phase,phase_to_plot,'LineWidth',1.5,'color',[0.9 0.3 0.4])
xlim([0 x_out_phase(end-1)]);
ylim([-180 180]);
legend('Bar position','EPG phase','Location','EastOutside')
%Set legend outside of the plot so that it doesn't occlude the traces
axP = get(gca,'Position');
set(gca, 'Position', axP);
ylabel('Deg','fontweight','bold','fontsize',12);
title('Bar and bump position','fontweight','bold','fontsize',12);
set(gca,'xticklabel',{[]})

subplot(3,6,[13 17])
%Get offset to plot
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
%Remove lines that wrap around using auxiliary function
[x_out_offset,offset_to_plot] = removeWrappedLines(continuous_data.time,offset);
plot(x_out_offset,offset_to_plot,'k','LineWidth',1.5)
xlim([0 x_out_offset(end)]);
ylim([-180 180]);
xlabel('Time (sec)','fontweight','bold','fontsize',12);
ylabel('Deg','fontweight','bold','fontsize',12);
title('Offset','fontweight','bold','fontsize',12);

%Plot circular offset distribution
subplot(3,6,18)
polarhistogram(deg2rad(offset),'FaceColor','k')
set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','counterclockwise');
title('Offset distribution','fontweight','bold','fontsize',12);
rticklabels({}); %remove rticklabels

%Save figure
saveas(gcf,[path,'\analysis\continuous_plots\offset_stabilizer_block_heatmap.png']);

%% Offset precision

%computed over 60 sec windows, ignoring times when the fly is standing
%still
%I will analyze offset variability by computing a rolling window of circular
%standard deviation of offset and taking the inverse
fcn_precision = @(x) circ_r(x);
fcn_mean = @(x) nanmean(x);
%Compute the offset variability and precision over different window sizes, from 1 s to
%50 s
window_sizes= 550;
moving = continuous_data.total_mvt_ds > 25;
gof = continuous_data.adj_rs > 0.5;
for window = 1:length(window_sizes)
    offset_precision(:,window) = matlab.tall.movingWindow(fcn_precision,window_sizes(window),deg2rad(offset(moving)));
    %bump_mag(:,window) = matlab.tall.movingWindow(fcn_mean,window_sizes(window),continuous_data.bump_magnitude(moving & gof));
    bump_mag(:,window) = movmean(continuous_data.bump_magnitude(moving & gof),window_sizes);
    bump_width(:,window) = movmean(continuous_data.bump_width(moving & gof),window_sizes);
end

time = continuous_data.time;

figure('Position',[100 100 1200 1000]),
subplot(3,1,1)
plot(time(moving),offset_precision)
xlabel('Time (sec)'); ylabel('Offset precision');
ylim([0.5 1]);

subplot(3,1,2)
plot(time(moving & gof),bump_mag)
xlabel('Time (sec)'); ylabel('Bump magnitude');
ylim([0.5 2]);

subplot(3,1,3)
plot(time(moving & gof),bump_width)
xlabel('Time (sec)'); ylabel('Bump width');
ylim([1 2]);


%% Save data

save([path,'\offset_stabilizer_data.mat'],'offset_precision','bump_mag','bump_width');

%% Clear space

clear all; close all;