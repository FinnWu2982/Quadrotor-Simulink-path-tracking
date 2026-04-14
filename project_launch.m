clear all
close all

%% PATH PLANNING %% 
wait_time = 0.1;  

tau_v = 0.1;

x_bound = [-1500 / wait_time, 50];
y_bound = [-1000 / wait_time, 120];
z_bound = [-50, 0];

[final_path, final_yaw] = plan_path(wait_time);

%% MODEL LAUNCH %%
[x_in, y_in, z_in, yaw_in] = compute_sim_in(final_path, final_yaw, wait_time);

global K_px K_dx K_py K_dy K_pz K_dz K_p_phi K_d_phi K_p_theta K_d_theta K_p_psi K_d_psi Jr I_mat L k b m g;

%% TODO: Please fill the parameters below: %%
% ===== Position loop (accel commands) =====
K_px = 0.6; 
K_dx = 1.2; 
K_py = 0.6; 
K_dy = 1.2; 
K_pz = 1.2; 
K_dz = 1.8; 

% ===== Attitude loop (body angular accel commands) =====
K_p_phi   = 25; 
K_d_phi   = 8; 
K_p_theta = 25; 
K_d_theta = 8; 
K_p_psi   = 9; 
K_d_psi   = 4;

% Physical Parameters (Derived from Report & Project Description)
m = 1.7006;         % Total mass [kg] (Report Table 1)
L = 0.25;           % Arm length [m] (500mm wheelbase / 2)
k = 0.09;           % Thrust coefficient (Project Description pg.8)
b = 0.07;           % Drag coefficient (Project Description pg.8)

% Inertia Calculations (Based on Project Description Appendix A)
m_motor = 0.1;              % Assumed motor weight [kg]
m_drone = m - 4 * m_motor;  % Body mass [kg]
r_body = L / 4;             % Effective body radius [m]
r_prop = 0.127;             % Propeller radius (10 inch prop) [m]

% Calculated Moments of Inertia
Jr = 0.01 * m_motor * r_prop^2;     
Ixx = (2/5) * m_drone * r_body^2 + 2 * L^2 * m_motor;
Iyy = Ixx;                          % Symmetric body
Izz = (2/5) * m_drone * r_body^2 + 4 * L^2 * m_motor;

I_mat = diag([Ixx Iyy Izz]);

%% Parameters
g = 9.81;

sim('Quadrotor_Model.slx');

fprintf("Simulation finished")

%% PLOT RESULT %%
plot_path_2d(final_path, x_out, y_out, x_bound, y_bound);
plot_path_3d(final_path, x_out, y_out, z_out, x_bound, y_bound, z_bound);