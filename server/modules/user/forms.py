from pydantic import BaseModel

class Signup(BaseModel):
    name: str
    phone: str

class Login(BaseModel):
    phone: str

class VerifyOTP(BaseModel):
    phone: str
    otp: str