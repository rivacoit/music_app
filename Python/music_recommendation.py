from firebase_utils import initialize_firestore_app, get_all_data
from lyrics_analyzer import get_stem

db = initialize_firestore_app()

data = get_all_data(db, "musicRecommendation")

def fetch_music_based_on_emotion(emotion):
    # print(data[emotion])
    return data[emotion]


def fetch_music_based_on_activity(emotion, text):
# def fetch_music_based_on_activity(text):
    result = {}
    s = text.split()
    s = get_stem(s)
    for eachemotion, song_list in data.items():
        if (eachemotion == emotion):
            # print(song_list)
            for name, song_info in song_list.items():
                # print('NAME:', name)
                song_info = data[emotion][name]
                keywords = song_info['keywords']
                # print('SONG INFO:', song_info)
                # print(keywords)
                for word in s:
                    if word in keywords:
                        # print(name)
                        # print(song_info)
                        result.update({name: song_info})
        # print('RESULT:', result)
    return result


# print(fetch_music_based_on_emotion('joy'))
# result = fetch_music_based_on_activity('playing')
# print(result)