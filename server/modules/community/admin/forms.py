from pydantic import BaseModel

class PostAnnouncement(BaseModel):
    title: str
    content: str