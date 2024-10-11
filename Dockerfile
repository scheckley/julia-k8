# Use the official Julia image as a base
FROM julia:latest

# Set environment variables to handle rootless container
ENV USER=juliauser
ENV HOME=/home/$USER
ENV JULIA_PROJECT=@.

# Create a non-root user
RUN useradd -ms /bin/bash $USER

# Change ownership of the working directory
WORKDIR /home/$USER
RUN mkdir -p /home/$USER/.julia && chown -R $USER:$USER /home/$USER

# Switch to non-root user
USER $USER

# Create a new Julia environment in the working directory
RUN julia -e 'using Pkg; Pkg.activate("."); Pkg.add("Pluto")'

# Set permissions for the .julia directory
RUN chmod -R 755 /home/$USER/.julia

# Expose port 8888 for Pluto
EXPOSE 8888

# Set the entry point to run Pluto on port 8888
ENTRYPOINT ["julia", "-e", "using Pluto; Pluto.run(\"0.0.0.0\", 8888)"]
