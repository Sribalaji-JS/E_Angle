package com.example.demo.service;

import com.example.demo.model.AiPrediction;
import com.example.demo.model.AngleData;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Service
public class AiClient {

    private final RestTemplate restTemplate = new RestTemplate();

    @Value("${ai.server.url:http://localhost:5000/predict}")
    private String AI_URL;

    public AiPrediction predict(AngleData data) {
        Map<String, Object> request = new HashMap<>();
        request.put("A", data.getA());
        request.put("B", data.getB());
        request.put("t", data.getT());
        request.put("n", data.getN());
        request.put("d", data.getD());
        request.put("dh", data.getDh());
        request.put("p", data.getP());
        request.put("e", data.getE());
        request.put("Nr", data.getNr());

        try {
            return restTemplate.postForObject(AI_URL, request, AiPrediction.class);
        } catch (Exception ex) {
            System.err.println("AI Prediction failed: " + ex.getMessage());
            return null;
        }
    }
}
