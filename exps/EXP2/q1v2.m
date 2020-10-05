
f_0 = 1000;
msef = [];
f_s = 10*f_0:10*1000:50*f_0;
L = [4 8 16 32];
figure(2)
for q = 1:1:length(L)
    
    for p = 1:1:length(f_s)
        t = 0:1/f_s(p):30/f_0;
        delta = 10/L(q);
        
        inp = 5 + 5*cos(2*pi*f_0*t);
        plot(t,inp);
        hold on;
        x = [];
        xbin = [];
        for i = 1:1:length(t)
            x = [x myQuantize(inp(i),delta)];
            xbin = [xbin tobinary(x(i),delta,q+1)];
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
        recon = req;

        plot(t,recon,'r');
        hold off;
        msef = [msef (sum((recon-inp).^2))/length(recon)];
    end
    

end
% 
% f1 = figure(2);
% plot(L,msef(1:4));
% hold on;
% plot(L,msef(5:8),'r');
% plot(L,msef(9:12),'k');
% plot(L,msef(13:16),'g');
% plot(L,msef(17:20),'c');
% 
% xlabel('L (Quantization Levels)');
% ylabel('MSE');
% legend('$f_{s} = 10 f_{0}$','$f_{s} = 20 f_{0}$','$f_{s} = 30 f_{0}$','$f_{s} = 40 f_{0}$','$f_{s} = 50 f_{0}$','interpreter','latex');
% title('MSE vs Quantization levels for different f_{s}')
% hold off;

f1 = figure(2);
 plot(f_s,msef(1:5));
 hold on;
 plot(f_s,msef(6:10),'r');
 plot(f_s,msef(11:15),'k');
 plot(f_s,msef(16:20),'g');
 
 xlabel('f_{s} (Hz)');
 ylabel('MSE');
 legend(["L = "+4 "L = "+8 "L = "+16 "L = "+32])
 title('MSE vs f_{s} for different Quantization levels')
 hold off;
