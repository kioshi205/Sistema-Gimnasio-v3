package com.example.SistemaGimnasioV2.Repository;

import com.example.SistemaGimnasioV2.modelJB.SubproductoLV;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class SubproductoRepositoryLV {

    private static final String SQL_BASE =
            "SELECT s.id_subproducto, s.id_categoria, c.nombre_categoria, " +
                    "s.nombre_subproducto, s.precio_individual, s.estado " +
                    "FROM SUBPRODUCTO s INNER JOIN CATEGORIA c ON c.id_categoria = s.id_categoria ";

    private final JdbcTemplate jdbc;

    private static final RowMapper<SubproductoLV> MAPEADOR = (rs, numeroFila) -> {
        SubproductoLV subproducto = new SubproductoLV();
        subproducto.setIdSubproducto(rs.getInt("id_subproducto"));
        subproducto.setIdCategoria(rs.getInt("id_categoria"));
        subproducto.setNombreCategoria(rs.getString("nombre_categoria"));
        subproducto.setNombreSubproducto(rs.getString("nombre_subproducto"));
        subproducto.setPrecioIndividual(rs.getBigDecimal("precio_individual"));
        subproducto.setEstado(rs.getString("estado"));
        return subproducto;
    };

    public SubproductoRepositoryLV(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<SubproductoLV> listarTodos() {
        return jdbc.query(SQL_BASE + "ORDER BY s.id_subproducto", MAPEADOR);
    }

    public List<SubproductoLV> listarPorCategoria(int idCategoria) {
        String sql = SQL_BASE + "WHERE c.id_categoria = ? ORDER BY s.id_subproducto";
        return jdbc.query(sql, MAPEADOR, idCategoria);
    }

    public SubproductoLV buscarPorId(int idSubproducto) {
        String sql = SQL_BASE + "WHERE s.id_subproducto = ?";
        List<SubproductoLV> subproductos = jdbc.query(sql, MAPEADOR, idSubproducto);
        return subproductos.isEmpty() ? null : subproductos.get(0);
    }

    public void insertar(SubproductoLV subproducto) {
        String sql = "INSERT INTO SUBPRODUCTO " +
                "(id_categoria, nombre_subproducto, precio_individual, estado) " +
                "VALUES (?, ?, ?, 'ACTIVO')";
        jdbc.update(sql, subproducto.getIdCategoria(), subproducto.getNombreSubproducto(),
                subproducto.getPrecioIndividual());
    }

    public void actualizar(SubproductoLV subproducto) {
        String sql = "UPDATE SUBPRODUCTO SET id_categoria = ?, nombre_subproducto = ?, " +
                "precio_individual = ?, estado = ? WHERE id_subproducto = ?";
        jdbc.update(sql, subproducto.getIdCategoria(), subproducto.getNombreSubproducto(),
                subproducto.getPrecioIndividual(), subproducto.getEstado(),
                subproducto.getIdSubproducto());
    }

    public List<Integer> listarIdsPlanesPorSubproducto(int idSubproducto) {
        String sql = "SELECT DISTINCT ps.id_plan FROM PLAN_SUBPRODUCTO ps " +
                "WHERE ps.id_subproducto = ?";
        return jdbc.queryForList(sql, Integer.class, idSubproducto);
    }

    public String buscarNombrePlan(int idPlan) {
        return jdbc.queryForObject("SELECT nombre_plan FROM PLAN WHERE id_plan = ?", String.class, idPlan);
    }
}
