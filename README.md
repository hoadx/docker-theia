## Supported tags
- latest (370MB ~ 90MB compressed)

## Theia applications
[Theia](https://github.com/theia-ide/theia) is a platform to develop Cloud & Desktop IDEs with modern web technologies.
This image is based on the latest stable released version of `theiaide/theia` image.

## How to use this image
This script pulls the image and runs Theia IDE on http://localhost:3000 with the current directory as a workspace. The option of `--init` is added to fix the [defunct process problem](https://github.com/theia-ide/theia-apps/issues/195).

    # Linux or macOS
    docker run -it --init -p 3000:3000 -v "$(pwd):/workspace:cached" hoadx/theia
    
    # Windows
    docker run -it --init -p 3000:3000 -v "%cd%:workspace:cached" hoadx/theia


You can pass additional arguments to Theia after the image name, for example to enable debugging:

    # Linux or macOS
    docker run -it --init -p 3000:3000 --expose 9229 -p 9229:9229 -v "$(pwd):/workspace:cached" hoadx/theia --inspect=0.0.0.0:9229
    
    # Windows
    docker run -it --init -p 3000:3000 --expose 9229 -p 9229:9229 -v "%cd%:workspace:cached" hoadx/theia --inspect=0.0.0.0:9229

## Docker Compose
A docker-compose.yml looks like this:

    theia:
      container_name: theia
      image: hoadx/theia
      ports:
        - "3000:3000"
      environment:
        - CHANGE_OWNER=0     # Set the value to 1 to change ownership of workspace folder
        - USERID=5000        # set user id; ${USERID:-id -u}
        - GROUPID=5000       # set group id; ${GROUPID:-id -u}
      volumes:
        - .:/workspace

## Environment Variables
- CHANGE_OWNER
This variable is optional and specifies whether to change the ownership of workspace folder

- USERID
This variable is optional and specifies whether to set user id for workspace folder

- GROUPID
This variable is optional and specifies whether to set group id for workspace folder