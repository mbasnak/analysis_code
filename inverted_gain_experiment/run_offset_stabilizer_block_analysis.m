
function run_offset_stabilizer_block_analysis()

%plot the heatmap for the offset stabilizer block for all the flies in the
%dataset

%Get the path for each fly
parentDir = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data';
folderNames = dir(parentDir);

for content = 1:length(folderNames)
    if contains(folderNames(content).name,'60D05')
        flyData{content} = [folderNames(content).folder,'\',folderNames(content).name];
    end
end

%remove empty cells
data_dirs = flyData(~cellfun(@isempty,flyData));

%determine the session id for this trial type from the session_info.mat
%file, load the data and plot
for fly = 1:length(data_dirs)
    
    clearvars -except data_dirs fly
    
    load([data_dirs{fly},'\sessions_info.mat']);
    sid = sessions_info.offset_stabilizer;
    
    %get the contents of the fly folder
    fly_files = dir([data_dirs{fly},'\analysis']);
    %determine which content belongs to the sid we extracted
    for file = 1:length(fly_files)
        if (contains(fly_files(file).name,['sid_',num2str(sid),'_']) & contains(fly_files(file).name,'continuous_'))
            %load the data
            load([fly_files(file).folder,'\',fly_files(file).name])
            
            path = [fly_files(file).folder,'\'];
            
            %% Plot heatmap with bar position, phase and offset
            
            figure('Position',[200 200 1000 600]),
            subplot(3,6,[1 5])
            %Plot heatmap of EPG activity
            imagesc(continuous_data.dff_matrix')
            colormap(flipud(gray))
            ylabel('PB glomerulus');
            yticks(1:2:16);
            yticklabels({'8L','6L','4L','2L','1R','3R','5R','7R'});
            title('EPG activity in the PB');
            set(gca,'xtick',[]);
            set(gca,'xticklabel',{[]});
            
            subplot(3,6,[7 11])
            %Get bar position to plot
            bar_position = wrapTo180(continuous_data.visual_stim_pos);
            change_bar_position = abs([0;diff(smooth(bar_position))]);
            bar_position_to_plot = smooth(bar_position);
            bar_position_to_plot(change_bar_position>40==1) = NaN;
            plot(bar_position_to_plot,'LineWidth',1.5,'color',[0.2 0.6 0.7])
            hold on
            %Get EPG phase to plot
            phase = wrapTo180(rad2deg(continuous_data.bump_pos));
            change_phase = abs([0;diff(smooth(phase))]);
            phase_to_plot = smooth(phase);
            phase_to_plot(change_phase>40==1) = NaN;
            plot(phase_to_plot,'LineWidth',1.5,'color',[0.9 0.3 0.4])
            xlim([0 length(continuous_data.visual_stim_pos)]);
            ylim([-180 180]);
            axP = get(gca,'Position');
            legend('Bar position','EPG phase','Location','EastOutside')
            set(gca, 'Position', axP);
            ylabel('Deg');
            title('Bar and bump position');
            set(gca,'xticklabel',{[]})
            
            subplot(3,6,[13 17])
            %Get offset to plot
            offset = wrapTo180(rad2deg(circ_dist(deg2rad(continuous_data.visual_stim_pos),continuous_data.bump_pos')));
            change_offset = abs([0;diff(smooth(offset))]);
            offset_to_plot = smooth(offset);
            offset_to_plot(change_offset>30==1) = NaN;
            plot(continuous_data.time,offset_to_plot,'k','LineWidth',1.5)
            xlim([0 continuous_data.time(end)]);
            ylim([-180 180]);
            xlabel('Time (sec)');
            ylabel('Deg');
            title('Offset');
            
            subplot(3,6,18)
            polarhistogram(deg2rad(offset),'FaceColor','k')
            set(gca,'ThetaZeroLocation','top',...
                'ThetaDir','counterclockwise');
            title('Offset distribution');
            rticklabels({}); %remove rticklabels
            
            %Save figure
            saveas(gcf,[path,'continuous_plots\Offset_stabilizer_block_heatmap.png']);
            %
            %
            %             %% Binned plots of bump magnitude and movement
            %
            %             bump_mag = data.bump_magnitude;
            %
            %             figure('Position',[200 200 1400 600]),
            %
            %             nbins = 20;
            %             max_fwd_bin = max(data.vel_for_deg_ds)-10;
            %             min_mvt_bin = 0;
            %             binWidth = max_fwd_bin/nbins;
            %             fwdBins = [0:binWidth:max_fwd_bin];
            %
            %             %getting binned means
            %             for bin = 1:length(fwdBins)-1
            %                 meanBin(bin) = mean(bump_mag((data.vel_for_deg_ds > fwdBins(bin)) & (data.vel_for_deg_ds < fwdBins(bin+1))));
            %                 stdBin(bin) = std(bump_mag((data.vel_for_deg_ds > fwdBins(bin)) & (data.vel_for_deg_ds < fwdBins(bin+1))));
            %                 errBin(bin) = stdBin(bin)./sqrt(length((bump_mag((data.vel_for_deg_ds > fwdBins(bin)) & (data.vel_for_deg_ds < fwdBins(bin+1))))));
            %             end
            %
            %             %create axes for plot
            %             mvtAxes = fwdBins - binWidth;
            %             mvtAxes = mvtAxes(2:end);
            %             mvtAxes(end) = mvtAxes(end-1)+binWidth;
            %
            %             %Plot
            %             subplot(1,4,1)
            %             boundedline(mvtAxes,meanBin,errBin)
            %             ylabel('Bump magnitude (max-min)'); xlabel('Fwd velocity (deg/s)');
            %             ylim([0 max(bump_mag)]);
            %             title('Forward velocity');
            %
            %
            %             %side speed
            %             max_side_bin = max(abs(data.vel_side_deg_ds))-10;
            %             binWidth = max_side_bin/nbins;
            %             sideBins = [0:binWidth:max_side_bin];
            %
            %             %getting binned means
            %             for bin = 1:length(sideBins)-1
            %                 meanBin(bin) = mean(bump_mag((abs(data.vel_side_deg_ds) > sideBins(bin)) & (abs(data.vel_side_deg_ds) < sideBins(bin+1))));
            %                 stdBin(bin) = std(bump_mag((abs(data.vel_side_deg_ds)> sideBins(bin)) & (abs(data.vel_side_deg_ds) < sideBins(bin+1))));
            %                 errBin(bin) = stdBin(bin)./sqrt(length((bump_mag((abs(data.vel_side_deg_ds) > sideBins(bin)) & (abs(data.vel_side_deg_ds) < sideBins(bin+1))))));
            %             end
            %
            %             %create axes for plot
            %             mvtAxes = sideBins - binWidth;
            %             mvtAxes = mvtAxes(2:end);
            %             mvtAxes(end) = mvtAxes(end-1)+binWidth;
            %
            %             %Plot
            %             subplot(1,4,2)
            %             boundedline(mvtAxes,meanBin,errBin,'m')
            %             xlabel('Side speed (deg/s)');
            %             ylim([0 max(bump_mag)]);
            %             title('Side speed');
            %
            %
            %             %yaw speed
            %             max_yaw_bin = max(abs(data.vel_yaw_ds))-10;
            %             binWidth = max_yaw_bin/nbins;
            %             yawBins = [0:binWidth:max_yaw_bin];
            %
            %             %getting binned means
            %             for bin = 1:length(yawBins)-1
            %                 meanBin(bin) = mean(bump_mag((abs(data.vel_yaw_ds) > yawBins(bin)) & (abs(data.vel_yaw_ds) < yawBins(bin+1))));
            %                 stdBin(bin) = std(bump_mag((abs(data.vel_yaw_ds)> yawBins(bin)) & (abs(data.vel_yaw_ds) < yawBins(bin+1))));
            %                 errBin(bin) = stdBin(bin)./sqrt(length((bump_mag((abs(data.vel_yaw_ds) > yawBins(bin)) & (abs(data.vel_yaw_ds) < yawBins(bin+1))))));
            %             end
            %
            %             %create axes for plot
            %             mvtAxes = yawBins - binWidth;
            %             mvtAxes = mvtAxes(2:end);
            %             mvtAxes(end) = mvtAxes(end-1)+binWidth;
            %
            %             %Plot
            %             subplot(1,4,3)
            %             boundedline(mvtAxes,meanBin,errBin,'r')
            %             xlabel('Yaw speed (deg/s)');
            %             ylim([0 max(bump_mag)]);
            %             title('Yaw speed');
            %
            %
            %
            %             %total movement
            %             max_mvt_bin = max(data.total_mvt_ds)-10;
            %             binWidth = max_mvt_bin/nbins;
            %             mvtBins = [0:binWidth:max_mvt_bin];
            %
            %             %getting binned means
            %             for bin = 1:length(mvtBins)-1
            %                 meanBin(bin) = mean(bump_mag((data.total_mvt_ds > mvtBins(bin)) & (data.total_mvt_ds < mvtBins(bin+1))));
            %                 stdBin(bin) = std(bump_mag((data.total_mvt_ds > mvtBins(bin)) & (data.total_mvt_ds < mvtBins(bin+1))));
            %                 errBin(bin) = stdBin(bin)./sqrt(length((bump_mag((data.total_mvt_ds > mvtBins(bin)) & (data.total_mvt_ds < mvtBins(bin+1))))));
            %             end
            %
            %             %create axes for plot
            %             mvtAxes = mvtBins - binWidth;
            %             mvtAxes = mvtAxes(2:end);
            %             mvtAxes(end) = mvtAxes(end-1)+binWidth;
            %
            %             %Plot
            %             subplot(1,4,4)
            %             boundedline(mvtAxes,meanBin,errBin,'k')
            %             xlabel('Total movement (deg/s)');
            %             ylim([0 max(bump_mag)]);
            %             title('Total movement');
            %
            %             %Save figure
            %             saveas(gcf,[path,'plots\Offset_stabilizer_block_mvt_trend.png']);
            %
            %             %% Get reference offset from the last part of the block
            %
            %             visual_offset = circ_dist(data.dff_pva,deg2rad(wrapTo180(data.panel_angle)));
            %             mean_reference_offset = rad2deg(circ_mean(visual_offset(600:900),[],1));
            %
            %             save([path,'\reference_offset.mat'],'mean_reference_offset')
            
            
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
                heading_precision(:,window) = matlab.tall.movingWindow(fcn_precision,window_sizes(window),continuous_data.heading(moving));
                bump_mag(:,window) = movmean(continuous_data.bump_magnitude(moving & gof),window_sizes);
                bump_width(:,window) = movmean(continuous_data.bump_width(moving & gof),window_sizes);
            end
            
            time = continuous_data.time;
            
            figure('Position',[100 100 1200 1000]),
            subplot(3,1,1)
            plot(time(moving),offset_precision)
            xlabel('Time (sec)'); ylabel('Offset precision');
            ylim([0 1]);
            
            subplot(3,1,2)
            plot(time(moving & gof),bump_mag)
            xlabel('Time (sec)'); ylabel('Bump magnitude');
            ylim([0.5 2]);
            
            subplot(3,1,3)
            plot(time(moving & gof),bump_width)
            xlabel('Time (sec)'); ylabel('Bump width');
            ylim([1 2.5]);
            
            
            %% Save data
            
            save([path,'\offset_stabilizer_data.mat'],'offset_precision','bump_mag','bump_width','time','moving','gof','heading_precision');
            
        end
        
        
    end
end

close all;