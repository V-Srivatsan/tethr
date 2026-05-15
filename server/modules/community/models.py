from tortoise import fields
from tortoise.contrib.postgres.indexes import GistIndex
from lib.gis import GISPointField
from lib.db import BaseModel, BaseTimeMixin

class Community(BaseModel):
    name = fields.CharField(max_length=50)
    description = fields.CharField(max_length=255)
    location = GISPointField()

    class Meta:
        indexes = [GistIndex(fields=["location"])]


class Membership(BaseModel, BaseTimeMixin):
    user = fields.ForeignKeyField("user.User", related_name="memberships")
    community = fields.ForeignKeyField("community.Community", related_name="members")
    is_admin = fields.BooleanField(default=False)
    is_active = fields.BooleanField(default=True)
    verified = fields.BooleanField(default=False)