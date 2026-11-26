package com.example.SistemaGimnasioV2.Service;

import com.example.SistemaGimnasioV2.Repository.CategoriaRepositoryLV;
import com.example.SistemaGimnasioV2.Repository.SubproductoRepositoryLV;
import com.example.SistemaGimnasioV2.modelJB.CategoriaLV;
import com.example.SistemaGimnasioV2.modelJB.SubproductoLV;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
public class SubproductoServiceLV {

    private final SubproductoRepositoryLV repo;
    private final CategoriaRepositoryLV categoriaRepo;
    private final SuscripcionServiceJB suscripcionService;

    public SubproductoServiceLV(SubproductoRepositoryLV repo, CategoriaRepositoryLV categoriaRepo,
                                SuscripcionServiceJB suscripcionService) {
        this.repo = repo;
        this.categoriaRepo = categoriaRepo;
        this.suscripcionService = suscripcionService;
    }

    public List<SubproductoLV> listarSubproductos(Integer idCategoria) {
        if (idCategoria != null && idCategoria > 0) {
            return repo.listarPorCategoria(idCategoria);
        }
        return repo.listarTodos();
    }

    public List<CategoriaLV> listarCategorias() {
        return categoriaRepo.listar();
    }

    public List<CategoriaLV> listarCategoriasActivas() {
        return categoriaRepo.listarActivas();
    }

    public SubproductoLV buscarSubproducto(int idSubproducto) {
        return repo.buscarPorId(idSubproducto);
    }

    // RN02: baja lógica, nunca se elimina el subproducto
    public void desactivar(int idSubproducto) {
        cambiarEstado(idSubproducto, "INACTIVO");
    }

    public void activar(int idSubproducto) {
        cambiarEstado(idSubproducto, "ACTIVO");
    }

    private void cambiarEstado(int idSubproducto, String estado) {
        SubproductoLV subproducto = repo.buscarPorId(idSubproducto);
        if (subproducto != null) {
            subproducto.setEstado(estado);
            repo.actualizar(subproducto);
        }
    }

    // RN02: usa el método de main para saber qué planes quedan bloqueados
    public List<String> listarPlanesBloqueados(int idSubproducto) {
        List<Integer> idsPlanes = repo.listarIdsPlanesPorSubproducto(idSubproducto);
        List<String> nombres = new ArrayList<>();
        for (Integer idPlan : idsPlanes) {
            if (!suscripcionService.planDisponible(idPlan)) {
                nombres.add(repo.buscarNombrePlan(idPlan));
            }
        }
        return nombres;
    }

    public List<String> registrar(SubproductoLV subproducto, String precioTexto) {
        subproducto.setNombreSubproducto(texto(subproducto.getNombreSubproducto()));
        subproducto.setEstado("ACTIVO");

        List<String> errores = new ArrayList<>();
        subproducto.setPrecioIndividual(parsearPrecio(precioTexto, errores));
        validar(subproducto, errores, false);

        if (errores.isEmpty()) {
            repo.insertar(subproducto);
        }
        return errores;
    }

    public List<String> actualizar(SubproductoLV subproducto, String precioTexto) {
        subproducto.setNombreSubproducto(texto(subproducto.getNombreSubproducto()));
        subproducto.setEstado(texto(subproducto.getEstado()).toUpperCase());

        List<String> errores = new ArrayList<>();
        if (subproducto.getIdSubproducto() == null
                || repo.buscarPorId(subproducto.getIdSubproducto()) == null) {
            errores.add("El subproducto que intenta editar no existe.");
        }
        subproducto.setPrecioIndividual(parsearPrecio(precioTexto, errores));
        validar(subproducto, errores, true);

        if (errores.isEmpty()) {
            repo.actualizar(subproducto);
        }
        return errores;
    }

    private void validar(SubproductoLV subproducto, List<String> errores, boolean esEdicion) {
        if (subproducto.getIdCategoria() == null) {
            errores.add("Debe seleccionar una categoría.");
        } else {
            CategoriaLV categoria = categoriaRepo.buscarPorId(subproducto.getIdCategoria());
            if (categoria == null) {
                errores.add("La categoría seleccionada no existe.");
            } else if (!esEdicion && !"ACTIVO".equals(categoria.getEstado())) {
                errores.add("Solo se puede registrar en categorías activas.");
            }
        }

        String nombre = subproducto.getNombreSubproducto();
        if (nombre.isEmpty()) {
            errores.add("El nombre del subproducto es obligatorio.");
        } else if (nombre.length() > 100) {
            errores.add("El nombre del subproducto no puede superar los 100 caracteres.");
        }

        BigDecimal precio = subproducto.getPrecioIndividual();
        if (precio != null && precio.compareTo(BigDecimal.ZERO) < 0) {
            errores.add("El precio individual debe ser mayor o igual a 0.00.");
        }

        String estado = subproducto.getEstado();
        if (!"ACTIVO".equals(estado) && !"INACTIVO".equals(estado)) {
            errores.add("El estado debe ser ACTIVO o INACTIVO.");
        }
    }

    private BigDecimal parsearPrecio(String precioTexto, List<String> errores) {
        if (precioTexto == null || precioTexto.trim().isEmpty()) {
            errores.add("El precio individual es obligatorio.");
            return null;
        }
        try {
            return new BigDecimal(precioTexto.trim());
        } catch (NumberFormatException e) {
            errores.add("El precio individual debe ser un número válido.");
            return null;
        }
    }

    private String texto(String valor) {
        return valor == null ? "" : valor.trim();
    }
}
