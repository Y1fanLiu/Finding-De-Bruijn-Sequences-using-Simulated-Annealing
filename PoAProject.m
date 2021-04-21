clear all
close all

clc

%order 3, 10 entries
for i = 0:999
    if i<10
        temp = '00%d';
        Nro(i+1) = compose(temp, i);
    elseif i <100
        temp = '0%d';
        Nro(i+1) = compose(temp,i);
    elseif i < 1000
        temp = '%d';
        Nro(i+1) = compose(temp,i);
    else
        temp = '%d';
        Nro(i+1) = compose(temp,i);
    end
end

%order 3, 6 entries
for i = 1:length(Nro)
    if contains(Nro{i},'9') || contains(Nro{i},'8') || contains(Nro{i},'7') || contains(Nro{i},'6')
        iden(i) = 1;
    end
end
Nro(logical(iden)) = [];

N = 72;
lenN = length(Nro);
Itr = 400000;     %number of operations per trial
Trial = 1;      %number of trials

orgSequenceArridx = randperm(length(Nro),N);
orgSequenceArr = Nro(orgSequenceArridx);
%select random entries to form sequence

%copy first 2 digit to the end of sequence
orgSequenceState = strcat(orgSequenceArr{:},orgSequenceArr{1}(1:2));

%start E for StartSequenceState
for i = 1:lenN
    if contains(orgSequenceState,Nro{i})
        identify(i) = 1;
    end
end
%set up energy log
E(1:Trial,1) = lenN - sum(identify);
E(1:Trial,2:Itr) = 0;
%%
tic
for nn = 1   %trial number

    nn
    clearvars dE temp choiceidx identify replacementidx counter

    SequenceArridx = orgSequenceArridx;
    SequenceArr = orgSequenceArr;
    SequenceState = orgSequenceState;
    counter2 = 1;
    
    % operations
    for counter = 2:Itr

        oldSequenceArridx = SequenceArridx;
        oldSequenceArr = SequenceArr;
        oldSequenceState = SequenceState;
        %oldLast3digit = Last3digit;

        %Select string to replace to advance to next step
        
        RanChoice = counter2;
        counter2 = counter2+1;
        if counter2 > N
            counter2=1;
        end
        
        choiceidx = SequenceArridx(RanChoice);
        
        %close neighbor
        %{
        pm = rand;
        if pm>0.5
            replacementidx = choiceidx+1;
        else
            replacementidx = choiceidx-1;
        end
        
        if replacementidx==0
            replacementidx = lenN;
        elseif replacementidx == lenN+1
            replacementidx = 1;
        end
        %}
        %random neighbor
        replacementidx = ceil(rand*lenN);
        temp = SequenceArridx == replacementidx;
        SequenceArridx(RanChoice) = replacementidx;
        
        %exclusive rule
        if sum(temp) == 1 
            SequenceArridx(temp) = choiceidx;
        end

        %exchange sequence rule
        %{
        while sum(temp) == 1
            if pm>0.5
                replacementidx = replacementidx+1;
            else
                replacementidx = replacementidx-1;
            end
            
            if replacementidx==0
                replacementidx = lenN;
            elseif replacementidx == lenN+1
                replacementidx = 1;
            end
            temp = SequenceArridx == replacementidx;
        end
%}
        % no exchange rule
        SequenceArridx(RanChoice) = replacementidx;
        SequenceArr = Nro(SequenceArridx);
        
        SequenceState = strcat(SequenceArr{:},SequenceArr{1}(1:2));
        
        % Energy after step
        for i = 1:lenN
            if contains(SequenceState,Nro{i})
                identify(i) = 1;
            end
        end
        E(nn,counter) = lenN - sum(identify);               %Energy function
        clearvars identify

        %break if E = 0 is reached
        if E(nn,counter) == 0
            break
        end
        
        
        %Energy difference
        dE = E(nn,counter)-E(nn,counter-1);      
        if dE > 0
            T = 30000.*(exp(1./(counter-1))-1);      %Temperature  
            P = exp(-dE/T);                %Acceptance rate
            % reversion if not accepted
            if rand>P
                SequenceArridx = oldSequenceArridx;
                SequenceArr = oldSequenceArr;
                SequenceState = oldSequenceState;
                E(nn,counter) = E(nn,counter-1);
            end
        end
    end
end

toc
%%
yyaxis left
plot(E')
grid on
ylabel('Energy')


yyaxis right
T = 30000.*(exp(1./(1:Itr))-1);
P = exp(-1./T); 
plot(P)
legend('Simulated Annealing T = 30000.*(exp(1./(steps))-1)','Probability for accepting dE = 1 for T = 30000.*(exp(1./(steps))-1)')
title('Simulated Annealing with differnet Temperature')
ylabel('Acceptance Probability')
