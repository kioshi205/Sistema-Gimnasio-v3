package com.example.SistemaGimnasioV2.modelJLHA;

import java.time.LocalDate;

/** Datos mínimos de la suscripción vigente de un cliente (INT20). */
public class SuscripcionVigenteJLHA {

    private int idSuscripcion;
    private String detalle;
    private LocalDate fechaFin;

    public int getIdSuscripcion() {
        return idSuscripcion;
    }

    public void setIdSuscripcion(int idSuscripcion) {
        this.idSuscripcion = idSuscripcion;
    }

    public String getDetalle() {
        return detalle;
    }

    public void setDetalle(String detalle) {
        this.detalle = detalle;
    }

    public LocalDate getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(LocalDate fechaFin) {
        this.fechaFin = fechaFin;
    }
}
