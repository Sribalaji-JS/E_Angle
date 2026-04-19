package com.example.demo.service;

import com.example.demo.model.AngleData;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.*;
// import java.util.stream.Collectors;

@Service
public class DataService {

    private final List<AngleData> angleDataList = new ArrayList<>();

    // ── Dataset Loading ───────────────────────────────────────────────────────
    @PostConstruct
    public void init() {
        try (var is = getClass().getResourceAsStream("/EAngle_data.csv");
                var br = new BufferedReader(
                        new InputStreamReader(Objects.requireNonNull(is), StandardCharsets.UTF_8))) {

            // Skip header row
            String line = br.readLine();
            while ((line = br.readLine()) != null) {
                String[] v = line.split(",");
                if (v.length < 12)
                    continue;

                AngleData a = new AngleData();
                a.setDesignation(v[0].trim());
                a.setA(Double.parseDouble(v[1].trim()));
                a.setB(Double.parseDouble(v[2].trim()));
                a.setT(Double.parseDouble(v[3].trim()));
                a.setN(Integer.parseInt(v[4].trim()));
                a.setD(Double.parseDouble(v[5].trim()));
                a.setDh(Double.parseDouble(v[6].trim()));
                a.setP(Double.parseDouble(v[7].trim()));
                a.setE(Double.parseDouble(v[8].trim()));
                a.setCapacity(Double.parseDouble(v[9].trim()));
                a.setFailure(v[10].trim());
                a.setNr(Integer.parseInt(v[11].trim()));

                angleDataList.add(a);
            }
        } catch (Exception e) {
            System.err.println("Failed to load dataset: " + e.getMessage());
        }
    }

    // ── Recommendation Logic ─────────────────────────────────────────────────

    /**
     * Returns the MOST ECONOMICAL section that satisfies the given constraints.
     *
     * Selection criteria (in order):
     * 1. capacity >= targetCapacity
     * 2. n == bolts
     * 3. nr == rows (0 means "any")
     * 4. Among all qualifying rows → pick the one with the SMALLEST cross-section
     * area proxy: (A + B - t) * t (minimises material weight)
     * Tie-break: lowest capacity (closest to target → most economical)
     */
    public AngleData findRecommended(double targetCapacity, int bolts, int nr) {
        return candidateStream(targetCapacity, bolts, nr)
                .min(Comparator.comparingDouble(AngleData::getCapacity))
                .orElse(null);
    }

    /**
     * Returns ONE alternative section:
     * - Same bolt count and row arrangement as the recommended section
     * - capacity >= targetCapacity (still safe)
     * - Different row entry from the recommended (different record)
     * - Closest next option above the recommended by cross-section area proxy
     * (i.e. "next step up" from the recommended section in terms of material)
     */
    public AngleData findAlternative(double targetCapacity, int bolts, int nr, AngleData recommended) {
        List<AngleData> alternatives = findAlternatives(targetCapacity, bolts, nr, recommended, 1);
        return alternatives.isEmpty() ? null : alternatives.get(0);
    }

    /**
     * Returns a LIST of alternative sections:
     * - Same bolt count and row arrangement as the recommended section
     * - capacity >= targetCapacity (still safe)
     * - Different row entry from the recommended (different record)
     * - Closest next options above the recommended by cross-section area proxy
     */
    public List<AngleData> findAlternatives(double targetCapacity, int bolts, int nr, AngleData recommended, int limit) {
        if (recommended == null)
            return Collections.emptyList();

        double marginCap = recommended.getCapacity() * 0.5; // Increased margin to find more alternatives

        return candidateStream(targetCapacity, bolts, nr)
                .filter(a -> !a.getDesignation().equals(recommended.getDesignation()))
                .filter(a -> a.getCapacity() >= recommended.getCapacity() - 5)
                .filter(a -> a.getCapacity() <= recommended.getCapacity() + marginCap)
                .sorted(Comparator.comparingDouble(AngleData::getCapacity))
                .limit(limit)
                .toList();
    }

    // ── Accuracy Calculation ─────────────────────────────────────────────────

    /**
     * Accuracy is determined by how close the recommended section's capacity
     * is to the required target capacity (relative surplus).
     *
     * surplus% = (recommended.capacity - target) / target * 100
     *
     * 0–10% → High (95%) – very close match, minimal overdesign
     * 10–25% → Medium (80%) – moderate surplus
     * >25% → Low (65%) – significant overdesign; consider iterating
     */
    public String calculateAccuracy(double targetCapacity, AngleData recommended) {
        if (recommended == null)
            return "N/A";

        double surplus = ((recommended.getCapacity() - targetCapacity) / targetCapacity) * 100.0;

        if (surplus <= 10.0) {
            return "High (95%)";
        } else if (surplus <= 25.0) {
            return "Medium (80%)";
        } else {
            return "Low (65%)";
        }
    }

    // ── Private Helpers ──────────────────────────────────────────────────────

    private java.util.stream.Stream<AngleData> candidateStream(double targetCapacity, int bolts, int nr) {
        return angleDataList.stream()
                .filter(a -> a.getCapacity() >= targetCapacity)
                .filter(a -> a.getN() == bolts)
                .filter(a -> {
                    if (nr == 0) return true;
                    if (!isLargeSection(a.getDesignation())) return true;
                    return a.getNr() == nr;
                });
    }

    private boolean isLargeSection(String desig) {
        if (desig == null) return false;
        java.util.regex.Matcher m = java.util.regex.Pattern.compile("(\\d+)").matcher(desig);
        if (m.find()) {
            try {
                return Integer.parseInt(m.group(1)) >= 100;
            } catch (NumberFormatException e) {
                return false;
            }
        }
        return false;
    }
}
