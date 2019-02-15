FROM python:3.6.0-alpine

WORKDIR /app
COPY . /app

RUN apk add --no-cache gcc=5.3.0-r0 musl-dev=1.1.14-r16
RUN pip install -r /app/requirements.txt

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

CMD ["python3", "post_app.py"]
