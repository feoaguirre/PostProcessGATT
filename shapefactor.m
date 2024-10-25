%% load parameters and variables

cd bin;
parameters;
clear caseName D delta delta99end domain logAll flowType flowParameters Ma numMethods p_col p_row Red time ;
cd ..;

mesh = load('mesh.mat');
meanflow = load('flow_mean.mat');
xind_end = find(abs(mesh.X-xEnd)==min(abs(mesh.X-xEnd)),1);
meanU = mean(meanflow.U,3);
meanR = mean(meanflow.R,3);
meanU(isnan(meanU)) = 0;
meanR(isnan(meanR)) = 0;

%% calculate delta

Delta = zeros(length(mesh.X),1);
Deltai = zeros(length(mesh.X),1);
for i=1:length(mesh.X)
    for j=48:length(mesh.Y)
%     for j=38:length(mesh.Y)
        if abs(meanU(i,j)-1)<= 1e-3
            Deltai(i) = j;
            Delta(i) = mesh.Y(j);
            continue
        end
    end    
end

for i=1:length(mesh.X)
    if Delta(i) == 0
       Delta(i) = Delta(i-1);
    end    
end

%% calculate delta star

Delta1 = zeros(length(mesh.X),1);
for i=1:length(mesh.X)
%    Delta1(i) = trapz(mesh.Y(50:Deltai(i)),(1-((meanR(i,50:Deltai(i)).*meanU(i,50:Deltai(i))))/(1.002*1.002)));
Delta1(i) = trapz(mesh.Y(38:Deltai(i)),(1-((meanR(i,38:Deltai(i)).*meanU(i,38:Deltai(i))))/(1.002*1.002)));
end

%% calculate theta

Delta2 = zeros(length(mesh.X),1);
for i=1:length(mesh.X)
%      Delta2(i) = trapz(mesh.Y(50:Deltai(i)),(1-((meanU(i,50:Deltai(i))))/(1.002)).*(meanR(i,50:Deltai(i)).*(meanU(i,50:Deltai(i)))./(1.002*1.002)));
Delta2(i) = trapz(mesh.Y(38:Deltai(i)),(1-((meanU(i,38:Deltai(i))))/(1.002)).*(meanR(i,38:Deltai(i)).*(meanU(i,38:Deltai(i)))./(1.002*1.002)));   
end


%% find shape factor
H = Delta1./Delta2;

%%plot 

figure
plot(mesh.X(1:xind_end)-mesh.flowType.cav{1,1}.x(2),H(1:xind_end),'b--');%-mesh.flowType.cav{1,1}.x(2)
fe = 800-mesh.flowType.cav{1,1}.x(2);
grid on; hold on;
plot([mesh.X(1) mesh.X(end)], [2.59 2.59],'r');
plot([mesh.X(1) mesh.X(end)], [1.4 1.4],'g');
% plot([x1 x1],[0 5],'k--')
% plot([fe-300 fe-300],[0 5],'k--')
plot([mesh.flowType.cav{1, 1}.x(2) mesh.flowType.cav{1, 1}.x(2)],[1 3.5],'k--')
plot([mesh.flowType.cav{1, 1}.x(1) mesh.flowType.cav{1, 1}.x(1)],[1 3.5],'k--')
xlim([0 540]);
ylim([1.0 3.5])
xlabel('X');
ylabel('Shape Factor');
legend('Shape factor case A','Blasius Shape Factor','typical turbulent Shape Factor','Trailing edge case B','Leading edge case B');