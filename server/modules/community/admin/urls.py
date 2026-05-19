from fastapi import APIRouter, Depends
from lib.views import parse_res
import middleware
from . import logic, forms

router = APIRouter()

@router.put("/membership/{membership_id}/")
async def accept_membership(membership_id: str, perm: dict = Depends(middleware.get_admin)):
    return parse_res(await logic.accept_membership(membership_id, perm['community']))

@router.delete("/membership/{membership_id}/")
async def reject_membership(membership_id: str, perm: dict = Depends(middleware.get_admin)):
    return parse_res(await logic.reject_membership(membership_id, perm['community']))

@router.put("/membership/{membership_id}/admin/")
async def make_admin(membership_id: str, perm: dict = Depends(middleware.get_admin)):
    return parse_res(await logic.make_admin(membership_id, perm['community']))

@router.delete("/membership/{membership_id}/admin/")
async def remove_admin(membership_id: str, perm: dict = Depends(middleware.get_admin)):
    return parse_res(await logic.remove_admin(membership_id, perm['community'], perm['user']))

@router.get("/announcements/")
async def get_announcements(perm: dict = Depends(middleware.get_member)):
    return parse_res(await logic.get_announcements(perm['community']))

@router.post("/announcements/")
async def create_announcement(form: forms.PostAnnouncement, perm: dict = Depends(middleware.get_admin)):
    return parse_res(await logic.create_announcement(perm['user'], perm['community'], form.title, form.content))