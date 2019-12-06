frmLen = 40;                                   %设定每一帧信息数量
data = randi([0 1],frmLen,1);                   % 生成信息序列


%%%% turboEnc
% input
interlvrIndices = randperm(frmLen);
trellis = poly2trellis(3,[7 5],7);
x = data;

% encode
y = turboEnc(trellis, interlvrIndices, x);







