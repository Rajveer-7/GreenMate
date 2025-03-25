package com.greenmate.greenmate_backend.controllers;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController{
@GetMapping("/")
public String goHome(){
    return "home.html";
}

}