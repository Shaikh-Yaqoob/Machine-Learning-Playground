img = imread('EYE.jpg'); % Read image
red = img(:,:,1); % Red channel
green = img(:,:,2); % Green channel
blue = img(:,:,3); % Blue channel
a = zeros(size(img, 1), size(img, 2));
just_red = cat(3, red, a, a);
just_green = cat(3, a, green, a);
just_blue = cat(3, a, a, blue);
back_to_original_img = cat(3, red, green, blue);
%figure, imshow(img), title('Original image')
%figure, imshow(just_red), title('Red channel')
%figure, imshow(just_green), title('Green channel')
%figure, imshow(just_blue), title('Blue channel')
%figure, imshow(back_to_original_img), title('Back to original image')

img = imread('EYE.jpg'); % Read image
green = img(:,:,2); % Green channel
just_green = cat(3, a, green, a);
figure, imshow(just_green), title('Green channel')

% %CALCULATE TURTUOSITY OF VESSELS
% 
% figure 
% imshow(L == 25);
% set(gca,'xlim',[320,380],'ylim',[412,465]);
% title('labelled vessel no popos up')
% 
% %endponts way1
% [row, col] = find(bwmorph(L == 25, 'endpoints'));
% hold on 
% plot(col, row,'r.','MarkerSize',36)
% 
% %MEASURING URVE LENGTH WAY1 : perimeter
% set(gca, 'xlimmode','auto','ylimmode','auto')
% L = bwlabel(vessel_segments,8);
% %imshow(label2rgb(imdilate(L,strel('disk',4))jet(max(L(:))),'k','shuffle'));
% RGB = label2rgb(L,jet(max(L(:))),'k','shuffle'); 
% se2 = strel('disk',1);
% dialted_labelled_branch = imdilate(RGB,se2);
% figure
% imshow(dialted_labelled_branch)
% title('Arclength via perimeter')
% hold on
% stats = regionprops(L,'Centroid','Perimeter');
% delete(findobj(gcf,'tag','mybalel'));
% 
% pathlengths = [stats.Perimeter]/2;
% for ii = 1:numel(stats)
%     text(stats(ii).Centroid(1),stats(ii).Centroid(2),sprintf('*%0.1f pixels',pathlengths(ii)),'fontunits','normal','color',[0.9 0.7 0],'tag','mylabel')
% end
% title('segments length')
% 
% % TURTUOSITIES
% imshow(L)
% delete(findobj(gcf,'tag','mylabel'));
% hold on
% turtuosity = pathlengths./dists; %pathlengths./dists
% colors = [0.9 0.7 0;1 0 0];
% criticalvalue = 1.2;
% for ii = 1:numel(dists)
%     %fprintf('didnt work')1+(turtuosity(ii)>criticalvalue)*2,:
%     text(stats(ii).Centroid(1),stats(ii).Centroid(2),sprintf('*V%d: %0.2f',ii,turtuosity(ii)),'fontsize',9+(turtuosity(ii)>criticalvalue)*2,'fontweight','b','color',colors(1+(turtuosity(ii)>criticalvalue),:),'tag','myLabel')
% end    
% title('Turtuosity','color',[0 0.7 0],'fontsize',10)
