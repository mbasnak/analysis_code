%code to convert data to NWB

clear all; close all;

generateCore();

%% Get the path for each fly

parentDir = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\GCaMP_control\data';
folderNames = dir(parentDir);

for content = 1:length(folderNames)
    if contains(folderNames(content).name,'60D05')
        flyData{content} = [folderNames(content).folder,'\',folderNames(content).name];
    end
end

%remove empty cells
data_dirs = flyData(~cellfun(@isempty,flyData));

%% determine the session id for this trial type from the session_info.mat
%file, load the data and convert to nwb

for fly = 1:length(data_dirs)
    
    
    %get the contents of the fly folder
    fly_files = dir([data_dirs{fly},'\analysis']);
    
    for file = 1:length(fly_files)
        
        if contains(fly_files(file).name,'continuous_analysis')
            
            %load the data
            fileName = fly_files(file).name;
            load([fly_files(file).folder,'\',fly_files(file).name])
            
            %% Determine stimulus speed
            
            if (continuous_data.run_obj.function_number == 52 | continuous_data.run_obj.function_number == 53)
                stim_vel = 30;
            elseif (continuous_data.run_obj.function_number == 54 | continuous_data.run_obj.function_number == 55)
                stim_vel = 60;
            elseif (continuous_data.run_obj.function_number == 206 | continuous_data.run_obj.function_number == 207)
                stim_vel = 90;
            elseif (continuous_data.run_obj.function_number == 208 | continuous_data.run_obj.function_number == 209)
                stim_vel = 120;
            elseif (continuous_data.run_obj.function_number == 210 | continuous_data.run_obj.function_number == 211)
                stim_vel = 150;
            elseif (continuous_data.run_obj.function_number == 212 | continuous_data.run_obj.function_number == 213)
                stim_vel = 180;
            else
                stim_vel = 210;
            end
            
            sid = fly_files(file).name(25:26);
            sid = regexprep(sid,'_','');
            
            
            %% Set up the NWB file
            
            %An NWB file represents a single session of an experiment.
            %Each file must have a session_description, identifier, and session start time.
            %Create a new NWBFile object with those and additional metadata.
            %For all MatNWB functions, we use the Matlab method of entering keyword argument pairs, where arguments are entered
            %as name followed by value.
            
            %get name from matching sid run_obj and extract date
            run_obj_files = dir([data_dirs{fly},'\ball\runobj']);
            for run_obj_file = 1:length(run_obj_files)
                if contains(run_obj_files(run_obj_file).name,['sid_',num2str(sid)])
                    run_obj_file_name = run_obj_files(run_obj_file).name;
                end
            end
            year = str2num(run_obj_file_name(1:4));
            month = str2num(run_obj_file_name(6:7));
            day = str2num(run_obj_file_name(8:9));
            hour = str2num(run_obj_file_name(11:12));
            min = str2num(run_obj_file_name(14:15));
            sec = str2num(run_obj_file_name(17:18));
            
            if fly == 6
                nwb = NwbFile( ...
                    'session_description', 'fly presented with a bright visual cue rotating in open loop',...
                    'identifier', strcat('Fly',num2str(30)), ...
                    'session_start_time', datetime(year, month, day, hour, min, sec), ...
                    'general_experimenter', 'Melanie Basnak', ... % optional
                    'general_institution', 'Harvard University'); % optional
            else
                nwb = NwbFile( ...
                    'session_description', 'fly presented with a bright visual cue rotating in open loop',...
                    'identifier', strcat('Fly',num2str(fly+61)), ...
                    'session_start_time', datetime(year, month, day, hour, min, sec), ...
                    'general_experimenter', 'Melanie Basnak', ... % optional
                    'general_institution', 'Harvard University'); % optional
            end
            
            nwb
            
            
            %% Specify the subject information
            
            if fly ==6
                subject = types.core.Subject( ...
                    'subject_id', num2str(30), ...
                    'age', 'P1D', ...
                    'description', strcat('Fly ',num2str(30)), ...
                    'genotype', '60D05/GCaMP7f',...
                    'species', 'Drosophila melanogaster', ...
                    'sex', 'F');
            else
                subject = types.core.Subject( ...
                    'subject_id', num2str(fly+61), ...
                    'age', 'P1D', ...
                    'description', strcat('Fly ',num2str(fly+61)), ...
                    'genotype', '60D05/GCaMP7f',...
                    'species', 'Drosophila melanogaster', ...
                    'sex', 'F');
            end
            nwb.general_subject = subject;
            
            
            %% Save behavior data
            
            heading_data = continuous_data.heading;
            
            spatial_series_ts = types.core.SpatialSeries( ...
                'data', heading_data, ...
                'data_unit','radians',...
                'reference_frame', '0 means the cue is right in front of the fly', ...
                'timestamps', continuous_data.time);
            
            %store the SpatialSeries object inside of a Position object.
            Position = types.core.CompassDirection('SpatialSeries', spatial_series_ts);
            
            %Create a processing module called "behavior" for storing behavioral data in the NWBFile and add the Position
            %object to the module.
            
            % create processing module
            behavior_mod = types.core.ProcessingModule( ...
                'description',  'contains behavioral data');
            % add the Position object (that holds the SpatialSeries object)
            behavior_mod.nwbdatainterface.set(...
                'Position', Position);
            % add the processing module to the NWBFile object, and name it "behavior"
            nwb.processing.set('behavior', behavior_mod);
            
            
            %% Imaging data
            
            %% Set imaging plane object
            
            % First, you must create an ImagingPlane object, which will hold information about the area and method used to collect
            %the optical imaging data.
            
            optical_channel = types.core.OpticalChannel( ...
                'description', 'description', ...
                'emission_lambda', 510.);
            device = types.core.Device();
            nwb.general_devices.set('Device', device);
            imaging_plane_name = 'imaging_plane';
            imaging_plane = types.core.ImagingPlane( ...
                'optical_channel', optical_channel, ...
                'description', 'EPG imaging in the PB', ...
                'device', types.untyped.SoftLink(device), ...
                'excitation_lambda', 485, ...
                'imaging_rate', 9.18, ...
                'indicator', 'GCaMP7f', ...
                'location', 'PB');
            nwb.general_optophysiology.set(imaging_plane_name, imaging_plane);
            
            %not sure about this section
            
            
            %% Store the raw imaging data
            
            % load imaging data
            import ScanImageTiffReader.ScanImageTiffReader;
            expression = ['*sid_' num2str(sid) '_tid_' num2str(0) '_*'];
            imagingFile = dir(fullfile([data_dirs{fly},'\2p'], expression));
            reader = ScanImageTiffReader(fullfile(data_dirs{fly}, '2p', imagingFile(1).name));
            
            %data
            rawFile_original = reader.data();
            %metadata
            metadata_char = reader.metadata();
            %descriptions = reader.descriptions();
            list = strsplit(metadata_char,'RoiGroups');%,'CollapseDelimiters',true);
            list = char(list{1});
            list = list(1:end-7);
            eval(list);
            
            %reshape
            rawFile_original = permute(rawFile_original,[2 1 3]); %permute 1st and 2nd dimensions of the image data
            dimensions = size(rawFile_original); %store imaging dimensions
            
            rawFile = reshape(rawFile_original, dimensions(1), dimensions(2), SI.hStackManager.numFramesPerVolume, SI.hStackManager.numVolumes, SI.hChannels.channelSave(end));
            
            %we're reshaping the image file so that it now has 4 dimensions: the first
            %two are the x and y coordinates of an imaging plane, the third one is the
            %number of frames per volume, and the last one is the number of volumes
            %taken in the trial.
            
            %compress the data
            compressed_data = types.untyped.DataPipe('data', rawFile);
            
            image_series = types.core.TwoPhotonSeries( ...
                'imaging_plane', types.untyped.SoftLink(imaging_plane), ...
                'data', compressed_data, ...
                'data_unit', 'n.a.',...
                'timestamps',continuous_data.time);
            nwb.acquisition.set('TwoPhotonSeries', image_series);
            
            
            %% Add ROIs using an image mask
            
            % load roi data
            load([data_dirs{fly} '\2p\ROI\ROI_midline_sid_' num2str(sid) '_tid_0.mat']);
            
            %1) Find the row corresponding to the midline
            for row = 1:length(roi)
                if contains(roi(row).name,'mid')
                    roi_mid = row;
                end
            end
            
            % determine ROI mask
            % Pull up the locations for all the px in the PB mask
            PB_mask = zeros(size(rawFile,1),size(rawFile,2));
            for row = 1:length(roi)
                if row~=roi_mid
                    PB_mask = PB_mask + roi(row).BW;
                end
            end
            PB_mask(PB_mask>1) = 1;
            PB_coverage = logical(PB_mask);
            
            
            %get the normal lines through the segment midpoints
            midline_coordinates = [roi(roi_mid).xi,roi(roi_mid).yi];
            
            %transform to integer
            midline_coordinates_in = floor(midline_coordinates);
            figure, imagesc(PB_coverage)
            for segment = 1:length(midline_coordinates_in)-1
                roiLine = images.roi.Line(gca, 'Position', [midline_coordinates_in(segment,1),midline_coordinates_in(segment,2); midline_coordinates_in(segment+1,1),midline_coordinates_in(segment+1,2)]);
                midline_segment_mask{segment} = createMask(roiLine);
            end
            
            
            n_rois = length(midline_segment_mask);
            image_mask = zeros(size(midline_segment_mask{1,1},1),size(midline_segment_mask{1,1},2),n_rois);
            for roi = 1:n_rois
                image_mask(:,:,roi) = midline_segment_mask{1,roi};
            end
            image_mask = logical(image_mask);
            
            
            % add data to NWB structures
            plane_segmentation = types.core.PlaneSegmentation( ...
                'colnames', {'image_mask'}, ...
                'id', types.hdmf_common.ElementIdentifiers('data', 0:n_rois-1), ...
                'imaging_plane', types.untyped.SoftLink(imaging_plane),'description','contains rois',...
                'image_mask', types.hdmf_common.VectorData( ...
                'data', image_mask, 'description', 'segmented of the PB midline that the DF/F traces are associated with'));
            
            %Now create an ImageSegmentation object and put the plane_segmentation object inside of it, naming it PlaneSegmentation.
            img_seg = types.core.ImageSegmentation();
            img_seg.planesegmentation.set('PlaneSegmentation', plane_segmentation);
            
            %Now create a ProcessingModule called "ophys" and put our img_seg object in it, calling it ImageSegmentation, and add the ProcessingModule to nwb.
            ophys_module = types.core.ProcessingModule( ...
                'description',  'contains optical physiology data');
            ophys_module.nwbdatainterface.set('ImageSegmentation', img_seg);
            nwb.processing.set('ophys', ophys_module);
            
            %% Store fluorescence over time
            
            roi_table_region = types.hdmf_common.DynamicTableRegion( ...
                'table', types.untyped.ObjectView(plane_segmentation), ...
                'description', 'midline_rois', ...
                'data', (0:n_rois-1)');
            
            roi_response_series = types.core.RoiResponseSeries( ...
                'rois', roi_table_region, ...
                'data', continuous_data.dff_matrix', ...
                'data_unit','na',...
                'timestamps',continuous_data.time,...
                'description','DF/F associated with each of the coordinates of the PB midline');
            fluorescence = types.core.Fluorescence();
            fluorescence.roiresponseseries.set('RoiResponseSeries', roi_response_series);
            ophys_module.nwbdatainterface.set('Fluorescence', fluorescence);
            
            %Finally, the ophys ProcessingModule is added to the NwbFile.
            nwb.processing.set('ophys', ophys_module);
            %Write the NWB file
            if fly == 6
                nwbExport(nwb, ['passive_rotation_data_fly_',num2str(30),'_sid_',sid,'_stim_vel_',num2str(stim_vel),'.nwb']);
            else
                nwbExport(nwb, ['passive_rotation_data_fly_',num2str(fly+61),'_sid_',sid,'_stim_vel_',num2str(stim_vel),'.nwb']);
            end
            
            
        end
    end
    
    clearvars -except data_dirs
    
end
