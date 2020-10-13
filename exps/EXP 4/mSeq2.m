function [fullHistory,Sequence] = mSeq2(initialState,iterations)
    
    len = 5;
    fullHistory = zeros(iterations,len);
    fullHistory(1,1:end) = initialState;
    Sequence = zeros(1,len);
    Sequence(1) = initialState(len);
    for i = 1:1:iterations-1
       for j = 1:1:len
        if(j==1)
            fullHistory(i+1,j) = xor(xor(xor(fullHistory(i,2),fullHistory(i,3)),fullHistory(i,4)),fullHistory(i,5));
        else
            fullHistory(i+1,j) = fullHistory(i,j-1);
        end
       Sequence(i+1) = fullHistory(i+1,len);
       end
    end
end