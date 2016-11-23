FROM cheggwpt/ruby:0.0.2
MAINTAINER jgilley@chegg.com

# remove supervisor since it is not used here
# Make the app directory
# install the fake sqs gem without docs
RUN	apk del supervisor && \
	mkdir -p /var/data/sqs && \
	gem install fake_sqs -v 0.3.1 --no-ri --no-rdoc

# Add the service script
COPY service.sh /service.sh

# this container has a "patch" for fake_sqs 0.3.1 that flushes the cache for each "msg" for stdio logging
COPY container_confs /

# LINK env vars for convox
ENV LINK_USERNAME convox
ENV LINK_PASSWORD password
ENV LINK_PATH /
ENV LINK_SHOW_LOGS /

# expose the fake sqs port
EXPOSE 4568

# expose the app volume
VOLUME ["/var/data/sqs/"]

# default command for entrypoint.sh
CMD ["service"]
