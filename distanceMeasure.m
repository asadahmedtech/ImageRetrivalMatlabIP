function dist = distanceMeasure(queryImageFeature, dataset, part)
    datasize = size(dataset,1);
    distances = zeros(datasize,2);
    for i = 1:datasize
        distances(i,1) = pdist2(queryImageFeature(1:256),dataset(i,1:256),'chebychev');
        distances(i,2) = 1+floor((dataset(i,257)-1)/part);
    end
    [~,idx] = sort(distances(:,1)); % sort just the first column
    dist = distances(idx,:);   % sort the whole matrix using the sort indices
end

function dist = calcDistance(vec1, vec2)
    V = vec1 - vec2;
    dist = sqrt(V * V');
end
function D = distChiSq( X, Y )

%%% supposedly it's possible to implement this without a loop!
m = size(X,1);  n = size(Y,1);
mOnes = ones(1,m); D = zeros(m,n);
for i=1:n
  yi = Y(i,:);  yiRep = yi( mOnes, : );
  s = yiRep + X;    d = yiRep - X;
  D(:,i) = sum( d.^2 ./ (s+eps), 2 );
end
D = D/2;
end