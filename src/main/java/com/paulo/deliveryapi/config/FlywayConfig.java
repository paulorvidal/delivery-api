package com.paulo.deliveryapi.config;

import javax.sql.DataSource;

import org.flywaydb.core.Flyway;
import org.springframework.context.annotation.Configuration;

import jakarta.annotation.PostConstruct;

@Configuration
public class FlywayConfig {

    private final DataSource dataSource;

    public FlywayConfig(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @PostConstruct
    public void migrate() {
        Flyway flyway = Flyway.configure()
                .dataSource(dataSource)
                .locations("classpath:db/migration") // Aponta para a pasta certa
                .baselineOnMigrate(true) // Cria a tabela de histórico se não existir
                .outOfOrder(true) // Evita erros se você renomear as V1, V2 fora de ordem
                .load();

        flyway.migrate();
    }
}