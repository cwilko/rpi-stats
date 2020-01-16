FROM arm32v7/alpine
COPY qemu-arm-static /usr/bin

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Installing dependencies
RUN apk add mosquitto-clients

# Run app.sh when the container launches
CMD ["./app.sh"]