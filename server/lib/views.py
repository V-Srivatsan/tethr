from fastapi.responses import JSONResponse

def parse_res(res: tuple[int, dict]):
    status_code, data = res
    return JSONResponse(content=data, status_code=status_code)