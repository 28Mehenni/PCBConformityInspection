function [pointMis] = rectan(recovered, mybox)
pointMis=recovered;
imagesize = size(recovered);
maxright = imagesize(2); % nombre de colonnes
maxbottom = imagesize(1);% nombre de lignes
minboxsize = uint16(min(maxright,maxbottom) /50);
for i = 1:length(mybox)
 mleft(i) = uint16(min(mybox{i}(:,2)));
 mright(i) = uint16(max(mybox{i}(:,2)));
 mtop(i) = uint16(min(mybox{i}(:,1)));
 mbottom(i) = uint16(max(mybox{i}(:,1)));
 left(i) = max(mleft(i) - minboxsize, 1);
 right(i) = min(mright(i) + minboxsize, maxright);
 top(i) = max(mtop(i) - minboxsize, 1);
 bottom(i) = min(mbottom(i) + minboxsize, maxbottom);

 pointMis(top(i),left(i):right(i),1)=255; pointMis(top(i)+1,left(i):right(i),1)=255; pointMis(top(i)+2,left(i):right(i),1)=255;
 pointMis(top(i),left(i):right(i),2)=0; pointMis(top(i)+1,left(i):right(i),2)=0;pointMis(top(i)+2,left(i):right(i),2)=0;
 pointMis(top(i),left(i):right(i),3)=0; pointMis(top(i)+1,left(i):right(i),3)=0; pointMis(top(i)+2,left(i):right(i),3)=0;

 pointMis(bottom(i),left(i):right(i),1)=255;pointMis(bottom(i)+1,left(i):right(i),1)=255;pointMis(bottom(i)+2,left(i):right(i),1)=255;
 pointMis(bottom(i),left(i):right(i),2)=0; pointMis(bottom(i)+1,left(i):right(i),2)=0; pointMis(bottom(i)+2,left(i):right(i),2)=0;
 pointMis(bottom(i),left(i):right(i),3)=0;pointMis(bottom(i)+1,left(i):right(i),3)=0;pointMis(bottom(i)+2,left(i):right(i),3)=0;

 pointMis(top(i):bottom(i),left(i),1)=255;pointMis(top(i):bottom(i),left(i)+1,1)=255;pointMis(top(i):bottom(i),left(i)+2,1)=255;
 pointMis(top(i):bottom(i),left(i),2)=0;pointMis(top(i):bottom(i),left(i)+1,2)=0;pointMis(top(i):bottom(i),left(i)+2,2)=0;
 pointMis(top(i):bottom(i),left(i),3)=0;pointMis(top(i):bottom(i),left(i)+1,3)=0;pointMis(top(i):bottom(i),left(i)+2,3)=0;

 pointMis(top(i):bottom(i),right(i),1)=255;pointMis(top(i):bottom(i),right(i)+1,1)=255;pointMis(top(i):bottom(i),right(i)+2,1)=255;
 pointMis(top(i):bottom(i),right(i),2)=0;pointMis(top(i):bottom(i),right(i)+1,2)=0;pointMis(top(i):bottom(i),right(i)+2,2)=0;
 pointMis(top(i):bottom(i),right(i),3)=0;pointMis(top(i):bottom(i),right(i)+1,3)=0;pointMis(top(i):bottom(i),right(i)+2,3)=0;
end
end