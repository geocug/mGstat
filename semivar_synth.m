% semivar_synth : synthethic semivariogram
%
% Call ex :  
%    [sv,d]=semivar_synth('0.1 Nug(0) + 1 Gau(1.5)',[0:.1:6]);plot(d,sv)
% or : 
%    V(1).par1=1;V(1).par2=1.5;V(1).type='Gau';
%    V(2).par1=0.1;V(2).par2=0;V(2).type='Nug';
%    [sv,d]=semivar_synth(V,[0:.1:6]);plot(d,sv)
%
function [sv,d]=semivar_synth(V,d);
  
  if nargin==0,
    V='5 Nug(0) + 1 Sph(5)'
    d=[0:.1:20];
  end
  
  if nargin==1
    d=[0:.1:20];
  end
  
  if isstr(V)
    V=deformat_variogram(V);
  end

  sv=zeros(size(d));
  
  for iv=1:length(V),
    [gamma]=synthetic_variogram(V(iv),d);
    sv=sv+gamma;
  end
  
function [gamma,h]=synthetic_variogram(V,h)
  
  type=V.type;
  v1=V.par1;
  v2=V.par2;
  gamma=h.*0;
  
  s1=find(h<v2);
  s2=find(h>=v2);      
  
  if strmatch(type,'Nug')
    mgstat_verbose('Nug',12);
    gamma(1)=0;
    gamma(2:length(h))=v1;
    %% SEE GSTAT MANUAL FOR TYPES....
  elseif strmatch(type,'Sph')
    mgstat_verbose('Sph',12);
    gamma(s1)=v1.*(1.5*abs(h(s1))/(v2) - .5* (h(s1)./v2).^3);
    gamma(s2)=v1;
  elseif strmatch(type,'Gau')
    mgstat_verbose('Gau',12);
    gamma=v1.*(1-exp(-(h./v2).^2));
  elseif strmatch(type,'Lin')
    mgstat_verbose('Lin',12);
    if v2==0,
      gamma=v1.*h;
    else
      gamma(s1)=h(s1)./v2;
      gamma(s2)=1;
      gamma=gamma.*v1;
    end
  elseif strmatch(type,'Log')
    mgstat_verbose(type,12);
    gamma=log(h+v2);
  elseif strmatch(type,'Pow')
    mgstat_verbose(type,12);
    gamma=h.^v2;
  elseif strmatch(type,'Exp')
    mgstat_verbose(type,12);
    gamma=1-exp(-h/v2);
  else
    mgstat_verbose(sprintf('%s : ''%s'' type is not recognized',mfilename,type),-1);
  end
  