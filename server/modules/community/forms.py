from pydantic import BaseModel

class CreateCommunity(BaseModel):
    name: str
    description: str
    lat: float
    lng: float