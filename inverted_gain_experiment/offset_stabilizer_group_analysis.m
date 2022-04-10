%group analysis for the offset stabilizer block

clear all; close all;

%% Load data

path = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp28\data\';
%Get folder names
folderContents = dir(path);

%Load the summary data of the folder that correspond to experimental flies
for content = 1:length(folderContents)
   if contains(folderContents(content).name,'60D05')
       data(content) = load([folderContents(content).folder,'\',folderContents(content).name,'\analysis\offset_stabilizer_data.mat']);
   end
end

%% Clean and combine data

%Remove empty rows
data = data(all(~cellfun(@isempty,struct2cell(data))));

% moving = [];
% gof = [];
% offset_precision = [];
% bump_mag = [];
% bump_width = [];
% time = [];
% fly_num = [];
% 
% for fly = 1:length(data)
%    moving = [moving,data(fly).moving];
%    gof = [gof,data(fly).gof];
%    offset_precision = [offset_precision,data(fly).offset_precision'];
%    bump_mag = [bump_mag,data(fly).bump_mag'];
%    bump_width = [bump_width,data(fly).bump_width'];
%    time = [time,data(fly).time'];
%    fly_num = [fly_num,repelem(fly,1,length(data(fly).moving))];      
% end
% %Combine the tables into one
% allData = table(moving,gof,offset_precision,bump_mag,bump_width,time,fly_num,'VariableNames', {'moving','gof','offset_precision','bump_mag','bump_width','time','fly_num'});
% 
% 


%% Plot offset precision and bump parameters

%With all flies
figure,

for fly = 1:length(data)
    
    subplot(3,1,1)
    plot(data(fly).time(data(fly).moving),data(fly).offset_precision)
    hold on
    ylabel('Offset precision');
    
    subplot(3,1,2)
    plot(data(fly).time(data(fly).moving & data(fly).gof),data(fly).bump_mag)
    hold on
    ylabel('Bump magnitude');
    
    subplot(3,1,3)
    plot(data(fly).time(data(fly).moving & data(fly).gof),data(fly).bump_width)
    hold on
    ylabel('Bump width');
    xlabel('Time (sec)');
       
end

%% Plot heading precision

figure,

for fly = 1:length(data)
    
    plot(data(fly).time(data(fly).moving),data(fly).heading_precision)
    hold on
    ylabel('Heading precision');
       
end