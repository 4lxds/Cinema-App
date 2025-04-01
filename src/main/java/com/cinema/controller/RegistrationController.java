package com.cinema.controller;

import com.cinema.model.User;
import com.cinema.repository.UserRepository;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class RegistrationController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private AuthenticationManager authenticationManager;

    @GetMapping("/register")
    public String showRegistrationForm(Model model,
                                       @RequestParam(value = "redirect", required = false) String redirect) {
        model.addAttribute("user", new User());
        model.addAttribute("redirect", redirect);
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(@ModelAttribute("user") User user,
                               @RequestParam(value = "redirect", required = false) String redirect,
                               Model model) {
        //if username is taken
        if (userRepository.findByUsername(user.getUsername()) != null) {
            model.addAttribute("error", "Username already exists!");
            return "register";
        }

        //encode and default role
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRoles("ROLE_USER");
        userRepository.save(user);

        //after registration redirect with param
        if (redirect != null && !redirect.isEmpty()) {
            return "redirect:/login?redirect=" + redirect;
        }
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String showLoginForm() {
        return "login";
    }

    @PostMapping("/login")
    public String performLogin(@RequestParam("username") String username,
                               @RequestParam("password") String password,
                               @RequestParam(value = "redirect", required = false) String redirect,
                               HttpServletRequest request,
                               HttpServletResponse response) {
        try {
            UsernamePasswordAuthenticationToken token =
                    new UsernamePasswordAuthenticationToken(username, password);
            Authentication auth = authenticationManager.authenticate(token);
            //set authentication in SecurityContext
            SecurityContextHolder.getContext().setAuthentication(auth);
            //context in session
            HttpSession session = request.getSession(true);
            session.setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY,
                    SecurityContextHolder.getContext());
            Cookie userCookie = new Cookie("loggedInUser", username);
            userCookie.setPath("/");
            userCookie.setMaxAge(86400); //1 day
            userCookie.setHttpOnly(true);
            response.addCookie(userCookie);

            if (redirect != null && !redirect.isEmpty()) {
                return "redirect:" + redirect;
            }
            //success redirect
            return "redirect:/movies";
        } catch (AuthenticationException ex) {
            //fail redirect
            return "redirect:/login?error";
        }
    }
}