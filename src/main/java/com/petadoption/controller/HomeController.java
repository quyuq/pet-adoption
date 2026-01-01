package com.petadoption.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import com.petadoption.entity.User;
import javax.servlet.http.HttpSession;

@Controller
public class HomeController {

    @Autowired
    private com.petadoption.service.PetService petService;

    @GetMapping(value = { "/", "/index" })
    public String index(org.springframework.ui.Model model) {
        // Fetch latest 6 available pets for the homepage
        // species=null, status=0(Available), keyword=null, page=1, size=6
        java.util.List<com.petadoption.entity.Pet> featuredPets = petService.getPetsByPage(null,
                com.petadoption.entity.Pet.STATUS_AVAILABLE, null, 1, 6);
        model.addAttribute("featuredPets", featuredPets);
        return "index";
    }
}
