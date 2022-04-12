package com.example.node1;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@SpringBootApplication
public class Node1Application {

    public static void main(String[] args) {
        SpringApplication.run(Node1Application.class, args);
    }

    @Value("${spring.profiles.active}")
    private String env;

    @GetMapping("/node1")
    public String hello() {
        return "hello,node1--" + env;
    }
}
