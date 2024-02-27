%__________________________________________WIDTH DETECTION_____________________________________________

%remove shorter comings from clean vessels
clean_vessel = bwmorph(clean_image,'spur',5);
clean_vessel(~eyemask)= 0;
figure, imshow(clean_vessel)
title('Clean Vessel after removing shoter segments (spur)')

%clean vessel image without branchpoint
clean_vessel_wo_branchpoint = clean_vessel & ~dialted_branchpoint;
figure, imshow(clean_vessel_wo_branchpoint);
title('Clean Vessel Image Without Branchpoint')

%discarding shorter segments(manual value selection)
minlength = 15;
vessel_segments_width = bwareaopen(clean_vessel_wo_branchpoint, minlength, 8);
figure, imshow(vessel_segments_width);
title('Discarding Shorter Segments of clean image')

% %centerline of vessels (Skeletonization)
% centerline_skleton = bwmorph(clean_vessel_wo_branchpoint,'skel',Inf);
% figure
% imshow(centerline_skleton)
% title('Centerline of Vessels')
% 
% %skleton image without branchpoint
% centerline_skleton = centerline_skleton & ~dialted_branchpoint;
% figure
% imshow(centerline_skleton);
% title('Skleton Image Without Branchpoint')
% 
% %discarding shorter segments(manual value selection)
% minlength = 15;
% vessel_segments_width_skel = bwareaopen(centerline_skleton, minlength, 8);
% figure
% imshow(vessel_segments_width_skel);
% title('Discarding Shorter Segments of skeleton image')

%-----shotcut for centerline - skleton for overlay------
centerline_skleton = bwmorph(vessel_segments_width,'skel',Inf);
figure, imshow(centerline_skleton)
title('Centerline of Vessels')

%BINARY IMAGE WITH SKLETON OVERLAY overlaying centerline over segmented vessels
overlayed = imoverlay(vessel_segments_width, centerline_skleton, 'r');
figure, imshow(overlayed)
title('Overlayed Image with Centerline')

%LABELLING & DILATING VESSEL SEGMENTS 
L1 = bwlabel(vessel_segments_width,8);
imshow(label2rgb(imdilate(L1,strel('disk',4)),jet(max(L1(:))),'k','shuffle'));
RGB = label2rgb(L1,jet(max(L1(:))),'k','shuffle'); 
se2 = strel('disk',1);
dialted_labelled_branch = imdilate(RGB,se2);
figure, imshow(dialted_labelled_branch)
title('Labelled Vessels')

[r, c] = find(L1==25);
rc = [r c]

%imtool(dialted_labelled_branch)

figure, imshow(L1 == 25);
set(gca,'xlim',[195,242],'ylim',[333,369]);% 238 346
title('labelled vessel no')

% CHECK LABELS FOR VESSEL IMAGE
%    figure
%    h = imshow(L1 == 1);
%    title('play')
%    for ii = 1:max(L1(:))
%        %dialted_labelled_branch = ii;
%        set(h,'cdata',L1 ==ii)
%        pause
%    end

%LABELLING & DILATING SKLETON (CENTERLINE)IMAGE 
L2 = bwlabel(centerline_skleton,8);
imshow(label2rgb(imdilate(L2,strel('disk',4)),jet(max(L2(:))),'k','shuffle'));
RGB2 = label2rgb(L2,jet(max(L2(:))),'k','shuffle'); 
se22 = strel('disk',1);
dialted_labelled_centerline = imdilate(RGB2,se22);
figure
imshow(dialted_labelled_centerline)
title('Labelled centerline')

[r, c] = find(L2==25);
rc = [r c]

%imtool(dialted_labelled_branch)

figure
imshow(L2 == 25);
set(gca,'xlim',[195,242],'ylim',[333,369]);% 238 346
title('Labelled Centerline No')

% CHECK LABELS FOR CENTERLINE IMAGE
%    figure
%    h = imshow(L2 == 1);
%    title('play')
%    for ii = 1:max(L2(:))
%        %dialted_labelled_branch = ii;
%        set(h,'cdata',L2 ==ii)
%        pause
%    end

%WIDTH OF LABELLED VESSEL
vessel25 = L1 == 25; 
figure 
imshow(vessel25);
%set(gca,'xlim',[195,242],'ylim',[333,369]);% 238 346
title('labelled vessel no')

centerline25 = L2 == 25;
figure 
imshow(centerline25);
%set(gca,'xlim',[195,242],'ylim',[333,369]);% 238 346
title('Labelled Centerline No')

%    AVERAGE WIDTH COMPUTATION
% Compute the Euclidean Distance Transform
fontSize = 15;
edtImage = bwdist(~vessel25);
figure
imshow(edtImage, []);
set(gca,'xlim',[195,242],'ylim',[333,369]);% 238 346
title('Distance Transform', 'FontSize', fontSize, 'Interpreter', 'None');
% Extract the distances only along the skeleton image to extract only radii along spine.
radii = edtImage(centerline25); 
% These are the half widths.  Multiply by 2 to get the full widths.
averageWidth = 2 * mean(radii);
caption = sprintf('Distance Transform.  Mean Width = %.1f', averageWidth);
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');

%------FOR WHOLE FIGURE
%WAY1

% [row, col] = find(bwmorph(L2 == 25, 'endpoints'));
% hold on 
% plot(col, row,'r.','MarkerSize',36)
% 
% %set(gca, 'xlimmode','auto','ylimmode','auto')
% L2 = bwlabel(vessel_segments_width,8);
% imshow(label2rgb(imdilate(L2,strel('disk',4)),jet(max(L2(:))),'k','shuffle'));
% RGB = label2rgb(L2,jet(max(L2(:))),'k','shuffle'); 
% se2 = strel('disk',1);
% dialted_labelled_branch = imdilate(RGB,se2);
% figure
% imshow(dialted_labelled_branch)
% title('Labelled Vessels')
% hold on
% stats = regionprops(L2,'Centroid','Perimeter');
% delete(findobj(gcf,'tag','mybalel'));
% 
% %edtImage = bwdist(~L1,'Centroid','Perimeter');
% %radii = edtImage(L2); 
% %averageWidth = [stats.Perimeter]*mean(radii)*2;
% 
% pathlengths = [stats.Perimeter]/2;
% for ii = 1:numel(stats)
%     text(stats(ii).Centroid(1),stats(ii).Centroid(2),sprintf('*V%d: %0.1f pixels',ii,pathlengths(ii)),'fontunits','normal','color',[0.9 0.7 0],'tag','mylabel')
% end
% title('segments length')
% 
% 
% % [row, col] = find(bwmorph(L == 25, 'endpoints'));
% % hold on 
% % plot(col, row,'r.','MarkerSize',36)
% % 
% % set(gca, 'xlimmode','auto','ylimmode','auto')
% % L = bwlabel(vessel_segments,8);
% % %imshow(label2rgb(imdilate(L,strel('disk',4))jet(max(L(:))),'k','shuffle'));
% % RGB = label2rgb(L,jet(max(L(:))),'k','shuffle'); 
% % se2 = strel('disk',1);
% % dialted_labelled_branch = imdilate(RGB,se2);
% % figure
% % imshow(dialted_labelled_branch)
% % title('Arclength via perimeter')
% % hold on
% % stats = regionprops(L,'Centroid','Perimeter');
% % delete(findobj(gcf,'tag','mybalel'));
% % 
% % pathlengths = [stats.Perimeter]/2;
% % for ii = 1:numel(stats)
% %     text(stats(ii).Centroid(1),stats(ii).Centroid(2),sprintf('*%0.1f pixels',pathlengths(ii)),'fontunits','normal','color',[0.9 0.7 0],'tag','mylabel')
% % end
% % title('segments length')
% 
% %WAY2
% endpoint_fcn = @(nhood) (nhood(5)==1)&&(nnz(nhood)==2);
% 
% figure 
% imshow(L2 == 25);
% 
% %set(gca,'xlim',[320,380],'ylim',[412,465]);
% %L=25 X =  338 427 Y = 360 451 rect1 = 336.5 425.5 3 3 rect2 = 358.5 449.5 3 3
% %rect(1) = rectangle('position',[336.5 425.5 3 3],'edgecolor', 'red');
% %rect(1) = rectangle('position',[358.5 449.5 3 3],'edgecolor', 'red');
% 
% %cross check
% endpoint_fcn([0 0 0;0 1 0; 0 1 1])
% 
% endpoint_fcn([0 0 0;0 1 0; 0 0 1])
% 
% endpoint_lut = makelut(endpoint_fcn, 3);
% 
% %set(gca,'xlim',[320,380],'ylim',[412,465])
% 
% %plot(col, row,'r.','MarkerSize',36)
% 
% [row, col] = find(bwlookup(L2 == 25, endpoint_lut));
% hold on
% plot(col, row,'yo','MarkerSize',36)
% plot(col, row,'r.','MarkerSize',36)
% 
% 
% 
% figure
% im = L2 == 25;
% imshow(im);
% set(gca,'xlim',[320,380],'ylim',[412,465]);
% %im = imcrop(L,[320 412 380 465]);%330 420 34 35
% %imshow(im);
% [row, col] = find(bwlookup(im, endpoint_lut));
% hold on
% plot(col, row,'m.','MarkerSize',36)
% title('single vessel')
% 
% gdist = bwdistgeodesic(im, col(1), row(1), 'quasi-euclidean');
% imshow(gdist,[])
% title('geodisc distance transform')
% hold on
% text(col(1)+2, row(1)-1, 'starting point','color','r')
% plot(col(1), row(1), 'm.', 'markersize', 36)
% colormap([0 0 0;jet])
% colorbar('horizontal')
%  
% %using geodesic and using lookup table
% figure
% imshow(L);
% delete(findobj(gcf,'tag','myLabel'));
% hold on 
% 
% mydist = @(p1,p2) sqrt((p1(1)-p1(2))^2 + (p2(1)-p2(2))^2);
% stats = regionprops(L,'Centroid');
% 
% %preallocate
% dists = zeros(numel(stats,1));
% pathlengths = dists;
% 
% for ii = 1:numel(stats)
%     tmpIm = L == ii;
%     %[r,c] = find(bwmorph(tmpIm,'endpoints'));
%     [r,c] = find(bwlookup(tmpIm,endpoint_lut));
%     hold on
%     plot(c,r,'r.','markersize',12,'tag','mylabel')
%     plot(c(1),r(1),'go','markersize',10,'tag','mylabel')
%     try
%         %calc endpoint dist
%         dists(ii) = mydist(r,c);
%         %calc pathlengths
%         pathlengths(ii)= max(max(bwdistgeodesic(tmpIm,col(1), row(1),'quasi-euclidean')));
%         text(stats(ii).Centroid(1),stats(ii).Centroid(2),sprintf('*%0.1f pixels',dists(ii)),'fontsize',9,'fontweight','normal','color',[0.7 0.7 0],'tag','mylabel');
%     catch
%         %fprintf('didnt work')
%         dists(ii) = mydist(r,c);
%         pathlengths(ii)= max(max(bwdistgeodesic(tmpIm,col(1), row(1),'quasi-euclidean')));
%         text(stats(ii).Centroid(1),stats(ii).Centroid(2),sprintf('*%0.1f pixels',dists(ii)),'fontsize',9,'fontweight','normal','color',[0.7 0.7 0],'tag','mylabel');
%     end
% end        
% 
% % fontSize = 15;
% % edtImage = bwdist(~dialted_labelled_branch);
% % figure
% % imshow(edtImage, []);
% % %set(gca,'xlim',[195,242],'ylim',[333,369]);% 238 346
% % title('Distance Transform', 'FontSize', fontSize, 'Interpreter', 'None');
% % % Extract the distances only along the skeleton image to extract only radii along spine.
% % radii = edtImage(dialted_labelled_centerline); 
% % % These are the half widths.  Multiply by 2 to get the full widths.
% % averageWidth = 2 * mean(radii);
% % %caption = sprintf('Distance Transform.  Mean Width = %.1f', averageWidth);
% % t%itle(caption, 'FontSize', fontSize, 'Interpreter', 'None');
% % 
% % for ii = 1:numel(averageWidth)
% %     text(edtImage(ii).Centroid(1),radii(ii).Centroid(2),sprintf('*V%d: Mean Width = %.1f',ii,averageWidth(ii)),'fontsize','normal','fontweight','b','color',[0.9 0.7 0],'tag','myLabel');
% % end    
% % title('Distance Transform.','color',[0 0.7 0],'fontsize',10)


