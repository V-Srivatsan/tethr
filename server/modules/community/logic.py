from .models import Community, Membership
from lib.gis import GIS_FindNear

async def create_community(
    name: str, description: str, creator: int,
    lat: float, lng: float
):
    if await Membership.filter(user_id=creator, is_active=True).exists():
        return (429, { "message": "You are already part of a community" })
    
    community = await Community.create(name=name, description=description, location=(lng, lat))
    await Membership.create(user_id=creator, community=community, is_admin=True, verified=True)
    return (200, { "message": "Community created successfully" })


async def list_communities(lat: float, lng: float):
    comms: list[Community] = await GIS_FindNear(Community, "location", (lng, lat), 5000)
    return (200, { "communities": [
        {
            "uid": comm.uid.hex,
            "name": comm.name,
            "description": comm.description
        } for comm in comms
    ] })


async def join_community(user_id: int, community_uid: str):
    community = await Community.get_or_none(uid=community_uid)
    if not community: return (404, { "message": "Community not found" })

    if await Membership.filter(user_id=user_id, is_active=True).exists():
        return (429, { "message": "You are already part of a community" })

    await Membership.create(user_id=user_id, community=community)
    return (200, { "message": "Requested to join community" })


async def accept_membership(admin_id: int, membership_uid: str):
    membership = await Membership.get_or_none(uid=membership_uid).prefetch_related("community")
    if not membership: return (404, { "message": "Membership request not found" })

    if not (await Membership.filter(
        user_id=admin_id, community=membership.community, 
        is_admin=True, is_active=True
    ).exists()): return (403, { "message": "You are not an admin of this community" })

    membership.verified = True
    await membership.save()
    return (200, { "message": "Membership request accepted" })


async def leave_community(user_id: int):
    membership = await Membership.get_or_none(user_id=user_id, is_active=True).prefetch_related("community")
    if not membership: return (404, { "message": "You are not part of any community" })

    if not membership.verified:
        await membership.delete()
        return (200, { "message": "Left the community successfully" })
    
    other_admin = await Membership.filter(
        community=membership.community, is_admin=True, is_active=True
    ).exclude(user_id=user_id).exists()

    if membership.is_admin and not other_admin:
        return (403, { "message": "You must transfer admin rights before leaving the community" })
    
    membership.is_active = False
    await membership.save()
    return (200, { "message": "Left the community successfully" })