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
    chown -R root:root $HOME && \
    chmod -R g+rwX $HOME

# Install sudo for temporary privilege escalation
RUN apt-get update && apt-get install -y sudo

# Add pluto user to sudo group
RUN useradd -m pluto && echo "pluto ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/pluto

# Create a startup script with additional configuration
RUN echo '#!/bin/bash\n\
sudo -E julia --project=$PLUTO_PROJECT -e "\
using Pluto;\
Pluto.run(\
    host=\"0.0.0.0\",\
    port=8888,\
    launch_browser=false,\
    require_secret_for_open_links=false,\
    require_secret_for_access=false,\
    dismiss_update_notification=true,\
    auto_reload_from_file=true,\
    show_file_system=true,\
    disable_writing_notebook_files=false\
)"' > /tmp/pluto/start_pluto.sh && \
    chmod +x /tmp/pluto/start_pluto.sh

EXPOSE 8888

# Switch to pluto user
USER pluto

# Set the entry point to run the startup script
ENTRYPOINT ["/tmp/pluto/start_pluto.sh"]