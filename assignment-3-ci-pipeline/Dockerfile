FROM bash:5.2-alpine

WORKDIR /app
COPY app/app.sh /usr/local/bin/devops-diagnostic
RUN chmod +x /usr/local/bin/devops-diagnostic

ENTRYPOINT ["devops-diagnostic"]
CMD ["help"]
