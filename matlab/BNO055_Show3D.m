function BNO055_Show3D()
    % Configuración del puerto serial
    portName = 'COM5';
    baudRate = 9600;
    
    % Intento de conexión con manejo de errores
    try
        serialObj = serialport(portName, baudRate);
        configureTerminator(serialObj, "LF");
        disp(['Conectado al puerto ' portName]);
    catch connErr
        error(['No se pudo abrir el puerto: ' connErr.message]);
    end

    % Cierre automático del puerto al finalizar
    cleanupObj = onCleanup(@() cerrarPuerto(serialObj));

    % Dimensiones del cubo/paralelepípedo
    width =     0.4;
    height =    0.5;
    depth =     0.1;

    % Vértices del paralelepípedo
    vertices = [
        -width, -height, -depth;
         width, -height, -depth;
         width,  height, -depth;
        -width,  height, -depth;
        -width, -height,  depth;
         width, -height,  depth;
         width,  height,  depth;
        -width,  height,  depth;
    ];

    % Conexiones de las caras
    faces = [
        1, 2, 3, 4;
        5, 6, 7, 8;
        1, 2, 6, 5;
        2, 3, 7, 6;
        3, 4, 8, 7;
        4, 1, 5, 8
    ];

    % Crear figura 3D
    figure('Name', 'Visualización BNO055');
    hold on;
    axis equal;
    grid on;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    title('Visualización en Tiempo Real - BNO055');
    view(3);
    axis([-1.5, 1.5, -1.5, 1.5, -1.5, 1.5]);
    set(gca, 'Color', '#F0F0F0');
    light('Position', [1, 1, 1], 'Style', 'local');
    lighting gouraud;
    pause(1);

    try
        while true
            if serialObj.NumBytesAvailable > 0
                line = readline(serialObj);
                angles = split(strtrim(line), ",");

                if numel(angles) == 3
                    try
                        % Lectura de los angulos
                        yaw_raw   = hex2dec_signed(angles{1});
                        roll_raw  = hex2dec_signed(angles{2});
                        pitch_raw = hex2dec_signed(angles{3});
                        
                        % Conversion de angulos
                        yaw_deg   = yaw_raw / 16.0;
                        roll_deg  = roll_raw / 16.0;
                        pitch_deg = pitch_raw / 16.0;
                        
                        % Correción del yaw
                        if yaw_deg > 180
                            yaw_deg = yaw_deg - 360;
                        elseif yaw_deg < -180
                            yaw_deg = yaw_deg + 360;
                        end
                        
                        % Impresión de datos
                        fprintf("Yaw: %.2f, Roll: %.2f, Pitch: %.2f\n", ...
                                yaw_deg, roll_deg, pitch_deg);

                        % Convertir a radianes
                        yaw = deg2rad(yaw_deg);
                        pitch = deg2rad(roll_deg);
                        roll = deg2rad(pitch_deg);
    
                        % Matrices de rotación
                        R_x = [ 1,          0,          0;
                                0, -cos(roll),  sin(roll);
                                0,  sin(roll), cos(roll)];
    
                        R_y = [ cos(pitch), 0,  sin(pitch);
                                0,          1,  0;
                                sin(pitch), 0, -cos(pitch)];
    
                        R_z = [ -cos(yaw),  sin(yaw),   0;
                                sin(yaw),   cos(yaw),   0;
                                0,          0,          1];

                        % Rotación combinada
                        R = R_z * R_y * R_x;
                        rotated_vertices = (R * vertices')';

                        % Dibujar cubo
                        cla;
                        patch('Vertices', rotated_vertices, 'Faces', faces, ...
                              'FaceColor', '#4682B4', 'EdgeColor', 'k', 'LineWidth', 1.5);
                        drawnow;

                    catch rotErr
                        disp(['Error procesando rotación: ' rotErr.message]);
                    end
                end
            end

            % Salir si cierra la figura
            if ~ishandle(gcf)
                break;
            end

            pause(0.01);
        end
    catch ME
        % Manejo de errores generales
        disp(['Error en visualización: ' ME.message]);
    end

    %% Función para cerrar el puerto de forma segura
    function cerrarPuerto(sObj)
        try
            % Verificación antes de cerrar
            if exist('sObj', 'var') && ~isempty(sObj) && isvalid(sObj)
                clear sObj;
                disp('Puerto serial cerrado correctamente.');
            end
        catch err
            disp(['Error al cerrar puerto: ' err.message]);
        end
    end

    %% Conversión hex signed
    function val = hex2dec_signed(hexStr)
        val = hex2dec(hexStr);
        if val >= 2^15
            val = val - 2^16;
        end
    end
end
