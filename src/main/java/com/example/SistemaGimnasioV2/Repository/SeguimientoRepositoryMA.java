
package com.example.SistemaGimnasioV2.Repository;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.*;

@Repository
public class SeguimientoRepositoryMA {

    private final JdbcTemplate jdbc;

    public SeguimientoRepositoryMA(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    private final RowMapper<Map<String, Object>> mapper = (rs, rowNum) -> {
        Map<String, Object> datos = new LinkedHashMap<>();

        for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
            datos.put(rs.getMetaData().getColumnLabel(i).toUpperCase(), rs.getObject(i));
        }

        return datos;
    };

    public List<Map<String, Object>> listarClientes(String buscar) {
        String texto = buscar == null ? "" : buscar.trim();

        return jdbc.query("""
            SELECT *
            FROM CLIENTE
            WHERE ? = ''
               OR LOWER(DNI) LIKE LOWER(?)
               OR LOWER(NOMBRE) LIKE LOWER(?)
               OR LOWER(APELLIDO) LIKE LOWER(?)
            ORDER BY ID_CLIENTE
            """,
                mapper,
                texto,
                "%" + texto + "%",
                "%" + texto + "%",
                "%" + texto + "%"
        );
    }

    public Map<String, Object> buscarCliente(int id) {
        List<Map<String, Object>> lista = jdbc.query(
                "SELECT * FROM CLIENTE WHERE ID_CLIENTE = ?",
                mapper,
                id
        );

        return lista.isEmpty() ? null : lista.get(0);
    }

    public int actualizarCliente(
            int id,
            String dni,
            String nombre,
            String apellido,
            String telefono,
            String email) {

        return jdbc.update("""
            UPDATE CLIENTE
            SET DNI = ?,
                NOMBRE = ?,
                APELLIDO = ?,
                TELEFONO = ?,
                EMAIL = ?
            WHERE ID_CLIENTE = ?
            """,
                dni, nombre, apellido, telefono, email, id
        );
    }

    public boolean existeDni(String dni, int id) {
        Integer cantidad = jdbc.queryForObject("""
            SELECT COUNT(*)
            FROM CLIENTE
            WHERE DNI = ? AND ID_CLIENTE <> ?
            """,
                Integer.class,
                dni, id
        );

        return cantidad != null && cantidad > 0;
    }

    public boolean existeEmail(String email, int id) {
        if (email == null || email.isBlank()) {
            return false;
        }

        Integer cantidad = jdbc.queryForObject("""
            SELECT COUNT(*)
            FROM CLIENTE
            WHERE EMAIL = ? AND ID_CLIENTE <> ?
            """,
                Integer.class,
                email, id
        );

        return cantidad != null && cantidad > 0;
    }

    public List<Map<String, Object>> listarSuscripciones(String buscar, String estado) {
        String texto = buscar == null ? "" : buscar.trim();
        String filtroEstado = estado == null ? "" : estado.trim();

        return jdbc.query("""
            SELECT S.ID_SUSCRIPCION,
                   S.ID_CLIENTE,
                   C.DNI,
                   C.NOMBRE,
                   C.APELLIDO,
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
            INNER JOIN CLIENTE C ON C.ID_CLIENTE = S.ID_CLIENTE
            LEFT JOIN PLAN P ON P.ID_PLAN = S.ID_PLAN
            WHERE (
                ? = ''
                OR LOWER(C.DNI) LIKE LOWER(?)
                OR LOWER(C.NOMBRE) LIKE LOWER(?)
                OR LOWER(C.APELLIDO) LIKE LOWER(?)
                OR CAST(S.ID_SUSCRIPCION AS VARCHAR) LIKE ?
            )
            AND (
                ? = ''
                OR CASE
                    WHEN S.FECHA_FIN < CURRENT_DATE THEN 'Vencida'
                    WHEN S.FECHA_FIN <= DATEADD('DAY', 7, CURRENT_DATE) THEN 'Por vencer'
                    ELSE 'Vigente'
                END = ?
            )
            ORDER BY S.ID_SUSCRIPCION DESC
            """,
                mapper,
                texto,
                "%" + texto + "%",
                "%" + texto + "%",
                "%" + texto + "%",
                "%" + texto + "%",
                filtroEstado,
                filtroEstado
        );
    }

    public Map<String, Object> buscarSuscripcion(int id) {
        List<Map<String, Object>> lista = jdbc.query("""
            SELECT S.*,
                   C.DNI,
                   C.NOMBRE,
                   C.APELLIDO,
                   C.TELEFONO,
                   C.EMAIL,
                   COALESCE(P.NOMBRE_PLAN, 'Personalizado') AS NOMBRE_PLAN,
                   COALESCE(P.DURACION_DIAS, 30) AS DURACION_DIAS,
                   CASE
                       WHEN S.FECHA_FIN < CURRENT_DATE THEN 'Vencida'
                       WHEN S.FECHA_FIN <= DATEADD('DAY', 7, CURRENT_DATE) THEN 'Por vencer'
                       ELSE 'Vigente'
                   END AS ESTADO_SUSCRIPCION
            FROM SUSCRIPCION S
            INNER JOIN CLIENTE C ON C.ID_CLIENTE = S.ID_CLIENTE
            LEFT JOIN PLAN P ON P.ID_PLAN = S.ID_PLAN
            WHERE S.ID_SUSCRIPCION = ?
            """,
                mapper,
                id
        );

        return lista.isEmpty() ? null : lista.get(0);
    }

    public List<Map<String, Object>> historialCliente(int idCliente) {
        return jdbc.query("""
            SELECT S.ID_SUSCRIPCION,
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
            """,
                mapper,
                idCliente
        );
    }

    public List<Map<String, Object>> listarPlanesMayores(double monto) {
        return jdbc.query("""
            SELECT *
            FROM PLAN
            WHERE PRECIO_BASE > ?
            ORDER BY PRECIO_BASE ASC
            """,
                mapper,
                monto
        );
    }

    public List<Map<String, Object>> listarSubproductos() {
        return jdbc.query("""
            SELECT S.ID_SUBPRODUCTO,
                   S.NOMBRE_SUBPRODUCTO,
                   S.PRECIO_INDIVIDUAL,
                   S.ESTADO,
                   C.NOMBRE_CATEGORIA
            FROM SUBPRODUCTO S
            INNER JOIN CATEGORIA C ON C.ID_CATEGORIA = S.ID_CATEGORIA
            WHERE S.ESTADO = 'ACTIVO'
            ORDER BY C.NOMBRE_CATEGORIA, S.NOMBRE_SUBPRODUCTO
            """,
                mapper
        );
    }

    public List<Map<String, Object>> listarSubproductosPlan(int idPlan) {
        return jdbc.query("""
            SELECT S.ID_SUBPRODUCTO,
                   S.NOMBRE_SUBPRODUCTO,
                   S.PRECIO_INDIVIDUAL
            FROM PLAN_SUBPRODUCTO PS
            INNER JOIN SUBPRODUCTO S ON S.ID_SUBPRODUCTO = PS.ID_SUBPRODUCTO
            WHERE PS.ID_PLAN = ?
            ORDER BY S.NOMBRE_SUBPRODUCTO
            """,
                mapper,
                idPlan
        );
    }

    public Map<String, Object> buscarSubproductoPorNombre(String nombre) {
        List<Map<String, Object>> lista = jdbc.query("""
            SELECT ID_SUBPRODUCTO,
                   NOMBRE_SUBPRODUCTO,
                   PRECIO_INDIVIDUAL
            FROM SUBPRODUCTO
            WHERE LOWER(NOMBRE_SUBPRODUCTO) = LOWER(?)
              AND ESTADO = 'ACTIVO'
            """,
                mapper,
                nombre.trim()
        );

        return lista.isEmpty() ? null : lista.get(0);
    }

    public int actualizarRenovacion(int idSuscripcion, java.sql.Date inicio, java.sql.Date fin) {
        return jdbc.update("""
            UPDATE SUSCRIPCION
            SET FECHA_INICIO = ?,
                FECHA_FIN = ?
            WHERE ID_SUSCRIPCION = ?
            """,
                inicio, fin, idSuscripcion
        );
    }

    public int actualizarMejora(int idSuscripcion, int idPlan, String detalle, double monto) {
        return jdbc.update("""
            UPDATE SUSCRIPCION
            SET ID_PLAN = ?,
                DETALLE = ?,
                MONTO_TOTAL = ?
            WHERE ID_SUSCRIPCION = ?
            """,
                idPlan, detalle, monto, idSuscripcion
        );
    }
}
