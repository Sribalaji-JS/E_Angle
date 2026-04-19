package com.example.demo.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class AiPrediction {
    @JsonProperty("capacity_kn")
    private double capacityKn;
    
    @JsonProperty("failure_type")
    private String failureType;
}
