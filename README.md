# Python Flask Docker image

[![Build Status](https://travis-ci.org/devilbox/docker-python-flask.svg?branch=master)](https://travis-ci.org/devilbox/docker-python-flask)
[![Tag](https://img.shields.io/github/tag/devilbox/docker-python-flask.svg)](https://github.com/devilbox/docker-python-flask/releases)
[![Gitter](https://badges.gitter.im/devilbox/Lobby.svg)](https://gitter.im/devilbox/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Discourse](https://img.shields.io/discourse/https/devilbox.discourse.group/status.svg?colorB=%234CB697)](https://devilbox.discourse.group)
[![type](https://img.shields.io/badge/type-Docker-blue.svg)](https://hub.docker.com/r/devilbox/python-flask)
[![License](https://img.shields.io/badge/license-MIT-%233DA639.svg)](https://opensource.org/licenses/MIT)

This project provides a Python Flask Docker image for development purposes.


## Docker image tags

* **Image name:** `devilbox/python-flask`

### Rolling tags

| Image tag | Python version |
|-----------|----------------|
| `3.8-dev` | Latest 3.8.x   |
| `3.7-dev` | Latest 3.7.x   |
| `3.6-dev` | Latest 3.6.x   |
| `3.5-dev` | Latest 3.5.x   |
| `2.7-dev` | Latest 2.7.x   |


### Release tags

Release tags are fixed and bound to git tags.

| Image Tag           | Python version |
|---------------------|----------------|
| `3.8-dev-<git-tag>` | Latest 3.8.x   |
| `3.7-dev-<git-tag>` | Latest 3.7.x   |
| `3.6-dev-<git-tag>` | Latest 3.6.x   |
| `3.5-dev-<git-tag>` | Latest 3.5.x   |
| `2.7-dev-<git-tag>` | Latest 2.7.x   |


## Example

For easy usage, there is a Docker Compose example project included.
```bash
cp .env.example .env
docker-compose up
```
```bash
curl localhost:3000
```


## Environment Variables

| Variable        | Required | Description |
|-----------------|----------|-------------|
| `FLASK_PROJECT` | Yes      | The directory name in `/shared/httpd/` to serve [1] |
| `FLASK_APP`     |          | The main entrypoint file name (default is `main.py`) |
| `FLASK_PORT`    |          | Docker internal port to serve the application (default is `3000`) |
| `NEW_UID`       |          | User id of the host system to ensure syncronized permissions between host and container |
| `NEW_GID`       |          | Group id of the host system to ensure syncronized permissions between host and container |

* [1] See [Project directory structure](#project-directory-structure) for usage


## Project directory structure

The following shows how to organize your project on the host operating system.

### Basic structure

The following is the least required directory structure:
```bash
<project-dir>/
└── app                      # Must be named 'app'
    └── main.py              # Entrypoint name can be changed via env var [1]
```

* [1] Use the `FLASK_APP` environment variable to defined the file for the entrypoint in `<project-dir>/app/`. Example: `FLASK_APP=test.py`.


### Structure with dependencies

The following directory structure allows for auto-installing Python dependencies during startup into a virtual env.
```bash
<project-dir>/
├── app                      # Must be named 'app'
│   ├── __init__.py
│   └── main.py              # Entrypoint name can be changed via env var
└── requirements.txt         # Optional: will pip install in virtual env
```

After you've started the container with a `requirements.txt` in place, a new `venv/` directory will be added with you Python virtual env.
```bash
<project-dir>/
├── app
│   ├── __init__.py
│   ├── main.py
│   └── __pycache__
├── requirements.txt
└── venv
    ├── bin
    ├── include
    └── lib
```

### Mounting your project

When using this image, you need to mount your project directory into `/shared/httpd/` into the container:
```bash
docker run \
  --rm \
  -v $(pwd)/<project-dir>:/shared/httpd/<project-dir> \
  devilbox/python-flask:3.9-dev
```

If your local uid or gid are not 1000, you should set them accordingly via env vars to ensure to syncronize file system permissions across the container and your host system.
```bash
docker run \
  --rm \
  -v $(pwd)/<project-dir>:/shared/httpd/<project-dir> \
  -e NEW_UID=$(id -u) \
  -e NEW_GID=$(id -g) \
  devilbox/python-flask:3.9-dev
```


## Build locally
```bash
# Build default version (Python 3.8)
make build

# Build specific version
make build PYTHON=3.7
```


## Test locally
```bash
# Test default version (Python 3.8)
make test

# Test specific version
make test PYTHON=3.7
```


## License

**[MIT License](LICENSE)**

Copyright (c) 2019 [cytopia](https://github.com/cytopia)
