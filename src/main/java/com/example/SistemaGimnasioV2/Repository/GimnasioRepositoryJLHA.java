package com.example.SistemaGimnasioV2.Repository;

import com.example.SistemaGimnasioV2.modelJB.ClienteJB;
import com.example.SistemaGimnasioV2.modelJLHA.CuponJLHA;
import com.example.SistemaGimnasioV2.modelJLHA.MarcacionAccesoJLHA;
import com.example.SistemaGimnasioV2.modelJLHA.SuscripcionVigenteJLHA;
import com.example.SistemaGimnasioV2.modelJLHA.VentaJLHA;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.sql.Time;
import java.sql.Types;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Repository
public class GimnasioRepositoryJLHA {

    private final JdbcTemplate jdbc;

    public GimnasioRepositoryJLHA(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    // ===================== INT20 - Control de acceso =====================

    public ClienteJB buscarClientePorDni(String dni) {
        List<ClienteJB> clientes = jdbc.query(
                "SELECT id_cliente, dni, nombre, apellido FROM CLIENTE WHERE dni = ?",
                new BeanPropertyRowMapper<>(ClienteJB.class), dni);
        return clientes.isEmpty() ? null : clientes.get(0);
    }

    /** Suscripción cuyo rango de fechas incluye "hoy"; si hay varias, la que vence más tarde. */
    public SuscripcionVigenteJLHA buscarSuscripcionVigente(int idCliente, LocalDate hoy) {
        List<SuscripcionVigenteJLHA> lista = jdbc.query(
                "SELECT id_suscripcion, detalle, fecha_fin FROM SUSCRIPCION " +
                        "WHERE id_cliente = ? AND fecha_inicio <= ? AND fecha_fin >= ? " +
                        "ORDER BY fecha_fin DESC LIMIT 1",
                new BeanPropertyRowMapper<>(SuscripcionVigenteJLHA.class),
                idCliente, Date.valueOf(hoy), Date.valueOf(hoy));
        return lista.isEmpty() ? null : lista.get(0);
    }

    /** Inserta una marcación. idSuscripcion es null cuando el resultado es DENEGADO. */
    public void insertarMarcacion(int idCliente, Integer idSuscripcion,
                                  LocalDate fecha, LocalTime hora, String resultado) {
        jdbc.update(
                "INSERT INTO MARCACION_ACCESO (id_cliente, id_suscripcion, fecha_acceso, hora_acceso, resultado) " +
                        "VALUES (?, ?, ?, ?, ?)",
                new Object[]{idCliente, idSuscripcion, Date.valueOf(fecha), Time.valueOf(hora), resultado},
                new int[]{Types.INTEGER, Types.INTEGER, Types.DATE, Types.TIME, Types.VARCHAR});
    }

    public List<MarcacionAccesoJLHA> ultimasMarcaciones(int limite) {
        return jdbc.query(
                "SELECT m.id_acceso, c.dni, CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo, " +
                        "m.fecha_acceso, m.hora_acceso, m.resultado " +
                        "FROM MARCACION_ACCESO m JOIN CLIENTE c ON c.id_cliente = m.id_cliente " +
                        "ORDER BY m.fecha_acceso DESC, m.hora_acceso DESC, m.id_acceso DESC LIMIT ?",
                new BeanPropertyRowMapper<>(MarcacionAccesoJLHA.class), limite);
    }

    // ===================== INT21 - Cupones =====================

    public boolean existeCodigo(String codigo) {
        Integer cantidad = jdbc.queryForObject(
                "SELECT COUNT(*) FROM CUPON WHERE UPPER(codigo) = ?", Integer.class, codigo.toUpperCase());
        return cantidad != null && cantidad > 0;
    }

    /** Inserta el cupón con estado ACTIVO. */
    public void insertarCupon(CuponJLHA c) {
        jdbc.update(
                "INSERT INTO CUPON (codigo, descripcion, porcentaje_descuento, fecha_inicio, fecha_fin, estado) " +
                        "VALUES (?, ?, ?, ?, ?, 'ACTIVO')",
                c.getCodigo(), c.getDescripcion(), c.getPorcentajeDescuento(),
                Date.valueOf(c.getFechaInicio()), Date.valueOf(c.getFechaFin()));
    }

    public List<CuponJLHA> listarCupones() {
        return jdbc.query(
                "SELECT c.id_cupon, c.codigo, c.descripcion, c.porcentaje_descuento, c.fecha_inicio, c.fecha_fin, " +
                        "c.estado, (SELECT COUNT(*) FROM SUSCRIPCION s WHERE s.id_cupon = c.id_cupon) AS usos " +
                        "FROM CUPON c ORDER BY c.id_cupon DESC",
                new BeanPropertyRowMapper<>(CuponJLHA.class));
    }

    // ===================== Métricas de ganancias =====================

    /** Las ganancias salen de SUSCRIPCION.monto_total, fechadas por fecha_inicio. Sin plan = Personalizado. */
    public List<VentaJLHA> listarVentas(LocalDate desde, LocalDate hasta) {
        return jdbc.query(
                "SELECT s.fecha_inicio AS fecha, COALESCE(p.nombre_plan, 'Personalizado') AS plan, " +
                        "s.monto_total AS monto " +
                        "FROM SUSCRIPCION s LEFT JOIN PLAN p ON p.id_plan = s.id_plan " +
                        "WHERE s.fecha_inicio >= ? AND s.fecha_inicio <= ? " +
                        "ORDER BY s.fecha_inicio",
                new BeanPropertyRowMapper<>(VentaJLHA.class), Date.valueOf(desde), Date.valueOf(hasta));
    }
}
