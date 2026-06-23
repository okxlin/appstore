# MT Photos AI 识别相关任务独立部署项目

- 基于 PaddleOCR 实现的文本识别（OCR）接口
- 基于 Chinese-CLIP（OpenAI CLIP 模型的中文版本）实现的图片、文本提取特征接口

## 版本说明

- `latest` / `1.2.1`：官方镜像，默认不强制绑定 GPU，适合普通 CPU 环境安装。
- `latest-onnx`：官方 ONNX 镜像，不强制绑定 GPU。
- `latest-cuda`：官方镜像的 CUDA/GPU 配置版本，宿主机需要已安装 NVIDIA 驱动、NVIDIA Container Toolkit，并且 Docker/Compose 能正常申请 GPU。

## 安全提示

当前官方镜像基于 Ubuntu 22.04/OpenVINO 运行环境。维护测试中使用 Trivy 对 `mtphotos/mt-photos-ai:1.2.1` 扫描到 Critical/High 级别依赖风险，主要来自基础系统包、Python 图像/模型处理依赖和 `linux-libc-dev`。建议仅在可信内网中使用，并关注上游镜像更新。
