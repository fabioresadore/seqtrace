## seqtrace-xfce

#### Easy script to build and run a Docker container with an XFCE environment accessible via  VNC web interface at http://localhost:6080/vnc_lite.html


Place the files to be read by seqtrace inside the `files` folder, and they will appear in the Docker container in the `/root/Desktop/files/` 


Prerequisites
- Docker installed and running.
- Permissions to run docker (user in the docker group or execution via sudo).

Project Structure
- run.sh (the script shown)
- Dockerfile (assumed to be in the same directory to build the image)
- files/ (local directory that will be mounted on the container's Desktop)

Important variables in the script
- IMAGE_NAME: Docker image name (default: seqtrace-xfce)
- CONTAINER_NAME: Container name (default: seqtrace-xfce)
- PROJECT_DIR: Project directory (automatically determined)
- FILES_DIR: Local directory ./files mapped to /root/Desktop/files in the container

---
## How to use

1. Make the script executable (if necessary):

 `chmod +x run.sh`

2. Start the container:

`./run.sh start`

What the command does:

- Stops and removes an existing container with the same name (if any).

- Builds the Docker image using the local Dockerfile.

- Runs the container in the background, mapping port 6080 and mounting ./files in /root/Desktop/files.

- Waits 5 seconds and attempts to automatically open the VNC URL in the browser.



3. Stop the container:

`./run.sh stop`

- Stops and removes the container if it exists.

