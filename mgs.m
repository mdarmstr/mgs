close all;

scrs = generateData(2);
eps = 1e-3;
%d = [R1'*(mn2 - mn1)'; -R2'*(mn2-mn1)'];
scrs1 = scrs(scrs(:,3)==2,1:2); scrs2 = scrs(scrs(:,3)==1,1:2);
mn1 = mean(scrs1); mn2 = mean(scrs2);
d = mn2'-mn1';
[~,S1,V1] = svd(cov(scrs1 - mn1),"econ"); [~,S2,V2] = svd(cov(scrs2 - mn2),"econ");
R1 = V1*S1; R2 = V2*S2;

M = [R1,-R2];
%[Y,S,V] = svd(M,"econ")
b = pinv(M)*d;

% C = [R1'*R1, -R1'*R2; -R2'*R1, R2'*R2];
% %C = [R1,-R2];
% b = pinv(C) * d;
% 
U = reshape(b,[2,2]);
Un = U ./vecnorm(U);
M2 = [Un(:,1),Un(:,2)];

M2 = M2 ./vecnorm(M2);
%R1 = R1*Un(:,1); R2 = R2*Un(:,2);
% 
% % U = U + (br ./ vecnorm(br));
%U = U ./ vecnorm(U)
% 
% % d = C*U(:) - d;
% % disp(iter)

U(:,1) =  R1*U(:,1);
U(:,2) =  R2*U(:,2);

chi_num = pinv([V1*S1*M2(:,1),-V2*S2*M2(:,2)])*d%%The scores contain information about the rotation and variance. Need to decouple.
chi_den1 = sum(sum(((scrs1 - mean(scrs1))./std(scrs1)).^2));
chi_den2 = sum(sum(((scrs2 - mean(scrs2))./std(scrs2)).^2));

chi_den = chi_den1/(length(scrs1)*2) + chi_den2/(length(scrs2)*2);

F = (sum(chi_num.^2)/4)/(chi_den)
p = fcdf(F,4,length(scrs1)*2+length(scrs2)*2)

chi2cdf(chi.^2,2)

hold on;
scatteru(scrs)
quiver(mn1(1), mn1(2), U(1,1), U(2,1), 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.1);
quiver(mn2(1), mn2(2), U(1,2), U(2,2), 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.1)
%plot([mn1(1),U(1,1)],[mn1(2),U(2,1)],'b');
%plot([mn2(1),U(1,2)],[mn2(2),U(2,2)],'k')

text(0.95, 0.95, sprintf('\\xi: %.2f', p), ...
    'Units', 'normalized', ...
    'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', ...
    'FontSize', 12, 'FontWeight', 'bold', 'Color', 'black',...
    'interpreter','tex');


hold off;


