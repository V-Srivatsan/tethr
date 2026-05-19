from modules.community.models import Membership, Announcement

async def accept_membership(membership_uid: str, admin_community: int):
    membership = await Membership.get_or_none(uid=membership_uid, community_id=admin_community)
    if not membership: return (404, { "message": "Membership request not found" })

    membership.verified = True
    await membership.save()
    return (200, { "message": "Membership request accepted" })


async def reject_membership(membership_uid: str, admin_community: int):
    membership = await Membership.get_or_none(uid=membership_uid, community_id=admin_community, is_active=True)
    if not membership: return (404, { "message": "Membership request not found" })

    if not membership.verified: await membership.delete()
    else:
        if membership.is_admin:
            return (403, { "message": "Cannot remove an admin member" })
        
        membership.is_active = False
        await membership.save()
    return (200, { "message": "Membership removed" })


async def make_admin(membership_uid: str, admin_community: int):
    membership = await Membership.get_or_none(uid=membership_uid, community_id=admin_community, is_active=True)
    if not membership: return (404, { "message": "Membership not found" })

    membership.is_admin = True
    await membership.save()
    return (200, { "message": "Admin rights granted" })


async def remove_admin(membership_uid: str, admin_community: int, admin_id: int):
    membership = await Membership.get_or_none(uid=membership_uid, community_id=admin_community, is_active=True, is_admin=True)
    if not membership: return (404, { "message": "Membership not found" })
    if membership.user_id == admin_id: return (403, { "message": "You cannot remove your own admin rights" })

    admin_membership = await Membership.get(user_id=admin_id, community_id=admin_community, is_active=True, is_admin=True)
    if membership.updated_at <= admin_membership.updated_at:
        return (403, { "message": "You can only remove newer admins" })
    
    membership.is_admin = False
    await membership.save()
    return (200, { "message": "Admin rights removed" })


async def get_announcements(community_id: int):
    announcements = await Announcement.filter(community_id=community_id)\
        .order_by("-created_at", "-updated_at")\
        .select_related("user").all()
    return (200, {
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