from fastapi import APIRouter
from .admin.urls import router as admin_router
from .member.urls import router as member_router

router = APIRouter(prefix="/community")
router.include_router(admin_router)
router.include_router(member_router)