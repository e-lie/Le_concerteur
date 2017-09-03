#!/usr/bin/python3

from urllib import request
import urllib
import json
import os
from glob import glob
from pydub import AudioSegment

SERVER_URL="https://leconcerteur.fr/concerteur"
SOUND_DIR="/home/pi/concerteurClient/sounds/"
LAST = 'last_file_name.txt'
SIGNATURE = 'concerteur_01'

def get_sound_list(refresh):
    #Local POST request to the flask app using a custom port
    url = SERVER_URL + '/get-sound-list'
    with open(SOUND_DIR+LAST, 'r') as f:
        filename = f.readline()
        params = { 'lastFilename':filename,
                'refresh':refresh}
        print(params)
        # Encode the query string
        querystring = urllib.parse.urlencode(params)

        # Make a POST request and read the response
        resp = request.urlopen(url, querystring.encode('utf-8'))
        #read bytes from the JSON response and convert it to string (decode) then dictionnary (json.loads)
        jsondata = resp.read().decode('utf-8')
        data = json.loads(jsondata)
        with open(SOUND_DIR+'question.txt', 'w') as f:
            f.write("question_active {};".format(int(data['question_active'])))
        return data
        
def get_update_status():
    #Local POST request to the flask app using a custom port
    url = SERVER_URL + '/update-status'
    params = { 'signature':SIGNATURE }
    # Encode the query string
    querystring = urllib.parse.urlencode(params)

    # Make a POST request and read the response
    resp = request.urlopen(url, querystring.encode('utf-8'))
    #read bytes from the JSON response and convert it to string (decode) then dictionnary (json.loads)
    jsondata = resp.read().decode('utf-8')
    data = json.loads(jsondata)
    return data['update_status']
        
def get_sound(filename):
    url = SERVER_URL + '/get-sound'
    print("getsound : {}".format(filename))
    params = {'soundname':filename}
    with open(SOUND_DIR+filename, 'wb') as f:
        querystring = urllib.parse.urlencode(params)
        resp = request.urlopen(url, querystring.encode('utf-8'))
        mp3 = resp.read()
        f.write(mp3)


def convert_sounds_to_wav(new_files):
    mp3_files = glob(SOUND_DIR+'*.mp3')
    file_number = len(mp3_files) - len(new_files)
    for mp3_filename in new_files:
        file_number += 1
        mp3_path = SOUND_DIR+mp3_filename
	
        mp3seg = AudioSegment.from_mp3(mp3_path)
        mp3seg.export("{}{}.wav".format(SOUND_DIR,file_number), format="wav")
    
    with open(SOUND_DIR+'params.txt', 'w') as f:
        f.write("nbcontrib {};".format(len(mp3_files)))

def convert_question(question_filename):
    mp3_path = SOUND_DIR + question_filename
    mp3seg = AudioSegment.from_mp3(mp3_path)
    mp3seg.export(SOUND_DIR+"question.wav", format="wav")
    os.remove(mp3_path)

def clean_files():
    os.system('rm -f {}*.mp3'.format(SOUND_DIR))
    os.system('rm -f {}*.wav'.format(SOUND_DIR))
    with open(SOUND_DIR+'params.txt', 'w') as f:
        f.write("nbcontrib {};".format(0))


if __name__ == "__main__":
    refresh = get_update_status()
    print(refresh)
    data = get_sound_list(refresh)
    print(data)
    if data['refresh']:
        clean_files()
    new_files = data['filenames']
    last_filename = data['lastfilename']
    if data['question_filename']:
        get_sound(data['question_filename'])
        convert_question(data['question_filename'])
    for sound in new_files:
        get_sound(sound)
    with open(SOUND_DIR+LAST, 'w') as f:
        f.write(last_filename)

    convert_sounds_to_wav(new_files)
