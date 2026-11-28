package com.example.SistemaGimnasioV2.modelJLHA;

import com.example.SistemaGimnasioV2.modelJB.CuponJB;

import java.time.LocalDate;


public class CuponJLHA extends CuponJB {

    private int usos;

    public int getUsos() {
        return usos;
    }

    public void setUsos(int usos) {
        this.usos = usos;
    }


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
