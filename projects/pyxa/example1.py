# Opens a URL in Safari and prints the loaded page.
import PyXA
from time import sleep
safari = PyXA.Safari()
safari.open("https://www.apple.com")
sleep(1)
safari.current_document.print()