frmLen = 40;                                   %�趨ÿһ֡��Ϣ����
data = randi([0 1],frmLen,1);                   % ������Ϣ����


%%%% turboEnc
% input
interlvrIndices = randperm(frmLen);
trellis = poly2trellis(3,[7 5],7);
x = data;

% encode
y = turboEnc(trellis, interlvrIndices, x);







