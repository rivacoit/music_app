#imports
from firebase_utils import get_all_data, update_data
from lyrics_analyzer import get_keywords_from_lyrics

#adding keywords for each song
def add_keywords2songs(db, collection):
    data = get_all_data(db, collection)
    for emotion, song_list in data.items():
        for name, song_info in song_list.items():
            #get the lyrics and retreive their keywords
            lyrics = song_info['lyrics']
            keywords = get_keywords_from_lyrics(lyrics)

            #update the Firebase collection and stores keywords in the corresponding location
            song_info['keywords'] = keywords
            update_data(db, collection, emotion, {name: song_info})

            
