package com.example.SistemaGimnasioV2.Service;

import com.example.SistemaGimnasioV2.Repository.GimnasioRepositoryJB;
import com.example.SistemaGimnasioV2.modelJB.ClienteJB;
import com.example.SistemaGimnasioV2.modelJB.CuponJB;
import com.example.SistemaGimnasioV2.modelJB.PlanJB;
import com.example.SistemaGimnasioV2.modelJB.ResumenSuscripcionJB;
import com.example.SistemaGimnasioV2.modelJB.SubproductoJB;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
public class SuscripcionServiceJB {

    private static final int DIAS_PERSONALIZADO = 30;
    private static final int ID_CATEGORIA_ENTRENAMIENTO = 1;
    private static final int MINIMO_SUBPRODUCTOS_DESCUENTO = 5;
    private static final BigDecimal PORCENTAJE_PERSONALIZADO = new BigDecimal("0.15");
    private static final BigDecimal PORCENTAJE_REFERIDO = new BigDecimal("0.50");

    private final GimnasioRepositoryJB repo;

    public SuscripcionServiceJB(GimnasioRepositoryJB repo) {
        this.repo = repo;
    }

    public List<PlanJB> listarPlanes() {
        return repo.listarPlanes();
    }

    public List<SubproductoJB> listarSubproductos() {
        return repo.listarSubproductos();
    }

    public List<SubproductoJB> buscarSubproductos(List<Integer> ids) {
        return repo.buscarSubproductos(ids);
    }

    public boolean planDisponible(int idPlan) {
        List<String> inactivos = repo.listarServiciosInactivosPorPlan(idPlan);
        return inactivos.isEmpty();
    }

    public boolean seleccionValida(Integer idPlan, List<Integer> ids) {
        if (idPlan != null) {
            return planDisponible(idPlan);
        }
        return ids != null && !ids.isEmpty();
    }

    
    public boolean tieneZonaEntrenamiento(List<SubproductoJB> subproductos) {
        for (SubproductoJB s : subproductos) {
            if (s.getIdCategoria() != null && s.getIdCategoria() == ID_CATEGORIA_ENTRENAMIENTO) {
                return true;
            }
        }
        return false;
    }


    public BigDecimal subtotal(List<SubproductoJB> subproductos) {
        BigDecimal suma = BigDecimal.ZERO;
        for (SubproductoJB s : subproductos) {
            suma = suma.add(s.getPrecioIndividual());
        }
        return suma;
    }


    public BigDecimal descuentoPersonalizado(List<SubproductoJB> subproductos) {
        if (subproductos.size() >= MINIMO_SUBPRODUCTOS_DESCUENTO) {
            BigDecimal suma = subtotal(subproductos);
            return suma.multiply(PORCENTAJE_PERSONALIZADO).setScale(2, RoundingMode.HALF_UP);
        }
        return BigDecimal.ZERO;
    }


    public BigDecimal total(List<SubproductoJB> subproductos) {
        BigDecimal suma = subtotal(subproductos);
        BigDecimal descuento = descuentoPersonalizado(subproductos);
        return suma.subtract(descuento);
    }

    public List<String> validarCliente(ClienteJB c) {
        c.setDni(texto(c.getDni()));
        c.setNombre(texto(c.getNombre()));
        c.setApellido(texto(c.getApellido()));
        c.setTelefono(texto(c.getTelefono()));
        c.setEmail(texto(c.getEmail()));

        List<String> errores = new ArrayList<>();
        if (!c.getDni().matches("\\d{8}")) {
            errores.add("El DNI debe tener 8 dígitos.");
        } else if (repo.buscarClientePorDni(c.getDni()) == null) {
            if (c.getNombre().isEmpty()) {
                errores.add("El nombre es obligatorio.");
            }
            if (c.getApellido().isEmpty()) {
                errores.add("El apellido es obligatorio.");
            }
            if (!c.getTelefono().isEmpty() && !c.getTelefono().matches("\\d{9}")) {
                errores.add("El teléfono debe tener 9 dígitos.");
            }
            if (!c.getEmail().isEmpty() && repo.existeEmail(c.getEmail())) {
                errores.add("Ese correo ya está registrado.");
            }
        }
        return errores;
    }

    public int guardarCliente(ClienteJB c) {
        ClienteJB existente = repo.buscarClientePorDni(c.getDni());
        if (existente != null) {
            return existente.getIdCliente();
        }
        if (c.getTelefono().isEmpty()) {
            c.setTelefono(null);
        }
        if (c.getEmail().isEmpty()) {
            c.setEmail(null);
        }
        return repo.insertarCliente(c);
    }

    public ResumenSuscripcionJB armarResumen(Integer idPlan, List<Integer> ids, int idCliente,
                                             String codigoCupon, String dniReferente) {
        ResumenSuscripcionJB resumen = new ResumenSuscripcionJB();
        int dias;
        BigDecimal subtotalPlan;
        BigDecimal descuentoPers = BigDecimal.ZERO;

        if (idPlan != null) {
            PlanJB plan = repo.buscarPlan(idPlan);
            resumen.setNombrePlan(plan.getNombrePlan());
            resumen.setDetalle(String.join(";", plan.getIncluye()));
            subtotalPlan = plan.getPrecioBase();
            dias = plan.getDuracionDias();
        } else {
            List<SubproductoJB> subproductos = repo.buscarSubproductos(ids);
            List<String> nombres = new ArrayList<>();
            for (SubproductoJB s : subproductos) {
                nombres.add(s.getNombreSubproducto());
            }
            resumen.setNombrePlan("Personalizado");
            resumen.setDetalle(String.join(";", nombres));
            subtotalPlan = subtotal(subproductos);
            descuentoPers = descuentoPersonalizado(subproductos);
            dias = DIAS_PERSONALIZADO;
        }

        LocalDate hoy = LocalDate.now();
        resumen.setCliente(repo.buscarCliente(idCliente));
        resumen.setFechaInicio(hoy);
        resumen.setFechaFin(hoy.plusDays(dias));
        resumen.setFechaFinVigente(repo.fechaFinVigente(idCliente, hoy));
        resumen.setSubtotal(subtotalPlan);
        resumen.setDescuentoPersonalizado(descuentoPers);
        resumen.setDescuentoPromocion(BigDecimal.ZERO);

        BigDecimal montoBase = subtotalPlan.subtract(descuentoPers);


        aplicarPromocion(resumen, idCliente, montoBase, hoy, codigoCupon, dniReferente);

        return resumen;
    }

    private void aplicarPromocion(ResumenSuscripcionJB resumen, int idCliente, BigDecimal montoBase,
                                  LocalDate hoy, String codigoCupon, String dniReferente) {
        String cuponLimpio = texto(codigoCupon);
        String dniRefLimpio = texto(dniReferente);


        if (!cuponLimpio.isEmpty() && !dniRefLimpio.isEmpty()) {
            resumen.setMensajePromocion("No se puede combinar un cupón promocional con el descuento por referido. Ingresa solo uno.");
            resumen.setMontoTotal(montoBase);
            return;
        }


        if (!cuponLimpio.isEmpty()) {
            CuponJB cupon = repo.buscarCuponPorCodigo(cuponLimpio);

            if (cupon == null) {
                resumen.setMensajePromocion("El cupón ingresado no existe. Se mantiene el precio normal.");
                resumen.setMontoTotal(montoBase);
                return;
            }
            if (!"ACTIVO".equals(cupon.getEstado())) {
                resumen.setMensajePromocion("El cupón se encuentra inactivo. Se mantiene el precio normal.");
                resumen.setMontoTotal(montoBase);
                return;
            }
            if (hoy.isBefore(cupon.getFechaInicio()) || hoy.isAfter(cupon.getFechaFin())) {
                resumen.setMensajePromocion("El cupón está vencido o fuera de vigencia. Se mantiene el precio normal.");
                resumen.setMontoTotal(montoBase);
                return;
            }
            if (repo.cuponYaFueUsado(cupon.getIdCupon())) {
                resumen.setMensajePromocion("Ese cupón ya fue utilizado en otra suscripción. Se mantiene el precio normal.");
                resumen.setMontoTotal(montoBase);
                return;
            }

            BigDecimal porcentaje = new BigDecimal(cupon.getPorcentajeDescuento())
                    .divide(new BigDecimal("100"), 4, RoundingMode.HALF_UP);
            BigDecimal descuento = montoBase.multiply(porcentaje).setScale(2, RoundingMode.HALF_UP);

            resumen.setIdCuponAplicado(cupon.getIdCupon());
            resumen.setDescuentoPromocion(descuento);
            resumen.setNombrePromocion("Cupón " + cupon.getCodigo() + " (" + cupon.getPorcentajeDescuento() + "%)");
            resumen.setMontoTotal(montoBase.subtract(descuento));
            return;
        }


        if (!dniRefLimpio.isEmpty()) {
            if (repo.contarSuscripcionesCliente(idCliente) > 0) {
                resumen.setMensajePromocion("El descuento por referido aplica solo para clientes nuevos sin suscripciones previas.");
                resumen.setMontoTotal(montoBase);
                return;
            }
            if (!dniRefLimpio.matches("\\d{8}")) {
                resumen.setMensajePromocion("El DNI del socio referente debe tener 8 dígitos.");
                resumen.setMontoTotal(montoBase);
                return;
            }

            ClienteJB referente = repo.buscarClientePorDni(dniRefLimpio);
            if (referente == null) {
                resumen.setMensajePromocion("El DNI del socio referente no está registrado.");
                resumen.setMontoTotal(montoBase);
                return;
            }
            if (referente.getIdCliente().equals(idCliente)) {
                resumen.setMensajePromocion("Un cliente no puede referirse a sí mismo.");
                resumen.setMontoTotal(montoBase);
                return;
            }
            if (repo.fechaFinVigente(referente.getIdCliente(), hoy) == null) {
                resumen.setMensajePromocion("El socio referente no cuenta con una suscripción vigente.");
                resumen.setMontoTotal(montoBase);
                return;
            }

            BigDecimal descuento = montoBase.multiply(PORCENTAJE_REFERIDO).setScale(2, RoundingMode.HALF_UP);

            resumen.setDescuentoPromocion(descuento);
            resumen.setNombrePromocion("Referido por " + referente.getNombre() + " " + referente.getApellido() + " (50%)");
            resumen.setMontoTotal(montoBase.subtract(descuento));
            return;
        }


        resumen.setMontoTotal(montoBase);
    }

    public int confirmar(Integer idPlan, List<Integer> ids, int idCliente,
                         String codigoCupon, String dniReferente) {
        ResumenSuscripcionJB resumen = armarResumen(idPlan, ids, idCliente, codigoCupon, dniReferente);
        return repo.insertarSuscripcion(
                idCliente,
                idPlan,
                resumen.getIdCuponAplicado(),
                resumen.getDetalle(),
                resumen.getFechaInicio(),
                resumen.getFechaFin(),
                resumen.getMontoTotal()
        );
    }

    public boolean tieneSuscripcionVigente(int idCliente) {
        return repo.fechaFinVigente(idCliente, LocalDate.now()) != null;
    }

    private String texto(String valor) {
        if (valor == null) {
            return "";
        }
        return valor.trim();
    }
}