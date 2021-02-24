# Value Function Iteration, no sdf

using Interpolations

function valfuninterp!(vf_f1, nodes_f1, kp_f1, z_f1, nkp_f1, nz_f1, beta_f1)

        itp = interpolate(nodes_f1, vf_f1, Gridded(Linear()));
        vfaltitp_f1 = zeros(nkp_f1, nz_f1);

        for jj = 1:nz_f1, ii = 1:nkp_f1
                vfaltitp_f1[ii,jj] = itp[kp_f1[ii], z_f1[jj]];
        end 
        vfaltitp_f1 = beta_f1*vfaltitp_f1';        
        return vfaltitp_f1;       
end 


function valfun(vf_f2, optk_f2, cf_f2, nodes_f2, kp_f2, kp3d_f2, z_f2, nkp_f2, nk_f2, nz_f2, beta_f2)

vfnextinterp2f_f2 = valfuninterp!(vf_f2, nodes_f2, kp_f2, z_f2, nkp_f2, nz_f2, beta_f2);

vfinterp_f2 = zeros(nk_f2, nz_f2, nkp_f2);

for i = 1:nk_f2
        vfinterp_f2[i,:,:] = vfnextinterp2f_f2;
end

vfnew_f2, optknew_loc = findmax(cf_f2 + vfinterp_f2, dims = 3);
vfnew_f2 = dropdims(vfnew_f2, dims = 3);
optknew_f2 = dropdims(kp3d_f2[optknew_loc], dims = 3);

# Limited liability
vfnew_f2 = @. max(vfnew_f2, 0.)

errval_f2 = sum((vfnew_f2[:] - vf_f2[:]).^2);
errval2_f2 = sum((optknew_f2[:] - optk_f2[:]).^2);

return vfnew_f2, optknew_f2, errval_f2, errval2_f2
end