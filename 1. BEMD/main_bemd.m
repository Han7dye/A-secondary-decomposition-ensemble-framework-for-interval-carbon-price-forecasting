clear;
clc;

%load our data
data=load('HBEA.txt');
data_bemd = complex(data(:,2), data(:,1));

%% BEMD
bimf = bemd(data_bemd);
dataT = real(bimf);
dataI = imag(bimf);

%plot each mode
[m,n]=size(dataT);
t=1:n;
%subplot(m+1,1,1);
%set(gcf,'color','w')
%plot(t,data(:,2),'k',t,data(:,1),'k--')
%set(gca,'fontname','times New Roman')
%set(gca,'fontsize',14.0)
%ylabel('Original')

for i=1:m-1
subplot(m+1,1,i+1);
set(gcf,'color','w')
plot(t,dataT(i,:),'k',t,dataI(i,:),'b')
set(gca,'fontname','times New Roman')
set(gca,'fontsize',14.0)
ylabel(['IMF',int2str(i)])
end

subplot(m+1,1,m+1);
set(gcf,'color','w')
plot(t,dataT(m,:),'k',t,dataI(m,:),'b')
set(gca,'fontname','times New Roman')
set(gca,'fontsize',14.0)
ylabel('Residue')
ct=dataT';
ci=dataI';