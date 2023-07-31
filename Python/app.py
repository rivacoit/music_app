from flask import Flask, request, jsonify
from lyrics_analyzer import get_keywords_from_lyrics

app = Flask(__name__)

@app.route('/', methods=['POST'])
def analyze_lyrics():
    data = request.get_json()
    lyrics = data['lyrics']
    keywords = get_keywords_from_lyrics(lyrics)
    # print(f'Received lyrics: {lyrics}')
    # print(f'Extracted keywords: {keywords}')

    return jsonify({'keywords': list(keywords)})

if __name__ == '__main__':
    print('Starting Flask server...')
    app.run(debug=True)