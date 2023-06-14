 clc; clear all; close all
subjects = [3 4 5 6 7 8 9 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33]; 
%%
%%% subject 1-2 are pilot subjects using a slightly different paradigm, so
%%% we did not pay for the scans! 
%%% and we did not analyse their data! 


num_subjects = length(subjects);
mat2=[];
mat= [ ];
mat3=[];
mat4=[];
P_all=[];
for Sub = 1 : num_subjects

    %% load the data here
    for block = 1 : 4
        clear sc
        clear stats_combined
        dataFile = ['S',num2str(subjects(Sub)) '_MDSLTest_B' num2str(block)];
        load(dataFile);
            att_chars = data.atts;
    math_att = att_chars(1,:);
    mem_att = att_chars(2,:);
    ptrn_att = att_chars(3,:);
    

    
    %%

        %% correct percentage
        prop_correct(1,block) = length(find(data.outcome(:,1) == data.outcome(:,2)))/63;

        %%%%%% prepare attributes here
        t_d = data.output_test;
        for trial= 1:63
            %%%%% find who was selected
            %% Column 1: Domain
        
            ind1 = t_d(trial,3);
            ind2 = t_d(trial,4);
            %% 
            %% 6: which was first character
            ind1 = t_d(trial,6);
            if ind1 == t_d(trial,3)
                ind2 = t_d(trial,4);
            else
                ind2 = t_d(trial,3);
            end
            
            
            %% 14: selected character
            %% 13: RT
            ind_sel = t_d(trial,14);
            if ind1 == ind_sel
                choice(trial,1) = 1;
            else
                choice(trial,1) = 0;
            end
            %%%% continue here
            if t_d(trial,1) == 1
                rel(trial,1) = math_att(ind1)-math_att(ind2);
                irel(trial,1) = mem_att(ind1)-mem_att(ind2) + ptrn_att(ind1)-ptrn_att(ind2);
                
                irel_1(trial,1) = mem_att(ind1)-mem_att(ind2);
                irel_2(trial,1) = ptrn_att(ind1)-ptrn_att(ind2);

            elseif t_d(trial,1) == 2
                rel(trial,1) = mem_att(ind1)-mem_att(ind2);
                irel(trial,1) = math_att(ind1)-math_att(ind2) + ptrn_att(ind1)-ptrn_att(ind2);
                
                irel_1(trial,1) = math_att(ind1)-math_att(ind2);
                irel_2(trial,1) = ptrn_att(ind1)-ptrn_att(ind2);
                
            elseif t_d(trial,1) == 3
                rel(trial,1) = ptrn_att(ind1)-ptrn_att(ind2);
                irel(trial,1) = math_att(ind1)-math_att(ind2) + mem_att(ind1)-mem_att(ind2);
                
                irel_1(trial,1) = math_att(ind1)-math_att(ind2);
                irel_2(trial,1) = mem_att(ind1)-mem_att(ind2);
            end
            if abs(irel_1(trial,1))> abs(irel_2(trial,1))
                irel_max(trial,1) = irel_1(trial,1);
                irel_min(trial,1) = irel_2(trial,1);
            else
                irel_min(trial,1) = irel_1(trial,1);
                irel_max(trial,1) = irel_2(trial,1);
            end
        end


        
        mat = [mat; choice (rel) (irel) block*ones(length(choice),1) Sub*ones(length(choice),1)];
         mat4 = [mat4; choice (rel) (irel_max) (irel_min) block*ones(length(choice),1) Sub*ones(length(choice),1)];
        
       [h,p] = corr(rel,irel);
       P_all(end+1) = h;
    end
accuracy(Sub,1) = mean(prop_correct);
end
mat(:,4) = zscore(mat(:,4));


tr = find(sign(mat(:,2)) ~= sign(mat(:,3)) & abs(mat(:,2))<.3);
 tbl = table(mat(:,1),mat(:,2),mat(:,3), mat(:,4),mat(:,5), 'VariableNames',{'ch','rel_dif','irel_dif','block','s'});

   
   altlme = fitlme(tbl,'ch~rel_dif * irel_dif*block','CheckHessian',true)
 lme = fitlme(tbl,'ch~rel_dif *block')
results = compare(lme,altlme)



%% alternative with max and min
tbl = table(mat4(:,1),zscore(mat4(:,2)),zscore(mat4(:,3)), zscore(mat4(:,4)),mat4(:,5),mat4(:,6), 'VariableNames',{'ch','rel_dif','irel_max','irel_min','block','s'});
 altlme2 = fitlme(tbl,'ch~rel_dif * irel_max*irel_min*block','CheckHessian',true)
 results = compare(altlme,altlme2)
 %%
 

 tbl = table(mat4(tr,1),mat4(tr,2)+mat4(tr,3)+mat4(tr,4),mat4(tr,5),mat4(tr,6), 'VariableNames',{'ch','all_d','block','s'});
  altlme3 = fitlme(tbl,'ch~all_d *block','CheckHessian',true)
  results = compare(lme,altlme3)
  results = compare(altlme3,altlme)

 ci = coefCI(altlme);
 
 figure
coef_ch = [altlme.Coefficients.Estimate(2) altlme.Coefficients.Estimate(3) altlme.Coefficients.Estimate(5)];
CIlow=[ci(2,1) ci(3,1) ci(5,1)];
CIhigh = [ci(2,2) ci(3,2) ci(5,2)];
x =1:2:6;
b= bar(x,coef_ch,.35,'FaceColor',[127,0,191]/256,'EdgeColor','none','LineWidth',1.5);
b.FaceColor = 'flat';

hold on
for coef = 1 : 3
    y = CIlow(1,coef):.01:CIhigh(1,coef);    
    h = plot(x(coef) + zeros(length(y)),y,'color',[127,0,191]/256);
    
    h(1).LineWidth = 2;
    
end


ax= gca;
ax.XTick =[];
ax.XAxis.Color = [0 0 0];
ax.YAxis.Color = 'black';
set(gca,'linewidth',1.25)
box off

set(gca,'fontsize',26)
%%
figure
coef_ch = [3544 3466 4400 4427 7971 7933];
 x =1:2:12;
 bar(x,coef_ch,.35,'FaceColor',[102, 255, 102]/256,'EdgeColor',[102, 255, 102]/256,'LineWidth',1.5);
ylim([3000 8000])

figure
coef_ch = [3544 3466];
 x =1:2:4;
 bar(x,coef_ch,.35,'FaceColor',[102, 255, 102]/256,'EdgeColor',[102, 255, 102]/256,'LineWidth',1.5);
ylim([3000 3550])
ax= gca;
ax.XTick =[];
ax.XAxis.Color = [0 0 0];
ax.YAxis.Color = 'black';
set(gca,'linewidth',1.25)
box off
ylabel('BIC ')
ax.XTick = [1 3];
ax.XTickLabel = {'simple','full'};
set(gca,'fontsize',22)
xlabel('model type')
figure
coef_ch = [4400 4427];
 x =1:2:4;
 bar(x,coef_ch,.35,'FaceColor',[102, 255, 102]/256,'EdgeColor',[102, 255, 102]/256,'LineWidth',1.5);
ylim([4350 4450])
ax= gca;
ax.XTick =[];
ax.XAxis.Color = [0 0 0];
ax.YAxis.Color = 'black';
set(gca,'linewidth',1.25)
box off
ylabel('BIC ')
ax.XTick = [1 3];
ax.XTickLabel = {'simple','full'};
set(gca,'fontsize',22)
xlabel('model type')
figure
coef_ch = [7971 7933];
 x =1:2:4;
 bar(x,coef_ch,.35,'FaceColor',[102, 255, 102]/256,'EdgeColor',[102, 255, 102]/256,'LineWidth',1.5);
ylim([7900 8000])


ax= gca;
ax.XTick =[];
ax.XAxis.Color = [0 0 0];
ax.YAxis.Color = 'black';
set(gca,'linewidth',1.25)
box off
ylabel('BIC ')
ax.XTick = [1 3];
ax.XTickLabel = {'simple','full'};
set(gca,'fontsize',22)
xlabel('model type') 
%%

%% incongruent trials
mat_lmm = mat;
tr = find(sign(mat(:,2)) ~= sign(mat(:,3)) & abs(mat(:,2))>.3); %% .3 is the difficulty threshold. change to <.3 for hard trials
matic= [mat_lmm(tr,:)];

a0 = matic(:,2)-mean(matic(:,2));
proj_a0a2 = (dot(matic(:,3),a0)/dot(a0,a0)).*a0;
matic(:,3) = matic(:,3) - proj_a0a2;



tbl = table(matic(:,1),zscore(matic(:,2)),zscore(matic(:,3)), matic(:,4),matic(:,5), 'VariableNames',{'ch','rel_dif','irel_dif','block','s'});
lmic = fitlme(tbl,'ch~rel_dif * irel_dif*block','CheckHessian',true)
altlmic = fitlme(tbl,'ch~rel_dif *block','CheckHessian',true)

results = compare(altlmic,lmic)
 anova(lmic,'DFMethod','Satterthwaite')
 
%% congruent trials
mat_lmm = mat;
clear tr t_c
tr = find(sign(mat(:,2)) == sign(mat(:,3)) & abs(mat(:,2))>.3); %% .3 is the difficulty threshold. change to <.3 for hard trials
matc= [mat_lmm(tr,:)];

a0 = matc(:,2)-mean(matc(:,2));
proj_a0a2 = (dot(matc(:,3),a0)/dot(a0,a0)).*a0;
matc(:,3) = matc(:,3) - proj_a0a2;

tbl = table(matc(:,1),zscore(matc(:,2)),zscore(matc(:,3)), matc(:,4),matc(:,5), 'VariableNames',{'ch','rel_dif','irel_dif','block','s'});
lmc = fitlme(tbl,'ch~rel_dif * irel_dif*block','CheckHessian',true)

altlmc = fitlme(tbl,'ch~rel_dif *block','CheckHessian',true)

results = compare(altlmc,lmc)

 anova(lmc,'DFMethod','Satterthwaite') 

 CI_ic = coefCI(lmic);
%%
 CI_c = coefCI(lmc);
 
 
 figure
coef_ch = [lmc.Coefficients.Estimate(2) lmic.Coefficients.Estimate(2) lmc.Coefficients.Estimate(3) lmic.Coefficients.Estimate(3)];
CIlow=[CI_c(2,1) CI_ic(2,1) CI_c(3,1)  CI_ic(3,1)];
CIhigh = [CI_c(2,2) CI_ic(2,2) CI_c(3,2)  CI_ic(3,2)];
x =[1 1.5 2.5 3];
b= bar(x,coef_ch,.8,'FaceColor',[31 252 130]./255,'EdgeColor','none','LineWidth',1.5);
b.FaceColor = 'flat';
b.CData(2,:) = [252 56 31]./255;
b.CData(4,:) = [252 56 31]./255;
hold on
for coef = 1 : 4
    y = CIlow(1,coef):.01:CIhigh(1,coef);
    if mod(coef,2)
    h = plot(x(coef) + zeros(length(y)),y,'color',[31 252 130]./255);
    else
        h = plot(x(coef) + zeros(length(y)),y,'color',[252 56 31]./255);
    end
    h(1).LineWidth = 2;
    
end


ax= gca;
ax.XTick =[];
ax.XAxis.Color = [0 0 0];
ax.YAxis.Color = 'black';
set(gca,'linewidth',1.25)
box off
%ylabel('effect on choice ')
ax.XTick = [1.25 2.75];
ax.XTickLabel = {'',''};
set(gca,'fontsize',26)
%xlabel('coefficient') 
ylim([-.1 .5])



