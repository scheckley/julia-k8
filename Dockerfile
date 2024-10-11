# Use the official Julia image as a base
FROM julia:latest

# Set environment variables to handle rootless container
ENV USER=juliauser
ENV HOME=/home/$USER

# Create a non-root user
RUN useradd -ms /bin/bash $USER

# Change ownership of the working directory
WORKDIR /home/$USER

# Change to the non-root user
USER $USER

# Set the shell to bash
SHELL ["/bin/bash", "-c"]

# Optional: You can add any Julia packages or custom scripts here
# For example, to add Julia packages:
# RUN julia -e 'using Pkg; Pkg.add(["Example"])'

# Set the entry point to the Julia REPL (optional)
ENTRYPOINT ["julia"]
