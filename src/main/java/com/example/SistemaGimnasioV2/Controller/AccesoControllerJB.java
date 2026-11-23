package com.example.SistemaGimnasioV2.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AccesoControllerJB {

    private static final String USUARIO = "recepcion";
    private static final String CLAVE = "1234";

    @GetMapping("/")
    public String inicio() {
        return "PublicoJB/inicioJB";
    }

    @GetMapping("/contacto")
    public String contacto() {
        return "PublicoJB/contactoJB";
    }

    @GetMapping("/login")
    public String formularioLogin() {
        return "PublicoJB/loginJB";
    }

    @PostMapping("/login")
    public String iniciarSesion(@RequestParam String usuario,
                                @RequestParam String clave,
                                Model model) {
        if (usuario.equals(USUARIO) && clave.equals(CLAVE)) {
            return "redirect:/planes";
        }
        model.addAttribute("error", "Usuario o contraseña incorrectos.");
        return "PublicoJB/loginJB";
    }
}
