# Frigate

## Introduction
Frigate is an open-source real-time video surveillance system.

## Features
- Monitor IP cameras and process video streams with object detection.
- Provide RTSP and WebRTC video streams.
- Keep configuration and recordings in user-selected persistent directories.

## Deployment
Install Frigate with Docker Compose through 1Panel. The fixed `0.18.3` package
supports amd64 and arm64 variants. The `stable` package follows the upstream
stable image channel.

## Ports
| Variable | Description | Default | Required |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTPS | Web UI port | 8971 | Yes |
| PANEL_APP_PORT_RTSP | RTSP port | 8554 | Yes |
| PANEL_APP_PORT_WEBRTC_TCP | WebRTC TCP port | 8555 | Yes |
| PANEL_APP_PORT_WEBRTC_UDP | WebRTC UDP port | 8555 | Yes |

## Persistent data
`CONFIG_PATH` stores Frigate configuration and `STORAGE_PATH` stores recordings.
Back up both directories before an upgrade or migration. The `0.18.3` upgrade
script migrates the legacy RTSP and WebRTC port keys while retaining custom values.

## References
- Website: <https://frigate.video>
- Documentation: <https://frigate.video/docs/>
- Source: <https://github.com/blakeblackshear/frigate>
