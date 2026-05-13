from tortoise import Model, fields
import os, uuid

TORTOISE_CONFIG = {
    "connections": {
        "default": os.getenv("DATABASE_URL")
    },
    "apps": {
        "user": {
            "models": ["modules.user.models"],
            "default_connection": "default",
            "migrations": "modules.user.migrations"
        },
        "community": {
            "models": ["modules.community.models"],
            "default_connection": "default",
            "migrations": "modules.community.migrations"
        },
        "request": {
            "models": ["modules.request.models"],
            "default_connection": "default",
            "migrations": "modules.request.migrations"
        },
        "shelter": {
            "models": ["modules.shelter.models"],
            "default_connection": "default",
            "migrations": "modules.shelter.migrations"
        },
        "zone": {
            "models": ["modules.zone.models"],
            "default_connection": "default",
            "migrations": "modules.zone.migrations"
        }
    }
}


class BaseModel(Model):
    id = fields.BigIntField(primary_key=True)
    uid = fields.UUIDField(default=uuid.uuid4, unique=True, index=True)

    class Meta:
        abstract = True


class BaseTimeMixin():
    created_at = fields.DatetimeField(auto_now_add=True)
    updated_at = fields.DatetimeField(auto_now=True)