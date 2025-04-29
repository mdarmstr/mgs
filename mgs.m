function params = mgs(scrs)

    scrs1 = scrs(scrs(:,3)==2,1:2);
    scrs2 = scrs(scrs(:,3)==1,1:2);
    mn1 = mean(scrs1);
    mn2 = mean(scrs2);
    d = mn2' - mn1';
    
    [~,S1,V1] = svd(cov(scrs1 - mn1), "econ");
    [~,S2,V2] = svd(cov(scrs2 - mn2), "econ");
    R1 = V1 * S1;
    R2 = V2 * S2;

    M = [R1, -R2];
    b = pinv(M) * d;
    U = reshape(b, [2, 2]);
    Un = U ./ vecnorm(U);
    M2 = [Un(:,1), Un(:,2)];
    M2 = M2 ./ vecnorm(M2);
    
    U(:,1) = R1 * U(:,1);
    U(:,2) = R2 * U(:,2);
    
    chi2 = sum(pinv([V1*S1*M2(:,1), -V2*S2*M2(:,2)]) * d)^2/4;
    p = chi2cdf(chi2,4,"upper");
    
    %chi_num = sum(d)^2;

    %F = chi_num / chi_den;
    
    params = struct('scrs', scrs, 'mn1', mn1, 'mn2', mn2, 'U', U, 'p', p,'F',chi2);
end
