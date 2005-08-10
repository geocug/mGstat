function [be,d,d_est,d_var]=krig_blinderror(pos_known,val_known,V,options,nleaveout);

nknown=size(pos_known,1);
pos=1:1:nknown;

d_est=zeros(nknown,1);
d_var=zeros(nknown,1);

for i=1:nknown
  used=find(pos~=i);
  
  [d_est(i),d_var(i)]=krig(pos_known(used,:),val_known(used,:),...
                    pos_known(i,:),V,options);
  
  if (i/10)==round(i/10), 
    mgstat_verbose(sprintf('%s cross validation  %d/%d',mfilename,i,nknown));
  end
end


d=d_est-val_known;
d=(d_est-val_known)./d_var;

be=sqrt(d(:)'*d(:));


%REMEMBER TO NORMALIZE MISFIT BY IT VARIANCE