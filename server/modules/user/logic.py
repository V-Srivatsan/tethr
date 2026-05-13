import jwt
import os
import random
from .models import User
from lib.cache import cache

def generate_jwt(user: User):
    token = jwt.encode({
        "id": user.id,
        "uid": user.uid.hex,
        "name": user.name,
        "phone": user.phone,
        "role": user.role.value,
        "verified": user.verified
    }, os.getenv("JWT_SECRET", "SECRET_KEY"))

    return token


async def create_user(name: str, phone: str):
    try:
        await User.create(name=name, phone=phone)
        return await login_user(phone, bypass=True)
    except Exception as e:
        return (400, { "message": "User with this phone number already exists" })
    

async def login_user(phone: str, bypass=False):
    if not bypass:
        user = await User.get_or_none(phone=phone)
        if not user: return (404, { "message": "User not found" })
    
    otp = ''.join([str(random.randint(0, 9)) for _ in range(6)])
    cache.set(f"otp:{phone}", otp, ttl=300)
    print(f"OTP for {phone}: {otp}", flush=True)
    return (200, { "message": "OTP sent to your phone number" })


async def verify_otp(phone: str, otp: str):
    cached_otp = cache.get(f"otp:{phone}")
    if not cached_otp: return (404, { "message": "OTP expired or not found" })
    if cached_otp != otp: return (400, { "message": "Invalid OTP" })
    
    cache.delete(f"otp:{phone}")
    token = generate_jwt(await User.get(phone=phone))
    return (200, { "token": token })