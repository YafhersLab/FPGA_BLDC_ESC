function BNO055_ReadAngles()
    % Configuración del puerto
    portName = 'COM5';
    baudRate = 9600;
    
    try
        % Intento de conexión con manejo de errores
        try
            serialObj = serialport(portName, baudRate);
            configureTerminator(serialObj, "LF");
            disp(['Conexión exitosa en el puerto ' portName]);
        catch connectErr
            error(['Error de conexión ' connectErr.message]);
        end
        
        % Configurar limpieza del puerto serial al cerrar el script
        cleanupObj = onCleanup(@() cleanup_serial(serialObj));
        disp('Leyendo datos... (Ctrl+C para detener)');

        % Bucle principal de lectura
        while true
            if (serialObj.NumBytesAvailable > 0)
                try
                    % Lectura de angulos del puerto serial
                    dataLine = readline(serialObj);
                    angles = split(strtrim(dataLine), ",");

                    % Comprobar si la lectura es correcta
                    if (numel(angles) == 11)
                        % Almacenar los valores CRUDOS en variables persistentes
                        yaw_raw = hex2dec_signed(angles{1});
                        roll_raw = hex2dec_signed(angles{2});
                        pitch_raw = hex2dec_signed(angles{3});
                        yaw_setpoint = hex2dec_signed(angles{4});
                        roll_setpoint = hex2dec_signed(angles{5});
                        pitch_setpoint = hex2dec_signed(angles{6});
                        motor_yaw_l = hex2dec_signed(angles{7});
                        motor_yaw_r = hex2dec_signed(angles{8});
                        motor_pitch_b = hex2dec_signed(angles{9});
                        motor_pitch_t = hex2dec_signed(angles{10});
                        command = hex2dec_signed(angles{11});
                        
                        % Calcular valores para mostrar (convertidos)
                        yaw_deg = yaw_raw / 100;
                        roll_deg = roll_raw / 100;
                        pitch_deg = pitch_raw / 100;
                        yaw_deg_setpoint = yaw_setpoint / 100;
                        roll_deg_setpoint = roll_setpoint / 100;
                        pitch_deg_setpoint = pitch_setpoint / 100;
            
                        % Asignación de variables globales
                        assignin('base', 'yaw_deg', yaw_raw);
                        assignin('base', 'roll_deg', roll_raw);
                        assignin('base', 'pitch_deg', pitch_raw);
                        assignin('base', 'yaw_deg_setpoint', yaw_setpoint);
                        assignin('base', 'roll_deg_setpoint', roll_setpoint);
                        assignin('base', 'pitch_deg_setpoint', pitch_setpoint);
                        assignin('base', 'command', command);

                        % Imprimir los valores
                        fprintf("Y: %.2f, R: %.2f, P: %.2f, YD: %.2f, RD: %.2f, PD: %.2f, MY_L: %.2f, MY_R: %.2f, MP_B: %.2f, MP_T: %.2f, CMD: %.2f\n", ...
                            yaw_deg, roll_deg, pitch_deg, yaw_deg_setpoint, roll_deg_setpoint, pitch_deg_setpoint, ...
                            motor_yaw_l, motor_yaw_r, motor_pitch_b, motor_pitch_t, command);
                    end
                   
                catch readErr
                    disp(['Error leyendo datos: ' readErr.message]);
                end
            end

            pause(0.01); % Pequeña pausa
        end
        
    catch ME
        % Manejo de errores generales
        if contains(ME.message, 'Operation terminated by user')
            disp('Programa detenido por el usuario.');
        else
            disp(['Error: ' ME.message]);
        end
    end
    
    %% Función de limpieza
    function cleanup_serial(sObj)
        try
            % Verificación antes de cerrar
            if exist('sObj', 'var') && ~isempty(sObj) && isvalid(sObj)
                clear sObj;
                disp('Puerto serial cerrado correctamente.');
            end
        catch cleanErr
            disp(['Error durante limpieza: ' cleanErr.message]);
        end
    end
    
    %% Función para convertir hexadecimal a decimal con signo (16 bits)
    function val = hex2dec_signed(hexStr)
        val = hex2dec(hexStr);
        if val >= 2^15
            val = val - 2^16;
        end
    end
end