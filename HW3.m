function run()
clc;
close all;


%% Load images

%Image folder 1 My images
% We canc hange this number based on the photos
% the photos will have to be named 1.jpg, 2.jpg ,... sequentially

for i = 1:11
     fprintf("Uploading our img#%d\n",i);
     %rotation pur image
     Images{i} = imrotate(imread(strcat('Pics/Photos_2/',num2str(i),'.jpg')), -90);
end
% I picked osort of the middle image for what we needed
OurMiddleImage = 5;


%Image folder 2 My images
%for i = 1:4
%    fprintf("Uploading our img#%d\n",i);
%    Images{i} = imrotate(imread(strcat('Pics/Photos/',num2str(i),'.jpg')), -90);
%end
%OurMiddleImage = 3;


ImageNum = size(Images,2);
ImgIndices = (1:ImageNum)';
if(OurMiddleImage>ImageNum)
    fprintf("Base image cannoy be more than number of images pick a number between the range of number of images\n");
    fprintf("make baseimage middle image %d\n", ImageNum\2);
    OurMiddleImage = ImageNum;
end

FinalImage = find(OurMiddleImage~=ImgIndices);
InlierThreshold = 15;
width = size(Images{1},2);
height = size(Images{1},1);

%%Features

%2: SURF


%% Extract Features
for(i=1:ImageNum)
    fprintf("features from img#%d\n",i);
    % make image gray
    Img{i}=rgb2gray(Images{i});
    %detacting features using sutf
    FeaturePoints{i}=detectSURFFeatures(Img{i});
    %extract features
    FeatureDescriptors{i}=extractFeatures(Img{i},FeaturePoints{i});
    %mark locations for each image
    Features{i}.Location = FeaturePoints{i}.Location;
    Features{i}.Descriptors = FeatureDescriptors{i};
end

%% Match Features between img i and img i+1
for i=1:ImageNum-1
    fprintf("Matching img#%d and img#%d\n",i, i+1);

    [Idx1, Idx2] = TryFeatureMatch(2, 1, ...
                                   Features{i}.Descriptors,...
                                   Features{i+1}.Descriptors);
    MatchedIndices{i}.BaseIdx = Idx1;
    MatchedIndices{i}.TargetIdx = Idx2;
    PTs{i}.BaseLoc = Features{i}.Location(MatchedIndices{i}.BaseIdx,:);
    PTs{i}.TargetLoc = Features{i+1}.Location(MatchedIndices{i}.TargetIdx,:);
    MatchingSize{i} = size(PTs{i}.BaseLoc,1);
end

%% Match features and get inlier matches
for i=1:ImageNum-1
    fprintf("Finding Homography from img#%d and img#%d\n",i, i+1);
    [Idx1, Idx2] = TryFeatureMatch(2, 3,...
                                   Features{i}.Descriptors,...
                                   Features{i+1}.Descriptors);
    MatchedIndices{i}.BaseIdx=Idx1;
    MatchedIndices{i}.TargetIdx=Idx2;
    PTs{i}.BaseLoc = Features{i}.Location(MatchedIndices{i}.BaseIdx,:);
    PTs{i}.TargetLoc = Features{i+1}.Location(MatchedIndices{i}.TargetIdx,:);
    MatchingSize{i} = size(PTs{i}.BaseLoc,1);
    
    
    %% Do RANSAC
    if size(PTs{i}.BaseLoc,1)<4
        fprintf('Number of correspondence for img#%d and img#%d is %d\n', i, i+1, size(PTs{i}.BaseLoc,1));
        error('Not enough correspondence for homography RANSAC');
    end
    [Inliers{i}, ~] = RANSACHomography(InlierThreshold, PTs{i}.BaseLoc, PTs{i}.TargetLoc);
    if size(Inliers{i},1)<4
        fprintf('Number of correspondence inliers for img#%d and img#%d is %d\n', i, i+1, size(Inliers{i},1));
        error('Not enough correspondence for Homography');
    end
   
    Outliers{i} = (1:MatchingSize{i})';
    Outliers{i} = setdiff(Outliers{i},Inliers{i});
    H{i}.NDLT=GetHomographyNDLT(PTs{i}.TargetLoc(Inliers{i},:), PTs{i}.BaseLoc(Inliers{i},:));

     WarpImg(2, Images{i}, Images{i+1}, H{i}.NDLT);
    drawnow;
end

%% Get Homography
%making 3 x 3 Homography matrix
H_Base = zeros(3,3,ImageNum-1);
fprintf("Calculating homography for images\n");
for i=1:size(FinalImage,1)
    ImgIdx = FinalImage(i,1);
    fprintf("Finding Homography between img#%d and img#%d\n",ImgIdx, OurMiddleImage);

    
    if(ImgIdx<OurMiddleImage)
        H_Base(:,:,i) = H{ImgIdx}.NDLT;
        for j = ImgIdx+1:1:OurMiddleImage-1
            H_Base(:,:,i) = H{j}.NDLT*H_Base(:,:,i);
        end
    else
        H_Base(:,:,i) = inv(H{ImgIdx-1}.NDLT);
        for j = ImgIdx-2:-1:OurMiddleImage
            H_Base(:,:,i) = inv((H{j}.NDLT))*H_Base(:,:,i);
        end
    end
end

%% Warp images into base image
fprintf("working on warping the image and stiching...\n");
WarpImgs(3,Images,ImgIndices,OurMiddleImage,H_Base);

end