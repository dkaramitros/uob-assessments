clc; close all;

%% Export Options
range = 1:units;
export_emf = true;
export_pdf = true;
filter_flagged = false;
filter_notavailable = true;

%% Useful Variables
marks=2.5:5:97.5;
labels_b={'Fail','3rd','2:1','2:2','1st'};
labels_m={'Fail','2:1','2:2','1st'};
flagmarks=strings(units,3);
for i=1:units
    for j=1:3
        if flags(i,j)==1
            flagmarks(i,j)='*';
        end
    end
end

%% Loop
for i=range
if ~isnan(mean(i)) || ~filter_notavailable
if sum(flags(i,:))>0 || ~filter_flagged

    %% Figure
    description = append(codes{i,1},': ',codes{i,2},' (',codes{i,3},')');
    fig = figure('Name',codes{i,1},'Units','centimeters','Position',[2,2,32,18]);
    % Rectangle (for plotting purposes)
    annotation('rectangle',[0,0,1,1],'Color','w')
    % Titles
    annotation('textbox',[0.05,0.8,0.9,.2],'String',description, ...
        'LineStyle','none','FontName','Rockwell','FontSize',32,'VerticalAlignment','middle')
    annotation('textbox',[0.05,0,0.9,.15],'String','bristol.ac.uk',...
        'LineStyle','none','FontName','Rockwell','FontSize',28,'Color','#B01C2E','VerticalAlignment','middle')
    % Information
    if level(i) == 7
        text = sprintf(['Students: %d\n' ...
            'Attempted: %d\n\n' ...
            'Mean: %0.1f%s\n' ...
            'Median: %0.1f\n' ...
            'St Dev: %0.1f%s\n\n' ...
            'Classifications:\n' ...
            '1^{st}: %d (%0.1f%%)\n' ...
            '2:1: %d (%0.1f%%)\n' ...
            '2:2: %d (%0.1f%%)\n' ...
            'Fail: %d (%0.1f%%)%s\n'],...
            students(i),attempted(i), ...
            mean(i),flagmarks(i,1),median(i),stdev(i),flagmarks(i,2), ...
            classification(i,5),classification_pct(i,5)*100, ...
            classification(i,4),classification_pct(i,4)*100, ...
            classification(i,3),classification_pct(i,3)*100, ...
            classification(i,1),classification_pct(i,1)*100,flagmarks(i,3));
    else
        text = sprintf(['Students: %d\n' ...
            'Attempted: %d\n\n' ...
            'Mean: %0.1f%s\n' ...
            'Median: %0.1f\n' ...
            'St Dev: %0.1f%s\n\n' ...
            'Classifications:\n' ...
            '1st: %d (%0.1f%%)\n' ...
            '2:1: %d (%0.1f%%)\n' ...
            '2:2: %d (%0.1f%%)\n' ...
            '3rd: %d (%0.1f%%)\n' ...
            'Fail: %d (%0.1f%%)%s\n'],...
            students(i),attempted(i), ...
            mean(i),flagmarks(i,1),median(i),stdev(i),flagmarks(i,2), ...
            classification(i,5),classification_pct(i,5)*100, ...
            classification(i,4),classification_pct(i,4)*100, ...
            classification(i,3),classification_pct(i,3)*100, ...
            classification(i,2),classification_pct(i,2)*100, ...
            classification(i,1),classification_pct(i,1)*100,flagmarks(i,3));
    end
    annotation('textbox',[0.05,0.15,0.3,.65],'String',text,...
        'LineStyle','none','FontSize',18,'VerticalAlignment','middle')
    % Flag
    if sum(flags(i,:))>0
        annotation('textbox',[0.05,0,0.9,.1],'String',...
            '* Marks distribution might require consideration.', ...
            'LineStyle','none','FontSize',12,'HorizontalAlignment','right','VerticalAlignment','middle')
    end
    % Distribution
    ax1 = axes;
    ax1.Position = [0.3,0.2,0.4,0.6];
    plot_dist = bar(ax1,marks,distribution(i,:),1,'LineWidth',1);
    ax1.FontSize = 14;
    ax1.XLim = [0,100];
    ax1.XTick = 0:10:100;
    ax1.LineWidth = 1;
    xlabel('Marks (%)','FontSize',16,'FontWeight','bold')
    ylabel('Number of Students','FontSize',16,'FontWeight','bold')
    % Classification
    ax2 = axes;
    ax2.Position = [0.8,0.2,0.15,0.6];
    if level(i) == 7
        plot_class = bar(ax2,0,classification_pct(i,[1,3:5])*100,'stacked','LineWidth',1);
        legend(flip(plot_class),flip(labels_m),'Location','northeastoutside')
    else
        plot_class = bar(ax2,0,classification_pct(i,1:5)*100,'stacked','LineWidth',1);
        legend(flip(plot_class),flip(labels_b),'Location','northeastoutside')
    end
    ax2.FontSize = 14;
    ax2.XLim = [-0.7,0.7];
    ax2.XTick = [];
    ax2.YLim = [0,100];
    ax2.YTick = 0:10:100;
    ax2.LineWidth = 1;
    ylabel('Percentage of Students (%)','FontSize',16,'FontWeight','bold')

    %% Export
    if export_emf == true
        exportgraphics(fig,append(codes{i,1},'.emf'))
    end
    if export_pdf == true
        if i==1
            exportgraphics(fig,append(code,'.pdf'),'Append',false)
        else
            exportgraphics(fig,append(code,'.pdf'),'Append',true)
        end
    end

end
end
end