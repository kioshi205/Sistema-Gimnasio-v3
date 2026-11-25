package com.example.SistemaGimnasioV2.Controller;

import com.example.SistemaGimnasioV2.Service.SubproductoServiceLV;
import com.example.SistemaGimnasioV2.modelJB.SubproductoLV;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/subproductos")
public class SubproductoControllerLV {

    private final SubproductoServiceLV servicio;

    public SubproductoControllerLV(SubproductoServiceLV servicio) {
        this.servicio = servicio;
    }

    @GetMapping
    public String listar(@RequestParam(required = false) Integer idCategoria, Model model) {
        model.addAttribute("subproductos", servicio.listarSubproductos(idCategoria));
        model.addAttribute("categorias", servicio.listarCategorias());
        model.addAttribute("idCategoria", idCategoria);
        return "SubproductosLV/listarSubproductosLV";
    }

    @GetMapping("/registrar")
    public String formularioRegistrar(Model model) {
        model.addAttribute("subproducto", new SubproductoLV());
        model.addAttribute("categorias", servicio.listarCategoriasActivas());
        return "SubproductosLV/registrarSubproductoLV";
    }

    @PostMapping("/registrar")
    public String registrar(@RequestParam(required = false) Integer idCategoria,
                            @RequestParam(required = false) String nombreSubproducto,
                            @RequestParam(required = false) String precioIndividual,
                            Model model) {
        SubproductoLV subproducto = new SubproductoLV();
        subproducto.setIdCategoria(idCategoria);
        subproducto.setNombreSubproducto(nombreSubproducto);

        List<String> errores = servicio.registrar(subproducto, precioIndividual);
        if (!errores.isEmpty()) {
            model.addAttribute("errores", errores);
            model.addAttribute("subproducto", subproducto);
            model.addAttribute("precioTexto", precioIndividual);
            model.addAttribute("categorias", servicio.listarCategoriasActivas());
            return "SubproductosLV/registrarSubproductoLV";
        }
        return "redirect:/subproductos";
    }

    @GetMapping("/editar")
    public String formularioEditar(@RequestParam int id, Model model) {
        SubproductoLV subproducto = servicio.buscarSubproducto(id);
        if (subproducto == null) {
            return "redirect:/subproductos";
        }
        model.addAttribute("subproducto", subproducto);
        model.addAttribute("precioTexto", subproducto.getPrecioIndividual().toPlainString());
        model.addAttribute("categorias", servicio.listarCategorias());
        model.addAttribute("planesBloqueados", servicio.listarPlanesBloqueados(id));
        return "SubproductosLV/editarSubproductoLV";
    }

    @PostMapping("/editar")
    public String editar(@RequestParam(required = false) Integer idSubproducto,
                         @RequestParam(required = false) Integer idCategoria,
                         @RequestParam(required = false) String nombreSubproducto,
                         @RequestParam(required = false) String precioIndividual,
                         @RequestParam(required = false) String estado,
                         Model model) {
        SubproductoLV subproducto = new SubproductoLV();
        subproducto.setIdSubproducto(idSubproducto);
        subproducto.setIdCategoria(idCategoria);
        subproducto.setNombreSubproducto(nombreSubproducto);
        subproducto.setEstado(estado);

        List<String> errores = servicio.actualizar(subproducto, precioIndividual);
        if (!errores.isEmpty()) {
            model.addAttribute("errores", errores);
            model.addAttribute("subproducto", subproducto);
            model.addAttribute("precioTexto", precioIndividual);
            model.addAttribute("categorias", servicio.listarCategorias());
            if (idSubproducto != null) {
                model.addAttribute("planesBloqueados", servicio.listarPlanesBloqueados(idSubproducto));
            }
            return "SubproductosLV/editarSubproductoLV";
        }
        return "redirect:/subproductos";
    }

    @PostMapping("/desactivar")
    public String desactivar(@RequestParam int idSubproducto) {
        servicio.desactivar(idSubproducto);
        return "redirect:/subproductos/editar?id=" + idSubproducto;
    }

    @PostMapping("/activar")
    public String activar(@RequestParam int idSubproducto) {
        servicio.activar(idSubproducto);
        return "redirect:/subproductos/editar?id=" + idSubproducto;
    }
}
