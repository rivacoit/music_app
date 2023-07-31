import firebase_admin
from firebase_admin import credentials, firestore

def initialize_firestore_app():
    cred = credentials.Certificate("key.json")
    firebase_admin.initialize_app(cred)
    return firestore.client()

def get_data(db, collection, emotion):
    doc_ref = db.collection(collection).document(emotion)
    doc = doc_ref.get()
    if doc.exists:
        return doc.to_dict()
    else:
        return {}

def get_all_data(db, collection):
    data = {}
    docs = db.collection(collection).stream()
    for doc in docs:
        data[doc.id] = doc.to_dict()
    return data

def update_data(db, collection, emotion, data):
    doc_ref = db.collection(collection).document(emotion)
    doc_ref.set(data, merge=True)
