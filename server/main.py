from fastapi import FastAPI
from tortoise.contrib.fastapi import register_tortoise
from lib.db import TORTOISE_CONFIG

app = FastAPI()
register_tortoise(app, TORTOISE_CONFIG, generate_schemas=False)


from modules.user.urls import router as user_routes
app.include_router(user_routes)

from modules.community.urls import router as community_routes
app.include_router(community_routes)