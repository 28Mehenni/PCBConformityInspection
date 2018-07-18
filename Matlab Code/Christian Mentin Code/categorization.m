%==========================================================================
% Image Understanding KU - Bildverstehen KU
% WS 2012/13
% -----------------------------------------
% Project Members: 
% Christian Mentin    0931162
% Florian Hofer       0930287
% Sebastian Lassacher 0930373
% -----------------------------------------
% File:      categorization.m
% Hosted by: Florian Hofer
% Date:      26.01.2013
%==========================================================================

function [] = categorization(BOARD,OUTPUT)
% BOARD  = board name + path (e.g. '..\Beispielbilder\Platine_1.jpg')
% OUTPUT = define whether there should be an output-figure or not. 

disp(['categorization: Start: ',datestr(now)]);
if nargin<2 || isempty(OUTPUT) %Standard Values
    disp('categorization: No OUTPUT param, will proceed with standard values.');
    OUTPUT_INTER = 0;  %Additional output for Intermediate Results
    PRINT_DOC    = 0;  %Additional prints for Documentary
    OUTPUT_HIST  = 0;  %Additional output of color histogram
    PRINT_HIST   = 1;  %Additional print of color histogram
    OUTPUT_STAT  = 1;  %Additional output for Statistic purpose
else
    OUTPUT_INTER = OUTPUT(1);
    PRINT_DOC    = OUTPUT(2);
    OUTPUT_HIST  = OUTPUT(3);
    PRINT_HIST   = OUTPUT(4);
    OUTPUT_STAT  = OUTPUT(5);
end

%BOARD = '..\Beispielbilder\Platine_1.jpg';
       %'..\Beispielbilder\Platine_1.jpg';
       %'..\Beispielbilder\Platine_1_ausschnitt_3.jpg';
       %'..\Beispielbilder\Platine_5.jpg';
       %'..\Beispielbilder\Platine_6.jpg';
       %'..\Beispielbilder\Platine_9.jpg';
%THRESHOLD = 0.1; % Start-Threshold
           %0.1;  %für Platine_1.jpg      % Threshold for Color Deletion
           %0.06; %für Platine_5.jpg
           %0.07; %für Platine_6.jpg
           %0.01; %für Platine_7-1.jpg    % Nevertheless worse result
           %0.07; %für Platine_9.jpg
%THRESHOLD_ADAPT = 1; %Adaptive Threshold

BARS = 30; % Histogram Bars for Color Histogram (0 = no scaling, very slow)
           
%--------------------------------------------------------------------------
% Load Input Image & Get Interest Points
BOARD_PATH = BOARD;
BOARD = regexp(BOARD,'\','split');
BOARD = BOARD{3};
BOARD = regexp(BOARD,'.jpg','split');
BOARD = BOARD{1};
file = sprintf('categorization_memory_%s.mat',BOARD);
if(exist(file,'file')) % Load existing data if it exists
    I_input = im2double(imread(BOARD_PATH));
    load(file);
    fprintf('Load: 100%%\n');
else   
    I_input =  im2double(imread(BOARD_PATH));
    x_size = size(I_input,2);
    y_size = size(I_input,1);
    %fprintf('Load:  10%%');
    [I_find,I_blob] = scale_space_conversion(I_input);
    %search for SOIC_08 style Parts
    Element_of_Interest =  rgb2gray(imread('..\Beispielbilder\EOI\SOIC_8.png'));
    [SOIC08_found, new_Input_Image] = find_matches( I_find, Element_of_Interest, 1, 0.01, 'plot_OFF' );
    elements_found = SOIC08_found;
    %fprintf(repmat('\b',1,10)); fprintf('Load:  40%%');
    %search for 0805 style Parts
    Element_of_Interest =  rgb2gray(imread('..\Beispielbilder\EOI\rectangle_style0805_withpads.png'));
    [rect_0805_found, new_Input_Image2] = find_matches( new_Input_Image, Element_of_Interest, 3, 0.0075, 'plot_OFF' );
    elements_found = elements_found + rect_0805_found;
    %fprintf(repmat('\b',1,10)); fprintf('Load:  70%%');
    % %search for 0603 style Parts
    Element_of_Interest =  rgb2gray(imread('..\Beispielbilder\EOI\rectangle_style0603_withpads_2.png'));
    [rect_0603_found, new_Input_Image3] = find_matches( new_Input_Image2, Element_of_Interest, 5, 0.05, 'plot_OFF' );
    elements_found = elements_found + rect_0603_found;
    %fprintf(repmat('\b',1,10)); 
    fprintf('Load: 100%%\n');
    save(file,'elements_found','x_size','y_size','I_blob');
end

%--------------------------------------------------------------------------
% Get coordinates and prognosticated type of objects
i = 1;
for x=1:x_size;
    for y=1:y_size;
        if (elements_found(y,x) > 0) && (elements_found(y,x)>=3)         
            x_pos(i) = x;
            y_pos(i) = y;
            align(i) = elements_found(y,x);
            i = i + 1;
        end
    end
end
fprintf('Cath:  10%%');
f = figure('visible','on');
imshow(I_input); hold on; %title('Original picture');
plot(x_pos,y_pos,'d','Marker','s','MarkerFaceColor','r','Markersize',3,'MarkerEdgeColor','none');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 12 4]);
if(PRINT_DOC)
    print(f,'-dpng','results/categorization_01.png');
end
name = sprintf('results/categorization_%s_original.png',BOARD);
print(f,'-dpng',name);

%--------------------------------------------------------------------------
% Create color histogram
red   = reshape(I_input(:,:,1),x_size*y_size,1);
green = reshape(I_input(:,:,2),x_size*y_size,1);
blue  = reshape(I_input(:,:,3),x_size*y_size,1);

res = 256;
colors = (red.*(res-1)).*(res*res)+(green.*(res-1))*res+(blue.*(res-1));
[c,first] = unique(colors,'first');
[c,last ] = unique(colors,'last');
amplitude = last-first;

[amplitude,index] = sort(amplitude);
c = c(index);
index = floor(length(c)*0.1);
groundcolors = sort(c(index:end));
r = groundcolors./(res*res*res);
g = mod(groundcolors,res*res)./res;
b = mod(groundcolors,res);
% 90% of all ground colors saved - efficient way to set these colors to
% black in board?

if OUTPUT_HIST || PRINT_HIST
    if BARS > 0
        j=1; % Mean value of colors to get only 30 bars
        SIZE = floor(length(colors)/BARS);
        for i=1:SIZE:length(colors)-SIZE;
            r(j)   = mean(red(i:i+SIZE));
            g(j)   = mean(green(i:i+SIZE));
            b(j)   = mean(blue(i:i+SIZE));
            j = j+1;
        end

        j=1; % Mean value of amplitudes to get only 30 bars
        SIZE = floor(length(amplitude)/BARS);
        for i=1:SIZE:length(amplitude)-SIZE;
            amp(j) = mean(amplitude(i:i+SIZE));
            j = j+1;
        end

        [amplitude,index] = sort(amp);
        red   = r(index);
        green = g(index);
        blue  = b(index);
        
        red = max(0,min(1,red));
        green = max(0,min(1,green));
        blue = max(0,min(1,blue));
        
        if OUTPUT_HIST
            f = figure('visible','on');
        else
            f = figure('visible','off');
        end
        for i=1:BARS
            b = bar(BARS-i,amplitude(i)); hold on;
            set(b,'facecolor',[red(i) green(i) blue(i)]);
        end
        xlim([-1 BARS]); title('Color Histogram'); 
        xlabel('Mean Color Values');
        ylabel('Number of Pixels');
    else
        [amplitude,index] = sort(amplitude);
        c = c(index);
        red   = c./(res*res*res);
        green = mod(c,res*res)./res;
        blue  = mod(c,res);
        
        red = max(0,min(1,red));
        green = max(0,min(1,green));
        blue = max(0,min(1,blue));
        
        if OUTPUT_HIST
            f = figure('visible','on');
        else
            f = figure('visible','off');
        end
        for i=1:length(amplitude)
            b = bar(amplitude(i)); hold on;
            set(b,'facecolor',[red(i) green(i) blue(i)]);
        end
        %title('Color Histogram'); 
        xlabel('Mean Color Values');
        ylabel('Number of Pixels');
    end
    if PRINT_HIST
        set(gcf,'PaperUnits','inches','PaperPosition',[0 0 12 4])
        name = sprintf('results/categorization_%s_colorhistogram.png',BOARD);
        print(f,'-dpng',name);
    end
end

%--------------------------------------------------------------------------
% Delete any kind of color (board color should vanish):
% FUNCTION OBSOLETE - IS DONE BY SCALE_SPACE_CONVERSION
%{
Input_Image = double(I_input);
I1 = Input_Image(:,:,1);
I2 = Input_Image(:,:,2);
I3 = Input_Image(:,:,3);
thresh = THRESHOLD;
ratio_black = 0;
while(ratio_black < 0.47)
    Input_Image_mean = (I1 + I2 + I3)/3;
    I1(abs(Input_Image(:,:,1) - Input_Image_mean)>thresh) = 0;
    I2(abs(Input_Image(:,:,2) - Input_Image_mean)>thresh) = 0;
    I3(abs(Input_Image(:,:,3) - Input_Image_mean)>thresh) = 0;
    I = I1.*I2.*I3; %Colored spaces > threshold are set to Black
    I(I > 0) = 1;   %A little bit colored spaces = White
    number_white = nnz(I);
    number_all   = x_size*y_size;
    if THRESHOLD_ADAPT
        ratio_black = (number_all - number_white)/number_all;
        if(ratio_black < 0.47)
            if thresh == 0.005
                break;
            end
            thresh = thresh - 0.005;
        end
    else
        ratio_black = 1;
    end
end
if thresh ~= THRESHOLD
    fprintf('\n      New Threshold: %f          \nCath:  70%%',thresh);
else
    fprintf(repmat('\b',1,10)); fprintf('Cath:  70%%');
end

Input_Image(:,:,1) = I .* Input_Image(:,:,1);
Input_Image(:,:,2) = I .* Input_Image(:,:,2);
Input_Image(:,:,3) = I .* Input_Image(:,:,3); %White spaces = Input_image
I_gray = rgb2gray(Input_Image);

if(PRINT_DOC || OUTPUT_INTER)
    if(OUTPUT_INTER)
        f = figure('visible','on');
    else
        f = figure('visible','off');
    end
    imshow(I_gray); title('Original without colors'); hold on
    plot(x_pos,y_pos,'d','Marker','s','MarkerFaceColor','r','Markersize',3,'MarkerEdgeColor','none');
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 12 4])
    if(PRINT_DOC)
        print(f,'-dpng','results/categorization_02.png');
    end
end
I_blob = I_gray;
%}

%--------------------------------------------------------------------------
% The actual categorization:
object = zeros(length(x_pos),10); % Object vector [type,align check passed,rect1,rect2]
for i=1:length(x_pos); 
    if OUTPUT_INTER
        figure;
        disp('----------------------------------------------');
        fprintf('categorization:          Object at (%4d %4d)\n',x_pos(i),y_size - y_pos(i));
    end
    if align(i) == 3 || align(i) == 4
        add1 = 20; %20
        add2 = 35; %35
    elseif align(i) == 5 || align(i) == 6
        add1 = 15; %15
        add2 = 30; %30
    end
    add3 = 2;
        
    for mask=1:2;
        %------------------------------------------------------------------
        % Cut out a small piece around the possibly detected object:
        switch(mask)
            case 1
                I_object = I_blob((max(1,y_pos(i)-add1):min(y_size,y_pos(i)+add1)),(max(1,x_pos(i)-add2):min(x_size,x_pos(i)+add2)),:);
            case 2
                I_object = I_blob((max(1,y_pos(i)-add2):min(y_size,y_pos(i)+add2)),(max(1,x_pos(i)-add1):min(x_size,x_pos(i)+add1)),:);
        end
        I_object_rgb = I_input((max(1,y_pos(i)-add3):min(y_size,y_pos(i)+add3)),(max(1,x_pos(i)-add3):min(x_size,x_pos(i)+add3)),:);
        if OUTPUT_INTER
            subplot(2,6,1+(mask-1)*6); imshow(I_object); title('Cutted image of object');
        end
        x_size_obj = size(I_object,2);
        y_size_obj = size(I_object,1);

        %------------------------------------------------------------------
        % Erode in order to delete large noise (e.g. 2x2 pixel)
        for erode=1:7; %3
            form_element = [0 1 0 ; 1 1 1 ; 0 1 0];
            I_object = imerode(I_object,form_element);
            if OUTPUT_INTER
                subplot(2,6,2+(mask-1)*6); imshow(I_object); title('Eroded (no noise)');
            end
        end

        %------------------------------------------------------------------
        % Get largest available rectangle around object
        index_min = find(I_object > 0,1,'first');
        index_max = find(I_object > 0,1,'last');
        x_min = ceil(index_min/y_size_obj);
        x_max = ceil(index_max/y_size_obj);

        index_min = find(I_object' > 0,1,'first');
        index_max = find(I_object' > 0,1,'last');
        y_min = ceil(index_min/x_size_obj);
        y_max = ceil(index_max/x_size_obj);

        x_length = x_max - x_min;
        y_length = y_max - y_min;
        if OUTPUT_INTER
            subplot(2,6,3+(mask-1)*6); imshow(I_object); title('Borders'); hold on;
            rectangle('Position',[x_min y_min x_length y_length],'LineWidth',2, 'EdgeColor','r');
        end
        
        switch(mask)
            case 1
                x_min_safe = x_pos(i)-add2+x_min;
                y_min_safe = y_pos(i)-add1+y_min;
            case 2
                x_min_safe = x_pos(i)-add1+x_min;
                y_min_safe = y_pos(i)-add2+y_min;
        end
        
        % Check whether size of the rectangle got zero!
        if(size(x_length) == [0 1])
            x_length = 1;
        end
        if(size(y_length) == [0 1])
            y_length = 1;
        end
        x_length = max(x_length,1);
        y_length = max(y_length,1);

        if(size(x_min_safe) == [0 1])
            x_min_safe = 1;
        end
        if(size(y_min_safe) == [0 1])
            y_min_safe = 1;
        end
        if(size(x_min) == [0 1])
            x_min = 1;
        end
        if(size(y_min) == [0 1])
            y_min = 1;
        end
        
        object(i,(3+4*(mask-1)):(2+4*mask)) = [x_min_safe y_min_safe x_length y_length];
        
        %------------------------------------------------------------------
        % Smooth image
        %filter = fspecial('gaussian',[5 5],7);
        %I_object = imfilter(I_object_rgb,filter,'replicate');
        if OUTPUT_INTER
            subplot(2,6,5+(mask-1)*6); imshow(I_object_rgb); title('Cropped image in color');
        end

        %------------------------------------------------------------------
        % Get Color of blob in the center
        center_color = [sum(sum(I_object_rgb(:,:,1)))/25 sum(sum(I_object_rgb(:,:,2)))/25 sum(sum(I_object_rgb(:,:,3)))/25];
        center_color_mean = mean(center_color(1:2));
        thresh = 0.02;
        if center_color(3) < center_color_mean - thresh
            capacitor = 1; % Color
        else
            capacitor = 0;
        end

        %------------------------------------------------------------------
        % Check if it is a resistor/capacitor or chip
        if x_min == 1 || y_min == 1 || x_max == x_size_obj || y_max == y_size_obj
            %Possible chip - is set after loop
        else
            if capacitor
                object(i,1) = 2; %Possible capacitor
                if OUTPUT_INTER
                    disp('categorization: [ok]     Possible Capacitor.');
                end
            else
                object(i,1) = 1; %Possible resistor
                if OUTPUT_INTER
                    disp('categorization: [ok]     Possible Resistor.');
                end
            end
            % Alignment check
            if (((y_length>x_length)&&((align(i)==4)||(align(i)==6)))||...
               ((x_length>y_length)&&((align(i)==3)||(align(i)==5))))
                object(i,2) = 1; % check ok
                if OUTPUT_INTER
                    disp('categorization: [ok]     Alignment check.');  
                end
            elseif OUTPUT_INTER
                disp('categorization: [FAILED] Alignment check.');
            end
        end
    end
    if ~object(i,1)
        object(i,1) = 3; % Possible chip
        if OUTPUT_INTER
            disp('categorization: [ok]     Possible Chip.');
        end
    end
end
if OUTPUT_INTER
    fprintf('Cath: 100%%\n');
else
    fprintf(repmat('\b',1,10)); fprintf('Cath: 100%%\n');
end

%--------------------------------------------------------------------------
% Plot Results
f = figure('visible','on');
imshow(I_blob); title('Results'); hold on
x_pos_print = x_pos;
for i=1:length(x_pos);
    if object(i,1) == 1
        switch align(i)
            case 3
                rectangle('Position',[object(i,3:6)],'LineWidth',2, 'EdgeColor','r');
                x_pos_print(i) = x_pos_print(i)+31;
            case 4
                rectangle('Position',[object(i,7:10)],'LineWidth',2, 'EdgeColor','r');
                x_pos_print(i) = x_pos_print(i)+13;
            case 5
                rectangle('Position',[object(i,3:6)],'LineWidth',2, 'EdgeColor','r');
                x_pos_print(i) = x_pos_print(i)+24;
            case 6
                rectangle('Position',[object(i,7:10)],'LineWidth',2, 'EdgeColor','r');
                x_pos_print(i) = x_pos_print(i)+8;
        end
        hold on;
        text(x_pos_print(i),y_pos(i),'\color{red}R');
    elseif object(i,1) == 2
        switch align(i)
            case 3
                rectangle('Position',[object(i,3:6)],'LineWidth',2, 'EdgeColor','y');
                x_pos_print(i) = x_pos_print(i)+31;
            case 4
                rectangle('Position',[object(i,7:10)],'LineWidth',2, 'EdgeColor','y');
                x_pos_print(i) = x_pos_print(i)+13;
            case 5
                rectangle('Position',[object(i,3:6)],'LineWidth',2, 'EdgeColor','y');
                x_pos_print(i) = x_pos_print(i)+24;
            case 6
                rectangle('Position',[object(i,7:10)],'LineWidth',2, 'EdgeColor','y');
                x_pos_print(i) = x_pos_print(i)+8;
        end
        hold on;
        text(x_pos_print(i),y_pos(i),'\color{yellow}C');
    elseif object(i,1) == 3
        x_pos_print(i) = max(0,x_pos_print(i)-7);
        text(x_pos_print(i),y_pos(i),'\color{green}Undef');
    else
        text(x_pos_print(i),y_pos(i),'\color{blue}ERROR');
    end
    hold on;
end

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 12 4])
if PRINT_DOC
    print(f,'-dpng','results/categorization_11.png');
    name = sprintf('results/categorization_%s_result.png',BOARD);
    print(f,'-dpng',name);
else
    name = sprintf('results/categorization_%s_result.png',BOARD);
    print(f,'-dpng',name);
end

if OUTPUT_STAT
    f = figure('visible','on');
    imshow(I_input); title('Results'); hold on
    x_pos_print = x_pos;
    for i=1:length(x_pos);
        if object(i,1) == 1
            switch align(i)
                case 3
                    rectangle('Position',[object(i,3:6)],'LineWidth',2, 'EdgeColor','r');
                    x_pos_print(i) = x_pos_print(i)+31;
                case 4
                    rectangle('Position',[object(i,7:10)],'LineWidth',2, 'EdgeColor','r');
                    x_pos_print(i) = x_pos_print(i)+13;
                case 5
                    rectangle('Position',[object(i,3:6)],'LineWidth',2, 'EdgeColor','r');
                    x_pos_print(i) = x_pos_print(i)+24;
                case 6
                    rectangle('Position',[object(i,7:10)],'LineWidth',2, 'EdgeColor','r');
                    x_pos_print(i) = x_pos_print(i)+8;
            end
            hold on;
            text(x_pos_print(i),y_pos(i),'\color{red}R');
        elseif object(i,1) == 2
            switch align(i)
                case 3
                    rectangle('Position',[object(i,3:6)],'LineWidth',2, 'EdgeColor','y');
                    x_pos_print(i) = x_pos_print(i)+31;
                case 4
                    rectangle('Position',[object(i,7:10)],'LineWidth',2, 'EdgeColor','y');
                    x_pos_print(i) = x_pos_print(i)+13;
                case 5
                    rectangle('Position',[object(i,3:6)],'LineWidth',2, 'EdgeColor','y');
                    x_pos_print(i) = x_pos_print(i)+24;
                case 6
                    rectangle('Position',[object(i,7:10)],'LineWidth',2, 'EdgeColor','y');
                    x_pos_print(i) = x_pos_print(i)+8;
            end
            hold on;
            text(x_pos_print(i),y_pos(i),'\color{yellow}C');
        elseif object(i,1) == 3
            x_pos_print(i) = max(0,x_pos_print(i)-7);
            %text(x_pos_print(i),y_pos(i),'\color{green}Undef');
        else
            text(x_pos_print(i),y_pos(i),'\color{blue}ERROR');
        end
        hold on;
    end
end
fprintf('Plot: 100%%\n');

%--------------------------------------------------------------------------
% For Documentary:
if PRINT_DOC
    % Cut around object
    I_print_mask1 = ones(size(I_blob));
    I_print_mask2 = ones(size(I_blob));
    I_print_color = zeros(size(I_input));
    for i=1:length(x_pos); 
        if align(i) == 3 || align(i) == 4
            add1 = 20;
            add2 = 35;
        elseif align(i) == 5 || align(i) == 6
            add1 = 15;
            add2 = 30;
        end
        add3 = 2;

        for mask=1:2;
            switch(mask)
                case 1
                    I_print_mask1((max(1,y_pos(i)-add1):min(y_size,y_pos(i)+add1)),(max(1,x_pos(i)-add2):min(x_size,x_pos(i)+add2)),:) = I_blob((max(1,y_pos(i)-add1):min(y_size,y_pos(i)+add1)),(max(1,x_pos(i)-add2):min(x_size,x_pos(i)+add2)),:);
                case 2
                    I_print_mask2((max(1,y_pos(i)-add2):min(y_size,y_pos(i)+add2)),(max(1,x_pos(i)-add1):min(x_size,x_pos(i)+add1)),:) = I_blob((max(1,y_pos(i)-add2):min(y_size,y_pos(i)+add2)),(max(1,x_pos(i)-add1):min(x_size,x_pos(i)+add1)),:);
            end
            I_print_color((max(1,y_pos(i)-add3):min(y_size,y_pos(i)+add3)),(max(1,x_pos(i)-add3):min(x_size,x_pos(i)+add3)),:) = I_input((max(1,y_pos(i)-add3):min(y_size,y_pos(i)+add3)),(max(1,x_pos(i)-add3):min(x_size,x_pos(i)+add3)),:);
        end
    end
    f = figure('visible','off'); imshow(I_print_mask1); title('Cutted Objects x-direction'); 
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 12 4])
    print(f,'-dpng','results/categorization_03.png');
    f = figure('visible','off'); imshow(I_print_mask2); title('Cutted Objects y-direction'); 
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 12 4])
    print(f,'-dpng','results/categorization_04.png');

    % Erode in order to delete large noise (e.g. 2x2 pixel)
    for erode=1:3;
        form_element = [0 1 0 ; 1 1 1 ; 0 1 0];
        I_print_mask1 = imerode(I_print_mask1,form_element);
        I_print_mask2 = imerode(I_print_mask2,form_element);
    end
    f = figure('visible','off'); imshow(I_print_mask1); title('Eroded Objects x-direction');
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 12 4])
    print(f,'-dpng','results/categorization_05.png');
    f = figure('visible','off'); imshow(I_print_mask2); title('Eroded Objects y-direction');
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 12 4])
    print(f,'-dpng','results/categorization_06.png');

    % Get largest available rectangle around object x_dir
    SUBPRINT = 1;
    for i=1:length(x_pos); 
        if align(i) == 3 || align(i) == 4
            add1 = 20;
            add2 = 35;
        elseif align(i) == 5 || align(i) == 6
            add1 = 15;
            add2 = 30;
        end

        I_object = I_blob((max(1,y_pos(i)-add1):min(y_size,y_pos(i)+add1)),(max(1,x_pos(i)-add2):min(x_size,x_pos(i)+add2)),:);
        x_size_obj = size(I_object,2);
        y_size_obj = size(I_object,1);

        for erode=1:3;
            form_element = [0 1 0 ; 1 1 1 ; 0 1 0];
            I_object = imerode(I_object,form_element);
        end

        index_min = find(I_object > 0,1,'first');
        index_max = find(I_object > 0,1,'last');
        x_min = ceil(index_min/y_size_obj);
        x_max = ceil(index_max/y_size_obj);

        index_min = find(I_object' > 0,1,'first');
        index_max = find(I_object' > 0,1,'last');
        y_min = ceil(index_min/x_size_obj);
        y_max = ceil(index_max/x_size_obj);

        x_length = x_max - x_min;
        y_length = y_max - y_min;

        if SUBPRINT
            f = figure('visible','off'); 
            imshow(I_print_mask1); title('Rectangle x-direction');
            SUBPRINT = 0;
        end
        x_min2 = x_min + max(1,x_pos(i)-add2);
        y_min2 = y_min + max(1,y_pos(i)-add1);
        hold on; rectangle('Position',[x_min2 y_min2 x_length y_length],'LineWidth',2, 'EdgeColor','r');
    end
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 12 4])
    print(f,'-dpng','results/categorization_07.png');

    % Get largest available rectangle around object y_dir
    SUBPRINT = 1;
    for i=1:length(x_pos); 
        if OUTPUT_INTER
            figure;
            disp('----------------------------------------------');
            fprintf('categorization:          Object at (%4d %4d)\n',x_pos(i),y_size - y_pos(i));
        end
        if align(i) == 3 || align(i) == 4
            add1 = 20;
            add2 = 35;
        elseif align(i) == 5 || align(i) == 6
            add1 = 15;
            add2 = 30;
        end

        I_object = I_blob((max(1,y_pos(i)-add2):min(y_size,y_pos(i)+add2)),(max(1,x_pos(i)-add1):min(x_size,x_pos(i)+add1)),:);
        x_size_obj = size(I_object,2);
        y_size_obj = size(I_object,1);

        for erode=1:3;
            form_element = [0 1 0 ; 1 1 1 ; 0 1 0];
            I_object = imerode(I_object,form_element);
        end

        index_min = find(I_object > 0,1,'first');
        index_max = find(I_object > 0,1,'last');
        x_min = ceil(index_min/y_size_obj);
        x_max = ceil(index_max/y_size_obj);

        index_min = find(I_object' > 0,1,'first');
        index_max = find(I_object' > 0,1,'last');
        y_min = ceil(index_min/x_size_obj);
        y_max = ceil(index_max/x_size_obj);

        x_length = x_max - x_min;
        y_length = y_max - y_min;

        if SUBPRINT
            f = figure('visible','off'); 
            imshow(I_print_mask2); title('Rectangle y-direction');
            SUBPRINT = 0;
        end
        x_min2 = x_min + max(1,x_pos(i)-add1);
        y_min2 = y_min + max(1,y_pos(i)-add2);
        hold on; rectangle('Position',[x_min2 y_min2 x_length y_length],'LineWidth',2, 'EdgeColor','r');
    end
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 12 4])
    print(f,'-dpng','results/categorization_08.png');
    
    % Color image
    f = figure('visible','off'); imshow(I_print_color); title('Color patch');
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 12 4])
    print(f,'-dpng','results/categorization_09.png');

    % Smooth image
    filter = fspecial('gaussian',[5 5],7);
    I_print_color = imfilter(I_print_color,filter,'replicate');
    f = figure('visible','off'); 
    imshow(I_print_color); title('Color patch (Gauss Filtered)');
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 12 4])
    print(f,'-dpng','results/categorization_10.png');
end
disp(['categorization: End:   ',datestr(now)]);