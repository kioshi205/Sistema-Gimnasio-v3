INSERT INTO PLAN (id_plan, nombre_plan, descripcion, precio_base, duracion_dias) VALUES
                                                                                     (1, 'Básico', 'Sala de máquinas y pesas; Wifi gratis; Acceso al dispensador de agua purificada; Uso de casilleros', 90, 30),
                                                                                     (2, 'Medio', 'Sala de máquinas y pesas; Zona de cardio; Wifi gratis; Acceso al dispensador de agua purificada; Zona de descanso y lounge; Ingreso a las duchas; Uso de casilleros; Equipo de entrenamiento y lavado', 195, 30),
                                                                                     (3, 'Pro', 'Sala de máquinas y pesas; Zona de cardio; Zona funcional; Wifi gratis; Acceso al dispensador de agua purificada; Zona de descanso y lounge; Estación de carga de celulares; Ingreso a las duchas; Uso de casilleros; Equipo de entrenamiento y lavado; Uso de secadores de cabello; Kit de aseo personal; Acceso a máquinas de relajación muscular; Sauna; Reloj de mano cardiomedidor; Parking de auto', 410, 30);

INSERT INTO CATEGORIA (id_categoria, nombre_categoria, descripcion) VALUES
                                                                        (1, 'Zonas de Entrenamiento', 'Áreas del gimnasio para entrenar'),
                                                                        (2, 'Servicios Generales', 'Servicios de uso común para todos los socios'),
                                                                        (3, 'Higiene y Comodidad', 'Duchas, casilleros, equipo de lavado y aseo'),
                                                                        (4, 'Recuperación Muscular', 'Equipos e instalaciones para recuperarse después de entrenar'),
                                                                        (5, 'Monitoreo', 'Dispositivos y herramientas para medir el progreso del socio'),
                                                                        (6, 'Movilidad', 'Facilidades de estacionamiento');

INSERT INTO SUBPRODUCTO (id_subproducto, id_categoria, nombre_subproducto, precio_individual) VALUES
                                                                                                  (1, 1, 'Sala de máquinas y pesas', 50),
                                                                                                  (2, 1, 'Zona de cardio', 35),
                                                                                                  (3, 1, 'Zona funcional', 30),
                                                                                                  (4, 2, 'Wifi gratis', 10),
                                                                                                  (5, 2, 'Acceso al dispensador de agua purificada', 10),
                                                                                                  (6, 2, 'Zona de descanso y lounge', 15),
                                                                                                  (7, 2, 'Estación de carga de celulares', 10),
                                                                                                  (8, 3, 'Ingreso a las duchas', 30),
                                                                                                  (9, 3, 'Uso de casilleros', 20),
                                                                                                  (10, 3, 'Equipo de entrenamiento y lavado', 25),
                                                                                                  (11, 3, 'Uso de secadores de cabello', 10),
                                                                                                  (12, 3, 'Kit de aseo personal', 15),
                                                                                                  (13, 4, 'Acceso a máquinas de relajación muscular', 40),
                                                                                                  (14, 4, 'Sauna', 35),
                                                                                                  (15, 4, 'Zona de estiramiento y foam rollers', 15),
                                                                                                  (16, 5, 'Reloj de mano cardiomedidor', 35),
                                                                                                  (17, 5, 'Evaluación en balanza de bioimpedancia', 25),
                                                                                                  (18, 5, 'Rutina digital en app', 20),
                                                                                                  (19, 6, 'Parking de auto', 40),
                                                                                                  (20, 6, 'Parking de moto y bicicleta', 15);

INSERT INTO CLIENTE (id_cliente, dni, nombre, apellido, telefono, email) VALUES
                                                                             (1, '70112233', 'María', 'Rojas Paucar', '912345001', 'maria.rojas@correo.pe'),
                                                                             (2, '70223344', 'Luis', 'Ccora Yupanqui', '912345002', 'luis.ccora@correo.pe'),
                                                                             (3, '70990011', 'Valeria', 'Huaccho Rivera', '912345009', 'valeria.huaccho@correo.pe'),
                                                                             (4, '71001122', 'Andrés', 'Tovar Gómez', '912345010', 'andres.tovar@correo.pe');

INSERT INTO CUPON (id_cupon, codigo, descripcion, porcentaje_descuento, fecha_inicio, fecha_fin, estado) VALUES
                                                                                                             (1, 'BIENVENIDA10', 'Descuento de bienvenida para nuevos socios', 10, '2026-11-01', '2026-12-31', 'ACTIVO'),
                                                                                                             (2, 'VERANO15', 'Promoción campaña de verano', 15, '2027-01-01', '2027-02-28', 'ACTIVO');

INSERT INTO SUSCRIPCION (id_suscripcion, id_cliente, id_plan, id_cupon, detalle, fecha_inicio, fecha_fin, monto_total) VALUES
                                                                                                                           (1, 1, 2, NULL, 'Sala de máquinas y pesas; Zona de cardio; Wifi gratis; Acceso al dispensador de agua purificada; Zona de descanso y lounge; Ingreso a las duchas; Uso de casilleros; Equipo de entrenamiento y lavado', '2026-09-01', '2026-10-01', 195),
                                                                                                                           (2, 2, 1, NULL, 'Sala de máquinas y pesas; Wifi gratis; Acceso al dispensador de agua purificada; Uso de casilleros', '2026-09-05', '2026-10-05', 90),
                                                                                                                           (3, 3, 2, NULL, 'Sala de máquinas y pesas; Zona de cardio; Wifi gratis; Acceso al dispensador de agua purificada; Zona de descanso y lounge; Ingreso a las duchas; Uso de casilleros; Equipo de entrenamiento y lavado', '2026-11-02', '2026-12-02', 195),
                                                                                                                           (4, 4, NULL, NULL, 'Sala de máquinas y pesas; Zona funcional; Wifi gratis; Ingreso a las duchas; Zona de estiramiento y foam rollers; Parking de moto y bicicleta', '2026-11-03', '2026-12-03', 150);

INSERT INTO MARCACION_ACCESO (id_acceso, id_cliente, id_suscripcion, fecha_acceso, hora_acceso, resultado) VALUES
                                                                                                               (1, 3, 3, '2026-11-18', '07:30:00', 'PERMITIDO'),
                                                                                                               (2, 4, 4, '2026-11-18', '18:45:00', 'PERMITIDO'),
                                                                                                               (3, 3, 3, '2026-11-20', '08:10:00', 'PERMITIDO'),
                                                                                                               (4, 1, NULL, '2026-11-20', '19:05:00', 'DENEGADO');

ALTER TABLE PLAN ALTER COLUMN id_plan RESTART WITH 4;
ALTER TABLE CATEGORIA ALTER COLUMN id_categoria RESTART WITH 7;
ALTER TABLE SUBPRODUCTO ALTER COLUMN id_subproducto RESTART WITH 21;
ALTER TABLE CLIENTE ALTER COLUMN id_cliente RESTART WITH 5;
ALTER TABLE CUPON ALTER COLUMN id_cupon RESTART WITH 3;
ALTER TABLE SUSCRIPCION ALTER COLUMN id_suscripcion RESTART WITH 5;
ALTER TABLE MARCACION_ACCESO ALTER COLUMN id_acceso RESTART WITH 5;