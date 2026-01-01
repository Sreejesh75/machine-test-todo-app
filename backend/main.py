from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import firebase_admin
from firebase_admin import credentials, messaging
import os
from pathlib import Path

# Initialize FastAPI
app = FastAPI()

# Initialize Firebase Admin SDK
# Get the directory where this script is located
SCRIPT_DIR = Path(__file__).parent
SERVICE_ACCOUNT_PATH = SCRIPT_DIR / "Keyy"

if not firebase_admin._apps:
    try:
        if SERVICE_ACCOUNT_PATH.exists():
            cred = credentials.Certificate(str(SERVICE_ACCOUNT_PATH))
            firebase_admin.initialize_app(cred)
            print(f"✅ Firebase Admin SDK initialized successfully.")
            print(f"📁 Using service account: {SERVICE_ACCOUNT_PATH}")
        else:
            print(f"⚠️  Warning: 'serviceAccountKey.json' not found at {SERVICE_ACCOUNT_PATH}")
            print("   FCM features will fail. Please add your Firebase service account key.")
    except Exception as e:
        print(f"❌ Error initializing Firebase Admin SDK: {e}")

class NotificationRequest(BaseModel):
    token: str
    title: str
    body: str
    data: dict = {}

@app.post("/send-notification")
async def send_notification(request: NotificationRequest):
    """
    Endpoint to send an FCM notification to a specific device token.
    """
    if not firebase_admin._apps:
         raise HTTPException(status_code=500, detail="Firebase Admin SDK not initialized. Check server logs.")

    try:
        # Construct the message
        # Note: 'notification' key handles the system tray notification.
        # 'data' key is for custom data payloads.
        message = messaging.Message(
            notification=messaging.Notification(
                title=request.title,
                body=request.body,
            ),
            data=request.data,
            token=request.token,
        )

        # Send the message
        response = messaging.send(message)
        return {"message": "Notification sent successfully", "response": response}

    except Exception as e:
        # Catch Firebase errors (e.g., invalid token)
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/")
def read_root():
    return {"message": "FCM Backend is running. POST to /send-notification to test."}