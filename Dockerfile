# Use the official Julia image as a base
FROM plutojl/pluto:latest

# Set environment variables to handle rootless container
#ENV USER=pluto
#ENV HOME=/home/$USER

# Set the JULIA_DEPOT_PATH to a directory where the user has write permissions
ENV JULIA_DEPOT_PATH=$HOME/.julia_custom_depot

# Create a non-root user
#:RUN useradd -ms /bin/bash $USER

# Change ownership of the working directory
WORKDIR ${HOME}/$USER
RUN mkdir -p $HOME/.julia_custom_depot && chown -R $USER:$USER $HOME/.julia_custom_depot
RUN mkdir -p $HOME/.julia && chown -R $USER:$USER $HOME/.julia
RUN mkdir -p $HOME/.julia_custom_depot/logs

# Change ownership of the workspace directory to ensure write access
RUN chown -R 1000:1000 $HOME

RUN chmod -R 777 $HOME/.julia_custom_depot
RUN chmod -R 777 $HOME/.julia/
RUN chmod -R 777 $HOME/.julia_custom_depot/logs/

# Switch to non-root user
USER $USER

# Create a new Julia environment in the working directory
RUN julia -e 'import Pkg; Pkg.add("Pluto")'

EXPOSE 8888

# Set the entry point to run Pluto on port 8888
ENTRYPOINT ["julia", "-e", "using Pluto; Pluto.run(\"0.0.0.0\", 8888)"]
