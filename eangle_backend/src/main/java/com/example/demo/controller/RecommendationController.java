package com.example.demo.controller;

import com.example.demo.model.AngleData;
import com.example.demo.model.RecommendationRequest;
import com.example.demo.model.RecommendationResponse;
import com.example.demo.service.DataService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class RecommendationController {

    private final DataService dataService;

    public RecommendationController(DataService dataService) {
        this.dataService = dataService;
    }

    /**
     * POST /api/recommend
     *
     * Request body:
     * {
     *   "targetCapacity": 350,
     *   "bolts": 4,
     *   "rows": 1
     * }
     *
     * Response:
     * {
     *   "recommended_section": "ISA 100100",
     *   "recommended_capacity": 362.0,
     *   "alternative_section": "ISA 110110",
     *   "alternative_capacity": 401.0,
     *   "accuracy": "High (95%)"
     * }
     */
    @PostMapping("/recommend")
    public ResponseEntity<RecommendationResponse> recommend(@RequestBody RecommendationRequest req) {

        // Step 1: Find the most economical (smallest) qualifying section
        AngleData recommended = dataService.findRecommended(
                req.getTargetCapacity(), req.getBolts(), req.getRows());

        if (recommended == null) {
            return ResponseEntity.notFound().build();
        }

        // Step 2: Find alternatives (next steps up from recommended)
        java.util.List<AngleData> alternatives = dataService.findAlternatives(
                req.getTargetCapacity(), req.getBolts(), req.getRows(), recommended, 5);

        // Step 3: Compute accuracy rating
        String accuracy = dataService.calculateAccuracy(req.getTargetCapacity(), recommended);

        // Step 4: Build strict 5-field response
        RecommendationResponse response = RecommendationResponse.builder()
                .recommendedSection(recommended.getDesignation())
                .recommendedCapacity(recommended.getCapacity())
                .alternativeSection(!alternatives.isEmpty() ? alternatives.get(0).getDesignation() : "N/A")
                .alternativeCapacity(!alternatives.isEmpty() ? alternatives.get(0).getCapacity() : 0.0)
                .accuracy(accuracy)
                .t(recommended.getT())
                .n(recommended.getN())
                .nr(recommended.getNr())
                .d(recommended.getD())
                .dh(recommended.getDh())
                .p(recommended.getP())
                .e(recommended.getE())
                .failureMode(recommended.getFailure())
                .A(recommended.getA())
                .B(recommended.getB())
                .alternatives(alternatives)
                .build();

        return ResponseEntity.ok(response);
    }
}
