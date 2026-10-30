# ESP32 + MicroPython

A minimal development environment for experimenting with ESP32 microcontrollers using [MicroPython](https://micropython.org/), [Just](https://just.systems/), and [uv](https://docs.astral.sh/uv/).

The goal is to make getting started, flashing firmware, uploading scripts, and interacting with the board as straightforward as possible.

## Hardware

This setup was developed and tested with:

- ESP32-ESP-32S NodeMCU development board
- ESP32-WROOM-32 module
- CP2102 USB-to-serial interface

Other ESP32 development boards should work, although pin assignments and firmware compatibility may vary.

## Prerequisites

You'll need:

- **Just** — command runner for the development tasks.
- **uv** — Python package and tool manager.
- **curl** — downloading MicroPython firmware.
- **USB serial access** — your system must have permission to access the ESP32's serial device.

On Ubuntu, the CP2102 typically appears as `/dev/ttyUSB0`. Other boards or systems may use a different device name.

## Getting Started

### 1. Clone the repository

```bash
git clone <repository-url>
cd esp32
```

### 2. Connect your ESP32

Connect the board over USB and identify its serial device:

```bash
ls /dev/ttyUSB*
```

If necessary, update `PORT` in the `Justfile` to match your device.

### 3. Flash MicroPython

Download the firmware and flash it to the ESP32:

```bash
just flash
```

The default firmware is MicroPython v1.29.0 for generic ESP32 boards.

The firmware binary is downloaded automatically if needed.

**Note:** Flashing firmware replaces the existing firmware on the device. Use `just erase` if you want to completely erase the board's flash storage before starting over.

### 4. Generate a test script

Create a simple blinking LED example:

```bash
just new
```

This generates `new.py`, which blinks the onboard LED connected to GPIO 2.

You can provide a different filename:

```bash
just new blink
```

### 5. Upload and run your script

Upload a script to the board as `main.py` and restart it:

```bash
just deploy blink
```

The ESP32 automatically executes `main.py` when it boots.

### 6. Open the REPL

Connect to the MicroPython interactive console:

```bash
just serial
```

The REPL (Read-Eval-Print Loop) lets you interactively execute Python commands on the board, inspect hardware, and experiment without repeatedly uploading scripts.

Use `Ctrl+]` to exit the REPL.

## Just Commands

| Command | Description |
|---|---|
| `just` | List available recipes. |
| `just firmware` | Download the MicroPython firmware if needed. |
| `just flash` | Flash MicroPython onto the ESP32. |
| `just erase` | Erase the board's entire flash storage. |
| `just new` | Generate a basic blinking LED script. |
| `just new <name>` | Generate a script with a custom filename. |
| `just deploy <name>` | Upload `<name>.py` as `main.py` and restart the board. |
| `just serial` | Open a serial REPL connection. |
| `just kill` | Stop a running serial REPL process. |

## Configuration

The `Justfile` contains a few variables that can be adjusted for your hardware and firmware preferences:

```make
PORT := '/dev/ttyUSB0'

FIRMWARE := 'ESP32_GENERIC-20260824-v1.29.0.bin'
FIRMWARE_URL := 'https://micropython.org/resources/firmware/ESP32_GENERIC-20260824-v1.29.0.bin'
```

- `PORT`: Serial device used to communicate with the ESP32.
- `FIRMWARE`: Local firmware binary filename.
- `FIRMWARE_URL`: Firmware download location.

For a different ESP32 variant, select the appropriate firmware from the [MicroPython downloads page](https://micropython.org/download/).

## Working with MicroPython

Once MicroPython is installed, you can develop directly on the board using Python.

A few useful modules for hardware experimentation:

- `machine` — GPIO, PWM, timers, touch sensors, and other hardware interfaces.
- `neopixel` — controlling addressable RGB LED strips.
- `time` — delays, ticks, and timing utilities.
- `network` — Wi-Fi connectivity.
- `esp32` — ESP32-specific functionality, including deep sleep.

See the [MicroPython ESP32 documentation](https://docs.micropython.org/en/latest/esp32/quickref.html) for additional information.

## Notes

- `main.py` runs automatically when the board boots.
- Uploading a new script as `main.py` replaces the existing one.
- The firmware binary is downloaded locally and can be excluded from version control.
- The serial REPL and other tools are invoked through `uv tool run`, so there's no need to create or maintain a Python virtual environment for this project.
