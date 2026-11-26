
package com.example.SistemaGimnasioV2.Controller;

import com.example.SistemaGimnasioV2.Service.SeguimientoServiceMA;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/seguimiento")
public class SeguimientoControllerMA {

    private final SeguimientoServiceMA service;

    public SeguimientoControllerMA(SeguimientoServiceMA service) {
        this.service = service;
    }

    // F14: listar y buscar clientes
    @GetMapping("/clientes")
    public String listarClientes(
            @RequestParam(required = false) String buscar,
            Model model) {

        model.addAttribute("clientes", service.listarClientes(buscar));
        model.addAttribute("buscar", buscar);

        return "seguimiento/listarClientesMA";
    }

    // F15: mostrar formulario de edición
    @GetMapping("/cliente/editar/{id}")
    public String editarCliente(@PathVariable int id, Model model) {

        Map<String, Object> cliente = service.buscarCliente(id);

        if (cliente == null) {
            return "redirect:/seguimiento/clientes?error=noencontrado";
        }

        model.addAttribute("cliente", cliente);

        return "seguimiento/editarClienteMA";
    }

    // F15: guardar cambios
    @PostMapping("/cliente/guardar")
    public String guardarCliente(
            @RequestParam int idCliente,
            @RequestParam String nombre,
            @RequestParam String apellido,
            @RequestParam String telefono,
            @RequestParam String email,
            Model model) {

        String error = service.actualizarCliente(
                idCliente, nombre, apellido, telefono, email
        );

        if (error != null) {
            model.addAttribute("error", error);
            model.addAttribute("cliente", service.buscarCliente(idCliente));
            return "seguimiento/editarClienteMA";
        }

        return "redirect:/seguimiento/clientes?actualizado";
    }

    // F16: listar y filtrar suscripciones
    @GetMapping("/suscripciones")
    public String listarSuscripciones(
            @RequestParam(required = false) String buscar,
            @RequestParam(required = false) String estado,
            Model model) {

        model.addAttribute(
                "suscripciones",
                service.listarSuscripciones(buscar, estado)
        );

        model.addAttribute("buscar", buscar);
        model.addAttribute("estadoSeleccionado", estado);

        return "seguimiento/listarSuscripcionesMA";
    }

    // F17: historial del cliente
    @GetMapping("/historial/{idCliente}")
    public String historial(
            @PathVariable int idCliente,
            Model model) {

        Map<String, Object> cliente = service.buscarCliente(idCliente);

        if (cliente == null) {
            return "redirect:/seguimiento/clientes?error=noencontrado";
        }

        model.addAttribute("cliente", cliente);
        model.addAttribute("historial",
                service.historialCliente(idCliente));

        return "seguimiento/historialSuscripcionesMA";
    }

    // F18: mostrar renovación
    @GetMapping("/renovar/{id}")
    public String mostrarRenovacion(
            @PathVariable int id,
            Model model) {

        Map<String, Object> suscripcion = service.buscarSuscripcion(id);

        if (suscripcion == null
                || "Vigente".equals(suscripcion.get("ESTADO_SUSCRIPCION"))) {
            return "redirect:/seguimiento/suscripciones?error=renovacion";
        }

        model.addAttribute("suscripcion", suscripcion);

        return "seguimiento/renovarSuscripcionMA";
    }

    // F18: confirmar renovación
    @PostMapping("/renovar/confirmar")
    public String confirmarRenovacion(@RequestParam int idSuscripcion) {

        String error = service.renovarSuscripcion(idSuscripcion);

        if (error != null) {
            return "redirect:/seguimiento/suscripciones?error=renovacion";
        }

        return "redirect:/seguimiento/suscripciones?renovada";
    }

    // F19: mostrar formulario de mejora
    @GetMapping("/mejorar/{id}")
    public String mostrarMejora(
            @PathVariable int id,
            Model model) {

        Map<String, Object> suscripcion = service.buscarSuscripcion(id);

        if (suscripcion == null
                || !"Vigente".equals(suscripcion.get("ESTADO_SUSCRIPCION"))) {
            return "redirect:/seguimiento/suscripciones?error=mejora";
        }

        double precioActual =
                ((Number) suscripcion.get("PRECIO_PLAN")).doubleValue();

        model.addAttribute("suscripcion", suscripcion);
        model.addAttribute("planes",
                service.listarPlanesMayores(precioActual));
        model.addAttribute("subproductos",
                service.listarSubproductos());

        return "seguimiento/mejorarPlanMA";
    }

    // F19: confirmar mejora
    @PostMapping("/mejorar/confirmar")
    public String confirmarMejora(
            @RequestParam int idSuscripcion,
            @RequestParam int idPlanNuevo,
            @RequestParam(required = false) List<Integer> adicionales,
            Model model) {

        String error = service.mejorarPlan(
                idSuscripcion, idPlanNuevo, adicionales
        );

        if (error != null) {
            Map<String, Object> suscripcion =
                    service.buscarSuscripcion(idSuscripcion);

            model.addAttribute("suscripcion", suscripcion);
            model.addAttribute("planes",
                    service.listarPlanesMayores(
                            ((Number) suscripcion.get("PRECIO_PLAN")).doubleValue()
                    ));
            model.addAttribute("subproductos",
                    service.listarSubproductos());
            model.addAttribute("error", error);

            return "seguimiento/mejorarPlanMA";
        }

        return "redirect:/seguimiento/suscripciones?mejorada";
    }
}
