ARG REGISTRY

FROM $REGISTRY/alpine-dev:latest
ENV PATH=/root/.cargo/bin:$PATH
ADD source /
RUN wget -O /rustup.sh https://sh.rustup.rs && bash /rustup.sh -yq && rm -f /rustup.sh
CMD ["bash"]
