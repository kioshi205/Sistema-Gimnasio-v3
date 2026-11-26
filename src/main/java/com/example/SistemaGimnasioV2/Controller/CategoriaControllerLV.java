package com.example.SistemaGimnasioV2.Controller;

import com.example.SistemaGimnasioV2.Service.CategoriaServiceLV;
import com.example.SistemaGimnasioV2.modelJB.CategoriaLV;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/categorias")
public class CategoriaControllerLV {

    private final CategoriaServiceLV servicio;

    public CategoriaControllerLV(CategoriaServiceLV servicio) {
        this.servicio = servicio;
    }

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("categorias", servicio.listarCategorias());
        return "CategoriasLV/listarCategoriasLV";
    }

    @GetMapping("/registrar")
    public String formularioRegistrar(Model model) {
        model.addAttribute("categoria", new CategoriaLV());
        return "CategoriasLV/registrarCategoriaLV";
    }

    @PostMapping("/registrar")
    public String registrar(@RequestParam(required = false) String nombreCategoria,
                            @RequestParam(required = false) String descripcion,
                            Model model) {
        CategoriaLV categoria = new CategoriaLV();
        categoria.setNombreCategoria(nombreCategoria);
        categoria.setDescripcion(descripcion);

        List<String> errores = servicio.registrar(categoria);
        if (!errores.isEmpty()) {
            model.addAttribute("errores", errores);
            model.addAttribute("categoria", categoria);
            return "CategoriasLV/registrarCategoriaLV";
        }
        return "redirect:/categorias";
    }

    @GetMapping("/editar")
    public String formularioEditar(@RequestParam int id, Model model) {
        CategoriaLV categoria = servicio.buscarCategoria(id);
        if (categoria == null) {
            return "redirect:/categorias";
        }
        model.addAttribute("categoria", categoria);
        model.addAttribute("planesBloqueados", servicio.listarPlanesBloqueados(id));
        return "CategoriasLV/editarCategoriaLV";
    }

    @PostMapping("/editar")
    public String editar(@RequestParam(required = false) Integer idCategoria,
                         @RequestParam(required = false) String nombreCategoria,
                         @RequestParam(required = false) String descripcion,
                         @RequestParam(required = false) String estado,
                         Model model) {
        CategoriaLV categoria = new CategoriaLV();
        categoria.setIdCategoria(idCategoria);
        categoria.setNombreCategoria(nombreCategoria);
        categoria.setDescripcion(descripcion);
        categoria.setEstado(estado);

        List<String> errores = servicio.actualizar(categoria);
        if (!errores.isEmpty()) {
            model.addAttribute("errores", errores);
            model.addAttribute("categoria", categoria);
            if (idCategoria != null) {
                model.addAttribute("planesBloqueados", servicio.listarPlanesBloqueados(idCategoria));
            }
            return "CategoriasLV/editarCategoriaLV";
        }
        return "redirect:/categorias";
    }

    @PostMapping("/desactivar")
    public String desactivar(@RequestParam int idCategoria) {
        servicio.desactivar(idCategoria);
        return "redirect:/categorias/editar?id=" + idCategoria;
    }

    @PostMapping("/activar")
    public String activar(@RequestParam int idCategoria) {
        servicio.activar(idCategoria);
        return "redirect:/categorias/editar?id=" + idCategoria;
    }
}
