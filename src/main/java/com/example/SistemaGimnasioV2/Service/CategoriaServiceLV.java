package com.example.SistemaGimnasioV2.Service;

import com.example.SistemaGimnasioV2.Repository.CategoriaRepositoryLV;
import com.example.SistemaGimnasioV2.modelJB.CategoriaLV;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class CategoriaServiceLV {

    private final CategoriaRepositoryLV repo;

    public CategoriaServiceLV(CategoriaRepositoryLV repo) {
        this.repo = repo;
    }

    public List<CategoriaLV> listarCategorias() {
        return repo.listar();
    }

    public List<CategoriaLV> listarCategoriasActivas() {
        return repo.listarActivas();
    }

    public CategoriaLV buscarCategoria(int idCategoria) {
        return repo.buscarPorId(idCategoria);
    }

    public List<String> registrar(CategoriaLV categoria) {
        categoria.setNombreCategoria(texto(categoria.getNombreCategoria()));
        categoria.setDescripcion(texto(categoria.getDescripcion()));
        categoria.setEstado("ACTIVO");

        List<String> errores = validar(categoria, false);
        if (errores.isEmpty()) {
            repo.insertar(categoria);
        }
        return errores;
    }

    public List<String> actualizar(CategoriaLV categoria) {
        categoria.setNombreCategoria(texto(categoria.getNombreCategoria()));
        categoria.setDescripcion(texto(categoria.getDescripcion()));
        categoria.setEstado(texto(categoria.getEstado()).toUpperCase());

        List<String> errores = validar(categoria, true);
        if (errores.isEmpty()) {
            repo.actualizar(categoria);
        }
        return errores;
    }

    private List<String> validar(CategoriaLV categoria, boolean esEdicion) {
        List<String> errores = new ArrayList<>();

        if (esEdicion) {
            if (categoria.getIdCategoria() == null || repo.buscarPorId(categoria.getIdCategoria()) == null) {
                errores.add("La categoría que intenta editar no existe.");
            }
        }

        String nombre = categoria.getNombreCategoria();
        if (nombre.isEmpty()) {
            errores.add("El nombre de la categoría es obligatorio.");
        } else if (nombre.length() > 60) {
            errores.add("El nombre de la categoría no puede superar los 60 caracteres.");
        }

        String descripcion = categoria.getDescripcion();
        if (descripcion.isEmpty()) {
            categoria.setDescripcion(null);
        } else if (descripcion.length() > 200) {
            errores.add("La descripción no puede superar los 200 caracteres.");
        }

        String estado = categoria.getEstado();
        if (!"ACTIVO".equals(estado) && !"INACTIVO".equals(estado)) {
            errores.add("El estado debe ser ACTIVO o INACTIVO.");
        }

        return errores;
    }

    private String texto(String valor) {
        return valor == null ? "" : valor.trim();
    }
}
