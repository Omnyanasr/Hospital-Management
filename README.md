# 📱 Hospital Management Mobile App

This is the mobile application (Flutter) for the Hospital Management System. It allows patients to book appointments, chat with an AI symptom checker, analyze blood test results, and view prescriptions assigned by doctors.

👉 **Live Repository:** [Hospital-Management](https://github.com/Omnyanasr/Hospital-Management)

---

## 🚀 Features

### 🩺 Doctor Appointments
- Browse available doctors
- Filter by specialization and availability
- Book or cancel appointments easily

### 💬 AI Chatbot – Symptom Checker
- Chatbot allows users to describe their symptoms
- Suggests a suitable doctor specialization
- Helps navigate available doctors based on symptoms

### 🧪 Blood Test Analysis
- Input blood test values manually
- Detect if values are normal or abnormal
- For **abnormal results**:
  - Suggest possible diseases
  - Provide treatment guides and doctor specialization
  - Estimate time to return to normal
- For **all results** (normal/abnormal):
  - Time to retest
  - Health information and care guides

### 📈 Health Monitoring & Prediction
- Monitor blood test trends over time
- Predict the next expected value using AI models
- Visual feedback on health progression

### 💊 View Prescriptions
- Medicines prescribed by doctors appear directly in the app

---

## 🛠️ Tech Stack

- **Flutter** – UI and frontend logic
- **Firebase Authentication** – User login and registration
- **Cloud Firestore** – Storing appointments, test results, user data
- **FastAPI Backend (External)** – Handles AI blood test analysis and predictions
- **OpenAI API (Optional)** – For chatbot intelligence (if implemented)

---

## 📲 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/Omnyanasr/Hospital-Management.git
   cd Hospital-Management
