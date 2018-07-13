%load color plot
clear;clc;close all;
x=50:5:150;                 %input disagree 
n=length(x);
left = sprum_to_color('E:\Ring-1\Ring_150_70\Ring\left\*.txt','E:\Ring-1\Ring_150_70\Ring\left\',x);   %input file path
right= sprum_to_color('E:\Ring-1\Ring_150_70\Ring\right\*.txt','E:\Ring-1\Ring_150_70\Ring\right\',x);
%find max /min in left and max/min in right
min1=100;max1=10000;c1=1;c2=1;c3=1;d1=0;d2=0;d3=0;
M=rank_max(left,right,n);
[k1,k2]=size(M);
for i=1:k1
    if M(i,5)<=min1&&M(i,6)>=max1
        A(c1,:)=M(i,:);
        c1=c1+1;
    end
end
for i=1:k1
    if M(i,6)<=min1&&M(i,5)>=max1
         B(c2,:)=M(i,:);
        c2=c2+1;
    end 
end

%find similar color of left and right
for i=1:n
    for j=1:n
            E(i,j)=(left{i,j}(1)-right{i,j}(1))^2+(left{i,j}(2)-right{i,j}(2))^2+(left{i,j}(3)-right{i,j}(3))^2;
    end
end
[row,col,~]=find(E<=500);
S1=[row,col];


%load image
I1 = imread('E:\zimu\chang1.jpg');%%input the image name here
I1=imresize(I1,[250 300]);
figure;
imshow(I1);
I2 = imread('E:\zimu\tian4.jpg');%%input the image name here
I2=imresize(I2,[250,300]);
figure;
imshow(I2);
[m1,n1,l1]=size(I1);
[P1,P2,P3]=cutimg(I1,100,0); %left img 100为噪声，0为噪声替换为0
[Q1,Q2,Q3]=cutimg(I2,100,0); %right img
I1_new=zeros(m1,n1,3,'uint8');
I2_new=zeros(m1,n1,3,'uint8');
%着色
S1=cell(n,n);
S2=cell(n,n);
for i=1:21
    for j=1:21

S1{i,j}=max_min(1,left,right,200,21,i,j);% left several  same while right several different  
S2{i,j}=max_min(2,left,right,200,21,i,j);% right several  same while left several different 
S1{i,j}=sortrows(S1{i,j},-4);                %按照第4列从大到小进行排序
S2{i,j}=sortrows(S2{i,j},-3);  
S1{i,j}=[S1{i,j}(end,:);S1{i,j}];
S2{i,j}=[S2{i,j}(end,:);S2{i,j}];
    end
end
%左--右  1对多  多对1
%1. find all left color plot
H1=cell(length(P1),1);
t=1;
for i=1:length(P1)
    [g1,g2]=find(P2==P1(i));
    H1{t}=[g1,g2];
    t=t+1;
end
%2. find all right color plot
H2=cell(length(Q1),1);
t1=1;
for i=1:length(Q1)
    [s1,s2]=find(Q2==Q1(i));
    H2{t1}=[s1,s2];
    t1=t1+1;
end

%left image one in right images
HG=cell(29,27);
FF=cell(29,1);
HK=cell(29,1);
tt=1;
for i=1:29
    f1=length(H1{i}(:,1));
    for j=1:27
         f2=length(H2{j}(:,1));
         for i1=1:f1
             for j1=1:f2
                 if (H1{i}(i1,1)==H2{j}(j1,1)&&H1{i}(i1,2)==H2{j}(j1,2))
                     HG{i,j}(tt,1)=i;
                     HG{i,j}(tt,2)=j;
                     HG{i,j}(tt,3)=H1{i}(i1,1);
                     HG{i,j}(tt,4)=H1{i}(i1,2);
                     tt=tt+1;
                 end
             end
         end
         tt=1;
        
      
    end
     FF{i}=[HG{i,1};HG{i,2};HG{i,3};HG{i,4};HG{i,5};HG{i,6};HG{i,7};HG{i,8};HG{i,9};HG{i,10};HG{i,11};HG{i,12};HG{i,13};HG{i,14};HG{i,15};HG{i,16};HG{i,17};HG{i,18};HG{i,19};HG{i,20};HG{i,21};HG{i,22};HG{i,23};HG{i,24};HG{i,25};HG{i,26};HG{i,27};];  
end     

for i=1:29
    HK{i,1}=unique(FF{i}(:,2));
    leth(i,1)=i;
    leth(i,2)=length(HK{i,1});
end
LH=sortrows(leth,-2);      %按照元素个数进行排序
ZH=cell(29,1);
for i=1:29
    ZH{i}(:,1)=HK{i}(:,1);
    ZH{i}(:,2)=1;
    ZH{i}(:,3)=1;
end
%关键 确定ZH
HM=zeros(27,29);
for i=1:27
 for j=1:29
    for k=1:length(ZH{j}(:,1))
        if ZH{j}(k,1)==i
        HM(i,j)=ZH{j}(k,1);
        end
    end
 end
end

%确定开始颜色,非常重要
 Z0=[3,17];
 H=max_min(1,left,right,200,21,Z0(1),Z0(2));
 H=sortrows(H,-4); 
 H=[H(end,:);H]; 
 HS=max_min(2,left,right,200,21,Z0(1),Z0(2));
 HS=sortrows(HS,-4); 
 HS=[HS(end,:);HS];
%根据开始颜色进行色块选择
HT=cell(27,29);
for i=1:29
   [r,c,v]=find(HM(:,i));
   for j=1:length(r)
    HT{r(j),i}=[0,0];   
   end
end
%确定第一行的色块
for i=1
   [r,c,v]=find(HM(:,i));
   for j=1:length(r)
   HT{r(j),i}=[H(j,1),H(j,2)];
   end
end
%确定第一列的色块
for i=1
    [r,c,v]=find(HM(i,:));
    for j=1:length(c)
        HT{i,c(j)}=[HS(j,1),HS(j,2)];
    end
end

%调整
%1.交换1和26列
t=cell(1,1);
t=HT(1,2);
HT(1,2)=HT(1,3);
HT(1,3)=t;


%进行第一次有条件填充
[r1,c1,v1]=find(HM(:,1));
[r2,c2,v2]=find(HM(1,:));
for i=2:length(c2)
    for j=2:length(r1)
        A1=HT{1,c2(i)};
        B1=HT{r1(j),1};
        C=S2{B1(1),B1(2)};
        if HM(r1(j),c2(i))~=0
        for k=1:length(C(:,1))
            AC(k)=(left{C(k,1),C(k,2)}(1)-left{A1(1),A1(2)}(1))^2+(left{C(k,1),C(k,2)}(2)-left{A1(1),A1(2)}(2))^2+(left{C(k,1),C(k,2)}(3)-left{A1(1),A1(2)}(3))^2;
        end
        [yy1,yy2]=min(AC);
        HT{r1(j),c2(i)}=[C(yy2,1),C(yy2,2)];
        AC=0;
        end
   end

end
%进行第二次补充填充
for i=1:27
    for j=1:29
        tt=HM(i,j);
        if tt~=0&&(HM(i,1)==0||HM(1,j)==0)
            if HM(i,1)==0
                sss1=S1{HT{1,j}(1),HT{1,j}(2)};
                HT{i,j}=[sss1(2,1),sss1(2,2)];
            else
                sss1=S2{HT{i,1}(1),HT{i,1}(2)};
                HT{i,j}=[sss1(2,1),sss1(2,2)];
            end
        end
    end
end


N=cell(m1,n1);


%填充颜色
for i=1:29
        [r,c,v]=find(HM(:,i));
        for j=1:length(r) 
        for k=1:length(FF{i}(:,1)) 
            if v(j)==FF{i}(k,2)
                 I1_new(FF{i}(k,3),FF{i}(k,4),:)=left{HT{r(j),i}(1),HT{r(j),i}(2)};
                 I2_new(FF{i}(k,3),FF{i}(k,4),:)=right{HT{r(j),i}(1),HT{r(j),i}(2)};
                 N{FF{i}(k,3),FF{i}(k,4)}=[HT{r(j),i}(1),HT{r(j),i}(2)]; 
            end
        end
        end
end

figure;
imshow(I1_new);
figure;
imshow(I2_new);