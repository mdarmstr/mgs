close all;

scrs = generateData(2);
eps = 1e-3;
%d = [R1'*(mn2 - mn1)'; -R2'*(mn2-mn1)'];
scrs1 = scrs(scrs(:,3)==2,1:2); scrs2 = scrs(scrs(:,3)==1,1:2);
mn1 = mean(scrs1); mn2 = mean(scrs2);
d = mn2'-mn1';
[~,S1,V1] = svd(scrs1 - mn1,"econ"); [~,S2,V2] = svd(scrs2 - mn2,"econ");
R1 = V1*S1; R2 = V2*S2;

M = [R1,-R2];
%[Y,S,V] = svd(M,"econ");
b = pinv(M)*d;

% C = [R1'*R1, -R1'*R2; -R2'*R1, R2'*R2];
% %C = [R1,-R2];
% b = pinv(C) * d;
% 
U = reshape(b,[2,2]);
Un = U ./vecnorm(U);

%R1 = R1*Un(:,1); R2 = R2*Un(:,2);
% 
% % U = U + (br ./ vecnorm(br));
%U = U ./ vecnorm(U)
% 
% % d = C*U(:) - d;
% % disp(iter)


U(:,1) =  R1*U(:,1);
U(:,2) =  R2*U(:,2);


hold on;
scatteru(scrs)
quiver(mn1(1), mn1(2), U(1,1), U(2,1), 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.2);
quiver(mn2(1), mn2(2), U(1,2), U(2,2), 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.2)
%plot([mn1(1),U(1,1)],[mn1(2),U(2,1)],'b');
%plot([mn2(1),U(1,2)],[mn2(2),U(2,2)],'k')
hold off;


