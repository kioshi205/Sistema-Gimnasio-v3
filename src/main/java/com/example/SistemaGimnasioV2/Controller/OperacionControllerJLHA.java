package com.example.SistemaGimnasioV2.Controller;

import com.example.SistemaGimnasioV2.Service.OperacionServiceJLHA;
import com.example.SistemaGimnasioV2.modelJLHA.PanelMetricasJLHA;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class OperacionControllerJLHA {


    private static final String RUTA_RENOVAR_INT18 = "/suscripciones";
    private static final String RUTA_PLANES_INT01 = "/planes";

    private final OperacionServiceJLHA servicio;

    public OperacionControllerJLHA(OperacionServiceJLHA servicio) {
        this.servicio = servicio;
    }


    @GetMapping("/acceso")
    public String pantallaAcceso(Model model) {
        model.addAttribute("ultimas", servicio.ultimasMarcaciones());
        model.addAttribute("rutaRenovar", RUTA_RENOVAR_INT18);
        model.addAttribute("rutaPlanes", RUTA_PLANES_INT01);
        return "AccesoJLHA/controlJLHA";
    }


    @PostMapping("/acceso/verificar")
    public String verificarAcceso(@RequestParam String dni, RedirectAttributes flash) {
        flash.addFlashAttribute("resultado", servicio.verificar(dni));
        return "redirect:/acceso";
    }



    @GetMapping("/cupones/nuevo")
    public String formularioCupon(Model model) {
        model.addAttribute("cupones", servicio.listarCupones());
        model.addAttribute("porcentajeCupon", OperacionServiceJLHA.PORCENTAJE_CUPON_RN01);
        return "CuponesJLHA/crearJLHA";
    }

    @PostMapping("/cupones/nuevo")
    public String guardarCupon(@RequestParam(defaultValue = "") String codigo,
                               @RequestParam(defaultValue = "") String descripcion,
                               @RequestParam(defaultValue = "") String fechaInicio,
                               @RequestParam(defaultValue = "") String fechaFin,
                               Model model,
                               RedirectAttributes flash) {
        List<String> errores = servicio.crearCupon(codigo, descripcion, fechaInicio, fechaFin);
        if (!errores.isEmpty()) {

            model.addAttribute("errores", errores);
            model.addAttribute("cupones", servicio.listarCupones());
            model.addAttribute("porcentajeCupon", OperacionServiceJLHA.PORCENTAJE_CUPON_RN01);
            return "CuponesJLHA/crearJLHA";
        }
        flash.addFlashAttribute("mensaje",
                "Cupón " + servicio.normalizarCodigo(codigo) + " creado correctamente con estado ACTIVO.");
        return "redirect:/cupones/nuevo";
    }




    @GetMapping("/metricas")
    public String metricas(@RequestParam(required = false) String desde,
                           @RequestParam(required = false) String hasta,
                           Model model) {
        PanelMetricasJLHA panel = servicio.armarMetricas(desde, hasta);
        model.addAttribute("panel", panel);
        model.addAttribute("datosJson", servicio.aJson(panel));
        return "MetricasJLHA/panelJLHA";
    }
}
