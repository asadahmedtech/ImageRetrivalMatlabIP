function s = histintersection(XI,XJ)
 m=size(XJ,1); % number of samples of p
  p=size(XI,2); % dimension of samples
  assert(p == size(XJ,2)); % equal dimensions
  assert(size(XI,1) == 1); % pdist requires XI to be a single sample
  
  d=zeros(m,1); % initialize output array
  sxi=sum(XI);
  for i=1:m
    d(i,1) = 1 - (sum(min(XI, XJ(i,:))) / sxi);
    if d(i,1)<0
        fprintf(d(i,1));
    end
  end
  s = sum(d);
end