import time
from aq import AQ

aq = AQ()
aq.leds_automatic()

interval = int(input("Enter interval between readings (seconds):"))
file_name = input("Enter filename:")

auto_cal = input("Auto-calibrate at 2:00 AM (Y/N)?")

current_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
print("Logging started at: " + current_time)
print("Press CTRL-c to end logging")

f = open(file_name, "w")
f.write("time(s)\ttemp(C)\teCO2(ppm)\n")
print("time(s)\ttemp(C)\teCO2(ppm)")

last_update = 0
t0 = int(time.monotonic())

try:
    while True:
        now = time.monotonic()
        if (now > last_update + interval):
            last_update = now
            t = str(int(now) - t0)
            temp_c = str(aq.get_temp())
            eco2 = str(int(aq.get_eco2()))
            f.write(t + "\t")
            f.write(temp_c + "\t")
            f.write(eco2 + "\n")
            print(t + "\t" + temp_c + "\t" + str(int(eco2)))
        tm = time.localtime()
        if auto_cal.upper() == 'Y' and tm.tm_hour == 2 and tm.tm_min == 0 and tm.tm_sec == 0 :
            print("recalibrating")
            aq.calibrate_400()
            time.sleep(1000)
except:
    f.close()
    print("\nLogging to file " + file_name + " complete")
    current_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    print("Logging ended at: " + current_time)
