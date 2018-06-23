FROM jenkins/jenkins:2.121.1

USER root
RUN apt-get update \
    && apt-get --no-install-recommends --yes install gosu

# Copy init scripts
COPY init.groovy.d/* /usr/share/jenkins/ref/init.groovy.d/

# Pre-install plugins
COPY --chown=jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Disable setup wizard
RUN echo $JENKINS_VERSION > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
RUN echo $JENKINS_VERSION > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion

COPY entrypoint.sh /
ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]
