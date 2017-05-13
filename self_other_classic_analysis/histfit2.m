function varargout = histfit2(data,nbins,dist,plottype)
%HISTFIT Histogram with superimposed fitted normal density.
%   HISTFIT(DATA,NBINS) plots a histogram of the values in the vector DATA,
%   along with a normal density function with parameters estimated from the
%   data.  NBINS is the number of bars in the histogram. With one input
%   argument, NBINS is set to the square root of the number of elements in
%   DATA. 
%
%   HISTFIT(DATA,NBINS,DIST) plots a histogram with a density from the DIST
%   distribution.  DIST can take the following values:
%
%         'beta'                             Beta
%         'birnbaumsaunders'                 Birnbaum-Saunders
%         'exponential'                      Exponential
%         'extreme value' or 'ev'            Extreme value
%         'gamma'                            Gamma
%         'generalized extreme value' 'gev'  Generalized extreme value
%         'generalized pareto' or 'gp'       Generalized Pareto (threshold 0)
%         'inverse gaussian'                 Inverse Gaussian
%         'logistic'                         Logistic
%         'loglogistic'                      Log logistic
%         'lognormal'                        Lognormal
%         'negative binomial' or 'nbin'      Negative binomial
%         'nakagami'                         Nakagami
%         'normal'                           Normal
%         'poisson'                          Poisson
%         'rayleigh'                         Rayleigh
%         'rician'                           Rician
%         'tlocationscale'                   t location-scale
%         'weibull' or 'wbl'                 Weibull
%
%   H = HISTFIT(...) returns a vector of handles to the plotted lines.
%   H(1) is a handle to the histogram, H(2) is a handle to the density curve.

%   Copyright 1993-2008 The MathWorks, Inc. 
%   $Revision: 1.1.8.3 $  $Date: 2010/12/22 16:31:43 $
if ~isvector(data)
   error(message('stats:histfit:VectorRequired'));
end

data = data(:);
data(isnan(data)) = [];
n = numel(data);

if nargin<2 || isempty(nbins)
    binwidth = 2*iqr(data)*n^(-1/3); % Freedman-Diaconis rule
    bincenters = min(data):binwidth:max(data);
    % Do histogram calculations
    [bincounts,~] = hist(data,bincenters);
elseif numel(nbins) == 1
    % Do histogram calculations
    [bincounts,bincenters]=hist(data,nbins);
elseif numel(nbins) == n
    % Do histogram calculations
    bincenters = data;
    binwidth = median(diff(bincenters)); % Finds the width of each bin.
    area = n * binwidth; % total area to normalize the pdf
    freq = nbins;
    bincounts = freq./100*area;
end

% Fit distribution to data
if nargin<3 || isempty(dist)
    dist = 'normal';
end
try
    if exist('freq')
        pd = fitdist(data,dist,'Frequency',freq);
    else
        pd = fitdist(data,dist);
    end
catch myException
    if isequal(myException.identifier,'stats:ProbDistUnivParam:fit:NRequired')
        % Binomial is not allowed because we have no N parameter
        error(message('stats:histfit:BadDistribution'))
    else
        % Pass along another other errors
        throw(myException)
    end
end

% Find range for plotting
q = icdf(pd,[0.0013499 0.99865]); % three-sigma range for normal distribution
x = linspace(q(1),q(2)*2);
if ~pd.Support.iscontinuous
    % For discrete distribution use only integers
    x = round(x);
    x(diff(x)==0) = [];
end

% Compute the normalized histogram
binwidth = median(diff(bincenters)); % Finds the width of each bin.
area = n * binwidth; % total area to normalize the pdf
xd = bincenters;
yd = bincounts./area;

% Plot the histogram with no gap between bars.
if ~isempty(plottype)
    switch plottype
        case 'pdf'
            const = 1;
        case 'counts'
            const = area;
        case 'percent'
            const = area./n;
        otherwise
            const = 1;
    end
    
    if numel(nbins) == n
        hh = bar(xd(:),freq(:),[min(xd), max(xd)],'hist');
        set(hh,'EdgeColor','none','FaceColor','g')
        
        % Probability density function of the histogram
        xn = xd+abs(min(xd));
        xf = linspace(0,max(xn),301)-abs(min(xd));
        y = pdf(pd,xf);
        
        % Overlay the density
        np = get(gca,'NextPlot');
        set(gca,'NextPlot','add')
        hh1 = plot(xf,y*area./n*100,'k-');
    else
        hh = bar(xd,yd.*const,[min(data), max(data)],'hist');
        set(hh,'EdgeColor','none','FaceColor','g')
        
        % Probability density function of the histogram
        xn = xd+abs(min(xd));
        xf = linspace(0,max(xn),1001)-abs(min(xd));
        y = pdf(pd,xf);
        
        % Overlay the density
        np = get(gca,'NextPlot');
        set(gca,'NextPlot','add')
        hh1 = plot(xf,y*const,'k-');
    end

    
    if nargout == 1
        h = [hh; hh1];
    end
    
    set(gca,'NextPlot',np)
    
    h = [hh; hh1];
else
    h = 0;
end


argout={h,pd,[xd',yd']};

if nargout > length(argout)
    error('Too many output arguments.');
end

[varargout{1:nargout}]=argout{1:nargout};


