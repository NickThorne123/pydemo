 clc; clear all; close all
subjects = [3 4 5 6 7 8 9 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33];
%subjects = [3 4 5 6 7 8 11 12 13 14 15 16 17 18 19 20 21 22 23 24 26 27 28 29 30 31 32 33];
%subjects = [3 8 11 12 13 17 19 20 22 23 24 27 30 32 33];
%subjects = [4 5 6 7 9 14 15 16 18 21 25 26 28 29 31];
%subjects=[3,8,11,12,13,17,19,20,22,24,27,30,32,33];
%subjects=[4,5,6,7,14,15,16,18,21,23,26,28,29,31];
num_subjects = length(subjects);
mat2=[];
mat= [ ];
mat3=[];
for Sub = 1 : num_subjects
    %% load the domain scores here
%     load atts_new;
%     att_chars = atts_new{5};
%     math_att = att_chars(1,:);
%     mem_att = att_chars(2,:);
%     ptrn_att = att_chars(3,:);
    %% load the data here
        clear sc
        clear stats_combined
        dataFile = ['S',num2str(subjects(Sub)) '_MDSLTraining_fmri.mat'];
        load(dataFile);
            att_chars = data.atts;
    math_att = att_chars(1,:);
    mem_att = att_chars(2,:);
    ptrn_att = att_chars(3,:);
    %% math
    [h,rank_math] = sort(math_att);
    
    for ch = 1 : 7
            math_att_r(ch,1) = find(rank_math==ch);
    end
    
    %% mem
    
      [h,rank_mem] = sort(mem_att);
    
    for ch = 1 : 7
            mem_att_r(ch,1) = find(rank_mem==ch);
    end
    
    %% ptrn
          [h,rank_ptrn] = sort(ptrn_att);
    
    for ch = 1 : 7
            ptrn_att_r(ch,1) = find(rank_ptrn==ch);
    end
    %%
    %math_att = math_att_r;
    %mem_att = mem_att_r;
    %ptrn_att = ptrn_att_r;
        %% correct percentage
        prop_correct(Sub,1) = length(find(data.outcome(:,1) == data.outcome(:,2)))/63;
        %% conduct the main logistic regression (choice vs atrributes here)
        %ind1 = data.output_test(:,3); ind2 = data.output_test(:,4);
        %att = data.output_test(:,1);
        %choice = data.output_test(:,14);
        %%%%%% prepare attributes here
        t_d = data.output_test;
        for trial= 1:63
            %%%%% find who was selected
            ind1 = t_d(trial,3);
            ind2 = t_d(trial,4);
            %% 
            ind1 = t_d(trial,6);
            if ind1 == t_d(trial,3)
                ind2 = t_d(trial,4);
            else
                ind2 = t_d(trial,3);
            end
            
            
            
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

            elseif t_d(trial,1) == 2
                rel(trial,1) = mem_att(ind1)-mem_att(ind2);
                irel(trial,1) = math_att(ind1)-math_att(ind2) + ptrn_att(ind1)-ptrn_att(ind2);
                
            elseif t_d(trial,1) == 3
                rel(trial,1) = ptrn_att(ind1)-ptrn_att(ind2);
                irel(trial,1) = math_att(ind1)-math_att(ind2) + mem_att(ind1)-mem_att(ind2);
            end
            
        end
        %%
  [b,dev] = glmfit([zscore(rel) zscore(irel)  zscore(rel).*zscore(irel)],choice,'binomial','link','logit'); 
  %[b,dev] = glmfit([zscore(rel)],choice,'binomial','link','logit');
  b_rel(Sub,1) = b(2);
  b_irel(Sub,1) = b(3);
  %b_interac(Sub,block) = b(4);
  b_quad(Sub,1) = b(4);
  Dev(Sub,1) = dev;      
%%

        
        %mat = [mat; choice zscore(rel) zscore(irel) Sub*ones(length(choice),1)];
        mat = [mat; t_d(:,13) zscore(rel) zscore(irel) Sub*ones(length(choice),1)];
         mat3 = [mat3; t_d(:,13) zscore(rel +irel) Sub*ones(length(choice),1)];

end

 %tbl = table(mat(:,1),mat(:,2),mat(:,3), mat(:,4), 'VariableNames',{'ch','rel_dif','irel_dif','s'});
  %lme = fitglme(tbl,'ch~rel_dif * irel_dif +(1+rel_dif * irel_dif|s)','Distribution','Binomial','Link','logit')

  
 tbl = table(mat(:,1),mat(:,2),mat(:,3), mat(:,4), 'VariableNames',{'ch','rel_dif','irel_dif','s'});
  lme = fitglme(tbl,'ch~rel_dif * irel_dif +(1+rel_dif * irel_dif|s)')
  
  tbl = table(mat3(:,1),mat3(:,2),mat(:,3),  'VariableNames',{'ch','all','s'});
  lme = fitglme(tbl,'ch~all +(1+all|s)')
  
 %tbl = table(mat2(:,1),mat2(:,2),mat2(:,3), mat2(:,4),mat2(:,5),mat2(:,6), 'VariableNames',{'ch','rel','irel','quad_rel','quad_irel','s'});
  %lme = fitglme(tbl,'ch~rel*irel*quad_rel*quad_irel +(1+rel*irel*quad_rel*quad_irel|s)','Distribution','Binomial','Link','logit')
  %lme = fitglme(tbl,'ch~rel + irel + interac+(1+rel + irel + interac|s)','Distribution','Binomial','Link','logit')
  
  %altlme = fitglme(tbl,'ch~rel+ irel+interac+quad_irel +(1+rel+ irel+interac+quad_irel|s)','Distribution','Binomial','Link','logit')

   %tbl = table(mat3(:,1),mat3(:,2),mat3(:,3), mat3(:,4), 'VariableNames',{'ch','rel_dif','irel_dif','s'});
 % lme = fitglme(tbl,'ch~rel_dif * irel_dif +(1+rel_dif * irel_dif|s)','Distribution','Binomial','Link','logit')
%results = compare(lme,altlme)
  
  
  figure
coef_ch = [.11 -.14 .01];
 CI=[.21 .16 .12];
x =1:2:6;
bar(x,coef_ch,.35,'FaceColor',[138,43,226]/256,'EdgeColor',[138,43,226]/256,'LineWidth',1.5);
hold on
for coef = 1 : 3
    y = coef_ch(1,coef)-CI(1,coef):.01:coef_ch(1,coef)+CI(1,coef);
    h = plot(x(coef) + zeros(length(y)),y,'color',[138,43,226]/256);
    h(1).LineWidth = 2;
end

ax= gca;
ax.XTick =[];
ax.XAxis.Color = [0 0 0];
ax.YAxis.Color = 'black';
set(gca,'linewidth',1.25)
box off
ylabel('Effect on choice ')
ax.XTick = [1 3 5];
ax.XTickLabel = {'relevant','irrelevant','interaction'};
set(gca,'fontsize',22)


