package com.example.SistemaGimnasioV2.Repository;

import com.example.SistemaGimnasioV2.modelJB.PlanJB;
import com.example.SistemaGimnasioV2.modelJB.SubproductoJB;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;

@Repository
public class PlanGestionRepositoryLDG {

    private final JdbcTemplate jdbc;

    private static final String SQL_SUBPRODUCTOS =
            "SELECT s.id_subproducto, s.id_categoria, c.nombre_categoria, " +
                    "s.nombre_subproducto, s.precio_individual, s.estado " +
                    "FROM SUBPRODUCTO s JOIN CATEGORIA c ON c.id_categoria = s.id_categoria ";

    public PlanGestionRepositoryLDG(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<PlanJB> listarPlanes() {
        return jdbc.query(
                "SELECT id_plan, nombre_plan, precio_base, duracion_dias FROM PLAN " +
                        "WHERE id_plan IN (1, 2, 3) ORDER BY id_plan",
                new BeanPropertyRowMapper<>(PlanJB.class));
    }

    public PlanJB buscarPlan(int idPlan) {
        List<PlanJB> planes = jdbc.query(
                "SELECT id_plan, nombre_plan, precio_base, duracion_dias FROM PLAN WHERE id_plan = ?",
                new BeanPropertyRowMapper<>(PlanJB.class), idPlan);
        if (planes.isEmpty()) {
            return null;
        }
        return planes.get(0);
    }

    public List<SubproductoJB> listarSubproductos() {
        return jdbc.query(
                SQL_SUBPRODUCTOS + "WHERE s.estado = 'ACTIVO' AND c.estado = 'ACTIVO' " +
                        "ORDER BY s.id_subproducto",
                new BeanPropertyRowMapper<>(SubproductoJB.class));
    }

    public SubproductoJB buscarSubproducto(int idSubproducto) {
        List<SubproductoJB> subproductos = jdbc.query(
                SQL_SUBPRODUCTOS + "WHERE s.id_subproducto = ?",
                new BeanPropertyRowMapper<>(SubproductoJB.class), idSubproducto);
        if (subproductos.isEmpty()) {
            return null;
        }
        return subproductos.get(0);
    }

    public List<Integer> listarIdsSubproductos(int idPlan) {
        return jdbc.queryForList(
                "SELECT id_subproducto FROM PLAN_SUBPRODUCTO WHERE id_plan = ? ORDER BY id_subproducto",
                Integer.class, idPlan);
    }

    public List<String> listarNombresSubproductos(int idPlan) {
        return jdbc.queryForList(
                "SELECT s.nombre_subproducto FROM PLAN_SUBPRODUCTO ps " +
                        "JOIN SUBPRODUCTO s ON s.id_subproducto = ps.id_subproducto " +
                        "WHERE ps.id_plan = ? ORDER BY s.id_subproducto",
                String.class, idPlan);
    }

    public int actualizarPrecioPlan(int idPlan, BigDecimal precioBase) {
        return jdbc.update(
                "UPDATE PLAN SET precio_base = ? WHERE id_plan = ?",
                precioBase, idPlan);
    }

    public int eliminarSubproductosPlan(int idPlan) {
        return jdbc.update(
                "DELETE FROM PLAN_SUBPRODUCTO WHERE id_plan = ?",
                idPlan);
    }

    public int insertarSubproductoPlan(int idPlan, int idSubproducto) {
        return jdbc.update(
                "INSERT INTO PLAN_SUBPRODUCTO (id_plan, id_subproducto) VALUES (?, ?)",
                idPlan, idSubproducto);
    }
}
