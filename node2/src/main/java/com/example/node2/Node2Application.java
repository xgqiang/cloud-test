package com.example.node2;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@SpringBootApplication
public class Node2Application {

    public static void main(String[] args) {
        SpringApplication.run(Node2Application.class, args);
    }

    @Value("${spring.profiles.active}")
    private String env;

    @GetMapping("/node2")
    public String hello() {
        return "hello,node2--" + env;
    }
}
