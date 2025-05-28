# 🌾 Agri Insight – Smart Farming Companion App

Agri Insight is a mobile app designed to support farmers and agriculture enthusiasts. It provides smart crop recommendations, weather updates, and agri-related news, all in one place. The goal is to help users make better decisions by using real-time data and machine learning.

> ⚠️ Note: This is a work-in-progress project. Some features are yet to be fully completed and integrated.

---

## 🔑 Key Features

- **Crop Recommendation** – Suggests crops based on soil, weather, and other parameters (using a machine learning model).
- **Weather Forecast** – Displays real-time weather data via Weather API.
- **Agri News Feed** – Pulls recent agricultural news using News API.
- **Crop Calendar Tracker** – Lets users input sowing dates and track growth timelines.
- **User Authentication** – Basic login/signup functionality using Firebase.
- **Data Storage** – Stores user and crop data in Firebase Realtime Database.

---

## 🛠 Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend/ML:** Python (Random Forest), Firebase
- **APIs Used:** Weather API, News API
- **Database:** Firebase Realtime Database

---

## 🧠 Machine Learning Model

The crop recommendation is powered by a Random Forest Classifier trained on environmental and soil parameters like:

- Soil type
- Temperature
- Humidity
- Season

The model predicts suitable crops for the given conditions. Integration with the app is still in progress.

---

## 🔌 APIs Used

- **Weather API** – for weather updates
- **News API** – to fetch agricultural news
- **Firebase** – for user authentication and data storage
