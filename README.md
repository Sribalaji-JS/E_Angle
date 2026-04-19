# E_Angle: Precision Steel Design Assistant

**E_Angle** is a professional engineering tool designed for the selection and analysis of Indian Standard Angle (ISA) sections in steel connections, fully compliant with **IS 800:2007**. It leverages Machine Learning to recommend the most material-efficient angle sections and predicts connection performance with high precision.

---

## 🚀 Key Features

- **Optimal Section Recommendation**: Automatically identifies the most efficient ISA section for a given target capacity.
- **ML-Powered Analysis**: Uses Random Forest models to predict tensile capacity and failure modes with high accuracy.
- **Professional PDF Reporting**: Generates high-end Technical Design Reports with branding, branding icons, and full technical specifications.
- **Modern UI/UX**: A sleek, glassmorphic mobile interface built with Flutter, optimized for field and office use.
- **IS 800:2007 Compliance**: Specifically tailored for Indian Standard engineering practices.

---

## 🛠️ Technology Stack

### Frontend (Mobile App)
- **Framework**: Flutter (Dart)
- **UI Design**: Modern Glassmorphism / Slate & Blue theme
- **Reporting**: PDF generation with `pdf` and `printing` packages
- **Typography**: Google Fonts (Outfit / Inter)

### Backend (AI Engine)
- **Framework**: Python / Flask
- **Machine Learning**: Scikit-learn (Random Forest Regressor & Classifier)
- **Data Handling**: Pandas & NumPy
- **Storage**: Sanitized CSV dataset with automated normalization scripts

---

## 📂 Project Structure

```text
E_Angle/
├── eangle_mobile/          # Flutter Mobile Application
│   ├── lib/
│   │   ├── screens/        # UI Screens (Input, Result, Splash)
│   │   ├── services/       # API Communications
│   │   └── models/         # Data Models
│   └── assets/             # Branding & Reference Diagrams
├── eangle_backend/         # Flask API Service
│   └── main.py             # API Entry Point & ML logic
├── models/                 # Pre-trained ML Models (.pkl)
├── train_models.py         # ML Training scripts
├── EAngle_data.csv         # Cleaned engineering dataset
├── .gitignore              # Git environment rules
└── README.md               # Project Documentation
```

---

## ⚙️ Installation & Setup

### Backend Setup
1. Navigate to the backend directory.
2. Install dependencies:
   ```bash
   pip install flask flask-cors scikit-learn pandas
   ```
3. Run the server:
   ```bash
   python app.py
   ```

### Mobile Setup
1. Navigate to `eangle_mobile`.
2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Run on your device:
   ```bash
   flutter run
   ```

---

## 📈 Machine Learning Details

The system utilizes two primary models trained on a verified engineering dataset:
1. **Capacity Regressor**: Predicts the ultimate tensile capacity of a connection in kN based on geometry and bolt configuration.
2. **Failure Classifier**: Identifies the critical failure mode (e.g., Block Shear, Net Section Rupture, or Tension Yielding).

---

## 📄 License & Disclaimer

Generated reports and analysis are for engineering assistance and should be verified against manual calculations as per **IS 800:2007**.

**Developer**: Sribalaji-JS
**Version**: 1.0.0
