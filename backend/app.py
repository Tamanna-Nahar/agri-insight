import joblib
from flask import Flask, request, jsonify
import pandas as pd
from sklearn.preprocessing import StandardScaler

# Initialize the Flask app
app = Flask(__name__)

model = joblib.load('crop_recommendation_model.pkl')  # Load model
scaler = joblib.load('scaler.pkl')  # Load scaler
label_encoder = joblib.load('label_encoder.pkl')  # Load label encoder


# Route to make predictions
@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json(force=True)

    try:
        N = data['N']
        P = data['P']
        K = data['K']
        temperature = data['temperature']
        humidity = data['humidity']
        ph = data['ph']
        rainfall = data['rainfall']

        input_data = pd.DataFrame([[N, P, K, temperature, humidity, ph, rainfall]],
                                  columns=['N', 'P', 'K', 'temperature', 'humidity', 'ph', 'rainfall'])

        input_data_scaled = scaler.transform(input_data)  # Use transform instead of fit_transform for prediction

        prediction = model.predict(input_data_scaled)

        predicted_crop = label_encoder.inverse_transform(prediction)[0]  

        result = {'predicted_crop': predicted_crop}  
        return jsonify(result)
    except Exception as e:
        return jsonify({'error': str(e)})


if __name__ == '__main__':
    app.run(debug=True)
