FROM python:3

RUN apt-get update -y && apt-get install zip -y

RUN pip install --upgrade pip
RUN pip install jupyter jupyter_contrib_nbextensions 

# Install jupyter contriobuted extensions (e.g. spellcheck)
RUN jupyter contrib nbextension install --system

# Copy notebooks
COPY . /app

WORKDIR /app
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", \
     "--ip=0.0.0.0", "--allow-root"]


