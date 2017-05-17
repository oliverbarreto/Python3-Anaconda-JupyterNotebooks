# Automating Juyter configuration 

If you have a anaconda and pytohn docker image you can work with juypter notebooks. However, instead of writing a long command everytime we start the docker image, we are going to create a config file to config jupyter and override default options.

First we need to create a config file for jupyter [as the docs say](http://jupyter-notebook.readthedocs.io/en/latest/config.html). We create a `jupyter_notebook_config.py` file, with all the defaults commented out, with the following command line:
```bash
$ jupyter notebook --generate-config
Writing default config to: /root/.jupyter/jupyter_notebook_config.py
```

We move the file to the external volume for editing:
```
mv /root/.jupyter/jupyter_notebook_config.py /tmp/notebooks/jupyter_notebook_config.py
```

And we edit what we want to config and don't type every time we launch the image with:
```
-c "/opt/conda/bin/jupyter notebook --notebook-dir=/tmp/notebooks --ip='*' --port=8888 --no-browser"
```

So we modify the config file:
```
// The directory to use for notebooks and kernels.
c.NotebookApp.notebook_dir = /tmp/notebooks

// Whether to open in a browser after starting. The specific browser used is
/  platform dependent and determined by the python standard library `webbrowser`
/  module, unless it is overridden using the --browser (NotebookApp.browser)
/  configuration option.
c.NotebookApp.open_browser = False

// The port the notebook server will listen on.
c.NotebookApp.port = 8888

// Set the kernel's IP address [default localhost]. If the IP address is
/ something other than localhost, then Consoles on other machines will be able
/  to connect to the Kernel, so be careful!
c.ConnectionFileMixin.ip = '*'
```

We save this file and use it for configuring the new Docker image. For this, we have to put this file `jupyter_notebook_config.py` in our Jupyter folder, which is in our home directory, `~/.jupyter`.

We create a Dockerfile with:
```
# Oliver Barreto Own container with Anaconda and Jupyter Notebooks alrady installed

FROM continuumio/anaconda3
MAINTAINER Oliver Barreto "oliver.barreto.online@gmail.com"
RUN /opt/conda/bin/conda install jupyter -y --quiet
RUN mkdir /tmp/notebooks
COPY ./jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
CMD /opt/conda/bin/jupyter notebook
```

We build the new image
```
$ docker build -t conda-python3-jupyter:latest .
```

And then execute jupyter notebooks by just running:
```
# docker run -t -i -p 8888:8888 -v /Volumes/HDData/Users/Oliver/Dropbox/Developer/Dev/Python/iNotebooks:/tmp/notebooks --rm conda-python3-jupyter /bin/bash -c "/opt/conda/bin/jupyter notebook"
```

this shoudl load the config file and just work by just launching jupyter notebook command... 

...but it doesn't work for me !!! You need to launch it by typing the command with all options, so it makes no sense... so you end up with:

```
docker run -i -t -p 8888:8888 -v /Volumes/HDData/Users/Oliver/Dropbox/Developer/Dev/Python/iNotebooks:/tmp/notebooks --rm conda-python3-jupyter /bin/bash -c "/opt/conda/bin/jupyter notebook --notebook-dir=/tmp/notebooks --ip='*' --port=8888 --no-browser"
```

## Summary
 Build the Dockerfile with:
 docker build -t conda-python3-jupyter:latest .

 Execute jupyter notebooks by just running:
 docker run -t -i -p 8888:8888 -v /Volumes/HDData/Users/Oliver/Dropbox/Developer/Dev/Python/iNotebooks:/tmp/notebooks --rm conda-python3-jupyter /bin/bash -c "/opt/conda/bin/jupyter notebook"

 
 Run it on terminal mode without launching jupyter notebook
 docker run -i -t -p 8888:8888 -v /Volumes/HDData/Users/Oliver/Dropbox/Developer/Dev/Python/iNotebooks:/tmp/notebooks --rm conda3-jupyter /bin/bash

