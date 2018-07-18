function varargout = PCBINspection(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PCBINspection_OpeningFcn, ...
                   'gui_OutputFcn',  @PCBINspection_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before PCBINspection is made visible.
function PCBINspection_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
t=imread('C:\Users\Maestro\Desktop\Rédaction\Chapitres\LOGO.jpg');
axes(handles.axes2);
imshow(t);

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = PCBINspection_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

%MaximizeFigureWindow;
%===========================================================================================================================

% create an axes that spans the whole gui
ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
% import the background image and show it on the axes
bg = imread('background10.jpg'); imagesc(bg);
% prevent plotting over the background and turn the axis off
set(ah,'handlevisibility','off','visible','off')
% making sure the background is behind all the other uicontrols
uistack(ah, 'bottom');

%===========================================================================================================================

function pb_loadimages_Callback(hObject, eventdata, handles)

folder_dir = uigetdir;
% file_lists_dir(folder_name);
file_lists= dir(fullfile(folder_dir,'*.jpg'));

for iter1 = 1: size(file_lists,1)
    new_line{iter1} = file_lists(iter1).name;
end

initial_name=cellstr(get(handles.listbox1,'String'));
new_name = [initial_name  new_line];
new_name = [new_line];
set(handles.listbox1,'String',new_name);

handles.folder_dir = folder_dir;
guidata(hObject, handles);

%===========================================================================================================================

function listbox1_Callback(hObject, eventdata, handles)

full_list = cellstr(get(handles.listbox1,'String'));
sel_val=get(handles.listbox1,'value');
sel_item=full_list(sel_val);
sel_item_full_name = fullfile(handles.folder_dir,sel_item);
handles = guidata(hObject);
handles.img = imread(sel_item_full_name{1});
img = handles.img;
axes(handles.axes1),imshow(img);
guidata(hObject, handles);

%===========================================================================================================================
function listbox1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================================================================================================================

function popupmenu1_Callback(hObject, eventdata, handles)
val = get(handles.popupmenu1,'value');

%==========================================================================================================================
function popupmenu1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================================================================================================================
% --- Executes on button press in ButtonInspection.
function ButtonInspection_Callback(hObject, eventdata, handles)
index = get(handles.listbox1,'value'); 
allFilenames = get(handles.listbox1,'String'); 
filename = allFilenames{index};
rgbImage = imread(filename);
if ndims(rgbImage) == 3
    
    popupmenu4value = get(handles.popupmenu1,'Value');
    switch popupmenu4value
      case 2
        %ref = imread('Ty.jpg');
        ref = imread('PCB_test1.jpg');
        %ref = imread('PCBcuivre.jpg');
      case 3
        ref = imread('PCB_test3.jpg');
      case 4
        ref = imread('ZZnexcus.jpg');
        %ref = imread('PCB_test3.jpg');
      case 5
        ref = imread('crackingZ4.jpg');
    end
    handles = guidata(hObject);
    % handles.redChannel = correctgeo(rgbImage,ref);
%     [handles.redChannel , handles.coord, handles.mybox, handles.points] = funcoord2(rgbImage,ref);
%     redChannel=handles.redChannel;
%     coord=handles.coord;
%     points=handles.points;
%     %
%     mybox=handles.mybox;
    % Update handles structure
    guidata(hObject, handles);
    axes(handles.axes2);
    if popupmenu4value == 4
    %%%%%%%%%%%%%%%%%%%%%
     [handles.redChannel , handles.coord, handles.mybox, handles.points] = funcoord2(rgbImage,ref);
    redChannel=handles.redChannel;
    coord=handles.coord;
    points=handles.points;
    %
    mybox=handles.mybox;
    % Update handles structure
    guidata(hObject, handles);
    %%%%%%%%%%%%%%%%%%%%%
    handles.pointMis = rectan(redChannel, mybox);
    pointMis=handles.pointMis;
    imshow(pointMis);
    handles.pointMis=pointMis;
    handles.coord=coord;
    handles.mybox=mybox;
    guidata(hObject, handles);
    hold on
%--------------------------------------------------------------------------
coordCAP0802 = [175 154 415 231 451 231];
coordCAP0603 = [144 164 259 164 246 55 246 27];
coordRES0603 = [42 30 42 56 42 82 42 108 42 134 78 164 118 164 206 164 234 164 246 82 330 161 367 171 444 171 468 171 252 347 12 342];
coordCAP0912 = [328 228 159 361];
coordComp1 = [145 65];

nbcap0603=0;
nbcap0802=0;
nbres0603=0;
nbcap0912=0;
nbcomp1=0;
for j=1:2:length(coord)
max1=100000;
max2=100000;  
max3=100000;
max4=100000;
max5=100000;

k=0;l=0;m=0;

    for i=1:2:length(coordCAP0802)
        X = [coord(j),coord(j+1);coordCAP0802(i),coordCAP0802(i+1)];
        d1 = pdist(X,'euclidean');
        if d1<max1
            max1=d1;
            k=i;
        end
    end
    for i=1:2:length(coordCAP0603)
        Y = [coord(j),coord(j+1);coordCAP0603(i),coordCAP0603(i+1)];
        d2 = pdist(Y,'euclidean'); 
        if d2<max2
            max2=d2;
            l=i;
        end  
    end
    for i=1:2:length(coordRES0603)
        Z = [coord(j),coord(j+1);coordRES0603(i),coordRES0603(i+1)];
        d3 = abs(pdist(Z,'euclidean'));
        if d3<max3
            max3=d3;
            m=i;
        end  
    end
    for i=1:2:length(coordCAP0912)
        V = [coord(j),coord(j+1);coordCAP0912(i),coordCAP0912(i+1)];
        d4 = abs(pdist(V,'euclidean'));
        if d4<max4
            max4=d4;
            n=i;
        end  
    end
    for i=1:2:length(coordComp1)
        U = [coord(j),coord(j+1);coordComp1(i),coordComp1(i+1)];
        d5 = abs(pdist(U,'euclidean'));
        if d5<max5
            max5=d5;
            r=i;
        end  
    end
    
    if (max1<max2 && max1<max3 && max1<max4 && max1<max5)
            plot(coordCAP0802(k),coordCAP0802(k+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordCAP0802(k),coordCAP0802(k+1),'\color{yellow}Cap0802');
            nbcap0802=nbcap0802+1;
    elseif (max2<max1 && max2<max3 && max2<max4 && max2<max5)
            plot(coordCAP0603(l),coordCAP0603(l+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordCAP0603(l),coordCAP0603(l+1),'\color{yellow}Cap0603');
            nbcap0603=nbcap0603+1;
    elseif((max3<max1 && max3<max2 && max3<max4 && max3<max5))
            plot(coordRES0603(m),coordRES0603(m+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordRES0603(m),coordRES0603(m+1),'\color{yellow}Res');
            nbres0603=nbres0603+1;
    elseif ((max4<max1 && max4<max2 && max4<max3 && max4<max5))
            plot(coordCAP0912(n),coordCAP0912(n+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordCAP0912(n),coordCAP0912(n+1),'\color{yellow}Cap0912');
            nbcap0912=nbcap0912+1;
    elseif ((max5<max1 && max5<max2 && max5<max3 && max5<max4))
            plot(coordComp1(r),coordComp1(r+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordComp1(r),coordComp1(r+1),'\color{yellow}Comp1');
            nbcomp1=nbcomp1+1;
        
    end
end
    set (handles.edit2,'String',num2str(points));
    set (handles.edit3,'String',num2str(nbres0603));
    set (handles.edit4,'String',num2str(nbcap0603));
    set (handles.edit5,'String',num2str(nbcap0802));
    set (handles.edit6,'String',num2str(nbcap0912));
    set (handles.edit7,'String',num2str(nbcomp1));
    hold (handles.axes2,'off');
%-----------------------------------------------------------------------------------------------------------------
    elseif popupmenu4value == 2
        
    %%%%%%%%%
    [handles.redChannel , handles.coord, handles.mybox, handles.points] = funcoord3(rgbImage,ref);
    redChannel=handles.redChannel;
    coord=handles.coord;
    points=handles.points;
    %
    mybox=handles.mybox;
    % Update handles structure
    % guidata(hObject, handles); poke
    %%%%%%%%%
    set (handles.edit2,'String',num2str(points));
    set (handles.edit3,'String','number');
    set (handles.edit4,'String','number');
    set (handles.edit5,'String','number');
    set (handles.edit6,'String','number');
    set (handles.edit7,'String','number');
    handles.pointMis = rectan(redChannel, mybox);
    %
    pointMis=handles.pointMis;
    guidata(hObject, handles);
    imshow(pointMis);
    elseif popupmenu4value == 3
    %%%%%
    [handles.redChannel , handles.coord, handles.mybox, handles.points] = funcoord2(rgbImage,ref);
    redChannel=handles.redChannel;
    coord=handles.coord;
    points=handles.points;
    %
    mybox=handles.mybox;
    % Update handles structure
    guidata(hObject, handles);
    %%%%%
     handles.pointMis = rectan(redChannel, mybox);
    pointMis=handles.pointMis;
    imshow(pointMis);
    handles.pointMis=pointMis;
    handles.coord=coord;
    handles.mybox=mybox;
    guidata(hObject, handles);
    hold on
%--------------------------------------------------------------------------
coordCAP0802 = [1276 1118];
coordCAP0603 = [299 219 290 350 688 671 342 929 460 922 634 932 215 1124 284 1258 923 1063 902 1137];
coordRES0603 = [230 309 230 345 373 42 906 142 559 642 558 645 688 640 562 829 562 860 562 890 710 898 710 958 720 1042 782 1042 752 1098 680 1185 680 1216 954 288 1002 282 1061 274 1061 304 1118 270 1118 333 1118 364 1118 396 1118 422 1131 479 1131 530 1100 530 1118 570 1118 618 1118 652 1118 682 1114 840 1114 870 1114 902 1152 928 996 929 923 985 923 1097 923 1182 923 1213 1209 937 1238 937 1270 937 1287 982 1317 922 1347 922 1391 922 1433 940 1600 932 1630 932 1702 924 1776 931 1808 930 1858 890 1850 839 1880 839 1853 508 1848 293];
coordCAP0912 = [348 832 464 856 263 1020 232 1170];
coordComp1 = [972 462 915 339 956 339 995 339 1035 339 918 578 958 578 997 578 1037 578];
%
coordDiode0603 = [908 298 932 1137 1155 958 1432 905 1602 989 1661 932 1745 932 1879 786 1850 784 1860 741 1860 710 1858 678 1858 650 ];
coordDiode0805 = [267 934 1250 1185];
coordInductance0603 = [562 922 711 927 688 1039 722 1097];
coordSot23 = [1397 1023];
%

nbcap0603=0;
nbcap0802=0;
nbres0603=0;
nbcap0912=0;
nbcomp1=0;
%
nbdiode0603=0;
nbdiode0805=0;
nbinductance0603=0;
nbsot23=0;
%
for j=1:2:length(coord)
max1=100000;
max2=100000;  
max3=100000;
max4=100000;
max5=100000;
%
max6=100000;
max7=100000;
max8=100000;
max9=100000;
%
k=0;l=0;m=0;

    for i=1:2:length(coordCAP0802)
        X = [coord(j),coord(j+1);coordCAP0802(i),coordCAP0802(i+1)];
        d1 = pdist(X,'euclidean');
        if d1<max1
            max1=d1;
            k=i;
        end
    end
    for i=1:2:length(coordCAP0603)
        Y = [coord(j),coord(j+1);coordCAP0603(i),coordCAP0603(i+1)];
        d2 = pdist(Y,'euclidean'); 
        if d2<max2
            max2=d2;
            l=i;
        end  
    end
    for i=1:2:length(coordRES0603)
        Z = [coord(j),coord(j+1);coordRES0603(i),coordRES0603(i+1)];
        d3 = abs(pdist(Z,'euclidean'));
        if d3<max3
            max3=d3;
            m=i;
        end  
    end
    for i=1:2:length(coordCAP0912)
        V = [coord(j),coord(j+1);coordCAP0912(i),coordCAP0912(i+1)];
        d4 = abs(pdist(V,'euclidean'));
        if d4<max4
            max4=d4;
            n=i;
        end  
    end
    for i=1:2:length(coordComp1)
        U = [coord(j),coord(j+1);coordComp1(i),coordComp1(i+1)];
        d5 = abs(pdist(U,'euclidean'));
        if d5<max5
            max5=d5;
            r=i;
        end  
    end
    %
    for i=1:2:length(coordDiode0603)
        U = [coord(j),coord(j+1);coordDiode0603(i),coordDiode0603(i+1)];
        d6 = abs(pdist(U,'euclidean'));
        if d6<max6
            max6=d6;
            p=i;
        end  
    end
    for i=1:2:length(coordInductance0603)
        U = [coord(j),coord(j+1);coordInductance0603(i),coordInductance0603(i+1)];
        d7 = abs(pdist(U,'euclidean'));
        if d7<max7
            max7=d7;
            s=i;
        end  
    end
    for i=1:2:length(coordDiode0805)
        U = [coord(j),coord(j+1);coordDiode0805(i),coordDiode0805(i+1)];
        d8 = abs(pdist(U,'euclidean'));
        if d8<max8
            max8=d8;
            y=i;
        end  
    end
    for i=1:2:length(coordSot23)
        U = [coord(j),coord(j+1);coordSot23(i),coordSot23(i+1)];
        d9 = abs(pdist(U,'euclidean'));
        if d9<max9
            max9=d9;
            x=i;
        end  
    end
    %
    
    if (max1<max2 && max1<max3 && max1<max4 && max1<max5 && max1<max6 && max1<max7 && max1<max8 && max1<max9)
            plot(coordCAP0802(k),coordCAP0802(k+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordCAP0802(k),coordCAP0802(k+1),'\color{yellow}Cap0802');
            nbcap0802=nbcap0802+1;
    elseif (max2<max1 && max2<max3 && max2<max4 && max2<max5 && max2<max6 && max2<max7 && max2<max8 && max2<max9)
            plot(coordCAP0603(l),coordCAP0603(l+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordCAP0603(l),coordCAP0603(l+1),'\color{yellow}Cap0603');
            nbcap0603=nbcap0603+1;
    elseif((max3<max1 && max3<max2 && max3<max4 && max3<max5 && max3<max6 && max3<max7 && max3<max8 && max3<max9))
            plot(coordRES0603(m),coordRES0603(m+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordRES0603(m),coordRES0603(m+1),'\color{yellow}Res');
            nbres0603=nbres0603+1;
    elseif ((max4<max1 && max4<max2 && max4<max3 && max4<max5&& max4<max6 && max4<max7 && max4<max8 && max4<max9) )
            plot(coordCAP0912(n),coordCAP0912(n+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordCAP0912(n),coordCAP0912(n+1),'\color{yellow}Cap0912');
            nbcap0912=nbcap0912+1;
    elseif ((max5<max1 && max5<max2 && max5<max3 && max5<max4 && max5<max6 && max5<max7 && max5<max8 && max5<max9))
            plot(coordComp1(r),coordComp1(r+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordComp1(r),coordComp1(r+1),'\color{yellow}Comp1');
            nbcomp1=nbcomp1+1;
    elseif ((max6<max1 && max6<max2 && max6<max3 && max6<max4 && max6<max5 && max6<max7 && max6<max8 && max6<max9))
            plot(coordDiode0603(p),coordDiode0603(p+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordDiode0603(p),coordDiode0603(p+1),'\color{yellow}Diode0603');
            nbdiode0603=nbdiode0603+1;
    elseif ((max7<max1 && max7<max2 && max7<max3 && max7<max4 && max7<max5 && max7<max6 && max7<max8 && max7<max9  ))
            plot(coordInductance0603(s),coordInductance0603(s+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordInductance0603(s),coordInductance0603(s+1),'\color{yellow}Inductance0603');
            nbinductance0603=nbinductance0603+1;
    elseif ((max8<max1 && max8<max2 && max8<max3 && max8<max4 && max8<max5 && max8<max6 && max8<max7 && max8<max9))
            plot(coordDiode0805(y),coordDiode0805(y+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordDiode0805(y),coordDiode0805(y+1),'\color{yellow}Diode0805');
            nbdiode0805=nbdiode0805+1;
     elseif ((max9<max1 && max9<max2 && max9<max3 && max9<max4 && max9<max5 && max9<max6 && max9<max7 && max9<max8))
            plot(coordSot23(x),coordSot23(x+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordSot23(x),coordSot23(x+1),'\color{yellow}Sot23');
            nbsot23=nbsot23+1;
        
    end
end
    set (handles.edit2,'String',num2str(points));
    set (handles.edit3,'String',num2str(nbres0603));
    set (handles.edit4,'String',num2str(nbcap0603));
    set (handles.edit5,'String',num2str(nbcap0802));
    set (handles.edit6,'String',num2str(nbcap0912));
    set (handles.edit7,'String',num2str(nbcomp1));
    set (handles.edit11,'String',num2str(nbinductance0603));
    set (handles.edit12,'String',num2str(nbdiode0603));
    set (handles.edit13,'String',num2str(nbsot23));
    hold (handles.axes2,'off');
    
    %%%%%%%%%08062018
    elseif popupmenu4value == 5
    [handles.redChannel , handles.coord, handles.mybox, handles.points] = funcoord2(rgbImage,ref);
    redChannel=handles.redChannel;
    coord=handles.coord;
    points=handles.points;
    %
    mybox=handles.mybox;
    % Update handles structure
    %%%%%%%%%
%     set (handles.edit2,'String',num2str(points));
%     set (handles.edit3,'String','number');
%     set (handles.edit4,'String','number');
%     set (handles.edit5,'String','number');
%     set (handles.edit6,'String','number');
%     set (handles.edit7,'String','number');
    handles.pointMis = rectan(redChannel, mybox);
    
    %
    pointMis=handles.pointMis;
    guidata(hObject, handles);
    imshow(pointMis);
    hold on 
    %%%%%%%%-------------------------------------------------data base
    coordCAP0802 = [538 137 824 164 795 368 870 481 866 519 438 548 432 445 432 402];
    coordCAP0603 = [440 480 440 510];
    coordRES0603 = [422 170 448 88 477 88 504 88 532 90 558 90 583 90 636 90 661 90 778 90 802 90 793 200 793 428 988 384 998 531 702 558 674 558 622 565 606 611 568 611 536 580 496 586];
    coordCAP0912 = [894 144 ];
    coordComp1 = [728 496 620 496  510 496 510 396 510 270 616 270 740 270 740 935 624 395];
%
    coordDiode0805 = [738 180 ];
    coordDiode0912 = [738 180 ];
    coordDiode12 = [956 136 ];
    coordInductance0805 = [836 105 845 598];
    coordRES0805 = [695 102 734 102 846 560 786 557 746 580 ];
    
    %%
    nbcap0603=0;
    nbcap0802=0;
    nbres0603=0;
    nbcap0912=0;
    nbcomp1=0;
%
    nbdiode0603=0;
    nbdiode0805=0;
    nbdiode12=0;
    nbinductance0805=0;
    nbres0805 =0;
    %%
    %% boucle popupmenu=5
    for j=1:2:length(coord)
max1=100000;
max2=100000;  
max3=100000;
max4=100000;
max5=100000;
%
max6=100000;
max7=100000;
max8=100000;
max9=100000;
%
k=0;l=0;m=0;

    for i=1:2:length(coordCAP0802)
        X = [coord(j),coord(j+1);coordCAP0802(i),coordCAP0802(i+1)];
        d1 = pdist(X,'euclidean');
        if d1<max1
            max1=d1;
            k=i;
        end
    end
    for i=1:2:length(coordCAP0603)
        Y = [coord(j),coord(j+1);coordCAP0603(i),coordCAP0603(i+1)];
        d2 = pdist(Y,'euclidean'); 
        if d2<max2
            max2=d2;
            l=i;
        end  
    end
    for i=1:2:length(coordRES0603)
        Z = [coord(j),coord(j+1);coordRES0603(i),coordRES0603(i+1)];
        d3 = abs(pdist(Z,'euclidean'));
        if d3<max3
            max3=d3;
            m=i;
        end  
    end
    for i=1:2:length(coordCAP0912)
        V = [coord(j),coord(j+1);coordCAP0912(i),coordCAP0912(i+1)];
        d4 = abs(pdist(V,'euclidean'));
        if d4<max4
            max4=d4;
            n=i;
        end  
    end
    for i=1:2:length(coordComp1)
        U = [coord(j),coord(j+1);coordComp1(i),coordComp1(i+1)];
        d5 = abs(pdist(U,'euclidean'));
        if d5<max5
            max5=d5;
            r=i;
        end  
    end
    %
    for i=1:2:length(coordDiode0805)
        U = [coord(j),coord(j+1);coordDiode0805(i),coordDiode0805(i+1)];
        d6 = abs(pdist(U,'euclidean'));
        if d6<max6
            max6=d6;
            p=i;
        end  
    end
    for i=1:2:length(coordDiode12)
        U = [coord(j),coord(j+1);coordDiode12(i),coordDiode12(i+1)];
        d7 = abs(pdist(U,'euclidean'));
        if d7<max7
            max7=d7;
            s=i;
        end  
    end
    for i=1:2:length(coordDiode0805)
        U = [coord(j),coord(j+1);coordDiode0805(i),coordDiode0805(i+1)];
        d8 = abs(pdist(U,'euclidean'));
        if d8<max8
            max8=d8;
            y=i;
        end  
    end
    %
    
    if (max1<max2 && max1<max3 && max1<max4 && max1<max5 && max1<max6 && max1<max7 && max1<max8 && max1<max9)
            plot(coordCAP0802(k),coordCAP0802(k+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordCAP0802(k),coordCAP0802(k+1),'\color{yellow}Cap0802');
            nbcap0802=nbcap0802+1;
    elseif (max2<max1 && max2<max3 && max2<max4 && max2<max5 && max2<max6 && max2<max7 && max2<max8 && max2<max9)
            plot(coordCAP0603(l),coordCAP0603(l+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordCAP0603(l),coordCAP0603(l+1),'\color{yellow}Cap0603');
            nbcap0603=nbcap0603+1;
    elseif((max3<max1 && max3<max2 && max3<max4 && max3<max5 && max3<max6 && max3<max7 && max3<max8 && max3<max9))
            plot(coordRES0603(m),coordRES0603(m+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordRES0603(m),coordRES0603(m+1),'\color{yellow}Res');
            nbres0603=nbres0603+1;
    elseif ((max4<max1 && max4<max2 && max4<max3 && max4<max5&& max4<max6 && max4<max7 && max4<max8 && max4<max9) )
            plot(coordCAP0912(n),coordCAP0912(n+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordCAP0912(n),coordCAP0912(n+1),'\color{yellow}Cap0912');
            nbcap0912=nbcap0912+1;
    elseif ((max5<max1 && max5<max2 && max5<max3 && max5<max4 && max5<max6 && max5<max7 && max5<max8 && max5<max9))
            plot(coordComp1(r),coordComp1(r+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordComp1(r),coordComp1(r+1),'\color{yellow}Comp1');
            nbcomp1=nbcomp1+1;
    elseif ((max6<max1 && max6<max2 && max6<max3 && max6<max4 && max6<max5 && max6<max7 && max6<max8 && max6<max9))
            plot(coordDiode0603(p),coordDiode0603(p+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordDiode0603(p),coordDiode0603(p+1),'\color{yellow}Diode0603');
            nbdiode0603=nbdiode0603+1;
    elseif ((max7<max1 && max7<max2 && max7<max3 && max7<max4 && max7<max5 && max7<max6 && max7<max8 && max7<max9  ))
            plot(coordDiode12(s),coordDiode120603(s+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordDiode12(s),coordDiode12(s+1),'\color{yellow}Inductance0603');
            nbdiode12=nbdiode12+1;
    elseif ((max8<max1 && max8<max2 && max8<max3 && max8<max4 && max8<max5 && max8<max6 && max8<max7 && max8<max9))
            plot(coordDiode0805(y),coordDiode0805(y+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordDiode0805(y),coordDiode0805(y+1),'\color{yellow}Diode0805');
            nbdiode0805=nbdiode0805+1;
     elseif ((max9<max1 && max9<max2 && max9<max3 && max9<max4 && max9<max5 && max9<max6 && max9<max7 && max9<max8))
            plot(coordRES0805(x),coordRES0805(x+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordRES0805(x),coordRES0805(x+1),'\color{yellow}Sot23');
            nb0805=nbres0805+1;
        
    end
    end
     set (handles.edit2,'String',num2str(points));
    set (handles.edit3,'String',num2str(nbres0603));
    set (handles.edit4,'String',num2str(nbcap0603));
    set (handles.edit5,'String',num2str(nbcap0802));
    set (handles.edit6,'String',num2str(nbcap0912));
    set (handles.edit7,'String',num2str(nbcomp1));
    set (handles.edit11,'String',num2str(nbdiode12));
    set (handles.edit12,'String',num2str(nbdiode0603));
    set (handles.edit15,'String',num2str(nbres0805));
    hold (handles.axes2,'off');
    %%
    %%%%%%%%%-------------------------------------------------
    else
    imshow(redChannel);
    plot(400,400,'Marker','s','MarkerFaceColor','g','Markersize',8,'MarkerEdgeColor','none');
    end
    
else
    message = sprintf('%s is not an RGB image', filename);
    uiwait(warndlg(message));
end
return
%==========================================================================================================================
% --- Executes on button press in ButtonCamera.
% function ButtonCamera_Callback(hObject, eventdata, handles)
% closereq;
% % call the script which open the playgame gui
% ipcam3( );

%==========================================================================================================================
function ButtonOpen_Callback(hObject, eventdata, handles)
%axes(handles.axes1),figure,imshow(handles.img);
guidata(hObject, handles);


function ButtonOpen2_Callback(hObject, eventdata, handles)
%axes(handles.axes2),figure,imshow(handles.redChannel);

menu4value = get(handles.popupmenu1,'Value');

if menu4value == 4
pointMis=handles.pointMis;
coord=handles.coord;
axes(handles.axes2),figure,imshow(pointMis);
hold on
coordCAP0802 = [175 154 415 231 451 231];
coordCAP0603 = [144 164 259 164 246 55 246 27];
coordRES0603 = [42 30 42 56 42 82 42 108 42 134 78 164 118 164 206 164 234 164 246 82 330 161 367 171 444 171 468 171 252 347 12 342];
coordCAP0912 = [328 228 159 361];
coordComp1 = [145 65];

nbcap0603=0;
nbcap0802=0;
nbres0603=0;
nbcap0912=0;
nbcomp1=0;
for j=1:2:length(coord)
max1=100000;
max2=100000;  
max3=100000;
max4=100000;
max5=100000;

k=0;l=0;m=0;

    for i=1:2:length(coordCAP0802)
        X = [coord(j),coord(j+1);coordCAP0802(i),coordCAP0802(i+1)];
        d1 = pdist(X,'euclidean');
        if d1<max1
            max1=d1;
            k=i;
        end
    end
    for i=1:2:length(coordCAP0603)
        Y = [coord(j),coord(j+1);coordCAP0603(i),coordCAP0603(i+1)];
        d2 = pdist(Y,'euclidean'); 
        if d2<max2
            max2=d2;
            l=i;
        end  
    end
    for i=1:2:length(coordRES0603)
        Z = [coord(j),coord(j+1);coordRES0603(i),coordRES0603(i+1)];
        d3 = abs(pdist(Z,'euclidean'));
        if d3<max3
            max3=d3;
            m=i;
        end  
    end
    for i=1:2:length(coordCAP0912)
        V = [coord(j),coord(j+1);coordCAP0912(i),coordCAP0912(i+1)];
        d4 = abs(pdist(V,'euclidean'));
        if d4<max4
            max4=d4;
            n=i;
        end  
    end
    for i=1:2:length(coordComp1)
        U = [coord(j),coord(j+1);coordComp1(i),coordComp1(i+1)];
        d5 = abs(pdist(U,'euclidean'));
        if d5<max5
            max5=d5;
            r=i;
        end  
    end
    
    if (max1<max2 && max1<max3 && max1<max4 && max1<max5)
            plot(coordCAP0802(k),coordCAP0802(k+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordCAP0802(k),coordCAP0802(k+1),'\color{yellow}Cap0802');
            nbcap0802=nbcap0802+1;
    elseif (max2<max1 && max2<max3 && max2<max4 && max2<max5)
            plot(coordCAP0603(l),coordCAP0603(l+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordCAP0603(l),coordCAP0603(l+1),'\color{yellow}Cap0603');
            nbcap0603=nbcap0603+1;
    elseif((max3<max1 && max3<max2 && max3<max4 && max3<max5))
            plot(coordRES0603(m),coordRES0603(m+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordRES0603(m),coordRES0603(m+1),'\color{yellow}Res');
            nbres0603=nbres0603+1;
    elseif ((max4<max1 && max4<max2 && max4<max3 && max4<max5))
            plot(coordCAP0912(n),coordCAP0912(n+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordCAP0912(n),coordCAP0912(n+1),'\color{yellow}Cap0912');
            nbcap0912=nbcap0912+1;
    elseif ((max5<max1 && max5<max2 && max5<max3 && max5<max4))
            plot(coordComp1(r),coordComp1(r+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordComp1(r),coordComp1(r+1),'\color{yellow}Comp1');
            nbcomp1=nbcomp1+1;
        
    end
end
elseif menu4value == 5
    pointMis=handles.pointMis;
    coord=handles.coord;
    guidata(hObject, handles);
    %points=handles.points;
    %
   % mybox=handles.mybox;
    % Update handles structure
    guidata(hObject, handles);
    %%%%%%%%%

    %handles.pointMis = rectan(redChannel, mybox);
    %
    
    axes(handles.axes2),figure,imshow(pointMis);
    hold on 
    %%%%%%%%-------------------------------------------------data base
    coordCAP0802 = [538 137 824 164 795 368 870 481 866 519 438 548 432 445 432 402];
    coordCAP0603 = [440 480 440 510];
    coordRES0603 = [422 170 448 88 477 88 504 88 532 90 558 90 583 90 636 90 661 90 778 90 802 90 793 200 793 428 988 384 998 531 702 558 674 558 622 565 606 611 568 611 536 580 496 586];
    coordCAP0912 = [894 144 ];
    coordComp1 = [728 496 620 496  510 496 510 396 510 270 616 270 740 270 740 935 624 395];
%
    coordDiode0805 = [738 180 ];
    coordDiode0912 = [738 180 ];
    coordDiode12 = [956 136 ];
    coordInductance0805 = [836 105 845 598];
    coordRES0805 = [695 102 734 102 846 560 786 557 746 580 ];
    
    %%
    nbcap0603=0;
    nbcap0802=0;
    nbres0603=0;
    nbcap0912=0;
    nbcomp1=0;
%
    nbdiode0603=0;
    nbdiode0805=0;
    nbdiode12=0;
    nbinductance0805=0;
    nbres0805 =0;
    %%
    %% boucle popupmenu=5
    for j=1:2:length(coord)
max1=100000;
max2=100000;  
max3=100000;
max4=100000;
max5=100000;
%
max6=100000;
max7=100000;
max8=100000;
max9=100000;
%
k=0;l=0;m=0;

    for i=1:2:length(coordCAP0802)
        X = [coord(j),coord(j+1);coordCAP0802(i),coordCAP0802(i+1)];
        d1 = pdist(X,'euclidean');
        if d1<max1
            max1=d1;
            k=i;
        end
    end
    for i=1:2:length(coordCAP0603)
        Y = [coord(j),coord(j+1);coordCAP0603(i),coordCAP0603(i+1)];
        d2 = pdist(Y,'euclidean'); 
        if d2<max2
            max2=d2;
            l=i;
        end  
    end
    for i=1:2:length(coordRES0603)
        Z = [coord(j),coord(j+1);coordRES0603(i),coordRES0603(i+1)];
        d3 = abs(pdist(Z,'euclidean'));
        if d3<max3
            max3=d3;
            m=i;
        end  
    end
    for i=1:2:length(coordCAP0912)
        V = [coord(j),coord(j+1);coordCAP0912(i),coordCAP0912(i+1)];
        d4 = abs(pdist(V,'euclidean'));
        if d4<max4
            max4=d4;
            n=i;
        end  
    end
    for i=1:2:length(coordComp1)
        U = [coord(j),coord(j+1);coordComp1(i),coordComp1(i+1)];
        d5 = abs(pdist(U,'euclidean'));
        if d5<max5
            max5=d5;
            r=i;
        end  
    end
    %
    for i=1:2:length(coordDiode0805)
        U = [coord(j),coord(j+1);coordDiode0805(i),coordDiode0805(i+1)];
        d6 = abs(pdist(U,'euclidean'));
        if d6<max6
            max6=d6;
            p=i;
        end  
    end
    for i=1:2:length(coordDiode12)
        U = [coord(j),coord(j+1);coordDiode12(i),coordDiode12(i+1)];
        d7 = abs(pdist(U,'euclidean'));
        if d7<max7
            max7=d7;
            s=i;
        end  
    end
    for i=1:2:length(coordDiode0805)
        U = [coord(j),coord(j+1);coordDiode0805(i),coordDiode0805(i+1)];
        d8 = abs(pdist(U,'euclidean'));
        if d8<max8
            max8=d8;
            y=i;
        end  
    end
    %
    
    if (max1<max2 && max1<max3 && max1<max4 && max1<max5 && max1<max6 && max1<max7 && max1<max8 && max1<max9)
            plot(coordCAP0802(k),coordCAP0802(k+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordCAP0802(k),coordCAP0802(k+1),'\color{yellow}Cap0802');
            nbcap0802=nbcap0802+1;
    elseif (max2<max1 && max2<max3 && max2<max4 && max2<max5 && max2<max6 && max2<max7 && max2<max8 && max2<max9)
            plot(coordCAP0603(l),coordCAP0603(l+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordCAP0603(l),coordCAP0603(l+1),'\color{yellow}Cap0603');
            nbcap0603=nbcap0603+1;
    elseif((max3<max1 && max3<max2 && max3<max4 && max3<max5 && max3<max6 && max3<max7 && max3<max8 && max3<max9))
            plot(coordRES0603(m),coordRES0603(m+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordRES0603(m),coordRES0603(m+1),'\color{yellow}Res');
            nbres0603=nbres0603+1;
    elseif ((max4<max1 && max4<max2 && max4<max3 && max4<max5&& max4<max6 && max4<max7 && max4<max8 && max4<max9) )
            plot(coordCAP0912(n),coordCAP0912(n+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordCAP0912(n),coordCAP0912(n+1),'\color{yellow}Cap0912');
            nbcap0912=nbcap0912+1;
    elseif ((max5<max1 && max5<max2 && max5<max3 && max5<max4 && max5<max6 && max5<max7 && max5<max8 && max5<max9))
            plot(coordComp1(r),coordComp1(r+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordComp1(r),coordComp1(r+1),'\color{yellow}Comp1');
            nbcomp1=nbcomp1+1;
    elseif ((max6<max1 && max6<max2 && max6<max3 && max6<max4 && max6<max5 && max6<max7 && max6<max8 && max6<max9))
            plot(coordDiode0603(p),coordDiode0603(p+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordDiode0603(p),coordDiode0603(p+1),'\color{yellow}Diode0603');
            nbdiode0603=nbdiode0603+1;
    elseif ((max7<max1 && max7<max2 && max7<max3 && max7<max4 && max7<max5 && max7<max6 && max7<max8 && max7<max9  ))
            plot(coordDiode12(s),coordDiode120603(s+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordDiode12(s),coordDiode12(s+1),'\color{yellow}Inductance0603');
            nbdiode12=nbdiode12+1;
    elseif ((max8<max1 && max8<max2 && max8<max3 && max8<max4 && max8<max5 && max8<max6 && max8<max7 && max8<max9))
            plot(coordDiode0805(y),coordDiode0805(y+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordDiode0805(y),coordDiode0805(y+1),'\color{yellow}Diode0805');
            nbdiode0805=nbdiode0805+1;
     elseif ((max9<max1 && max9<max2 && max9<max3 && max9<max4 && max9<max5 && max9<max6 && max9<max7 && max9<max8))
            plot(coordRES0805(x),coordRES0805(x+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordRES0805(x),coordRES0805(x+1),'\color{yellow}Sot23');
            nb0805=nbres0805+1;
        
    end
    end
elseif menu4value == 2
    pointMis=handles.pointMis;
    coord=handles.coord;
    guidata(hObject, handles);
    %points=handles.points;
    %
    % mybox=handles.mybox;
    % Update handles structure
    %
    
    axes(handles.axes2),figure,imshow(pointMis);

elseif menu4value == 3
    coord=handles.coord;
    points=handles.points;
    %
    
    mybox=handles.mybox;
    % Update handles structure
    axes(handles.axes2),figure,imshow(handles.pointMis);

    hold on
%--------------------------------------------------------------------------
coordCAP0802 = [1276 1118];
coordCAP0603 = [299 219 290 350 688 671 342 929 460 922 634 932 215 1124 284 1258 923 1063 902 1137];
coordRES0603 = [230 309 230 345 373 42 906 142 559 642 558 645 688 640 562 829 562 860 562 890 710 898 710 958 720 1042 782 1042 752 1098 680 1185 680 1216 954 288 1002 282 1061 274 1061 304 1118 270 1118 333 1118 364 1118 396 1118 422 1131 479 1131 530 1100 530 1118 570 1118 618 1118 652 1118 682 1114 840 1114 870 1114 902 1152 928 996 929 923 985 923 1097 923 1182 923 1213 1209 937 1238 937 1270 937 1287 982 1317 922 1347 922 1391 922 1433 940 1600 932 1630 932 1702 924 1776 931 1808 930 1858 890 1850 839 1880 839 1853 508 1848 293];
coordCAP0912 = [348 832 464 856 263 1020 232 1170];
coordComp1 = [972 462 915 339 956 339 995 339 1035 339 918 578 958 578 997 578 1037 578];
%
coordDiode0603 = [908 298 932 1137 1155 958 1432 905 1602 989 1661 932 1745 932 1879 786 1850 784 1860 741 1860 710 1858 678 1858 650 ];
coordDiode0805 = [267 934 1250 1185];
coordInductance0603 = [562 922 711 927 688 1039 722 1097];
coordSot23 = [1397 1023];
%

nbcap0603=0;
nbcap0802=0;
nbres0603=0;
nbcap0912=0;
nbcomp1=0;
%
nbdiode0603=0;
nbdiode0805=0;
nbinductance0603=0;
nbsot23=0;
%
for j=1:2:length(coord)
max1=100000;
max2=100000;  
max3=100000;
max4=100000;
max5=100000;
%
max6=100000;
max7=100000;
max8=100000;
max9=100000;
%
k=0;l=0;m=0;

    for i=1:2:length(coordCAP0802)
        X = [coord(j),coord(j+1);coordCAP0802(i),coordCAP0802(i+1)];
        d1 = pdist(X,'euclidean');
        if d1<max1
            max1=d1;
            k=i;
        end
    end
    for i=1:2:length(coordCAP0603)
        Y = [coord(j),coord(j+1);coordCAP0603(i),coordCAP0603(i+1)];
        d2 = pdist(Y,'euclidean'); 
        if d2<max2
            max2=d2;
            l=i;
        end  
    end
    for i=1:2:length(coordRES0603)
        Z = [coord(j),coord(j+1);coordRES0603(i),coordRES0603(i+1)];
        d3 = abs(pdist(Z,'euclidean'));
        if d3<max3
            max3=d3;
            m=i;
        end  
    end
    for i=1:2:length(coordCAP0912)
        V = [coord(j),coord(j+1);coordCAP0912(i),coordCAP0912(i+1)];
        d4 = abs(pdist(V,'euclidean'));
        if d4<max4
            max4=d4;
            n=i;
        end  
    end
    for i=1:2:length(coordComp1)
        U = [coord(j),coord(j+1);coordComp1(i),coordComp1(i+1)];
        d5 = abs(pdist(U,'euclidean'));
        if d5<max5
            max5=d5;
            r=i;
        end  
    end
    %
    for i=1:2:length(coordDiode0603)
        U = [coord(j),coord(j+1);coordDiode0603(i),coordDiode0603(i+1)];
        d6 = abs(pdist(U,'euclidean'));
        if d6<max6
            max6=d6;
            p=i;
        end  
    end
    for i=1:2:length(coordInductance0603)
        U = [coord(j),coord(j+1);coordInductance0603(i),coordInductance0603(i+1)];
        d7 = abs(pdist(U,'euclidean'));
        if d7<max7
            max7=d7;
            s=i;
        end  
    end
    for i=1:2:length(coordDiode0805)
        U = [coord(j),coord(j+1);coordDiode0805(i),coordDiode0805(i+1)];
        d8 = abs(pdist(U,'euclidean'));
        if d8<max8
            max8=d8;
            y=i;
        end  
    end
    for i=1:2:length(coordSot23)
        U = [coord(j),coord(j+1);coordSot23(i),coordSot23(i+1)];
        d9 = abs(pdist(U,'euclidean'));
        if d9<max9
            max9=d9;
            x=i;
        end  
    end
    %
    
    if (max1<max2 && max1<max3 && max1<max4 && max1<max5 && max1<max6 && max1<max7 && max1<max8 && max1<max9)
            plot(coordCAP0802(k),coordCAP0802(k+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordCAP0802(k),coordCAP0802(k+1),'\color{yellow}Cap0802');
            nbcap0802=nbcap0802+1;
    elseif (max2<max1 && max2<max3 && max2<max4 && max2<max5 && max2<max6 && max2<max7 && max2<max8 && max2<max9)
            plot(coordCAP0603(l),coordCAP0603(l+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordCAP0603(l),coordCAP0603(l+1),'\color{yellow}Cap0603');
            nbcap0603=nbcap0603+1;
    elseif((max3<max1 && max3<max2 && max3<max4 && max3<max5 && max3<max6 && max3<max7 && max3<max8 && max3<max9))
            plot(coordRES0603(m),coordRES0603(m+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordRES0603(m),coordRES0603(m+1),'\color{yellow}Res');
            nbres0603=nbres0603+1;
    elseif ((max4<max1 && max4<max2 && max4<max3 && max4<max5&& max4<max6 && max4<max7 && max4<max8 && max4<max9) )
            plot(coordCAP0912(n),coordCAP0912(n+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordCAP0912(n),coordCAP0912(n+1),'\color{yellow}Cap0912');
            nbcap0912=nbcap0912+1;
    elseif ((max5<max1 && max5<max2 && max5<max3 && max5<max4 && max5<max6 && max5<max7 && max5<max8 && max5<max9))
            plot(coordComp1(r),coordComp1(r+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordComp1(r),coordComp1(r+1),'\color{yellow}Comp1');
            nbcomp1=nbcomp1+1;
    elseif ((max6<max1 && max6<max2 && max6<max3 && max6<max4 && max6<max5 && max6<max7 && max6<max8 && max6<max9))
            plot(coordDiode0603(p),coordDiode0603(p+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordDiode0603(p),coordDiode0603(p+1),'\color{yellow}Diode0603');
            nbdiode0603=nbdiode0603+1;
    elseif ((max7<max1 && max7<max2 && max7<max3 && max7<max4 && max7<max5 && max7<max6 && max7<max8 && max7<max9  ))
            plot(coordInductance0603(s),coordInductance0603(s+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordInductance0603(s),coordInductance0603(s+1),'\color{yellow}Inductance0603');
            nbinductance0603=nbinductance0603+1;
    elseif ((max8<max1 && max8<max2 && max8<max3 && max8<max4 && max8<max5 && max8<max6 && max8<max7 && max8<max9))
            plot(coordDiode0805(y),coordDiode0805(y+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordDiode0805(y),coordDiode0805(y+1),'\color{yellow}Diode0805');
            nbdiode0805=nbdiode0805+1;
     elseif ((max9<max1 && max9<max2 && max9<max3 && max9<max4 && max9<max5 && max9<max6 && max9<max7 && max9<max8))
            plot(coordSot23(x),coordSot23(x+1),'Marker','s','MarkerFaceColor','y','Markersize',8,'MarkerEdgeColor','none');
            text(coordSot23(x),coordSot23(x+1),'\color{yellow}Sot23');
            nbsot23=nbsot23+1;
        
    end
end
end
guidata(hObject, handles);



function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)

function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)

function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)

function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)

function edit6_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)

function edit7_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit11_Callback(hObject, eventdata, handles)

function edit11_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)


function edit12_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)

function edit13_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
