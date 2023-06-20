clc; clear all;

%% Input Variables
filename = 'Stats.xlsx';
code = 'CENG';
year = '22/23';

%% Import Data
inputdata = readcell(filename);

%% Count Units (using unit code on 1st column)
% Initialise variables
units = 0;
% Loop through rows
for i = 1:size(inputdata,1)
    if not(ismissing(inputdata{i,1}))
        if contains(inputdata{i,1},code)
            units = units + 1;
        end
    end
end

%% Read Unit Data (using year on 1st column)
% Initialise Variables
codes = cell(units,3);
students = zeros(units,1);
mean = zeros(units,1);
stdev = zeros(units,1);
median = zeros(units,1);
attempted = zeros(units,1);
distribution = zeros(units,20);
distribution_pct = zeros(units,20);
level = zeros(units,1);
classification = zeros(units,5);
classification_pct = zeros(units,5);
flags = zeros(units,3);
j = 0;
% Loop through rows
for i = 1:size(inputdata,1)
    if strcmp(inputdata{i,1},year)
        j = j + 1;
        % Main information
        codes{j,1} = inputdata{i,4};
        codes{j,2} = inputdata{i,5};
        codes{j,3} = inputdata{i,7};
        students(j,1) = inputdata{i,8};
        mean(j,1) = inputdata{i,9};
        stdev(j,1) = inputdata{i,10};
        median(j,1) = inputdata{i,11};
        attempted(j,1) = inputdata{i,12};
        % Marks distribution
        for k = 1:20
            distribution(j,k) = str2num(extractBefore(inputdata{i,k+13},'('));
        end
        distribution_pct(j,:) = distribution(j,:)/attempted(j,1);
        % Unit level & degree classifications
        if codes{j,1}(5) == 'M'
            level(j,1) = 7;
            classification(j,1) = sum(distribution(j,1:10)); %fail
        else
            level(j,1) = str2num(codes{j,1}(5)) + 3;
            classification(j,1) = sum(distribution(j,1:8)); %fail
            classification(j,2) = sum(distribution(j,9:10)); %3rd
        end
        classification(j,3) = sum(distribution(j,11:12)); %2:2
        classification(j,4) = sum(distribution(j,13:14)); %2:1
        classification(j,5) = sum(distribution(j,15:20)); %1st
        classification_pct(j,:) = classification(j,:)/attempted(j,1);
        % Flags
        if level(j,1) == 7
            if mean(j,1)<55 || mean(j,1)>70 ; flags(j,1)=1 ; end %mean
            if stdev(j,1)<5 ; flags(j,2)=1 ; end %stdev
            if classification_pct(j,1)>0.05 ; flags(j,3)=1 ; end %fails
        else
            if mean(j,1)<50 || mean(j,1)>70 ; flags(j,1)=1 ; end %mean
            if stdev(j,1)<5 ; flags(j,2)=1 ; end %stdev
            if classification_pct(j,1)>0.10 ; flags(j,3)=1 ; end %fails
        end
    end
end