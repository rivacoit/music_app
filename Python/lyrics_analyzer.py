import nltk
from nltk.tag import pos_tag
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer
from rake_nltk import Rake

def get_actions(lyrics):
    nltk.download('punkt')
    nltk.download('averaged_perceptron_tagger')
    tokens = word_tokenize(lyrics)
    pos_tag_list = pos_tag(tokens)
    actions = set()
    for word, tag in pos_tag_list:
        if tag == 'VB':
            actions.add(word)
    return actions

def get_keywords(lyrics):
    nltk.download('stopwords')
    rake_nltk_var = Rake(include_repeated_phrases=False)
    rake_nltk_var.extract_keywords_from_text(lyrics)
    keyword_extracted = rake_nltk_var.get_word_degrees()
    return set(keyword_extracted)

def get_stem(keywords):
    ps = PorterStemmer()
    stem_keywords = set()
    for word in keywords:
        word = ps.stem(word)
        stem_keywords.add(word)
    return stem_keywords

def get_keywords_from_lyrics(lyrics):
    actions = get_actions(lyrics)
    keywords = get_keywords(lyrics)
    keywords.update(actions)
    keywords = get_stem(keywords)
    return keywords
