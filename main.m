%% Pre
%% Loading dataset 
[fname, pthname] = uigetfile('*.mat', 'Select the Dataset');
if (fname ~= 0)
    dataset_fullpath = strcat(pthname, fname);
    [pathstr, name, ext] = fileparts(dataset_fullpath);
    if ( strcmpi(ext, '.mat') == 1)
        filename = fullfile( pathstr, strcat(name, ext) );
        load(filename);
    else
        fprintf('Error');
    end
end
clear('dataset_fullpath','pathstr', 'name', 'ext', 'filename','pthname','fname');
%% Load Query Image and Convert to feature Vector
[query_fname, query_pathname] = uigetfile('*.jpg', 'Select query image');
if (query_fname ~= 0)
    query_fullpath = strcat(query_pathname, query_fname);
    imgInfo = imfinfo(query_fullpath);
    [pathstr, name, ext] = fileparts(query_fullpath); % fiparts returns char type
    if ( strcmpi(ext, '.jpg') == 1)
        queryImage = imread( fullfile( pathstr, strcat(name, ext) ) );
        imshow(queryImage);
        set = LBPFeatureExtract(queryImage);
        queryImageFeature = [set', str2num(name)];
        clear('query_fname', 'query_pathname', 'query_fullpath', ...
            'name', 'queryImage', 'set', 'imgInfo');
    else
        errordlg('You have not selected the correct file type');
    end
end
%% Image Retrival
datasize = size(dataset,1);
nretrieve = 10;
precision = zeros(datasize/100,1);
recall = zeros(datasize/100,1);

distances = zeros(datasize,2);
for i = 1:datasize
    distances(i,1) = norm(queryImageFeature(1:256) - dataset(i,1:256));
    distances(i,2) = dataset(i,257);
end
imageSet = (queryImageFeature(257));
%%
[~,idx] = sort(distances(:,1)); % sort just the first column
sortedmat = distances(idx,:);   % sort the whole matrix using the sort indices
%%
num = 0;
for k = 1:10
    num = 0;
        for j = 1:10*k
                if(floor(imageSet/100)==floor(sortedmat(j,2)/100))
                    num = num +1;
                end           
        end
    precision(k,1)=(num/(10*k));
end
recall(floor(imageSet/100))=precision(10);

%% ARR Value 
DB = 1856;
part = 16;

Recall = zeros(DB,1);
[~,idx] = sort(dataset(:,257)); % sort just the first column
mat = dataset(idx,:);% sort the whole matrix using the sort indices
r = zeros(DB,1);
correct = zeros(DB,1);
pred = zeros(DB,1);

for n = 16:16  
    for i = 1:DB
        num = 0;
        dist = distanceMeasure(mat(i,:), dataset, part);
%         pred(1+100*floor((i-1)/100):100+100*floor((i-1)/100)) = dist(1:100);
        for j = 1:n
            correct(i)= 1+floor((i-1)/part);
            pred(i) = mode(dist(1:n,2));
            if(floor((i-1)/part)==dist(j,2)-1)
                num = num + 1;
            end
        end
%         num
        Recall(i)=num/n;
    end
    r(n) = sum(Recall)/DB;
    r(n)
end
%% Precision and Recall
cmat = confMatGet(correct,pred);
calcPandR(cmat);
%% a
x = dist(1:100,2);
y = 0;
for i = 1:length(x)
    if(x(i)==3)
        y= y+1;
    end
end