# Prints Music track info whenever the track changes.
import PyXA
from time import sleep
music = PyXA.Application("Music")

# Wait for Music.app to be ready to play
music.activate()
while not music.frontmost:
    sleep(0.5)
music.play()

track_name = ""
while True:
    if music.current_track.name != track_name:
        track_name = music.current_track.name
        print(music.current_track.name)
        print(music.current_track.album)
        print(music.current_track.artist, "\n")