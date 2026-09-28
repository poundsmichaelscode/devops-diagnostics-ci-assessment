FROM bash:5.2-alpine

WORKDIR /app
COPY app/diagnostic.sh /usr/local/bin/diagnostic
RUN chmod +x /usr/local/bin/diagnostic

ENTRYPOINT ["diagnostic"]
CMD ["help"]
