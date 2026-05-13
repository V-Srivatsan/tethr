from tortoise import fields
from lib.db import BaseModel

from enum import Enum
class UserRole(Enum):
    USER = 'user'
    NGO = 'ngo'
    GOVT = 'govt'


class User(BaseModel):
    name = fields.CharField(max_length=50)
    phone = fields.CharField(max_length=15, unique=True)
    role = fields.CharEnumField(enum_type=UserRole, default=UserRole.USER)
    verified = fields.BooleanField(default=False)



