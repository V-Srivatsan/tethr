import valkey
import os

class Cache:
    def __init__(self):
        self.client = valkey.from_url(os.environ.get("CACHE_URL", "redis://cache:6379"))
    
    def set(self, key, value, ttl=None):
        self.client.set(key, value, ex=ttl)
    
    def get(self, key):
        res = self.client.get(key)
        if res is None: return None
        return res.decode()

    def delete(self, key):
        self.client.delete(key)

cache = Cache()