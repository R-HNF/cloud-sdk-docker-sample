FROM google/cloud-sdk:321.0.0-slim

RUN apt-get update && apt-get install -y \
    vim

# create and switch to a normal user
ARG USER=sv-user
RUN useradd -ms /bin/bash $USER
USER $USER

# normal user home directory
WORKDIR /home/$USER
# [REQUIRE] prepare a secret key file
COPY sv-secret-key.json $PWD

# [REQUIRE] set the ARG
ARG GCP_PROJECT
ARG SERVICE_ACCOUNT
RUN gcloud auth activate-service-account $SERVICE_ACCOUNT --key-file=$PWD/sv-secret-key.json --project=$GCP_PROJECT && \
    rm $PWD/sv-secret-key.json