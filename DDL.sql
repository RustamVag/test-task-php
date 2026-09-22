CREATE TABLE cities (
    id   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cities_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE routes (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    number              VARCHAR(20) NOT NULL,
    departure_city_id   BIGINT UNSIGNED NOT NULL,
    destination_city_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_routes_number (number),
    KEY idx_routes_departure_city (departure_city_id),
    KEY idx_routes_destination_city (destination_city_id),
    CONSTRAINT fk_routes_departure
        FOREIGN KEY (departure_city_id) REFERENCES cities(id),
    CONSTRAINT fk_routes_destination
        FOREIGN KEY (destination_city_id) REFERENCES cities(id),
    CONSTRAINT chk_routes_cities
        CHECK (departure_city_id <> destination_city_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE buses (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    route_id            BIGINT UNSIGNED NOT NULL,
    model               VARCHAR(100) NOT NULL,
    registration_number VARCHAR(20) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_buses_registration_number (registration_number),
    KEY idx_buses_route_id (route_id),
    CONSTRAINT fk_buses_route
        FOREIGN KEY (route_id) REFERENCES routes(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE route_stops (
    id                   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    route_id             BIGINT UNSIGNED NOT NULL,
    city_id              BIGINT UNSIGNED NOT NULL,
    expected_travel_time TIME NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_route_stops_route_city (route_id, city_id),
    KEY idx_route_stops_city (city_id, route_id),
    CONSTRAINT fk_route_stops_route
        FOREIGN KEY (route_id) REFERENCES routes(id) ON DELETE CASCADE,
    CONSTRAINT fk_route_stops_city
        FOREIGN KEY (city_id) REFERENCES cities(id),
    CONSTRAINT chk_route_stops_travel_time
        CHECK (expected_travel_time >= '00:00:00')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE bus_schedules (
    id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    route_id       BIGINT UNSIGNED NOT NULL,
    departure_date DATETIME NOT NULL,
    arrival_date   DATETIME NOT NULL,
    bus_id         BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_bus_schedules_bus_departure (bus_id, departure_date),
    KEY idx_bus_schedules_route_departure (route_id, departure_date),
    CONSTRAINT fk_bus_schedules_route
        FOREIGN KEY (route_id) REFERENCES routes(id),
    CONSTRAINT fk_bus_schedules_bus
        FOREIGN KEY (bus_id) REFERENCES buses(id),
    CONSTRAINT chk_bus_schedules_dates
        CHECK (arrival_date >= departure_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE bus_schedule_stops (
    id                    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    city_id               BIGINT UNSIGNED NOT NULL,
    bus_schedule_id       BIGINT UNSIGNED NOT NULL,
    expected_arrival_time DATETIME NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_bss_schedule_city (bus_schedule_id, city_id),
    KEY idx_bss_city_arrival (city_id, expected_arrival_time, bus_schedule_id),
    CONSTRAINT fk_bss_city
        FOREIGN KEY (city_id) REFERENCES cities(id),
    CONSTRAINT fk_bss_schedule
        FOREIGN KEY (bus_schedule_id) REFERENCES bus_schedules(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;