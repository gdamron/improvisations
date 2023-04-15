import subprocess
from gpiozero import Button

PATH = "/home/pi/musicBox/main.ck"

proc = None
btn = Button(10)

def play():
    print("starting music box process")
    proc = subprocess.Popen(["chuck", PATH])

def stop():
    print("killing music box process")
    proc.kill()
    proc = None

print("listening for button presses")

button.when_pressed = stop
button.when_released = play

pause()
