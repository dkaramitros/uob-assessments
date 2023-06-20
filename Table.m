clc; close all;

%% Export Options
filter_flagged = true;
filter_notavailable = true;

%% Create Table of Data
filter = logical( (1-(isnan(mean)*filter_notavailable)) .* (1-(sum(flags,2)==0)*filter_flagged) );
outputdata = [codes,num2cell(students),num2cell(attempted),num2cell(mean),num2cell(median),num2cell(stdev),num2cell(flip(classification_pct,2))];
outputfiltered = outputdata(filter,:);
outputtitle = {'Unit code','Unit name','Teaching block',...
    'Student count','Attempted',...
    'Mean','Median','Standard deviation',...
    '1st (%)','2:1 (%)','2:2 (%)','3rd (%)','Fail (%)'};

%% Export
writecell([outputtitle;outputfiltered],strcat(code,'.xlsx'),WriteMode="overwritesheet");
