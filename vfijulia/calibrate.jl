
include("fcnDiscretize.jl")

## set parameters

# discount factor
const β = 0.97

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
const α   = .60;
const δ   = .1;

# adjustment costs
#const ϕ = 0.;
const ϕ = 1.5;

# idiosyncratic shocks -- Rouwenhorst (1995) method
const nz      = 11;
const zbar    = 0.;
const ρz    = 0.9;
const σz    = 0.1;        
zdev    = 2*σz/sqrt((1 - ρz^2)*(nz - 1));
z, Qz = rouwenhorst(nz, ρz, σz, (1-ρz)*zbar);

cf = zeros(nk, nz, nkp);

for kk = 1:nkp, jj = 1:nz, ii = 1:nk
    invest = (kp[kk] - (1-δ)*k[ii]);
    cf[ii,jj,kk] = exp(z[jj])*k[ii]^α - invest - ϕ*(invest/k[ii])^2*k[ii];
end
