from tortoise import fields
from lib.db import BaseModel
import os

from enum import Enum
class UserRole(Enum):
    USER = 'user'
    NGO = 'ngo'
    GOVT = 'govt'

def gen_token(): return os.urandom(128).hex()


class User(BaseModel):
    name = fields.CharField(max_length=50)
    phone = fields.CharField(max_length=15, unique=True)
    role = fields.CharEnumField(enum_type=UserRole, default=UserRole.USER)
    verified = fields.BooleanField(default=False)


class RefreshToken(BaseModel):
    user = fields.OneToOneField("user.User", related_name="refresh_token")
    token = fields.CharField(max_length=256, unique=True, default=gen_token)
    
    def refresh(self): self.token = gen_token()