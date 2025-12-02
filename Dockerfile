FROM villanova/villanova-java-base:11.0.3
ARG VERSION
### Required Openshift Labels
LABEL name="Villanova Kubernetes Service" \
      maintainer="dev@villanova.com" \
      vendor="Villanova Spa" \
      version="v${VERSION}" \
      release="7.3" \
      summary="Villanova infrastructure project for Kubernetes APIs" \
      description="Villanova infrastructure project for kubernetes APIs"

COPY target/generated-resources/licenses /licenses
COPY entrypoint.sh /

ENV PORT 8080
ENV CLASSPATH /opt/lib
EXPOSE 8080

# copy pom.xml and wildcards to avoid this command failing if there's no target/lib directory
COPY pom.xml target/lib* /opt/lib/

# NOTE we assume there's only 1 jar in the target dir
# but at least this means we don't have to guess the name
# we could do with a better way to know the name - or to always create an app.jar or something
COPY target/villanova-k8s-service.jar /opt/app.jar
WORKDIR /opt
ENTRYPOINT ["/entrypoint.sh"]
CMD ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:MaxRAMPercentage=90.0", "-XshowSettings:vm", "-jar", "app.jar"]
