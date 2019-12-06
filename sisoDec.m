function [Lu_out] = sisoDec(Lu_in, Lc_in, trellis)


% setup
Infty = 1e10;
blkLen = length(Lu_in);
nStates = trellis.numStates;
lastStates = trellis.lastStates;
lastOutputs = trellis.lastOutputs;
%----------------
lcD = reshape(Lc_in, pN, blkLen);

A(1,1) = 0;
A(1,2:nStates) = -Infty*ones(1, nStates-1);

B(blkLen, 1) = 0;
B(blkLen, 1:nStates) = -Infty*ones(1, nStates-1);

% 前向递推计算alpha 
for k=2:blkLen+1
    for s = 1:nStates
        M = -Infty*ones(1,nStates);
        M(lastStates(s,dk+1)) = (-lcD(1,k-1)+lcD(2,k-1)*lastOutputs(s,2)) - log(1+exp(Lu_in(k-1)));
        M(lastStates(s,dk+1)) = ( lcD(1,k-1)+lcD(2,k-1)*lastOutputs(s,4)) - log(1+exp(Lu_in(k-1)))+Lu_in(k-1);
        
      if(sum(exp(M+A(k-1,:))) < 1e-300)
          A(k,s) = -Infty;
      else
          A(k,s) = log(sum(exp(M+A(k-1,:))));
      end
    end
    
    Amax = max(A(k,:));
    A(k,:) = A(k,:) - Amax;
end

for k=blkLen-1:-1:1
    for s=1:nStates
      M = -Infty*ones(1,nStates);
      M(nextStates(s,1)) = (-lcD(1,k+1)+lcD(2,k+1)*nextOutputs(s, 2)) - log(1+exp(Lu_in(k+1)));
      M(nextStates(s,2)) = (-lcD(1,k+1)+lcD(2,k+1)*nextOutputs(s, 4)) - log(1+exp(Lu_in(k+1)))+Lu_in(k+1);
        
      if(sum(exp(M+B(k+1,:)))<1e-300) 
          B(k,s) = -Infty;
      else
          B(k,s) = log(sum(exp(M+B(k+1,:)))); 
      end
    end
    
    Bmax = max(B(k,:));
    B(k,:) = B(k,:) - Bmax;
end

for k=1:blkLen
    for s=1:nStates
        M1 = (-lcD(1,k)+lcD(2,k)*lastOutputs(s,2)) - log(1+exp(Lu_in(k)));
        M2 = ( lcD(1,k)+lcD(2,k)*lastOutputs(s,4)) - log(1+exp(Lu_in(k)))+Lu_in(k);
        
        tmp1(s) = exp(M1 + A(k,lastStates(s,1)) + B(k,s));
        tmp2(s) = exp(M2 + A(k,lastStates(s,2)) + B(k,s));
    end
    L_all(k) = log(sum(tmp2)) - log(sum(tmp1));
end
        
        
        
        
        
        
        
        
        
        
end

