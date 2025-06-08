from flask import Flask, jsonify , request
#from flask_cors import CORS
import pygame.mixer as mx

app = Flask(__name__)
#CORS(app)

# Initialize pygame mixer
mx.init()
MUSIC_FILE = r"D:\Media\SnG\MixPlaylist\HAPPY.mp3"  # Place your mp3 file in the same folder

is_playing = False

@app.route("/path", methods=["GET", "POST"])
def get_path():
    return jsonify({"path": MUSIC_FILE})

#@app.route("/play", methods=["POST"])
@app.post("/play")
def play():
    global is_playing
    if not is_playing:
        if mx.music.get_busy():
            mx.music.unpause()
        else:
            mx.music.load(MUSIC_FILE)
            mx.music.play()
        
        is_playing = True
    return jsonify({"status": "playing"})

@app.post("/pause")
def pause():
    global is_playing
    if is_playing:
        mx.music.pause()
        print(mx.music.get_pos()) #min is 197
        is_playing = False
    return jsonify({"status": "paused"}
)
#TODO: return song progress, made unpause work, change ui a little bit

if __name__ == "__main__":
    app.run(host="127.0.0.1",port=8000, debug=True)
