clc; clear all; close all
%% this script train participants
%%%% explain the structure of the code here
%%%% AliM. Sept 2019
%% collect participant's unidentifiable data
data.individual.id = input('Subject Id: ')
data.individual.age = input('Subject age: ')
data.individual.jender =  input('male or female: ', 's')
resultFileName  =  ['S', int2str(data.individual.id) , '_MDSLTraining_fMRI' ];
data.output_training = [];
data.output_test = [];
data.outcome=[];
data.output_feedbackTime = [];
%% specify atrribute values here
%% change this part later and use the recently generated attributes
load atts_new;
att_chars = atts_new{1};
math_att = att_chars(1,:);
mem_att = att_chars(2,:);
ptrn_att = att_chars(3,:);
data.atts = att_chars;
load img_rnd
image_rand = img_rnd(data.individual.id,:);   %%% randomize images of the actors
data.actors_image = image_rand;
test_block_counter = 1;
%% construct characters' position in the test session here-Math
load Mat.mat
%% open screen
Screen('Preference', 'SkipSyncTests', 1);
sca
PsychDefaultSetup(2);
screens = Screen('Screens');
screenNumber = max(screens);
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;
%grey = [170/256 170/256 170/256];
[w, windowRect] = PsychImaging('OpenWindow', screenNumber, white,[0 0 1100 1100]);
%[w, windowRect] = PsychImaging('OpenWindow', screenNumber, white);
[x_center, y_center] = RectCenter(windowRect);
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
[screenXpixels, screenYpixels] = Screen('WindowSize', w);
Screen('TextSize', w , 20);
Screen('TextFont', w, 'Times');
KbName('UnifyKeyNames');
SpaceKey = KbName('Space');
%% start the exp
num_blocks = 1;  %%%% should be 2
num_miniblocks = 1;  %% identical to # attributes
num_trials = 1;   %%% should be 2
num_indivduals = 1;  %%%% should be 7
num_rep_per_att = 1;  %%%% number of repetition per attribute; 3
for block = 1:num_blocks
    order_atts = randperm(3);%%% 1 is math, 2 is memory, 3 is problem solving
    if block <2
        for minib = 1 : num_miniblocks %% should be three, equal to number of attitudes
            for rep_att = 1 : num_rep_per_att
                order_ind = randperm(length(mem_att)); %%% order of showing individuals
                for ind = 1 : num_indivduals
                    for trial = 1 : num_trials
                        clear temp_output;
                        temp_output(1,1) = order_atts(minib);
                        temp_output(1,2) = order_ind(ind);
                        temp_output(1,3) = image_rand(order_ind(ind));
                        %% image of the relevant individual
                        if data.individual.jender == 'm'
                            FileName = [ 'M' int2str(image_rand(order_ind(ind))) '.png'];
                        elseif data.individual.jender == 'f'
                            FileName = [ 'F' int2str(image_rand(order_ind(ind))) '.png'];
                        end
                        theImage = imread(FileName);
                        [s1, s2, s3] = size(theImage);
                        aspectRatio = s2 / s1;
                        heightScalers = .3;
                        imageHeights = screenYpixels .* heightScalers;
                        imageWidths = imageHeights .* aspectRatio;
                        imageHeights = 259;
                        imageWidths = 216;
                        theRect = [0 0 imageWidths imageHeights];
                        dstRects = CenterRectOnPointd(theRect, x_center,y_center+50);
                        imageTexture = Screen('MakeTexture', w, theImage);
                        %%
                        t = GetSecs;
                        Rect_mouse = 0;
                        click  = 0;
                        b = 0;
                        baseRect = [0 0 1050 500];
                        centeredRect = CenterRectOnPointd(baseRect, x_center, y_center+50);
                        loc_lines=0:10:100;
                        while ~ click
                            Screen('TextSize', w , 30);
                            if order_atts(minib) == 1
                                Screen('FillRect', w ,[255/255 204/255 204/255])
                                Screen('DrawText', w,'Math' , x_center-30 , y_center-150, [0 0 0]);
                                Screen('TextSize', w , 20);
                                num = 0:.10:1;
                                for i= 1:11
                                    Screen('DrawText', w,  num2str(num(i)) , 9*loc_lines(i)+x_center-460 , y_center+210, [0 0 0]);
                                end
                            elseif order_atts(minib) == 2
                                Screen('FillRect', w ,[224/255 255/255 255/255])
                                Screen('DrawText', w,'Memory  ' , x_center-50 , y_center-150, [0 0 0]);
                                Screen('TextSize', w , 20);
                                num = 0:1:10;
                                for i= 1:11
                                    Screen('DrawText', w,  num2str(num(i)) , 9*loc_lines(i)+x_center-455 , y_center+210, [0 0 0]);
                                end
                            elseif order_atts(minib) == 3
                                Screen('FillRect', w ,[224/255 255/255 102/255])
                                Screen('DrawText', w,'Problem solving  ' , x_center-80 , y_center-150, [0 0 0]);
                                Screen('TextSize', w , 20);
                                num = 0:10:100;
                                for i= 1:11
                                    Screen('DrawText', w,  num2str(num(i)) , 9*loc_lines(i)+x_center-460 , y_center+210, [0 0 0]);
                                end
                            end
                            for i = 1:11
                                Screen('DrawLine',w ,black, 9*loc_lines(i)+x_center - 450, y_center + 195,  9*loc_lines(i)+x_center - 450, y_center + 205, 3);
                            end
                            Screen('FrameRect', w, [0 0 0], centeredRect,4);
                            Screen('DrawTextures', w, imageTexture, [], dstRects);
                            Screen('DrawLine',w ,black, x_center - 450, y_center + 200,  x_center + 450, y_center + 200, 5);
                            [x,y,b] = GetMouse;
                            Screen('FillOval',w,[0 0 255], [x y x+20 y+20]);
                            %% determine the position of the mouse
                            P = x - (x_center - 450);
                            P = round(P/9,2);
                            Screen('TextSize', w , 40);
                            if x > x_center - 450 && x < x_center + 459 && y < y_center + 210 && y > y_center + 180
                                if b(1) == 1
                                    click = 1;
                                end
                            end
                            Screen(w,'Flip');
                            HideCursor;
                        end
                        temp_output(1,5) = GetSecs - t;
                        temp_output(1,4) = P;
                        %% feedback section
                        if order_atts(minib) == 1
                            feedb = normrnd(math_att(order_ind(ind)),.02);
                        elseif order_atts(minib) == 2
                            feedb = normrnd(mem_att(order_ind(ind)),.02);
                        elseif order_atts(minib) == 3
                            feedb = normrnd(ptrn_att(order_ind(ind)),.02);
                        end
                        temp_output(1,6) = feedb;
                        feedb = feedb*100;
                        t = GetSecs;
                        %% show feedback
                        space_key = 0;
                        %while space_key == 0
                        while GetSecs - t<3   %%% feedback should be 3
                            Screen('DrawLine',w ,black, x_center - 450, y_center + 200,  x_center + 450, y_center + 200, 5);
                            Screen('FillOval',w,[0 0 255], [x y x+20 y+20]);
                            Screen('FillOval',w,[0 153/255 76/255], [9*feedb+x_center-450 y_center+190 9*feedb+x_center-430 y_center+210]);
                            Screen('DrawTextures', w, imageTexture, [], dstRects);
                            if order_atts(minib) == 1
                                Screen('TextSize', w , 30);
                                Screen('DrawText', w,'Math' , x_center-30 , y_center-150, [0 0 0]);
                                Screen('TextSize', w , 20);
                                num = 0:.10:1;
                                for i= 1:11
                                    Screen('DrawText', w,  num2str(num(i)) , 9*loc_lines(i)+x_center-460 , y_center+210, [0 0 0]);
                                end
                            elseif order_atts(minib) == 2
                                Screen('TextSize', w , 30);
                                Screen('DrawText', w,'Memory' , x_center-50 , y_center-150, [0 0 0]);
                                Screen('TextSize', w , 20);
                                num = 0:1:10;
                                for i= 1:11
                                    Screen('DrawText', w,  num2str(num(i)) , 9*loc_lines(i)+x_center-455 , y_center+210, [0 0 0]);
                                end
                            elseif order_atts(minib) == 3
                                Screen('TextSize', w , 30);
                                Screen('DrawText', w,'Problem solving' , x_center-80 , y_center-150, [0 0 0]);
                                Screen('TextSize', w , 20);
                                num = 0:10:100;
                                for i= 1:11
                                    Screen('DrawText', w,  num2str(num(i)) , 9*loc_lines(i)+x_center-460 , y_center+210, [0 0 0]);
                                end
                            end
                            for i = 1:11
                                Screen('DrawLine',w ,black, 9*loc_lines(i)+x_center - 450, y_center + 195,  9*loc_lines(i)+x_center - 450, y_center + 205, 3);
                            end
                            Screen('FrameRect', w, [0 0 0], centeredRect,4);
                            Screen(w,'Flip');
                            %HideCursor;
                            [keyIsDown,secs,keyCode] = KbCheck;
                            if keyCode(SpaceKey)
                                space_key = 1;
                            end
                        end
                        data.output_training(end+1,:) = temp_output;
                        save(resultFileName,'data');
                    end
                end
            end
        end
        %% interleaved training phase
        %%% if you occured to be here, I know it's stupid to repeat the
        %%% whole thing again for new blocks, but it was not originaly the
        %%% plan and I had to change the whole structure to make it cleverer. Dan is to blame!
    elseif block >1
        rep_per_block = 2;
        for rep = 1 : rep_per_block
            att_ToTrain = repmat([1;2;3],7,1);
            charac = repelem([1:7],3)';
            shuf = randperm(length(att_ToTrain));
            att_ToTrain = att_ToTrain(shuf);
            charac = charac(shuf);
            for trial = 1 : length(att_ToTrain)
                clear temp_output;
                temp_output(1,1) = att_ToTrain(trial);
                temp_output(1,2) = charac(trial);
                temp_output(1,3) = image_rand(charac(trial));
                %% image of the relevant individual
                
                if data.individual.jender == 'm'
                    FileName = [ 'M' int2str(image_rand(charac(trial))) '.png'];
                elseif data.individual.jender == 'f'
                    FileName = [ 'F' int2str(image_rand(charac(trial))) '.png'];
                end
                theImage = imread(FileName);
                [s1, s2, s3] = size(theImage);
                aspectRatio = s2 / s1;
                heightScalers = .3;
                imageHeights = screenYpixels .* heightScalers;
                imageWidths = imageHeights .* aspectRatio;
                imageHeights = 259;
                imageWidths = 216;
                theRect = [0 0 imageWidths imageHeights];
                dstRects = CenterRectOnPointd(theRect, x_center,y_center+50);
                imageTexture = Screen('MakeTexture', w, theImage);
                %%
                t = GetSecs;
                Rect_mouse = 0;
                click  = 0;
                b = 0;
                baseRect = [0 0 1050 500];
                centeredRect = CenterRectOnPointd(baseRect, x_center, y_center+50);
                loc_lines=0:10:100;
                while ~ click
                    Screen('TextSize', w , 30);
                    if att_ToTrain(trial) == 1
                        Screen('FillRect', w ,[255/255 204/255 204/255])
                        Screen('DrawText', w,'Math' , x_center-30 , y_center-150, [0 0 0]);
                        Screen('TextSize', w , 20);
                        num = 0:.10:1;
                        for i= 1:11
                            Screen('DrawText', w,  num2str(num(i)) , 9*loc_lines(i)+x_center-460 , y_center+210, [0 0 0]);
                        end
                    elseif att_ToTrain(trial) == 2
                        Screen('FillRect', w ,[224/255 255/255 255/255])
                        Screen('DrawText', w,'Memory  ' , x_center-50 , y_center-150, [0 0 0]);
                        Screen('TextSize', w , 20);
                        num = 0:1:10;
                        for i= 1:11
                            Screen('DrawText', w,  num2str(num(i)) , 9*loc_lines(i)+x_center-455 , y_center+210, [0 0 0]);
                        end
                    elseif att_ToTrain(trial) == 3
                        Screen('FillRect', w ,[224/255 255/255 102/255])
                        Screen('DrawText', w,'Problem solving  ' , x_center-80 , y_center-150, [0 0 0]);
                        Screen('TextSize', w , 20);
                        num = 0:10:100;
                        for i= 1:11
                            Screen('DrawText', w,  num2str(num(i)) , 9*loc_lines(i)+x_center-460 , y_center+210, [0 0 0]);
                        end
                    end
                    for i = 1:11
                        Screen('DrawLine',w ,black, 9*loc_lines(i)+x_center - 450, y_center + 195,  9*loc_lines(i)+x_center - 450, y_center + 205, 3);
                    end
                    Screen('FrameRect', w, [0 0 0], centeredRect,4);
                    Screen('DrawTextures', w, imageTexture, [], dstRects);
                    Screen('DrawLine',w ,black, x_center - 450, y_center + 200,  x_center + 450, y_center + 200, 5);
                    [x,y,b] = GetMouse;
                    Screen('FillOval',w,[0 0 255], [x y x+20 y+20]);
                    %% determine the position of the mouse
                    P = x - (x_center - 450);
                    P = round(P/9,2);
                    Screen('TextSize', w , 40);
                    if x > x_center - 450 && x < x_center + 459 && y < y_center + 210 && y > y_center + 180
                        if b(1) == 1
                            click = 1;
                        end
                    end
                    Screen(w,'Flip');
                    HideCursor;
                end
                temp_output(1,5) = GetSecs - t;
                temp_output(1,4) = P;
                %% feedback section
                if att_ToTrain(trial) == 1
                    feedb = normrnd(math_att(charac(trial)),.02);
                elseif att_ToTrain(trial) == 2
                    feedb = normrnd(mem_att(charac(trial)),.02);
                elseif att_ToTrain(trial) == 3
                    feedb = normrnd(ptrn_att(charac(trial)),.02);
                end
                temp_output(1,6) = feedb;
                feedb = feedb*100;
                t = GetSecs;
                %% show feedback
                space_key = 0;
                while GetSecs - t<3 %%% should be 3
                    Screen('DrawLine',w ,black, x_center - 450, y_center + 200,  x_center + 450, y_center + 200, 5);
                    Screen('FillOval',w,[0 0 255], [x y x+20 y+20]);
                    Screen('FillOval',w,[0 153/255 76/255], [9*feedb+x_center-450 y_center+190 9*feedb+x_center-430 y_center+210]);
                    Screen('DrawTextures', w, imageTexture, [], dstRects);
                    if att_ToTrain(trial) == 1
                        Screen('TextSize', w , 30);
                        Screen('DrawText', w,'Math' , x_center-30 , y_center-150, [0 0 0]);
                        Screen('TextSize', w , 20);
                        num = 0:.10:1;
                        for i= 1:11
                            Screen('DrawText', w,  num2str(num(i)) , 9*loc_lines(i)+x_center-460 , y_center+210, [0 0 0]);
                        end
                    elseif att_ToTrain(trial) == 2
                        Screen('TextSize', w , 30);
                        Screen('DrawText', w,'Memory' , x_center-50 , y_center-150, [0 0 0]);
                        Screen('TextSize', w , 20);
                        num = 0:1:10;
                        for i= 1:11
                            Screen('DrawText', w,  num2str(num(i)) , 9*loc_lines(i)+x_center-455 , y_center+210, [0 0 0]);
                        end
                    elseif att_ToTrain(trial) == 3
                        Screen('TextSize', w , 30);
                        Screen('DrawText', w,'Problem solving' , x_center-80 , y_center-150, [0 0 0]);
                        Screen('TextSize', w , 20);
                        num = 0:10:100;
                        for i= 1:11
                            Screen('DrawText', w,  num2str(num(i)) , 9*loc_lines(i)+x_center-460 , y_center+210, [0 0 0]);
                        end
                    end
                    for i = 1:11
                        Screen('DrawLine',w ,black, 9*loc_lines(i)+x_center - 450, y_center + 195,  9*loc_lines(i)+x_center - 450, y_center + 205, 3);
                    end
                    Screen('FrameRect', w, [0 0 0], centeredRect,4);
                    Screen(w,'Flip');
                    %HideCursor;
                    [keyIsDown,secs,keyCode] = KbCheck;
                    if keyCode(SpaceKey)
                        space_key = 1;
                    end
                end
                data.output_training(end+1,:) = temp_output;
                save(resultFileName,'data');
            end
        end
    end
    %% test session after each training round
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% make jitters and itis here
    if block == 1
        pd = makedist('Normal');
        pd.mu = 3.7;
        pd_t = truncate(pd,3,5);
        ITIs = random(pd_t,100,1);
        Jitters = random(pd_t,100,1);
        Test_coun = nan(6,6,3); %% first dimension is math, sec is mem and etc.
        for i = 1:6
            Test_coun(i,i:end,:) = 0;
        end
        att_ToTest = repelem([1;2;3],21);
        att_ToTest = att_ToTest(randperm(length(att_ToTest)));
        num_test_trials = 2;  %%%%%% should be changed to length(att_ToTest) 63
        clear resp_test;
        resp_test=[];
        for Trial = 1:num_test_trials
            
            clear temp_output;
            %% choose two individuals for comparison att_ToTest
            temp_output(1,1) = att_ToTest(Trial);
            all_poss = find (Test_coun(:,:,att_ToTest(Trial))==0);
            IndsToPair = all_poss(unidrnd(length(all_poss)));
            temp_output(1,2) = IndsToPair;
            ind1 = IndsToPair/6;
            if floor(ind1) ~= ind1
                ind1 = floor(ind1)+2;
            else
                ind1 = floor(ind1)+1;
            end
            temp_output(1,3) = ind1;
            ind2 = mod(IndsToPair,6);
            if ind2 == 0
                ind2 = 6;
            end
            temp_output(1,4) = ind2;
            %%%%% mark the tested ones
            temp = Test_coun(:,:,att_ToTest(Trial));
            temp(IndsToPair ) = 1;
            Test_coun(:,:,att_ToTest(Trial)) =temp; clear temp
            %% prepare their images here
            if data.individual.jender == 'm'
                FileName = [ 'M' int2str(image_rand(ind1)) '.png'];
            elseif data.individual.jender == 'f'
                FileName = [ 'F' int2str(image_rand(ind1)) '.png'];
            end
            theImage_ind1 = imread(FileName);
            [s1, s2, s3] = size(theImage_ind1);
            aspectRatio = s2 / s1;
            heightScalers = .3;
            imageHeights = screenYpixels .* heightScalers;
            imageWidths = imageHeights .* aspectRatio;
            imageHeights = 259;
            imageWidths = 216;
            theRect_ind1 = [0 0 imageWidths imageHeights];
            if mod(Trial,2) == 1
                dstRects_ind1 = CenterRectOnPointd(theRect_ind1, x_center-170,y_center-50);
            else
                dstRects_ind1 = CenterRectOnPointd(theRect_ind1, x_center+170,y_center-50);
            end
            imageTexture_ind1 = Screen('MakeTexture', w, theImage_ind1);
            %%%%%%%%% ind2
            if data.individual.jender == 'm'
                FileName = [ 'M' int2str(image_rand(ind2)) '.png'];
            elseif data.individual.jender == 'f'
                FileName = [ 'F' int2str(image_rand(ind2)) '.png'];
            end
            theImage_ind2 = imread(FileName);
            [s1, s2, s3] = size(theImage_ind2);
            aspectRatio = s2 / s1;
            heightScalers = .3;
            imageHeights = screenYpixels .* heightScalers;
            imageWidths = imageHeights .* aspectRatio;
            imageHeights = 259;
            imageWidths = 216;
            theRect_ind2 = [0 0 imageWidths imageHeights];
            if mod(Trial,2) == 1
                dstRects_ind2 = CenterRectOnPointd(theRect_ind2, x_center+170,y_center-50);
            else
                dstRects_ind2 = CenterRectOnPointd(theRect_ind2, x_center-170,y_center-50);
            end
            imageTexture_ind2 = Screen('MakeTexture', w, theImage_ind2);
            Rkey = KbName('RightArrow');
            Lkey = KbName('LeftArrow');
            fir_key = KbName('1!');
            sec_key = KbName('2@');
            background_color=[255/255 204/255 204/255;224/255 255/255 255/255;224/255 255/255 102/255];
            atts={'Mathematics','Memory','Problem solving'};
            %% present the domain here for a short time
            t_domain = GetSecs;
            temp_output(1,5) = t_domain;
            while GetSecs - t_domain<1
                Screen('TextSize', w , 30);
                Screen('FillRect', w ,background_color(att_ToTest(Trial),:));
                baseRect = [0 0 700 500];
                Screen('DrawText', w,atts{att_ToTest(Trial)}, x_center-80 , y_center-235, [0 0 0]);
                centeredRect = CenterRectOnPointd(baseRect, x_center, y_center);
                
                Screen('FrameRect', w, [0 0 0], centeredRect,4);
                Screen(w,'Flip');
            end
            
            %% specify which character should be presented first
            if mod(test_block_counter,2) == 1 %%% odd block
                val_order = M_o(ind1,ind2,att_ToTest(Trial),data.individual.id);
            elseif mod(test_block_counter,2) == 0
                val_order = M_e(ind1,ind2,att_ToTest(Trial),data.individual.id);
            end
            %% save who was presented first
            if val_order == 1
                temp_output(1,6) = ind1;
            elseif val_order == 0
                temp_output(1,6) = ind2;
            end
            
            %% present character 1 here for 2 second
            dstRects_both = CenterRectOnPointd(theRect_ind1, x_center,y_center-50);
            t_FirCharac = GetSecs;
            temp_output(1,7) = t_FirCharac;
            while GetSecs - t_FirCharac < 2
                Screen('TextSize', w , 30);
                Screen('FillRect', w ,grey);
                %Screen('FillRect', w ,background_color(att_ToTest(Trial),:));
                baseRect = [0 0 700 500];
                Screen('DrawText', w,atts{att_ToTest(Trial)}, x_center-80 , y_center-235, [0 0 0]);
                centeredRect = CenterRectOnPointd(baseRect, x_center, y_center);
                
                Screen('FrameRect', w, [0 0 0], centeredRect,4);
                if val_order == 1
                    Screen('DrawTextures', w, imageTexture_ind1, [], dstRects_both);
                elseif val_order == 0
                    Screen('DrawTextures', w, imageTexture_ind2, [], dstRects_both);
                end
                Screen(w,'Flip');
            end
            %% jitter after first character
            temp_output(1,8) = GetSecs;
            jitter = Jitters(Trial);
            temp_output(1,9) = jitter;
            start_jitter = GetSecs;
            while GetSecs - start_jitter < jitter
                Screen('FillRect', w ,grey);
                Screen('TextSize', w , 100);
                Screen('DrawText', w,  '+' , x_center-50 , y_center-50, black);
                Screen(w,'Flip');
            end
            temp_output(1,10) = GetSecs;
            %% present second character now
            fir_time = 0;
            resp_reg = 0;
            t_SecCharac = GetSecs;
            right = 0; left = 0;
            temp_output(1,11) = t_SecCharac;
            while GetSecs - t_SecCharac < 2
                %Screen('FillRect', w ,background_color(att_ToTest(Trial),:));
                Screen('TextSize', w , 30);
                baseRect = [0 0 700 500];
                Screen('DrawText', w,atts{att_ToTest(Trial)}, x_center-80 , y_center-235, [0 0 0]);
                centeredRect = CenterRectOnPointd(baseRect, x_center, y_center);
                
                Screen('FrameRect', w, [0 0 0], centeredRect,4);
                if val_order == 0
                    Screen('DrawTextures', w, imageTexture_ind1, [], dstRects_both);
                elseif val_order == 1
                    Screen('DrawTextures', w, imageTexture_ind2, [], dstRects_both);
                end
                
                [keyIsDown,secs,keyCode] = KbCheck;
                if keyCode(fir_key) || keyCode(sec_key)
                    resp_reg = 1;
                end
                if keyCode(fir_key)
                    left = 1; right = 0;
                elseif keyCode(sec_key)
                    right = 1; left = 0;
                end
                if resp_reg == 1 && fir_time == 0
                    RT = GetSecs - t_SecCharac;
                    fir_time = 1;
                    
                end
                
                Screen(w,'Flip');
            end
            %%
            %% choice section
            start_t = GetSecs;
            temp_output(1,12) = start_t;            
            while GetSecs - start_t < 3.001 && resp_reg == 0
                %Screen('FillRect', w ,background_color(att_ToTest(Trial),:));
                baseRect = [0 0 700 500];
                Screen('DrawText', w,atts{att_ToTest(Trial)}, x_center-80 , y_center-235, [0 0 0]);
                centeredRect = CenterRectOnPointd(baseRect, x_center, y_center);
                Screen('TextSize', w , 30);
                Screen('FrameRect', w, [0 0 0], centeredRect,4);
                Screen('DrawText', w,'choose' ...
                    , x_center-50 , y_center, [0 0 0]);
                [keyIsDown,secs,keyCode] = KbCheck;
                if keyCode(fir_key) || keyCode(sec_key)
                    resp_reg = 1;
                end
                if keyCode(fir_key)
                left = 1; right = 0;
            elseif keyCode(sec_key)
                right = 1; left = 0;
            end
                Screen(w,'Flip');
            end
            if fir_time == 0
            RT = GetSecs - t_SecCharac;
            end
            temp_output(1,13) = RT;
            %% warning if trial was missed!
            w_t = GetSecs;
            if resp_reg == 0
                while GetSecs - w_t < .5
                    
                    Screen('DrawText', w,'too slow' ...
                        , x_center-50 , y_center, [0 0 0]);
                    Screen(w,'Flip');
                end
            elseif resp_reg == 1
                while GetSecs - w_t < .5                    
                    Screen(w,'Flip');
                end
            end
            if resp_reg == 1
                if val_order == 1 & keyCode(fir_key)
                    temp_output(1,14) = ind1;
                elseif val_order == 0 & keyCode(sec_key)
                    temp_output(1,14) = ind1;
                else
                    temp_output(1,14) = ind2;
                end
            elseif resp_reg == 0
                temp_output(1,14) = nan;
            end
            temp_output(1,15) = GetSecs;
            resp_test(Trial,1) = temp_output(1,14);          
            %% ITI
            iti = ITIs(Trial);
            temp_output(1,16) = ITIs(Trial);
            if resp_reg == 1 && left
        temp_output(1,17) = 1;
    elseif resp_reg == 1 && right
        temp_output(1,17) = 2;
    elseif resp_reg == 0
        temp_output(1,17) = nan;
    end
            start_jitter = GetSecs;
            while GetSecs - start_jitter < iti
                Screen('FillRect', w ,grey);
                Screen('TextSize', w , 100);
                Screen(w,'Flip');
            end
            data.output_test(end+1,:) = temp_output; clear temp_output
            %% summarize things here
            %%% the individual chosen by the participant
            if att_ToTest (Trial) == 1
                if math_att (ind1) > math_att (ind2)
                    resp_test(Trial,2) = ind1;
                elseif math_att (ind1) < math_att (ind2)
                    resp_test(Trial,2) = ind2;
                elseif math_att (ind1) == math_att (ind2)
                    resp_test(Trial,2) = nan;
                end
            elseif att_ToTest (Trial) == 2
                if mem_att (ind1) > mem_att (ind2)
                    resp_test(Trial,2) = ind1;
                elseif mem_att (ind1) < mem_att (ind2)
                    resp_test(Trial,2) = ind2;
                elseif mem_att (ind1) == mem_att (ind2)
                    resp_test(Trial,2) = nan;
                end
            elseif att_ToTest (Trial) == 3
                if ptrn_att (ind1) > ptrn_att (ind2)
                    resp_test(Trial,2) = ind1;
                elseif ptrn_att (ind1) < ptrn_att (ind2)
                    resp_test(Trial,2) = ind2;
                elseif ptrn_att (ind1) == ptrn_att (ind2)
                    resp_test(Trial,2) = nan;
                end
            end
            data.outcome (end+1,:) = resp_test(Trial,:);
            save(resultFileName,'data');
            %% give cumulative feedback at the end of eahc block
            
            if Trial == 63
            data.output_feedbackTime(end+1,1) = GetSecs;
            current_resps = resp_test(1:Trial,:);
            atts = att_ToTest(1:Trial);
            for i = 1:3
                n_atts = find(atts == i);
                c_r = find(current_resps(n_atts,1) == current_resps(n_atts,2));
                prop(i,1) = length(c_r)/length(n_atts);
                clear n_atts c_r
            end
            feedb_time = GetSecs;
            while GetSecs - feedb_time < 1%%% should be presented for 12 seconds
                Screen('TextSize', w , 30);
                Screen('FillRect', w ,grey);
                %%%%math
                p1 = 'you have chosen better individual in ';
                p2 = num2str(floor(prop(1,1)* 100));
                p3 = ' % of trials in the mathematics domain';
                %%%%mrmory
                p4 = num2str(floor(prop(2,1)* 100));
                p5 = ' % of trials in the memory domain';
                %%%%problem solving
                p6 = num2str(floor(prop(3,1)* 100));
                p7 = ' % of trials in the problem solving domain';
                Screen('DrawText', w,  [p1 p2 p3] , x_center-500 , y_center+100, [0 0 0]);
                Screen('DrawText', w,  [p1 p4 p5] , x_center-500 , y_center-100, [0 0 0]);
                Screen('DrawText', w,  [p1 p6 p7] , x_center-500 , y_center, [0 0 0]);
                Screen(w,'Flip');
            end
             block_change_time = GetSecs;
            while GetSecs - block_change_time < 1
                Screen('DrawText', w,  ' You will start a new block now' , x_center-200 , y_center, [0 0 0]);
                Screen(w,'Flip');
            end
            
            end
           
        end
        test_block_counter = test_block_counter +1;
    end
    
end
Screen('Close',w);
