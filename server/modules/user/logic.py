import jwt
import os
import random
import datetime
from .models import User, RefreshToken
from lib.cache import cache

async def generate_jwt(user: User):
    membership = await user.memberships.filter(is_active=True).first()
    token = jwt.encode({
        "id": user.id,
        "verified": user.verified,
        "community": membership.community_id if membership else None,
        "community_verified": membership.verified if membership else False,
        "is_admin": membership.is_admin if membership else False,
        "exp": (datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(seconds=30))
    }, os.getenv("JWT_SECRET", "SECRET_KEY"))

    return token


async def refresh_token(refresh_token: str):
    token = await RefreshToken.get_or_none(token=refresh_token).select_related("user")
    if not token: return (404, { "message": "Refresh token not found" })

    token.refresh()
    await token.save()
    return (200, { "token": await generate_jwt(token.user), "refresh_token": token.token })


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
    
    user = await User.get(phone=phone).select_related("refresh_token")
    refresh_token = user.refresh_token
    if refresh_token is None:
        refresh_token = await RefreshToken.create(user=user)

    token = await generate_jwt(user)
    return (200, { 
        "token": token, "refresh_token": refresh_token.token, 
        "name": user.name 
    })


async def get_user(user_id: int):
    user = await User.get_or_none(id=user_id)
    if not user: return (404, { "message": "User not found" })

    active_comm = await user.memberships.filter(is_active=True).select_related("community").first()
    return (200, {
        "name": user.name,
        "phone": user.phone,
        "community": active_comm.community.name if active_comm else None,
        "role": user.role.value,
        "verified": user.verified
    })