package com.example.demo.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RecommendationResponse {

    @JsonProperty("recommended_section")
    private String recommendedSection;

    @JsonProperty("recommended_capacity")
    private double recommendedCapacity;

    @JsonProperty("alternative_section")
    private String alternativeSection;

    @JsonProperty("alternative_capacity")
    private double alternativeCapacity;

    @JsonProperty("accuracy")
    private String accuracy;

    @JsonProperty("t")
    private double t;

    @JsonProperty("n")
    private int n;

    @JsonProperty("nr")
    private int nr;

    @JsonProperty("d")
    private double d;

    @JsonProperty("dh")
    private double dh;

    @JsonProperty("p")
    private double p;

    @JsonProperty("e")
    private double e;

    @JsonProperty("failure_mode")
    private String failureMode;

    @JsonProperty("A")
    private double A;

    @JsonProperty("B")
    private double B;

    @JsonProperty("alternatives")
    private java.util.List<AngleData> alternatives;
}
