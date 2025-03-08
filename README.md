# Interactive Python Session (isession)

## Overview

This is a simple but powerful tool to interactively explore and analyze data. It
is based on iPython, a more advanced version of the standard Python shell. It
provides a rich set of features for working with data interactively, including
tab completion, multi-line editing, and auto-indentation, as well as the ability
to configure the default editing mode,e.g., Vim- or Emacs-mode. Additionally, it
provides a `startup` script folder, which allows you to define custom startup
scripts to initialize the environment, set up the project database, or import
local libraries as well as public ones. Particularly useful is the ability to
automatically reload modules, which is not possible in the standard Python
shell, so you can develop your application interactively by importing modules
and functions from your project.

### Why use this tool?

This tool can be used to mount your project into its isession container environment
and provide a Python shell which can easily be customized with your specific project
setup (database, libraries, etc.).  All you have to do is editing your
`docker-compose.yml` (or any other docker management file) to mount your project
modules into the container.

### How to use it?

Consider this `docker-compose.yml` file:

```yaml
services:
  isession:
    container_name: isession
    # This image is build from the Dockerfile in this repository. It has uv and
    # iPython (system-wide) installed.
    image: ${DOCKER_REPOSITORY}/isession:1.0.0
    # This command creates a new virtual environment from your project
    # dependencies and makes them available in the iPython shell, so you can
    # import your modules and functions and don't have to worry about installing
    # dependencies
    command: ['uv', 'run', 'ipython']
    volumes:
      # Mount your project dependencies into the container, e.g., the
      # pyproject.toml file in order to use uv as the package manager
      - ./my_project/pyproject.toml:/app/pyproject.toml
      # Mount your project source code into the container, so you can import your
      # modules and functions from the iPython shell 
      - ./my_project/src:/app/my_project
      # Mount the isession data folder into the container, so you can save your
      # session data, e.g., history, configuration, etc.
      - isession_data:/app/.ipython/profile_default
      # Mount the isession startup folder into the container, so you can define
      # custom startup scripts to initialize the environment, set up the project
      - ${PWD}/isession/startup:/app/.ipython/profile_default/startup
      # Mount any other folder you need to access from the iPython shell
      - ${PWD}/processed:/app/processed_data
    environment:
      # Define environment variables, etc. and other stuff you normally do
      - OUTPUT_FOLDER=/app/processed_data
    stdin_open: true
    tty: true

volumes:
  isession_data:
  ```

  If so desired, you could also mount the `ipyton_config.py` file into the
  container (under `.ipython/default_profile/ipython_config.py`) and adjust the
  configuration to fit your needs. The `ipython_config.py` is a modified version
  of the default iPython configuration file. Check out the comments in the file
  for more information.
  
## Design

The `isession` tool is based on the `uv` package manager, which is a simple,
ultra-fast package manager for Python. `uv` requires a `pyproject.toml` file in
the project root directory, which specifies the project dependencies. This means
it will only work out of the box with projects that define their dependencies in
a `pyproject.toml` file (since this is the dependency file which we mount into
our `isession`). Feel free to tweak this tool to your liking, if you think it is
useful. Any feedback is welcome.
