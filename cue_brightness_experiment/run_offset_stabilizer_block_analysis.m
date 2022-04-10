
function run_offset_stabilizer_block_analysis()

%This function plots the data for the offset stabilizer block for all the flies in the
%dataset (heatmap of EPG activity, phase and bar position in time, offset
%in time, and offset distribution)



%Get the path to the data for each fly
parentDir = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts';
folderNames = dir(parentDir);

for content = 1:length(folderNames)
    if contains(folderNames(content).name,'60D05')
        flyData{content} = [folderNames(content).folder,'\',folderNames(content).name];
    end
end
%Remove empty cells
data_dirs = flyData(~cellfun(@isempty,flyData));


%Determine the session id for this trial type from the session_info.mat
%file, load the data and plot
for fly = 1:length(data_dirs)
    
    load([data_dirs{fly},'\sessions_info.mat']);
    sid = sessions_info.offset_stabilizer;
    
    %Get the contents of the fly folder
    fly_files = dir([data_dirs{fly},'\analysis']);
    
    %Determine which content belongs to the sid we extracted
    for file = 1:length(fly_files)
        if (contains(fly_files(file).name,['sid_',num2str(sid),'_']) & contains(fly_files(file).name,'continuous'))
            
            %Load the data
            path = fly_files(file).folder;
            load([path,'\',fly_files(file).name])
            
            %% Make directory to save plots
            
            %List the contents of the analysis folder
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
            xlim([0 x_out_offset(end-1)]);
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
            saveas(gcf,[path,'\continuous_plots\offset_stabilizer_block_heatmap.png']);
            %
            %
            %             %% Analyze relationship between yaw speed data and BM
            %
            %             nbins = 20;
            %             yaw_speed = abs(continuous_data.vel_yaw_ds);
            %             maxBinYS = max(yaw_speed);
            %             binWidthYS = maxBinYS/nbins;
            %             YSBins = [0:binWidthYS:maxBinYS];
            %
            %             %getting binned means
            %             for bin = 1:length(YSBins)-1
            %                 meanBin(bin) = mean(continuous_data.bump_magnitude((yaw_speed(1:length(continuous_data.bump_magnitude)) > YSBins(bin)) & (yaw_speed(1:length(continuous_data.bump_magnitude)) < YSBins(bin+1))));
            %             end
            %
            %             %create axes for plot
            %             YSAxes = YSBins - binWidthYS;
            %             YSAxes = YSAxes(2:end);
            %             YSAxes(end) = YSAxes(end-1)+binWidthYS;
            %
            %             %Plot
            %             figure('Position',[200 200 1400 600]),
            %             %Plot bump magnitude in time
            %             subplot(2,4,[1 3])
            %             plot(continuous_data.time(1:length(continuous_data.bump_magnitude)),continuous_data.bump_magnitude, 'k')
            %             ylabel('Bump magnitude');
            %             ylim([0 5]);
            %             set(gca,'xticklabel',{[]});
            %
            %             %Plot total movement
            %             subplot(2,4,[5 7])
            %             plot(continuous_data.time(1:length(continuous_data.bump_magnitude)),yaw_speed(1:length(continuous_data.bump_magnitude)),'k')
            %             xlabel('Time (sec)');
            %             ylabel('Yaw speed (deg/s)');
            %
            %             %Plot relationship between both parameters
            %             subplot(2,4,[4,8]);
            %             plot(YSAxes,meanBin,'-ko')
            %             ylabel('Mean bump magnitude'); xlabel('Yaw speed (deg/s)');
            %             ylim([0 (max(meanBin)+0.5)]);
            %
            %
            %             %% Bin for vel data
            %
            %             for_vel = abs(continuous_data.vel_for_ds');
            %             maxBinFV = max(for_vel);
            %             binWidthFV = maxBinFV/nbins;
            %             FVBins = [0:binWidthFV:maxBinFV];
            %
            %             %getting binned means
            %             for bin = 1:length(FVBins)-1
            %                 meanBin(bin) = mean(continuous_data.bump_magnitude((for_vel(1:length(continuous_data.bump_magnitude)) > FVBins(bin)) & (for_vel(1:length(continuous_data.bump_magnitude)) < FVBins(bin+1))));
            %             end
            %
            %             %create axes for plot
            %             fvAxes = FVBins - binWidthFV;
            %             fvAxes = fvAxes(2:end);
            %             fvAxes(end) = fvAxes(end-1)+binWidthFV;
            %
            %             %Plot
            %             figure('Position',[200 200 1400 600]),
            %             %Plot bump magnitude in time
            %             subplot(2,4,[1 3])
            %             plot(continuous_data.time(1:length(continuous_data.bump_magnitude)),continuous_data.bump_magnitude, 'k')
            %             ylabel('Bump magnitude');
            %             ylim([0 5]);
            %             set(gca,'xticklabel',{[]});
            %
            %             %Plot total movement
            %             subplot(2,4,[5 7])
            %             plot(continuous_data.time(1:length(continuous_data.bump_magnitude)),for_vel(1:length(continuous_data.bump_magnitude)),'k')
            %             xlabel('Time (sec)');
            %             ylabel('Forward velocity (mm/s)');
            %
            %             %Plot relationship between both parameters
            %             subplot(2,4,[4,8]);
            %             plot(fvAxes,meanBin,'-ko')
            %             ylabel('Mean bump magnitude'); xlabel('Forward velocity (mm/s)');
            %             ylim([0 (max(meanBin)+0.5)]);
            %
            %             %% Bin both parameters to build heatmap
            %
            %             %getting binned means
            %             for ys_bin = 1:length(YSBins)-1
            %                 for fv_bin = 1:length(FVBins)-1
            %                     doubleBin(ys_bin,fv_bin) = mean(continuous_data.bump_magnitude((yaw_speed(1:length(continuous_data.bump_magnitude)) > YSBins(ys_bin)) & (yaw_speed(1:length(continuous_data.bump_magnitude)) < YSBins(ys_bin+1)) & (for_vel(1:length(continuous_data.bump_magnitude)) > FVBins(fv_bin)) & (for_vel(1:length(continuous_data.bump_magnitude)) < FVBins(fv_bin+1))));
            %                 end
            %             end
            %
            %             %flip the data such that high forward velocity values are at the top
            %             binned_data = flip(doubleBin);
            %
            %             figure,
            %             imagesc(binned_data)
            %             xticks([1:4:20])
            %             set(gca, 'XTickLabel', round(FVBins(1:4:20)))
            %             xlabel('Forward velocity (mm/s)','fontsize',12,'fontweight','bold');
            %             ylabel('Yaw speed (deg/sec)','fontsize',12,'fontweight','bold');
            %             yticks([1:4:20])
            %             set(gca, 'YTickLabel', round(YSBins(20:-4:1)))
            %             c = colorbar;
            %             ylabel(c, 'Bump magnitude')
            %
            %
            %             %Save figure
            %             saveas(gcf,[path,'\continuous_plots\bm_heatmap.png']);
            %
            %             %Save velocity and bump magnitude data
            %             bump_magnitude = continuous_data.bump_magnitude;
            %             save([fly_files(file).folder,'\continuous_vel_bm_data.mat'],'for_vel','yaw_speed','bump_magnitude');
            
            
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
                standing_offset_precision(:,window) = matlab.tall.movingWindow(fcn_precision,window_sizes(window),deg2rad(offset(~moving)));
                heading_precision(:,window) = matlab.tall.movingWindow(fcn_precision,window_sizes(window),continuous_data.heading(moving));
                bump_mag(:,window) = movmean(continuous_data.bump_magnitude(moving & gof),window_sizes);
                standing_bump_mag(:,window) = movmean(continuous_data.bump_magnitude(~moving & gof),window_sizes);                
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
            
            
            %% Global offset precision
            
            global_offset_precision = circ_r(deg2rad(offset(moving & gof)));
            global_standing_offset_precision = circ_r(deg2rad(offset(~moving & gof)));            
            
            %% Get bump and movement parameters
            
            zbump_magnitude = zscore(continuous_data.bump_magnitude(gof ));
            zbump_width = zscore(continuous_data.bump_width(gof));
            total_mvt = continuous_data.total_mvt_ds(gof);
            rot_speed = abs(continuous_data.vel_yaw_ds(gof));
            for_vel = continuous_data.vel_for_deg_ds(gof);   
            
            all_mvt_data = table(zbump_magnitude',zbump_width',total_mvt',rot_speed',for_vel,'VariableNames', {'zbump_magnitude','zbump_width','total_mvt','rot_speed','for_vel'});
            
            mean_bump_mag_standing = mean(continuous_data.bump_magnitude(gof & ~moving));
            mean_bump_mag_moving = mean(continuous_data.bump_magnitude(gof & moving));
            mean_bump_width_standing = mean(continuous_data.bump_width(gof & ~moving));
            mean_bump_width_moving = mean(continuous_data.bump_width(gof & moving));
            
            zbump_mag_moving = zscore(continuous_data.bump_magnitude(gof & moving));
            zbump_width_moving = zscore(continuous_data.bump_width(gof & moving));
            rot_speed_moving = abs(continuous_data.vel_yaw_ds(gof & moving));
            
            all_thresh_mvt_data = table(zbump_mag_moving',zbump_width_moving',rot_speed_moving','VariableNames', {'zbump_mag','zbump_width','rot_speed'});
            
            %% Save data
            
            save([path,'\offset_stabilizer_data.mat'],'mean_bump_mag_standing','mean_bump_width_standing','mean_bump_mag_moving','mean_bump_width_moving','offset_precision','bump_mag','bump_width','time','moving','gof','heading_precision','standing_offset_precision','standing_bump_mag','global_offset_precision','global_standing_offset_precision','all_mvt_data','all_thresh_mvt_data');
            
            %%
            close all; clearvars -except fly data_dirs fly_files sid
            
        end
        
    end
end
end
