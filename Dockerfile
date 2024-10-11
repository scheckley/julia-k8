# Use the official Julia image as a base
FROM julia:latest

# Set environment variables to handle rootless container
ENV USER=juliauser
ENV HOME=/home/$USER

# Create a non-root user
RUN useradd -ms /bin/bash $USER

# Change ownership of the working directory
WORKDIR /home/$USER

# Switch to non-root user
USER $USER

# Install Pluto.jl
RUN julia -e 'using Pkg; Pkg.add("Pluto")'

# Expose port 888 for Pluto
EXPOSE 888

# Set the entry point to run Pluto on port 888
ENTRYPOINT ["julia", "-e", "using Pluto; Pluto.run(\"0.0.0.0\", 888)"]
