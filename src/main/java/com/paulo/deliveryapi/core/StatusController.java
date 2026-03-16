package com.paulo.deliveryapi.core;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class StatusController {

    @GetMapping("/status")
    public Map<String, Object> getStatus() {
        Map<String, Object> status = new HashMap<>();
        status.put("api_nome", "Delivery API White-label");
        status.put("status", "ONLINE");
        status.put("versao", "1.0.0");
        status.put("data_hora", LocalDateTime.now());

        return status; // O Spring converte esse Map automaticamente para JSON
    }
}