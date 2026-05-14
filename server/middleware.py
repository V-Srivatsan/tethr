from fastapi import Header, HTTPException
import jwt
import os

async def get_user(authorization: str | None = Header(default=None)):
    if not authorization:
        raise HTTPException(status_code=401, detail="Authorization header is missing")
    
    try:
        data = jwt.decode(authorization, os.getenv("JWT_SECRET", "SECRET_KEY"), algorithms=["HS256"])
    except Exception as e:
        raise HTTPException(status_code=401, detail="Invalid token")
    return data['id']