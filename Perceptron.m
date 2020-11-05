% The Perceptron Algorithm (Supervised)
% With sign activation function
% Last edit: Jan 22 2020 19:20

%Clear Console
clc;
clear all;

% contents of the input (x1 axis, x2 axis, desired target output)
load ('./datasets/input.mat'); %load the dataset
myperceptron(input); %replace "input" with the name of the vector of the dataset displayed on the workplace


%Main function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = myperceptron(input)

    title("The Perceptron Algorithm");
    fprintf(2,'*****************************\n')

    %%%%%%%%%%%%%%%%
    %Initialization%
    %%%%%%%%%%%%%%%%
    x1 = input(:,1); %set the first column of the input to x1
    x2 = input(:,2); %set the second column of the input to x2
    target = input(:,3); %set the third column of the input to target

    %Number of inputs
    inputLength = length(input);

    %Learning Rate
    learning_rate = 0.01;

    %Number of itterations/epochs(how many times we want to train or modify the
    %weights
    iterations = 100; %number of loops requested
    epoch = 0; %initialize the epochs

    %Bias
    bias = 1; %set a bias

    %First random weights
    %initial weight is selected randomly
    %generate the first 3 weights (one for bias, one for x1 and one for x2)
    rand('state',sum(100*clock));
    weights = -1*2.*rand(3,1);

    weight_x1 = weights(1,1); %set the first weight position of the vector to the weight_x1
    weight_x2 = weights(2,1);%set the second weight position of the vector to the weight_x2
    weight_bias = weights(3,1);%set the thirst weight position of the vector to the weight_bias

    fprintf(2,'Input weights (random): \n')
    fprintf(2,'x1: ')
    disp(weight_x1);
    fprintf(2,'x2: ')
    disp(weight_x2);
    fprintf(2,'bias: ')
    disp(weight_bias);

    %Sum
    sum1 = 0; %initialise the sum

    %Activation Function Result (y)
    result = 0; %initialise the result

    %initialise counters
    total_correct_guesses = 0;
    total_wrong_guesses = 0;


    %Draw the points
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure(1); %in one window
    axis([-5 5 -5 5]); %change view position / Coordinate space
    hold on
    scatter(x1(target == -1), x2(target == -1), 150, '*')
    scatter(x1(target == 1), x2(target == 1), 120, '*')
    hold on
    drawnow() 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %The algorithm
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    while epoch < iterations % from 1 to the number of itterations

        changes_in_weights = 0; %count how many changes were done on the weights at each epoch
        correct_guesses = 0; %count how many correct guesses at each epoch

        for j=1:inputLength

            %weighted sum or guess function
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            sum1 = sum1 + (bias * weight_bias) + (x1(j) * weight_x1) + (x2(j) * weight_x2);

            %Activation function/Sign function
            result = sign_func(sum1);  %returns -1 or 1 based on the sum1

            %find the error or difference 
            error = target(j) - result; 
            %end of guess function 
            %%%%%%%%%%%%%%%%%%%%%%

            if result == target(j) %if guess is equal to the target then
                total_correct_guesses = total_correct_guesses + 1;
                correct_guesses = correct_guesses + 1;
            else %if not match, then 
                %update the weights
                weight_x1 = weight_x1 + learning_rate * x1(j) * error;
                weight_x2 = weight_x2 + learning_rate * x2(j) * error;
                weight_bias = weight_bias + learning_rate * bias * error;

                total_wrong_guesses = total_wrong_guesses + 1;
                changes_in_weights = changes_in_weights + 1;  
            end
        end


        %Draw the new line for each epoch to visualize the changes
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        line_x1 = min(x1);
        line_y1 = ((-weight_x1 * line_x1) - (bias * weight_bias))  / weight_x2;
        line_x2 = max(x1);
        line_y2 = ((-weight_x1 * line_x2) - (bias * weight_bias))  / weight_x2;

        line_x = [line_x1 line_x2];
        line_y = [line_y1 line_y2];

        if exist('new_line','var')
            delete(new_line); %delete previous line
        end
        new_line = plot(line_x,line_y); %draw new line
        %plot(line_x,line_y); %draw new line
        refreshdata %refresh the data of the line always
        drawnow
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        %For debug
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fprintf(2,'_________________________________ \n\n')
        fprintf(2,'Number of current epoch: ')
        disp(epoch);
        fprintf(2,'Changes performed to this epoch: ')
        disp(changes_in_weights);
        fprintf(2,'Correct guesses to this epoch: ')
        disp(correct_guesses);
        fprintf(2,'_________________________________ \n')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        epoch = epoch + 1; % one epoch completed , so count it

    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    %For debug
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf(2,'*****************************\n')
    fprintf(2,'*******END OF ALGORITHM******\n')
    fprintf(2,'*****************************\n')
    fprintf(2,'Final weights: \n')
    fprintf(2,'x1: ')
    disp(weight_x1);
    fprintf(2,'x2: ')
    disp(weight_x2);
    fprintf(2,'bias: ')
    disp(weight_bias);
    fprintf(2,'Number of epochs: ')
    disp(epoch);
    fprintf(2,'Number of patterns: ')
    disp(inputLength);
    fprintf(2,'Number of guesses: ')
    disp(total_correct_guesses + total_wrong_guesses);
    fprintf(2,'Total correct guesses: ')
    disp(total_correct_guesses);
    fprintf(2,'Total wrong guesses (changes in weights): ')
    disp(total_wrong_guesses);
    fprintf(2,'Success percentage: ')
    disp(((total_correct_guesses)/(total_correct_guesses + total_wrong_guesses))*100);
    fprintf(2,'*****************************\n')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Activation function/Sign function
%returns 1 or -1 depending on the sum/input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function return_result = sign_func(the_sum)
    return_result = 0;  %reset the results   
    if the_sum >= 0 
        return_result = 1; %is the output of the function (y)
    else
        return_result = -1; %is the output of the function (y)
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%