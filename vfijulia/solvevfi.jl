using Kronecker
using JLD
using Printf

# Load functions
include("fcnsimpleVfi.jl")

# initialize
vf      = zeros(nk, nz);
optk    = zeros(nk, nz);
kp3d = permutedims(repeat(kp, 1, nk, nz),[2,3,1]);
nodes = (k, z);

vf, optk, errval, errpol = valfun(vf, optk, cf, nodes, kp, kp3d, k, z, nkp, nk, nz, β)

# Precision
errval  = 10.0^6;
errpol = 10.0^6;
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
vf, optk, errval, errpol = valfun(vf, optk, cf, nodes, kp, kp3d, k, z, nkp, nk, nz, β)
iter = 1;
@printf(".");
str =   @sprintf("%.3f, %.5f, %.0f", errval, errpol, iter)
open(vfilog, "a") do io;
    println(io, str);
end

# iterate
while errval > tolvf;
    vf, optk, errval, errpol = valfun(vf, optk, cf, nodes, kp, kp3d, k, z, nkp, nk, nz, β)
    iter = iter + 1;
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