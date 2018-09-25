%%PART 2
%We are designing a low pass filter. Considering this filter is probably designed to
%stop bullets, significant attenuation at higher frequencies is desired.
%A second order filter with a cutoff frequency of 4 Hz is a good initial
%approach.

%Borrowing from 222, we can derive the transfer function H(s) for a
%second-order low pass circuit as Wo^2/(s^2 + 2*d*Wo*s + Wo^2).
%For our system, we want an Wo value of 4 Hz and a damping coefficient of
%0.7071 for a critically damped system.

%From our textbook, we know that the transfer funtion H(s) = P(s)/Q(s).
%Thus, our second order differential equation is defined.

%(D^2 + 35.5D + 631.5)*y(t) = 631.5*x(t)

%We can demonstrate the response of this system with a bode plot, but we
%will also do it by plugging in sin functions for x(t).

s = sym('s');
sys = tf([631.5],[1 35.5 631.5]);
figure(1)
bode(sys)

w = [0.1:1:500];
amp_in = 10; %amplitude of x(t)
figure(2)
hold on
for i = 1:1:length(w)
    %H(w) = Vo/Vin;
    %Vo = H(w)*Vin;
    Vo = 631.5/(w(i)^2 + 35.5*w(i) + 631.5)*amp_in;
    plot(w(i)/(2*pi),Vo,'*')
end
xlabel('Frequency of Input (Hz)')
ylabel('Amplitude of Output')
title('Low Pass Filter Response (Input Amplitude = 10)')
    
    
    