package com.example.SistemaGimnasioV2.modelJLHA;

import java.time.LocalDate;
import java.time.LocalTime;

/** Fila de la tabla MARCACION_ACCESO con el nombre del socio, para el historial de INT20. */
public class MarcacionAccesoJLHA {

    private int idAcceso;
    private String dni;
    private String nombreCompleto;
    private LocalDate fechaAcceso;
    private LocalTime horaAcceso;
    private String resultado;

    public int getIdAcceso() {
        return idAcceso;
    }

    public void setIdAcceso(int idAcceso) {
        this.idAcceso = idAcceso;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public LocalDate getFechaAcceso() {
        return fechaAcceso;
    }

    public void setFechaAcceso(LocalDate fechaAcceso) {
        this.fechaAcceso = fechaAcceso;
    }

    public LocalTime getHoraAcceso() {
        return horaAcceso;
    }

    public void setHoraAcceso(LocalTime horaAcceso) {
        this.horaAcceso = horaAcceso;
    }

    public String getResultado() {
        return resultado;
    }

    public void setResultado(String resultado) {
        this.resultado = resultado;
    }
}
