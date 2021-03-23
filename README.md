---
title: A Template for AI4EU Tutorials
author: Michele Lombardi <michele.lombardi2@unibo.it>
---

# A Template for AI4EU Tutorials

This is a simple template and how-to guide for preparing tutorials on AI topics distributed as [Jupyter notebooks](https://jupyter.org/) running inside [Docker containers](https://www.docker.com/), hosted on the AI4EU platform.

It is a convenient setup that simplifies the installation of new tools, as all components run in a virtual environment, that can be configured automatically by the tutorial author. The guide assumes basic familiarity with both Jupyter and Docker and covers:

* How to run a tutorial
* How to populate the template with the tutorial content
* How to export the tutorial and publish it on the AI4EU platform


## Running a Tutorial

Running a tutorial requires to:

* Install [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) (the two tools ship together on Windows and OSX)
* Open a terminal in the tutorial main folder (the one containing the `Dockerfile`)
* Executing the command:

```sh
docker-compose up
```

This will:

* Download a base image for the virtualize environment (just the first time)
* Configure the container as specified in the `Dockerfile`
* Run the Jupyter notebook server inside the container

If everything goes well, you should see on the terminal a message similar to:

```sh
Attaching to tutorial-template_jupyter_1
jupyter_1  | [I 12:53:12.467 NotebookApp] Writing notebook server cookie secret to /root/.local/share/jupyter/runtime/notebook_cookie_secret
jupyter_1  | [I 12:53:12.678 NotebookApp] [jupyter_nbextensions_configurator] enabled 0.4.1
jupyter_1  | [I 12:53:12.680 NotebookApp] Serving notebooks from local directory: /app/notebooks
jupyter_1  | [I 12:53:12.680 NotebookApp] Jupyter Notebook 6.2.0 is running at:
jupyter_1  | [I 12:53:12.680 NotebookApp] http://d806a2f6c7af:8888/?token=22aa406c8640afae5480eb35bd4f89409b63f2708d3c47c9
jupyter_1  | [I 12:53:12.680 NotebookApp]  or http://127.0.0.1:8888/?token=22aa406c8640afae5480eb35bd4f89409b63f2708d3c47c9
jupyter_1  | [I 12:53:12.680 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
jupyter_1  | [C 12:53:12.683 NotebookApp] 
jupyter_1  |     
jupyter_1  |     To access the notebook, open this file in a browser:
jupyter_1  |         file:///root/.local/share/jupyter/runtime/nbserver-1-open.html
jupyter_1  |     Or copy and paste one of these URLs:
jupyter_1  |         http://d806a2f6c7af:8888/?token=22aa406c8640afae5480eb35bd4f89409b63f2708d3c47c9
jupyter_1  |      or http://127.0.0.1:8888/?token=22aa406c8640afae5480eb35bd4f89409b63f2708d3c47c9
```

Copying the last link (the one starting with `http://127.0.0.1:8888`) on the address bar of a browser will allow you to access the tutorial.

Once you are done, pressing CTRL+C on the terminal will close the Docker container.

## Setting Up the Template

Setting up the template requires to:

1. Configuring the container
2. Filling the container with content (Jupyter notebooks, datasets, images, etc.)

The container follows a basic files structure:

* The `data` is meant to contain datasets
* The `notebooks` folders should contain the jupyter notebooks
  - Images, fonts, and any media resource used by the notebooks should go in `notebooks/assets`
  - Custom Python modules (e.g. used for lengthy code, plotting functions, or other components that are used often or across notebooks) should go in the `notebooks/util` folder
* The main folder contains also a `Dockerfile` and a file `docker-compose.yml`

Most of the container setup is controlled by the Dockerfile. The basic version provided here installs `pip`, `jupyter`, and the Jupyter contributed extensions.

```
# Base image specification
FROM python:3

# Update the package list (this is a Ubuntu-based machine)
RUN apt-get update -y && apt-get install zip -y

# Install pip
RUN pip install --upgrade pip

# Install a couple of Python packages
RUN pip install jupyter jupyter_contrib_nbextensions 

# Install jupyter contriobuted extensions (e.g. spellcheck)
RUN jupyter contrib nbextension install --system

# Copy raw data
COPY ./data /app/data

# During development, the notebooks folder will be overriden by a volume
COPY ./notebooks /app/notebooks

# Move to the notebook folder
WORKDIR /app/notebooks

# Start the jupyter server in the container
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", \
     "--ip=0.0.0.0", "--allow-root"]
```

For more detail, have a look at the [Dockerfile reference](https://docs.docker.com/engine/reference/builder/).

The `docker-compose.yml` file contains configuration instructions for docker compose, which simplifies manageing Docker containers. In this case, it enables us to use simple commands to start the tutorial. The file content is:

```
version: '2.0'
services:
  jupyter:
    build: .
    ports:
    - "8888:8888"
    volumes:
    - ./notebooks:/app/notebooks
```

Here we are specifying that port 8888 on the host is mapped to port 8888 of the container, where the Jupyter server will be listening.

We are also using a _shared volume_ for the `notebooks` folder. This allows us to make modifications to the content of that folder (and in particular to any custom Python modules) and see that reflected in the container file system, even while that is running. Note that the same is not done for the data folder (which is just copied when the container starts): if you desire the same behavior in this case, too, you need to add a second line in the "volume" section in `docker-compose.yml`.

Once the setup is done, content can be added as you would usually do in a Jupyter notebook. Following the proposed folder structure is not mandatory, but it is encouraged to maximize compatibility.

# Publishing the Tutorial

Publishing a tutorial is done in three steps:

1. Publishing static web pages for each notebook
2. Publishing a compressed archive with the content of the (populated) tutorial
3. Registering a new "Tutorial" node on the AI4EU CMS, which will contain meta-information about the tutorial and pointers to the compressed archive and the static web pages.

Static, self-contained, web pages can be easily obtained from the notebooks via the use of the `nbconvert` tool, and in particular of the command:

```sh
jupyter nbconvert --to html_embed --template basic --HTMLExporter.anchor_link_text='' "the_notebook_file.ipynb"
```

This will export the notebook as an HTML page, including all linked resources, so that no external file are necessary. Note this can be result in a pretty large file if images or plots are used in the container. The main benefit is that copy-pasting the source is enough to publish the whole notebook.

AND HERE THE CLEAR GUIDE STOPS: THE NEXT STEPS ARE STILL IN A PROVISIONAL STATE
