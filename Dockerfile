# Use the official Julia image as a base
FROM plutojl/pluto:latest

# Set environment variables
ENV HOME=/tmp/pluto
ENV JULIA_DEPOT_PATH=$HOME/.julia_custom_depot
ENV PLUTO_PROJECT=$HOME/.julia_custom_depot/pluto_project
ENV PLUTO_NOTEBOOK_DIR=$HOME/.julia_custom_depot/pluto_notebooks

# Switch to root to make directory changes
USER root

# Create necessary directories and set permissions
RUN mkdir -p $JULIA_DEPOT_PATH $HOME/.julia $PLUTO_PROJECT $PLUTO_NOTEBOOK_DIR && \
    chmod -R 777 $HOME

# Switch back to non-root user
USER 1000

# Create a new Julia environment in the working directory
RUN julia -e 'using Pkg; Pkg.add("Pluto")'

EXPOSE 8888

# Set the entry point to run Pluto on port 8888 with the updated syntax
ENTRYPOINT ["julia", "-e", "using Pluto; Pluto.run(host=\"0.0.0.0\", port=8888)"]