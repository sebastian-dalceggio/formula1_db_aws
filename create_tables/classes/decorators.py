import time
from functools import wraps

def retry(tries=100, time_sleep=2):
    def inner(func):
        @wraps(func)
        def wrapper(*args, **kargs):
            attempts = tries
            while True:
                attempts -= 1
                try:
                    return func(*args, **kargs)
                except Exception as e:
                    if attempts:
                        time.sleep(time_sleep)
                        continue
                    else:
                        raise e
        return wrapper
    return inner