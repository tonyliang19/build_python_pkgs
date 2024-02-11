# ARGS for docker
IMAGE_NAME ?= py_comp
DKF=python_compile_pkg.Dockerfile
# Parameter to specify which package to build
PY_PKG_SRC=mogonet
# ------------------------------------------------
# Other parameters
SHELL=/bin/bash
# Targets to build

help:
	@echo "Run 'make build' to build the docker image"
	@echo "Run 'make run' to instantiate docker container"
	@echo "Run 'make upload' to publish bundled package
	@echo "Run 'make clean' to clear built stuff"

# Docker related ------------------------------------------------
build: ${DKF}
	docker build -t ${IMAGE_NAME} \
		--build-arg PY_PKG_SRC=${PY_PKG_SRC} \
		-f ${DKF} .
	@(docker rmi $$(docker images -q -f dangling=true) 2>/dev/null) || (echo "No image to delete" && exit 1)

run:
	docker run -it --rm ${IMAGE_NAME}

# Python pkg related -------------------------------------------
bundle:
	@echo "Bundling the code"; echo
	@python3 -m build

upload: bundle
	@echo "Uploading built package to PyPI"
	@python3 -m twine upload dist/*

clean:
	@echo "Removing the build/ dist/ and *.egg-info/ directories"
	@rm -rf build dist *.egg-info

