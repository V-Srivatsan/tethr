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