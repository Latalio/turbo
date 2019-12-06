frmLen = 40;                                   %设定每一帧信息数量
data = randi([0 1],frmLen,1);                   % 生成信息序列


%%%% turboEnc
% input
interlvrIndices = randperm(frmLen);
trellis = poly2trellis(3,[7 5],7);


% encode
y = turboEnc(trellis, interlvrIndices, data);

SNR = -6;
    
noiseVar = 10^(-SNR/10);

hMod = comm.BPSKModulator;
    
hChan = comm.AWGNChannel('NoiseMethod','Signal to noise ratio (Es/No)', ...
        'EsNo',SNR);
hDemod = comm.BPSKDemodulator('DecisionMethod','Log-likelihood ratio', ...
        'Variance',noiseVar);
 
 encodedData = y;
    
% 进行调制
modSignal = step(hMod,encodedData);

% 添加噪声，得到接收信号
receivedSignal = step(hChan,modSignal);

%进行解调
demodSignal = step(hDemod,receivedSignal);

x = demodSignal;

% input
% trellis

% setup
blkLen = length(interlvrIndices); 
pN = log2(trellis.numOutputSymbols);
pMLen = log2(trellis.numStates);
pNumTails = pMLen*(pN);    



% Bit order
dIdx = (2*pN-1)*blkLen;
yD = reshape(x((1:dIdx).', 1), 2*pN-1, blkLen);
lc1D = yD(1:pN, :);
y1T = x(dIdx + (1:pNumTails).', 1);
Lc1_in = [lc1D(:); y1T];
            
Lu1_in = zeros(blkLen+pMLen, 1);
            
lc2D1 = zeros(1, blkLen);
lc2D2 = yD(pN+1:2*pN-1, :);
lc2D = [lc2D1; lc2D2];
y2T = x(dIdx + pNumTails + (1:pNumTails).', 1);
Lc2_in = [lc2D(:); y2T];