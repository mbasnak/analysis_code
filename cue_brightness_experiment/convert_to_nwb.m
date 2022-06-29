%code to convert data to NWB 

clear all; close all;

%% Get the path for each fly

parentDir = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts';
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

for fly = 1%:length(data_dirs)
    
    load([data_dirs{fly},'\sessions_info.mat']);
    sid = sessions_info.closed_loop;
    
    %get the contents of the fly folder
    fly_files = dir([data_dirs{fly},'\analysis']);
    %determine which content belongs to the sid we extracted
    
    %determine which content belongs to the sid we extracted
    for file = 1:length(fly_files)
        if (contains(fly_files(file).name,['sid_',num2str(sid),'_']) & contains(fly_files(file).name,'continuous'))
            %load the data
            fileName = fly_files(file).name;
            load([fly_files(file).folder,'\',fly_files(file).name])
            
            
            generateCore();
            
            
            
            %% Set up the NWB file
            
            %An NWB file represents a single session of an experiment.
            %Each file must have a session_description, identifier, and session start time.
            %Create a new NWBFile object with those and additional metadata.
            %For all MatNWB functions, we use the Matlab method of entering keyword argument pairs, where arguments are entered
            %as name followed by value.
            
            
            nwb = NwbFile( ...
                'session_description', 'fly presented with visual cue of varying contrast',...
                'identifier', strcat('Fly',num2str(fly)), ...
                'session_start_time', datetime(year(continuous_data.run_obj.date),month(continuous_data.run_obj.date),day(continuous_data.run_obj.date),...
                hour(continuous_data.run_obj.time),minute(continuous_data.run_obj.time),second(continuous_data.run_obj.time)), ...
                'general_experimenter', 'Melanie Basnak', ... % optional
                'general_session_id', 'change in contrast', ... % optional
                'general_institution', 'Harvard University'); % optional
            nwb
            
            
            %% Specify the subject information
            
            subject = types.core.Subject( ...
                'subject_id', num2str(fly), ...
                'age', '1D', ...
                'description', strcat('Fly ',num2str(fly)), ...
                'genotype', '60D05/GCaMP7f',...
                'species', 'Drosophila melanogaster', ...
                'sex', 'F')
            nwb.general_subject = subject;
            
            
            
            %% Save behavior data
            
            heading_data = continuous_data.heading;
            
            spatial_series_ts = types.core.SpatialSeries( ...
                'data', heading_data, ...
                'data_unit', 'rad', ...
                'reference_frame', '0 means the visual cue is right in front of the fly', ...
                'timestamps', continuous_data.time)
            
            %store the SpatialSeries object inside of a Position object.
            Position = types.core.Position('SpatialSeries', spatial_series_ts);
            
            %Create a processing module called "behavior" for storing behavioral data in the NWBFile and add the Position
            %object to the module.
            
            % create processing module
            behavior_mod = types.core.ProcessingModule( ...
                'description',  'contains behavioral data')
            % add the Position object (that holds the SpatialSeries object)
            behavior_mod.nwbdatainterface.set(...
                'Position', Position);
            % add the processing module to the NWBFile object, and name it "behavior"
            nwb.processing.set('behavior', behavior_mod);
            
            
            %% Define the 'trials' (set the ID of the different experimental blocks in this fly's session)
            
            %Identify contrast change frames
            contrast_change = find(abs(diff(continuous_data.fr_y_ds)) > 1);
            pos_function = continuous_data.run_obj.function_number;
            
            %Define the order of intensities of the visual stimuli presented according to the function used
            %1 = darkness; 2 = low contrast, 3 = high contrast
            if pos_function == 195
                contrast = [1,2,1,3,2,3];
            elseif pos_function == 196
                contrast = [2,1,3,1,2,3];
            else
                contrast = [3,1,2,1,2,3];
            end
            
            trials = types.core.TimeIntervals( ...
                'colnames', {'start_time', 'stop_time', 'cue_contrast'}, ...
                'description', 'trial data and properties', ...
                'id', types.hdmf_common.ElementIdentifiers('data', 1:6), ...
                'start_time', types.hdmf_common.VectorData('data', [0; continuous_data.time(contrast_change(1:5))], ...
                'description','start time of trial'), ...
                'stop_time', types.hdmf_common.VectorData('data', [continuous_data.time(contrast_change(1:5)); continuous_data.time(end)], ...
                'description','end of each trial'), ...
                'cue_contrast', types.hdmf_common.VectorData('data', contrast, ...
                'description', 'visual cue contrast (where 1 = zero contrast, 2 = low contrast, 3 = high contrast'))
            nwb.intervals_trials = trials;
            
            
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
            imagingFile = dir(fullfile([parentDir,'\2p'], expression));
            %reader = ScanImageTiffReader('cdata_Closed_Loop_X_Open_Loop_Y_20201019_155917_sid_1_tid_0_tt_1200__00001.tif');
            reader = ScanImageTiffReader(fullfile(parentDir, 2p, imagingFile(1).name));
            
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
            rawFile = reshape(rawFile_original, dimensions(1), dimensions(2), SI.hFastZ.numFramesPerVolume, SI.hFastZ.numVolumes, SI.hChannels.channelSave(end));
            %we're reshaping the image file so that it now has 4 dimensions: the first
            %two are the x and y coordinates of an imaging plane, the third one is the
            %number of frames per volume, and the last one is the number of volumes
            %taken in the trial.
            
            image_series = types.core.TwoPhotonSeries( ...
                'imaging_plane', types.untyped.SoftLink(imaging_plane), ...
                'starting_time', 0.0, ...
                'data', rawFile, ...
                'data_unit', 'lumens');
            nwb.acquisition.set('TwoPhotonSeries', image_series);
            
        end
    end
    
    
    
    
end