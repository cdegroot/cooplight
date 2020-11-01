# Cooplight

A NodeMCU project to have an ESP8266 drive a bunch of LEDs around dusk. Our chickens keep
getting in too late and then they don't see their roosts well enough to get up to them.

This uses two pieces of white LED strip (with three LEDs each), on their on transistor, driven by two
GPIO pins. This keeps GPIO current and small transistor power dissipation low.

Apart from gpio, this uses NodeMCU's sntp and rtc modules to keep the time, so this will
only reliably work if there's a WiFi signal.
