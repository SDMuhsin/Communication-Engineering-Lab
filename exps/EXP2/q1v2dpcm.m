
f_0 = 1000;
msef = [];
f_s = 10*f_0:10*1000:50*f_0;
L = [4 8 16 32];
for p = 1:1:length(f_s)
    for q = 2:1:length(L)
        t = 0:1/f_s(p):30/f_0;
        
        
        
        inp = 5 + 5*cos(2*pi*f_0*t);
        inp_original_copy = inp;
        
        for i=2:1:length(inp)
            inp(i) = inp(i) - inp(i-1);
        end
        inp = inp + 5;
        plot(t,inp);
        hold on;
        x = [];
        xbin = [];
        
        delta = (max(inp)-min(inp))/L(q);
        for i = 1:1:length(t)
            x = [x myQuantize2(inp(i),0, 15, delta)];
            
            %xbin = [xbin dec2bin(x(i),q+1)];
        end
        
        for i = 1:1:length(x)
            if(x(i)-delta/2 <= 0)
                x(i) =  0;
            else
                x(i) = floor((x(i)-delta/2)/delta);
            end
        end
        xbin = [];
        for i = 1:1:length(x)
            v = dec2bin(x(i),q);
            for j = 1:1:length(v)
                xbin = [xbin,str2num(v(j))];
            end
        end
        tsig = zeros(1,length(xbin));
        for i = 1:1:length(xbin)
            if xbin(i)==1
               tsig(i) = 1;
            else
                tsig(i) = -1;
            end
        end
        
        r = tsig + 1/sqrt(2)*10^(-20/20) * randn(1,length(tsig));
        
        for j = 1:1:length(r)
            if r(j)>0
                r(j)=1;
            else
                r(j)=0;
            end
        end

        y = [];
        for i = 1:q+1:length(r)
            y(floor(i/(q+1))+1) = todecimal(r(i:i+q));
        end

        req = requant(y,delta);

        %recon = zeros(1,length(req));
        recon = req;
        %-Linear-interpolation------

        recon(1) = req(1);
        for i = 2:1:length(recon)
            recon(i) = (req(i-1)+req(i))/2;
        end
        
        for i = 2:1:length(recon)
           recon(i) = recon(i) + recon(i-1); 
        end
        %plot(t,recon,'r');
        hold off;
        msef = [msef (sum((recon-inp_original_copy).^2))/length(recon)];
    end
end

f2 = figure(2);
plot(L,msef(1:4));
hold on;
plot(L,msef(5:8),'r');
plot(L,msef(9:12),'k');
plot(L,msef(13:16),'g');
plot(L,msef(17:20),'c');
xlabel('L(Quantization levels)');
ylabel('MSE');
xlim([4,32]);
title("MSE vs L for different f_{s}")
legend('$f_{s} = 10 f_{0}$','$f_{s} = 20 f_{0}$','$f_{s} = 30 f_{0}$','$f_{s} = 40 f_{0}$','$f_{s} = 50 f_{0}$','interpreter','latex');
hold off;

f3 = figure(3);
msef2 = reshape(msef,[],5);
plot(f_s,msef2(1,:));
hold on;
plot(f_s,msef2(2,:),'r');
plot(f_s,msef2(3,:),'k');
plot(f_s,msef2(4,:),'g');
xlabel('$f_{s} Hz$','interpreter','latex');
ylabel('MSE');
legend('$L = 4$','$L = 8$','$L = 16$','$L = 32$','interpreter','latex');
title("MSE vs f_{s} for different quantization levels");
hold off;