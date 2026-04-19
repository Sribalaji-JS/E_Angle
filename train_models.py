import os
import csv
import pickle

def train_and_export_models():
    # Attempt imports checking if environment is ready
    try:
        import pandas as pd
        from sklearn.model_selection import train_test_split
        from sklearn.ensemble import RandomForestRegressor, RandomForestClassifier
        from sklearn.metrics import mean_squared_error, accuracy_score
        from sklearn.preprocessing import LabelEncoder
    except ImportError as e:
        print(f"Dependencies are still installing... ({e})")
        return

    csv_file = 'EAngle_data.csv'
    if not os.path.exists(csv_file):
        print(f"Error: {csv_file} not found.")
        return
        
    print(f"Loading dataset from {csv_file}...")
    df = pd.read_csv(csv_file)
    
    # We drop mapping designation and use pure dimensions 
    features = ['A', 'B', 't', 'n', 'd', 'dh', 'p', 'e', 'Nr']
    
    # Drop rows missing critical features
    df = df.dropna(subset=features + ['capacity', 'failure'])
    
    X = df[features]
    y_reg = df['capacity']
    y_clf = df['failure']
    
    # Encode classification targets
    le = LabelEncoder()
    y_clf_encoded = le.fit_transform(y_clf)
    
    # Split
    X_train, X_test, y_reg_train, y_reg_test, y_clf_train, y_clf_test = train_test_split(
        X, y_reg, y_clf_encoded, test_size=0.2, random_state=42)
        
    print("\n--- Training Capacity Prediction Model (Regression) ---")
    reg_model = RandomForestRegressor(n_estimators=100, random_state=42)
    reg_model.fit(X_train, y_reg_train)
    y_reg_pred = reg_model.predict(X_test)
    mse = mean_squared_error(y_reg_test, y_reg_pred)
    import math
    rmse = math.sqrt(mse)
    print(f"Regression RMSE: {rmse:.2f} kN")
    
    print("\n--- Training Failure Prediction Model (Classification) ---")
    clf_model = RandomForestClassifier(n_estimators=100, random_state=42)
    clf_model.fit(X_train, y_clf_train)
    y_clf_pred = clf_model.predict(X_test)
    acc = accuracy_score(y_clf_test, y_clf_pred)
    print(f"Classification Accuracy: {acc * 100:.2f}%")
    
    # Save the models and encoder
    os.makedirs('models', exist_ok=True)
    with open('models/reg_model.pkl', 'wb') as f:
        pickle.dump(reg_model, f)
        
    with open('models/clf_model.pkl', 'wb') as f:
        pickle.dump(clf_model, f)
        
    with open('models/label_encoder.pkl', 'wb') as f:
        pickle.dump(le, f)
        
    print("\nModels exported successfully to /models directory!")

if __name__ == '__main__':
    train_and_export_models()
