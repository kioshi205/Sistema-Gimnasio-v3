package com.example.SistemaGimnasioV2.Controller;

import com.example.SistemaGimnasioV2.Service.SuscripcionServiceJB;
import com.example.SistemaGimnasioV2.modelJB.ClienteJB;
import com.example.SistemaGimnasioV2.modelJB.SubproductoJB;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class SuscripcionControllerJB {

    private final SuscripcionServiceJB servicio;

    public SuscripcionControllerJB(SuscripcionServiceJB servicio) {
        this.servicio = servicio;
    }

    @GetMapping("/planes")
    public String catalogo(Model model) {
        model.addAttribute("planes", servicio.listarPlanes());
        return "PlanesJB/catalogoJB";
    }

    @GetMapping("/planes/personalizado")
    public String disenador(Model model) {
        model.addAttribute("subproductos", servicio.listarSubproductos());
        return "PlanesJB/disenadorJB";
    }

    @GetMapping("/planes/personalizado/vista-previa")
    public String vistaPrevia(@RequestParam(required = false) List<Integer> ids, Model model) {
        if (ids == null || ids.isEmpty()) {
            model.addAttribute("error", "Selecciona al menos un subproducto.");
            model.addAttribute("subproductos", servicio.listarSubproductos());
            return "PlanesJB/disenadorJB";
        }
        List<SubproductoJB> subproductos = servicio.buscarSubproductos(ids);
        model.addAttribute("subproductos", subproductos);
        model.addAttribute("total", servicio.total(subproductos));
        model.addAttribute("ids", ids);
        return "PlanesJB/vista-previaJB";
    }

    @GetMapping("/clientes/registro")
    public String formularioCliente(@RequestParam(required = false) Integer idPlan,
                                    @RequestParam(required = false) List<Integer> ids,
                                    Model model) {
        if (!servicio.seleccionValida(idPlan, ids)) {
            return "redirect:/planes";
        }
        model.addAttribute("cliente", new ClienteJB());
        model.addAttribute("idPlan", idPlan);
        model.addAttribute("ids", ids);
        return "ClientesJB/registroJB";
    }

    @PostMapping("/clientes/registro")
    public String registrarCliente(@ModelAttribute("cliente") ClienteJB cliente,
                                   @RequestParam(required = false) Integer idPlan,
                                   @RequestParam(required = false) List<Integer> ids,
                                   Model model) {
        if (!servicio.seleccionValida(idPlan, ids)) {
            return "redirect:/planes";
        }
        List<String> errores = servicio.validarCliente(cliente);
        if (!errores.isEmpty()) {
            model.addAttribute("errores", errores);
            model.addAttribute("idPlan", idPlan);
            model.addAttribute("ids", ids);
            return "ClientesJB/registroJB";
        }
        int idCliente = servicio.guardarCliente(cliente);
        return "redirect:/suscripciones/resumen?idCliente=" + idCliente + seleccionEnUrl(idPlan, ids);
    }

    @GetMapping("/suscripciones/resumen")
    public String resumen(@RequestParam int idCliente,
                          @RequestParam(required = false) Integer idPlan,
                          @RequestParam(required = false) List<Integer> ids,
                          Model model) {
        if (!servicio.seleccionValida(idPlan, ids)) {
            return "redirect:/planes";
        }
        model.addAttribute("resumen", servicio.armarResumen(idPlan, ids, idCliente));
        model.addAttribute("idCliente", idCliente);
        model.addAttribute("idPlan", idPlan);
        model.addAttribute("ids", ids);
        return "SuscripcionesJB/confirmacionJB";
    }

    @PostMapping("/suscripciones/confirmar")
    public String confirmar(@RequestParam int idCliente,
                            @RequestParam(required = false) Integer idPlan,
                            @RequestParam(required = false) List<Integer> ids) {
        if (!servicio.seleccionValida(idPlan, ids) || servicio.tieneSuscripcionVigente(idCliente)) {
            return "redirect:/planes";
        }
        int idSuscripcion = servicio.confirmar(idPlan, ids, idCliente);
        return "redirect:/suscripciones/exito?id=" + idSuscripcion;
    }

    @GetMapping("/suscripciones/exito")
    public String exito(@RequestParam int id, Model model) {
        model.addAttribute("idSuscripcion", id);
        return "SuscripcionesJB/confirmacionJB";
    }

    private String seleccionEnUrl(Integer idPlan, List<Integer> ids) {
        if (idPlan != null) {
            return "&idPlan=" + idPlan;
        }
        StringBuilder url = new StringBuilder();
        for (Integer id : ids) {
            url.append("&ids=").append(id);
        }
        return url.toString();
    }
}
