FROM cheggwpt/ruby:0.0.2
MAINTAINER jgilley@chegg.com

# remove supervisor since it is not used here
# Make the app directory
# install the fake sqs gem without docs
RUN	apk del supervisor && \
	mkdir -p /var/data/sqs && \
	gem install fake_sqs -v 0.3.1 --no-ri --no-rdoc

# Add the files
# this container has a "patch" for fake_sqs 0.3.1 that flushes the cache for each "msg" for stdio logging
COPY container_confs /

# fake SQS environment vars
ENV SQS_USERNAME convox
ENV SQS_PASSWORD password
ENV SQS_PATH /
ENV SQS_SHOW_LOGS 0

# LINK env vars for convox
ENV LINK_USERNAME convox
ENV LINK_PASSWORD password
ENV LINK_PATH /

# expose the fake sqs port
EXPOSE 4568

# expose the app volume
VOLUME ["/var/data/sqs/"]

# the entry point definition
ENTRYPOINT ["/entrypoint.sh"]

# default command for entrypoint.sh
CMD ["fakesqs"]
