FROM nvcr.io/nvidia/pytorch:22.07-py3

WORKDIR /app

COPY ./requirements.txt .

RUN python3 -m pip install -r requirements.txt

COPY . .

ENV FLASK_APP "app.main:app"
CMD ["flask", "run", "-p", "8000"]
