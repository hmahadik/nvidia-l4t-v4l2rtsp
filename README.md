# nvidia-l4t-v4l2rtsp

## Option 1: Use docker

To create an H264 encoded RTSP stream of a local USB camera attached as `/dev/video0`:

```
docker run -d --name v4l2rtsp --device /dev/video0 -p 8554:8554 --restart unless-stopped hmahadik/nvidia-l4t-v4l2rtsp:latest
```

RTSP stream will be accessible at `rtsp://<ip_address_of_jetson>:8554/test`

Customize the stream by appending a valid gstreamer pipeline to the above command:

```
docker run -d -p 8554:8554 --device /dev/video1 hmahadik/nvidia-l4t-v4l2rtsp:latest "\"v4l2src device=/dev/video1 ! video/x-raw ! omxh265enc ! rtph265pay name=pay0 pt=96\""
```

## Option 2: Build it from source

Install dependencies
```
sudo apt-get install -y  libgstrtspserver-1.0 libgstreamer1.0-dev
```

Compile
```
gcc test-launch.c -o test-launch $(pkg-config --cflags --libs gstreamer-1.0 gstreamer-rtsp-server-1.0)
```

Run
```
./test-launch "v4l2src device=/dev/video0 ! video/x-h264,width=1920,height=1080,framerate=30/1 ! rtph264pay name=pay0 pt=96"
```

RTSP stream will be accessible at `rtsp://<ip_address_of_jetson>:8554/test`
