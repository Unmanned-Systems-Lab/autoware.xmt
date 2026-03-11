# Ansible Collection - autoware.dev_env

This collection contains the playbooks to set up the development environment for Autoware.

## Set up a development environment

### Ansible installation

```bash
# Remove apt installed ansible (In Ubuntu 22.04, ansible the version is old)
sudo apt-get purge ansible

# Install pipx
sudo apt-get -y update
sudo apt-get -y install pipx

# Add pipx to the system PATH
python3 -m pipx ensurepath

# Install ansible
pipx install --include-deps --force "ansible==10.*"
```

### Install ansible collections

This step should be repeated when a new playbook is added.

```bash
cd ~/autoware # The root directory of the cloned repository
ansible-galaxy collection install -f -r "ansible-galaxy-requirements.yaml"
```

## Installation notes

- `ansible-playbook` runs the installed collection under `~/.ansible/collections/ansible_collections/autoware/dev_env`, not the files directly under `./ansible`.
- After changing any local playbook, role, task, default, or helper script, reinstall the collection before rerunning `ansible-playbook` or `./setup-dev-env.sh`.

```bash
cd ~/autoware
ansible-galaxy collection install -f -r "ansible-galaxy-requirements.yaml"
```

- On NVIDIA Jetson platforms, keep the BSP-provided driver stack and skip discrete `cuda-drivers` installation.
- `setup-dev-env.sh` auto-detects Jetson (`aarch64` + Jetson device model) and enables the Jetson-specific `spconv` package selection. Do not force the `-sbsa` package variant on Jetson.
- `agnocast-kmod` is skipped on kernels that do not have matching `linux-headers` packages available. This is expected on some Jetson kernels such as `5.15.148-tegra`.
- The CUDA role prefers local Vulkan and EGL vendor manifests when they already exist on the machine. This avoids failures caused by external manifest downloads and is the expected path on Jetson images.
