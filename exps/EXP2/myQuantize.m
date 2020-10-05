function quant = myQuantize(x,dt)
    c = 0;
    for j = dt:dt:10
       if x<=j
           quant = c+dt/2;
           break;
       else
           c = j;
       end
    end
end