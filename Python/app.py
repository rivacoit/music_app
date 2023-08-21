from flask import Flask, request, jsonify
# from lyrics_analyzer import get_keywords_from_lyrics
from addkeywordstofirebase import add_keywords_to_songs
import pickle
from emotion_prediction import predict_text_emotion
from music_recommendation import fetch_music_based_on_emotion

app = Flask(__name__)

with open('text_emotion.pkl', 'rb') as model_file:
    text_emotion_model = pickle.load(model_file)


# @app.route('/', methods=['POST'])
# def analyze_lyrics():
#     data = request.get_json()
#     lyrics = data['lyrics']
#     keywords = get_keywords_from_lyrics(lyrics)
#     # print(f'Received lyrics: {lyrics}')
#     # print(f'Extracted keywords: {keywords}')

#     return jsonify({'keywords': list(keywords)})

@app.route('/predict_emotion', methods=['POST'])
def predict_emotion():
    data = request.get_json()
    text = data['text']
    emotion = predict_text_emotion(text_emotion_model, text)
    
    return jsonify({'emotion': emotion})

@app.route('/recommendation', methods=['GET'])
def recommend_song():
    emotion = request.args.get('emotion')
    recommend_songs = fetch_music_based_on_emotion(emotion)
    return jsonify({'recommended_songs': recommend_songs})

if __name__ == '__main__':
    print('Starting Flask server...')
    # add_keywords_to_songs()
    app.run(debug=True)