%Turbo��������
clear
clc

SNR= [-6, -5.5, -5, -4.5];                                  %�趨�����[-6, -5.75, -5.5, -5.25]
frameLoop = [1*(10^5),2*(10^5),5*(10^5),1*(10^6)];                %ÿ������ȴ������֡��

frameErrorRate = zeros(1,length(SNR));  


frmLen = 40;                                   %�趨ÿһ֡��Ϣ����
rng default

intrlvrIndices = randperm(frmLen);

hTEnc = comm.TurboEncoder('TrellisStructure',poly2trellis(3, ...
    [7 5],7),'InterleaverIndices',intrlvrIndices);

hTDec = comm.TurboDecoder('TrellisStructure',poly2trellis(3, ...
    [7 5],7),'InterleaverIndices',intrlvrIndices, ...
    'NumIterations',5);

hMod = comm.BPSKModulator;



for snr_index = 1:1:length(SNR)
    %��ӡ�м���
    frameErrorRate    
    
    SNR_ThisPoint = SNR(snr_index);
    
    noiseVar = 10^(-SNR_ThisPoint/10);
    
    hChan = comm.AWGNChannel('NoiseMethod','Signal to noise ratio (Es/No)', ...
        'EsNo',SNR_ThisPoint);
    
    hDemod = comm.BPSKDemodulator('DecisionMethod','Log-likelihood ratio', ...
        'Variance',noiseVar);
    
    frameErrorNumber = zeros(1,frameLoop(snr_index));                       %ȡֵΪ1����ʾ������֡
    
    for frmIdx = 1:frameLoop(snr_index)
        % ���ɳ�ʼ����Ϣ���У�ά�� frmLen*1��ÿ��Ԫ�����ȡֵ0����1
        data = randi([0 1],frmLen,1);

        % ����Turbo�����
        encodedData = step(hTEnc,data);

        % ���е���
        modSignal = step(hMod,encodedData);

        % �����������õ������ź�
        receivedSignal = step(hChan,modSignal);

        %���н��
        demodSignal = step(hDemod,receivedSignal);

        %����Turbo����
        receivedBits = step(hTDec,-demodSignal);

        %�����������жϣ�ͳ���������
%         errorStats = step(hError,data,receivedBits);
        if(sum(abs(receivedBits-data))~=0)
            frameErrorNumber(frmIdx) = 1;
        end
        
    end
    
    frameErrorRate(snr_index) = mean(frameErrorNumber);    
    
end

%��ӡ���
frameErrorRate

%����FER����
semilogy(SNR,frameErrorRate,'b-d')
hold on

xlabel('SNR')
ylabel('FER')



