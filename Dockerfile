# Use the official Julia image as a base
FROM plutojl/pluto:latest

# Set environment variables
ENV HOME=/tmp/pluto
ENV JULIA_DEPOT_PATH=$HOME/.julia_custom_depot
ENV PLUTO_PROJECT=$HOME/.julia_custom_depot/pluto_project
ENV PLUTO_NOTEBOOK_DIR=$HOME/.julia_custom_depot/pluto_notebooks

# Switch to root to make directory changes
USER root

# Create all necessary directories and set permissions
RUN mkdir -p $JULIA_DEPOT_PATH/logs \
             $JULIA_DEPOT_PATH/packages \
             $JULIA_DEPOT_PATH/registries \
             $JULIA_DEPOT_PATH/environments \
             $JULIA_DEPOT_PATH/compiled \
             $JULIA_DEPOT_PATH/scratchspaces \
             $PLUTO_PROJECT \
             $PLUTO_NOTEBOOK_DIR && \
    chmod -R 777 $HOME && \
    chown -R 1000:0 $HOME && \
    chmod -R g+rwX $HOME

# Install debugging tools
RUN apt-get update && apt-get install -y strace

# Switch back to non-root user
USER 1000

# Create a new Julia environment in the working directory
RUN julia -e 'using Pkg; Pkg.add("Pluto")'

# Create a startup script
RUN echo '#!/bin/bash\n\
julia -e "using Pluto; Pluto.run(host=\"0.0.0.0\", port=8888)"' > /tmp/pluto/start_pluto.sh && \
    chmod +x /tmp/pluto/start_pluto.sh

EXPOSE 8888

# Set the entry point to run the startup script with strace for debugging
ENTRYPOINT ["strace", "-f", "-e", "trace=file", "/tmp/pluto/start_pluto.sh"]
