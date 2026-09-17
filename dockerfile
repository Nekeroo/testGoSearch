# ------------------------------------------------
# 1. Build GoSearch
# ------------------------------------------------
FROM golang:1.25-bookworm AS builder

RUN go install github.com/ibnaleem/gosearch@latest

# ------------------------------------------------
# 2. Runtime avec terminal Web
# ------------------------------------------------
FROM tsl0922/ttyd:1.7.8

USER root

RUN apt-get update \
    && apt-get install -y ca-certificates bash \
    && update-ca certificates \
    && rm -rf /var/lib/apt/lists/*

# On récupère le binaire compilé
COPY --from=builder /go/bin/gosearch /usr/local/bin/gosearch

# Port HTTP utilisé par ttyd
EXPOSE 7681

WORKDIR /workspace

# -W = terminal modifiable
# bash = ouvre un vrai terminal dans le navigateur
CMD ["ttyd", "-W", "-p", "7681", "bash"]
