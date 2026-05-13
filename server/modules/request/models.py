from tortoise import fields
from lib.gis import GISPointField
from lib.db import BaseModel, BaseTimeMixin

from enum import Enum
class RequestStatus(Enum):
    PENDING = 'pending'
    ACCEPTED = 'accepted'
    COMPLETED = 'completed'
    CANCELLED = 'cancelled'


class Request(BaseModel, BaseTimeMixin):
    title = fields.CharField(max_length=100)
    description = fields.CharField(max_length=255)
    location = GISPointField()

    creator = fields.ForeignKeyField("user.User", related_name="created_requests")
    community = fields.ForeignKeyField("community.Community", related_name="requests", null=True)
    acceptor = fields.ForeignKeyField("user.User", related_name="accepted_requests", null=True)

    urgency = fields.SmallIntField(default=0, min_value=0, max_value=5)
    status = fields.CharEnumField(RequestStatus, default=RequestStatus.PENDING)


class SOSRequest(BaseModel, BaseTimeMixin):
    user = fields.ForeignKeyField("user.User", related_name="sos_requests")
    location = GISPointField()
    resolved = fields.BooleanField(default=False)