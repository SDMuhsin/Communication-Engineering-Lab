function [fullHistory,Sequence] = mSequenceGeneration(initialState,iterations)
    
    len = length(initialState);
    fullHistory = zeros(iterations,len);
    fullHistory(1,1:end) = initialState;
    Sequence = zeros(1,len);
    Sequence(1) = initialState(len);
    for i = 1:1:iterations-1
       for j = 1:1:len
        if(j==1)
            fullHistory(i+1,j) = xor(fullHistory(i,len),fullHistory(i,len-1));
        else
            fullHistory(i+1,j) = fullHistory(i,j-1);
        end
       Sequence(i+1) = fullHistory(i+1,len);
    end
end