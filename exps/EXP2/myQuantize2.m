function quant = myQuantize2(x,dt,mx)
    c = 0;
    for j = dt:dt:mx
       if x<=j
           quant = c+dt/2;
           break;
       else
           c = j;
       end
    end
end
