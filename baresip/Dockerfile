ARG IMAGE=ghcr.io/baresip/docker/libre:latest
FROM ${IMAGE}
ARG VERSION=v3.16.0
ARG REPO=https://github.com/baresip/baresip.git
ARG BUILD_VARIANT=Release
RUN install_packages clang-15 libopus-dev libasound2-dev libmosquitto-dev libspandsp-dev libpulse-dev ffmpeg
WORKDIR /root/
RUN git clone -b ${VERSION} --depth=1 ${REPO} && \
    cd baresip && \
    cmake -B build -DCMAKE_BUILD_TYPE=${BUILD_VARIANT} -DCMAKE_C_FLAGS="-g" -DCMAKE_CXX_FLAGS="-g" -DCMAKE_C_COMPILER=clang-15 \
        -DCMAKE_CXX_COMPILER=clang++-15 -DCMAKE_INSTALL_PREFIX=/usr && \
    cmake --build build -j && \
    cmake --install build --prefix dist && cp -a dist/* /usr/

RUN mkdir -p /root/dist/usr && \
    cp -a /root/re/dist/* /root/dist/usr/ && \
    cp -a /root/baresip/dist/* /root/dist/usr/

WORKDIR /root/dist/usr/share/baresip
RUN mkdir 48000-2ch
RUN for i in *.wav; do ffmpeg -i "$i" -ar 48000 -ac 2 ./48000-2ch/"${i%.*}.wav"; done

# --- Final build image ---
FROM bitnami/minideb:bookworm
RUN install_packages libopus0 ca-certificates openssl libasound2 libmosquitto1 libspandsp2 libpulse0 pulseaudio
COPY --from=0 /root/dist/usr/ /usr/
RUN mkdir /usr/baresip_modules/
RUN find /usr/lib/*/baresip/modules -name '*.so' -exec cp {} /usr/baresip_modules/ \;
WORKDIR /root
USER root
ENV USER=root
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["baresip"]
