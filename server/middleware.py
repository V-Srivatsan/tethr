from fastapi import Header, HTTPException
import jwt
import os

def decode_jwt(token: str | None):
    if not token:
        raise HTTPException(status_code=401, detail="Token is missing")
    try:
        return jwt.decode(token, os.getenv("JWT_SECRET", "SECRET_KEY"), algorithms=["HS256"])
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token has expired")
    except Exception as e:
        raise HTTPException(status_code=401, detail="Invalid token")

def get_user(authorization: str | None = Header(default=None)):
    return decode_jwt(authorization)['id']

def get_member(authorization: str | None = Header(default=None)):
    data = decode_jwt(authorization)
    if not data.get("community_verified", False):
        raise HTTPException(status_code=403, detail="User is not verified in a community")
    return {
        "user": data['id'], 
        "community": data['community'], 
        "is_admin": data['is_admin']
    }

def get_admin(authorization: str | None = Header(default=None)):
    data = decode_jwt(authorization)
    if not data.get("community_verified", False) or not data.get("is_admin", False):
        raise HTTPException(status_code=403, detail="User is not an admin")
    return {
        "user": data['id'], 
        "community": data['community']
    }