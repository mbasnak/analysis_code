%% Code to plot example timepoints for gof

path = 'Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability\20210617_60D05_7f_fly2';
sid = 3;


tid = 0; %I only ever run 1 trial per session

global slash;
if isunix() == 1 %if running in Linux or mac
    slash = '/'; %define the slash this way
else %if running in windows
    slash = '\'; %define the other way
end
set(0,'DefaultTextInterpreter','none');

%% Load the imaging data

%Move to the folder of interest
cd(path)

%Load the roi data 
load(['2p' slash 'ROI' slash 'ROI_midline_sid_' num2str(sid) '_tid_' num2str(tid) '.mat']);
%Load the registered imaging stack
load(['2p' slash 'sid_' num2str(sid) '_tid_' num2str(tid) slash 'rigid_sid_' num2str(sid) '_tid_' num2str(tid) '_Chan_1_sessionFile.mat']);

%% Get the summed GCaMP7f data

%add the data across the z layers making up each volume, to obtain 1 PB image per timepoint
summedData = squeeze(sum(regProduct,3));

%% Get midline coordinates and PB mask

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

%% Get the normal line across each small segment of the PB midline

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

 %%Uncomment to plot the normals and the DF/F for an example timepoint

% figure('Position',[200 50 600 800]);
% subplot(3,1,1)
% plot(midline_coordinates(:,1),midline_coordinates(:,2), 'r');
% hold on
% for segment = 1:length(midline_coordinates)-1
%     plot([midV{segment}(1), midV{segment}(1) + normal1{segment}(1)], [midV{segment}(2), midV{segment}(2) + normal1{segment}(2)], 'b');
%     plot([midV{segment}(1), midV{segment}(1) + normal2{segment}(1)], [midV{segment}(2), midV{segment}(2) + normal2{segment}(2)], 'b');
% end
% title('PB midline and normal segments');

%%% Get the distance to each normal line in an example timepoint

% PB_image = summedData(:,:,3);
% PB_image(PB_coverage == 0) = 0;
% 
% %For each of those locations, find the distance to each normal in the
% %midline
% midline_f = zeros(1,length(midline_coordinates)-1); %start empty midline brightness vector
% 
% for row = 1:size(PB_coverage,1)
%     for column = 1:size(PB_coverage,2)
%         if PB_coverage(row,column) == 1
%             %for every normal to the midline
%             dist_to_midline = zeros(length(normal1),1);
%             for norm_line = 1:length(normal1)
%                 % Get the distance to that normal
%                 dist_to_midline(norm_line) = GetPointLineDistance(column,row,point1{norm_line}(1),point1{norm_line}(2),point2{norm_line}(1),point2{norm_line}(2));
%             end
%             %find the minimum distance
%             [~ , Imin] = min(dist_to_midline);
%             %add intensity value of that pixel to that point in the midline
%             midline_f(Imin) = midline_f(Imin) + PB_image(row,column);
%         end
%     end
% end
% % 
% % Plot
% subplot(3,1,2)
% imagesc(flip(PB_image))
% title('PB activity at example timepoint');
% colormap(gray)
% 
% subplot(3,1,3)
% plot(midline_distances,midline_f)
% title('Fluorescence at example timepoint using midline');
% 
% saveas(gcf,'ExampleTimepoint.png');

%% Assign fluorescence across the PB to the corresponding closest point in the midline

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

%% Get baseline and compute DF/F

%1) Get the baseline fluorescence
baseline_f = zeros(1,length(midline_coordinates)-1);

for segment = 1:length(midline_coordinates)-1
    
    sorted_f = sort(midline_ff(segment,:));
    %Get baseline as the tenth percentile
    baseline_f(segment) = prctile(sorted_f,10);  
    
end

%2) Compute df/f
dff = (midline_ff'-baseline_f)./baseline_f;

%% fit von Mises

%1) Convert the distances along the PB midline to angular distances, taking
%into account that the full length of the PB corresponds to 2pi + (7/8)pi
%in angular distances (since we are grouping the middle glomeruli)
angular_midline_distances = midline_distances*(2*pi + 2*pi*(7/8))/max(midline_distances);
%put back on circle
angular_midline_distances_2pi = mod(angular_midline_distances,2*pi);

%2) Create the fit function
fo = fitoptions('Method','NonlinearLeastSquares',...
    'Lower',[0,-inf,0,-inf],... % [a,c,k,u]
    'StartPoint',[1,0,1,0]);

ft = fittype('a*exp(k*cos(x-u))+c','options',fo);

%random_points = datasample(1:length(dff),10);
random_points = [3494,380,8435];

for timepoint = 1:length(random_points)
    
    %4) Fit the data
    data_to_fit = dff(random_points(timepoint),:);
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
    bump_width(timepoint) = 2 * abs( acos( 1/k * log( 1/2 *( exp(k) + exp(-k) ))));
    %The above math gives you back the bump width in radians. You need a
    %factor conversion to change to EB wedges or tiles
     
    
    %7) Uncomment to plot the original data and the fit
    figure,
    plot(angular_midline_distances,dff(random_points(timepoint),:)','k','linewidth',1.5)
    hold on
    plot(angular_midline_distances,feval(model_data,angular_midline_distances),'color',[.6 .2 .6],'linewidth',1.5)
    xlabel('Angular distance (radians)');
    ylabel('DF/F');
    title(['R2 = ',num2str(gof.adjrsquare,2)]);
    legend('data','fit','location','best');     
    
    data = dff(random_points(timepoint),:);
    fit_data = feval(model_data,angular_midline_distances);
    example_data_fit = table(angular_midline_distances,data',fit_data,'VariableNames',{'distance','data','fit'});
    writetable(example_data_fit,['Z:\Wilson Lab\Mel\Experiments\Uncertainty\Exp35\data\high_reliability\example_data_fit_',num2str(timepoint),'.csv'])
    %saveas(gcf,[path,'\analysis\continuous_plots\example_gof_frame_',num2str(timepoint),'.png'])
    
end