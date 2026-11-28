package com.example.SistemaGimnasioV2.modelJLHA;

import java.io.Serializable;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;


public class AccesoResultadoJLHA implements Serializable {

    public static final String PERMITIDO = "PERMITIDO";
    public static final String DENEGADO = "DENEGADO";
    public static final String NO_REGISTRADO = "NO_REGISTRADO";
    public static final String DNI_INVALIDO = "DNI_INVALIDO";

    private String estado;
    private String dni;
    private String nombreCompleto;
    private long diasRestantes;
    private LocalDate fechaFin;
    private List<String> servicios = new ArrayList<>();
    private String mensaje;

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
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

    public long getDiasRestantes() {
        return diasRestantes;
    }

    public void setDiasRestantes(long diasRestantes) {
        this.diasRestantes = diasRestantes;
    }

    public LocalDate getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(LocalDate fechaFin) {
        this.fechaFin = fechaFin;
    }

    public List<String> getServicios() {
        return servicios;
    }

    public void setServicios(List<String> servicios) {
        this.servicios = servicios;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }
}
