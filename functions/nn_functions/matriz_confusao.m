%Universidade Federal do Rio de Janeiro
%Laboratorio de Processamento de Sinais
%Nome: Natanael Nunes de Moura Junior

% matriz de confusao para duas classes

function [MC] = matriz_confusao(output,target)
score = 0;
total_c1 = 0;
total_c2 = 0;
t1_o1 = 0;
t1_o2 = 0;
t2_o1 = 0;
t2_o2 = 0;


for i=1:length(output)
    if output(i) < 0 %output = class1
        if target(i) < 0 % target = class1
            t1_o1 = t1_o1 +1;
            total_c1 = total_c1+1;
        else %target = class2
            t2_o1 = t2_o1 +1;
            total_c2 = total_c2+1;
        end
    else %output = class2
        if target(i) < 0 % target = class1
            t1_o2 = t1_o2 +1;
            total_c1 = total_c1+1;
        else %target = class2
            t2_o2 = t2_o2 +1;
            total_c2 = total_c2+1;
        end
    end 
end

MC = [t1_o1/total_c1 t1_o2/total_c1; t2_o1/total_c2 t2_o2/total_c2];

figure;
imagesc(MC);

colorbar;
%set(gca,'DefaultTextInterpreter', 'latex')
set(gca,'Xtick',1:2,'XTickLabel',{'C1 Estimado', 'C2 Estimado'});
set(gca,'Ytick',1:2,'YTickLabel',{'C1 Real', 'C2 Real'});

a = axis;

h1 = text(a(1)+((a(2)-a(1))/4)-0.15,a(3)+(a(4)-a(3))/4,sprintf('%1.2f%%',100*MC(1,1)));
h2 = text(((a(2)-a(1))/1)-0.15,a(3)+(a(4)-a(3))/4,sprintf('%1.2f%%',100*MC(1,2)));

h3 = text(a(1)+((a(2)-a(1))/4)-0.15,(a(4)-a(3))/1,sprintf('%1.2f%%',100*MC(2,1)));
h4 = text(((a(2)-a(1))/1)-0.15,(a(4)-a(3))/1,sprintf('%1.2f%%',100*MC(2,2)));

set(h1,'FontSize',15, 'FontWeight', 'bold', 'Color', 'w');
set(h2,'FontSize',15, 'FontWeight', 'bold', 'Color', 'w');
set(h3,'FontSize',15, 'FontWeight', 'bold', 'Color', 'w');
set(h4,'FontSize',15, 'FontWeight', 'bold', 'Color', 'w');



end