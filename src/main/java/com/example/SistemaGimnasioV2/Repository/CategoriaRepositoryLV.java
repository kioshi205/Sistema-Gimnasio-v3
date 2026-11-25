package com.example.SistemaGimnasioV2.Repository;

import com.example.SistemaGimnasioV2.modelJB.CategoriaLV;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class CategoriaRepositoryLV {

    private final JdbcTemplate jdbc;

    private static final RowMapper<CategoriaLV> MAPEADOR = (rs, numeroFila) -> {
        CategoriaLV categoria = new CategoriaLV();
        categoria.setIdCategoria(rs.getInt("id_categoria"));
        categoria.setNombreCategoria(rs.getString("nombre_categoria"));
        categoria.setDescripcion(rs.getString("descripcion"));
        categoria.setEstado(rs.getString("estado"));
        return categoria;
    };

    public CategoriaRepositoryLV(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<CategoriaLV> listar() {
        String sql = "SELECT id_categoria, nombre_categoria, descripcion, estado " +
                "FROM CATEGORIA ORDER BY id_categoria";
        return jdbc.query(sql, MAPEADOR);
    }

    public List<CategoriaLV> listarActivas() {
        String sql = "SELECT id_categoria, nombre_categoria, descripcion, estado " +
                "FROM CATEGORIA WHERE estado = 'ACTIVO' ORDER BY nombre_categoria";
        return jdbc.query(sql, MAPEADOR);
    }

    public CategoriaLV buscarPorId(int idCategoria) {
        String sql = "SELECT id_categoria, nombre_categoria, descripcion, estado " +
                "FROM CATEGORIA WHERE id_categoria = ?";
        List<CategoriaLV> categorias = jdbc.query(sql, MAPEADOR, idCategoria);
        return categorias.isEmpty() ? null : categorias.get(0);
    }

    public void insertar(CategoriaLV categoria) {
        String sql = "INSERT INTO CATEGORIA (nombre_categoria, descripcion, estado) VALUES (?, ?, 'ACTIVO')";
        jdbc.update(sql, categoria.getNombreCategoria(), categoria.getDescripcion());
    }

    public void actualizar(CategoriaLV categoria) {
        String sql = "UPDATE CATEGORIA SET nombre_categoria = ?, descripcion = ?, estado = ? " +
                "WHERE id_categoria = ?";
        jdbc.update(sql, categoria.getNombreCategoria(), categoria.getDescripcion(),
                categoria.getEstado(), categoria.getIdCategoria());
    }
}
