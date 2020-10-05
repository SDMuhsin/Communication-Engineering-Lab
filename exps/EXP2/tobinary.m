function b = tobinary(x,dt,n)
    b = de2bi(floor(((x*2)/dt)/2),n,'left-msb');
end