
package com.example.SistemaGimnasioV2.Controller;

import com.example.SistemaGimnasioV2.Service.SeguimientoServiceMA;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Map;

@Controller
@RequestMapping("/seguimiento")
public class SeguimientoControllerMA {

    private final SeguimientoServiceMA service;

    public SeguimientoControllerMA(SeguimientoServiceMA service) {
        this.service = service;
    }

    @GetMapping("/clientes")
    public String clientes(@RequestParam(required = false) String buscar, Model model) {
        model.addAttribute("clientes", service.listarClientes(buscar));
        model.addAttribute("buscar", buscar);
        return "seguimientoMA/clientesMA";
    }

    @GetMapping("/cliente/editar/{id}")
    public String editarCliente(@PathVariable int id, Model model, RedirectAttributes ra) {
        Map<String, Object> cliente = service.buscarCliente(id);

        if (cliente == null) {
            ra.addFlashAttribute("error", "Cliente no encontrado.");
            return "redirect:/seguimiento/clientes";
        }

        model.addAttribute("cliente", cliente);
        return "seguimientoMA/editarClienteMA";
    }

    @PostMapping("/cliente/guardar")
    public String guardarCliente(
            @RequestParam int idCliente,
            @RequestParam String dni,
            @RequestParam String nombre,
            @RequestParam String apellido,
            @RequestParam(required = false) String telefono,
            @RequestParam(required = false) String email,
            RedirectAttributes ra) {

        String error = service.actualizarCliente(
                idCliente, dni, nombre, apellido, telefono, email
        );

        if (error != null) {
            ra.addFlashAttribute("error", error);
        } else {
            ra.addFlashAttribute("mensaje", "Cliente actualizado correctamente.");
        }

        return "redirect:/seguimiento/cliente/editar/" + idCliente;
    }

    @GetMapping("/suscripciones")
    public String suscripciones(
            @RequestParam(required = false) String buscar,
            @RequestParam(required = false) String estado,
            Model model) {

        model.addAttribute("suscripciones", service.listarSuscripciones(buscar, estado));
        model.addAttribute("buscar", buscar);
        model.addAttribute("estado", estado);

        return "seguimientoMA/suscripcionesMA";
    }

    @GetMapping("/historial/{idCliente}")
    public String historial(@PathVariable int idCliente, Model model, RedirectAttributes ra) {
        Map<String, Object> cliente = service.buscarCliente(idCliente);

        if (cliente == null) {
            ra.addFlashAttribute("error", "Cliente no encontrado.");
            return "redirect:/seguimiento/clientes";
        }

        model.addAttribute("cliente", cliente);
        model.addAttribute("historial", service.historialCliente(idCliente));

        return "seguimientoMA/historialClienteMA";
    }

    @GetMapping("/renovar/{id}")
    public String renovar(@PathVariable int id, Model model, RedirectAttributes ra) {

        Map<String, Object> suscripcion = service.buscarSuscripcion(id);

        if (suscripcion == null) {
            ra.addFlashAttribute("error", "Suscripción no encontrada.");
            return "redirect:/seguimiento/suscripciones";
        }

        String estado = String.valueOf(
                suscripcion.get("ESTADO_SUSCRIPCION")
        );

        if (!"Vencida".equals(estado) && !"Por vencer".equals(estado)) {
            ra.addFlashAttribute(
                    "error",
                    "Solo se pueden renovar suscripciones por vencer o vencidas."
            );
            return "redirect:/seguimiento/suscripciones";
        }

        Map<String, Object> resumen = service.obtenerResumenRenovacion(id);

        System.out.println("========== RESUMEN F18 ==========");
        System.out.println("SUSCRIPCION: " + suscripcion);
        System.out.println("RESUMEN: " + resumen);
        System.out.println("=================================");

        model.addAttribute("suscripcion", suscripcion);
        model.addAttribute("resumen", resumen);

        return "seguimientoMA/renovarSuscripcionMA";
    }

    @PostMapping("/renovar/confirmar")
    public String confirmarRenovacion(
            @RequestParam int idSuscripcion,
            RedirectAttributes ra) {

        String error = service.renovarSuscripcion(idSuscripcion);

        if (error != null) {
            ra.addFlashAttribute("error", error);
        } else {
            ra.addFlashAttribute(
                    "mensaje",
                    "La renovación se registró correctamente. Se creó una nueva suscripción."
            );
        }

        return "redirect:/seguimiento/suscripciones";
    }

    @GetMapping("/mejorar/{id}")
    public String mejorar(@PathVariable int id, Model model, RedirectAttributes ra) {

        Map<String, Object> suscripcion = service.buscarSuscripcion(id);

        if (suscripcion == null) {
            ra.addFlashAttribute("error", "Suscripción no encontrada.");
            return "redirect:/seguimiento/suscripciones";
        }

        double monto = ((Number) suscripcion.get("MONTO_TOTAL")).doubleValue();

        model.addAttribute("suscripcion", suscripcion);
        model.addAttribute("planes", service.listarPlanesMayores(monto));
        model.addAttribute("subproductos", service.listarSubproductos());
        model.addAttribute(
                "subproductosActuales",
                service.obtenerSubproductosActuales(suscripcion)
        );

        return "seguimientoMA/mejorarPlanMA";
    }

    @PostMapping("/mejorar/confirmar")
    public String confirmarMejora(
            @RequestParam int idSuscripcion,
            @RequestParam int idPlanNuevo,
            @RequestParam(required = false) String[] adicionales,
            RedirectAttributes ra) {

        String error = service.mejorarPlan(
                idSuscripcion, idPlanNuevo, adicionales
        );

        if (error != null) {
            ra.addFlashAttribute("error", error);
        } else {
            ra.addFlashAttribute("mensaje", "El plan se mejoró correctamente.");
        }

        return "redirect:/seguimiento/suscripciones";
    }
}
