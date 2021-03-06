%code to plot example flies for the different panels

%% Example fly for figure 1

clear all; close all;
load('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts\20201027_60D05_7f\analysis\continuous_analysis_sid_1_tid_0.mat');

%identify changes in contrast
change_y_panels = abs(diff(continuous_data.fr_y_ds));
changeContrast = find(abs(diff(continuous_data.fr_y_ds))>1);

%Plot
% Plot the heatmap of EPG activity
figure('Position',[0 0 1800 500]),
ax(1) = subplot(3,1,1);
dff_matrix = continuous_data.dff_matrix(changeContrast(1):changeContrast(4),1:41)';
imagesc(flip(dff_matrix))
colormap(flipud(gray))
hold on
xline(length(dff_matrix)/3,'r','linestyle','--','linewidth',2)
xline(2*length(dff_matrix)/3,'r','linestyle','--','linewidth',2)
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gca,'xtick',[])
set(gca,'ytick',[])

colormap(ax(1),flipud(gray));
pos = get(subplot(3,1,1),'Position');
h = colorbar('Position', [pos(1)+pos(3)+0.01  pos(2)  pos(3)/60  pos(4)]);

% Plot the heading and the EPG phase
ax(2) = subplot(3,1,2);
%Get heading to plot
visual_stim = wrapTo180(continuous_data.visual_stim_pos(changeContrast(1):changeContrast(4)));
%Remove wrapped lines to plot
[x_out_heading,visual_stim_to_plot] = removeWrappedLines(continuous_data.time(changeContrast(1):changeContrast(4)),visual_stim);
x_out_heading = x_out_heading - x_out_heading(1);
plot(x_out_heading,visual_stim_to_plot,'LineWidth',1.5,'color',[0.4940 0.1840 0.5560])
hold on
phase = wrapTo180(rad2deg(continuous_data.bump_pos(changeContrast(1):changeContrast(4))'));
[x_out_phase,phase_to_plot] = removeWrappedLines(continuous_data.time(changeContrast(1):changeContrast(4)),phase);
x_out_phase = x_out_phase - x_out_phase(1);
plot(x_out_phase,phase_to_plot,'color',[0.4660 0.6740 0.1880],'LineWidth',1.5)
xline(200,'r','linestyle','--','linewidth',2)
xline(400,'r','linestyle','--','linewidth',2)
ylim([-180, 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
if ~isnan(x_out_phase(end))
    xlim([x_out_phase(1),x_out_phase(end)]);
else
    xlim([x_out_phase(1),x_out_phase(end-1)]);
end
set(gca,'XTickLabel',[]);
set(gca,'XTick',[]);
ax = gca;
ax.FontSize = 14;

ax(3) = subplot(3,1,3);
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos(changeContrast(1):changeContrast(4))',deg2rad(visual_stim))));
%Change time to min
time = continuous_data.time/60;
[x_out_offset,offset_to_plot] = removeWrappedLines(time(changeContrast(1):changeContrast(4)),offset);
x_out_offset = x_out_offset - x_out_offset(1);
plot(x_out_offset,offset_to_plot,'k','LineWidth',1.5)
hold on
xline(200/60,'r','linestyle','--','linewidth',2)
xline(400/60,'r','linestyle','--','linewidth',2)
ylim([-180 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
xlabel('Time (min)','fontsize',20);
if ~isnan(x_out_offset(end))
    xlim([x_out_offset(1) x_out_offset(end)]);
else
    xlim([x_out_offset(1) x_out_offset(end-1)]);
end
ax = gca;
ax.FontSize = 14;


saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\Fig1\example_fly_fig1.svg')
save('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts\example_fly_fig1.mat','dff_matrix','visual_stim_to_plot','phase_to_plot','offset_to_plot','x_out_offset','x_out_phase','x_out_heading');


%polarhistograms
figure('Position',[0 0 1800 800]),
subplot(1,3,1)
polarhistogram(deg2rad(offset(1:floor(length(offset)/3))),15,'FaceColor','k','FaceAlpha',.3,'EdgeAlpha',0.3)
hold on
offset_mean = circ_mean(deg2rad(offset(1:floor(length(offset)/3))));
offset_strength = circ_r(deg2rad(offset(1:floor(length(offset)/3))));
rl = rlim;
polarplot([offset_mean,offset_mean],[0,rl(2)*offset_strength],'k','linewidth',6)
set(gca,'ThetaZeroLocation','top',...
    'ThetaDir','clockwise');
rticklabels({}); 
rticks([]);
thetaticks([0,90,180,270]);
ax = gca;
ax.FontSize = 20;

subplot(1,3,2)
polarhistogram(deg2rad(offset(floor(length(offset)/3):floor(2*length(offset)/3))),15,'FaceColor','k','FaceAlpha',.3,'EdgeAlpha',0.3)
hold on
offset_mean = circ_mean(deg2rad(offset(floor(length(offset)/3):floor(2*length(offset)/3))));
offset_strength = circ_r(deg2rad(offset(floor(length(offset)/3):floor(2*length(offset)/3))));
rl = rlim;
polarplot([offset_mean,offset_mean],[0,rl(2)*offset_strength],'k','linewidth',6)
set(gca,'ThetaZeroLocation','top',...
    'ThetaDir','clockwise');
rticklabels({}); 
rticks([]);
thetaticks([0,90,180,270]);
ax = gca;
ax.FontSize = 20;

subplot(1,3,3)
polarhistogram(deg2rad(offset(floor(2*length(offset)/3):end)),15,'FaceColor','k','FaceAlpha',.3,'EdgeAlpha',0.3)
hold on
offset_mean = circ_mean(deg2rad(offset(floor(2*length(offset)/3):end)));
offset_strength = circ_r(deg2rad(offset(floor(2*length(offset)/3):end)));
rl = rlim;
polarplot([offset_mean,offset_mean],[0,rl(2)*offset_strength],'k','linewidth',6)
set(gca,'ThetaZeroLocation','top',...
    'ThetaDir','clockwise');
rticklabels({});
rticks([]);
thetaticks([0,90,180,270]);
ax = gca;
ax.FontSize = 20;

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\Fig1\example_fly_fig1_histograms.svg')

%% Example of gof fit for figure 1 (darkness and low contrast, high R2)

clear all; close all;

path = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts\20201027_60D05_7f';
sid = 1;

tid = 0; %I only ever run 1 trial per session

global slash;
if isunix() == 1 %if running in Linux or mac
    slash = '/'; %define the slash this way
else %if running in windows
    slash = '\'; %define the other way
end
set(0,'DefaultTextInterpreter','none');

% Load the imaging data

%Move to the folder of interest
cd(path)

%Load the roi data 
load(['2p' slash 'ROI' slash 'ROI_midline_sid_' num2str(sid) '_tid_' num2str(tid) '.mat']);
%Load the registered imaging stack
load(['2p' slash 'sid_' num2str(sid) '_tid_' num2str(tid) slash 'rigid_sid_' num2str(sid) '_tid_' num2str(tid) '_Chan_1_sessionFile.mat']);

% Get the summed GCaMP7f data
%add the data across the z layers making up each volume, to obtain 1 PB image per timepoint
summedData = squeeze(sum(regProduct,3));

% Get midline coordinates and PB mask
%1) Find the row corresponding to the midline
for row = 1:length(roi)
    if contains(roi(row).name,'mid')
        roi_mid = row;
    end
end

%2) Pull up the coordinates that make up the midline along the PB
midline_coordinates = [roi(roi_mid).xi,roi(roi_mid).yi];

%3) Get the 'vector lengths' for each section of the line, to know how much
%distance of the PB they represent
midline_segment_lengths = zeros(length(midline_coordinates)-1,1);
for segment = 1:length(midline_coordinates)-1
    midline_segment_lengths(segment) = sqrt( (midline_coordinates(segment+1,1)-midline_coordinates(segment,1))^2 + (midline_coordinates(segment+1,2)-midline_coordinates(segment,2))^2 );
end
midline_distances = cumsum(midline_segment_lengths);

%4) Pull up the locations for all the px in the PB mask
PB_mask = zeros(size(regProduct,1),size(regProduct,2));
for row = 1:length(roi)
    if row~=roi_mid
        PB_mask = PB_mask + roi(row).BW;
    end
end
PB_mask(PB_mask>1) = 1;
PB_coverage = logical(PB_mask);

% Get the normal line across each small segment of the PB midline

midV = cell(1,length(midline_coordinates)-1);
normal1 = cell(1,length(midline_coordinates)-1);
normal2 = cell(1,length(midline_coordinates)-1);
point1 = cell(1,length(midline_coordinates)-1);
point2 = cell(1,length(midline_coordinates)-1);

for segment = 1:length(midline_coordinates)-1
    
    y_part = [midline_coordinates(segment,1),midline_coordinates(segment,2)];
    x_part = [midline_coordinates(segment+1,1),midline_coordinates(segment+1,2)];
    V = y_part - x_part;
    midV{segment} = x_part + 0.5 * V;
    normal1{segment} = [ V(2), -V(1)];
    normal2{segment} = [-V(2),  V(1)];
    
    point1{segment} = [midV{segment}(1), midV{segment}(2)];
    point2{segment} = [midV{segment}(1) + normal1{segment}(1), midV{segment}(2) + normal1{segment}(2)];
end

% Assign fluorescence across the PB to the corresponding closest point in the midline

%Initialize variables
midline_ff = zeros(length(midline_coordinates)-1,size(summedData,3)); %start empty midline brightness vector
PB_Image = cell(1,size(summedData,3));

%For each timepoint
for timepoint = 1:size(summedData,3)
    
    PB_Image{timepoint} = summedData(:,:,timepoint);
    PB_Image{timepoint}(PB_coverage == 0) = 0;
    
    %For each of those locations, find the distance to each normal in the
    %midline
    for row = 1:size(PB_coverage,1)
        for column = 1:size(PB_coverage,2)
            if PB_coverage(row,column) == 1
                %for every normal to the midline
                for norm_line = 1:length(normal1)
                    % Get the distance to that normal
                    dist_to_midline(norm_line) = GetPointLineDistance(column,row,point1{norm_line}(1),point1{norm_line}(2),point2{norm_line}(1),point2{norm_line}(2));
                end
                %find the minimum distance
                [~, Imin] = min(dist_to_midline);
                %add intensity value of that pixel to that point in the midline
                midline_ff(Imin,timepoint) = midline_ff(Imin,timepoint) + PB_Image{timepoint}(row,column);
            end
        end
    end
        
end

% Get baseline and compute DF/F

%1) Get the baseline fluorescence
baseline_f = zeros(1,length(midline_coordinates)-1);

for segment = 1:length(midline_coordinates)-1
    
    sorted_f = sort(midline_ff(segment,:));
    %Get baseline as the tenth percentile
    baseline_f(segment) = prctile(sorted_f,10);  
    
end

%2) Compute df/f
dff = (midline_ff'-baseline_f)./baseline_f;

dff_data = dff;

angular_midline_distances = midline_distances*(2*pi + 2*pi*(7/8))/max(midline_distances);
%put back on circle
angular_midline_distances_2pi = mod(angular_midline_distances,2*pi);

%2) Create the fit function
fo = fitoptions('Method','NonlinearLeastSquares',...
    'Lower',[0,-inf,0,-inf],... % [a,c,k,u]
    'StartPoint',[1,0,1,0]);

ft = fittype('a*exp(k*cos(x-u))+c','options',fo);
%
for timepoint = [5518:100:7344]
    
    %4) Fit the data
    data_to_fit = dff_data(timepoint,:);
    [model_data, gof] = fit(angular_midline_distances_2pi,data_to_fit',ft,...
        'MaxIter',20000,'MaxFunEvals',20000);
    adj_rs(timepoint) = gof.adjrsquare;
    
    %5) Get the coefficient values.
    coeff_names = coeffnames(ft);
    coefficientValues = coeffvalues(model_data);
    a = coefficientValues(strcmp(coeff_names,'a'));
    k = coefficientValues(strcmp(coeff_names,'k'));
    u = coefficientValues(strcmp(coeff_names,'u'));
    c = coefficientValues(strcmp(coeff_names,'c'));
    
    %6) Get bump parameters
    bump_pos(timepoint) = mod(u,2*pi);
    bump_mag(timepoint) = a * ( exp(k) - exp(-k) );
    bump_width(timepoint) = rad2deg(2 * abs( acos( 1/k * log( 1/2 *( exp(k) + exp(-k) )))));
    %The above math gives you back the bump width in radians. You need a
    %factor conversion to change to EB wedges or tiles
     
    
    %7) Uncomment to plot the original data and the fit
    figure,
    subplot(2,1,1)
    plot(angular_midline_distances,dff_data(timepoint,:)')
    hold on
    plot(angular_midline_distances,feval(model_data,angular_midline_distances))
    %add the bump position estimate
    plot(bump_pos(timepoint),feval(model_data,bump_pos(timepoint)),'ro')
    xlabel('Angular distance (radians)');
    ylabel('DF/F');
    title(['Frame #',num2str(timepoint),' AdjR2 =',num2str(gof.adjrsquare)]);
    legend('data','fit');
    %Add the bump parameters
    subplot(2,1,2)
    text(0,0.5,['Bump magnitude = ',num2str(bump_mag(timepoint))]);
    hold on
    text(0.5,0.5,['Bump width = ',num2str(bump_width(timepoint))]);
    text(0.25,0,['Bump pos = ',num2str(u)]); axis off
    
%     data = dff(timepoint,:);
%     fit_data = feval(model_data,angular_midline_distances);
%     example_data_fit = table(angular_midline_distances,data',fit_data,'VariableNames',{'distance','data','fit'});
%     writetable(example_data_fit,['Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts\example_data_fit_',num2str(timepoint),'.csv'])

end



%% Example fly for figure 3

clear all; close all;

load('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\20210218_60D05_7f\analysis\continuous_analysis_sid_0_tid_0.mat');

gof = continuous_data.adj_rs > 0.4;

figure('Position',[50 50 1800 900]),
ax(1) = subplot(6,1,1);
dff_matrix = continuous_data.dff_matrix';
imagesc(flip(dff_matrix))
colormap(flipud(gray))
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gca,'xtick',[])
set(gca,'ytick',[])
xlim([400*9.18, 650*9.18]);

colormap(ax(1),flipud(gray));
pos = get(subplot(6,1,1),'Position');
h = colorbar('Position', [pos(1)+pos(3)+0.01  pos(2)  pos(3)/60  pos(4)]);

% Plot the heading and the EPG phase
ax(2) = subplot(6,1,2);
%Get heading to plot
visual_stim = wrapTo180(continuous_data.visual_stim_pos);
%Remove wrapped lines to plot
[x_out_heading,visual_stim_to_plot] = removeWrappedLines(continuous_data.time,visual_stim);
plot(x_out_heading,visual_stim_to_plot,'LineWidth',1.5,'color',[0.4940 0.1840 0.5560])
hold on
phase = wrapTo180(rad2deg(continuous_data.bump_pos)');
[x_out_phase,phase_to_plot] = removeWrappedLines(continuous_data.time,phase);
plot(x_out_phase,phase_to_plot,'color',[0.4660 0.6740 0.1880],'LineWidth',1.5)
ylim([-180, 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
set(gca,'XTickLabel',[]);
set(gca,'XTick',[]);
xlim([400 650]);
ax = gca;
ax.FontSize = 14;


ax(3) = subplot(6,1,3);
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',deg2rad(visual_stim))));
[x_out_offset,offset_to_plot] = removeWrappedLines(continuous_data.time,offset);
x_out_offset = x_out_offset - x_out_offset(1);
plot(x_out_offset,offset_to_plot,'k','LineWidth',1.5)
set(gca,'XTick',[]);
ylim([-180 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
xlim([400 650]);
ax = gca;
ax.FontSize = 14;

%rotational speed
yaw_speed = abs(continuous_data.vel_yaw_ds);
yaw_speed(~gof) = NaN;
rolling_rot_speed = movmean(yaw_speed,92);

ax(4) = subplot(6,1,4);
plot(continuous_data.time,rolling_rot_speed,'k','LineWidth',1.5)
set(gca,'XTick',[]);
xlim([400 650]);
ax = gca;
ax.FontSize = 14;
            
%bump width
ax(5) = subplot(6,1,5);
bump_width = continuous_data.bump_width;
bump_width(~gof) = NaN;
rolling_bump_width = movmean(bump_width,92);
plot(continuous_data.time,rad2deg(rolling_bump_width),'k','LineWidth',1.5)
ylim([60 160]);
xlim([400 650]);
yticks([80,120,160]);
yticklabels({'80','120','160'});
set(gca,'XTick',[]);
ax = gca;
ax.FontSize = 14;

%bump mag
ax(6) = subplot(6,1,6);
bump_mag = continuous_data.bump_magnitude;
bump_mag(~gof) = NaN;
rolling_bump_mag = movmean(bump_mag,92);
plot(continuous_data.time,rolling_bump_mag,'k','LineWidth',1.5)
ylim([0 3.5]);
xlim([400 650]);
yticks([1:3]);
yticklabels({'1','2','3'});
xticks([400:50:650]);
xticklabels({'0','50','100','150','200','250'});
xlabel('Time (sec)','fontsize',16);
ax = gca;
ax.FontSize = 14;

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\Fig3\example_fly.svg')


figure,
subplot(1,2,1)
plot(rolling_bump_width,rolling_rot_speed,'o')
corr_bw = corrcoef(rolling_bump_width(~isnan(rolling_bump_width)),rolling_rot_speed(~isnan(rolling_rot_speed)));
title(['Corr = ',num2str(corr_bw(1,2))]);

subplot(1,2,2)
plot(rolling_bump_mag,rolling_rot_speed,'o')
corr_bm = corrcoef(rolling_bump_mag(~isnan(rolling_bump_mag)),rolling_rot_speed(~isnan(rolling_rot_speed)));
title(['Corr = ',num2str(corr_bm(1,2))]);

%% Example flies for figure 4

clear all; close all;

%fly 1, high offset precision
load('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts\20201020_60D05_7f\analysis\continuous_analysis_sid_1_tid_0.mat');

%identify changes in contrast
change_y_panels = abs(diff(continuous_data.fr_y_ds));
changeContrast = find(abs(diff(continuous_data.fr_y_ds))>1);

%Plot
% Plot the heatmap of EPG activity
figure('Position',[0 0 1400 500]),
ax(1) = subplot(3,1,1);
dff_matrix = continuous_data.dff_matrix(changeContrast(2):changeContrast(3),:)';
imagesc(flip(dff_matrix))
colormap(flipud(gray))
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gca,'xtick',[])

colormap(ax(1),flipud(gray));
pos = get(subplot(3,1,1),'Position');
h = colorbar('Position', [pos(1)+pos(3)+0.01  pos(2)  pos(3)/60  pos(4)]);

% Plot the heading and the EPG phase
ax(2) = subplot(3,1,2)
%Get heading to plot
visual_stim = wrapTo180(continuous_data.visual_stim_pos(changeContrast(2):changeContrast(3)));
%Remove wrapped lines to plot
[x_out_heading,visual_stim_to_plot] = removeWrappedLines(continuous_data.time(changeContrast(2):changeContrast(3)),visual_stim);
plot(x_out_heading,visual_stim_to_plot,'LineWidth',1.5,'color',[0.4940 0.1840 0.5560])
hold on
phase = wrapTo180(rad2deg(continuous_data.bump_pos(changeContrast(2):changeContrast(3))'));
[x_out_phase,phase_to_plot] = removeWrappedLines(continuous_data.time(changeContrast(2):changeContrast(3)),phase);
plot(x_out_phase,phase_to_plot,'color',[0.4660 0.6740 0.1880],'LineWidth',1.5)
ylim([-180, 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
if ~isnan(x_out_phase(end))
    xlim([x_out_phase(1),x_out_phase(end)]);
else
    xlim([x_out_phase(1),x_out_phase(end-1)]);
end
set(gca,'XTickLabel',[]);
set(gca,'XTick',[]);
ax = gca;
ax.FontSize = 14;

% Plot the offset
ax(3) = subplot(3,1,3)
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos(changeContrast(2):changeContrast(3))',deg2rad(visual_stim))));
[x_out_offset,offset_to_plot] = removeWrappedLines(continuous_data.time(changeContrast(2):changeContrast(3)),offset);
x_out_offset = x_out_offset - x_out_offset(1);
plot(x_out_offset,offset_to_plot,'LineWidth',1.5,'color','k')
ylim([-180 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
if ~isnan(x_out_offset(end))
    xlim([x_out_offset(1) x_out_offset(end)]);
else
    xlim([x_out_offset(1) x_out_offset(end-1)]);
end
set(gca,'XTickLabel',[]);
set(gca,'XTick',[]);
ax = gca;
ax.FontSize = 14;

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\Fig4\example_fly1.svg')


histfig = figure,
subplot(2,1,1)
polarhistogram(deg2rad(offset),15,'FaceColor','k','FaceAlpha',.3,'EdgeAlpha',0.3)
hold on
offset_mean = circ_mean(deg2rad(offset));
offset_strength = circ_r(deg2rad(offset));
rl = rlim;
polarplot([offset_mean,offset_mean],[0,rl(2)*offset_strength],'k','linewidth',4)
set(gca,'ThetaZeroLocation','top',...
    'ThetaDir','clockwise');
rticklabels({});
rticks([]);
thetaticks([0,90,180,270]);
ax = gca;
ax.FontSize = 14;




%%%%% Fly 2


%clear all; close all;

%fly 2, low offset precision
load('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts\20201130_60D05_7f\analysis\continuous_analysis_sid_2_tid_0.mat');

%identify changes in contrast
change_y_panels = abs(diff(continuous_data.fr_y_ds));
changeContrast = find(abs(diff(continuous_data.fr_y_ds))>1);

%Plot
% Plot the heatmap of EPG activity
figure('Position',[0 0 1400 500]),
ax(1) = subplot(3,1,1);
dff_matrix = continuous_data.dff_matrix(changeContrast(2):changeContrast(3),:)';
imagesc(flip(dff_matrix))
colormap(flipud(gray))
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gca,'xtick',[])
set(gca,'ytick',[])

colormap(ax(1),flipud(gray));
pos = get(subplot(3,1,1),'Position');
h = colorbar('Position', [pos(1)+pos(3)+0.01  pos(2)  pos(3)/60  pos(4)]);

% Plot the heading and the EPG phase
ax(2) = subplot(3,1,2);
%Get heading to plot
visual_stim = wrapTo180(continuous_data.visual_stim_pos(changeContrast(2):changeContrast(3)));
%Remove wrapped lines to plot
[x_out_heading,visual_stim_to_plot] = removeWrappedLines(continuous_data.time(changeContrast(2):changeContrast(3)),visual_stim);
plot(x_out_heading,visual_stim_to_plot,'LineWidth',1.5,'color',[0.4940 0.1840 0.5560])
hold on
phase = wrapTo180(rad2deg(continuous_data.bump_pos(changeContrast(2):changeContrast(3))'));
[x_out_phase,phase_to_plot] = removeWrappedLines(continuous_data.time(changeContrast(2):changeContrast(3)),phase);
plot(x_out_phase,phase_to_plot,'color',[0.4660 0.6740 0.1880],'LineWidth',1.5)
ylim([-180, 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
if ~isnan(x_out_phase(end))
    xlim([x_out_phase(1),x_out_phase(end)]);
else
    xlim([x_out_phase(1),x_out_phase(end-1)]);
end
set(gca,'XTickLabel',[]);
set(gca,'XTick',[]);
ax = gca;
ax.FontSize = 14;

% Plot the offset
ax(3) = subplot(3,1,3);
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos(changeContrast(2):changeContrast(3))',deg2rad(visual_stim))));
[x_out_offset,offset_to_plot] = removeWrappedLines(continuous_data.time(changeContrast(2):changeContrast(3)),offset);
x_out_offset = x_out_offset - x_out_offset(1);
plot(x_out_offset,offset_to_plot,'k','LineWidth',1.5)
ylim([-180 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
xlabel('Time (sec)','fontsize',16);
if ~isnan(x_out_offset(end))
    xlim([x_out_offset(1) x_out_offset(end)]);
else
    xlim([x_out_offset(1) x_out_offset(end-1)]);
end
ax = gca;
ax.FontSize = 14;

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\Fig4\example_fly2.svg')


figure(histfig)
subplot(2,1,2)
polarhistogram(deg2rad(offset),15,'FaceColor','k','FaceAlpha',.3,'EdgeAlpha',0.4)
hold on
offset_mean = circ_mean(deg2rad(offset));
offset_strength = circ_r(deg2rad(offset));
rl = rlim;
polarplot([offset_mean,offset_mean],[0,rl(2)*offset_strength],'k','linewidth',4)
set(gca,'ThetaZeroLocation','top',...
    'ThetaDir','clockwise');
rticklabels({});
rticks([]);
thetaticks([0,90,180,270]);
ax = gca;
ax.FontSize = 14;

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\Fig4\examples_polarhistograms.svg')

%% Example flies for figure 5

clear all; close all;

%fly 1, remapping strategy
load('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\20210129_60D05_7f\analysis\continuous_analysis_sid_1_tid_0.mat');

gain_changes = [1837,9183];

% Plot the heatmap of EPG activity
figure('Position',[100 100 1800 600]),
ax(1) = subplot(4,1,1);
%I'm flipping the dff matrix for it to make sense along with the fly's
%heading
imagesc(flip(continuous_data.dff_matrix'))
colormap(flipud(gray))
set(gca,'XTick',[]);
set(gca,'ytick',[])
xlim([gain_changes(2)-floor(400*9.18),gain_changes(2)-floor(100*9.18)]);

colormap(ax(1),flipud(gray));
pos = get(subplot(4,1,1),'Position');
h = colorbar('Position', [pos(1)+pos(3)+0.01  pos(2)  pos(3)/60  pos(4)]);

% Plot the bar position, the fly heading and the EPG phase
ax(2) = subplot(4,1,2);
%Get heading position to plot
heading = wrapTo180(-continuous_data.heading_deg(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18)));
[x_out_heading, heading_to_plot] = removeWrappedLines(continuous_data.time(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18)),heading);
plot(x_out_heading,heading_to_plot,'color',[0.8500 0.3250 0.0980],'LineWidth',1.5)
hold on
phase = wrapTo180(rad2deg(continuous_data.bump_pos(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18))'));
[x_out_phase, phase_to_plot] = removeWrappedLines(continuous_data.time(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18)),phase);
plot(x_out_phase,phase_to_plot,'color',[0.4660 0.6740 0.1880],'LineWidth',1.5)
bar_position = wrapTo180(continuous_data.visual_stim_pos(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18)));
[x_out_bar, bar_pos_to_plot] = removeWrappedLines(continuous_data.time(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18)),bar_position);
plot(x_out_bar,bar_pos_to_plot,'color',[0.4940 0.1840 0.5560],'LineWidth',1.5)
ylim([-180, 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
set(gca,'XTick',[]);
xlim([x_out_phase(1), x_out_phase(end)]);
ax = gca;
ax.FontSize = 14;

% Plot the heading offset
ax(4) = subplot(4,1,3);
heading_offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18))',-continuous_data.heading(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18)))));
[x_out_heading_offset, heading_offset_to_plot] = removeWrappedLines(continuous_data.time(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18)),heading_offset);
plot(x_out_heading_offset,heading_offset_to_plot,'.','color','k')
ylim([-180 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
set(gca,'XTick',[]);
xlim([x_out_heading_offset(1), x_out_heading_offset(end)]);
ax = gca;
ax.FontSize = 14;

% Plot the bar offset
ax(4) = subplot(4,1,4);
bar_offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18))',deg2rad(continuous_data.visual_stim_pos(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18))))));
[x_out_offset, offset_to_plot] = removeWrappedLines(continuous_data.time(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18)),bar_offset);
x_out_offset = x_out_offset - x_out_offset(1);
plot(x_out_offset,offset_to_plot,'.','color','k')
ylim([-180 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
xlim([x_out_offset(1) x_out_offset(end)]);
xlabel('Time (sec)','fontsize',16);
ax = gca;
ax.FontSize = 14;

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\Fig5\example_fly1.svg')


%Polarhistograms

figure,
subplot(1,2,1)
heading_offset = heading_offset(floor(1/3*length(heading_offset)):end);
polarhistogram(deg2rad(heading_offset),15,'FaceColor','k','FaceAlpha',.3,'EdgeAlpha',0.4)
hold on
offset_mean = circ_mean(deg2rad(heading_offset));
offset_strength = circ_r(deg2rad(heading_offset));
rl = rlim;
polarplot([offset_mean,offset_mean],[0,rl(2)*offset_strength],'k','linewidth',4)
set(gca,'ThetaZeroLocation','top',...
    'ThetaDir','clockwise');
rticklabels({});
rticks([]);
thetaticks([0,90,180,270]);
ax = gca;
ax.FontSize = 14;

subplot(1,2,2)
bar_offset = bar_offset(floor(1/3*length(bar_offset)):end);
polarhistogram(deg2rad(bar_offset),15,'FaceColor','k','FaceAlpha',.3,'EdgeAlpha',0.4)
hold on
offset_mean = circ_mean(deg2rad(bar_offset));
offset_strength = circ_r(deg2rad(bar_offset));
rl = rlim;
polarplot([offset_mean,offset_mean],[0,rl(2)*offset_strength],'k','linewidth',4)
set(gca,'ThetaZeroLocation','top',...
    'ThetaDir','clockwise');
rticklabels({});
rticks([]);
thetaticks([0,90,180,270]);
ax = gca;
ax.FontSize = 14;

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\Fig5\example_fly1_polarhistogram.svg')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all;

%fly 2, ignoring internal cues
load('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\20210204_60D05_7f\analysis\continuous_analysis_sid_1_tid_0.mat');

gain_changes = [1837,9183];

% Plot the heatmap of EPG activity
figure('Position',[100 100 1800 600]),
ax(1) = subplot(4,1,1);
%I'm flipping the dff matrix for it to make sense along with the fly's
%heading
imagesc(flip(continuous_data.dff_matrix'))
colormap(flipud(gray))
set(gca,'XTick',[]);
set(gca,'ytick',[])
xlim([gain_changes(2)-floor(400*9.18),gain_changes(2)-floor(100*9.18)]);

colormap(ax(1),flipud(gray));
pos = get(subplot(4,1,1),'Position');
h = colorbar('Position', [pos(1)+pos(3)+0.01  pos(2)  pos(3)/60  pos(4)]);

% Plot the bar position, the fly heading and the EPG phase
ax(2) = subplot(4,1,2);
%Get heading position to plot
heading = wrapTo180(-continuous_data.heading_deg(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18)));
[x_out_heading, heading_to_plot] = removeWrappedLines(continuous_data.time(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18)),heading);
plot(x_out_heading,heading_to_plot,'color',[0.8500 0.3250 0.0980],'LineWidth',1.5)
hold on
phase = wrapTo180(rad2deg(continuous_data.bump_pos(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18))'));
[x_out_phase, phase_to_plot] = removeWrappedLines(continuous_data.time(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18)),phase);
plot(x_out_phase,phase_to_plot,'color',[0.4660 0.6740 0.1880],'LineWidth',1.5)
bar_position = wrapTo180(continuous_data.visual_stim_pos(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18)));
[x_out_bar, bar_pos_to_plot] = removeWrappedLines(continuous_data.time(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18)),bar_position);
plot(x_out_bar,bar_pos_to_plot,'color',[0.4940 0.1840 0.5560],'LineWidth',1.5)
ylim([-180, 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
set(gca,'XTick',[]);
xlim([x_out_phase(1), x_out_phase(end)]);
ax = gca;
ax.FontSize = 14;

% Plot the heading offset
ax(3) = subplot(4,1,3);
heading_offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18))',-continuous_data.heading(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18)))));
[x_out_heading_offset, heading_offset_to_plot] = removeWrappedLines(continuous_data.time(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18)),heading_offset);
plot(x_out_heading_offset,heading_offset_to_plot,'.','color','k')
ylim([-180 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
set(gca,'XTick',[]);
xlim([x_out_heading_offset(1), x_out_heading_offset(end)]);
ax = gca;
ax.FontSize = 14;

% Plot the bar offset
ax(4) = subplot(4,1,4);
bar_offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18))',deg2rad(continuous_data.visual_stim_pos(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18))))));
[x_out_offset, offset_to_plot] = removeWrappedLines(continuous_data.time(gain_changes(2)-floor(400*9.18):gain_changes(2)-floor(100*9.18)),bar_offset);
x_out_offset = x_out_offset - x_out_offset(1);
plot(x_out_offset,offset_to_plot,'.','color','k')
ylim([-180 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
xlim([x_out_offset(1) x_out_offset(end)]);
xlabel('Time (sec)','fontsize',16);
ax = gca;
ax.FontSize = 14;

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\Fig5\example_fly2.svg')

%Polarhistograms

figure,
subplot(1,2,1)
heading_offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos(gain_changes(2)-floor(200*9.18):gain_changes(2))',-continuous_data.heading(gain_changes(2)-floor(200*9.18):gain_changes(2)))));
total_mvt = continuous_data.total_mvt_ds(gain_changes(2)-floor(200*9.18):gain_changes(2));
moving = total_mvt > 20;
heading_offset = heading_offset(moving);
polarhistogram(deg2rad(heading_offset),15,'FaceColor','k','FaceAlpha',.3,'EdgeAlpha',0.4)
hold on
offset_mean = circ_mean(deg2rad(heading_offset));
offset_strength = circ_r(deg2rad(heading_offset));
rl = rlim;
polarplot([offset_mean,offset_mean],[0,rl(2)*offset_strength],'k','linewidth',4)
set(gca,'ThetaZeroLocation','top',...
    'ThetaDir','clockwise');
rticklabels({});
rticks([]);
thetaticks([0,90,180,270]);
ax = gca;
ax.FontSize = 14;

subplot(1,2,2)
bar_offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos(gain_changes(2)-floor(200*9.18):gain_changes(2))',deg2rad(continuous_data.visual_stim_pos(gain_changes(2)-floor(200*9.18):gain_changes(2))))));
bar_offset = bar_offset(moving);
polarhistogram(deg2rad(bar_offset),15,'FaceColor','k','FaceAlpha',.3,'EdgeAlpha',0.4)
hold on
offset_mean = circ_mean(deg2rad(bar_offset));
offset_strength = circ_r(deg2rad(bar_offset));
rl = rlim;
polarplot([offset_mean,offset_mean],[0,rl(2)*offset_strength],'k','linewidth',4)
set(gca,'ThetaZeroLocation','top',...
    'ThetaDir','clockwise');
rticklabels({});
rticks([]);
thetaticks([0,90,180,270]);
ax = gca;
ax.FontSize = 14;

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\Fig5\example_fly2_polarhistogram.svg')


%% Example flies for figure 6

%%%% Fly 1
clear all; close all;
path = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability\20210924_60D05_7f_fly2';

% Import sessions information
load([path,'\analysis\sessions_info.mat'])

% Initial panels
load([path,'\analysis\continuous_analysis_sid_',num2str(sessions.initial_cl_bar),'_tid_0.mat'])
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
pre_panels_offset_above_thresh = deg2rad(offset(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds > 25));
offset_precision_pre_panels = circ_r(pre_panels_offset_above_thresh);

% Initial wind
load([path,'\analysis\continuous_analysis_sid_',num2str(sessions.initial_cl_wind),'_tid_0.mat'])
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
pre_wind_offset_above_thresh = deg2rad(offset(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25));
offset_precision_pre_wind = circ_r(pre_wind_offset_above_thresh);

% Two-cues
load([path,'\analysis\continuous_analysis_sid_',num2str(sessions.cue_combination),'_tid_0.mat'])
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
combined_offset_above_thresh = deg2rad(offset(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25));
offset_precision_combined = circ_r(combined_offset_above_thresh);

%Final panels
load([path,'\analysis\continuous_analysis_sid_',num2str(sessions.final_cl_bar),'_tid_0.mat'])
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
post_panels_offset_above_thresh = deg2rad(offset(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25));
offset_precision_post_panels = circ_r(post_panels_offset_above_thresh);

%Final wind
load([path,'\analysis\continuous_analysis_sid_',num2str(sessions.final_cl_wind),'_tid_0.mat'])
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
post_wind_offset_above_thresh = deg2rad(offset(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds > 25));
offset_precision_post_wind = circ_r(post_wind_offset_above_thresh);

% Get circ_mean of offset per block
if sessions.initial_cl_wind < sessions.initial_cl_bar
    
    offset_mean = [circ_mean(pre_wind_offset_above_thresh),circ_mean(pre_panels_offset_above_thresh),circ_mean(combined_offset_above_thresh),circ_mean(post_wind_offset_above_thresh),circ_mean(post_panels_offset_above_thresh)];
    
elseif sessions.initial_cl_wind > sessions.initial_cl_bar
    
    offset_mean = [circ_mean(pre_panels_offset_above_thresh),circ_mean(pre_wind_offset_above_thresh),circ_mean(combined_offset_above_thresh),circ_mean(post_panels_offset_above_thresh),circ_mean(post_wind_offset_above_thresh)];
    
end

fly_color = [.3 .3 .3];

% Plot offset evolution with overlaid mean
if sessions.initial_cl_wind > sessions.initial_cl_bar
    
    figure('Position',[100 100 1400 400]),
    
    subplot(1,5,1)
    polarhistogram(pre_panels_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(1),offset_mean(1)],[0,rl(2)*offset_precision_pre_panels],'k','linewidth',5)
    title('Initial visual cue offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,2)
    polarhistogram(pre_wind_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(2),offset_mean(2)],[0,rl(2)*offset_precision_pre_wind],'k','linewidth',5)
    title('Initial wind offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,3)
    polarhistogram(combined_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(3),offset_mean(3)],[0,rl(2)*offset_precision_combined],'k','linewidth',5)
    title('Two-cue offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,4)
    polarhistogram(post_panels_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(4),offset_mean(4)],[0,rl(2)*offset_precision_post_panels],'k','linewidth',5)
    title('Final visual cue offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,5)
    polarhistogram(post_wind_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(5),offset_mean(5)],[0,rl(2)*offset_precision_post_wind],'k','linewidth',5)
    title('Final wind offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
else
    
    figure('Position',[100 100 1400 400]),
    
    subplot(1,5,1)
    polarhistogram(pre_wind_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(1),offset_mean(1)],[0,rl(2)*offset_precision_pre_wind],'k','linewidth',5)
    title('Initial wind offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,2)
    polarhistogram(pre_panels_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(2),offset_mean(2)],[0,rl(2)*offset_precision_pre_panels],'k','linewidth',5)
    title('Initial visual cue offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,3)
    polarhistogram(combined_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(3),offset_mean(3)],[0,rl(2)*offset_precision_combined],'k','linewidth',5)
    title('Two-cue offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,4)
    polarhistogram(post_wind_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(4),offset_mean(4)],[0,rl(2)*offset_precision_post_wind],'k','linewidth',5)
    title('Final wind offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,5)
    polarhistogram(post_panels_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(5),offset_mean(5)],[0,rl(2)*offset_precision_post_panels],'k','linewidth',5)
    title('Final visual cue offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
end

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\Fig6\example_fly1_polarhistograms.svg')


%%%% Fly 2
clear all; close all;
path = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability\20210618_60D05_7f';

% Import sessions information
load([path,'\analysis\sessions_info.mat'])

% Initial panels
load([path,'\analysis\continuous_analysis_sid_',num2str(sessions.initial_cl_bar),'_tid_0.mat'])
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
pre_panels_offset_above_thresh = deg2rad(offset(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds > 25));
offset_precision_pre_panels = circ_r(pre_panels_offset_above_thresh);

% Initial wind
load([path,'\analysis\continuous_analysis_sid_',num2str(sessions.initial_cl_wind),'_tid_0.mat'])
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
pre_wind_offset_above_thresh = deg2rad(offset(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25));
offset_precision_pre_wind = circ_r(pre_wind_offset_above_thresh);

% Two-cues
load([path,'\analysis\continuous_analysis_sid_',num2str(sessions.cue_combination),'_tid_0.mat'])
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
combined_offset_above_thresh = deg2rad(offset(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25));
offset_precision_combined = circ_r(combined_offset_above_thresh);

%Final panels
load([path,'\analysis\continuous_analysis_sid_',num2str(sessions.final_cl_bar),'_tid_0.mat'])
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
post_panels_offset_above_thresh = deg2rad(offset(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds>25));
offset_precision_post_panels = circ_r(post_panels_offset_above_thresh);

%Final wind
load([path,'\analysis\continuous_analysis_sid_',num2str(sessions.final_cl_wind),'_tid_0.mat'])
offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
post_wind_offset_above_thresh = deg2rad(offset(continuous_data.adj_rs>=0.5 & continuous_data.total_mvt_ds > 25));
offset_precision_post_wind = circ_r(post_wind_offset_above_thresh);

% Get circ_mean of offset per block
if sessions.initial_cl_wind < sessions.initial_cl_bar
    
    offset_mean = [circ_mean(pre_wind_offset_above_thresh),circ_mean(pre_panels_offset_above_thresh),circ_mean(combined_offset_above_thresh),circ_mean(post_wind_offset_above_thresh),circ_mean(post_panels_offset_above_thresh)];
    
elseif sessions.initial_cl_wind > sessions.initial_cl_bar
    
    offset_mean = [circ_mean(pre_panels_offset_above_thresh),circ_mean(pre_wind_offset_above_thresh),circ_mean(combined_offset_above_thresh),circ_mean(post_panels_offset_above_thresh),circ_mean(post_wind_offset_above_thresh)];
    
end

fly_color = [.3 .3 .3];

% Plot offset evolution with overlaid mean
if sessions.initial_cl_wind > sessions.initial_cl_bar
    
    figure('Position',[100 100 1400 400]),
    
    subplot(1,5,1)
    polarhistogram(pre_panels_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(1),offset_mean(1)],[0,rl(2)*offset_precision_pre_panels],'k','linewidth',5)
    title('Initial visual cue offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,2)
    polarhistogram(pre_wind_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(2),offset_mean(2)],[0,rl(2)*offset_precision_pre_wind],'k','linewidth',5)
    title('Initial wind offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,3)
    polarhistogram(combined_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(3),offset_mean(3)],[0,rl(2)*offset_precision_combined],'k','linewidth',5)
    title('Two-cue offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,4)
    polarhistogram(post_panels_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(4),offset_mean(4)],[0,rl(2)*offset_precision_post_panels],'k','linewidth',5)
    title('Final visual cue offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,5)
    polarhistogram(post_wind_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(5),offset_mean(5)],[0,rl(2)*offset_precision_post_wind],'k','linewidth',5)
    title('Final wind offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
else
    
    figure('Position',[100 100 1400 400]),
    
    subplot(1,5,1)
    polarhistogram(pre_wind_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(1),offset_mean(1)],[0,rl(2)*offset_precision_pre_wind],'k','linewidth',5)
    title('Initial wind offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,2)
    polarhistogram(pre_panels_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(2),offset_mean(2)],[0,rl(2)*offset_precision_pre_panels],'k','linewidth',5)
    title('Initial visual cue offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,3)
    polarhistogram(combined_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(3),offset_mean(3)],[0,rl(2)*offset_precision_combined],'k','linewidth',5)
    title('Two-cue offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,4)
    polarhistogram(post_wind_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(4),offset_mean(4)],[0,rl(2)*offset_precision_post_wind],'k','linewidth',5)
    title('Final wind offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
    subplot(1,5,5)
    polarhistogram(post_panels_offset_above_thresh,15,'FaceColor',fly_color,'EdgeColor',fly_color,'FaceAlpha',.3,'EdgeAlpha',.3)
    hold on
    rl = rlim;
    polarplot([offset_mean(5),offset_mean(5)],[0,rl(2)*offset_precision_post_panels],'k','linewidth',5)
    title('Final visual cue offset','fontsize',12);
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.RTickLabel = [];
    Ax.RGrid = 'off';
    Ax.ThetaGrid = 'off';
    thetaticks([0 90 180 270]);
    
end

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\Fig6\example_fly2_polarhistograms.svg')

%% Example flies for figure 7

%fly 1: prefers the bar
clear all; close all;
load('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp38\data\third_version\20211229_60D05_7f\analysis\continuous_analysis_sid_3_tid_0.mat');

real_bar_jump_frame = floor(2088.7*length(continuous_data.dff_matrix)/continuous_data.time(end));

%Conversion factors
sec_to_frames = length(continuous_data.dff_matrix)/continuous_data.time(end);
frames_to_sec = continuous_data.time(end)/length(continuous_data.dff_matrix);


time_zero = continuous_data.time(real_bar_jump_frame);
time = continuous_data.time-time_zero;

figure('Position',[100 100 1600 500]),
ax(1) = subplot(3,1,1);
imagesc(flip(continuous_data.dff_matrix(real_bar_jump_frame-10*sec_to_frames:real_bar_jump_frame+10*sec_to_frames,:)'))
colormap(flipud(gray))
hold on
plotting_length = real_bar_jump_frame+10*sec_to_frames-real_bar_jump_frame+10*sec_to_frames;
plot([plotting_length/2+.5 plotting_length/2+.5],[1 size(continuous_data.dff_matrix,2)],'r','linestyle','--','linewidth',2)
set(gca,'xtick',[])
set(gca,'ytick',[])

colormap(ax(1),flipud(gray));
pos = get(subplot(3,1,1),'Position');
h = colorbar('Position', [pos(1)+pos(3)+0.01  pos(2)  pos(3)/60  pos(4)]);

ax(2) = subplot(3,1,2);
time_to_plot = time(real_bar_jump_frame-10*sec_to_frames:real_bar_jump_frame+10*sec_to_frames);
bump_pos = wrapTo180(rad2deg(continuous_data.bump_pos));
bar_pos = wrapTo180(continuous_data.visual_stim_pos);
motor_pos = wrapTo180(rad2deg(continuous_data.motor_pos));
phase_to_plot = bump_pos(real_bar_jump_frame-10*sec_to_frames:real_bar_jump_frame+10*sec_to_frames);
[x_out_time,bump_pos_to_plot] = removeWrappedLines(time_to_plot,phase_to_plot');
plot(x_out_time,bump_pos_to_plot,'linewidth',2,'color',[0.4660 0.6740 0.1880])
hold on
bar_to_plot = bar_pos(real_bar_jump_frame-10*sec_to_frames:real_bar_jump_frame+10*sec_to_frames);
[x_out_time,bar_pos_to_plot] = removeWrappedLines(time_to_plot,bar_to_plot);
plot(x_out_time,bar_pos_to_plot,'linewidth',2,'color',[0.4940 0.1840 0.5560])
wind_to_plot = motor_pos(real_bar_jump_frame-10*sec_to_frames:real_bar_jump_frame+10*sec_to_frames);
[x_out_time,wind_pos_to_plot] = removeWrappedLines(time_to_plot,wind_to_plot');
plot(x_out_time,wind_pos_to_plot,'linewidth',2)
xline(time(real_bar_jump_frame),'k','linestyle','--','linewidth',2)
ylim([-180 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
xlim([time(real_bar_jump_frame-floor(10*sec_to_frames)) time(real_bar_jump_frame+floor(10*sec_to_frames))]);
set(gca,'xtick',[]);
ax = gca;
ax.FontSize = 14;

ax(3) = subplot(3,1,3);
%offset with respect to bar
bar_offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',deg2rad(continuous_data.visual_stim_pos))));
%offst with respect to wind
wind_offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos,deg2rad(motor_pos))));
bar_offset_to_plot = bar_offset(real_bar_jump_frame-10*sec_to_frames:real_bar_jump_frame+10*sec_to_frames);
[x_out_time,bar_off_to_plot] = removeWrappedLines(time_to_plot,bar_offset_to_plot);
plot(x_out_time,bar_off_to_plot,'linewidth',2,'color',[0.4940 0.1840 0.5560])
hold on
wind_offset_to_plot = wind_offset(real_bar_jump_frame-10*sec_to_frames:real_bar_jump_frame+10*sec_to_frames);
[x_out_time,wind_off_to_plot] = removeWrappedLines(time_to_plot,wind_offset_to_plot');
plot(x_out_time,wind_off_to_plot,'linewidth',2,'color',[0.9290 0.6940 0.1250])
xlim([time(real_bar_jump_frame-floor(10*sec_to_frames)) time(real_bar_jump_frame+floor(10*sec_to_frames))]);
xline(time(real_bar_jump_frame),'k','linestyle','--','linewidth',2)
ylim([-180 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
ax = gca;
ax.FontSize = 14;
set(gca,'xtick',[])

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\Fig7\example_fly1.svg')



%fly 2: prefers the wind
clear all; close all;
load('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp38\data\third_version\20211230_60D05_7f\analysis\continuous_analysis_sid_1_tid_0.mat');

real_bar_jump_frame = floor(2388.7*length(continuous_data.dff_matrix)/continuous_data.time(end));

%Conversion factors
sec_to_frames = length(continuous_data.dff_matrix)/continuous_data.time(end);
frames_to_sec = continuous_data.time(end)/length(continuous_data.dff_matrix);


time_zero = continuous_data.time(real_bar_jump_frame);
time = continuous_data.time-time_zero;

figure('Position',[100 100 1600 500]),
ax(1) = subplot(3,1,1);
imagesc(flip(continuous_data.dff_matrix(real_bar_jump_frame-10*sec_to_frames:real_bar_jump_frame+10*sec_to_frames,:)'))
colormap(flipud(gray))
hold on
plotting_length = real_bar_jump_frame+10*sec_to_frames-real_bar_jump_frame+10*sec_to_frames;
plot([plotting_length/2+.5 plotting_length/2+.5],[1 size(continuous_data.dff_matrix,2)],'r','linestyle','--','linewidth',2)
set(gca,'xtick',[])
set(gca,'ytick',[])

colormap(ax(1),flipud(gray));
pos = get(subplot(3,1,1),'Position');
h = colorbar('Position', [pos(1)+pos(3)+0.01  pos(2)  pos(3)/60  pos(4)]);

ax(2) = subplot(3,1,2);
time_to_plot = time(real_bar_jump_frame-10*sec_to_frames:real_bar_jump_frame+10*sec_to_frames);
bump_pos = wrapTo180(rad2deg(continuous_data.bump_pos));
bar_pos = wrapTo180(continuous_data.visual_stim_pos);
motor_pos = wrapTo180(rad2deg(continuous_data.motor_pos));
phase_to_plot = bump_pos(real_bar_jump_frame-10*sec_to_frames:real_bar_jump_frame+10*sec_to_frames);
[x_out_time,bump_pos_to_plot] = removeWrappedLines(time_to_plot,phase_to_plot');
plot(x_out_time,bump_pos_to_plot,'linewidth',2,'color',[0.4660 0.6740 0.1880])
hold on
bar_to_plot = bar_pos(real_bar_jump_frame-10*sec_to_frames:real_bar_jump_frame+10*sec_to_frames);
[x_out_time,bar_pos_to_plot] = removeWrappedLines(time_to_plot,bar_to_plot);
plot(x_out_time,bar_pos_to_plot,'linewidth',2,'color',[0.4940 0.1840 0.5560])
wind_to_plot = motor_pos(real_bar_jump_frame-10*sec_to_frames:real_bar_jump_frame+10*sec_to_frames);
[x_out_time,wind_pos_to_plot] = removeWrappedLines(time_to_plot,wind_to_plot');
plot(x_out_time,wind_pos_to_plot,'linewidth',2)
xline(time(real_bar_jump_frame),'k','linestyle','--','linewidth',2)
ylim([-180 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
xlim([time(real_bar_jump_frame-floor(10*sec_to_frames)) time(real_bar_jump_frame+floor(10*sec_to_frames))]);
set(gca,'xtick',[]);
ax = gca;
ax.FontSize = 14;

ax(3) = subplot(3,1,3);
%offset with respect to bar
bar_offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',deg2rad(continuous_data.visual_stim_pos))));
%offst with respect to wind
wind_offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos,deg2rad(motor_pos))));
bar_offset_to_plot = bar_offset(real_bar_jump_frame-10*sec_to_frames:real_bar_jump_frame+10*sec_to_frames);
[x_out_time,bar_off_to_plot] = removeWrappedLines(time_to_plot,bar_offset_to_plot);
plot(x_out_time,bar_off_to_plot,'linewidth',2,'color',[0.4940 0.1840 0.5560])
hold on
wind_offset_to_plot = wind_offset(real_bar_jump_frame-10*sec_to_frames:real_bar_jump_frame+10*sec_to_frames);
[x_out_time,wind_off_to_plot] = removeWrappedLines(time_to_plot,wind_offset_to_plot');
plot(x_out_time,wind_off_to_plot,'linewidth',2,'color',[0.9290 0.6940 0.1250])
xlim([time(real_bar_jump_frame-floor(10*sec_to_frames)) time(real_bar_jump_frame+floor(10*sec_to_frames))]);
xline(time(real_bar_jump_frame),'k','linestyle','--','linewidth',2)
ylim([-180 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
ax = gca;
ax.FontSize = 14;
xlabel('Time (sec)','fontsize',16);

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\Fig7\example_fly2.svg')


%% Example fly for sup figure 5 (same learner fly from figure 5)


clear all; close all;

%fly 1, remapping strategy
load('Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\20210129_60D05_7f\analysis\continuous_analysis_sid_1_tid_0.mat');

gain_changes = [1837,9183];

% Plot the heatmap of EPG activity
figure('Position',[100 100 1800 600]),
ax(1) = subplot(4,1,1);
%I'm flipping the dff matrix for it to make sense along with the fly's
%heading
imagesc(flip(continuous_data.dff_matrix'))
colormap(flipud(gray))
hold on
xline(gain_changes(1),'r','linewidth',2)
xline(gain_changes(2),'r','linewidth',2)
set(gca,'XTick',[]);
set(gca,'ytick',[])

colormap(ax(1),flipud(gray));
pos = get(subplot(4,1,1),'Position');
h = colorbar('Position', [pos(1)+pos(3)+0.01  pos(2)  pos(3)/60  pos(4)]);

% Plot the bar position, the fly heading and the EPG phase
ax(2) = subplot(4,1,2);
%Get heading position to plot
heading = wrapTo180(-continuous_data.heading_deg);
[x_out_heading, heading_to_plot] = removeWrappedLines(continuous_data.time,heading);
plot(x_out_heading,heading_to_plot,'color',[0.8500 0.3250 0.0980],'LineWidth',1.5)
hold on
phase = wrapTo180(rad2deg(continuous_data.bump_pos'));
[x_out_phase, phase_to_plot] = removeWrappedLines(continuous_data.time,phase);
plot(x_out_phase,phase_to_plot,'color',[0.4660 0.6740 0.1880],'LineWidth',1.5)
bar_position = wrapTo180(continuous_data.visual_stim_pos);
[x_out_bar, bar_pos_to_plot] = removeWrappedLines(continuous_data.time,bar_position);
plot(x_out_bar,bar_pos_to_plot,'color',[0.4940 0.1840 0.5560],'LineWidth',1.5)
xline(continuous_data.time(gain_changes(1)),'r','linewidth',2)
xline(continuous_data.time(gain_changes(2)),'r','linewidth',2)
ylim([-180, 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
set(gca,'XTick',[]);
xlim([x_out_phase(1), x_out_phase(end)]);
ax = gca;
ax.FontSize = 14;

% Plot the heading offset
ax(4) = subplot(4,1,3);
heading_offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',-continuous_data.heading)));
[x_out_heading_offset, heading_offset_to_plot] = removeWrappedLines(continuous_data.time,heading_offset);
plot(x_out_heading_offset,heading_offset_to_plot,'.','color','k')
xline(continuous_data.time(gain_changes(1)),'r','linewidth',2)
xline(continuous_data.time(gain_changes(2)),'r','linewidth',2)
ylim([-180 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
set(gca,'XTick',[]);
xlim([x_out_heading_offset(1), x_out_heading_offset(end)]);
ax = gca;
ax.FontSize = 14;

% Plot the bar offset
ax(4) = subplot(4,1,4);
bar_offset = wrapTo180(rad2deg(circ_dist(continuous_data.bump_pos',deg2rad(continuous_data.visual_stim_pos))));
[x_out_offset, offset_to_plot] = removeWrappedLines(continuous_data.time,bar_offset);
x_out_offset = x_out_offset - x_out_offset(1);
plot(x_out_offset,offset_to_plot,'.','color','k')
hold on
xline(continuous_data.time(gain_changes(1)),'r','linewidth',2)
xline(continuous_data.time(gain_changes(2)),'r','linewidth',2)
ylim([-180 180]);
yticks([-180:180:180]);
yticklabels({'-180','0','180'});
xticks([0,300,600,900,1200]);
xticklabels({'0','5','10','15','20'});
xlim([x_out_offset(1) x_out_offset(end)]);
xlabel('Time (min)','fontsize',16);
ax = gca;
ax.FontSize = 14;

saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\ExtraFigures\example_fly_ig_offset_return.svg')