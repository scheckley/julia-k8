# Use the official Julia image as a base
FROM julia:latest

# Set environment variables to handle rootless container
ENV USER=juliauser
ENV HOME=/home/$USER

# Create a non-root user
RUN useradd -ms /bin/bash $USER

# Change ownership of the working directory and .julia directory
WORKDIR /home/$USER
RUN mkdir -p /home/$USER/.julia && chown -R $USER:$USER /home/$USER

# Change ownership of the workspace directory to ensure write access
RUN chown -R 1000:1000 $HOME

# Switch to non-root user
USER $USER

# Install Pluto.jl
RUN julia -e 'using Pkg; Pkg.add("Pluto")'

# Set permissions for the .julia directory
RUN chmod -R 755 /home/$USER/.julia

# Expose port 8888 for Pluto
EXPOSE 8888

# Set the entry point to run Pluto on port 888
ENTRYPOINT ["julia", "-e", "using Pluto; Pluto.run(\"0.0.0.0\", 8888)"]
