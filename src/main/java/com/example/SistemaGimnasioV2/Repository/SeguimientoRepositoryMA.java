
package com.example.SistemaGimnasioV2.Repository;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Repository
public class SeguimientoRepositoryMA {

    private final JdbcTemplate jdbc;

    public SeguimientoRepositoryMA(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    private final RowMapper<Map<String, Object>> mapper = (rs, rowNum) -> {
        Map<String, Object> m = new java.util.HashMap<>();
        int n = rs.getMetaData().getColumnCount();

        for (int i = 1; i <= n; i++) {
            m.put(rs.getMetaData().getColumnLabel(i), rs.getObject(i));
        }

        return m;
    };

    public List<Map<String, Object>> listarClientes(String buscar) {
        String sql = """
            SELECT *
            FROM CLIENTE
            WHERE LOWER(DNI) LIKE LOWER(?)
               OR LOWER(NOMBRE) LIKE LOWER(?)
               OR LOWER(APELLIDO) LIKE LOWER(?)
            ORDER BY APELLIDO, NOMBRE
        """;

        String filtro = "%" + (buscar == null ? "" : buscar.trim()) + "%";

        return jdbc.query(sql, mapper, filtro, filtro, filtro);
    }

    public Map<String, Object> buscarCliente(int id) {
        String sql = "SELECT * FROM CLIENTE WHERE ID_CLIENTE = ?";
        List<Map<String, Object>> resultado = jdbc.query(sql, mapper, id);

        return resultado.isEmpty() ? null : resultado.get(0);
    }

    public int actualizarCliente(int id, String nombre, String apellido,
                                 String telefono, String email) {
        String sql = """
            UPDATE CLIENTE
            SET NOMBRE = ?, APELLIDO = ?, TELEFONO = ?, EMAIL = ?
            WHERE ID_CLIENTE = ?
        """;

        return jdbc.update(sql, nombre, apellido, telefono, email, id);
    }

    public boolean existeEmail(String email, int idCliente) {
        Integer cantidad = jdbc.queryForObject(
                "SELECT COUNT(*) FROM CLIENTE WHERE LOWER(EMAIL) = LOWER(?) AND ID_CLIENTE <> ?",
                Integer.class, email, idCliente
        );

        return cantidad != null && cantidad > 0;
    }

    public List<Map<String, Object>> listarSuscripciones() {
        return listarSuscripciones("", "");
    }

    public List<Map<String, Object>> listarSuscripciones(
            String buscar, String estado) {

        String filtro = "%" + (buscar == null ? "" : buscar.trim()) + "%";
        String estadoFiltro = estado == null ? "" : estado.trim();

        String sql = """
            SELECT
                S.ID_SUSCRIPCION,
                S.ID_CLIENTE,
                C.DNI,
                C.NOMBRE,
                C.APELLIDO,
                S.ID_PLAN,
                COALESCE(P.NOMBRE_PLAN, 'Personalizado') AS NOMBRE_PLAN,
                COALESCE(P.PRECIO_BASE, 0) AS PRECIO_PLAN,
                S.DETALLE,
                S.FECHA_INICIO,
                S.FECHA_FIN,
                S.MONTO_TOTAL,
                CASE
                    WHEN S.FECHA_FIN < CURRENT_DATE THEN 'Vencida'
                    WHEN S.FECHA_FIN <= DATEADD('DAY', 7, CURRENT_DATE) THEN 'Por vencer'
                    ELSE 'Vigente'
                END AS ESTADO_SUSCRIPCION
            FROM SUSCRIPCION S
            INNER JOIN CLIENTE C ON C.ID_CLIENTE = S.ID_CLIENTE
            LEFT JOIN PLAN P ON P.ID_PLAN = S.ID_PLAN
            WHERE (
                LOWER(C.DNI) LIKE LOWER(?)
                OR LOWER(C.NOMBRE) LIKE LOWER(?)
                OR LOWER(C.APELLIDO) LIKE LOWER(?)
            )
            AND (
                ? = ''
                OR CASE
                    WHEN S.FECHA_FIN < CURRENT_DATE THEN 'Vencida'
                    WHEN S.FECHA_FIN <= DATEADD('DAY', 7, CURRENT_DATE) THEN 'Por vencer'
                    ELSE 'Vigente'
                END = ?
            )
            ORDER BY S.FECHA_FIN DESC
        """;

        return jdbc.query(
                sql,
                mapper,
                filtro, filtro, filtro,
                estadoFiltro, estadoFiltro
        );
    }

    public Map<String, Object> buscarSuscripcion(int id) {
        String sql = """
            SELECT
                S.*,
                C.DNI,
                C.NOMBRE,
                C.APELLIDO,
                C.TELEFONO,
                C.EMAIL,
                COALESCE(P.NOMBRE_PLAN, 'Personalizado') AS NOMBRE_PLAN,
                COALESCE(P.PRECIO_BASE, 0) AS PRECIO_PLAN,
                CASE
                    WHEN S.FECHA_FIN < CURRENT_DATE THEN 'Vencida'
                    WHEN S.FECHA_FIN <= DATEADD('DAY', 7, CURRENT_DATE) THEN 'Por vencer'
                    ELSE 'Vigente'
                END AS ESTADO_SUSCRIPCION
            FROM SUSCRIPCION S
            INNER JOIN CLIENTE C ON C.ID_CLIENTE = S.ID_CLIENTE
            LEFT JOIN PLAN P ON P.ID_PLAN = S.ID_PLAN
            WHERE S.ID_SUSCRIPCION = ?
        """;

        List<Map<String, Object>> resultado = jdbc.query(sql, mapper, id);

        return resultado.isEmpty() ? null : resultado.get(0);
    }

    public List<Map<String, Object>> historialCliente(int idCliente) {
        String sql = """
            SELECT
                S.ID_SUSCRIPCION,
                S.ID_PLAN,
                COALESCE(P.NOMBRE_PLAN, 'Personalizado') AS NOMBRE_PLAN,
                S.DETALLE,
                S.FECHA_INICIO,
                S.FECHA_FIN,
                S.MONTO_TOTAL,
                CASE
                    WHEN S.FECHA_FIN < CURRENT_DATE THEN 'Vencida'
                    WHEN S.FECHA_FIN <= DATEADD('DAY', 7, CURRENT_DATE) THEN 'Por vencer'
                    ELSE 'Vigente'
                END AS ESTADO_SUSCRIPCION
            FROM SUSCRIPCION S
            LEFT JOIN PLAN P ON P.ID_PLAN = S.ID_PLAN
            WHERE S.ID_CLIENTE = ?
            ORDER BY S.FECHA_INICIO DESC
        """;

        return jdbc.query(sql, mapper, idCliente);
    }

    public List<Map<String, Object>> listarPlanesMayores(double precioActual) {
        String sql = """
            SELECT *
            FROM PLAN
            WHERE PRECIO_BASE > ?
            ORDER BY PRECIO_BASE ASC
        """;

        return jdbc.query(sql, mapper, precioActual);
    }

    public List<Map<String, Object>> listarSubproductos() {
        String sql = """
            SELECT ID_SUBPRODUCTO, NOMBRE_SUBPRODUCTO, PRECIO_INDIVIDUAL
            FROM SUBPRODUCTO
            WHERE ESTADO = 'ACTIVO'
            ORDER BY NOMBRE_SUBPRODUCTO
        """;

        return jdbc.query(sql, mapper);
    }

    public List<Integer> listarSubproductosPlan(int idPlan) {
        String sql = """
            SELECT ID_SUBPRODUCTO
            FROM PLAN_SUBPRODUCTO
            WHERE ID_PLAN = ?
        """;

        return jdbc.queryForList(sql, Integer.class, idPlan);
    }

    public List<Map<String, Object>> listarSubproductosActuales(int idSuscripcion) {
        String sql = """
            SELECT DISTINCT
                SP.ID_SUBPRODUCTO,
                SP.NOMBRE_SUBPRODUCTO,
                SP.PRECIO_INDIVIDUAL
            FROM SUSCRIPCION S
            INNER JOIN PLAN_SUBPRODUCTO PS
                ON S.ID_PLAN = PS.ID_PLAN
            INNER JOIN SUBPRODUCTO SP
                ON PS.ID_SUBPRODUCTO = SP.ID_SUBPRODUCTO
            WHERE S.ID_SUSCRIPCION = ?
            ORDER BY SP.NOMBRE_SUBPRODUCTO
        """;

        return jdbc.query(sql, mapper, idSuscripcion);
    }

    public Map<String, Object> buscarSubproducto(int id) {
        String sql = """
            SELECT ID_SUBPRODUCTO, NOMBRE_SUBPRODUCTO, PRECIO_INDIVIDUAL
            FROM SUBPRODUCTO
            WHERE ID_SUBPRODUCTO = ? AND ESTADO = 'ACTIVO'
        """;

        List<Map<String, Object>> resultado = jdbc.query(sql, mapper, id);

        return resultado.isEmpty() ? null : resultado.get(0);
    }

    public Map<String, Object> buscarSubproductoPorNombre(String nombre) {
        String sql = """
            SELECT ID_SUBPRODUCTO, NOMBRE_SUBPRODUCTO, PRECIO_INDIVIDUAL
            FROM SUBPRODUCTO
            WHERE LOWER(TRIM(NOMBRE_SUBPRODUCTO)) = LOWER(TRIM(?))
        """;

        List<Map<String, Object>> resultado = jdbc.query(sql, mapper, nombre);

        return resultado.isEmpty() ? null : resultado.get(0);
    }

    public int insertarRenovacion(int idCliente, Integer idPlan, String detalle,
                                  java.sql.Date fechaInicio, java.sql.Date fechaFin,
                                  double montoTotal) {
        String sql = """
            INSERT INTO SUSCRIPCION
            (ID_CLIENTE, ID_PLAN, DETALLE, FECHA_INICIO, FECHA_FIN, MONTO_TOTAL)
            VALUES (?, ?, ?, ?, ?, ?)
        """;

        return jdbc.update(sql, idCliente, idPlan, detalle,
                fechaInicio, fechaFin, montoTotal);
    }

    public int actualizarMejora(int idSuscripcion, Integer idPlan,
                                String detalle, double montoTotal) {
        String sql = """
            UPDATE SUSCRIPCION
            SET ID_PLAN = ?, DETALLE = ?, MONTO_TOTAL = ?
            WHERE ID_SUSCRIPCION = ?
        """;

        return jdbc.update(sql, idPlan, detalle, montoTotal, idSuscripcion);
    }
}
