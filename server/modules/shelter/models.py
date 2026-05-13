from tortoise import fields
from lib.db import BaseModel, BaseTimeMixin
from lib.gis import GISPointField

class Shelter(BaseModel, BaseTimeMixin):
    name = fields.CharField(max_length=100)
    landmark = fields.CharField(max_length=100)
    location = GISPointField()
    capacity = fields.IntField(min_value=0)
    occupied = fields.IntField(min_value=0, default=0)
    creator = fields.ForeignKeyField("user.User", related_name="created_shelters")