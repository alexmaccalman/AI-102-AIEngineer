# syntax=docker/dockerfile:1

FROM debian:bullseye-slim as dotnet

ENV \
    # DOTNET_TARBALL
    DOTNET_TARBALL=dotnet.tar.gz \
    # SDK Root
    DOTNET_ROOT=/usr/share/dotnet \
    # SDK version
    DOTNET_SDK_VERSION=6.0.400 \
    # Invariant mode
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

ENV \
    # Pre-set PATH
    PATH=${DOTNET_ROOT}:${PATH}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        wget \
    && apt-get purge -y --auto-remove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/*

# Install .NET SDK
RUN ARCH= && SHA512= && dpkgArch="$(dpkg --print-architecture)" \
    && case "${dpkgArch##*-}" in \
      amd64) ARCH='x64' \
	  		 SHA512='8decbba0a6b09501daede52cbb5a9ae9e5f31ade201918c03efcd1b4cc345ec934f88321704ec3beb1f90f2204934be7259c76f66d9204cbdd15933582602763';; \
      ppc64el) ARCH='ppc64le';; \
      s390x) ARCH='s390x';; \
      arm64) ARCH='arm64' \
	         SHA512='a21010f9e0e091bf0a4df9dfc4ec9893c056c2b07b10be093ea392a4fa5c8a38bad9535f66e570b45dc25165b685199fb729434b845bcfb35f8b79cceb22c632';; \
      armhf) ARCH='armv' \
	         SHA512='a72aa70bfb15e21a20ddd90c2c3e37acb53e6f1e50f5b6948aac616b28f80ac81e1157e8db5688e21dc9a7496011ef0fcf06cdca74ddc7271f9a1c6268f4b1b2';; \
      i386) ARCH='x86';; \
      *) echo "unsupported architecture"; exit 1 ;; \
    esac \
    && set -ex \
	&& curl -fSL --output ${DOTNET_TARBALL} https://dotnetcli.azureedge.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-$ARCH.tar.gz \
    && dotnet_sha512=$SHA512 \
    && echo "$dotnet_sha512  ${DOTNET_TARBALL}" | sha512sum -c - \
    && mkdir -p ${DOTNET_ROOT} \
    && tar -oxzf ${DOTNET_TARBALL} -C ${DOTNET_ROOT} \
    && rm ${DOTNET_TARBALL} \
    # # Trigger first run experience by running arbitrary cmd
    && dotnet help


#########################
# Node.JS
# FROM debian:bullseye-slim
FROM dotnet AS node.js

RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

ENV NODE_VERSION 16.10.0

RUN ARCH= && dpkgArch="$(dpkg --print-architecture)" \
    && case "${dpkgArch##*-}" in \
      amd64) ARCH='x64';; \
      ppc64el) ARCH='ppc64le';; \
      s390x) ARCH='s390x';; \
      arm64) ARCH='arm64';; \
      armhf) ARCH='armv7l';; \
      i386) ARCH='x86';; \
      *) echo "unsupported architecture"; exit 1 ;; \
    esac \
    && set -ex \
    # libatomic1 for arm
	&& savedAptMark="$(apt-mark showmanual)" \
    && apt-get update && apt-get install -y ca-certificates curl wget gnupg dirmngr xz-utils libatomic1 --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && for key in \
      4ED778F539E3634C779C87C6D7062848A1AB005C \
      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
      74F12602B6F1C4E913FAA37AD3A89613643B6201 \
      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
      8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
      DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
      A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
      108F52B48DB57BB0CC439B2997B01419BD92F80A \
      B9E2F5981AA6E0CD28160D9FF13993A75599653C \
    ; do \
      gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
      gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
    done \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
    && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
    && apt-mark auto '.*' > /dev/null \
	&& apt-mark manual $savedAptMark \
    && find /usr/local -type f -executable -exec ldd '{}' ';' \
      | awk '/=>/ { print $(NF-1) }' \
      | sort -u \
      | xargs -r dpkg-query --search \
      | cut -d: -f1 \
      | sort -u \
      | xargs -r apt-mark manual \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
    # smoke tests
    && node --version \
    && npm --version



##### Python instead of (Mini)Conda
#########################
# Python 3.9
#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

# FROM debian:bullseye-slim
FROM node.js AS python

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# runtime dependencies
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		netbase \
		tzdata \
	; \
	rm -rf /var/lib/apt/lists/*

ENV GPG_KEY E3FF2839C048B25C084DEBE9B26995E310250568
ENV PYTHON_VERSION 3.9.13

RUN set -eux; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		dpkg-dev \
		gcc \
		gnupg dirmngr \
		libbluetooth-dev \
		libbz2-dev \
		libc6-dev \
		libexpat1-dev \
		libffi-dev \
		libgdbm-dev \
		liblzma-dev \
		libncursesw5-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev \
		make \
		tk-dev \
		uuid-dev \
		wget \
		xz-utils \
		zlib1g-dev \
	; \
	\
	wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz"; \
	wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc"; \
	GNUPGHOME="$(mktemp -d)"; export GNUPGHOME; \
	gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$GPG_KEY"; \
	gpg --batch --verify python.tar.xz.asc python.tar.xz; \
	command -v gpgconf > /dev/null && gpgconf --kill all || :; \
	rm -rf "$GNUPGHOME" python.tar.xz.asc; \
	mkdir -p /usr/src/python; \
	tar --extract --directory /usr/src/python --strip-components=1 --file python.tar.xz; \
	rm python.tar.xz; \
	\
	cd /usr/src/python; \
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
	./configure \
		--build="$gnuArch" \
		--enable-loadable-sqlite-extensions \
		--enable-optimizations \
		--enable-option-checking=fatal \
		--enable-shared \
		--with-system-expat \
		--without-ensurepip \
	; \
	nproc="$(nproc)"; \
	make -j "$nproc" \
		LDFLAGS="-Wl,--strip-all" \
	; \
	make install; \
	\
	cd /; \
	rm -rf /usr/src/python; \
	\
	find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
			-o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name 'libpython*.a' \) \) \
		\) -exec rm -rf '{}' + \
	; \
	\
	ldconfig; \
	\
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec ldd '{}' ';' \
		| awk '/=>/ { print $(NF-1) }' \
		| sort -u \
		| xargs -r dpkg-query --search \
		| cut -d: -f1 \
		| sort -u \
		| xargs -r apt-mark manual \
	; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*; \
	\
	python3 --version

# make some useful symlinks that are expected to exist ("/usr/local/bin/python" and friends)
RUN set -eux; \
	for src in idle3 pydoc3 python3 python3-config; do \
		dst="$(echo "$src" | tr -d 3)"; \
		[ -s "/usr/local/bin/$src" ]; \
		[ ! -e "/usr/local/bin/$dst" ]; \
		ln -svT "$src" "/usr/local/bin/$dst"; \
	done

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 22.0.4
# https://github.com/docker-library/python/issues/365
ENV PYTHON_SETUPTOOLS_VERSION 58.1.0
# https://github.com/pypa/get-pip
ENV PYTHON_GET_PIP_URL https://github.com/pypa/get-pip/raw/aeca83c7ba7f9cdfd681103c4dcbf0214f6d742e/public/get-pip.py
ENV PYTHON_GET_PIP_SHA256 d0b5909f3ab32dae9d115aa68a4b763529823ad5589c56af15cf816fca2773d6

RUN set -eux; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends wget; \
	\
	wget -O get-pip.py "$PYTHON_GET_PIP_URL"; \
	echo "$PYTHON_GET_PIP_SHA256 *get-pip.py" | sha256sum -c -; \
	\
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*; \
	\
	export PYTHONDONTWRITEBYTECODE=1; \
	\
	python get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
		--no-compile \
		"pip==$PYTHON_PIP_VERSION" \
		"setuptools==$PYTHON_SETUPTOOLS_VERSION" \
	; \
	rm -f get-pip.py; \
	\
	pip --version



# #########################
# # Miniconda3
# # FROM debian:bullseye-slim
# FROM node.js AS miniconda

# LABEL maintainer="Anaconda, Inc"

# ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# # hadolint ignore=DL3008
# RUN apt-get update -q && \
#     apt-get install -q -y --no-install-recommends \
#         bzip2 \
#         ca-certificates \
#         curl \
#         git \
#         libglib2.0-0 \
#         libsm6 \
#         libxext6 \
#         libxrender1 \
#         mercurial \
#         openssh-client \
#         procps \
#         subversion \
#         wget \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# ENV PATH /opt/conda/bin:$PATH

# # ENV \
# #     # Pre-set PATH
# #     PATH=${DOTNET_ROOT}:${PATH}

# CMD [ "/bin/bash" ]

# # Leave these args here to better use the Docker build cache
# ARG CONDA_VERSION=py39_4.12.0

# RUN set -x && \
#     UNAME_M="$(uname -m)" && \
#     if [ "${UNAME_M}" = "x86_64" ]; then \
#         MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh"; \
#         SHA256SUM="78f39f9bae971ec1ae7969f0516017f2413f17796670f7040725dd83fcff5689"; \
#     elif [ "${UNAME_M}" = "s390x" ]; then \
#         MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-s390x.sh"; \
#         SHA256SUM="ff6fdad3068ab5b15939c6f422ac329fa005d56ee0876c985e22e622d930e424"; \
#     elif [ "${UNAME_M}" = "aarch64" ]; then \
#         MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-aarch64.sh"; \
#         SHA256SUM="5f4f865812101fdc747cea5b820806f678bb50fe0a61f19dc8aa369c52c4e513"; \
#     elif [ "${UNAME_M}" = "ppc64le" ]; then \
#         MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-ppc64le.sh"; \
#         SHA256SUM="1fe3305d0ccc9e55b336b051ae12d82f33af408af4b560625674fa7ad915102b"; \
#     fi && \
#     wget "${MINICONDA_URL}" -O miniconda.sh -q && \
#     echo "${SHA256SUM} miniconda.sh" > shasum && \
#     if [ "${CONDA_VERSION}" != "latest" ]; then sha256sum --check --status shasum; fi && \
#     mkdir -p /opt && \
#     sh miniconda.sh -b -p /opt/conda && \
#     rm miniconda.sh shasum && \
#     ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
#     echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
#     echo "conda activate base" >> ~/.bashrc && \
#     find /opt/conda/ -follow -type f -name '*.a' -delete && \
#     find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
#     /opt/conda/bin/conda clean -afy


# FROM miniconda AS python-packages
FROM python AS python-packages

RUN pip install flask requests python-dotenv pylint matplotlib pillow && \
    pip install --upgrade numpy



FROM python-packages AS azure-cli

ENV INSTALL_SCRIPT_URL="https://azurecliprod.blob.core.windows.net/install.py" \
	INSTALL_SCRIPT_SHA256=7869d3c46992852525b8f9e4c63e34edd2d29cafed9e16fd94d5356665eefdfd

RUN set -eux; \
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		gcc \
		python3-dev \
	; \
	curl -L https://aka.ms/InstallAzureCli | sed 's/\($python_cmd $install_script\)\( < $_TTY\)/printf \"\/usr\/local\/lib\/azure-cli\\n\/usr\/local\/bin\\n\" \| \1/g' | bash; \
	# install_script=$(mktemp -t azure_cli_install_tmp_XXXXXX) || exit; \
	# echo "Downloading Azure CLI install script from $INSTALL_SCRIPT_URL to $install_script."; \
	# curl -# $INSTALL_SCRIPT_URL > $install_script || exit ; \
	# if command -v sha256sum >/dev/null 2>&1; \
	# then \
	# 	echo "$INSTALL_SCRIPT_SHA256  $install_script" | sha256sum -c - || exit; \
	# elif command -v shasum >/dev/null 2>&1; \
	# then \
	# 	echo "$INSTALL_SCRIPT_SHA256  $install_script" | shasum -a 256 -c - || exit; \
	# fi; \
	# \
	# python_cmd=python3; \
	# if ! command -v python3 >/dev/null 2>&1; \
	# then \
	# 	if command -v python >/dev/null 2>&1; \
	# 	then \
	# 		python_cmd=python; \
	# 	else \
	# 		echo "ERROR: python3 or python not found." ;\
	# 		echo "If python is available on the system, add it to PATH." ;\
	# 		exit 1; \
	# 	fi; \
	# fi; \
	# \
	# chmod 775 $install_script; \
	# echo "Running install script."; \
	# printf "/usr/local/lib/azure-cli\n/usr/local/bin\n" | $python_cmd $install_script; \
	\
	apt-get remove -y gcc python3-dev; \
	apt-get autoremove -y; \
	rm -rf /var/lib/apt/lists/*; \
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
	find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec ldd '{}' ';' \
		| awk '/=>/ { print $(NF-1) }' \
		| sort -u \
		| xargs -r dpkg-query --search \
		| cut -d: -f1 \
		| sort -u \
		| xargs -r apt-mark manual \
	; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*;

# INSTALL POWERSHELL
# Install system components
RUN apt update  && apt install -y curl gnupg apt-transport-https

# Import the public repository GPG keys
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

# Register the Microsoft Product feed
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" > /etc/apt/sources.list.d/microsoft.list'

# Install PowerShell
RUN apt update && apt install -y powershell

