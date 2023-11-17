# Build, Push Python Package in Docker container with Make

This repo is to store useful [Makefile](./Makefile) that could build a containerized environment with Docker with available tools to bundle and push any python packages to PyPi.

## Requirements

- Docker in your host machine
- Make (optional) in your host machine
- `.pypirc` inside the cloned repo
## Workflow

1. Follow the [building python package doc](./build_python_pkg.md) to have a self-contained structure python package following the syntax from [PPUG](https://packaging.python.org/en/latest/tutorials/packaging-projects/)

2. Change some arguments in the [Makefile](./Makefile) like below:

    ```bash
    IMAGE_NAME ?= <your_preferred_name_of_built_docker_image>
    # This image could be published to dockerhub as well
    # but requires extra step to set username and password, then push
    # ---------------------------------------------------------------
    # Inside this dir, you should have at least one of setup.py or pyprojec.toml 
    PY_PKG_SRC=<the_dir_name_that_contains_the_package>
    ```

3. Prepare a `.pypirc` file, you could follow a guide from [PPUG](https://packaging.python.org/en/latest/specifications/pypirc/#using-a-pypi-token) again. If you dont like it, you could created it the like the following:

    ```bash
    # Assuming this in a file called .pypirc, which is in same directory of the cloned repo (inside)
    [disutils]
    index-servers =
        pypi
        testpypi
    
    [pypi]
    username = __token__ # This is needed to be __token__ when using API token
    password = <api_token_that_you_get_from_pypi>
    repository = https://upload.pypi.org/legacy/
    ```

4. Run `make build` to build the image that could used to bundle and compile the python package from source
    > This command needs to ran everytime when you change a package.

5. Run `make run` to instantiate a docker container with bash in it. **NOTE**: you need to install docker first

6. Now inside the container, you could run `make upload`, which triggers `make bundle` for compiling your python package to `dist/*`, and uploaded to PyPi with twine.
