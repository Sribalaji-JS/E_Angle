from flask import Flask, request, jsonify
import pickle
import pandas as pd
import os

app = Flask(__name__)

# Load models safely
reg_model = None
clf_model = None
label_encoder = None

def load_models():
    global reg_model, clf_model, label_encoder
    try:
        with open('models/reg_model.pkl', 'rb') as f:
            reg_model = pickle.load(f)
        with open('models/clf_model.pkl', 'rb') as f:
            clf_model = pickle.load(f)
        with open('models/label_encoder.pkl', 'rb') as f:
            label_encoder = pickle.load(f)
        print("Models loaded successfully.")
    except Exception as e:
        print("Model loading failed:", e)

load_models()

@app.route('/predict', methods=['POST'])
def predict():
    if not reg_model or not clf_model or not label_encoder:
        return jsonify({'error': 'Models not loaded on server'}), 500
        
    data = request.json
    
    # Extract features required by model: A, B, t, n, d, dh, p, e, Nr
    features = ['A', 'B', 't', 'n', 'd', 'dh', 'p', 'e', 'Nr']
    try:
        input_data = pd.DataFrame([{f: data.get(f, 0) for f in features}])
    except Exception as e:
        return jsonify({'error': f'Invalid input: {e}'}), 400
        
    # Capacity Prediction
    capacity_pred = reg_model.predict(input_data)[0]
    
    # Failure classification
    failure_encoded = clf_model.predict(input_data)[0]
    failure_label = label_encoder.inverse_transform([failure_encoded])[0]
    
    return jsonify({
        'capacity_kn': float(capacity_pred),
        'failure_type': str(failure_label)
    })

if __name__ == '__main__':
    # Running on port 5000
    app.run(host='0.0.0.0', port=5000, debug=True)
