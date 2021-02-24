
include("fcnDiscretize.jl")

## set parameters

# discount factor
const beta = 0.97

# capital grid
const nk = 15;
const kmin = 0.01;
const kmax = 10.;
kgridb = 0.3338;
k = exp.(collect(range(log(kmin), log(kmax), length = nk)));

# next period capital
const nkp = 50;
kp = collect(range((log(kmin)),(log(kmax)), length = nkp));
kp = exp.(kp);
# keep the policy grid in strict interior for "inter"polation
kp[1] = kmin + 10^-10;
kp[end] = kmax - 10^-10;

# transition probabilities

# technology parameter values
const alpha   = .60;
const delta   = .1;

# adjustment costs
#const phi = 0.;
const phi = 1.5;

# idiosyncratic shocks -- Rouwenhorst (1995) method
const nz      = 11;
const zbar    = 0.;
const rhoz    = 0.9;
const sigz    = 0.1;        
zdev    = 2*sigz/sqrt((1 - rhoz^2)*(nz - 1));
z, Qz = rouwenhorst(nz, rhoz, sigz, (1-rhoz)*zbar);

cf = zeros(nk, nz, nkp);

for kk = 1:nkp, jj = 1:nz, ii = 1:nk
    invest = (kp[kk] - (1-delta)*k[ii]);
    cf[ii,jj,kk] = exp(z[jj])*k[ii]^alpha - invest - phi*(invest/k[ii])^2*k[ii];
end
