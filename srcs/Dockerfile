FROM debian:13
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install ca-certificates apt-transport-https gnupg wget -y
RUN wget -O - https://apt.corretto.aws/corretto.key | gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" | tee /etc/apt/sources.list.d/corretto.list
RUN apt-get update -y && apt-get install -y java-21-amazon-corretto-jdk libxi6 libxtst6 libxrender1 -y
RUN java -version
COPY tools/entrypoint.sh entrypoint.sh
ENTRYPOINT ["sh", "entrypoint.sh"]
CMD ["./start.sh"]
# CMD [ "sleep", "infinity" ]
