ALPHA=0.3
BETA=0.95
DELTA=0.1
RHO=0.9

Abar=1
Kbar=((ALPHA*Abar)/(1/BETA-1+DELTA))^(1/(1-ALPHA))
Cbar=Abar*Kbar^ALPHA-DELTA*Kbar

syms c1 c2 k1 k2

eqstosolve = [c1 - c1*k1 + ALPHA*BETA*Kbar^(ALPHA-1)*(ALPHA-1)*k1,
Cbar * c1 + Kbar * k1 - Kbar^ALPHA*ALPHA - (1-DELTA)*Kbar,
c2 - c1*k2 - c2 * RHO + ALPHA*BETA*Kbar^(ALPHA-1)*(RHO + (ALPHA-1)*k2),
Cbar*c2 + Kbar*k2 - Kbar^ALPHA];
[c1star, c2star, k1star, k2star] = solve(eqstosolve, [c1, c2, k1, k2])

istar = 0;
for i = 1:length(k1star)
    % matrix to assess whether stationary or not
    A = [k1star(i),k2star(i);0,0.9];
    if eig(A) < 1
        if istar == 0
            istar = i;
            disp('Values: c1, c2, k1, k2:')
            disp(double(c1star(istar)))
            disp(double(c2star(istar)))
            disp(double(k1star(istar)))
            disp(double(k2star(istar)))
        else
            disp('ERROR: Multiple solutions')
            exit
        end
    end
end


T=40;
khat(1)=0;

khat(1)=0;
ahat(1)=0.01;
chat(1)=c2star(istar)*ahat(1);
khat(2)=k2star(istar)*ahat(1);

for i=2:(T+1)
    ahat(i)=RHO*ahat(i-1);
    chat(i)=c1star(istar)*khat(i)+c2star(istar)*ahat(i);
    khat(i+1)=k1star(istar)*khat(i)+k2star(istar)*ahat(i);
end

fig=figure;
timevec=1:T;
plot(timevec,ahat(1:T),timevec,chat(1:T),timevec,khat(1:T))
legend('ahat','chat','khat')
saveas(fig,'temp/irfs.jpg')
