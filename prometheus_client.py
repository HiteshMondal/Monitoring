from prometheus_client import start_http_server, Gauge
import random, time

temperature = Gauge('room_temperature_celsius', 'Temperature in Celsius')

if __name__ == '__main__':
    start_http_server(8000)
    while True:
        temperature.set(random.uniform(25, 35))
        time.sleep(5)
