
package com.example.SistemaGimnasioV2.Service;

import com.example.SistemaGimnasioV2.Repository.SeguimientoRepositoryMA;
import org.springframework.stereotype.Service;

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

    public List<Map<String, Object>> listarSuscripciones(String buscar, String estado) {
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

        if (nombre == null || nombre.isBlank() || apellido == null || apellido.isBlank()) {
            return "El nombre y apellido son obligatorios.";
        }

        if (telefono != null && !telefono.isBlank() && !telefono.trim().matches("\\d{9}")) {
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

    public String renovarSuscripcion(int id) {
        Map<String, Object> suscripcion = repo.buscarSuscripcion(id);

        if (suscripcion == null) {
            return "No se encontró la suscripción.";
        }

        String estado = String.valueOf(suscripcion.get("ESTADO_SUSCRIPCION"));

        if (!"Vencida".equals(estado) && !"Por vencer".equals(estado)) {
            return "Solo se pueden renovar las suscripciones por vencer o vencidas.";
        }

        LocalDate inicio = LocalDate.now();
        int duracion = ((Number) suscripcion.get("DURACION_DIAS")).intValue();
        LocalDate fin = inicio.plusDays(duracion);

        int resultado = repo.actualizarRenovacion(
                id,
                Date.valueOf(inicio),
                Date.valueOf(fin)
        );

        return resultado > 0 ? null : "No se pudo renovar la suscripción.";
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

            Map<String, Object> encontrado = repo.buscarSubproductoPorNombre(limpio);

            if (encontrado != null) {
                boolean existe = resultado.stream().anyMatch(x ->
                        Objects.equals(x.get("ID_SUBPRODUCTO"), encontrado.get("ID_SUBPRODUCTO"))
                );

                if (!existe) {
                    resultado.add(encontrado);
                }
            }
        }

        return resultado;
    }

    public String mejorarPlan(int idSuscripcion, int idPlanNuevo, String[] adicionales) {
        Map<String, Object> suscripcion = repo.buscarSuscripcion(idSuscripcion);

        if (suscripcion == null) {
            return "No se encontró la suscripción.";
        }

        if (!"Vigente".equals(suscripcion.get("ESTADO_SUSCRIPCION"))) {
            return "Solo se puede mejorar una suscripción vigente.";
        }

        double montoActual = ((Number) suscripcion.get("MONTO_TOTAL")).doubleValue();

        List<Map<String, Object>> planes = repo.listarPlanesMayores(montoActual);

        Map<String, Object> nuevoPlan = planes.stream()
                .filter(p -> ((Number) p.get("ID_PLAN")).intValue() == idPlanNuevo)
                .findFirst()
                .orElse(null);

        if (nuevoPlan == null) {
            return "Debes seleccionar un plan con un precio mayor al actual.";
        }

        List<Map<String, Object>> incluidos = repo.listarSubproductosPlan(idPlanNuevo);

        Set<Integer> idsIncluidos = new HashSet<>();
        List<String> nombres = new ArrayList<>();

        for (Map<String, Object> item : incluidos) {
            int id = ((Number) item.get("ID_SUBPRODUCTO")).intValue();
            idsIncluidos.add(id);
            nombres.add(String.valueOf(item.get("NOMBRE_SUBPRODUCTO")));
        }

        double total = ((Number) nuevoPlan.get("PRECIO_BASE")).doubleValue();

        List<Map<String, Object>> catalogo = repo.listarSubproductos();

        if (adicionales != null) {
            for (String valor : adicionales) {
                try {
                    int id = Integer.parseInt(valor);

                    if (idsIncluidos.contains(id)) {
                        continue;
                    }

                    Map<String, Object> subproducto = catalogo.stream()
                            .filter(x -> ((Number) x.get("ID_SUBPRODUCTO")).intValue() == id)
                            .findFirst()
                            .orElse(null);

                    if (subproducto != null) {
                        idsIncluidos.add(id);
                        nombres.add(String.valueOf(subproducto.get("NOMBRE_SUBPRODUCTO")));
                        total += ((Number) subproducto.get("PRECIO_INDIVIDUAL")).doubleValue();
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
