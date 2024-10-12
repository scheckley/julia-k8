# Use the official Julia image as a base
FROM julia:latest

# Set environment variables to handle rootless container
ENV USER=juliauser
ENV HOME=/home/$USER

# Set the JULIA_DEPOT_PATH to a directory where the user has write permissions
ENV JULIA_DEPOT_PATH=$HOME/$USER/.julia_custom_depot

# Create a non-root user
RUN useradd -ms /bin/bash $USER

# Change ownership of the working directory
WORKDIR /home/$USER
RUN mkdir -p $HOME/$USER/.julia_custom_depot && chown -R $USER:$USER $HOME/$USER

# Change ownership of the workspace directory to ensure write access
RUN chown -R 1000:1000 $HOME

RUN chmod -R 755 $HOME/$USER/.julia_custom_depot
RUN chmod -R 755 $HOME/$USER/.julia/
RUN chmod -R 755 $HOME/$USER/.julia_custom_depot/logs/

# Switch to non-root user
USER $USER

# Create a new Julia environment in the working directory
RUN julia -e 'import Pkg; Pkg.add("Pluto")'

# Set permissions for the custom Julia depot directory
RUN chmod -R 755 $HOME/$USER/.julia_custom_depot
RUN chmod -R 755 $HOME/$USER/.julia_custom_depot/logs/

# Expose port 8888 for Pluto
EXPOSE 8888

# Set the entry point to run Pluto on port 8888
ENTRYPOINT ["julia", "-e", "using Pluto; Pluto.run(\"0.0.0.0\", 8888)"]
