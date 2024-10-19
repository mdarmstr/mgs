close all

scrs = generateData(2);
max_iters = 10000;
learning_rate = 0.5;
eps = 1e-3;

%% Scores in the first two columns, classes in the last
% Calculate mean and variance tensors
scrs1 = scrs(scrs(:,3)==2,1:2); scrs2 = scrs(scrs(:,3)==1,1:2);
%mns = mean(scrs1)' - mean(scrs2)';
mn1 = mean(scrs1); mn2 = mean(scrs2);
mns = mn1' - mn2';
[~,S1,V1] = svd(scrs1 - mn1,"econ"); [~,S2,V2] = svd(scrs2 - mn2,"econ");
sg1 = V1*S1; sg2 = V2*S2;
sgm = [sg1,-sg2];

% Initialize U
[U,~,~] = svd(rand(2,2));

% % Initialize chi
% chi = pinv(sgm.*U) * mns;
% Un = pinv(sgm)*chi*mns'*pinv(mns*mns');
% U = U + Un;
% U = U ./ vecnorm(U);

res = [];
chi = pinv(sgm.*pinv(U)) * mns;
Un = eye(2);

while norm(Un) > eps
    % Calculate Un
    Un = pinv(sgm)*chi*mns'*pinv(mns*mns');
    %Un = mns * (chi'*chi)^(-1) * chi' * pinv(sgm);

    % Update U using gradient descent
    U = U - learning_rate * Un;
    
    % Normalize U
    U = U ./ vecnorm(U);

    chi = pinv(sgm.*pinv(U)) * mns;
    
    % (Optional) Check for convergence (e.g., if change in U is small)

    res = [res; norm(Un)];
    %disp(norm(Un1-Un0))
end

A = pinv(sgm.*pinv(U));

plot_results(scrs,A,mn1,mn2)

function plot_results(scrs,U,mn1,mn2)
hold on;
scatteru(scrs)
plot([mn1(1),U(1,1)],[mn1(2),U(1,2)],'b');
plot([mn2(1),U(2,1)],[mn2(2),U(2,2)],'k')

%[mns(1, 1), U(rnd1, 1)], [mns(1, 2), U(rnd1, 2)], 'b'



end
    % 
    % plot(log10(res))
    % disp(norm(chi)^2)