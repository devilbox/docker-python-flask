# Python Flask Docker image

[![Build Status](https://travis-ci.com/devilbox/docker-python-flask.svg?branch=master)](https://travis-ci.com/devilbox/docker-python-flask)
[![Tag](https://img.shields.io/github/tag/devilbox/docker-python-flask.svg)](https://github.com/devilbox/docker-python-flask/releases)
[![Gitter](https://badges.gitter.im/devilbox/Lobby.svg)](https://gitter.im/devilbox/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Discourse](https://img.shields.io/discourse/https/devilbox.discourse.group/status.svg?colorB=%234CB697)](https://devilbox.discourse.group)
[![type](https://img.shields.io/badge/type-Docker-blue.svg)](https://hub.docker.com/r/devilbox/python-flask)
[![License](https://img.shields.io/badge/license-MIT-%233DA639.svg)](https://opensource.org/licenses/MIT)

This project provides a Python Flask Docker image for development purposes.

View **[Dockerfile](https://github.com/devilbox/docker-python-flask/blob/master/Dockerfile)** on GitHub.


| Docker Hub | Upstream Project |
|------------|------------------|
| <a href="https://hub.docker.com/r/devilbox/python-flask"><img height="82px" src="http://dockeri.co/image/devilbox/python-flask" /></a> | <a href="https://github.com/cytopia/devilbox" ><img height="82px" src="https://raw.githubusercontent.com/devilbox/artwork/master/submissions_banner/cytopia/01/png/banner_256_trans.png" /></a> |


#### Documentation

In case you seek help, go and visit the community pages.

<table width="100%" style="width:100%; display:table;">
 <thead>
  <tr>
   <th width="33%" style="width:33%;"><h3><a target="_blank" href="https://devilbox.readthedocs.io">Documentation</a></h3></th>
   <th width="33%" style="width:33%;"><h3><a target="_blank" href="https://gitter.im/devilbox/Lobby">Chat</a></h3></th>
   <th width="33%" style="width:33%;"><h3><a target="_blank" href="https://devilbox.discourse.group">Forum</a></h3></th>
  </tr>
 </thead>
 <tbody style="vertical-align: middle; text-align: center;">
  <tr>
   <td>
    <a target="_blank" href="https://devilbox.readthedocs.io">
     <img title="Documentation" name="Documentation" src="https://raw.githubusercontent.com/cytopia/icons/master/400x400/readthedocs.png" />
    </a>
   </td>
   <td>
    <a target="_blank" href="https://gitter.im/devilbox/Lobby">
     <img title="Chat on Gitter" name="Chat on Gitter" src="https://raw.githubusercontent.com/cytopia/icons/master/400x400/gitter.png" />
    </a>
   </td>
   <td>
    <a target="_blank" href="https://devilbox.discourse.group">
     <img title="Devilbox Forums" name="Forum" src="https://raw.githubusercontent.com/cytopia/icons/master/400x400/discourse.png" />
    </a>
   </td>
  </tr>
  <tr>
  <td><a target="_blank" href="https://devilbox.readthedocs.io">devilbox.readthedocs.io</a></td>
  <td><a target="_blank" href="https://gitter.im/devilbox/Lobby">gitter.im/devilbox</a></td>
  <td><a target="_blank" href="https://devilbox.discourse.group">devilbox.discourse.group</a></td>
  </tr>
 </tbody>
</table>


## Docker image tags

* **Image name:** `devilbox/python-flask`

### Rolling tags

Rolling tags are updated and pushed nightly to ensure latest patch-level Python version.

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

| Variable         | Required | Default   | Description |
|------------------|----------|-----------| ------------|
| `FLASK_PROJECT`  | Yes      |           | The sub-directory name under `/shared/httpd/` to serve [1] |
| `FLASK_APP_DIR`  |          | `app`     | The main entrypoint dir name |
| `FLASK_APP_FILE` |          | `main.py` | The main entrypoint file name  |
| `FLASK_PORT`     |          | `3000`    | Docker container internal http port to serve the application |
| `NEW_UID`        |          | `1000`    | User id of the host system to ensure syncronized permissions between host and container |
| `NEW_GID`        |          | `1000`    | Group id of the host system to ensure syncronized permissions between host and container |

* [1] See [Project directory structure](#project-directory-structure) for usage


## Project directory structure

The following shows how to organize your project on the host operating system.

### Basic structure

The following is the least required directory structure:
```bash
<project-dir>/
└── app                      # Entrypoint dir name can be changed via env var [1]
    └── main.py              # Entrypoint file name can be changed via env var [2]
```

* [1] Use the `FLASK_APP_DIR` environment variable to define the dir for the entrypoint in `<project-dir>/app/`. Example: `FLASK_APP_DIR=src`.
* [2] Use the `FLASK_APP_FILE` environment variable to define the file for the entrypoint in `<project-dir>/app/main.py`. Example: `FLASK_APP_FILE=test.py`.


### Structure with dependencies

The following directory structure allows for auto-installing Python dependencies during startup into a virtual env.
```bash
<project-dir>/
├── app                      # Entrypoint dir name can be changed via env var
│   ├── __init__.py
│   └── main.py              # Entrypoint file name can be changed via env var
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
