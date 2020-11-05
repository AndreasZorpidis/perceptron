% The Pocket Perceptron Algorithm (Supervised)
% With sign activation function
% Based on the pocket algorithm by Gallant
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

    %Clear Console
    %clc;
    %clear all;

    title("The Pocket Perceptron Algorithm");
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

    fprintf(2,'Input weights (random): \n')
    fprintf(2,'x1: ')
    disp(weights(1,1));
    fprintf(2,'x2: ')
    disp(weights(2,1));
    fprintf(2,'bias: ')
    disp(weights(3,1));
    
    %Initialize the pocket of weights
    wpocket = zeros(3,1); %fill with zeros

    %Sum
    sum1 = 0; %initialise the sum

    %Activation Function Result (y)
    result = 0; %initialise the result

    %initialise counters
    total_correct_guesses = 0;
    total_wrong_guesses = 0;
    max_correct_runs = 0;%number of max true decision made by perceptron, used to decide whether pocket the weight


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
            sum1 = sum1 + (bias * weights(3,1)) + (x1(j) * weights(1,1)) + (x2(j) * weights(2,1));

            %Activation function/Sign function
            result = sign_func(sum1);  %returns -1 or 1 based on the sum1

            %find the error or difference 
            error = target(j) - result; 
            %end of guess function 
            %%%%%%%%%%%%%%%%%%%%%%

            if result == target(j) %if guess is equal to the target then
                
                total_correct_guesses = total_correct_guesses + 1;
                correct_guesses = correct_guesses + 1;
                
                if correct_guesses > max_correct_runs %if the correct runs surpass the max total of the correct runs then 
                    max_correct_runs = correct_guesses; %update the total and
                    wpocket = weights; %update the pocket
                end
            
            else %if not match, then 
                %update the weights
                weights(1,1) = weights(1,1) + learning_rate * x1(j) * error;
                weights(2,1) = weights(2,1) + learning_rate * x2(j) * error;
                weights(3,1) = weights(3,1) + learning_rate * bias * error;
                
                total_wrong_guesses = total_wrong_guesses + 1;
                changes_in_weights = changes_in_weights + 1;  
              
            end
        end


        %4. step
        if changes_in_weights == 0 %break if no updates on weights
            break;
        end
    
        %Draw the new line for each epoch to visualize the changes
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        line_x1 = min(x1);
        line_y1 = ((-weights(1,1) * line_x1) - (bias * weights(3,1)))  / weights(2,1);
        line_x2 = max(x1);
        line_y2 = ((-weights(1,1) * line_x2) - (bias * weights(3,1)))  / weights(2,1);

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


    %Draw the final line based on the pocket
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    line_x1 = min(x1);
    line_y1 = ((-wpocket(1,1) * line_x1) - (bias * wpocket(3,1)))  / wpocket(2,1);
    line_x2 = max(x1);
    line_y2 = ((-wpocket(1,1) * line_x2) - (bias * wpocket(3,1)))  / wpocket(2,1);

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
    fprintf(2,'*****************************\n')
    fprintf(2,'*******END OF ALGORITHM******\n')
    fprintf(2,'*****************************\n')
    fprintf(2,'Final weights: \n')
    fprintf(2,'x1: ')
    disp(weights(1,1));
    fprintf(2,'x2: ')
    disp(weights(2,1));
    fprintf(2,'bias: ')
    disp(weights(3,1));
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