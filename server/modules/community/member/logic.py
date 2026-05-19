from modules.community.models import Community, Membership
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


async def get_community_info(community_id: int, is_admin: bool):
    query = Membership.filter(community_id=community_id, is_active=True)
    if not is_admin: query = query.filter(verified=True)
    memberships = await query.order_by("user__name").select_related("user", "community").all()
    
    return (200, { 
        "name": memberships[0].community.name,
        "description": memberships[0].community.description,
        
        "members": {
            member.uid.hex: {
                "name": member.user.name,
                "phone": member.user.phone,
                "verified": member.verified,
                "is_admin": member.is_admin
            } for member in memberships
        }
    })


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
