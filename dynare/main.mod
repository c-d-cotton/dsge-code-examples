//Written for Dynare 4.
 
var logc logk loga;
varexo e;

parameters beta rho alpha delta sigma;
beta=0.95;
rho=0.9;
alpha=0.3;
delta=0.1;
sigma=0.1;

ass = 1;
kss =((ass*alpha)/(1/(beta)+delta-1))^(1/(1-alpha));
css = ass*kss^alpha-delta*kss;

model;
exp(logc)^(-1)=beta*exp(logc(+1))^(-1)*(exp(loga(+1))*alpha*exp(logk)^(alpha-1)+1-delta);
exp(logc)+exp(logk)=exp(loga)*exp(logk(-1))^alpha+(1-delta)*exp(logk(-1));
loga = rho*loga(-1)+e;
end;

initval;
logk = log(kss);
logc = log(css);
loga = log(ass);
end;

shocks;
var e; stderr sigma;
end;

steady;

stoch_simul(order=1);
