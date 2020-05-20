import requests
import random

def fetch_digits(start):
    r = requests.get(f'https://api.pi.delivery/v1/pi?start={start}&numberOfDigits=1000')
    return r.text[12:][:-2]

def encode(num):
    start = 0
    while True:
        pi_part = fetch_digits(start)
        index = pi_part.find(num)

        if index == -1:
            start += 1000
            continue

        actual_index = start + index
        actual_end = actual_index + int(len(num))
        return actual_index, actual_end

def decode(start_index, end_index):
    x = start_index // 1000 * 1000
    pi_part = fetch_digits(x)
    start = start_index - x
    end = end_index - x
    return pi_part[start:end]

num = input('Please enter a number to encode:\n')#str(random.randint(1000,10000))
ind_start, ind_end = encode(num)
print('your num:', num)
print('start pos:', ind_start)
print('end pos:', ind_end)

original = decode(ind_start, ind_end)
print('your original number is:', original)
