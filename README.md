# Quantum Todo App 📝

A feature-rich Flutter Todo application with Firebase Cloud Messaging integration and automated task notifications.

## ✨ Features

### Core Functionality
- ✅ **Create, Edit, Delete Tasks** - Full CRUD operations for task management
- ✅ **Task Properties** - Each task includes:
  - Title
  - Description
  - Priority Level (Low, Medium, High)
  - Due Date & Time
  - Creation timestamp

### Smart Features
- 🔔 **Automated Push Notifications** - Get notified when tasks are due
- ⏰ **Task Reminders** - Receive reminders 1 hour before task due date
- 🔍 **Search Functionality** - Search tasks by title or keyword
- 📊 **Flexible Sorting** - Sort by:
  - Priority (High to Low)
  - Due Date (Earliest first)
  - Creation Date (Newest first)
- 💾 **Data Persistence** - All data saved locally using Hive database
- 🔥 **Firebase Cloud Messaging** - Backend integration for remote notifications

### Architecture & Design
- 🏗️ **Clean Architecture** - Follows MVVM/MVC pattern
- 🎯 **BLoC State Management** - Predictable state management
- 💉 **Dependency Injection** - Using GetIt for service locator pattern
- 🎨 **Material Design** - Follows Material Design 3 guidelines
- 📱 **Responsive UI** - Beautiful gradient-based UI with smooth animations

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK (3.9.0 or higher)
- Android Studio / VS Code
- Firebase Account (for FCM)
- Python 3.11+ (for backend server)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd TodoApp-quntum
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation for Hive**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configure Firebase**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add your Android/iOS app to the project
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories
   - The `firebase_options.dart` file is already configured

5. **Run the app**
   ```bash
   flutter run
   ```

## 🔔 Notification System

### Local Notifications
The app uses `flutter_local_notifications` to schedule local notifications:
- **On Task Creation**: Automatically schedules notifications for the due date
- **Reminder Notifications**: Sends a reminder 1 hour before the task is due
- **On Task Update**: Reschedules notifications with updated time
- **On Task Delete**: Cancels all associated notifications

### Firebase Cloud Messaging (FCM)
The backend server can send push notifications remotely:

1. **Setup Backend** (See `backend/README.md` for details)
   ```bash
   cd backend
   pip install -r requirements.txt
   uvicorn main:app --reload
   ```

2. **Get FCM Token**
   - Run the Flutter app
   - Check the debug console for the FCM token
   - Copy the token for testing

3. **Send Test Notification**
   ```bash
   POST http://localhost:8000/send-notification
   Content-Type: application/json

   {
     "token": "YOUR_FCM_TOKEN",
     "title": "Task Reminder",
     "body": "Your task is due soon!",
     "data": {
       "taskId": "123"
     }
   }
   ```

## 📁 Project Structure

```
lib/
├── core/
│   ├── di/
│   │   └── injector.dart          # Dependency injection setup
│   ├── services/
│   │   └── notification_service.dart  # Local notification service
│   └── theme/
│       ├── app_colour.dart        # App color scheme
│       └── app_text_styles.dart   # Text styles
├── data/
│   ├── models/
│   │   └── task_model.dart        # Task data model (Hive)
│   └── repository/
│       └── task_repository.dart   # Data access layer
├── domain/
│   └── usecases/
│       ├── add_task_usecases.dart
│       ├── delete_task_usecases.dart
│       ├── get_task_usecases.dart
│       └── update_task_usecases.dart
└── presntation/
    ├── bloc/
    │   └── task/
    │       ├── task_bloc.dart     # BLoC logic
    │       ├── task_event.dart    # BLoC events
    │       └── task_state.dart    # BLoC states
    ├── screens/
    │   ├── splash_screen.dart
    │   ├── home_screen.dart
    │   ├── add_task_screen.dart
    │   └── edit_task_screen.dart
    └── widgets/
        ├── search_bar.dart
        └── task_card.dart

backend/
├── main.py                        # FastAPI server
├── requirements.txt               # Python dependencies
├── README.md                      # Backend setup guide
└── serviceAccountKey.json         # Firebase admin credentials
```

## 🛠️ Technologies Used

### Frontend
- **Flutter** - UI framework
- **Dart** - Programming language
- **flutter_bloc** - State management
- **Hive** - Local database
- **get_it** - Dependency injection
- **firebase_core** - Firebase initialization
- **firebase_messaging** - Push notifications
- **flutter_local_notifications** - Local notifications
- **timezone** - Timezone handling
- **intl** - Date formatting
- **uuid** - Unique ID generation
- **lottie** - Animations

### Backend
- **FastAPI** - Python web framework
- **Firebase Admin SDK** - Server-side Firebase
- **Uvicorn** - ASGI server

## 📋 Requirements Checklist

- ✅ Create, edit, and delete tasks
- ✅ Task properties (title, description, priority, due date)
- ✅ Priority levels for tasks
- ✅ Reminders for tasks due soon
- ✅ Push notifications based on task expiration
- ✅ Sort tasks (priority, due date, creation date)
- ✅ Search feature by title/keyword
- ✅ Data persistence (Hive database)
- ✅ Material Design guidelines
- ✅ Flutter & Dart
- ✅ MVVM/MVC architecture
- ✅ BLoC state management
- ✅ Clean, documented code
- ✅ Version control (Git)

## 🎯 Usage

### Creating a Task
1. Tap the **+** button on the home screen
2. Fill in task details:
   - Title (required)
   - Description
   - Priority (Low/Medium/High)
   - Due Date & Time
3. Tap **Save**
4. Notifications are automatically scheduled

### Editing a Task
1. Tap on any task card
2. Modify the details
3. Tap **Update**
4. Notifications are rescheduled automatically

### Deleting a Task
1. Tap the delete icon on a task card
2. Confirm deletion
3. Associated notifications are cancelled

### Searching Tasks
1. Use the search bar at the top
2. Type keywords from title or description
3. Results update in real-time

### Sorting Tasks
1. Use the dropdown menu (top right)
2. Select sorting criteria:
   - Priority
   - Due Date
   - Created Date

## 🔐 Permissions

The app requires the following permissions:
- **Notifications** - For local and push notifications
- **Internet** - For Firebase Cloud Messaging
- **Schedule Exact Alarms** - For precise notification timing (Android 12+)

## 🐛 Troubleshooting

### Notifications not working
1. Check notification permissions in device settings
2. Ensure the app has "Exact Alarm" permission (Android 12+)
3. Verify Firebase configuration is correct
4. Check that the due date is in the future

### Backend connection issues
1. Ensure the backend server is running
2. Check `serviceAccountKey.json` is in the backend folder
3. Verify FCM token is correct and not expired
4. Check firewall/network settings

## 📝 License

This project is created for educational purposes.

## 👨‍💻 Author

Quantum Todo App - A comprehensive task management solution with smart notifications.
