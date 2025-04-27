%1)%
alpha_v=[0,0.25,0.75,1];
f0=1; %ancho de banda ¿6?%
t=linspace(0,1/f0,100) ;
figure;
for k=1:length(alpha_v)
    alpha=alpha_v(k);
    B=f0*(alpha +1);
    f= linspace(-2*B,2*B,100);
    f1=f0*(1-alpha);
    f_delta=B-f0;
    he=zeros(1,length(f));
    for i = 1:length(f)
        fi=abs(f(i));
        if fi < f1
            he(i)= 1;
        elseif fi < B
            he(i)=0.5*(1+ cos((pi *(fi-f1))/(2*f_delta)));
        else
            he(i)=0;
        end
    end
    het=ifft(he);
    subplot(2,2,k);
    plot(t,het);
    title('Respuesta a impulso ')
    xlabel('Tiempo[s]');
    ylabel('h_e(t)');
    grid on;
end
sgtitle('Respuestas a impulso para diferente factores de roll-off');
figure;
for k=1:length(alpha_v)
    alpha=alpha_v(k);
    B=f0*(alpha + 1);
    f= linspace(-2*B,2*B,100);
    f1=f0*(1-alpha);
    f_delta=B-f0;
    he=zeros(1,length(f));
    for i = 1:length(f)
        fi=abs(f(i));
        if fi < f1
            he(i)= 1;
        elseif fi < B
            he(i)=0.5*(1+ cos(pi *(fi-f1)/(2*f_delta)));
        else
            he(i)=0;
        end
    end
    subplot(2,2,k);
    plot(f,he);
    title('Respuesta a frecuencia ')
    xlabel('Frecuencia(Hz)');
    ylabel('h_e(f)');
    grid on;
end
sgtitle('Respuestas a frecuencia para diferente factores de roll-off');

bits = 104;
bits_tx = randi([0 1], 1, bits);           
symbols = 2*bits_tx - 1;                   
sps = 8;                                   
fs = 100;                                 
T = 1;                                     
alpha_v = [0, 0.25, 0.75, 1]; 
snr_dB = 20;                               


for k = 1:length(alpha_v)
    alpha = alpha_v(k);
    span = 10; 
    rrc_filter = rcosdesign(alpha, span, sps);
    tx_upsampled = repelem(symbols, sps); 
    tx_filtered = conv(tx_upsampled, rrc_filter, 'same'); 
    tx_noisy = awgn(tx_filtered, snr_dB, 'measured');
    figure;
    eyediagram(tx_noisy, 2*sps);
    title(['Diagrama de ojo (α = ' num2str(alpha) ')']);
end