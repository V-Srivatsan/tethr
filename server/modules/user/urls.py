from fastapi import APIRouter, Depends
import middleware
from . import forms, logic
from lib.views import parse_res

router = APIRouter(prefix="/user")


@router.post("/auth/register/")
async def register(form: forms.Signup):
    return parse_res(await logic.create_user(form.name, form.phone))

@router.post("/auth/login/")
async def login(form: forms.Login):
    return parse_res(await logic.login_user(form.phone))

@router.post("/auth/verify/")
async def verify_otp(form: forms.VerifyOTP):
    return parse_res(await logic.verify_otp(form.phone, form.otp))

@router.get("/")
async def get_user(user_id: int = Depends(middleware.get_user)):
    return parse_res(await logic.get_user(user_id))