# Vue 3 Dockerized template

## Features
- [x] Zero app dependencies on host
- [x] Create new app via [create-vue](https://github.com/vuejs/create-vue)
- [x] Dev build with hot-reload

## Requirements
- Git
- Bash
- Fresh docker with compose v2 plugin
- GNU make

## Usage

### Creating new app

Via installer (recommended)
```bash
bash <(curl -s https://raw.githubusercontent.com/CanaryKnight/vue3-dockerized/main/installer.sh) <project_name>
```
or manually
```bash
git clone --branch v0.0.2 git@github.com:CanaryKnight/vue3-dockerized.git vue3-dockerized
cd vue3-dockerized && rm -rf .git && rm -rf installer.sh # remove git & installer from template
make create_app
```

### Running in dev-mode
```bash
make dev
```


## ToDo
- [ ] Fix permissions (for uid/gid != 1000)
- [ ] Configure ports, node version & other params
- [ ] Executables (yarn & etx) from container via make
- [ ] Fix console output
- [ ] Production build
- [ ] ~~Different package managers support~~