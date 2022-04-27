%Code to analyze the open-loop bouts

clear all; close all;

%% Load data

%Get directory you're interested in
path = uigetdir('Z:\Wilson Lab\Mel\Experiments\Uncertainty\GCaMP_control\data\');

%I will create a .txt file for each fly with the session numbers
%Read the .txt file containing the ID of the open loop sessions.
fileID = fopen([path,'\2p\open_loop_sessions.txt'],'r');
formatSpec = '%d';
open_loop_sessions = fscanf(fileID,formatSpec);

for session = 1:length(open_loop_sessions)
   data{session} = load([path,'\analysis\continuous_analysis_sid_',num2str(open_loop_sessions(session)),'_tid_0.mat']);    
end

%% For each open-loop bout, plot the heatmap of PB activity, the trajectory of the stimulus and the 'stimulus offset'
%defined as the circular distance between the phase of EPG activity and the stimulus
%position.

for session = 1:length(open_loop_sessions)
    
    figure('Position',[100, 100, 1000, 800]),
    
    %PB heatmap
    subplot(3,5,[1 4])
    dff = data{1,session}.continuous_data.dff_matrix';
    imagesc(flip(dff))
    colormap(flipud(gray))
    ylabel('PB distance')
    set(gca,'xticklabel',{[]});
    set(gca,'XTick',[]);
    title('EPG activity in the PB');
    
    %Stimulus position
    subplot(3,5,[6 9])
    bar_position = wrapTo180(data{1,session}.continuous_data.visual_stim_pos);
    [x_out_bar, bar_position_to_plot] = removeWrappedLines(data{1,session}.continuous_data.time, bar_position);
    %Get EPG phase to plot
    phase = wrapTo180(rad2deg(data{1,session}.continuous_data.bump_pos));
    [x_out_phase, phase_to_plot] = removeWrappedLines(data{1,session}.continuous_data.time, phase');
    %Plot using different colors if the stimulus was low or high contrast
    plot(x_out_bar,bar_position_to_plot,'color',[ 0.5 0.8 0.9],'LineWidth',1.5)
    hold on
    plot(x_out_phase,phase_to_plot,'color',[0.9 0.3 0.4],'LineWidth',1.5)
    axP = get(gca,'Position');
    legend('Bar position','EPG phase','Location','EastOutside')
    set(gca, 'Position', axP);
    if ~isnan(x_out_phase(end))
        xlim([0, x_out_phase(end)]);
    else
        xlim([0, x_out_phase(end-1)]);
    end
    ylim([-180 180]);
    ylabel('Degrees');
    set(gca,'xticklabel',{[]})
    title('Stimulus position');
    
    %Stim offset
    %Calculate stim offset as the circular distance between EPG activity
    %phase and the stimulus posotion
    stim_offset{session} = rad2deg(circ_dist(data{1,session}.continuous_data.bump_pos,deg2rad(data{1,session}.continuous_data.visual_stim_pos')));
    stimoffset = rad2deg(circ_dist(data{1,session}.continuous_data.bump_pos,deg2rad(data{1,session}.continuous_data.visual_stim_pos')));    
    [x_out_stimoffset, stimOffsetToPlot] = removeWrappedLines(data{1,session}.continuous_data.time, stimoffset');
    subplot(3,5,[11 14])
    %Plot using different colors if the stimulus was low or high contrast
    plot(x_out_stimoffset,stimOffsetToPlot,'color',[ 0.5 0.8 0.9],'LineWidth',1.5)
    xlim([0, data{1,session}.continuous_data.time(end)]);
    ylim([-180 180]);
    xlabel('Time (sec)'); ylabel('Degrees');
    title('Stimulus offset');
    
    %Plot stimulus offset distribution
    subplot(3,5,15)
    polarhistogram(deg2rad(stim_offset{session}),20,'FaceColor',[ 0.5 0.8 0.9])
    set(gca,'ThetaZeroLocation','top');
    title({'Offset distribution','High contrast'});
    Ax = gca;
    Ax.RGrid = 'off';
    Ax.RTickLabel = [];
    
    %Save figures
    saveas(gcf,[path,'\analysis\continuous_plots\openLoopHeatmapAndOffset_session',num2str(session),'.png']);
end

%% Summarize relevant data in table

close all;
%Calculate offset variation as the circular standard deviation of the
%'stimulus offset'
for session = 1:length(open_loop_sessions)
    [~,stim_offset_var(session)] = circ_std(deg2rad(stim_offset{session}),[],[],2);
    Rsq{session} = data{1,session}.continuous_data.adj_rs;
    TotalMvt{session} = data{1,session}.continuous_data.total_mvt_ds;
    [~,stim_offset_var_thresh(session)] = circ_std(deg2rad(stim_offset{session}(Rsq{session} > 0.5)),[],[],2);
    stim_offset_precision(session) = circ_r(deg2rad(stim_offset{session}(TotalMvt{session} > 25)),[],[],2);
end

%Define stimulus velocity conditions-which panel functions were used?
stim_vel_30 = [52,53];
stim_vel_60 = [54,55];
stim_vel_90 = [206,207];
stim_vel_120 = [208,209];
stim_vel_150 = [210,211];
stim_vel_180 = [212,213];
stim_vel_210 = [214,215];


%Obtain bump parameters
for session = 1:length(open_loop_sessions)
    BumpMagnitude{session} = data{1,session}.continuous_data.bump_magnitude;
    meanBM(session) = mean(BumpMagnitude{session});   

    BumpWidth{session} = data{1,session}.continuous_data.bump_width;
    meanBW(session) = mean(BumpWidth{session});
    
    total_mvt(session) = nanmean(TotalMvt{session});
    
    meanBM_thresh(session) = nanmean(BumpMagnitude{session}(Rsq{session} > 0.5 & TotalMvt{session} > 25));
    meanBW_thresh(session) = nanmean(BumpWidth{session}(Rsq{session} > 0.5 & TotalMvt{session} > 25));
end


%Obtain for each session a table with their offset var, their mean bump magnitude and bump width and their stim
%velocity
summarydata = array2table(zeros(0,9), 'VariableNames',{'offset_var','offset_var_thresh','offset_precision','bump_mag','bump_width','bump_mag_thresh','bump_width_thresh','stim_vel','total_mvt'});
warning('off');
for session = 1:length(open_loop_sessions)
    summarydata{session,'offset_var'} = stim_offset_var(session);
    summarydata{session,'offset_var_thresh'} = stim_offset_var_thresh(session); 
    summarydata{session,'offset_precision'} = stim_offset_precision(session);     
    summarydata{session,'bump_mag'} = meanBM(session);
    summarydata{session,'bump_mag_thresh'} = meanBM_thresh(session);    
    summarydata{session,'bump_width'} = meanBW(session);
    summarydata{session,'bump_width_thresh'} = meanBW_thresh(session);    
    if (data{1,session}.continuous_data.run_obj.function_number == 52 | data{1,session}.continuous_data.run_obj.function_number == 53)
        summarydata{session,'stim_vel'} = 30; 
    elseif (data{1,session}.continuous_data.run_obj.function_number == 54 | data{1,session}.continuous_data.run_obj.function_number == 55)
        summarydata{session,'stim_vel'} = 60; 
    elseif (data{1,session}.continuous_data.run_obj.function_number == 206 | data{1,session}.continuous_data.run_obj.function_number == 207)
        summarydata{session,'stim_vel'} = 90; 
    elseif (data{1,session}.continuous_data.run_obj.function_number == 208 | data{1,session}.continuous_data.run_obj.function_number == 209)
        summarydata{session,'stim_vel'} = 120; 
    elseif (data{1,session}.continuous_data.run_obj.function_number == 210 | data{1,session}.continuous_data.run_obj.function_number == 211)
        summarydata{session,'stim_vel'} = 150; 
    elseif (data{1,session}.continuous_data.run_obj.function_number == 212 | data{1,session}.continuous_data.run_obj.function_number == 213)
        summarydata{session,'stim_vel'} = 180; 
    else
        summarydata{session,'stim_vel'} = 210; 
    end
    summarydata{session,'total_mvt'} = total_mvt(session);
end

%% Compare the offset precision across speeds

%Average relevant information
mean_offset_data = varfun(@mean,summarydata,'InputVariables','offset_precision',...
       'GroupingVariables',{'stim_vel'});
   
%Plot
figure('Position',[200 200 800 800]),
scatter(mean_offset_data.stim_vel,mean_offset_data.mean_offset_precision,60)
ylim([0 1.5]);
[ax,h2]=suplabel('Stimulus angular velocity (deg/s)','x');
set(h2,'FontSize',12,'FontWeight','bold')
ylabel('HD encoding reliability','FontSize',12);

%save
saveas(gcf,[path,'\analysis\continuous_plots\open_loop_offset_precision.png']);

%% Thresholding

%Average relevant information
mean_offset_data_thresh = varfun(@mean,summarydata,'InputVariables','offset_var_thresh',...
       'GroupingVariables',{'stim_vel'});
   
%Plot
figure('Position',[200 200 800 800]),
scatter(mean_offset_data_thresh.stim_vel,mean_offset_data_thresh.mean_offset_var_thresh,60)
ylim([0 1.5]);
[ax,h2]=suplabel('Stimulus angular velocity (deg/s)','x');
set(h2,'FontSize',12,'FontWeight','bold')
ylabel('Offset variation (circ std)','FontSize',12);

%save
saveas(gcf,[path,'\analysis\continuous_plots\open_loop_offset_var_thresh.png']);

%% Compare the bump magnitude for each speed between contrasts

%Average relevant information
mean_bump_data = varfun(@mean,summarydata,'InputVariables','bump_mag',...
       'GroupingVariables',{'stim_vel'});
   
%Plot
figure('Position',[200 200 800 800]),
scatter(mean_bump_data.stim_vel,mean_bump_data.mean_bump_mag,60)
ylim([0 2.5]);
[ax,h2]=suplabel('Stimulus angular velocity (deg/s)','x');
set(h2,'FontSize',12,'FontWeight','bold')
ylabel('Bump magnitude (DF/F)');

%save
saveas(gcf,[path,'\analysis\continuous_plots\mean_bump_mag.png']);

%% Repeat thresholding

%Average relevant information
mean_bump_data_thresh = varfun(@mean,summarydata,'InputVariables','bump_mag_thresh',...
       'GroupingVariables',{'stim_vel'});
   
%Plot
figure('Position',[200 200 800 800]),
scatter(mean_bump_data_thresh.stim_vel,mean_bump_data_thresh.mean_bump_mag_thresh,60)
ylim([0 2.5]);
[ax,h2]=suplabel('Stimulus angular velocity (deg/s)','x');
set(h2,'FontSize',12,'FontWeight','bold')
ylabel('Bump magnitude (DF/F)');

%save
saveas(gcf,[path,'\analysis\continuous_plots\mean_bump_mag_thresh.png']);

%% Compare the width at half max for each speed between contrasts

%Average relevant information
mean_hw_data = varfun(@mean,summarydata,'InputVariables','bump_width',...
       'GroupingVariables',{'stim_vel'});
   
%Plot
figure('Position',[200 200 800 800]),
scatter(mean_hw_data.stim_vel,mean_hw_data.mean_bump_width,60)
ylim([0 5]);
[ax,h2]=suplabel('Stimulus angular velocity (deg/s)','x');
set(h2,'FontSize',12,'FontWeight','bold')
ylabel('Bump width at half max (rad)');

%save
saveas(gcf,[path,'\analysis\continuous_plots\mean_bump_hw.png']);

%% Repeat thresholding

%Average relevant information
mean_hw_data_thresh = varfun(@mean,summarydata,'InputVariables','bump_width_thresh',...
       'GroupingVariables',{'stim_vel'});
   
%Plot
figure('Position',[200 200 800 800]),
scatter(mean_hw_data_thresh.stim_vel,mean_hw_data_thresh.mean_bump_width_thresh,60)
ylim([0 5]);
[ax,h2]=suplabel('Stimulus angular velocity (deg/s)','x');
set(h2,'FontSize',12,'FontWeight','bold')
ylabel('Bump width at half max (rad)');

%save
saveas(gcf,[path,'\analysis\continuous_plots\mean_bump_hw_thresh.png']);

%% Model BM and BW as a function of total movement, and stim velocity

close all;
%create table with relevant variables
allBumpMag = [];
allBumpWidth = [];
allTotalMvt = [];
allZscoredMvt = [];
allRsq = [];
allTime = [];
stimVel = [];

for session = 1:length(open_loop_sessions)
   allBumpMag = [allBumpMag,BumpMagnitude{1,session}];
   allBumpWidth = [allBumpWidth,BumpWidth{1,session}]; 
   allTotalMvt = [allTotalMvt,fillmissing(data{1,session}.continuous_data.total_mvt_ds,'linear')];
   allZscoredMvt = [allZscoredMvt,zscore(fillmissing(data{1,session}.continuous_data.total_mvt_ds,'linear'))];
   allTime = [allTime,data{1,session}.continuous_data.time'];
   allRsq = [allRsq;data{1,session}.continuous_data.adj_rs'];
   if (data{1,session}.continuous_data.run_obj.function_number == 52 | data{1,session}.continuous_data.run_obj.function_number == 53)
       stimVel = [stimVel,repelem(30,length(data{1,session}.continuous_data.time))];
   elseif (data{1,session}.continuous_data.run_obj.function_number == 54 | data{1,session}.continuous_data.run_obj.function_number == 55)
       stimVel = [stimVel,repelem(60,length(data{1,session}.continuous_data.time))];
   elseif (data{1,session}.continuous_data.run_obj.function_number == 206 | data{1,session}.continuous_data.run_obj.function_number == 207)
       stimVel = [stimVel,repelem(90,length(data{1,session}.continuous_data.time))];
   elseif (data{1,session}.continuous_data.run_obj.function_number == 208 | data{1,session}.continuous_data.run_obj.function_number == 209)
       stimVel = [stimVel,repelem(120,length(data{1,session}.continuous_data.time))];
   elseif (data{1,session}.continuous_data.run_obj.function_number == 210 | data{1,session}.continuous_data.run_obj.function_number == 211)
       stimVel = [stimVel,repelem(150,length(data{1,session}.continuous_data.time))];
   elseif (data{1,session}.continuous_data.run_obj.function_number == 212 | data{1,session}.continuous_data.run_obj.function_number == 213)
       stimVel = [stimVel,repelem(180,length(data{1,session}.continuous_data.time))];
   elseif (data{1,session}.continuous_data.run_obj.function_number == 214 | data{1,session}.continuous_data.run_obj.function_number == 215)
       stimVel = [stimVel,repelem(210,length(data{1,session}.continuous_data.time))];
   end
end
bump_mag_data = table(stimVel',allTime',allTotalMvt',allZscoredMvt',allBumpMag',allRsq,'VariableNames',{'stimVel','Time','TotalMovement','ZscoredMvt','BumpMagnitude','Rsq'});
bump_width_data = table(stimVel',allTime',allTotalMvt',allZscoredMvt',allBumpWidth',allRsq,'VariableNames',{'stimVel','Time','TotalMovement','ZscoredMvt','BumpWidth','Rsq'});

mdl_BM = fitlm(bump_mag_data,'BumpMagnitude ~ stimVel+ZscoredMvt')
mdl_BW = fitlm(bump_width_data,'BumpWidth ~ stimVel+ZscoredMvt')


%% Save relevant data

save([path,'\analysis\open_loop_data.mat'],'bump_mag_data','bump_width_data','summarydata');

clear all; close all;