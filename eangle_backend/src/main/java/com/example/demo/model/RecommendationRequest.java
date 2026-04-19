package com.example.demo.model;

import lombok.Data;

@Data
public class RecommendationRequest {
    private double targetCapacity;
    private int bolts;
    private int rows; // corresponds to nr
}
