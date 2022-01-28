ARG NODE_VERSION=16
FROM node:${NODE_VERSION}-alpine
RUN apk add --no-cache make pkgconfig gcc g++ python3 libx11-dev libxkbfile-dev libsecret-dev
ARG version=latest
WORKDIR /home/theia
ADD $version.package.json ./package.json
ARG GITHUB_TOKEN
RUN yarn --pure-lockfile --ignore-engines && \
    NODE_OPTIONS="--max_old_space_size=4096" yarn theia build && \
    yarn theia download:plugins && \
    yarn --productioni --ignore-engines && \
    yarn autoclean --init && \
    echo *.ts >> .yarnclean && \
    echo *.ts.map >> .yarnclean && \
    echo *.spec.* >> .yarnclean && \
    yarn autoclean --force && \
    yarn cache clean

FROM node:${NODE_VERSION}-alpine
# See : https://github.com/theia-ide/theia-apps/issues/34

LABEL maintainer="duongxuanhoa@gmail.com"                                                          
                                                                                                   
ENV USER "theia"                                                                                   
ENV USERID "5000"                                                                                  
ENV GROUP "theia"                                                                                  
ENV GROUPID "5000"                                                                                 
ENV SHELL=/bin/bash                                                                                
ENV THEIA_DEFAULT_PLUGINS=local-dir:/home/theia/plugins                                            
ENV USE_LOCAL_GIT true                                                                             
                                                                                                   
RUN addgroup -g $GROUPID $USER \                                                                   
 && adduser -G $USER $GROUP -u $USERID -s /bin/sh -D $USER;                                        
                                                                                                   
RUN chmod g+rw /home && \                                                                          
    mkdir /workspace && \                                                                          
    chown -R $USER:$GROUP /home/$USER && \                                                         
    chown -R $USER:$GROUP /workspace;                                                              
RUN apk add --no-cache git openssh bash curl libsecret
ENV HOME /home/theia                                                                               
WORKDIR /home/theia       
COPY --from=0 --chown=theia:theia /home/theia /home/theia

EXPOSE 3000
ENV SHELL=/bin/bash \
    THEIA_DEFAULT_PLUGINS=local-dir:/home/theia/plugins
ENV USE_LOCAL_GIT true

COPY docker-entrypoint.sh /usr/local/bin/                                                          
RUN chmod +x /usr/local/bin/docker-entrypoint.sh  
