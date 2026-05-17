from .models import Community, Membership, Announcement
from lib.gis import GIS_FindNear

async def create_community(
    name: str, description: str, creator: int,
    lat: float, lng: float
):
    if await Membership.filter(user_id=creator, is_active=True).exists():
        return (412, { "message": "You are already part of a community" })
    
    community = await Community.create(name=name, description=description, location=(lng, lat))
    await Membership.create(user_id=creator, community=community, is_admin=True, verified=True)
    return (200, { "message": "Community created successfully" })


async def list_communities(lat: float, lng: float):
    comms: list[Community] = await GIS_FindNear(Community, "location", (lng, lat), 5000)
    return (200, { "communities": [
        {
            "uid": comm.uid.hex,
            "name": comm.name,
            "description": comm.description,
            "lat": comm.location[1],
            "lng": comm.location[0],
        } for comm in comms
    ] })


async def join_community(user_id: int, community_uid: str):
    community = await Community.get_or_none(uid=community_uid)
    if not community: return (404, { "message": "Community not found" })

    if await Membership.filter(user_id=user_id, is_active=True).exists():
        return (412, { "message": "You are already part of a community" })

    await Membership.create(user_id=user_id, community=community)
    return (200, { "message": "Requested to join community" })


async def accept_membership(admin_community: int, membership_uid: str):
    membership = await Membership.get_or_none(uid=membership_uid).select_related("community")
    if not membership: return (404, { "message": "Membership request not found" })

    if admin_community != membership.community.id: 
        return (403, { "message": "You are not an admin of this community" })

    membership.verified = True
    await membership.save()
    return (200, { "message": "Membership request accepted" })


async def leave_community(user_id: int):
    membership = await Membership.get_or_none(user_id=user_id, is_active=True).select_related("community")
    if not membership: return (404, { "message": "You are not part of any community" })

    if not membership.verified:
        await membership.delete()
        return (200, { "message": "Left the community successfully" })
    
    if membership.is_admin:
        other_admin = await Membership.filter(
            community=membership.community, is_admin=True, is_active=True
        ).exclude(user_id=user_id).exists()

        if not other_admin:
            return (403, { "message": "You must transfer admin rights before leaving the community" })
    
    membership.is_active = False
    await membership.save()
    return (200, { "message": "Left the community successfully" })


async def get_announcements(community_id: int, is_admin: bool):
    announcements = await Announcement.filter(community_id=community_id)\
        .order_by("-created_at", "-updated_at")\
        .select_related("user").all()
    return (200, { 
        "is_admin": is_admin,
        "announcements": [
            {
                "title": ann.title,
                "content": ann.content,
                "created_at": ann.created_at.isoformat(),
                "updated_at": ann.updated_at.isoformat(),
                "user": ann.user.name
            } for ann in announcements
        ] 
    })


async def create_announcement(user_id: int, community_id: int, title: str, content: str):
    await Announcement.create(
        community_id=community_id, user_id=user_id,
        title=title, content=content
    )
    return (200, { "message": "Announcement created successfully" })