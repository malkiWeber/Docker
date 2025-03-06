#!/bin/bash

# Function to handle errors
handle_error() {
  echo "Error: $1"
  exit 1
}

# Get version from user
read -p "Enter version: " version

# Get commit hash from user
read -p "Enter commit hash: " commit_hash

# Check if image exists
if docker image inspect chat-app:$version >/dev/null 2>&1; then
  read -p "Image chat-app:$version already exists. Do you want to rebuild? [y/n]: " rebuild
  if [ "$rebuild" == "y" ]; then
    # Delete existing image
    docker image rm chat-app:$version || handle_error "Failed to delete existing image"
  else
    echo "Using existing image chat-app:$version"
    exit 0
  fi
fi

# Tag the commit
git tag "$version" "$commit_hash" || handle_error "Failed to tag the commit"

# Build the image
docker build -t chat-app:$version . || handle_error "Failed to build the image"

# Push the tag to GitHub repository
git push origin "$version" || handle_error "Failed to push to GitHub"

# Success message
echo "Deployment successful!"

# Ask the user if they want to push the image to the Artifact Registry repository.
echo "Do you want to push the image to the Artifact Registry repository? (y/n)"
read -r PUSH_IMAGE

# If the user chooses to push the image, do so using service account impersonation.
if [ "$PUSH_IMAGE" = "y" ]; then
    appname="chat-app"
    # Push the Docker image to Artifact Registry (optional)
    echo "Pushing Docker image to artifactregistry"
    gcloud config set auth/impersonate_service_account artifact-admin-sa@grunitech-mid-project.iam.gserviceaccount.com  
    gcloud auth configure-docker me-west1-docker.pkg.dev

    # Define image_name and artifact_registry_image variables
    image_name="chat-app:$version"  # Use the image name and version you want to tag
    artifact_registry_image="me-west1-docker.pkg.dev/grunitech-mid-project/tovaz-chat-app-images/${appname}:${version}"  # Replace with your actual target image

    # Tag the image
    docker tag "$image_name" "$artifact_registry_image"

    # Push the tagged image to the Artifact Registry
    docker push "$artifact_registry_image"

    gcloud config set auth/impersonate_service_account tovaz-instance-sa@grunitech-mid-project.iam.gserviceaccount.com  
fi

echo "Deployment completed successfully."
