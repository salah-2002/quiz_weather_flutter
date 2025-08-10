# DEMO_APP – Flutter Quiz & Weather App

A Flutter-based mobile application that combines two main features:

✅ **Quiz Module** – An interactive quiz with dynamic scoring.  
🌦 **Weather Module** – Real-time weather data from OpenWeather API.

---

## 📂 Project Structure
lib/
├── main.dart # App entry point with bottom navigation

├── quiz.dart # Quiz screen logic and layout

├── question.dart # Question & answer models

├── answer.dart # Answer button widget

├── score.dart # Score result screen

├── weather.dart # Weather screen logic and API integration

---

## 🚀 Features

### 🎯 Quiz Module
- Multiple choice questions
- Dynamic score tracking
- Feedback on selected answers
- Scrollable layout with fixed bottom bar

### ☁️ Weather Module
- Uses **OpenWeatherMap API**
- Displays temperature, weather description, humidity, and pressure
- City search feature
- API key loaded securely from `.env`

---

## 🔑 Environment Variables

Create a `.env` file in the project root:

OPENWEATHER_API_KEY=your_api_key_here
flutter pub get
flutter run

Created by Salah Eddine Bazaragou
