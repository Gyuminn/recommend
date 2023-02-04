FROM openjdk:11-jre-slim

ARG ARTIFACTORY_FILE
ENV ARTIFACTORY_FILE ${ARTIFACTORY_FILE}
ENV USERNAME docker  
ENV ARTIFACTORY_HOME /home/${USERNAME}

# DON'T change USERNAME
# Add a docker user, make work dir
RUN adduser --disabled-password --gecos "" ${USERNAME} && \
  echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
  mkdir -p ${ARTIFACTORY_HOME} && \
  chown ${USERNAME}:${USERNAME} ${ARTIFACTORY_HOME} && \
  mkdir ./data

WORKDIR ${ARTIFACTORY_HOME}

# Copy your jar to the container
COPY ./target/${ARTIFACTORY_FILE} ${ARTIFACTORY_HOME}
COPY ./bestott.properties ./data/bestott.properties

# Launch the artifactory as docker user
ENTRYPOINT [ "sh", "-c" ]
USER docker
#CMD [ "java -jar ${ARTIFACTORY_FILE} --spring.profiles.active=${PROFILE}" ]
CMD [ "java -jar ./recommend.jar" ]

