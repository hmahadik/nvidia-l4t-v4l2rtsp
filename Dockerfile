FROM arm64v8/ubuntu:18.04 AS builder

WORKDIR /src
COPY ./test-launch.c /src/test-launch.c
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
  build-essential pkg-config libgstrtspserver-1.0 libgstreamer1.0-dev

RUN gcc test-launch.c -o test-launch $(pkg-config --cflags --libs gstreamer-1.0 gstreamer-rtsp-server-1.0)

FROM arm64v8/ubuntu:18.04

COPY --from=builder /src/test-launch /usr/bin/test-launch
ENV DEBIAN_FRONTEND=noninteractive
RUN set -eux; \
  apt-get update; \
  apt-get install -y \
    gstreamer1.0-tools gstreamer1.0-alsa \
    gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    libgstrtspserver-1.0 \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-good1.0-dev \
    libgstreamer-plugins-bad1.0-dev

EXPOSE 8554
ENTRYPOINT ["/usr/bin/test-launch"]
CMD ["\"v4l2src device=/dev/video0 ! video/x-h264,width=1920,height=1080,framerate=30/1 ! rtph264pay name=pay0 pt=96\""]
