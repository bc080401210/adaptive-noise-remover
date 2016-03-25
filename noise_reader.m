%------------------------------------------------------------
% IN THE NAME OF ALLH, THE MOST BENEFICENT, THE MOST MERCIFUL
%-------------------------------------------------------------

clear all; close all; clc;


%%  Read Noise Signal 


[noise fs]=audioread('Voice_001.wav');
n1=noise(fs/2:fs);


figure(1),
subplot(2,1,1);


plot(n1(1:1000));

title('closer look at random noise');
%tic
sound(n1,fs);
%toc
n2 = n1(1:100);
subplot(2,1,2);plot(n2);
title('scopic look at noise');
disp(strcat(' length of noise is',num2str(length(noise)/fs)))

pause(5);
%%  Read Source Signal


[sig fs_s]=audioread('source.wav');


len_s=length(sig);

len_in_sec = len_s /fs_s;

disp(strcat(' length of source melody is =',num2str(len_in_sec)));
disp('extracting 5 second signal');

%extract 15 sec data
if(len_in_sec>5)
    
    sig = sig(fs_s*15:fs_s*20)';
    noise= noise(fs*15:fs*20);
end



%% Amplify melody a bit

Gain=4;

sig = sig * Gain;

% Play & Plot amplified melody

sound(sig,fs_s); %play desired signal


figure(2),
subplot(2,1,1),
plot(n1(1:2000));
title('closer look at Melody Signal');

subplot(2,1,2);plot(sig(1:200),'k*');
title('scopic look at Melody Signal');




%%  MIXER STAGE [ Mixing Noise and Melody to achive noisy signal]


pause(5);

if(length(sig)==length(noise))

    noisy_sig = sig + noise;
    
    
else
    disp('Error in signal Lengths');
end

sound(noisy_sig,fs); % Play Noisy Melody
figure(3),
plot(1:length(noisy_sig),noisy_sig,'r-');
title('Noisy Signal');% Plot noisy signal
axis([1,length(noisy_sig),-2,2]);



%%  FINALLY THE FILTERING STAGE
pause(2);

% Generating noisy ref noise signal

ref=noise;  
figure,%noisy noise
subplot(2,1,1)
plot(1:length(ref),ref);
title('reference  (noisy noise)   (input2)');


% LMS ADAPTIVE FILTER parameters

order=5;
w=zeros(order,1);
mu=.02;%step size


hlms2 = dsp.LMSFilter('Length', order, ...
   'Method', 'Normalized LMS',...
   'AdaptInputPort', true, ...
   'StepSizeSource', 'Input port', ...
   'WeightsOutputPort', false);


a = 1; % adaptation control

[y, err] = step(hlms2, sig, noisy_sig, mu, a);

% for i=1:length(noisy_sig)-order
%    buffer = ref(i:i+order-1);                              %current 32 points of reference
%    desired(i) = noisy_sig(i)-buffer'*w;                    %dot product reference and coeffs
%    md = mu*desired(i);
%    w=w+(buffer.*md/norm(buffer));%update coeffs
% end

pause(2);
sound(y,fs);
%sound(desired,fs);

subplot(2,1,2)
plot(1:length(y),y);
title('filtered Output');




%%  END OF PROGRAM

%COPYRIGH: STRANGE LAB
%AUTHOR: ABDUL REHMAN
%DATE: 23-MAR-2016
%TIME: 1:01 AM
%

%Bibliography:
%  ---http://www.mathworks.com/help/dsp/ref/dsp.lmsfilter-class.html
%------------------------------------------------------------------