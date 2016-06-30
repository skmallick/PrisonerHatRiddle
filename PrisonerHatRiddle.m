%--------------------------------------------------------------------------
% Author: Shahid Mallick
%
% Simulated game of the Prisoner Hat Riddle. 
%   This program poses a riddle to the user and graphically sets the scene.
%   It solves the riddle from the perspective of everyone in line to ensure the solving method works.
%   It outputs a possible answer as well as a graphical representation of the solution.
%
% To run, simply call PrisonersHatRiddle
%--------------------------------------------------------------------------

%gets user input for the number of people in the party
n=0;
prompt = 'Pick a whole number between 5 and 25, inclusive: ';
n = input(prompt);
if isempty(n) || n < 5 || n > 25
    fprintf('No problem, I''ll assign you a random number');
    n = randi([5,25],1,1);
end

%describes the riddle
fprintf('\n');
fprintf('You and your friends have been abducted by aliens. The aliens will let you go if you can pass their test...otherwise they will eat you slowly and with salt.\n');
fprintf('THE TEST: They will line you up by height (tallest in the back, shortest in front), and place a black or white hat on each of you. You must face forward, and you can''t look at your own hat. In any order, each person must say a single word: "black" or "white" to guess the color of the hat on his or her head. If you get it right, you live. If you don''t, you''re lunch. As a group, you may discuss a strategy before the aliens begin their twisted test.\n');

fprintf('\n');
fprintf('There are %d people in your party, including you.\n', n);
fprintf('An alien places a hat on everybody''s head, including yours.\n');

%reads images of a black and white hat to be displayed in random order
%blackHat = imread('http://www.agnesb.eu/media/catalog/product/cache/2/face_image/300x300/0dc2d03fe217f8c83829496872af24a0/0/4/0408GF26_000_1.jpg');
blackHat = imread('http://www.vortexoptics.com/admin/includes/thumbnail_generator.php?maxw=300&img=app_cap_ripstop_black_fr-t.jpg');
whiteHat = imread('http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=31522694');

%shrinks images so they can be displayed easily
blackHat = imresize(blackHat,0.25);
whiteHat = imresize(whiteHat,0.25);

line = randi([0,1],1,n); %random binary array. 1 = black hat, 0 = white hat

%populates a cell array with the black and white hat images
i=1;
hatCell = cell(1,n,1);
for i= 1:n
    if line(i) == 1
        hatCell{i} = blackHat;
    else
        hatCell{i} = whiteHat;
    end
    i=i+1;
end

%image of the line as seen by the tallest person
hatMat = cell2mat(hatCell); %convert cell array to matrix for easy plotting
imshow(hatMat);
xlabel('The aliens line you up in height order and place a black or white hat on each person');

%gets user answer to the riddle
question = 'If you are the tallest one in line, what do you say to ensure everyone else''s safety? Type "b" for black, "w" for white: ';
guess = input(question, 's');
while isempty(guess) || (strcmp(guess,'b') == 0 && strcmp(guess,'w') == 0)
    guess = input('You can only guess "b" or "w": ', 's');
end

%declares cell and int array to store calculated answers from everyone in line
colorCell = cell(1,n,1); 
lineAnswers = zeros(1,n,1);

hatCount = sum(line(2:n)); %number of black hats as counted by the tallest person in line
evenOdd = mod(hatCount,2); %whether the tallest person sees an odd or even number of black hats (value is 0 if even, 1 if odd)

%tests the solving method
%goes through the line and generates responses for each person depending on the tallest person's answer (evenOdd)
%evenOdd is treated as a binary toggle -- modulated depending on how many black hats the most recent respondent in line saw
for i = 1:n
    if i == 1 || i == n %tallest and shortest person have the same condition 
        if evenOdd == 1
            lineAnswers(i) = 1;
            colorCell{i} = blackHat;
        else
            lineAnswers(i) = 0;
            colorCell{i} = whiteHat;
        end
        
    elseif i<n
        blk = sum(line(i+1:n)); %number of black hats seen by person in location i
        blkEvenOdd = mod(blk,2); %whether i sees an odd or even number of hats
        
        if evenOdd == 0   
            if blkEvenOdd == 0
                lineAnswers(i) = 0;
                colorCell{i} = whiteHat;
            else
                lineAnswers(i) = 1;
                colorCell{i} = blackHat;
                evenOdd = mod(evenOdd+1,2);
            end
        else
            if blkEvenOdd == 0
                lineAnswers(i) = 1;
                colorCell{i} = blackHat;
                evenOdd = mod(evenOdd+1,2);
            else
                lineAnswers(i) = 0;
                colorCell{i} = whiteHat;
            end
        end
    end    
end

colorMat = cell2mat(colorCell); %convert cell array to matrix for easy plotting

%ouputs solution
fprintf('\n');
fprintf('If you assigned a meaning to the words "white" or "black", e.g. "black" if you see an odd number of black hats - congratulations! Based on your answer, everyone else in line was able to correctly identify the hat that they were wearing.\n');
fprintf('\n');

%shows the original line and calculated line next to each other so the user can compare and see that the solving method works
figure
subplot(2,1,1), imshow(hatMat);
xlabel('Original Configuration');
subplot(2,1,2), imshow(colorMat);
xlabel('Possible Answer (e.g. if "black" means "odd number of black hats")');

%explanation
evenOdd = mod(hatCount,2);
if line(1) == 1 && evenOdd == 1
    fprintf('In our example, "black" meant an odd number of black hats and "white" meant an even number of black hats. Since the tallest person was wearing a black hat AND she saw an odd number of black hats, everyone is saved! Hooray!\n');
elseif line(1) == 1 && evenOdd == 0
    fprintf('In our example, "black" meant an odd number of black hats and "white" meant an even number of black hats. Since the tallest person was wearing a black hat BUT she saw an even number of black hats, she sacrificed herself for the greater good. o_O Hooray for minimal casualties!\n');
elseif line(1) == 0 && evenOdd == 0
        fprintf('In our example, "black" meant an odd number of black hats and "white" meant an even number of black hats. Since the tallest person was wearing a white hat AND she saw an even number of black hats, everyone is saved! Hooray!\n');
else
    fprintf('In our example, "black" meant an odd number of black hats and "white" meant an even number of black hats. Since the tallest person was wearing a white hat BUT she saw an odd number of black hats, she sacrificed herself for the greater good. o_O Hooray for minimal casualties!\n');
end

fprintf('\n');
        
        
        
        