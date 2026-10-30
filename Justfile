PORT := '/dev/ttyUSB0'

FIRMWARE := 'ESP32_GENERIC-20260824-v1.29.0.bin'
FIRMWARE_URL := 'https://micropython.org/resources/firmware/ESP32_GENERIC-20260824-v1.29.0.bin'

# Generate a blinking LED test script.
new name='new':
    printf '%s\n' \
        'import time' \
        'from machine import Pin' \
        '' \
        'led = Pin(2, Pin.OUT) # onboard LED' \
        '' \
        'print("Hello, world!")' \
        'while True:' \
        '  led.value(not led.value())' \
        '  time.sleep(0.5)' \
        '  print(led.value())' \
        > {{name}}.py

# Upload a script as main.py and restart the board.
deploy name='test':
    uv tool run mpremote connect {{PORT}} fs cp {{name}}.py :main.py
    uv tool run mpremote connect {{PORT}} reset

# Open a serial REPL.
serial:
    uv tool run mpremote connect {{PORT}} repl

# Stop a running serial terminal.
kill:
    pkill -f 'mpremote connect /dev/ttyUSB0 repl' || true

# Download MicroPython firmware if missing.
firmware:
    curl -fL '{{FIRMWARE_URL}}' -o '{{FIRMWARE}}'

# Flash MicroPython firmware to ESP32.
flash: firmware
    uv tool run esptool --port {{PORT}} --baud 460800 write-flash 0x1000 {{FIRMWARE}}

# Erase everything from the ESP32.
erase:
    uv tool run esptool --port {{PORT}} erase-flash
