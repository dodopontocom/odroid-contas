#!/bin/bash

gcloud.verify() {
    gcloud auth activate-service-account --key-file=${GCLOUD_SA_KEY_PATH}
    gcloud config set project ${GCLOUD_PROJECT_ID}

}