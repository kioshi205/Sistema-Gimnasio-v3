
package com.example.SistemaGimnasioV2.Service;

import com.example.SistemaGimnasioV2.Repository.SeguimientoRepositoryMA;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Date;
import java.time.LocalDate;
import java.util.*;

@Service
public class SeguimientoServiceMA {

    private final SeguimientoRepositoryMA repo;

    public SeguimientoServiceMA(SeguimientoRepositoryMA repo) {
        this.repo = repo;
    }

    public List<Map<String, Object>> listarClientes(String buscar) {
        return repo.listarClientes(buscar);
    }

    public Map<String, Object> buscarCliente(int id) {
        return repo.buscarCliente(id);
    }

    public List<Map<String, Object>> listarSuscripciones(
            String buscar, String estado) {
        return repo.listarSuscripciones(buscar, estado);
    }

    public Map<String, Object> buscarSuscripcion(int id) {
        return repo.buscarSuscripcion(id);
    }

    public List<Map<String, Object>> historialCliente(int id) {
        return repo.historialCliente(id);
    }

    public List<Map<String, Object>> listarSubproductos() {
        return repo.listarSubproductos();
    }

    public List<Map<String, Object>> listarPlanesMayores(double monto) {
        return repo.listarPlanesMayores(monto);
    }

    public String actualizarCliente(
            int id,
            String dni,
            String nombre,
            String apellido,
            String telefono,
            String email) {

        if (dni == null || !dni.trim().matches("\\d{8}")) {
            return "El DNI debe contener 8 dígitos.";
        }

        if (nombre == null || nombre.isBlank()
                || apellido == null || apellido.isBlank()) {
            return "El nombre y apellido son obligatorios.";
        }

        if (telefono != null && !telefono.isBlank()
                && !telefono.trim().matches("\\d{9}")) {
            return "El teléfono debe contener 9 dígitos.";
        }

        if (email != null && !email.isBlank()
                && !email.trim().matches("^[\\w.+-]+@[\\w.-]+\\.[A-Za-z]{2,}$")) {
            return "El correo electrónico no es válido.";
        }

        if (repo.buscarCliente(id) == null) {
            return "El cliente no existe.";
        }

        if (repo.existeDni(dni.trim(), id)) {
            return "El DNI ya se encuentra registrado.";
        }

        if (repo.existeEmail(email, id)) {
            return "El correo electrónico ya se encuentra registrado.";
        }

        repo.actualizarCliente(
                id,
                dni.trim(),
                nombre.trim(),
                apellido.trim(),
                telefono == null || telefono.isBlank() ? null : telefono.trim(),
                email == null || email.isBlank() ? null : email.trim()
        );

        return null;
    }

    // RESUMEN DE RENOVACIÓN F18
    public Map<String, Object> obtenerResumenRenovacion(int id) {

        Map<String, Object> suscripcion = repo.buscarSuscripcion(id);

        if (suscripcion == null) {
            return null;
        }

        LocalDate hoy = LocalDate.now();
        LocalDate vencimiento = convertirFecha(suscripcion.get("FECHA_FIN"));

        int mesesActuales = obtenerMeses(suscripcion);

        boolean dentroDelPlazo = !hoy.isAfter(vencimiento.plusDays(2));

        int mesesProximos = dentroDelPlazo
                ? mesesActuales + 1
                : 1;

        double montoBase = obtenerMontoBase(suscripcion);

        // Descuento del 20% desde 3 meses consecutivos.
        double porcentajeDescuento =
                mesesActuales >= 3 ? 20.0 : 0.0;

        double montoDescuento =
                montoBase * porcentajeDescuento / 100.0;

        double montoFinal = montoBase - montoDescuento;

        Map<String, Object> resumen = new LinkedHashMap<>();

        resumen.put("MESES_ACTUALES", mesesActuales);
        resumen.put("MESES_PROXIMOS", mesesProximos);
        resumen.put("PORCENTAJE_DESCUENTO", porcentajeDescuento);
        resumen.put("MONTO_BASE", montoBase);
        resumen.put("MONTO_DESCUENTO", montoDescuento);
        resumen.put("MONTO_FINAL", montoFinal);

        return resumen;
    }

    // REGISTRAR RENOVACIÓN ACTUALIZANDO LA MISMA FILA
    @Transactional
    public String renovarSuscripcion(int id) {

        Map<String, Object> suscripcion = repo.buscarSuscripcion(id);

        if (suscripcion == null) {
            return "No se encontró la suscripción.";
        }

        String estado = String.valueOf(
                suscripcion.get("ESTADO_SUSCRIPCION")
        );

        if (!"Vencida".equals(estado)
                && !"Por vencer".equals(estado)) {
            return "Solo se pueden renovar las suscripciones por vencer o vencidas.";
        }

        LocalDate hoy = LocalDate.now();

        LocalDate vencimiento =
                convertirFecha(suscripcion.get("FECHA_FIN"));

        int mesesActuales = obtenerMeses(suscripcion);

        boolean dentroDelPlazo =
                !hoy.isAfter(vencimiento.plusDays(2));

        int mesesNuevos = dentroDelPlazo
                ? mesesActuales + 1
                : 1;

        // Si renueva antes del vencimiento, conserva los días restantes.
        LocalDate inicio = hoy.isBefore(vencimiento)
                ? vencimiento
                : hoy;

        if (!dentroDelPlazo) {
            inicio = hoy;
        }

        int duracion =
                ((Number) suscripcion.get("DURACION_DIAS")).intValue();

        LocalDate fin = inicio.plusDays(duracion);

        double montoBase = obtenerMontoBase(suscripcion);

        // Descuento del 20% desde 3 meses consecutivos.
        double montoFinal = mesesActuales >= 3
                ? montoBase * 0.80
                : montoBase;

        String detalle = suscripcion.get("DETALLE") == null
                ? ""
                : String.valueOf(suscripcion.get("DETALLE"));

        // Actualiza el registro existente, conservando su ID.
        int resultado = repo.actualizarRenovacion(
                id,
                detalle,
                Date.valueOf(inicio),
                Date.valueOf(fin),
                montoFinal,
                mesesNuevos
        );

        return resultado > 0
                ? null
                : "No se pudo actualizar la renovación.";
    }

    private LocalDate convertirFecha(Object valor) {

        if (valor instanceof Date fecha) {
            return fecha.toLocalDate();
        }

        if (valor instanceof java.sql.Timestamp fecha) {
            return fecha.toLocalDateTime().toLocalDate();
        }

        if (valor instanceof LocalDate fecha) {
            return fecha;
        }

        return LocalDate.parse(String.valueOf(valor));
    }

    // Lee MESES_CONSECUTIVOS directamente de la base de datos.
    private int obtenerMeses(Map<String, Object> suscripcion) {

        Object valor = suscripcion.get("MESES_CONSECUTIVOS");

        if (valor == null) {
            return 1;
        }

        return ((Number) valor).intValue();
    }

    private double obtenerMontoBase(Map<String, Object> suscripcion) {

        Object precioPlan = suscripcion.get("PRECIO_BASE");

        if (precioPlan != null) {
            return ((Number) precioPlan).doubleValue();
        }

        // Para un plan personalizado usa el monto actual.
        Object montoTotal = suscripcion.get("MONTO_TOTAL");

        return montoTotal == null
                ? 0.0
                : ((Number) montoTotal).doubleValue();
    }

    public List<Map<String, Object>> obtenerSubproductosActuales(
            Map<String, Object> suscripcion) {

        Integer idPlan = suscripcion.get("ID_PLAN") == null
                ? null
                : ((Number) suscripcion.get("ID_PLAN")).intValue();

        if (idPlan != null) {
            return repo.listarSubproductosPlan(idPlan);
        }

        List<Map<String, Object>> resultado = new ArrayList<>();

        Object valorDetalle = suscripcion.get("DETALLE");

        if (valorDetalle == null) {
            return resultado;
        }

        String detalle = String.valueOf(valorDetalle);

        for (String nombre : detalle.split(";")) {

            String limpio = nombre.trim();

            if (limpio.equalsIgnoreCase("Wifi gratis")) {
                limpio = "Wifi";
            }

            Map<String, Object> encontrado =
                    repo.buscarSubproductoPorNombre(limpio);

            if (encontrado != null) {

                boolean existe = resultado.stream().anyMatch(x ->
                        Objects.equals(
                                x.get("ID_SUBPRODUCTO"),
                                encontrado.get("ID_SUBPRODUCTO")
                        )
                );

                if (!existe) {
                    resultado.add(encontrado);
                }
            }
        }

        return resultado;
    }

    // MEJORAR PLAN
    public String mejorarPlan(
            int idSuscripcion,
            int idPlanNuevo,
            String[] adicionales) {

        Map<String, Object> suscripcion =
                repo.buscarSuscripcion(idSuscripcion);

        if (suscripcion == null) {
            return "No se encontró la suscripción.";
        }

        if (!"Vigente".equals(suscripcion.get("ESTADO_SUSCRIPCION"))) {
            return "Solo se puede mejorar una suscripción vigente.";
        }

        double montoActual =
                ((Number) suscripcion.get("MONTO_TOTAL")).doubleValue();

        List<Map<String, Object>> planes =
                repo.listarPlanesMayores(montoActual);

        Map<String, Object> nuevoPlan = planes.stream()
                .filter(p ->
                        ((Number) p.get("ID_PLAN")).intValue() == idPlanNuevo
                )
                .findFirst()
                .orElse(null);

        if (nuevoPlan == null) {
            return "Debes seleccionar un plan con un precio mayor al actual.";
        }

        List<Map<String, Object>> incluidos =
                repo.listarSubproductosPlan(idPlanNuevo);

        Set<Integer> idsIncluidos = new HashSet<>();

        List<String> nombres = new ArrayList<>();

        for (Map<String, Object> item : incluidos) {

            int id = ((Number) item.get("ID_SUBPRODUCTO")).intValue();

            idsIncluidos.add(id);

            nombres.add(
                    String.valueOf(item.get("NOMBRE_SUBPRODUCTO"))
            );
        }

        double total =
                ((Number) nuevoPlan.get("PRECIO_BASE")).doubleValue();

        List<Map<String, Object>> catalogo =
                repo.listarSubproductos();

        if (adicionales != null) {

            for (String valor : adicionales) {

                try {

                    int id = Integer.parseInt(valor);

                    if (idsIncluidos.contains(id)) {
                        continue;
                    }

                    Map<String, Object> subproducto = catalogo.stream()
                            .filter(x ->
                                    ((Number) x.get("ID_SUBPRODUCTO")).intValue() == id
                            )
                            .findFirst()
                            .orElse(null);

                    if (subproducto != null) {

                        idsIncluidos.add(id);

                        nombres.add(
                                String.valueOf(
                                        subproducto.get("NOMBRE_SUBPRODUCTO")
                                )
                        );

                        total += ((Number)
                                subproducto.get("PRECIO_INDIVIDUAL"))
                                .doubleValue();
                    }

                } catch (NumberFormatException ignored) {
                }
            }
        }

        repo.actualizarMejora(
                idSuscripcion,
                idPlanNuevo,
                String.join("; ", nombres),
                total
        );

        return null;
    }
}
