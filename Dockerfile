ARG BUILD_FROM=debian:bullseye-slim

FROM $BUILD_FROM

RUN apt-get update \
 && apt-get install -y wget gnupg2 \
 && mkdir -p /etc/apt/keyrings \
 && wget -q -O /etc/apt/keyrings/mopidy-archive-keyring.gpg \
        https://apt.mopidy.com/mopidy.gpg \
 && wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/bullseye.list

RUN apt-get update \
 && apt-get install -y libffi-dev \
                       libxml2-dev \
                       libxslt1-dev \
                       zlib1g-dev \
                       build-essential \
                       gstreamer1.0-alsa \
                       gstreamer1.0-plugins-bad \
                       gstreamer1.0-plugins-good \
                       gstreamer1.0-plugins-ugly \
                       python3-dev \
                       python3-gst-1.0 \
                       python3-lxml \
                       python3-pip \
                       python3-setuptools \
                       python3-wheel \
                       libasound2-dev \
                       libspotify-dev \
                       mopidy \
 && rm -rf /var/lib/apt/lists/*

# Add git to get some Mopidy stuff straight from Github
#RUN apt-get update \
# && apt-get install -y git \
# && rm -rf /var/lib/apt/lists/*

COPY requirements.txt requirements.txt

RUN echo 4 && pip3 install -r requirements.txt \
 && rm -rf ~/.cache/pip

RUN update-ca-certificates --fresh

# https://discourse.mopidy.com/t/spotify-login-error-errortype-unable-to-contact-server-8/4979/19
RUN echo "104.154.126.229 ap.spotify.com" >> /etc/hosts

ENV TZ=Europe/Amsterdam

EXPOSE 6600 6680

ENTRYPOINT ["mopidy"]
