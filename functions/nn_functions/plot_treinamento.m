function [h] = plot_treinamento(trn_neural)
%PLOT_TREINAMENTO Summary of this function goes here
%   Detailed explanation goes here
h = figure;
axes('YScale','log','YMinorTick','on','YMinorGrid','on');

vect_mse = [trn_neural.perf trn_neural.tperf trn_neural.vperf];
m_min = min(min(vect_mse));
m_max = max(max(vect_mse));

thr = 1;

hold on
line_width = 2.0;
plot(trn_neural.epoch,trn_neural.perf,'-b','LineWidth',line_width);
plot(trn_neural.epoch,trn_neural.vperf,'-.r','LineWidth',line_width);


if ~(size(trn_neural.testInd,2) == 0)
    plot(trn_neural.epoch,trn_neural.tperf,'--g','LineWidth',line_width);
end

plot(trn_neural.best_epoch,trn_neural.perf(trn_neural.best_epoch),'bo','LineWidth',line_width);
plot(trn_neural.best_epoch,trn_neural.vperf(trn_neural.best_epoch),'ro','LineWidth',line_width);

if ~(size(trn_neural.testInd,2) == 0)
    plot(trn_neural.best_epoch,trn_neural.tperf(trn_neural.best_epoch),'go','LineWidth',line_width);
end


grid on;
hold off;
str_train = sprintf('MSE Train(%1.5f)',trn_neural.perf(trn_neural.best_epoch));


if (length(trn_neural.testInd) == length(intersect(trn_neural.testInd,trn_neural.valInd)))
    str_valid = sprintf('MSE Test(%1.5f)',trn_neural.vperf(trn_neural.best_epoch));
    legend(str_train,str_valid);
else
    str_valid = sprintf('MSE Validation(%1.5f)',trn_neural.vperf(trn_neural.best_epoch));
    str_test = sprintf('MSE Test(%1.5f)',trn_neural.tperf(trn_neural.best_epoch));
    legend(str_train,str_test,str_valid);
end
 

title('Neural Network Training Process','FontSize', 15,'FontWeight', 'bold');
xlabel('# Epochs','FontSize', 15,'FontWeight', 'bold'); ylabel('MSE','FontSize', 15,'FontWeight', 'bold');

end

