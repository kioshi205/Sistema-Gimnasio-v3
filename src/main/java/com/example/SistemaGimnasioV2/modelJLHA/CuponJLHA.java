package com.example.SistemaGimnasioV2.modelJLHA;

import com.example.SistemaGimnasioV2.modelJB.CuponJB;

import java.time.LocalDate;

/**
 * Cupón de INT21: reutiliza CuponJB (tabla CUPON) y añade cuántas veces fue canjeado,
 * para mostrar si sigue disponible según RN01 (activo, vigente y no utilizado).
 */
public class CuponJLHA extends CuponJB {

    private int usos;

    public int getUsos() {
        return usos;
    }

    public void setUsos(int usos) {
        this.usos = usos;
    }

    /** Situación del cupón hoy: DISPONIBLE, USADO, VENCIDO, POR INICIAR o INACTIVO. */
    public String getSituacion() {
        LocalDate hoy = LocalDate.now();
        if (!"ACTIVO".equals(getEstado())) {
            return "INACTIVO";
        }
        if (usos > 0) {
            return "USADO";
        }
        if (hoy.isAfter(getFechaFin())) {
            return "VENCIDO";
        }
        if (hoy.isBefore(getFechaInicio())) {
            return "POR INICIAR";
        }
        return "DISPONIBLE";
    }
}
