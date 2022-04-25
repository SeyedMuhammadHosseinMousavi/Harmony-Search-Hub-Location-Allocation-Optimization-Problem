
function sol=ParseSolution(xhat,model)

N=model.N;
P=model.P;
c=model.c;
alpha=model.alpha;
f=model.f;
r=model.r;
xii=diag(xhat)';
if any(xii>=0.5)
[~, so]=sort(xii,'descend');
nHub=0;
for i=so
if xii(i)<0.5 || nHub>=P
break;
end
xii(i)=1;
nHub=nHub+1;
end

xii(xii<1)=0;
else
[~, imax]=max(xii);

xii(:)=0;
xii(imax)=1;
end

Hubs=find(xii==1);
x=xhat;
for i=1:N
if xii(i)==0
x(i,:)=0;
else
x(:,i)=0;
x(i,i)=1;
end
end

h=zeros(1,N);
for i=1:N

XI=x(:,i);
XI(xii==0)=-inf;

[~, h(i)]=max(XI);

x(:,i)=0;
x(h(i),i)=1;

end
oc=zeros(N,N);
for i=1:N
for j=1:N
if i==j
oc(i,j)=0;
else
k=h(i);
l=h(j);
oc(i,j)=c(i,k)+alpha*c(k,l)+c(l,j);
end
end
end

ocr=oc.*r;
SumOCR=sum(ocr(:));

xiif=xii.*f;
SumXF=sum(xiif);

TotalCost=SumOCR+SumXF;

sol.x=x;
sol.h=h;
sol.Hubs=Hubs;
sol.SumOCR=SumOCR;
sol.SumXF=SumXF;
sol.TotalCost=TotalCost;

end