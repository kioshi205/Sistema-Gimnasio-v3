package com.example.SistemaGimnasioV2.Repository;

import com.example.SistemaGimnasioV2.modelJB.ClienteJB;
import com.example.SistemaGimnasioV2.modelJB.PlanJB;
import com.example.SistemaGimnasioV2.modelJB.SubproductoJB;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Repository
public class GimnasioRepositoryJB {

    private final JdbcTemplate jdbc;

    public GimnasioRepositoryJB(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }
    /*
    private static final String SQL_SUBPRODUCTOS =
            "SELECT s.id_subproducto, s.id_categoria, c.nombre_categoria, s.nombre_subproducto, s.precio_individual " +
                    "FROM SUBPRODUCTO s JOIN CATEGORIA c ON c.id_categoria = s.id_categoria ";

     */
    private static final String SQL_SUBPRODUCTOS =
            "SELECT s.id_subproducto, s.id_categoria, c.nombre_categoria, " +
                    "s.nombre_subproducto, s.precio_individual, s.estado " +
                    "FROM SUBPRODUCTO s JOIN CATEGORIA c ON c.id_categoria = s.id_categoria ";

    public List<PlanJB> listarPlanes() {
        return jdbc.query(
                "SELECT id_plan, nombre_plan, descripcion, precio_base, duracion_dias FROM PLAN ORDER BY precio_base",
                new BeanPropertyRowMapper<>(PlanJB.class));
    }

    public PlanJB buscarPlan(int idPlan) {
        return jdbc.queryForObject(
                "SELECT id_plan, nombre_plan, descripcion, precio_base, duracion_dias FROM PLAN WHERE id_plan = ?",
                new BeanPropertyRowMapper<>(PlanJB.class), idPlan);
    }

    /*public List<SubproductoJB> listarSubproductos() {
        return jdbc.query(
                SQL_SUBPRODUCTOS + "ORDER BY s.id_subproducto",
                new BeanPropertyRowMapper<>(SubproductoJB.class));
    }
     */

    public List<SubproductoJB> listarSubproductos() {
        String sql = SQL_SUBPRODUCTOS +
                "WHERE s.estado = 'ACTIVO' AND c.estado = 'ACTIVO' " +
                "ORDER BY s.id_subproducto";
        return jdbc.query(sql, new BeanPropertyRowMapper<>(SubproductoJB.class));
    }

    public List<SubproductoJB> buscarSubproductos(List<Integer> ids) {
        List<SubproductoJB> lista = new ArrayList<>();
        for (Integer id : ids) {
            lista.add(jdbc.queryForObject(
                    SQL_SUBPRODUCTOS + "WHERE s.id_subproducto = ?",
                    new BeanPropertyRowMapper<>(SubproductoJB.class), id));
        }
        return lista;
    }

    public ClienteJB buscarClientePorDni(String dni) {
        List<ClienteJB> clientes = jdbc.query(
                "SELECT id_cliente, dni, nombre, apellido, telefono, email FROM CLIENTE WHERE dni = ?",
                new BeanPropertyRowMapper<>(ClienteJB.class), dni);
        return clientes.isEmpty() ? null : clientes.get(0);
    }

    public ClienteJB buscarCliente(int idCliente) {
        return jdbc.queryForObject(
                "SELECT id_cliente, dni, nombre, apellido, telefono, email FROM CLIENTE WHERE id_cliente = ?",
                new BeanPropertyRowMapper<>(ClienteJB.class), idCliente);
    }

    public boolean existeEmail(String email) {
        Integer cantidad = jdbc.queryForObject("SELECT COUNT(*) FROM CLIENTE WHERE email = ?", Integer.class, email);
        return cantidad > 0;
    }

    public int insertarCliente(ClienteJB c) {
        jdbc.update("INSERT INTO CLIENTE (dni, nombre, apellido, telefono, email) VALUES (?, ?, ?, ?, ?)",
                c.getDni(), c.getNombre(), c.getApellido(), c.getTelefono(), c.getEmail());
        return jdbc.queryForObject("SELECT MAX(id_cliente) FROM CLIENTE", Integer.class);
    }

    public LocalDate fechaFinVigente(int idCliente, LocalDate hoy) {
        Date fin = jdbc.queryForObject(
                "SELECT MAX(fecha_fin) FROM SUSCRIPCION WHERE id_cliente = ? AND fecha_fin >= ?",
                Date.class, idCliente, Date.valueOf(hoy));
        return fin == null ? null : fin.toLocalDate();
    }

    public int insertarSuscripcion(int idCliente, Integer idPlan, String detalle,
                                   LocalDate inicio, LocalDate fin, BigDecimal monto) {
        jdbc.update("INSERT INTO SUSCRIPCION (id_cliente, id_plan, detalle, fecha_inicio, fecha_fin, monto_total) " +
                        "VALUES (?, ?, ?, ?, ?, ?)",
                idCliente, idPlan, detalle, Date.valueOf(inicio), Date.valueOf(fin), monto);
        return jdbc.queryForObject("SELECT MAX(id_suscripcion) FROM SUSCRIPCION", Integer.class);
    }
}
