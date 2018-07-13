function []=Chromaticity()
figure;
plotChromaticity;
hold on
x1=0.64;
y1=0.33;
scatter(x1,y1,10,'k');
text(x1-0.08,y1,'Red','VerticalAlignment','bottom','color','w','fontsize',12);
hold on 
x2=0.3;
y2=0.6;
scatter(x2,y2,10,'k');
text(x2-0.02,y2,'Green','VerticalAlignment','bottom','color','w','fontsize',12);
hold on 
x0=0.3;
y0=0.5;
text(x0,y0,'sRGB','VerticalAlignment','bottom','color','w','fontsize',12);
hold on 
x3=0.15;
y3=0.06;
scatter(x3,y3,10,'k');
text(x3+0.02,y3+0.04,'Bule','VerticalAlignment','bottom','color','w','fontsize',12);
plot([x1,x2],[y1,y2],'k');
plot([x1,x3],[y1,y3],'k');
plot([x2,x3],[y2,y3],'k');
end