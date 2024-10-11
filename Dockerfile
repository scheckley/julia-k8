# Use the official Julia image as a base
FROM julia:latest

# Set environment variables to handle rootless container
ENV USER=juliauser
ENV HOME=/home/$USER

# Create a directory for Julia packages and logs
ENV JULIA_DEPOT_PATH=$HOME/.julia_custom_depot

# Create a non-root user
RUN useradd -ms /bin/bash $USER

# Change ownership of the working directory
WORKDIR /home/$USER
RUN mkdir -p /home/$USER/.julia_custom_depot && chown -R $USER:$USER /home/$USER

# Switch to non-root user
USER $USER

# Create a new Julia environment in the working directory
RUN julia -e 'import Pkg; Pkg.add("Pluto")'

# Set permissions for the custom Julia depot directory
RUN chmod -R 755 /home/$USER/.julia_custom_depot

# Expose port 8888 for Pluto
EXPOSE 8888

# Set the entry point to run Pluto on port 8888
ENTRYPOINT ["julia", "-e", "using Pluto; Pluto.run(\"0.0.0.0\", 8888)"]
