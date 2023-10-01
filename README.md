# Vue 3 Dockerized template

## Features
- [x] Zero app dependencies on host
- [x] Dev build with hot-reload

## Requirements
- Git
- Bash
- Fresh docker with compose plugin

## Usage

### Creating new app
```bash
git clone git@github.com:CanaryKnight/vue3-dockerized.git
rm -rf .git # remove git from template
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
- [ ] Different package managers support