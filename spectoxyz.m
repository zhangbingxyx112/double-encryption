%==========================================================================
%函数功能：选定光源与标准观察者，将光谱反射率转化为XYZ刺激值
%Reference:https://blog.csdn.net/lxw907304340/article/details/45641419
%==========================================================================
function XYZ=spectoxyz(rec,Source,formulary,M)
[lambda1, xFcn, yFcn, zFcn] = colorMatchFcn(formulary);
[lambda2, energy] = illuminant(Source);
F=[lambda1;xFcn;yFcn;zFcn];
F=F';
S=[lambda2,energy];
% rec和Source波长的范围和间隔可能不一样，下面找出两者共有的波长
[comn,~,~] = intersect(rec(:,1),S(:,1));
% SR和RSPD以及CIE_Std波长的范围和间隔可能不一样，S下面找出3者共有的波长
[~,ia,~] = intersect(F(:,1),comn);
[~,ib,~] = intersect(rec(:,1),comn);
[~,ic,~] = intersect(S(:,1),comn);
if S(ic,2)==0
    XYZ= [0 0 0];
    return
end   
K=M/sum(S(ic,2).*F(ia,3));% 计算K值
[~,sample_num]=size(rec);
XYZ=zeros(sample_num-1,3);
for ii=2:sample_num
    Xt=K*sum(S(ic,2).* F(ia,2).*rec(ib,ii)); % 计算X刺激值
    Yt=K*sum(S(ic,2).* F(ia,3).*rec(ib,ii)); % 计算Y刺激值
    Zt=K*sum(S(ic,2).* F(ia,4).*rec(ib,ii)); % 计算Z刺激值
    XYZ(ii-1,:)=[Xt,Yt,Zt];
end

















