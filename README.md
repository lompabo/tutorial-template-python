---
title: AI4EU Tutorial Template (Python)
author: Michele Lombardi <michele.lombardi2@unibo.it>
---

# A Template for AI4EU Tutorials #

This is a simple template and how-to guide for preparing tutorials on AI
topics presented via Jupyter notebooks (and published on github), so that they
can be accessed in three different ways:

* As static pages on github
* As interactive notebooks running on a remote machine (via
[Binder](https://mybinder.org/))
* As interactive notebooks running on your local machine (via
[Docker](https://www.docker.com/))

The guide is intended for use in the AI4EU platform, but except for the last
preparation step (publication on the platform) the process is general.

The main tool used to deliver tutorials is [Jupyter](https://jupyter.org/), a
language-agnostic system using web technologies to display text and run code
interactively. In a nutshell, Jupyter will display a web page containing both
text cells (written in [Markdown](https://en.wikipedia.org/wiki/Markdown)) and
code cells. "Running" text cells will display the markdown source as nicely
formatted HTML, while running code cells will execute the code they contain.
While originally developed for Python, Jupyter now supports other languages
via dedicated
["kernels"](https://github.com/jupyter/jupyter/wiki/Jupyter-kernels).

A full overview of Jupyter is outside the scope of this guide, which will
focus instead in how to access and prepare a tutorial, and how to publish it
on the AI4EU platform.

# Accessing a Tutorial #

## Using github as a Viewer ##

The simplest approach for accessing a tutorial is simply to use
[github](https://github.com/), which allows one to visualize markdown files
(such as this `README.md`) and Jupyter notebooks as nicely formatted web
pages. Try inspecting the code of the ["Example notebook.ipynb"
file](https://github.com/lompabo/tutorial-template-python/blob/main/Example%20notebook.ipynb)
to see an example.

This is enough to view the text and code content of a tutorial, but it does
not enable executing the code and checking the results.

## Using Binder ##

[Binder](https://mybinder.org/) is a system that enables running repositories
containing Jupyter notebooks in Docker containers on a remote machine.
Accessing a tutorial in this way is actually very simple, since it involve
just clicking a link such as this one:

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/lompabo/ai4eu-tutorial-python/HEAD)

When you click the link, the Binder system will spawn a Docker container
running a Jupyter server, configure an environment for the tutorial, and allow
you to run it as if on a local machine. This means you can execute code, as
well as displaying the tutorial content. It's an extremely convenient way to
make tutorials accessible, with no setup required on the user part.

Of course _you_ (as the tutorial maker) will need to handle some configuration
files to achieve this results, but we will come to that shortly.

## Local Execution ##

More advanced use cases may benefit from running everything on a local
machine. In an effort to improve portability and to avoid messing up with the
local environment we will rely on [Docker]((https://www.docker.com/)) for
local execution.

Doing this will require to:

* Install Docker, by following the [online instructions](https://docs.docker.com/get-docker/).
* Install Docker Compose, by following the [online
instructions](https://docs.docker.com/compose/install/)
* Clone the repository with the tutorial, in this case via the command:
```sh
git clone https://github.com/lompabo/tutorial-template-python.git
```
* Start the container via Docker Compose, from the main directory of the
tutorial:
```sh
docker-compose up
```

On linux systems, you may need to start the docker service first.

The first execution of this process will be fairly long, since Docker will
need to download a base image for the container (think of a virtual machine
disk) and then some boilerplate configuration steps will need to be performed
(e.g. installing jupyter in the container). Subsequent runs will be much
faster.

The process will end with a message such as this one:
```sh
To access the notebook, open this file in a browser:
    file:///home/lompa/.local/share/jupyter/runtime/nbserver-1-open.html
Or copy and paste this URL:
    http://127.0.0.1:39281/?token=0cd92163797c3b3abe67c2b0aea57939867477d6068708a2
```
Copying one of the two addresses in a file browser file provide access to the Jupyter server running in the spawned container.

Once you are done, pressing CTRL+C on the terminal will close the Docker container.

For more information about how Docker works (such as the difference between
images and containers, or how to get rid of all of them once you are done with
the tutorial), you can check the [Docker
documentation](https://docs.docker.com/).


# Setting Up a Tutorial #

Setting up a tutorial for this three type of execution requires to:

1. Prepare a Dockerfile for the container, plus a docker-compose.yml file
2. Fill the container with content (Jupyter notebooks, datasets, images, etc.)
3. Push everything on github or a similar repository service


## Container Structure and Dockerfile ##

The Docker image (think of it as the "stamp" for the container that will spawn
from that) follows a basic files structure:

* The `data` directory is meant to contain datasets
- Images, fonts, and any media resource used by the notebooks should go in `assets`
- Custom Python modules (e.g. used for lengthy code, plot-making
  functions...) should go in the `util` folder
* The main folder contains also a `Dockerfile` and a file
`docker-compose.yml`, plus all the Jupyter notebooks

This structure is not at all mandatory, but provides a decent starting point
to design your notebooks so that they are not too cluttered.

Most of the container setup is controlled by the Dockerfile. Ensuring
compatibility with Binder requires some care in the Dockefile definition: all
such details (plus some basic comments) are commented in the file included in
this tutorial, which you can use a starting point. More details about the
Dockerfile syntax [in the official
documentation](https://docs.docker.com/engine/reference/builder/), while
information about the special setup needed for Binder to work can be found [in
a dedicated
page](https://mybinder.readthedocs.io/en/latest/tutorials/dockerfile.html on
the Binder) on the Binder documentation web site.


## Docker Compose Configuration ##

The `docker-compose.yml` file contains configuration instructions for docker compose, which simplifies manageing Docker containers. In this case, it enables us to use simple commands to start the tutorial. The file content is:

```yaml
version: '2.0'
services:
  jupyter:
    build: .
    ports:
    - "8888:8888"
    volumes:
    - .:~
```

The last two lines are only needed at development time: they ensure that the
current folder in the host is _mounted as a volume_ on the container, rather
than just copied. This is very useful since it allows changes made to any file
to propagate in both directions (from the host to the container and from the
container to the host). Once you are happy with the results, you may want to
comment them so that a user can make changes to the notebooks without fear to
loose their original content.

Note that relying on Docker Compose is a convenience choice and not at all
mandatory: you may use docker commands directly if you feel confident about
it.

## Adding Content ##

Content is best added by starting a container with `docker-compose up` and
then adding files or making changes in a mixed fashion: notebooks are likely
easier to edit in the container (i.e. via the Jupyter GUI), while images, 
data files, and Python modules can be managed in the host.

# Publishing the Tutorial #

Publishing a tutorial is done in three steps:

1. Uploading the tutorial content on github
2. Registering the repository on
[https://mybinder.org/](https://mybinder.org/)
3. Adding a new "tutorial" content items on the AI4EU platform

For step 1, you can refer to any tutorial on how to use
[git](https://git-scm.com/) if you are not yet familiar with it.

Registering the repository on mybinder.org is a very simple step: just go the
web site, paste the URL of your repository, then copy-paste the link to the
URL where the tutorial will be made available. The web site even allows you to
copy-paste the markdown code for a nicer looking button, if you prefer.

Finally (THIS PART IS STILL WiP), you can access the AI4EU plaform, create a
new tutorial content item, and fill the required fields.


