from tortoise import fields, connections, Model
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
    lon, lat = location
    conn = connections.get("default")
    rows = await conn.execute_query_dict(f"""
        SELECT *, ST_X({point_field}) AS lng, ST_Y({point_field}) AS lat FROM {model._meta.db_table}
        WHERE ST_DWithin(
            {point_field}::geography,
            ST_SetSRID(ST_MakePoint({lon}, {lat}), 4326)::geography,
            {distance_meters}
        )
    """)

    res = []
    for row in rows:
        res.append(model(**row))
        setattr(res[-1], point_field, (row["lng"], row["lat"]))
    return res