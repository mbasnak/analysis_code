%Code to combine data for various bump pars and movement models

clear all; close all;

%% Load data

path = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts';
%Get folder names
folderContents = dir(path);

%Load the summary data of the folder that correspond to experimental flies
for content = 1:length(folderContents)
    
    if contains(folderContents(content).name,'60D05')
        
        %load sessions info
        load(fullfile(folderContents(content).folder,folderContents(content).name,'sessions_info.mat'))
        %get closed-loop sid
        sid = sessions_info.closed_loop;
        
        %load processed data
        fileNames = dir(fullfile(folderContents(content).folder,folderContents(content).name,'analysis'));
        for file = 1:length(fileNames)
            if contains(fileNames(file).name,['continuous_analysis_sid_',num2str(sid),'_tid_0.mat'])
                processed_data(content) = load(fullfile(fileNames(file).folder,fileNames(file).name));
            end
        end
        
        %load raw data
        rawFileNames = dir(fullfile(folderContents(content).folder,folderContents(content).name,'ball'));
        for file = 1:length(fileNames)
            if (contains(rawFileNames(file).name,'bdata_Closed_Loop') & contains(rawFileNames(file).name,['sid_',num2str(sid),'_tid_0.mat']))
                raw_data(content) = load(fullfile(rawFileNames(file).folder,rawFileNames(file).name));
            end
        end
        
        
    end
    
end

%Clear empty cells
processed_data = processed_data(3:end);
raw_data = raw_data(all(~cellfun(@isempty,struct2cell(raw_data))));

%% Extract relevant information from the processed data

all_bump_magnitude = [];
all_bump_width = [];
all_zbump_mag = [];
all_zbump_width = [];
all_gof = [];
all_brightness_level = [];
all_fly_number = [];

for fly = 1:length(processed_data)
    
    bump_magnitude{fly} = processed_data(fly).continuous_data.bump_magnitude;
    bump_width{fly} = processed_data(fly).continuous_data.bump_width;
    zbump_mag{fly} = zscore(bump_magnitude{fly});
    zbump_width{fly} = zscore(bump_width{fly});
    gof{fly} = processed_data(fly).continuous_data.adj_rs;
    
    %get function number
    pos_function = processed_data(fly).continuous_data.run_obj.function_number;
    %determine brightness based on function number
    if pos_function == 195
        brightness = [1,2,1,3,2,3];
    elseif pos_function == 196
        brightness = [2,1,3,1,2,3];
    else
        brightness = [3,1,2,1,2,3];
    end
    %get frames of changes in brightness
    changeBrightness = find(abs(diff(processed_data(fly).continuous_data.fr_y_ds))>1);
    %create brightness vector
    initial_brightness = repelem(brightness(1),changeBrightness(1),1);
    middle_brightness = [];
    for order = 2:length(changeBrightness)
        middle_b = repelem(brightness(order),changeBrightness(order)-changeBrightness(order-1),1);
        middle_brightness = [middle_brightness;middle_b];
    end
    final_brightness = repelem(brightness(1),length(bump_magnitude{fly})-changeBrightness(end),1);
    brightness_level{fly} = [initial_brightness; middle_brightness; final_brightness];
    
    fly_number{fly} = repelem(fly,length(bump_magnitude{fly}),1);
    
    %combine into longer vectors
    all_bump_magnitude = [all_bump_magnitude,bump_magnitude{fly}];
    all_bump_width = [all_bump_width,bump_width{fly}];
    all_zbump_mag = [all_zbump_mag,zbump_mag{fly}];
    all_zbump_width = [all_zbump_width,zbump_width{fly}];
    all_gof = [all_gof,gof{fly}];
    all_brightness_level = [all_brightness_level,brightness_level{fly}'];
    all_fly_number = [all_fly_number,fly_number{fly}'];    
    
end


%% Extract relevant information from the raw data

x_channel = 3;
yaw_channel = 1;
y_channel = 2;

all_x = [];
all_y = [];
all_yaw = [];
all_for_vel = [];
all_side_vel = [];
all_yaw_vel = [];
all_yaw_speed = [];
all_total_movement = [];

for fly = 1:length(raw_data)
    
    % Tranform signal from voltage to radians for unwrapping
    x_pos = raw_data(fly).trial_bdata(:,x_channel).* 2 .* pi ./ 10;
    y_pos = raw_data(fly).trial_bdata(:,y_channel).* 2 .* pi ./ 10;
    yaw_pos = raw_data(fly).trial_bdata(:,yaw_channel).* 2 .* pi ./ 10;
    
    % Unwrap
    unwrapped_x_pos = unwrap(x_pos);
    unwrapped_y_pos = unwrap(y_pos);
    unwrapped_yaw_pos = unwrap(yaw_pos);
    
    % Tranform to deg
    x_pos_deg = rad2deg(unwrapped_x_pos);
    y_pos_deg = rad2deg(unwrapped_y_pos);
    yaw_pos_deg = rad2deg(unwrapped_yaw_pos);
    
    % Downsample the position data to match FicTrac's output
    sampleRate = 4000; %Ni-Daq sampling rate
    downsampled_x_pos = resample(x_pos_deg,25,sampleRate); 
    downsampled_y_pos = resample(y_pos_deg,25,sampleRate);  
    downsampled_yaw_pos = resample(yaw_pos_deg,25,sampleRate);
    
    % Smooth
    smoothed_x_pos = smoothdata(downsampled_x_pos,'rlowess',25); 
    smoothed_y_pos = smoothdata(downsampled_y_pos,'rlowess',25); 
    smoothed_yaw_pos = smoothdata(downsampled_yaw_pos,'rlowess',25);
    
    % Compute the velocity
    vel_for = gradient(smoothed_x_pos).* 25; %we multiply by 25 because we have downsampled to 25 Hz
    vel_side = gradient(smoothed_y_pos).* 25; 
    vel_yaw = gradient(smoothed_yaw_pos).* 25;
    
    % Smooth the velocity (comment out section if necessary)
    vel_for = smoothdata(vel_for,'rlowess',15);
    vel_side = smoothdata(vel_side,'rlowess',15);
    vel_yaw = smoothdata(vel_yaw,'rlowess',15);   
     
    % Downsample the position and velocity data to match the imaging data
    x_pos_deg_ds{fly} = x_pos_deg(round(linspace(1, length(smoothed_x_pos), length(bump_magnitude{fly}))));
    y_pos_deg_ds{fly} = y_pos_deg(round(linspace(1, length(smoothed_y_pos), length(bump_magnitude{fly}))));
    yaw_pos_deg_ds{fly} = yaw_pos_deg(round(linspace(1, length(smoothed_yaw_pos), length(bump_magnitude{fly})))); 
    for_vel_deg{fly} = vel_for(round(linspace(1, length(vel_for), length(bump_magnitude{fly}))));
    side_vel_deg{fly} = vel_side(round(linspace(1, length(vel_side), length(bump_magnitude{fly}))));
    yaw_vel_deg{fly} = vel_yaw(round(linspace(1, length(vel_yaw), length(bump_magnitude{fly})))); 
    yaw_speed_deg{fly} = abs(yaw_vel_deg{fly});
    total_movement{fly} = yaw_speed_deg{fly} + abs(for_vel_deg{fly}) + abs(side_vel_deg{fly});
    
    all_x = [all_x;x_pos_deg_ds{fly}];
    all_y = [all_y;y_pos_deg_ds{fly}];
    all_yaw = [all_yaw;yaw_pos_deg_ds{fly}];   
    all_for_vel = [all_for_vel;for_vel_deg{fly}];
    all_side_vel = [all_side_vel;side_vel_deg{fly}];
    all_yaw_vel = [all_yaw_vel;yaw_vel_deg{fly}];
    all_yaw_speed = [all_yaw_speed;yaw_speed_deg{fly}];
    all_total_movement = [all_total_movement;total_movement{fly}];
    
end

%generate moving variable
moving = zeros(length(all_x),1);
moving(all_total_movement > 20) = 1;

%% Combine all the data in one table

all_movement_model_data = table(all_fly_number',all_brightness_level',all_gof',all_bump_magnitude',all_bump_width',all_zbump_mag',all_zbump_width',all_x,all_y,all_yaw,all_for_vel,all_side_vel,all_yaw_vel,all_yaw_speed,all_total_movement,moving,'VariableNames',{'fly','brightness','gof','bump_mag','bump_width','zbump_mag','zbump_width','x_pos','y_pos','yaw_pos','for_vel','side_vel','yaw_vel','yaw_speed','total_movement','moving'});

%save table for stats
writetable(all_movement_model_data,'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp25\data\Experimental\two_ND_filters_3_contrasts\all_movement_model_data.csv')


%% Clear space

clear all; close all;