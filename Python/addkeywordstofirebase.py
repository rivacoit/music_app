from firebase_utils import initialize_firestore_app, update_data, get_all_data
from lyrics_analyzer import get_keywords_from_lyrics

db = initialize_firestore_app()

def add_keywords_to_songs():
    collection_name = "musicRecommendation"
    # emotion = ["angry", "sad", "joy"]

    emotions = {
        "angry": "angry",
        "joy": "joy",
        "sad": "sad"
    }

    for emotion, doc_name in emotions.items():
        songs = get_all_data(db, collection_name)[doc_name]

        for song_name, song_info in songs.items():
            lyrics = song_info['lyrics']
            keywords = get_keywords_from_lyrics(lyrics)
            song_info['keywords'] = list(keywords)
            update_data(db, collection_name, doc_name, {song_name: song_info})