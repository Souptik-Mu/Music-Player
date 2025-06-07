from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import pygame.mixer as mx

#todo (setart server) : python -m uvicorn backend_server:app --reload --host 127.0.0.1 --port 8000


app = FastAPI()

# Allow all origins for development
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize pygame mixer
mx.init()
MUSIC_FILE = "D:\Media\SnG\MixPlaylist\HAPPY.mp3"  # Place your mp3 file in the same folder

is_playing = False

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
    return {"status": "playing"}

@app.post("/pause")
def pause():
    global is_playing
    if is_playing:
        mx.music.pause()
        print(mx.music.get_pos()) #min is 197
        is_playing = False
    return {"status": "paused"}

#TODO: return song progress, made unpause work, change ui a little bit
