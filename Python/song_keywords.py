from firebase_utils import get_all_data, update_data
from lyrics_analyzer import get_keywords_from_lyrics

def add_keywords2songs(db, collection):
    data = get_all_data(db, collection)
    for emotion, song_list in data.items():
        for name, song_info in song_list.items():
            lyrics = song_info['lyrics']
            keywords = get_keywords_from_lyrics(lyrics)
            song_info['keywords'] = keywords
            update_data(db, collection, emotion, {name: song_info})
