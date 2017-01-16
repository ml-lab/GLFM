%% Data Exploratory Anaylisis for Prostate DB

file = '../results/tmp_prostate_drug_noDrug3.mat';
disp('First column is the drug_identifier = 1, second column is not(drug_identifier)');

addpath(genpath('./aux/'));
load(file);
data.cat_labels{1} = {'3', '4'};

data.ylabel_long = {'Stage', 'Drug level', 'Months of Follow-up', 'Status', 'Age in years', ...
    'Weight Index', 'Type of activity', 'History of Cardiovascular Disease', ...
    'Systolic Blood Pressure/10', 'Diastolic Blood Pressure/10', ...
    'Electrocardiogram', 'Serum Hemoglobin (g/100ml)', 'Size of Primary Tumor (cm^2)', ...
    'Combined Index of Stage and Hist. Grade', 'Serum Prostatic Acid Phosphatase', ...
    'Bone Metastases'};

Z = Zest';
%Z(:,2) = not(Z(:,2);
%drug_identifier = data.X(:,2) > 0.5;

th = 0.05; % remove features whose perc of observations is below th
idxs_to_delete = find( (sum(Z) > size(data.X,1)*(1-th)) | (sum(Z) < size(data.X,1)*th) );
Z(:,idxs_to_delete) = [];

[patterns, C] = get_feature_patterns(Z);
print_patterns(1,data.X(:,13),patterns,C,data.ylabel_long{13});


% Let us first plot continuous, positive real and count data
maskD = (data.C ~= 'c' & data.C ~= 'o'); % all dimensions excluding categorical and ordinal
figure(1); hold off
colors = {'k--', 'b', 'r', 'c', 'm'};
for f=3:size(Z,2) % for each feature
    subplot(5,1,1:2);
    val = B(maskD,f,1);
    z = 1:sum(maskD);
    
    % eventually transform B
    % TODO
    
    subplot(5,1,1:2);
    MM = val + B(maskD,1,1);
    h1 = plot(z, MM, colors{f}, 'Linewidth',2); hold on
    grid;
    
    subplot(5,1,3:4);
    MM = val + B(maskD,2,1);
    h1 = plot(z, MM, colors{f}, 'Linewidth',2); hold on
end
set(gca,'XTick',[])
set(gca,'XTicklabel',[])
set( gca, 'XTick', 1:sum(maskD))
set( gca,'XTickLabel', data.ylabel_long(maskD) );
rotateticklabel(gca,45);
grid;

numBias = 2;
leg = cell(1,size(Z,2)-numBias);
for k=1:(size(Z,2)-numBias)
    leg{k} = sprintf('F%d',k);
end
legend(leg);
pause;

%% Plot per feature prob. of category activation
% THEORETICAL, THROUGH B's
data.cat_labels{1} = data.cat_labels{1}';

idxs = find(data.C == 'c');

figure(3); hold off
title('Theoretical')
leg_handlers = zeros(1,size(Z,2)); % number of lines to comment in legend
for k=1:size(Z,2) % for each feature
    ticklabels = [];
    xx = data.X(Z(:,k) == 1,:);
    idx_plot = 0;
    %subplot(5,1,1:4);
    for rr=1:length(idxs) % for each categorical dimension
        r = idxs(rr);
        V = xx(:,r);
        V(V == missing) = []; % remove missing for analysis
        h = hist(V,unique(data.X(~isnan(data.X(:,r)),r))) ./ length(V);
        p = plot(idx_plot+1:(idx_plot+length(h)), h,colors{k}, 'Linewidth', 2); hold on
        idx_plot = idx_plot+length(h);
        if isempty(data.cat_labels{r})
            lab = cell(length(h),1);
            for j=1:length(h)
                lab{j} = [data.ylabel_long{r}, ' ', num2str(j-1)];
            end
        else
            lab = data.cat_labels{r};
        end
        ticklabels = [ticklabels; lab];
        if (rr == 1)
            leg_handlers(k) = p;
        end
    end
end

numBias = 2;
leg = cell(1,size(Z,2));
v = ['a','b','c','d'];
for k=1:numBias
    leg{k} = sprintf('F0%s',v(k));
end
for k=numBias+1:(size(Z,2))
    leg{k} = sprintf('F%d',k-numBias);
end
legend(leg_handlers, leg);
%legend(leg_handlers, {'F0', 'F1', 'F2', 'F3', 'F4'});
set( gca, 'XTick', 1:idx_plot)
set( gca,'XTickLabel', ticklabels );
rotateticklabel(gca,45);
grid;
pause;


%% Plot per feature prob. of category activation
% EMPIRICAL
data.cat_labels{1} = data.cat_labels{1}';

idxs = find(data.C == 'c');

figure(3); hold off
title('Empirical')
leg_handlers = zeros(1,size(Z,2)); % number of lines to comment in legend
for k=1:size(Z,2) % for each feature
    ticklabels = [];
    xx = data.X(Z(:,k) == 1,:);
    idx_plot = 0;
    %subplot(5,1,1:4);
    for rr=1:length(idxs) % for each categorical dimension
        r = idxs(rr);
        V = xx(:,r);
        V(V == missing) = []; % remove missing for analysis
        h = hist(V,unique(data.X(~isnan(data.X(:,r)),r))) ./ length(V);
        p = plot(idx_plot+1:(idx_plot+length(h)), h,colors{k}, 'Linewidth', 2); hold on
        idx_plot = idx_plot+length(h);
        if isempty(data.cat_labels{r})
            lab = cell(length(h),1);
            for j=1:length(h)
                lab{j} = [data.ylabel_long{r}, ' ', num2str(j-1)];
            end
        else
            lab = data.cat_labels{r};
        end
        ticklabels = [ticklabels; lab];
        if (rr == 1)
            leg_handlers(k) = p;
        end
    end
end

numBias = 2;
leg = cell(1,size(Z,2));
v = ['a','b','c','d'];
for k=1:numBias
    leg{k} = sprintf('F0%s',v(k));
end
for k=numBias+1:(size(Z,2))
    leg{k} = sprintf('F%d',k-numBias);
end
legend(leg_handlers, leg);
%legend(leg_handlers, {'F0', 'F1', 'F2', 'F3', 'F4'});
set( gca, 'XTick', 1:idx_plot)
set( gca,'XTickLabel', ticklabels );
rotateticklabel(gca,45);
grid;
pause;

%% Independent histograms for each identified pattern
for d=1:D % for each dimension
    ma = ~isnan(data.X(:,d));
    figure; hold off;
    if (data.C(d) == 'c') % plot histogram categories
        U = unique(data.X(ma,d));
        aux = zeros( size(patterns, 1),length(U));
        for p=1:size(patterns,1)
            aux(p,:) = hist(data.X(ma & (C == p),d),U);
        end
        aux = aux ./ repmat( sum(aux,2), 1, size(aux,2) );
        subplot(5,1,1:4);
        bar(unique(data.X(ma,d)), aux'); title(data.ylabel_long{d});
        set( gca,'XTickLabel', data.cat_labels{d}, 'FontSize', 14);
        rotateticklabel(gca,45);
        grid;
    else % plot box plots
        boxplot(data.X(ma,d),C(ma)); title(data.ylabel_long{d});
        grid;
    end
    pause;
end