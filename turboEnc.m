function [y] = turboEnc(trellis, interlvrIndices, x)
% setup
cConvEnc1 = comm.ConvolutionalEncoder('TrellisStructure',...
            trellis, 'TerminationMethod', 'Terminated');
cConvEnc2 = comm.ConvolutionalEncoder('TrellisStructure',...
            trellis, 'TerminationMethod', 'Terminated');
pN = log2(trellis.numOutputSymbols);
pMLen = log2(trellis.numStates);
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
end

