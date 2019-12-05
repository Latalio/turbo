frmLen = 40;                                   %设定每一帧信息数量
data = randi([0 1],frmLen,1);                   % 生成信息序列


%%%% turboEnc
% input
interlvrIndices = randperm(frmLen);
trellisStructure = poly2trellis(3,[7 5],7);
x = data;

% setup
cConvEnc1 = comm.ConvolutionalEncoder('TrellisStructure',...
            trellisStructure, 'TerminationMethod', 'Terminated');
cConvEnc2 = comm.ConvolutionalEncoder('TrellisStructure',...
            trellisStructure, 'TerminationMethod', 'Terminated');
pN = log2(trellisStructure.numOutputSymbols);
pMLen = log2(trellisStructure.numStates);
pNumTails = pMLen*(pN);        


blkLen = length(interlvrIndices);

y1 = step(cConvEnc1, x);
y2 = step(cConvEnc2, x(interlvrIndices));

% Bit reorder
dIdx = pN * blkLen;
y1D = reshape(y1((1:dIdx).'), pN, blkLen);
y2D = reshape(y2((1:dIdx).'), pN, blkLen);

% Remove 2nd systematic
yDTemp = [y1D; y2D(2:pN,:)];

%   Get tails
y1T = y1(dIdx + (1:pNumTails).');
y2T = y2(dIdx + (1:pNumTails).');
            
%   Append tails to end
y = [yDTemp(:); y1T(:); y2T(:)];


% hTEnc = comm.TurboEncoder('TrellisStructure',poly2trellis(3,[7 5],7),'InterleaverIndices',interlvrIndices);
% encodedData = step(hTEnc,data);



