FROM python:3.12-slim

# ffmpeg: needed for merging video/audio and MP3 extraction
# curl/unzip/ca-certificates: needed to install Deno below
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg curl unzip ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Deno: JS runtime yt-dlp needs to solve YouTube's challenge and get real formats
RUN curl -fsSL https://deno.land/install.sh | sh -s -- -y
ENV DENO_INSTALL="/root/.deno"
ENV PATH="$DENO_INSTALL/bin:$PATH"

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "run_all.py"]
