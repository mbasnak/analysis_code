% Code to plot polarhistograms of offset for cue combination experiments

clear all; close all;

%% Load data

path = 'Z:\wilsonlab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability';

folderContents = dir(path);

for content = 1:length(folderContents)
   if contains(folderContents(content).name,'60D05')
       data(content) = load([folderContents(content).folder,'\',folderContents(content).name,'\analysis\data.mat']);
   end
end

%Remove empty rows
data = data(all(~cellfun(@isempty,struct2cell(data))));

%% Combine all data

offset_precision = [];
offset_mean = [];
configuration = [];

for fly = 1:length(data)
    
    offset_precision = [offset_precision;data(fly).offset_precision];    
    offset_mean = [offset_mean;data(fly).offset_mean];
    configuration(fly) = data(fly).configuration;

end

%% Plot coloring by cue identity

figure('Position',[100 100 1400 600]),
for fly = 1:length(data)
    
    subplot(3,6,fly)
    if configuration(fly) == 1
        polarplot([offset_mean(fly,1),offset_mean(fly,1)],[0,offset_precision(fly,1)],'b','linewidth',4)
        hold on
        polarplot([offset_mean(fly,2),offset_mean(fly,2)],[0,offset_precision(fly,2)],'k','linewidth',4)
    else
        polarplot([offset_mean(fly,1),offset_mean(fly,1)],[0,offset_precision(fly,1)],'k','linewidth',4)
        hold on
        polarplot([offset_mean(fly,2),offset_mean(fly,2)],[0,offset_precision(fly,2)],'b','linewidth',4)
    end
    polarplot([offset_mean(fly,3),offset_mean(fly,3)],[0,offset_precision(fly,3)],'color',[.5 .5 .5],'linewidth',4)    
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    rlim([0 1])
    rticklabels({});
    rticks([]);
    thetaticklabels({});
    thetaticks([0,90,180,270]);    
    ax = gca;
    ax.FontSize = 20;
end

%saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\ExtraFigures\cc_offset_polarhistograms_by_cue_type.svg')

%% Plot coloring by cue order

figure('Position',[100 100 1400 600]),
for fly = 1:length(data)
    
    subplot(3,6,fly)
    polarplot([offset_mean(fly,1),offset_mean(fly,1)],[0,offset_precision(fly,1)],'color',[.8 .3 .1],'linewidth',4)
    hold on
    polarplot([offset_mean(fly,2),offset_mean(fly,2)],[0,offset_precision(fly,2)],'color',[.2 .5 .8],'linewidth',4)
    polarplot([offset_mean(fly,3),offset_mean(fly,3)],[0,offset_precision(fly,3)],'color',[.5 .5 .5],'linewidth',4)
    set(gca,'ThetaZeroLocation','top',...
        'ThetaDir','clockwise');
    rlim([0 1])
    rticklabels({});
    rticks([]);
    thetaticklabels({});
    thetaticks([0,90,180,270]);    
    ax = gca;
    ax.FontSize = 20;
end

%saveas(gcf,'C:\Users\Melanie\Dropbox (HMS)\Manuscript-Basnak\Figures\ExtraFigures\cc_offset_polarhistograms_by_cue_order.svg')
