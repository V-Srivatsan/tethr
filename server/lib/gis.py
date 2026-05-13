from tortoise import fields, Model
from typing import TypeVar, Type

T = TypeVar('T', bound=Model)

class GISPointField(fields.Field):
    SQL_TYPE = "GEOMETRY(Point, 4326)"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def to_db_value(self, value, instance):
        if value is None: return None
        return f"POINT({value[0]} {value[1]})"

    def to_python_value(self, value): return value



async def GIS_FindNear(
    model: Type[T],
    point_field: str,
    location: tuple[float, float],
    distance_meters: float
):
    """
    Find records within a specified distance from a location using PostGIS.
    
    Args:
        model: The Tortoise ORM model class with a location GISPointField
        location: Tuple of (longitude, latitude)
        distance_meters: Search radius in meters
    
    Returns:
        List of model instances within the specified distance
    """
    lon, lat = location
    
    
    return await model.raw(
        f"""
        SELECT * FROM {model._meta.db_table}
        WHERE ST_DWithin(
            {point_field}::geography,
            ST_SetSRID(ST_MakePoint({lon}, {lat}), 4326)::geography,
            {distance_meters}
        )
        """
    )