# Use the official Julia image as a base
FROM plutojl/pluto:latest

# Set environment variables
ENV HOME=/home/pluto
ENV JULIA_DEPOT_PATH=$HOME/.julia_custom_depot

# Switch to root to make directory changes
USER root

# Create necessary directories and set permissions
RUN mkdir -p $HOME/.julia_custom_depot $HOME/.julia $HOME/.julia_custom_depot/logs && \
    chown -R 1000:1000 $HOME && \
    chmod -R 777 $HOME/.julia_custom_depot $HOME/.julia

# Switch back to non-root user (assuming UID 1000 is the non-root user in the base image)
USER 1000

# Create a new Julia environment in the working directory
RUN julia -e 'using Pkg; Pkg.add("Pluto")'

EXPOSE 8888

# Set the entry point to run Pluto on port 8888
ENTRYPOINT ["julia", "-e", "using Pluto; Pluto.run(\"0.0.0.0\", 8888)"]