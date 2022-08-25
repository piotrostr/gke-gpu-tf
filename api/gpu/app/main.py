import torch

from flask import Flask

app = Flask(__name__)


def get_cuda_info() -> dict or str:
    if not torch.cuda.is_available():
        return "CUDA is not available"
    return {
        "visible_device": torch.cuda.get_device_name(0),
        "device_name": torch.cuda.get_device_name(),
        "device_count": torch.cuda.device_count(),
    }


@app.get("/gpu")
def gpu():
    return get_cuda_info()
