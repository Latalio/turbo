function [trellis] = trellisGen(nCons,codeGen,fbConn)
% 高进制形式的生成矩阵转换成二进制形式
nOutputs = length(codeGen);
codeGenBitVec = zeros(nOutputs,nCons);
for i=1:nOutputs
    codeGenBitVec(i,:) = dec2binvec(codeGen(i),nCons);
end

nStateBits = (nCons-1); 
nStates = 2^nStateBits;
bFbConn = fliplr(dec2binvec(fbConn,nCons));

% 状态转移
nextStates = zeros(nStates,2);
outputs = zeros(nStates,4);
for s=1:nStates
    sBinvec = dec2binvec(s-1,nStateBits);
    dk = 0;
    ak = mod(dk + bFbConn(1:nStateBits)*sBinvec.',2);
    [out1,nextState1] = enc(codeGenBitVec,ak,sBinvec);
    
    dk = 1;
    ak = mod(dk + bFbConn(2:end)*sBinvec',2);
    [out2,nextState2] = enc(codeGenBitVec,ak,sBinvec);
    
    nextStates(s,:) = [nextState1, nextState2];
    outputs(s,:) = [out1, out2];
end

% last
lastStates = zeros(nStates,2);
lastOutputs = zeros(nStates,4);
for s=1:nStates
    for dk=0:1
        lastStates(nextStates(s,dk+1), dk+1) = s;
        lastOutputs(nextStates(s,dk+1), dk+1) = outputs(s,dk+1);
    end
end
trellis.numStates = nStates;
trellis.nextStates = nextStates;
trellis.outputs = outputs;
trellis.lastStates = lastStates;
trellis.lastOutputs = lastOutputs;

end

%%
function [output, nextState] = enc(codeGenBitVec,ak,stateBinvec)
nStateBits = length(stateBinvec);
regs = [stateBinvec,ak];
output = mod(codeGenBitVec*regs',2)';
nextState = binvec2dec((regs(end-nStateBits+1:end)))+1;
end






