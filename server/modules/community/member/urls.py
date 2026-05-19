from fastapi import APIRouter, Depends
from lib.views import parse_res
import middleware
from . import logic, forms

router = APIRouter()


@router.post("/")
async def create_community(form: forms.CreateCommunity, user_id: int = Depends(middleware.get_user)):
    return parse_res(await logic.create_community(form.name, form.description, user_id, form.lat, form.lng))

@router.get("/")
async def list_communities(lat: float, lng: float):
    return parse_res(await logic.list_communities(lat, lng))

@router.post("/join/{community_id}/")
async def join_community(community_id: str, user_id: int = Depends(middleware.get_user)):
    return parse_res(await logic.join_community(user_id, community_id))

@router.get("/info/")
async def get_community_info(perm: dict = Depends(middleware.get_member)):
    return parse_res(await logic.get_community_info(perm['community'], perm['is_admin']))

@router.delete("/")
async def leave_community(user_id: int = Depends(middleware.get_user)):
    return parse_res(await logic.leave_community(user_id))
