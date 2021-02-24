using Kronecker
using JLD
using Printf

# Load functions
include("fcnsimpleVfi.jl")

# initialize
global vf      = zeros(nk, nz);
global optk    = zeros(nk, nz);
kp3d = permutedims(repeat(kp, 1, nk, nz),[2,3,1]);
nodes = (k, z);

# Precision
global errval  = 10.0^6;
global errpol = 10.0^6;
global iter = 1;
tolvf   = 10.0^(-6);
tolpol  = 10.0^(-6);

# printing convergence
vfilog = "vfilog.csv"
str =  "vferr, polerr, iter"
open(vfilog, "a") do io;
    println(io, str);
end
vfisol = "vfisol.jld"

@printf("VFI started: Please wait");
# first round
global vf, optk, errval, errpol = valfun(vf, optk, cf, nodes, kp, kp3d, z, nkp, nk, nz, beta)

@printf(".");
str =   @sprintf("%.3f, %.5f, %.0f", errval, errpol, iter)
open(vfilog, "a") do io;
    println(io, str);
end

# iterate
while errval > tolvf;
    global vf, optk, errval, errpol = valfun(vf, optk, cf, nodes, kp, kp3d, z, nkp, nk, nz, beta)
    global iter = iter + 1;
    @printf(".");
    str =   @sprintf("%.3f, %.5f, %.0f", errval, errpol, iter)
    print("\n")
    open(vfilog, "a") do io
        println(io, str)
    end        
end
# Play sound when complete
println("\007")

# save data
save(vfisol, "vf", vf, "optk", optk)
#optk = load("./temp/vfirun.jld","optk")

#k2 = repeat(k, 1, nz);
#z2 = repeat(z', nk, 1);
#plot_surface(k2, z2, vf, cmap=ColorMap("jet"))

#ax[:plot_surface](k2, z2, vf, rstride=2, cstride=2, cmap=ColorMap("jet"), alpha=0.7, linewidth=0.2)