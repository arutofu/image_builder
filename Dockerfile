FROM debian:buster

RUN apt-get update && \
    apt-get install -y debootstrap qemu-user-static binfmt-support

COPY builder /builder

WORKDIR /builder

CMD ["bash", "image-build.sh"]
