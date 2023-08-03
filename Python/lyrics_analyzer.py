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

# lyrics = """
# Your tattoo still looks cute to me, cute to me
# We're old news, but you're new to me, new to me

# I wanna fly to your shows, wanna wake up in your clothes
# Come get you tipsy at 6:30, wanna take tonight slow
# Yeah, it's all right
# In my life

# 'Cause it's true, babe, true, babe
# I'm sleepin' better next to you, babe, you, babe
# You're somethin' sweet, you're somethin' true, babe, true, babe
# You do it better than they do, babe, uh-huh

# La, la, la, na-na, na-na, na, na, na, na

# We could stay home and never leave, never leave
# Take the truck up the coast with me, coast with me

# I wanna fly to your shows, wanna wake up in your clothes
# Come get you tipsy at 6:30, wanna take tonight slow
# Yeah, it's all right
# In my life

# 'Cause it's true, babe, true, babe
# I'm sleepin' better next to you, babe, you, babe
# You're somethin' sweet, you're somethin' true, babe, true, babe
# You do it better than they do, babe, uh-huh

# La, la, la, na-na, na-na, na, na, na, na
# 'Cause it's true, babe, true, babe
# La, la, la, na-na, na-na, na, na, na, na

# And we're from two different worlds
# But you still call me your pretty girl, pretty girl
# Before you, it was all a blur
# Come on and call me your pretty girl, pretty girl

# 'Cause it's true, babe, true, babe
# I'm sleepin' better next to you, babe, you, babe (I'm sleepin' better next to you, babe)
# You're somethin' sweet, you're somethin' true, babe, true, babe
# You do it better than they do, babe, uh-huh

# La, la, la, na-na, na-na, na, na, na, na
# 'Cause it's true, babe, true, babe
# (You're somethin' sweet, you're somethin' true, babe, true, babe)
# La, la, la, na-na, na-na, na, na, na, na
# (You do it better than they do, babe, uh-huh)

#  """
# keywords = get_keywords_from_lyrics(lyrics)
# print(keywords)