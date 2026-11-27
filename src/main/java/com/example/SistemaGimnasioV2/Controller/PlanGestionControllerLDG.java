package com.example.SistemaGimnasioV2.Controller;

import com.example.SistemaGimnasioV2.Service.PlanGestionServiceLDG;
import com.example.SistemaGimnasioV2.modelJB.PlanJB;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class PlanGestionControllerLDG {

    private final PlanGestionServiceLDG servicio;

    public PlanGestionControllerLDG(PlanGestionServiceLDG servicio) {
        this.servicio = servicio;
    }

    @GetMapping("/gestion-planes")
    public String listar(Model model) {
        model.addAttribute("planes", servicio.listarPlanes());
        return "PlanesJB/gestionLDG";
    }

    @GetMapping("/gestion-planes/editar/{idPlan}")
    public String editar(@PathVariable int idPlan, Model model, RedirectAttributes redirect) {
        PlanJB plan = servicio.buscarPlan(idPlan);

        if (plan == null) {
            redirect.addFlashAttribute("error",
                    "El plan indicado no existe o no es un plan predeterminado.");
            return "redirect:/gestion-planes";
        }

        model.addAttribute("plan", plan);
        model.addAttribute("subproductos", servicio.listarSubproductos());
        model.addAttribute("idsSeleccionados", servicio.listarIdsSubproductos(idPlan));
        model.addAttribute("precioCalculado", servicio.calcularPrecioPlan(idPlan));
        return "PlanesJB/editarPlanLDG";
    }

    @PostMapping("/gestion-planes/actualizar/{idPlan}")
    public String actualizar(@PathVariable int idPlan,
                             @RequestParam(value = "ids", required = false) List<Integer> ids,
                             RedirectAttributes redirect) {
        String error = servicio.actualizarPlan(idPlan, ids);

        if (error != null) {
            redirect.addFlashAttribute("error", error);
            return "redirect:/gestion-planes/editar/" + idPlan;
        }

        redirect.addFlashAttribute("mensajeExito", "El plan se actualizó correctamente.");
        return "redirect:/gestion-planes";
    }
}
