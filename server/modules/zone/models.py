from tortoise import fields
from tortoise.contrib.postgres.indexes import GistIndex
from lib.gis import GISPointField
from lib.db import BaseModel, BaseTimeMixin

class Zone(BaseModel):
    center = GISPointField()
    radius = fields.FloatField() 
    danger = fields.SmallIntField(default=0, min_value=1, max_value=5)

    class Meta:
        indexes = [GistIndex(fields=["center"])]


class Incident(BaseModel, BaseTimeMixin):
    description = fields.CharField(max_length=255)
    location = GISPointField()
    creator = fields.ForeignKeyField("user.User", related_name="incidents")

    class Meta:
        indexes = [GistIndex(fields=["location"])]