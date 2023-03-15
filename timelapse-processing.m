% Image processing of DAX-1 tissue model timelapse images
% DAX-1 Tissue model trial 2 (t02)

% Written by Franz A. Tapia Chaca
% June 10th 2019

%% 0. Load image data
    close all
    clear
    clc
    % Image names: tTTsiteS-channel-Cz1
    TT = 49;            % time points in timelapse
    S = 3;              % number of sites
    % C = 1 or 2        % 2 channels available
    
    I_cell = cell([S TT]);  % Cell array of image files
    t_cell = cell([S TT]);  % Cell array of time stamp in ms
    
    % Load site 1 channel 2 images
    for i = 1:TT
        if i < 10
            % site 1 channel 2
            filename = [cd,'\t02-greyscale\',sprintf('t0%ssite1-channel2z1.tif',num2str(i))];
            I_cell{1,i} = imread(filename);
            t_cell{1,i} = imtime(filename);
            
            % site 2 channel 1
            filename = [cd,'\t02-greyscale\',sprintf('t0%ssite2-channel-1z1.tif',num2str(i))];
            I_cell{2,i} = flip(imread(filename),2);
            t_cell{2,i} = imtime(filename);
            
            % site 3 channel 1
            filename = [cd,'\t02-greyscale\',sprintf('t0%ssite3-channel1z1.tif',num2str(i))];
            I_cell{3,i} = flip(imread(filename),2);
            t_cell{3,i} = imtime(filename);

        else
            % site 1 channel 2
            filename = [cd,'\t02-greyscale\',sprintf('t%ssite1-channel2z1.tif',num2str(i))];
            I_cell{1,i} = imread(filename);
            t_cell{1,i} = imtime(filename);
            
            % site 2 channel 1
            filename = [cd,'\t02-greyscale\',sprintf('t%ssite2-channel-1z1.tif',num2str(i))];
            I_cell{2,i} = flip(imread(filename),2);
            t_cell{2,i} = imtime(filename);
            
            % site 3 channel 1
            filename = [cd,'\t02-greyscale\',sprintf('t%ssite3-channel1z1.tif',num2str(i))];
            I_cell{3,i} = flip(imread(filename),2);
            t_cell{3,i} = imtime(filename);
        end
    end
    
    % t10 is the last time point for all sites when the front doesn't
    %   appear yet
    
    % Site regions
    reg_borders = {964 522; ...
                   948 649; ...
                   905 577};
    
    site_mesh_borders = cell([1 S]);    % site region borders for mesh visualisation
    for i = 1:S % for each site 1-3
        site_reg = zeros(1608,'uint16');
        site_reg(reg_borders{i,1},:) = 16383;
        site_reg(reg_borders{i,2},:) = 16383;
        site_mesh_borders{1,S} = site_reg;
    end

%% 0.5 Display images in 3D
    close all    
    j = 3;  % site (choose 1, 2 or 3)
        figure('units','normalized','outerposition',[0 0 1 1])
            range = [1, 4, 7, 10];
            colormap(jet(2000))
                % Jet = visible spectrum
                % Hot = black red yellow white
                % jet(X), X = number of quanta for entire visicle spectrum
            %site = 3;

            % Border lines

            for i = 1:4
                subplot(2,2,i)
                    mesh(I_cell{j,range(i)},'CDataMapping','direct');
                    hold on
                    mesh(site_mesh_borders{j});
                    xlabel('S axis (px)');              % DAX-1 chip short axis
                    ylabel('L axis (px)');              % DAX-1 chip long axis
                    zlabel('Px intensity (0 - 16383)');
                    zlim([0 16383]);
                    
                    % Time stamp calculation
                    h = fix(t_cell{j,range(i)}/(60*60*1000));
                    m = round(t_cell{j,range(i)}/(60*1000) - 60*h);
                    title(sprintf('%s hours %s minutes', ...
                          num2str(h), ...
                          num2str(m)));
                    colorbar%('LimitsMode','manual','Limits',[0 16383])
                    view(2);
                hold off
            end
            sgtitle(sprintf('t02 site %s',num2str(j)))
    %end
        
%% 1. Intensity along S axis for region for T49
    deltaT = 49; % change to choose a timepoint to plot
    %t_pause = 0.001;
    
    figure('units','normalized','outerposition',[0 0 1 1])
    hold on
        plot(1:1608,I_cell{1,49}(reg_borders{1,2},:),'LineStyle',':','LineWidth',0.1);
        c_int = cat(1,c_int,I_cell{1,49}(reg_borders{1,2}:reg_borders{1,1},:));
            % Cumulative intensity along S axis
        %pause(t_pause);
        
        for j = reg_borders{1,2}+1:reg_borders{1,1}
            plot(1:1608,I_cell{1,49}(j,:),'LineStyle',':','LineWidth',0.1,'Color',[130/255 130/255 130/255]);
                % Plot of I along S axis
            
                % Updating array of cumulative intensity
            %pause(t_pause);
        end
        n_sd = 3;   % Number of standard deviations for plotting
        
        mean_c_int = mean(c_int,1);
        max_c_int = mean_c_int + n_sd*std(double(c_int),0,1);
        %min_c_int = mean_c_int - n_sd*std(double(c_int),0,1);
        
        plot(1:1608,mean_c_int,'LineWidth',2,'Color','black');
            % Average
        plot(1:1608,max_c_int,'LineStyle',':','LineWidth',2.3,'Color','black');
            % Max
        %plot(1:1608,min_c_int,'LineStyle',':','LineWidth',2.3,'Color','black');
            % Min
        xlabel('S axis (px)');
        ylabel('Px intensity (0 - 16383)');
        title('1 Standard deviation');
        grid on
    hold off
    
%% 1.5. Intensity along S axis for region for T1 - T49
    close all
    TT_hydrated = 10;
    c_int_cell = cell([S TT_hydrated]);
    c_int_cell_mean = cell([S TT_hydrated]);
    
    for i = 1:TT_hydrated        % for each time point
        for j = 1:3     % for each site
            c_int_cell{j,i} = I_cell{j,i}(reg_borders{j,2},:);
            c_int_cell{j,i} = cat(1,c_int_cell{j,i},I_cell{j,i}(reg_borders{j,2}+1:reg_borders{j,1},:));
            c_int_cell_mean{j,i} = mean(c_int_cell{j,i},1);
        end       
    end
    
    cm = colormap(jet(10));
    
    % Site 1
    for j = 1:3 % for each site
        figure('units','normalized','outerposition',[0 0 1 1])
        hold on
            for k = 1:TT_hydrated
                plot(1:1608,c_int_cell_mean{j,k},'Color',cm(k,:));
            end
        plot([816 816],[400 2200],'-r');
            % This is for site 1. Need to find location for all sites
        xlabel('S axis (px)');
        ylabel('Px intensity (0 - 16383)');
        ylim([400 1900]);
        title(sprintf('Intensity along S axis (from gel to channel) over time in site %s', num2str(j)));
        colorbar;
        grid on
        hold off
    end

    %% Notes for data processing
    % Each site has its own region - you used the region for site 1 for
    %       site 2 and site 3
    % See if averaging works for all time points
    % What does the averaging and variation of average tell you about
    %       penetration / rate of penetration?
    
    
    
    

    
%{
Minimum and maximum scale limits
min1 = min(reshape(I_cell{3,1},numel(I_cell{3,1}),1));
min2 = min(reshape(I_cell{3,17},numel(I_cell{3,17}),1));
min3 = min(reshape(I_cell{3,33},numel(I_cell{3,33}),1));
min4 = min(reshape(I_cell{3,49},numel(I_cell{3,49}),1));

min_all = min([min1,min2,min3,min4]);

max1 = max(reshape(I_cell{3,1},numel(I_cell{3,1}),1));
max2 = max(reshape(I_cell{3,17},numel(I_cell{3,17}),1));
max3 = max(reshape(I_cell{3,33},numel(I_cell{3,33}),1));
max4 = max(reshape(I_cell{3,49},numel(I_cell{3,49}),1));

max_all = max([max1,max2,max3,max4]);

        %}


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    






