
package com.example.SistemaGimnasioV2.Service;

import com.example.SistemaGimnasioV2.Repository.SeguimientoRepositoryMA;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service
public class SeguimientoServiceMA {

    private final SeguimientoRepositoryMA repository;

    public SeguimientoServiceMA(SeguimientoRepositoryMA repository) {
        this.repository = repository;
    }

    public List<Map<String, Object>> listarClientes(String buscar) {
        return repository.listarClientes(buscar);
    }

    public Map<String, Object> buscarCliente(int id) {
        return repository.buscarCliente(id);
    }

    public String actualizarCliente(int id, String nombre, String apellido,
                                    String telefono, String email) {

        if (nombre == null || nombre.trim().isEmpty()
                || apellido == null || apellido.trim().isEmpty()) {
            return "El nombre y apellido son obligatorios.";
        }

        if (telefono == null || !telefono.matches("[0-9]{9}")) {
            return "El teléfono debe contener exactamente 9 dígitos.";
        }

        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            return "Ingrese un correo electrónico válido.";
        }

        if (repository.buscarCliente(id) == null) {
            return "No se encontró el cliente.";
        }

        if (repository.existeEmail(email.trim(), id)) {
            return "Este correo ya está registrado por otro cliente.";
        }

        repository.actualizarCliente(
                id,
                nombre.trim(),
                apellido.trim(),
                telefono.trim(),
                email.trim()
        );

        return null;
    }

    public List<Map<String, Object>> listarSuscripciones() {
        return repository.listarSuscripciones();
    }

    public List<Map<String, Object>> listarSuscripciones(
            String buscar, String estado) {
        return repository.listarSuscripciones(buscar, estado);
    }

    public Map<String, Object> buscarSuscripcion(int id) {
        return repository.buscarSuscripcion(id);
    }

    public List<Map<String, Object>> historialCliente(int idCliente) {
        return repository.historialCliente(idCliente);
    }

    public List<Map<String, Object>> listarPlanesMayores(double precioActual) {
        return repository.listarPlanesMayores(precioActual);
    }

    public List<Map<String, Object>> listarSubproductos() {
        return repository.listarSubproductos();
    }

    public List<Map<String, Object>> obtenerSubproductosActuales(
            Map<String, Object> suscripcion) {

        List<Map<String, Object>> resultado = new ArrayList<>();

        if (suscripcion == null) {
            return resultado;
        }

        Object idPlan = suscripcion.get("ID_PLAN");

        // Si tiene un plan establecido, obtiene los servicios de PLAN_SUBPRODUCTO.
        if (idPlan != null) {
            int idSuscripcion = ((Number) suscripcion.get("ID_SUSCRIPCION")).intValue();

            return repository.listarSubproductosActuales(idSuscripcion);
        }

        // Si es personalizado, obtiene los servicios del campo DETALLE.
        Object detalleObjeto = suscripcion.get("DETALLE");

        if (detalleObjeto == null) {
            return resultado;
        }

        String detalle = detalleObjeto.toString().trim();

        if (detalle.isEmpty()) {
            return resultado;
        }

        String[] nombres = detalle.split(";");

        Set<Integer> agregados = new HashSet<>();

        for (String nombre : nombres) {
            String nombreLimpio = nombre.trim();

            if (nombreLimpio.isEmpty()) {
                continue;
            }

            Map<String, Object> subproducto =
                    repository.buscarSubproductoPorNombre(nombreLimpio);

            if (subproducto != null) {
                int id = ((Number) subproducto.get("ID_SUBPRODUCTO")).intValue();

                if (agregados.add(id)) {
                    resultado.add(subproducto);
                }
            }
        }

        return resultado;
    }

    public String renovarSuscripcion(int idSuscripcion) {
        Map<String, Object> anterior = repository.buscarSuscripcion(idSuscripcion);

        if (anterior == null) {
            return "No se encontró la suscripción.";
        }

        String estado = anterior.get("ESTADO_SUSCRIPCION").toString();

        if ("Vigente".equals(estado)) {
            return "Solo se pueden renovar suscripciones por vencer o vencidas.";
        }

        int idCliente = ((Number) anterior.get("ID_CLIENTE")).intValue();

        Integer idPlan = anterior.get("ID_PLAN") == null
                ? null
                : ((Number) anterior.get("ID_PLAN")).intValue();

        String detalle = anterior.get("DETALLE") == null
                ? ""
                : anterior.get("DETALLE").toString();

        double monto = ((Number) anterior.get("MONTO_TOTAL")).doubleValue();

        LocalDate hoy = LocalDate.now();

        LocalDate fechaAnteriorFin =
                ((Date) anterior.get("FECHA_FIN")).toLocalDate();

        LocalDate fechaInicio = fechaAnteriorFin.isBefore(hoy)
                ? hoy
                : fechaAnteriorFin;

        LocalDate fechaFin = fechaInicio.plusDays(30);

        repository.insertarRenovacion(
                idCliente,
                idPlan,
                detalle,
                Date.valueOf(fechaInicio),
                Date.valueOf(fechaFin),
                monto
        );

        return null;
    }

    public String mejorarPlan(int idSuscripcion, int idPlanNuevo,
                              List<Integer> adicionales) {

        Map<String, Object> suscripcion =
                repository.buscarSuscripcion(idSuscripcion);

        if (suscripcion == null) {
            return "No se encontró la suscripción.";
        }

        if (!"Vigente".equals(suscripcion.get("ESTADO_SUSCRIPCION"))) {
            return "Solo se pueden mejorar suscripciones vigentes.";
        }

        // Se toma el monto total que actualmente paga el cliente.
        double precioActual =
                ((Number) suscripcion.get("MONTO_TOTAL")).doubleValue();

        List<Map<String, Object>> planes =
                repository.listarPlanesMayores(precioActual);

        Map<String, Object> planNuevo = null;

        for (Map<String, Object> p : planes) {
            if (((Number) p.get("ID_PLAN")).intValue() == idPlanNuevo) {
                planNuevo = p;
                break;
            }
        }

        if (planNuevo == null) {
            return "El plan seleccionado no es superior al costo actual.";
        }

        double nuevoTotal =
                ((Number) planNuevo.get("PRECIO_BASE")).doubleValue();

        // Servicios que ya vienen incluidos en el nuevo plan.
        Set<Integer> incluidos =
                new HashSet<>(repository.listarSubproductosPlan(idPlanNuevo));

        // Servicios adicionales seleccionados.
        Set<Integer> seleccionados = new HashSet<>();

        if (adicionales != null) {
            seleccionados.addAll(adicionales);
        }

        List<String> nombresDetalle = new ArrayList<>();

        // Registrar los servicios incluidos en el nuevo plan.
        for (Integer id : incluidos) {
            Map<String, Object> sub = repository.buscarSubproducto(id);

            if (sub != null) {
                nombresDetalle.add(
                        sub.get("NOMBRE_SUBPRODUCTO").toString()
                );
            }
        }

        // Sumar únicamente los servicios adicionales que no están incluidos.
        for (Integer id : seleccionados) {

            if (incluidos.contains(id)) {
                continue;
            }

            Map<String, Object> sub = repository.buscarSubproducto(id);

            if (sub == null) {
                return "Uno de los servicios adicionales no está disponible.";
            }

            nuevoTotal +=
                    ((Number) sub.get("PRECIO_INDIVIDUAL")).doubleValue();

            nombresDetalle.add(
                    sub.get("NOMBRE_SUBPRODUCTO").toString()
            );
        }

        String detalle = String.join(";", nombresDetalle);

        repository.actualizarMejora(
                idSuscripcion,
                idPlanNuevo,
                detalle,
                nuevoTotal
        );

        return null;
    }
}
