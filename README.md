# Autoware - the world's leading open-source software project for autonomous driving

![Autoware_RViz](https://user-images.githubusercontent.com/63835446/158918717-58d6deaf-93fb-47f9-891d-e242b02cba7b.png)

<!--- Contributors -->
<p align="center">
    <a href="https://github.com/autowarefoundation/autoware_universe/graphs/contributors">
        <img src="https://img.shields.io/github/contributors/autowarefoundation/autoware_universe?style=flat&label=Autoware%20Universe%20Contributors"
            alt="Autoware Universe Contributors" /></a>
    <a href="https://github.com/autowarefoundation/autoware/graphs/contributors">
        <img src="https://img.shields.io/github/contributors/autowarefoundation/autoware?style=flat&label=Autoware%20Contributors"
            alt="Autoware Contributors" /></a>
</p>

<!--- Commit Activity -->
<p align="center">
    <a href="https://github.com/autowarefoundation/autoware_universe/pulse">
        <img src="https://img.shields.io/github/commit-activity/m/autowarefoundation/autoware_universe?style=flat&label=Autoware%20Universe%20Commit%20Activity"
            alt="Autoware Universe Activity" /></a>
    <a href="https://github.com/autowarefoundation/autoware/pulse">
        <img src="https://img.shields.io/github/commit-activity/m/autowarefoundation/autoware?style=flat&label=Autoware%20Commit%20Activity"
            alt="Autoware Activity" /></a>
</p>

<!--- License -->
<p align="center">
    <a href="https://github.com/autowarefoundation/autoware/blob/main/LICENSE">
        <img src="https://img.shields.io/github/license/autowarefoundation/autoware?style=flat&label=License"
            alt="License" /></a>
</p>

<!--- CI Reports -->
<p align="center">
    <a href="https://github.com/autowarefoundation/autoware/actions/workflows/health-check.yaml?query=branch%3Amain">
        <img src="https://img.shields.io/github/actions/workflow/status/autowarefoundation/autoware/health-check.yaml?style=flat&label=health-check"
            alt="health-check CI" /></a>
    <a href="https://app.codecov.io/gh/autowarefoundation/autoware_universe">
        <img src="https://img.shields.io/codecov/c/gh/autowarefoundation/autoware_universe?style=flat&label=Coverage&logo=codecov&logoColor=white"
            alt="Code Coverage" /></a>
</p>

<!--- Social Media -->
<p align="center">
    <a href="https://discord.gg/Q94UsPvReQ">
        <img src="https://img.shields.io/discord/953808765935816715?logo=discord&logoColor=white&style=flat&label=Autoware%20Discord"
            alt="Autoware Discord"></a>
    <a href="https://twitter.com/intent/follow?screen_name=AutowareFdn">
        <img src="https://img.shields.io/twitter/follow/AutowareFdn?logo=x&logoColor=white&style=flat"
            alt="Autoware Twitter / X"></a>
    <a href="https://www.linkedin.com/company/the-autoware-foundation/">
        <img src="https://img.shields.io/badge/Linkedin-Autoware%20Foundation-0a66c2?logo=linkedin&logoColor=white&style=flat"
            alt="Autoware Linkedin"></a>
</p>

Autoware is an open-source software stack for self-driving vehicles, built on the [Robot Operating System (ROS)](https://www.ros.org/). It includes all of the necessary functions to drive an autonomous vehicles from localization and object detection to route planning and control, and was created with the aim of enabling as many individuals and organizations as possible to contribute to open innovations in autonomous driving technology.

![Autoware architecture](https://static.wixstatic.com/media/984e93_552e338be28543c7949717053cc3f11f~mv2.png/v1/crop/x_0,y_1,w_1500,h_879/fill/w_863,h_506,al_c,usm_0.66_1.00_0.01,enc_auto/Autoware-GFX_edited.png)

## Documentation

To learn more about using or developing Autoware, refer to the [Autoware documentation site](https://autowarefoundation.github.io/autoware-documentation/main/). You can find the source for the documentation in [autowarefoundation/autoware-documentation](https://github.com/autowarefoundation/autoware-documentation).

## Autoware Universe 安装注意事项

以下内容基于近期与安装相关的提交记录和当前仓库文档整理，适合在开始 `Autoware Universe` 源码安装前快速检查：

- `autoware` 仓库本身只是 meta-repository，不包含完整源码。先安装 `python3-vcs2l`，再执行 `vcs import src < repositories/autoware.repos`；只克隆本仓库无法完成构建。
- 推荐从仓库根目录运行 `./setup-dev-env.sh universe`。脚本默认按 `humble` 准备环境，如需 `jazzy` 请显式加 `--ros-distro jazzy`。当前分支只支持 Ubuntu `22.04` 和 `24.04`。
- 如果手工运行 Ansible，不要使用 Ubuntu 自带的旧版 `ansible`，而应使用 `pipx install --include-deps --force "ansible==10.*"`。另外，`ansible-playbook` 实际执行的是安装到 `~/.ansible/collections/...` 的 collection；本地改动了 `ansible/` 下的 playbook、role、task 或脚本后，必须重新执行 `ansible-galaxy collection install -f -r "ansible-galaxy-requirements.yaml"`。
- 很多 Universe 模块依赖 CUDA、TensorRT 和 `spconv`。若使用 `--no-nvidia` 跳过这些角色，对应功能不会可用。x86 平台请确认 CUDA `12.8` 与兼容驱动；Jetson 平台应保留 BSP 自带驱动栈，不要额外安装 `cuda-drivers`。
- ARM64 需要区分普通 SBSA 服务器与 Jetson。Jetson 必须使用 `-jetson` 版本的 `cumm/spconv` 包，不能强行使用 `-sbsa`；`setup-dev-env.sh` 已会自动检测 Jetson 并设置 `spconv_is_jetson=true`。
- 感知模型和其他 artifacts 默认下载到 `~/autoware_data`。如果你在 `main` 上只同步了 `repositories/autoware.repos`，下载 artifacts 前通常需要切到最新 release tag；下载器支持重试、断点续传和校验，失败后可直接重跑。
- 安装开发工具后，记得执行 `git lfs install`，否则部分大文件只会以 LFS 指针文件形式存在。
- `acados` 已纳入 Universe 环境配置。安装完成后会把 `CMAKE_PREFIX_PATH`、`ACADOS_SOURCE_DIR` 和 `LD_LIBRARY_PATH` 写入 `.bashrc`；重新打开终端或 `source ~/.bashrc` 后再构建更稳妥。若某些包在构建阶段使用 `acados_template`，应显式使用 `/opt/acados/.venv/bin/python3`。
- 在 `humble` + 某些 Jetson 内核（例如 `5.15.148-tegra`）上，`agnocast-kmod` 可能因缺少匹配的 `linux-headers` 被自动跳过，这通常是预期行为，不等同于整个环境安装失败。

详细说明可继续参考：

- [源码导入说明](src/README.md)
- [Ansible 安装与 collection 刷新说明](ansible/README.md)
- [artifacts 下载说明](ansible/roles/artifacts/README.md)
- [`spconv` 平台差异说明](ansible/roles/spconv/README.md)
- [`acados` 说明](ansible/roles/acados/README.md)

## Repository overview

- [autowarefoundation/autoware](https://github.com/autowarefoundation/autoware)
  - Meta-repository containing `.repos` files to construct an Autoware workspace.
  - It is anticipated that this repository will be frequently forked by users, and so it contains minimal information to avoid unnecessary differences.
- [autowarefoundation/autoware_core](https://github.com/autowarefoundation/autoware_core)
  - Main repository for high-quality, stable ROS packages for Autonomous Driving.
  - Based on [Autoware.Auto](https://gitlab.com/autowarefoundation/autoware.auto/AutowareAuto) and [Autoware.Universe](https://github.com/autowarefoundation/autoware_universe).
- [autowarefoundation/autoware_universe](https://github.com/autowarefoundation/autoware_universe)
  - Repository for experimental, cutting-edge ROS packages for Autonomous Driving.
  - Autoware Universe was created to make it easier for researchers and developers to extend the functionality of Autoware Core
- [autowarefoundation/autoware_launch](https://github.com/autowarefoundation/autoware_launch)
  - Launch configuration repository containing node configurations and their parameters.
- [autowarefoundation/autoware-github-actions](https://github.com/autowarefoundation/autoware-github-actions)
  - Contains [reusable GitHub Actions workflows](https://docs.github.com/ja/actions/learn-github-actions/reusing-workflows) used by multiple repositories for CI.
  - Utilizes the [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) concept.
- [autowarefoundation/autoware-documentation](https://github.com/autowarefoundation/autoware-documentation)
  - Documentation repository for Autoware users and developers.
  - Since Autoware Core/Universe has multiple repositories, a central documentation repository is important to make information accessible from a single place.

## Using Autoware.AI

If you wish to use Autoware.AI, the previous version of Autoware based on ROS 1, switch to [autoware-ai](https://github.com/autowarefoundation/autoware_ai) repository. However, be aware that Autoware.AI has reached the end-of-life as of 2022, and we strongly recommend transitioning to Autoware Core/Universe for future use.

## Contributing

- [There is no formal process to become a contributor](https://github.com/autowarefoundation/autoware-projects/wiki#contributors) - you can comment on any [existing issues](https://github.com/autowarefoundation/autoware_universe/issues) or make a pull request on any Autoware repository!
  - Make sure to follow the [Contribution Guidelines](https://autowarefoundation.github.io/autoware-documentation/main/contributing/).
  - Take a look at Autoware's [various working groups](https://github.com/autowarefoundation/autoware-projects/wiki#working-group-list) to gain an understanding of any work in progress and to see how projects are managed.
- If you have any technical questions, you can start a discussion in the [Q&A category](https://github.com/autowarefoundation/autoware/discussions/categories/q-a) to request help and confirm if a potential issue is a bug or not.

## Useful resources

- [Autoware Foundation homepage](https://www.autoware.org/)
- [Support guidelines](https://autowarefoundation.github.io/autoware-documentation/main/support/support-guidelines/)
- [CI metrics](https://autowarefoundation.github.io/autoware-ci-metrics/)
