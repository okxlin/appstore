# ORYX

[![](https://img.shields.io/twitter/follow/srs_server?style=social)](https://twitter.com/srs_server)
[![](https://badgen.net/discord/members/bQUPDRqy79)](https://discord.gg/bQUPDRqy79)
[![](https://ossrs.net/wiki/images/wechat-badge4.svg)](https://ossrs.net/lts/zh-cn/contact#discussion)
[![](https://ossrs.net/wiki/images/do-btn-srs-125x20.svg)](https://marketplace.digitalocean.com/apps/srs)
[![](https://opencollective.com/srs-server/tiers/badge.svg)](https://opencollective.com/srs-server)

Oryx(SRS Stack), is an all-in-one, out-of-the-box, and open-source video solution for creating 
online video services, including live streaming and WebRTC, on the cloud or through self-hosting.

> Note: We renamed the project from SRS Stack to Oryx, because we only need a new name for AI assistant to identify 
> SRS and SRS Stack. AI assistant is confused with SRS and SRS Stack.

Oryx makes it easy for you to create an online video service. It is made using Go, Reactjs, SRS, 
FFmpeg, and WebRTC. It supports protocols like RTMP, WebRTC, HLS, HTTP-FLV, and SRT. It offers features 
like authentication, streaming on multiple platforms, recording, transcoding, virtual live events, 
automatic HTTPS, and an easy-to-use HTTP Open API.

[![](https://ossrs.io/lts/en-us/img/Oryx-5-sd.png?v=1)](https://ossrs.io/lts/en-us/img/Oryx-5-hd.png)

> Note: For more details on the Oryx, please visit the following [link](https://www.figma.com/file/Ju5h2DZeJMzUtx5k7D0Oak/Oryx).

## Usage

Run Oryx in one docker, then open http://localhost in browser:

```bash
docker run --restart always -d -it --name oryx -v $HOME/data:/data \
  -p 80:2022 -p 443:2443 -p 1935:1935 -p 8000:8000/udp -p 10080:10080/udp \
  ossrs/oryx:5
```

> Important: Remember to mount the `/data` volume to avoid losing data when the container restarts. For instance, 
> if you mount `/data` to `$HOME/data`, all data will be stored in the `$HOME/data` folder. Be sure to modify this 
> according to your desired directory.

> Important: To use WebRTC WHIP in a browser, avoid using localhost or 127.0.0.1. Instead, use a private IP (e.g., https://192.168.3.85), 
> a public IP (e.g., https://136.12.117.13), or a domain (e.g., https://your-domain.com). To set up HTTPS, 
> refer to [this post](https://blog.ossrs.io/how-to-secure-srs-with-lets-encrypt-by-1-click-cb618777639f).

> Note: In China, use `registry.cn-hangzhou.aliyuncs.com/ossrs/oryx:5` to accelerate the Docker pull process 
> and ensure the proper language is set.

The ports used for Oryx:

* `80/tcp`: The HTTP port, you can also use `2022` instead, such as `-p 2022:2022` etc.
* `443/tcp`: The HTTPS port, you can also use `2443` instead, such as `-p 2443:2443` etc.
* `1935/tcp`: The RTMP port, to support publish stream by RTMP to Oryx.
* `8000/udp`: The WebRTC UDP port, to transport WebRTC media data like RTP packets.
* `10080/udp`: The SRT UDP port, to support publish stream via SRT protocol.

You have the option to modify the volumes for Oryx and direct them to different directories.

* `/data` The global data directory.
    * `.well-known` The directory for Let's Encrypt ACME challenge.
    * `config` The .env for password, srs/redis/nginx/prometheus config, and SSL files.
    * `dvr` The dvr storage directory, save dvr files.
    * `lego` The LEGO Let's Encrypt ACME challenge directory.
    * `record` The record storage directory, save record files.
    * `redis` The redis data directory, the publish secret and record configuration.
    * `signals` The signals storage directory, save signal files.
    * `upload` The upload storage directory, save upload files.
    * `vlive` The storage directory for virtual live, save video files.
    * `transcript` The storage directory for transcription, save transcription files.
    * `nginx-cache` The storage directory for nginx cache, save cache files.
    * `srs-s3-bucket` The mount directory for AWS S3 compatible storage.

You can use environment variables to modify the settings.

* `MGMT_PASSWORD`: The mgmt administrator password.
* `REACT_APP_LOCALE`: The i18n config for ui, `en` or `zh`, default to `en`.

> Note: The `MGMT_PASSWORD` is also saved in `/data/config/.env`, you can modify it by yourself.

To access additional environment variables, please refer to the [Environments](DEVELOPER.md#environments) section.

## Sponsor

Would you like additional assistance from us? By becoming a sponsor or backer of SRS, we can provide you
with the support you need:

* Backer: $5 per month, online text chat support through Discord.
* Sponsor: $100 per month, online meeting support, 1 meeting per month in 1 hour.

Please visit [OpenCollective](https://opencollective.com/srs-server) to become a backer or sponsor, and send
us a direct message on [Discord](https://discord.gg/bQUPDRqy79). We are currently providing support to the 
developers listed below:

[![](https://opencollective.com/srs-server/backers.svg?width=800&button=false)](https://opencollective.com/srs-server)

We at SRS aim to establish a non-profit, open-source community that assists developers worldwide in creating
your own high-quality streaming and RTC platforms to support your businesses.

## FAQ

1. [English FAQ](https://ossrs.io/lts/en-us/faq-oryx)
1. [中文 FAQ](https://ossrs.net/lts/zh-cn/faq-oryx)

## Tutorials

- [x] Getting Started: [Blog](https://blog.ossrs.io/how-to-setup-a-video-streaming-service-by-1-click-e9fe6f314ac6), [EN](https://ossrs.io/lts/en-us/docs/v6/doc/getting-started-stack), [CN](https://ossrs.net/lts/zh-cn/docs/v5/doc/getting-started-stack).
- [x] Support WordPress Plugin: [Blog](https://blog.ossrs.io/publish-your-srs-livestream-through-wordpress-ec18dfae7d6f), [EN](https://ossrs.io/lts/en-us/blog/WordPress-Plugin), [CN](https://ossrs.net/lts/zh-cn/blog/WordPress-Plugin) or [WordPress Plugin](https://wordpress.org/plugins/srs-player).
- [x] Support Automatic HTTPS: [Blog](https://blog.ossrs.io/how-to-secure-srs-with-lets-encrypt-by-1-click-cb618777639f), [EN](https://ossrs.io/lts/en-us/blog/Oryx-Tutorial), [CN](https://ossrs.net/lts/zh-cn/blog/Oryx-HTTPS).
- [x] Support aaPanel to install on any linux: [Blog](https://blog.ossrs.io/how-to-setup-a-video-streaming-service-by-aapanel-9748ae754c8c), [EN](https://ossrs.io/lts/en-us/blog/BT-aaPanel), [CN](https://ossrs.net/lts/zh-cn/blog/BT-aaPanel).
- [x] Support DVR to local disk: [Blog](https://blog.ossrs.io/how-to-record-live-streaming-to-mp4-file-2aa792c35b25), [EN](https://ossrs.io/lts/en-us/blog/Record-Live-Streaming), [CN](https://mp.weixin.qq.com/s/axN_TPo-Gk_H7CbdqUud6g).
- [x] Support Virtual Live Streaming: [CN](https://mp.weixin.qq.com/s/I0Kmxtc24txpngO-PiR_tQ).
- [x] Support Stream IP Camera: [Blog](https://blog.ossrs.io/easily-stream-your-rtsp-ip-camera-to-youtube-twitch-or-facebook-c078db917149), [EN](http://ossrs.io/lts/en-us/blog/Stream-IP-Camera-Events), [CN](https://ossrs.net/lts/zh-cn/blog/Stream-IP-Camera-Events).
- [x] Support build small [HLS deliver CDN](https://github.com/ossrs/oryx/tree/main/scripts/nginx-hls-cdn) by Nginx.
- [x] Support Live Streaming: [CN](https://mp.weixin.qq.com/s/AKqVWIdk3SBD-6uiTMliyA).
- [x] Support Realtime SRT Streaming: [CN](https://mp.weixin.qq.com/s/HQb3gLRyJHHu56pnyHerxA).
- [x] Support DVR to Tencent Cloud Storage or VoD: [CN](https://mp.weixin.qq.com/s/UXR5EBKZ-LnthwKN_rlIjg).
- [x] Support Typecho Plugin: [CN](https://github.com/ossrs/Typecho-Plugin-SrsPlayer).
- [x] Support live stream transcoding: [Blog](https://blog.ossrs.io/efficient-live-streaming-transcoding-for-reducing-bandwidth-and-saving-costs-39bd001af02d), [EN](https://ossrs.io/lts/en-us/blog/Live-Transcoding), [CN](https://ossrs.net/lts/zh-cn/blog/Live-Transcoding).
- [x] Support transcription for converting speech to text: [Blog](https://blog.ossrs.io/revolutionizing-live-streams-with-ai-transcription-creating-accessible-multilingual-subtitles-1e902ab856bd), [EN](https://ossrs.io/lts/en-us/blog/live-streams-transcription), [CN](https://ossrs.net/lts/zh-cn/blog/live-streams-transcription).
- [x] Support AI assistant for live room: [Blog](https://blog.ossrs.io/transform-your-browser-into-a-personal-voice-driven-gpt-ai-assistant-with-srs-stack-13e28adf1e18), [EN](https://ossrs.io/lts/en-us/blog/browser-voice-driven-gpt), [CN](https://ossrs.net/lts/zh-cn/blog/live-streams-transcription)
- [x] Support video dubbing for multiple languages: [Blog](https://blog.ossrs.io/expand-your-global-reach-with-srs-stack-effortless-video-translation-and-dubbing-solutions-544e1db671c2), [EN](https://ossrs.io/lts/en-us/blog/browser-voice-driven-gpt), [CN](https://ossrs.net/lts/zh-cn/blog/live-streams-transcription)
- [x] Support OCR for video stream: [Blog](https://blog.ossrs.io/leveraging-openai-for-ocr-and-object-recognition-in-video-streams-using-oryx-e4d575d0ca1f), [EN](https://ossrs.io/lts/en-us/blog/ocr-video-streams), [CN](https://ossrs.net/lts/zh-cn/blog/ocr-video-streams)

Other more use scenarios is on the way, please read [this post](https://github.com/ossrs/srs/issues/2856#lighthouse).

## Features

The features that we're developing:

- [x] A mgmt support authentication and automatic updates.
- [x] Run SRS in docker, query status by docker and SRS API.
- [x] Support publish by RTMP/WebRTC, play by RTMP/HTTP-FLV/HLS/WebRTC.
- [x] SRS container use docker logs `json-file` and rotate for logging.
- [x] Support high-resolution and realtime(200~500ms) live streaming by SRT.
- [x] Run SRS hooks in docker, to callback by SRS server.
- [x] Support publish by SRT, play by RTMP/HTTP-FLV/HLS/WebRTC/SRT.
- [x] Change redis port and use randomly password.
- [x] Support integrity with tencent cloud VoD.
- [x] Support restreaming to multiple platforms.
- [x] Support WordPress Plugin: SrsPlayer.
- [x] Support aaPanel to install on any linux.
- [x] Support DVR to local disk.
- [x] Support upgrade to latest version manually.
- [x] Support HTTPS by let's encrypt with LEGO.
- [x] Support virtual live streaming, covert file or other resource to live.
- [x] Support self-host HLS CDN, to serve 10k+ viewers.
- [x] Support Typecho Plugin: Typecho-Plugin-SrsPlayer.
- [x] Support DVR to TencentCloud storage.
- [x] Support pull RTSP from IP Camera and stream to YouTube/Twitch/Facebook.
- [x] Support live streaming transcoding by FFmpeg, see [#2869](https://github.com/ossrs/srs/issues/2869).
- [x] Support transcription for converting speech to text.
- [x] Support AI assistant for live room.
- [x] Support video dubbing for multiple languages.
- [ ] Support limit the streaming duration to limit the fee.
- [ ] Support GB28181 by SRS 5.0 container.
- [ ] Support WebRTC face to face chat, see [#2857](https://github.com/ossrs/srs/issues/2857).
- [ ] Support WebRTC video chat room, see [#2924](https://github.com/ossrs/srs/issues/2924).
- [ ] Support a set of tools for developer, see [#2891](https://github.com/ossrs/srs/issues/2891).
- [ ] Collect logs of mgmt and containers together.
- [ ] Stop, restart and upgrade containers.
- [ ] Support logrotate to manage the logs.
- [ ] Enhance prometheus API with authentication.
- [ ] Integrate with prometheus and node-exporter.

## License

Oryx is an open-source project, licensed under the [MIT](https://spdx.org/licenses/MIT.html) license.

We also used the following open-source projects:

* [FFmpeg](https://ffmpeg.org/): A complete, cross-platform solution to record, convert and stream audio and video.
* [Redis](https://redis.io/): Redis is an in-memory data store used by millions of developers as a cache, vector database, document database, streaming engine, and message broker.
* [youtube-dl](https://github.com/ytdl-org/youtube-dl): Command-line program to download videos from YouTube.com and other video sites.

Other frameworks we used:

* [Reactjs](https://react.dev/): The library for web and native user interfaces.
* [Go](https://golang.org/): Build simple, secure, scalable systems with Go.

## Developer

For development, please refer to the [Environments](DEVELOPER.md) about the API and architecture.

2022.11
