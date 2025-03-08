# Use a Python image with uv pre-installed
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

WORKDIR /app

# Enable bytecode compilation
ENV UV_COMPILE_BYTECODE=1

# Copy from the cache instead of linking since it's a mounted volume
ENV UV_LINK_MODE=copy

# Create the .ipython directory structure and add the ipython_config.py file
COPY ./ipython_config.py /app/.ipython/profile_default/ipython_config.py

# Place executables in the environment at the front of the path
ENV PATH="/app/.venv/bin:$PATH"
ENV IPYTHONDIR=/app/.ipython

# RUN uv init && uv add ipython
RUN uv pip install ipython --system

