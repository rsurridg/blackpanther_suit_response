load('tempdata')
time = tempdata(:,1);
temp = tempdata(:,2);

%This curve has poor fit with a single exponential term and does not decay
%to 0
%ASSUMPTION 1:
%This response can be approximated as the sum of two natural modes.
%ASSUMPTION 2:
%The response decays towards a constant ambient temperature of 25*C

%If the time constant on the natural modes is sufficiently different, the
%initial decay will be primarily governed by the the mode with the smaller
%time constant, while the later decay will be primarily governed by the
%mode with the larger time constant.

%Therefore, time[0:0.5] will be used to estimate the smaller time constant.
region1_time = time(1:6);
region1_temp = temp(1:6);

% y = a*exp(b*x)
% ln y = ln a + b*x

% a0 = intercept = ln a
% a1 = slope = b

y_lin = log(region1_temp);
x_lin = region1_time;

n = length(x_lin);
sum_xy = sum(y_lin.*x_lin);
sum_x = sum(x_lin);
sum_y = sum(y_lin);
sum_x2 = sum(x_lin.^2);
sum_x_2 = sum_x^2;

a1 = (n*sum_xy - sum_x*sum_y)/(n*sum_x2 - sum_x_2);

%From curve fit, a*exp(b*x), b = -1.678

%A b value of -1.678 translates to a time constant (T1) of approximately
%0.60 seconds. By t = 5*T1, the influence of this mode will be orders of
%magnitude less than the mode with the larger time constant. 
%Therefore, we will calculate the next mode for time[3:3.5].

region2_time = time(31:36);
region2_temp = temp(31:36);

y_lin = log(region2_temp);
x_lin = region2_time;

n = length(x_lin);
sum_xy = sum(y_lin.*x_lin);
sum_x = sum(x_lin);
sum_y = sum(y_lin);
sum_x2 = sum(x_lin.^2);
sum_x_2 = sum_x^2;

a1 = (n*sum_xy - sum_x*sum_y)/(n*sum_x2 - sum_x_2);

%From curve fit, a*exp(b*x), b = -0.1624

%Natural response, yn(t) = C1*exp(-1.678*t) + C2*exp(-0.1624*t)

%roots = (x+1.678)(x+0.1624)
%characteristic polynomial = x^2 + 1.8404x + 0.2725

%system equation: (D^2 + 1.8404D + 0.2725)y(t) = P(D)x(t)

%Assuming that the forced response of the system is 25 in the original
%data, and the input that caused that response was x(t) = 25, then P(D)
%must equal AB because both the first and second derivative of a constant
%y(t) are zero.

%% INPUT 1
%x(t) = 300u(t) - 300(u(t-1))
%This can be done by convolution since h(t) can be found via the simplified
%impulse matching method, but it's faster and more straight-forward to break the input into two
%pieces and use the final conditions from the first block as the initial
%conditions for the second.

%FOR 0<t<1
%yn = K1*exp(-1.678*t) + K2*exp(-0.1624*t); %natural response
%yp = B; %forced response
%yp' = 0;
%yp'' = 0
%0.2725B = 0.2725*300;
%B = 300;
yp = 300;

%assuming initial conditions y(t) = 25 and y'(t) = 0
%25 = K1 + K2 + 300;
%K1 = -275 - K2
%0 = -1.678K1 - 0.1624K2
%K1 = -0.0968K2
%-0.0968K2 = -275 - K2
K2 = -275/(-0.0968+1);
K1 = -275 - K2;
t = 0:0.01:1;
ya =  K1*exp(-1.678*t) + K2*exp(-0.1624*t) + yp;
figure(1)
hold on
plot(t,ya)

t = 1;
dy1 = -1.678*K1*exp(-1.678*t) - 0.1624*K2*exp(-0.1624*t);
y1 =  K1*exp(-1.678*t) + K2*exp(-0.1624*t) + yp;

%FOR t>1
yp = 25;

%y1-25 = K1 + K2;
%dy1 = -1.678K1 - 0.1624K2

%K1 = y1 - 25 - K2;
%K1 = (dy1 + 0.1624K2)/(-1.678)
%y1 - 25 - K2 = (dy1 + 0.1624K2)/(-1.678)
K2 = (-1.678*(y1-25) - dy1)/(0.1624-1.678);
K1 = y1-25-K2;
t = 0:0.01:34;
yb = K1*exp(-1.678*t) + K2*exp(-0.1624*t) + yp;
x = t+1;
plot(x,yb)
title('Suit Response to x(t) = 300 (0<t<1)')
ylabel('Suit Temperature (C)')
xlabel('Time (s)')

knit_y = [ya yb];
knit_x = 0:0.01:35;

max_temp = max(knit_y);
max_temp_time = knit_x(find(knit_y==max(knit_y)));

range50 = find(knit_y>=50);
length50 = knit_x(range50(end)) - knit_x(range50(1));

%% INPUT 2
yp = 150;

%assuming initial conditions y(t) = 25 and y'(t) = 0
%25 = K1 + K2 + 150;
%K1 = -125 - K2

%0 = -1.678K1 - 0.1624K2
%K1 = -0.0968K2

%-0.0968K2 = -125 - K2
K2 = -125/(-0.0968+1);
K1 = -125 - K2;
t = 0:0.01:35;

y =  K1*exp(-1.678*t) + K2*exp(-0.1624*t) + yp;
figure(2)
hold on
plot(t,y)
title('Suit Response to x(t) = 150 (t>0)')
ylabel('Suit Temperature (C)')
xlabel('Time (s)')

temp70_time = t(find(y>=70,1));
temp50_time = t(find(y>=50,1));