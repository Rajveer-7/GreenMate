package com.greenmate.greenmate_backend.beans;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Entity
@Builder
@Table(name = "plant_health_records")
public class PlantHealthRecord {
     @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long recordId;

    @ManyToOne
    @JoinColumn(name = "userPlantId", nullable = false)
    private UserPlant userPlant;

    @Column(nullable = false)
    private LocalDate date;

    @Column(name = "health_status", nullable = false)
    private String healthStatus;

    @Column(length = 1024)
    private String notes;  
}
