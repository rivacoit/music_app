import pickle
from models import normalize_text

def load_model(filename):
    with open(filename, 'rb') as f:
        model = pickle.load(f)
    return model

def predict_text_emotion(model, text):
    data = {'Text': [text]}
    df = pd.DataFrame(data=data)
    df = normalize_text(df)
    text = df['Text'].values
    y_pred = model.predict(text)
    return y_pred[0]
