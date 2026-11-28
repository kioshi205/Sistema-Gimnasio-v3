INSERT INTO PLAN (id_plan, nombre_plan, precio_base, duracion_dias) VALUES
                                                                        (1, 'Básico', 90.00, 30),
                                                                        (2, 'Medio', 195.00, 30),
                                                                        (3, 'Pro', 410.00, 30);

INSERT INTO CATEGORIA (id_categoria, nombre_categoria, descripcion) VALUES
                                                                        (1, 'Zonas de Entrenamiento', 'Áreas del gimnasio para entrenar'),
                                                                        (2, 'Servicios Generales', 'Servicios de uso común para todos los socios'),
                                                                        (3, 'Higiene y Comodidad', 'Duchas, casilleros, equipo de lavado y aseo'),
                                                                        (4, 'Recuperación Muscular', 'Equipos e instalaciones para recuperarse después de entrenar'),
                                                                        (5, 'Monitoreo', 'Dispositivos y herramientas para medir el progreso del socio'),
                                                                        (6, 'Movilidad', 'Facilidades de estacionamiento');

INSERT INTO SUBPRODUCTO (id_subproducto, id_categoria, nombre_subproducto, precio_individual) VALUES
                                                                                                  (1, 1, 'Sala de máquinas y pesas', 50.00),
                                                                                                  (2, 1, 'Zona de cardio', 35.00),
                                                                                                  (3, 1, 'Zona funcional', 30.00),
                                                                                                  (4, 2, 'Wifi', 10.00),
                                                                                                  (5, 2, 'Acceso al dispensador de agua purificada', 10.00),
                                                                                                  (6, 2, 'Zona de descanso y lounge', 15.00),
                                                                                                  (7, 2, 'Estación de carga de celulares', 10.00),
                                                                                                  (8, 3, 'Ingreso a las duchas', 30.00),
                                                                                                  (9, 3, 'Uso de casilleros', 20.00),
                                                                                                  (10, 3, 'Equipo de entrenamiento y lavado', 25.00),
                                                                                                  (11, 3, 'Uso de secadores de cabello', 10.00),
                                                                                                  (12, 3, 'Kit de aseo personal', 15.00),
                                                                                                  (13, 4, 'Acceso a máquinas de relajación muscular', 40.00),
                                                                                                  (14, 4, 'Sauna', 35.00),
                                                                                                  (15, 4, 'Zona de estiramiento y foam rollers', 15.00),
                                                                                                  (16, 5, 'Reloj de mano cardiomedidor', 35.00),
                                                                                                  (17, 5, 'Evaluación en balanza de bioimpedancia', 25.00),
                                                                                                  (18, 5, 'Rutina digital en app', 20.00),
                                                                                                  (19, 6, 'Parking de auto', 40.00),
                                                                                                  (20, 6, 'Parking de moto y bicicleta', 15.00);

-- Plan 1: Básico (S/ 90)
INSERT INTO PLAN_SUBPRODUCTO (id_plan, id_subproducto) VALUES
                                                           (1, 1), (1, 4), (1, 5), (1, 9);

-- Plan 2: Medio (S/ 195)
INSERT INTO PLAN_SUBPRODUCTO (id_plan, id_subproducto) VALUES
                                                           (2, 1), (2, 2), (2, 4), (2, 5), (2, 6), (2, 8), (2, 9), (2, 10);

-- Plan 3: Pro (S/ 410)
INSERT INTO PLAN_SUBPRODUCTO (id_plan, id_subproducto) VALUES
                                                           (3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (3, 6), (3, 7), (3, 8),
                                                           (3, 9), (3, 10), (3, 11), (3, 12), (3, 13), (3, 14), (3, 16), (3, 19);

INSERT INTO CLIENTE (id_cliente, dni, nombre, apellido, telefono, email) VALUES
                                                                             (1, '70112233', 'María', 'Rojas Paucar', '912345001', 'maria.rojas@correo.pe'),
                                                                             (2, '70223344', 'Luis', 'Ccora Yupanqui', '912345002', 'luis.ccora@correo.pe'),
                                                                             (3, '70990011', 'Valeria', 'Huaccho Rivera', '912345009', 'valeria.huaccho@correo.pe'),
                                                                             (4, '71001122', 'Andrés', 'Tovar Gómez', '912345010', 'andres.tovar@correo.pe'),
                                                                             (5, '71234567', 'Camila', 'Quispe Mendoza', '964112233', 'camila.quispe@correo.pe'),
                                                                             (6, '71345678', 'Diego', 'Paredes Flores', '964223344', 'diego.paredes@correo.pe'),
                                                                             (7, '71456789', 'Sofía', 'Vargas Salazar', '964334455', 'sofia.vargas@correo.pe'),
                                                                             (8, '71567890', 'Mateo', 'Lozano Ramos', '964445566', 'mateo.lozano@correo.pe'),
                                                                             (9, '71678901', 'Lucía', 'Espinoza Castro', '964556677', 'lucia.espinoza@correo.pe'),
                                                                             (10, '71789012', 'Sebastián', 'Meza Vilchez', '964667788', 'sebastian.meza@correo.pe'),
                                                                             (11, '71890123', 'Fernanda', 'Chávez Soto', '964778899', 'fernanda.chavez@correo.pe'),
                                                                             (12, '71901234', 'Rodrigo', 'Gutiérrez Campos', '964889900', 'rodrigo.gutierrez@correo.pe'),
                                                                             (13, '72012345', 'Paola', 'Navarro León', '964990011', 'paola.navarro@correo.pe'),
                                                                             (14, '72123456', 'Gabriel', 'Hinojosa Pérez', '964101112', 'gabriel.hinojosa@correo.pe'),
                                                                             (15, '72234567', 'Daniela', 'Montalvo Ruiz', '964202223', 'daniela.montalvo@correo.pe');

INSERT INTO CUPON (id_cupon, codigo, descripcion, porcentaje_descuento, fecha_inicio, fecha_fin, estado) VALUES
                                                                                                             (1, 'BIENVENIDA25', 'Descuento de bienvenida para nuevos socios', 25, '2026-11-01', '2026-12-31', 'ACTIVO'),
                                                                                                             (2, 'VERANO25', 'Promoción campaña de verano', 25, '2027-01-01', '2027-02-28', 'ACTIVO'),
                                                                                                             (3, 'CAMPAÑA25', 'Descuento promocional de campaña 25%', 25, '2026-11-01', '2027-12-31', 'ACTIVO'),
                                                                                                             (4, 'VENCIDO25', 'Cupón de prueba vencido', 25, '2026-01-01', '2026-01-31', 'ACTIVO'),
                                                                                                             (5, 'APERTURA25', 'Campaña de apertura Huancayo 25%', 25, '2026-07-01', '2026-09-30', 'ACTIVO'),
                                                                                                             (6, 'PRIMAVERA25', 'Promoción mes de la primavera 25%', 25, '2026-09-01', '2026-10-31', 'ACTIVO'),
                                                                                                             (7, 'NOVIEMBRE25', 'Campaña Black Fitness noviembre 25%', 25, '2026-11-01', '2026-12-31', 'ACTIVO');


INSERT INTO SUSCRIPCION (id_suscripcion, id_cliente, id_plan, id_cupon, detalle, fecha_inicio, fecha_fin, monto_total, meses_consecutivos) VALUES
-- Base original (IDs 1 al 4) con fechas coherentes y montos exactos
(1, 1, 2, NULL, 'Sala de máquinas y pesas; Zona de cardio; Wifi; Acceso al dispensador de agua purificada; Zona de descanso y lounge; Ingreso a las duchas; Uso de casilleros; Equipo de entrenamiento y lavado', '2026-09-01', '2026-10-01', 195.00, 1),
(2, 2, 1, NULL, 'Sala de máquinas y pesas; Wifi; Acceso al dispensador de agua purificada; Uso de casilleros', '2026-09-05', '2026-10-05', 90.00, 2),
(3, 3, 2, NULL, 'Sala de máquinas y pesas; Zona de cardio; Wifi; Acceso al dispensador de agua purificada; Zona de descanso y lounge; Ingreso a las duchas; Uso de casilleros; Equipo de entrenamiento y lavado', '2026-11-18', '2026-12-18', 195.00, 2),
(4, 4, NULL, NULL, 'Sala de máquinas y pesas; Zona funcional; Wifi; Ingreso a las duchas; Zona de estiramiento y foam rollers; Parking de moto y bicicleta', '2026-11-03', '2026-12-03', 127.50, 3),

-- Historial previo real de Clientes 2, 3 y 4 (coherencia con INT17 y meses_consecutivos)
(5, 2, 1, NULL, 'Sala de máquinas y pesas; Wifi; Acceso al dispensador de agua purificada; Uso de casilleros', '2026-08-06', '2026-09-05', 90.00, 1),
(6, 3, 2, NULL, 'Sala de máquinas y pesas; Zona de cardio; Wifi; Acceso al dispensador de agua purificada; Zona de descanso y lounge; Ingreso a las duchas; Uso de casilleros; Equipo de entrenamiento y lavado', '2026-10-19', '2026-11-18', 195.00, 1),
(7, 4, NULL, NULL, 'Sala de máquinas y pesas; Zona funcional; Wifi; Ingreso a las duchas; Zona de estiramiento y foam rollers; Parking de moto y bicicleta', '2026-09-04', '2026-10-04', 127.50, 1),
(8, 4, NULL, NULL, 'Sala de máquinas y pesas; Zona funcional; Wifi; Ingreso a las duchas; Zona de estiramiento y foam rollers; Parking de moto y bicicleta', '2026-10-04', '2026-11-03', 127.50, 2),

-- Cliente 5 (Camila): 4 meses consecutivos Plan Pro (mes 1 con cupón 25%, mes 4 con fidelidad 20%)
(9, 5, 3, 5, 'Sala de máquinas y pesas; Zona de cardio; Zona funcional; Wifi; Acceso al dispensador de agua purificada; Zona de descanso y lounge; Estación de carga de celulares; Ingreso a las duchas; Uso de casilleros; Equipo de entrenamiento y lavado; Uso de secadores de cabello; Kit de aseo personal; Acceso a máquinas de relajación muscular; Sauna; Reloj de mano cardiomedidor; Parking de auto', '2026-08-15', '2026-09-14', 307.50, 1),
(10, 5, 3, NULL, 'Sala de máquinas y pesas; Zona de cardio; Zona funcional; Wifi; Acceso al dispensador de agua purificada; Zona de descanso y lounge; Estación de carga de celulares; Ingreso a las duchas; Uso de casilleros; Equipo de entrenamiento y lavado; Uso de secadores de cabello; Kit de aseo personal; Acceso a máquinas de relajación muscular; Sauna; Reloj de mano cardiomedidor; Parking de auto', '2026-09-14', '2026-10-14', 410.00, 2),
(11, 5, 3, NULL, 'Sala de máquinas y pesas; Zona de cardio; Zona funcional; Wifi; Acceso al dispensador de agua purificada; Zona de descanso y lounge; Estación de carga de celulares; Ingreso a las duchas; Uso de casilleros; Equipo de entrenamiento y lavado; Uso de secadores de cabello; Kit de aseo personal; Acceso a máquinas de relajación muscular; Sauna; Reloj de mano cardiomedidor; Parking de auto', '2026-10-14', '2026-11-13', 410.00, 3),
(12, 5, 3, NULL, 'Sala de máquinas y pesas; Zona de cardio; Zona funcional; Wifi; Acceso al dispensador de agua purificada; Zona de descanso y lounge; Estación de carga de celulares; Ingreso a las duchas; Uso de casilleros; Equipo de entrenamiento y lavado; Uso de secadores de cabello; Kit de aseo personal; Acceso a máquinas de relajación muscular; Sauna; Reloj de mano cardiomedidor; Parking de auto', '2026-11-13', '2026-12-13', 328.00, 4),

-- Cliente 6 (Diego): 4 meses consecutivos Plan Medio (mes 4 con fidelidad 20%)
(13, 6, 2, NULL, 'Sala de máquinas y pesas; Zona de cardio; Wifi; Acceso al dispensador de agua purificada; Zona de descanso y lounge; Ingreso a las duchas; Uso de casilleros; Equipo de entrenamiento y lavado', '2026-08-20', '2026-09-19', 195.00, 1),
(14, 6, 2, NULL, 'Sala de máquinas y pesas; Zona de cardio; Wifi; Acceso al dispensador de agua purificada; Zona de descanso y lounge; Ingreso a las duchas; Uso de casilleros; Equipo de entrenamiento y lavado', '2026-09-19', '2026-10-19', 195.00, 2),
(15, 6, 2, NULL, 'Sala de máquinas y pesas; Zona de cardio; Wifi; Acceso al dispensador de agua purificada; Zona de descanso y lounge; Ingreso a las duchas; Uso de casilleros; Equipo de entrenamiento y lavado', '2026-10-19', '2026-11-18', 195.00, 3),
(16, 6, 2, NULL, 'Sala de máquinas y pesas; Zona de cardio; Wifi; Acceso al dispensador de agua purificada; Zona de descanso y lounge; Ingreso a las duchas; Uso de casilleros; Equipo de entrenamiento y lavado', '2026-11-18', '2026-12-18', 156.00, 4),

-- Cliente 7 (Sofía): 3 meses consecutivos Plan Básico (Por vencer, lista para probar RN04)
(17, 7, 1, NULL, 'Sala de máquinas y pesas; Wifi; Acceso al dispensador de agua purificada; Uso de casilleros', '2026-09-02', '2026-10-02', 90.00, 1),
(18, 7, 1, NULL, 'Sala de máquinas y pesas; Wifi; Acceso al dispensador de agua purificada; Uso de casilleros', '2026-10-02', '2026-11-01', 90.00, 2),
(19, 7, 1, NULL, 'Sala de máquinas y pesas; Wifi; Acceso al dispensador de agua purificada; Uso de casilleros', '2026-11-01', '2026-12-01', 90.00, 3),

-- Cliente 8 (Mateo): Plan Pro vigente usando cupón NOVIEMBRE25 (25%)
(20, 8, 3, 7, 'Sala de máquinas y pesas; Zona de cardio; Zona funcional; Wifi; Acceso al dispensador de agua purificada; Zona de descanso y lounge; Estación de carga de celulares; Ingreso a las duchas; Uso de casilleros; Equipo de entrenamiento y lavado; Uso de secadores de cabello; Kit de aseo personal; Acceso a máquinas de relajación muscular; Sauna; Reloj de mano cardiomedidor; Parking de auto', '2026-11-22', '2026-12-22', 307.50, 1),

-- Cliente 9 (Lucía): Personalizado de 3 subproductos (S/ 105; mes 1 con cupón PRIMAVERA25)
(21, 9, NULL, 6, 'Sala de máquinas y pesas; Zona de cardio; Uso de casilleros', '2026-10-12', '2026-11-11', 78.75, 1),
(22, 9, NULL, NULL, 'Sala de máquinas y pesas; Zona de cardio; Uso de casilleros', '2026-11-11', '2026-12-11', 105.00, 2),

-- Cliente 10 (Sebastián): Plan Básico vigente con referido (50% desc)
(23, 10, 1, NULL, 'Sala de máquinas y pesas; Wifi; Acceso al dispensador de agua purificada; Uso de casilleros', '2026-11-25', '2026-12-25', 45.00, 1),

-- Cliente 11 (Fernanda): Personalizado de 5 subproductos (S/ 170 - 15% = S/ 144.50, Por vencer)
(24, 11, NULL, NULL, 'Sala de máquinas y pesas; Zona de cardio; Ingreso a las duchas; Uso de casilleros; Sauna', '2026-10-31', '2026-11-30', 144.50, 1),

-- Cliente 12 (Rodrigo): Historial julio-septiembre (Vencida, alimenta métricas históricas)
(25, 12, 2, NULL, 'Sala de máquinas y pesas; Zona de cardio; Wifi; Acceso al dispensador de agua purificada; Zona de descanso y lounge; Ingreso a las duchas; Uso de casilleros; Equipo de entrenamiento y lavado', '2026-07-10', '2026-08-09', 195.00, 1),
(26, 12, 3, NULL, 'Sala de máquinas y pesas; Zona de cardio; Zona funcional; Wifi; Acceso al dispensador de agua purificada; Zona de descanso y lounge; Estación de carga de celulares; Ingreso a las duchas; Uso de casilleros; Equipo de entrenamiento y lavado; Uso de secadores de cabello; Kit de aseo personal; Acceso a máquinas de relajación muscular; Sauna; Reloj de mano cardiomedidor; Parking de auto', '2026-08-09', '2026-09-08', 410.00, 2),

-- Cliente 13 (Paola): Personalizado de 4 subproductos sin descuento (S/ 125, Vigente)
(27, 13, NULL, NULL, 'Sala de máquinas y pesas; Zona funcional; Evaluación en balanza de bioimpedancia; Rutina digital en app', '2026-11-20', '2026-12-20', 125.00, 1),

-- Cliente 14 (Gabriel): Plan Básico en julio (Vencida)
(28, 14, 1, NULL, 'Sala de máquinas y pesas; Wifi; Acceso al dispensador de agua purificada; Uso de casilleros', '2026-07-18', '2026-08-17', 90.00, 1);

INSERT INTO MARCACION_ACCESO (id_acceso, id_cliente, id_suscripcion, fecha_acceso, hora_acceso, resultado) VALUES
                                                                                                               (1, 3, 3, '2026-11-18', '07:30:00', 'PERMITIDO'),
                                                                                                               (2, 4, 4, '2026-11-18', '18:45:00', 'PERMITIDO'),
                                                                                                               (3, 3, 3, '2026-11-20', '08:10:00', 'PERMITIDO'),
                                                                                                               (4, 1, NULL, '2026-11-20', '19:05:00', 'DENEGADO'),
                                                                                                               (5, 5, 12, '2026-11-14', '06:30:00', 'PERMITIDO'),
                                                                                                               (6, 7, 19, '2026-11-14', '09:15:00', 'PERMITIDO'),
                                                                                                               (7, 9, 22, '2026-11-15', '17:20:00', 'PERMITIDO'),
                                                                                                               (8, 11, 24, '2026-11-16', '07:45:00', 'PERMITIDO'),
                                                                                                               (9, 2, NULL, '2026-11-16', '18:10:00', 'DENEGADO'),
                                                                                                               (10, 5, 12, '2026-11-17', '06:40:00', 'PERMITIDO'),
                                                                                                               (11, 4, 4, '2026-11-17', '19:00:00', 'PERMITIDO'),
                                                                                                               (12, 6, 16, '2026-11-19', '07:05:00', 'PERMITIDO'),
                                                                                                               (13, 12, NULL, '2026-11-19', '16:30:00', 'DENEGADO'),
                                                                                                               (14, 7, 19, '2026-11-20', '10:00:00', 'PERMITIDO'),
                                                                                                               (15, 13, 27, '2026-11-21', '08:25:00', 'PERMITIDO'),
                                                                                                               (16, 5, 12, '2026-11-21', '18:30:00', 'PERMITIDO'),
                                                                                                               (17, 8, 20, '2026-11-22', '09:40:00', 'PERMITIDO'),
                                                                                                               (18, 6, 16, '2026-11-23', '07:15:00', 'PERMITIDO'),
                                                                                                               (19, 9, 22, '2026-11-23', '17:50:00', 'PERMITIDO'),
                                                                                                               (20, 14, NULL, '2026-11-23', '19:20:00', 'DENEGADO'),
                                                                                                               (21, 3, 3, '2026-11-24', '07:35:00', 'PERMITIDO'),
                                                                                                               (22, 11, 24, '2026-11-24', '14:15:00', 'PERMITIDO'),
                                                                                                               (23, 8, 20, '2026-11-24', '19:45:00', 'PERMITIDO'),
                                                                                                               (24, 10, 23, '2026-11-25', '08:00:00', 'PERMITIDO'),
                                                                                                               (25, 13, 27, '2026-11-25', '18:15:00', 'PERMITIDO'),
                                                                                                               (26, 1, NULL, '2026-11-25', '20:00:00', 'DENEGADO'),
                                                                                                               (27, 5, 12, '2026-11-26', '06:50:00', 'PERMITIDO'),
                                                                                                               (28, 6, 16, '2026-11-26', '18:40:00', 'PERMITIDO'),
                                                                                                               (29, 3, 3, '2026-11-27', '07:20:00', 'PERMITIDO'),
                                                                                                               (30, 15, NULL, '2026-11-27', '11:10:00', 'DENEGADO');

ALTER TABLE PLAN ALTER COLUMN id_plan RESTART WITH 4;
ALTER TABLE CATEGORIA ALTER COLUMN id_categoria RESTART WITH 7;
ALTER TABLE SUBPRODUCTO ALTER COLUMN id_subproducto RESTART WITH 21;
ALTER TABLE PLAN_SUBPRODUCTO ALTER COLUMN id_plan_subproducto RESTART WITH 29;
ALTER TABLE CLIENTE ALTER COLUMN id_cliente RESTART WITH 16;
ALTER TABLE CUPON ALTER COLUMN id_cupon RESTART WITH 9;
ALTER TABLE SUSCRIPCION ALTER COLUMN id_suscripcion RESTART WITH 29;
ALTER TABLE MARCACION_ACCESO ALTER COLUMN id_acceso RESTART WITH 31;