# Grievease - Student Grievance Redressal System

## 💼 Role
**Frontend Developer** — Developed the complete front-end interface using Flutter technology.

## 📌 Project Overview
**Grievease** is a student grievance redressal platform designed to streamline the process of reporting and resolving issues within educational institutions. It allows students to submit various concerns related to maintenance, faculty behavior, and more in a user-friendly and transparent way.

This system ensures that grievances are managed efficiently, and provides actionable insights to the college administration for continuous improvement in campus life.

## 🎯 Key Features
- 🔧 **Issue Submission:** Students can log different types of grievances including maintenance problems, feedback on faculty, and other concerns.
- 📊 **Dashboard View:** Displays grievance statuses, pending actions, and resolutions for transparency.
- 🔍 **Track & Monitor:** Allows students to track the status of their submitted grievances.
- 🧾 **Detailed Records:** Admin can view categorized and historical grievance records.
- 🔐 **Secure Access:** Role-based access for students and administrators.

## 🚀 Tech Stack
- **Frontend:** Flutter (Dart)
- **Backend:** Django REST Framework (in collaboration with backend team)
- **Database:** PostgreSQL / MySQL (used via Django ORM)
- **API Integration:** RESTful APIs for all major operations

## 🧩 Team Contribution
This was a collaborative capstone project as part of my MSc (IT) degree.
My primary responsibility was to develop the **entire frontend using Flutter**, ensuring smooth API integration with the backend developed by teammates.

## 📈 Outcome
- Improved grievance tracking and resolution transparency for students.
- Provided administration with insights to improve services.
- Created a digital solution that can be scaled across institutions.

---
## 🔧 How to Run the Project

The project consists of two main parts:
- 🖥️ **Frontend**: Built using Flutter
- 🛠️ **Backend**: Developed using Django REST Framework

---

### 🚀 1. Running the Flutter Frontend (`loginsplashscreen`)

> **Prerequisites:**
> - Flutter SDK installed
> - Android Studio or VS Code
> - Android emulator or physical device connected

```bash
# Navigate to the frontend directory
cd loginsplashscreen

# Get all the dependencies
flutter pub get

# Run the app on a connected device or emulator
flutter run
```
🛠️ 2. Running the Django Backend (GrievEaseBackend)
> **Prerequisites:**
> - Python 3.7+
> - pip
> - virtualenv (recommended)
> - MySQL/PostgreSQL or SQLite

```bash
# Navigate to the backend folder
cd GrievEaseBackend

# (Optional) Create and activate a virtual environment
python -m venv venv
source venv/bin/activate  # On Windows use `venv\Scripts\activate`

# Install dependencies
pip install -r requirements.txt

# Apply database migrations
python manage.py migrate

# Start the Django development server
python manage.py runserver
```
By default, the server runs on http://127.0.0.1:8000/



🔗 API Integration
The Flutter frontend interacts with the Django backend via RESTful APIs. Make sure both the frontend and backend are running and properly connected (update the base URL in the Flutter app if needed).
