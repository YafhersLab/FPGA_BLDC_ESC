command_values = 0:6;

% Define los valores de entrada YAW
error_yaw_values = -180:5:180;
var_error_yaw_values = -50:5:50;

% Crea la tabla LUT vacía
fuzzy_lut_yaw = zeros(length(error_yaw_values), length(var_error_yaw_values), length(command_values), 2);

% Genera la tabla LUT con el nuevo FIS
for i = 1:length(error_yaw_values)
    for j = 1:length(var_error_yaw_values)
        for k = 1:length(command_values)
            input = [error_yaw_values(i), var_error_yaw_values(j), command_values(k)];
            output = evalfis(fuzzy_controller_yaw, input);
            fuzzy_lut_yaw(i, j, k, :) = output;
        end
    end
end

clear i j k;
clear input output;

% Define los valores de entrada PITCH
error_pitch_values = -90:5:90;
var_error_pitch_values = -30:5:30;

% Crea la tabla LUT vacía
fuzzy_lut_pitch = zeros(length(error_pitch_values), length(var_error_pitch_values), length(command_values), 2);


% Genera la tabla LUT con el nuevo FIS
for i = 1:length(error_pitch_values)
    for j = 1:length(var_error_pitch_values)
        for k = 1:length(command_values)
            input = [error_pitch_values(i), var_error_pitch_values(j), command_values(k)];
            output = evalfis(fuzzy_controller_pitch, input);
            fuzzy_lut_pitch(i, j, k, :) = output;
        end
    end
end

clear i j k;
clear input output;

% Guarda la LUT en un archivo
save('fuzzy_lut_yaw.mat', 'fuzzy_lut_yaw', 'error_yaw_values', 'var_error_yaw_values', 'command_values');
save('fuzzy_lut_pitch.mat', 'fuzzy_lut_pitch', 'error_pitch_values', 'var_error_pitch_values', 'command_values');
